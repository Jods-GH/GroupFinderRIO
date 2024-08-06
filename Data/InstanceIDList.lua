local _, GFIO  = ...
--- ActiviTyID to ZoneID
---@class Raid
GFIO.RAIDS = {

	[1189] = {
		id = 14030, -- Vault
		difficulty = 1, -- normal
		shortName = "Vault (NHC)"
	},
	[1190] = {
		id = 14030, -- Vault
		difficulty = 2, -- heroic
		shortName = "Vault (HC)"
	},
	[1191] = {
		id = 14030, -- Vault
		difficulty = 3, -- mythic
		shortName = "Vault (M)"
	},
	[1235] = {
		id = 14663, -- Aberrus
		difficulty = 1, -- normal
		shortName = "Aberrus (NHC)"
	},
	[1236] = {
		id = 14663, -- Aberrus
		difficulty = 2, -- heroic
		shortName = "Aberrus (HC)"
	},
	[1237] = {
		id = 14663, -- Aberrus
		difficulty = 3, -- mythic
		shortName = "Aberrus (M)"
	},
	[1251] = {
		id = 14643, -- Amidrassil
		difficulty = 1, -- normal
		shortName = "Amidrassil (NHC)"
	},
	[1252] = {
		id = 14643, -- Amidrassil
		difficulty = 2, -- heroic
		shortName = "Amidrassil (HC)"
	},
	[1253] = {
		id = 14643, -- Amidrassil
		difficulty = 3, -- mythic
		shortName = "Amidrassil (M)"
	},

}

GFIO.DUNGEONS = {
	--TODO FIX THESE ↓
	[659] = {
		id = "", -- Siege Of Boralus
		difficulty = 4, -- Mythic plus
		shortName = "SOB (M+)"
	},
	[703] = {
		id = "", -- Mists of Tirna scithe
		difficulty = 4, -- Mythic plus
		shortName = "MOTS (M+)"
	},
	[713] = {
		id = "", -- Necrotic Wake
		difficulty = 4, -- Mythic plus
		shortName = "NW (M+)"
	},
	--TODO FIX THESE ↑
	[1157] = {
		id = 14032, -- Academy
		difficulty = 1, -- Normal
		shortName = "AA (NHC)"
	},
	[1158] = {
		id = 14032, -- Academy
		difficulty = 2, -- Heroic
		shortName = "AA (HC)"
	},
	[1159] = {
		id = 14032, -- Academy
		difficulty = 3, -- Mythic 
		shortName = "AA (M)"
	},
	[1160] = {
		id = 14032, -- Academy
		difficulty = 4, -- Mythic plus
		shortName = "AA (M+)"
	},
	[1161] = {
		id = 13991, -- Brackenhide
		difficulty = 1, -- Normal
		shortName = "BH (NHC)"
	},
	[1162] = {
		id = 13991, -- Brackenhide
		difficulty = 2, -- HC
		shortName = "BH (HC)"
	},
	[1163] = {
		id = 13991, -- Brackenhide
		difficulty = 3, -- Mythic 
		shortName = "BH (M)"
	},
	[1164] = {
		id = 13991, -- Brackenhide
		difficulty = 4, -- Mythic plus
		shortName = "BH (M+)"
	},
	[1165] = {
		id = 14082, -- Halls of Infusion
		difficulty = 1, -- Normal
		shortName = "HOI (NHC)"
	},
	[1166] = {
		id = 14082, -- Halls of Infusion
		difficulty = 2, -- Heroic
		shortName = "HOI (HC)"
	},
	[1167] = {
		id = 14082, -- Halls of Infusion
		difficulty = 3, -- Mythic
		shortName = "HOI (M)"
	},
	[1168] = {
		id = 14082, -- Halls of Infusion
		difficulty = 4, -- Mythic plus
		shortName = "HOI (M+)"
	},
	[1169] = {
		id = 14011, -- Neltharus
		difficulty = 1, -- Normal
		shortName = "NELT (NHC)"
	},
	[1170] = {
		id = 14011, -- Neltharus
		difficulty = 2, -- Heroic
		shortName = "NELT (HC)"
	},
	[1171] = {
		id = 14011, -- Neltharus
		difficulty = 3, -- Mythic 
		shortName = "NELT (M)"
	},
	[1172] = {
		id = 14011, -- Neltharus
		difficulty = 4, -- Mythic plus
		shortName = "NELT (M+)"
	},
	[1173] = {
		id = 14062, -- Ruby life pools
		difficulty = 1, -- Normal
		shortName = "RLP (NHC)"
	},
	[1174] = {
		id = 14062, -- Ruby life pools
		difficulty = 2, -- Heroic
		shortName = "RLP (HC)"
	},
	[1175] = {
		id = 14062, -- Ruby life pools
		difficulty = 3, -- Mythic 
		shortName = "RLP (M)"
	},
	[1176] = {
		id = 14062, -- Ruby life pools
		difficulty = 4, -- Mythic plus
		shortName = "RLP (M+)"
	},
	[1177] = {
		id = 13954, -- Azure Vault
		difficulty = 1, -- Normal
		shortName = "AV (NHC)"
	},
	[1178] = {
		id = 13954, -- Azure Vault
		difficulty = 4, -- Heroic
		shortName = "AV (HC)"
	},
	[1179] = {
		id = 13954, -- Azure Vault
		difficulty = 3, -- Mythic 
		shortName = "AV (M)"
	},
	[1180] = {
		id = 13954, -- Azure Vault
		difficulty = 4, -- Mythic plus
		shortName = "AV (M+)"
	},
	[1181] = {
		id = 13968, -- Nokhud
		difficulty = 1, -- Normal
		shortName = "NO (NHC)"
	},
	[1182] = {
		id = 13968, -- Nokhud
		difficulty = 2, -- Heroic
		shortName = "NO (HC"
	},
	[1183] = {
		id = 13968, -- Nokhud
		difficulty = 3, -- Mythic
		shortName = "NO (M)"
	},
	[1184] = {
		id = 13968, -- Nokhud
		difficulty = 4, -- Mythic plus
		shortName = "NO (M+)"
	},
	[1185] = {
		id = 14032, -- Uldaman
		difficulty = 1, -- Normal
		shortName = "ULD (NHC)"
	},
	[1186] = {
		id = 14032, -- Uldaman
		difficulty = 2, -- Heroic
		shortName = "ULD (HC)"
	},
	[1187] = {
		id = 14032, -- Uldaman
		difficulty = 3, -- Mythic
		shortName = "ULD (M)"
	},
	[1188] = {
		id = 14032, -- Uldaman
		difficulty = 4, -- Mythic plus
		shortName = "ULD (M+)"
	},
	--TODO FIX THESE ↓
	[1276] = {
		id = "", -- Darkflame cleft
		difficulty = 2, -- Heroic
		shortName = ""
	},
	[1279] = {
		id = "", -- Ara Kara
		difficulty = 2, -- Heroic
		shortName = ""
	},
	[1284] = {
		id = "", -- Ara Kara
		difficulty = 4, -- Mythic plus
		shortName = ""
	},
	[1287] = {
		id = "", -- Stone Vault
		difficulty = 4, -- Mythic plus
		shortName = ""
	},
	[1290] = {
		id = "", -- Grim Batol
		difficulty = 4, -- Mythic plus
		shortName = ""
	},
	[1291] = {
		id = "", -- The Dawnbreaker
		difficulty = 3, -- Mythic 
		shortName = ""
	},
	[1292] = {
		id = "", -- The StoneVault
		difficulty = 3, -- Mythic 
		shortName = ""
	},
	[1293] = {
		id = "", -- City of Threads
		difficulty = 3, -- Mythic 
		shortName = ""
	},
	[1309] = {
		id = "", -- The Rookery
		difficulty = 3, -- Heroic 
		shortName = ""
	},
	[1508] = {
		id = "", -- Cinderbrew Meadery
		difficulty = 3, -- Heroic 
		shortName = ""
	},
	[1511] = {
		id = "", -- Priory of the Sacred flame
		difficulty = 3, -- Heroic 
		shortName = ""
	},
	--TODO FIX THESE ↑
}

GFIO.ACTIVITY_ORDER = {
	[1253] = 10230, -- Amidrassil mythic
	[1252] = 10220, -- Amidrassil heroic
	[1251] = 10210, -- Amidrassil normal
	[1237] = 10130, -- Aberrus mythic
	[1236] = 10120, -- Aberrus heroic
	[1235] = 10110, -- Aberrus normal
	[1191] = 10030, -- vault mythic
	[1190] = 10020, -- vault heroic
	[1189] = 10010, -- vault normal
	[1146] = 10000, -- Worldboss Dragonflight (order is Majorpatch in front so 10000 for 10.0)
}
if GFIO.DEBUG_MODE then
	setmetatable(GFIO.RAIDS, {
		__index = function(_, key)
			error(string.format("attempted to access invalid raid: %s", tostring(key)), 2);
		end,
	})
	setmetatable(GFIO.ACTIVITY_ORDER, {
		__index = function(_, key)
			error(string.format("attempted to access invalid Activity order: %s", tostring(key)), 2);
		end,
	})
end