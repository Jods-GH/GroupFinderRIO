#!/usr/bin/env python3
"""Regenerate Data/InstanceIDList.lua from raider.io + wago.tools.

The addon maps WoW LFG *activityIDs* (the table keys) to raider.io *zoneIDs*
(the ``id`` field) plus a difficulty and a short name. Neither source alone
holds that mapping, so this script joins them:

  * wago.tools ``GroupFinderActivity`` gives every LFG activityID together with
    its category (2 = dungeon, 3 = raid), instance ``MapID`` and WoW
    ``DifficultyID``.
  * raider.io static data gives the zoneID (``id``) we ultimately need, keyed by
    ``challenge_mode_id`` for dungeons and by encounter set for raids.
  * wago.tools ``MapChallengeMode`` / ``JournalInstance`` / ``JournalEncounter``
    bridge a ``MapID`` to those raider.io entries.

Only the current + previous expansion are fetched (the group finder never lists
older content); everything else already in the file is treated as legacy and
preserved. Cosmetic fields the maintainer curated -- ``shortName`` and the
``ACTIVITY_ORDER`` values -- are kept for activityIDs that already exist; the
generator only fills them in for brand-new content.

Stdlib only, so the GitHub Action needs no dependencies.
"""

import csv
import io
import json
import re
import sys
import urllib.request
from collections import defaultdict

# --- config ---------------------------------------------------------------

UA = "Mozilla/5.0 (GroupFinderRIO instance-list generator)"
RAIDBOTS_METADATA_URL = "https://www.raidbots.com/static/data/live/metadata.json"
RIO_DUNGEON_URL = "https://raider.io/api/v1/mythic-plus/static-data?expansion_id={eid}"
RIO_RAID_URL = "https://raider.io/api/v1/raiding/static-data?expansion_id={eid}"
WAGO_CSV_URL = "https://wago.tools/db2/{table}/csv"

CAT_DUNGEON = "2"
CAT_RAID = "3"

# WoW DifficultyID -> addon difficulty (1 normal, 2 heroic, 3 mythic, 4 m+)
DUNGEON_DIFF = {"1": 1, "2": 2, "23": 3, "8": 4}
# 233 = "Mythic - Flexible Raiding", used by single-boss raids (Sporefall,
# Tidebound Grotto) that have no regular Mythic (16); treat it as mythic.
RAID_DIFF = {"14": 1, "15": 2, "16": 3, "233": 3}
# addon difficulty -> short-name suffix
DIFF_SUFFIX = {1: "NHC", 2: "HC", 3: "M", 4: "M+"}
# addon difficulty -> word used in ACTIVITY_ORDER comments
DIFF_NAME = {1: "normal", 2: "heroic", 3: "mythic", 4: "mythic+"}

OUTPUT_PATH = "Data/InstanceIDList.lua"

# --- fetch helpers --------------------------------------------------------


def _get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return resp.read()


def get_json(url):
    return json.loads(_get(url).decode("utf-8"))


def get_csv(table):
    text = _get(WAGO_CSV_URL.format(table=table)).decode("utf-8-sig")
    return list(csv.DictReader(io.StringIO(text)))


def derive_expansion_id():
    """raider.io expansion_id for the live build (client major - 1).

    Falls back to probing raider.io for the highest populated expansion_id when
    Raidbots is unreachable (e.g. from a restricted network), so the generator
    still produces the right data.
    """
    try:
        wow_build = get_json(RAIDBOTS_METADATA_URL).get("wowBuild")  # "12.1.0.68914"
        eid = int(str(wow_build).split(".", 1)[0]) - 1
        print(f"Derived expansion_id={eid} from wowBuild {wow_build}")
        return eid
    except Exception as exc:  # noqa: BLE001 - fallback is intentional
        print(f"Raidbots lookup failed ({exc}); probing raider.io instead")
        for eid in range(20, 5, -1):
            try:
                data = get_json(RIO_DUNGEON_URL.format(eid=eid))
            except Exception:  # noqa: BLE001
                continue
            if data.get("dungeons"):
                print(f"Probed expansion_id={eid} (highest populated)")
                return eid
    raise SystemExit("could not determine expansion_id")


# --- slug matching (raids) ------------------------------------------------


def slug(name):
    name = name.lower().replace("'", "").replace("’", "")
    return re.sub(r"[^a-z0-9]+", "-", name).strip("-")


# --- existing-file parsing ------------------------------------------------


def _find_table_body(text, name):
    """Return (start, end) span of the ``{ ... }`` body of ``GFIO.<name>``."""
    m = re.search(r"GFIO\." + re.escape(name) + r"\s*=\s*\{", text)
    if not m:
        raise SystemExit(f"could not find GFIO.{name} in {OUTPUT_PATH}")
    i = m.end()
    depth = 1
    while i < len(text) and depth:
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
        i += 1
    return m.end(), i - 1  # inside the braces, excluding the closing brace


def parse_struct_table(text, name):
    """Parse ``[key] = { id=.., difficulty=.., shortName=".." }`` entries.

    Returns ``{key: {id, id_raw, difficulty, shortName, comment}}`` preserving
    the inline ``-- comment`` next to ``id`` and whether ``id`` was quoted.
    """
    start, end = _find_table_body(text, name)
    body = text[start:end]
    entries = {}
    for m in re.finditer(r"\[(\d+)\]\s*=\s*\{", body):
        key = int(m.group(1))
        i = m.end()
        depth = 1
        while i < len(body) and depth:
            if body[i] == "{":
                depth += 1
            elif body[i] == "}":
                depth -= 1
            i += 1
        inner = body[m.end():i - 1]
        id_m = re.search(r"id\s*=\s*(\"[^\"]*\"|[\w]+)", inner)
        id_raw = id_m.group(1) if id_m else None
        comment_m = re.search(r"id\s*=\s*[^,]*,\s*--\s*(.*)", inner)
        diff_m = re.search(r"difficulty\s*=\s*(\d+)", inner)
        sn_m = re.search(r'shortName\s*=\s*"([^"]*)"', inner)
        entries[key] = {
            "id_raw": id_raw,
            "difficulty": int(diff_m.group(1)) if diff_m else None,
            "shortName": sn_m.group(1) if sn_m else None,
            "comment": comment_m.group(1).strip() if comment_m else None,
        }
    return entries


def parse_order_table(text, name):
    """Parse ``[key] = number`` entries, keeping the inline comment."""
    start, end = _find_table_body(text, name)
    body = text[start:end]
    entries = {}
    for m in re.finditer(r"\[(\d+)\]\s*=\s*(\d+)\s*,?\s*(?:--\s*(.*))?", body):
        entries[int(m.group(1))] = {
            "order": int(m.group(2)),
            "comment": (m.group(3) or "").strip() or None,
        }
    return entries


# --- build auto data ------------------------------------------------------


def abbreviate(name):
    """Derive a short label from an instance name (new entries only)."""
    words = [w for w in re.split(r"[^A-Za-z0-9]+", name) if w]
    stop = {"the", "of", "and"}
    sig = [w for w in words if w.lower() not in stop]
    initials = "".join(w[0] for w in sig).upper()
    if len(initials) >= 2:
        return initials
    base = (sig[0] if sig else name)
    return base[:4].upper()


def build_dungeons(rio_dungeons, gfa, mcm):
    """activityID -> {id, difficulty, name} for every current dungeon row."""
    cm_to_map = {r["ID"]: r["MapID"] for r in mcm}
    gfa_by_map = defaultdict(list)
    for r in gfa:
        if r["GroupFinderCategoryID"] == CAT_DUNGEON:
            gfa_by_map[r["MapID"]].append(r)
    rows = {}
    for d in rio_dungeons:
        mapid = cm_to_map.get(str(d["challenge_mode_id"]))
        if not mapid:
            continue
        for r in gfa_by_map.get(mapid, []):
            diff = DUNGEON_DIFF.get(r["DifficultyID"])
            if not diff:
                continue
            rows[int(r["ID"])] = {
                "id": d["id"],
                "difficulty": diff,
                "name": d["name"],
                "short": d.get("short_name") or abbreviate(d["name"]),
            }
    return rows


def build_raids(rio_raids, gfa, ji, je):
    """activityID -> {id, difficulty, name, rio_start, wing_rank} per raid row."""
    ji_by_map = defaultdict(list)
    for r in ji:
        ji_by_map[r["MapID"]].append(r["ID"])
    enc_by_ji = defaultdict(set)
    for r in je:
        enc_by_ji[r["JournalInstanceID"]].add(slug(r["Name_lang"]))
    ji_name = {r["ID"]: r["Name_lang"] for r in ji}

    rio_by_slug = []  # (set_of_slugs, raid)
    for raid in rio_raids:
        rio_by_slug.append((set(e["slug"] for e in raid["encounters"]), raid))

    def match_raid(ji_id):
        best, best_ov = None, 0
        for slugs, raid in rio_by_slug:
            ov = len(slugs & enc_by_ji.get(ji_id, set()))
            if ov > best_ov:
                best, best_ov = raid, ov
        return best

    rows = {}
    # rank wings within an expansion: order the WoW instances deterministically
    # so combined tiers (one raider.io raid = several wings) get distinct orders.
    wing_seen = {}  # (rio_id) -> {ji_id: rank}
    for r in sorted(gfa, key=lambda x: (int(x["MapID"]), int(x["OrderIndex"]))):
        if r["GroupFinderCategoryID"] != CAT_RAID:
            continue
        diff = RAID_DIFF.get(r["DifficultyID"])
        if not diff:
            continue
        ji_ids = ji_by_map.get(r["MapID"])
        if not ji_ids:
            continue
        ji_id = ji_ids[0]
        raid = match_raid(ji_id)
        if not raid:
            continue
        rows[int(r["ID"])] = {
            "id": raid["id"],
            "difficulty": diff,
            "name": ji_name.get(ji_id, raid["name"]),
            "short": abbreviate(ji_name.get(ji_id, raid["name"])),
            "rio_start": raid.get("starts", {}).get("us", ""),
            "ji_id": ji_id,
            "exp": raid.get("_exp"),  # raider.io expansion the raid was fetched under
        }
    return rows


def compute_activity_order(raid_rows):
    """order = major*1000 + minor*100 + difficulty*10.

    ``major`` = in-game major version = the raid's raider.io ``expansion_id`` + 1.
    ``minor`` = rank of the raid *wing* within that expansion (newest highest),
    ranked by raider.io start date then journal-instance id so the wings of a
    combined tier (one raider.io raid = several WoW instances) stay distinct.
    """
    wings_by_exp = defaultdict(set)
    for r in raid_rows.values():
        wings_by_exp[r["exp"]].add((r["rio_start"], int(r["ji_id"])))
    minor_of = {}
    for exp, wings in wings_by_exp.items():
        for i, wing in enumerate(sorted(wings)):
            minor_of[(exp, wing)] = i
    order = {}
    for key, r in raid_rows.items():
        minor = minor_of[(r["exp"], (r["rio_start"], int(r["ji_id"])))]
        order[key] = (r["exp"] + 1) * 1000 + minor * 100 + r["difficulty"] * 10
    return order


# --- rendering ------------------------------------------------------------


def _fmt_id(raw):
    """Render an id, dropping stale quotes so ids are plain numbers."""
    if raw is None:
        return "nil"
    raw = str(raw)
    if raw.startswith('"') and raw.endswith('"'):
        inner = raw[1:-1]
        return inner if inner.isdigit() else raw
    return raw


def render_struct_entry(key, id_raw, difficulty, short, comment):
    lines = [f"\t[{key}] = {{"]
    c = f" -- {comment}" if comment else ""
    lines.append(f"\t\tid = {_fmt_id(id_raw)},{c}")
    lines.append(f"\t\tdifficulty = {difficulty if difficulty is not None else 'nil'},")
    lines.append(f'\t\tshortName = "{short or ""}"')
    lines.append("\t},")
    return "\n".join(lines)


def render_struct_table(name, auto_rows, existing, diff_suffix=True):
    """Merge auto rows over parsed existing entries and render the table.

    Precedence: ``id``/``difficulty`` come from auto (authoritative); an
    existing non-empty ``shortName`` is kept, otherwise one is derived.
    Entries not in ``auto_rows`` are legacy and preserved as parsed.
    """
    auto_keys = set(auto_rows)
    legacy = [k for k in existing if k not in auto_keys]

    def merged_short(key, row):
        prev = (existing.get(key) or {}).get("shortName")
        if prev:
            return prev
        suffix = f" ({DIFF_SUFFIX[row['difficulty']]})" if diff_suffix else ""
        return f"{row['short']}{suffix}"

    parts = [f"GFIO.{name} = {{", ""]
    parts.append("\t-- BEGIN AUTO-GENERATED (raider.io + wago.tools) --")
    for key in sorted(auto_keys, reverse=True):
        row = auto_rows[key]
        parts.append(
            render_struct_entry(
                key, row["id"], row["difficulty"], merged_short(key, row), row["name"]
            )
        )
    parts.append("\t-- END AUTO-GENERATED --")
    if legacy:
        parts.append("")
        parts.append("\t-- Legacy / manually maintained (older expansions) --")
        for key in sorted(legacy, reverse=True):
            e = existing[key]
            parts.append(
                render_struct_entry(
                    key, e["id_raw"], e["difficulty"], e["shortName"], e["comment"]
                )
            )
    parts.append("}")
    return "\n".join(parts)


def render_order_table(auto_order, existing, raid_names):
    """Render formula-driven auto orders; preserve world-boss/legacy entries.

    Auto orders are fully regenerated from the ``major*1000+minor*100+diff*10``
    formula (rather than reusing existing values) so the whole auto block stays
    internally consistent and collision-free; only keys the generator does not
    manage (world bosses, older expansions) are preserved verbatim.
    """
    auto_keys = set(auto_order)
    manual = [k for k in existing if k not in auto_keys]
    parts = ["GFIO.ACTIVITY_ORDER = {", ""]
    parts.append("\t-- BEGIN AUTO-GENERATED (raider.io + wago.tools) --")
    for key in sorted(auto_keys, key=lambda k: auto_order[k], reverse=True):
        c = raid_names.get(key)
        parts.append(f"\t[{key}] = {auto_order[key]},{f' -- {c}' if c else ''}")
    parts.append("\t-- END AUTO-GENERATED --")
    if manual:
        parts.append("")
        parts.append("\t-- Manually maintained (world bosses / legacy) --")
        for key in sorted(manual, key=lambda k: existing[k]["order"], reverse=True):
            e = existing[key]
            c = f" -- {e['comment']}" if e["comment"] else ""
            parts.append(f"\t[{key}] = {e['order']},{c}")
    parts.append("}")
    return "\n".join(parts)


def main():
    with open(OUTPUT_PATH, encoding="utf-8") as fh:
        text = fh.read()

    header = text[: re.search(r"GFIO\.RAIDS\s*=\s*\{", text).start()]
    footer_m = re.search(r"if GFIO\.DEBUG_MODE then", text)
    footer = text[footer_m.start():] if footer_m else ""

    existing_raids = parse_struct_table(text, "RAIDS")
    existing_dungeons = parse_struct_table(text, "DUNGEONS")
    existing_order = parse_order_table(text, "ACTIVITY_ORDER")

    eid = derive_expansion_id()
    rio_dungeons_by_cm, rio_raids = {}, []
    for e in (eid, eid - 1):
        dd = get_json(RIO_DUNGEON_URL.format(eid=e))
        rr = get_json(RIO_RAID_URL.format(eid=e))
        # Collect every dungeon that appeared in ANY season of the expansion, not
        # just the current-season top-level `dungeons[]`: the group finder still
        # lists past-season dungeons at Heroic/Mythic. Dedupe by challenge_mode_id
        # (current expansion iterated first, so it wins on conflict).
        n_before = len(rio_dungeons_by_cm)
        for season in dd.get("seasons", []):
            for d in season.get("dungeons", []):
                rio_dungeons_by_cm.setdefault(str(d["challenge_mode_id"]), d)
        for raid in rr.get("raids", []):
            raid["_exp"] = e
        rio_raids += rr.get("raids", [])
        print(f"expansion_id={e}: {len(rio_dungeons_by_cm) - n_before} dungeons "
              f"(from seasons), {len(rr.get('raids', []))} raids")
    rio_dungeons = list(rio_dungeons_by_cm.values())

    gfa = get_csv("GroupFinderActivity")
    mcm = get_csv("MapChallengeMode")
    ji = get_csv("JournalInstance")
    je = get_csv("JournalEncounter")

    auto_dungeons = build_dungeons(rio_dungeons, gfa, mcm)
    auto_raids = build_raids(rio_raids, gfa, ji, je)
    auto_order = compute_activity_order(auto_raids)
    raid_names = {
        k: f"{v['name']} {DIFF_NAME.get(v['difficulty'], '')}".strip()
        for k, v in auto_raids.items()
    }

    print(f"auto: {len(auto_dungeons)} dungeon rows, {len(auto_raids)} raid rows")

    raids_lua = render_struct_table(
        "RAIDS", {k: {**v} for k, v in auto_raids.items()}, existing_raids
    )
    dungeons_lua = render_struct_table("DUNGEONS", auto_dungeons, existing_dungeons)
    order_lua = render_order_table(auto_order, existing_order, raid_names)

    out = (
        header.rstrip()
        + "\n\n"
        + raids_lua
        + "\n\n"
        + dungeons_lua
        + "\n\n"
        + order_lua
        + "\n"
        + footer
    )
    with open(OUTPUT_PATH, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(out)
    print(f"wrote {OUTPUT_PATH}")


if __name__ == "__main__":
    sys.exit(main())
