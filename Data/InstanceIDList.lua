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
	[1505] = {
		id = 14980, -- Nerub-ar Palace
		difficulty = 1, -- normal
		shortName = "Nerub-ar (NHC)"
	},
	[1506] = {
		id = 14980, -- Nerub-ar Palace
		difficulty = 2, -- heroic
		shortName = "Nerub-ar (HC)"
	},
	[1507] = {
		id = 14980, -- Nerub-ar Palace
		difficulty = 3, -- mythic
		shortName = "Nerub-ar (M)"
	},

}

GFIO.DUNGEONS = {
	--TODO FIX THESE ↓
	[143] = {
		id = 4950, -- Grim Batol
		difficulty = 2, -- Heroic
		shortName = "GB (HC)"
	},
	[534] = {
		id = 9354, -- Siege Of Boralus
		difficulty = 4, -- Mythic plus
		shortName = "SOB (M+)"
	},
	[535] = {
		id = 9354, -- Siege Of Boralus
		difficulty = 2, -- Heroic
		shortName = "SOB (HC)"
	},
	[658] = {
		id = 9354, -- Siege Of Boralus
		difficulty = 3, -- Mythic
		shortName = "SOB (M)"
	},
	[659] = {
		id = 9354, -- Siege Of Boralus
		difficulty = 4, -- Mythic plus
		shortName = "SOB (M+)"
	},
	[702] = {
		id = 13334, -- Mists of Tirna scithe
		difficulty = 4, -- Mythic plus
		shortName = "MOTS (M)"
	},
	[703] = {
		id = 13334, -- Mists of Tirna scithe
		difficulty = 4, -- Mythic plus
		shortName = "MOTS (M+)"
	},
	[713] = {
		id = 12916, -- Necrotic Wake
		difficulty = 4, -- Mythic plus
		shortName = "NW (M+)"
	},
	[714] = {
		id = 12916, -- Necrotic Wake
		difficulty = 3, -- Mythic
		shortName = "NW (M)"
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
		shortName = "DFC (HC)"
	},
	[1278] = {
		id = 15093, -- Ara Kara
		difficulty = 2, -- Heroic
		shortName = "ARAK (NHC)"
	},
	[1279] = {
		id = 15093, -- Ara Kara
		difficulty = 2, -- Heroic
		shortName = "ARAK (HC)"
	},
	[1280] = {
		id = 15093, -- Ara Kara
		difficulty = 3, -- Mythic
		shortName = "ARAK (M)"
	},
	[1284] = {
		id = 15093, -- Ara Kara
		difficulty = 4, -- Mythic plus
		shortName = "ARAK (M+)"
	},
	[1285] = {
		id = 14971, -- The Dawnbreaker
		difficulty = 4, -- Mythic + 
		shortName = "DAWN (M+)"
	},
	[1287] = {
		id = 14883, -- Stone Vault
		difficulty = 4, -- Mythic plus
		shortName = "SV (M+)"
	},
	[1288] = {
		id = 14979, -- City of Threads
		difficulty = 4, -- Mythic plus 
		shortName = "COT (M+)"
	},
	[1290] = {
		id = 4950, -- Grim Batol
		difficulty = 4, -- Mythic plus
		shortName = "GB (M+)"
	},
	[1291] = {
		id = 14971, -- The Dawnbreaker
		difficulty = 3, -- Mythic 
		shortName = "DAWN (M)"
	},
	[1292] = {
		id = 14883, -- The StoneVault
		difficulty = 3, -- Mythic 
		shortName = "SV (M)"
	},
	[1293] = {
		id = 14979, -- City of Threads
		difficulty = 3, -- Mythic 
		shortName = "COT (M)"
	},
	[1294] = {
		id = 4950, -- Grim Batol
		difficulty = 3, -- Mythic 
		shortName = "GB (M)"
	},
	[1308] = {
		id = "", -- The Rookery
		difficulty = 2, -- Heroic 
		shortName = "TR (NHC)"
	},
	[1309] = {
		id = "", -- The Rookery
		difficulty = 2, -- Heroic 
		shortName = "TR (HC)"
	},
	[1508] = {
		id = "", -- Cinderbrew Meadery
		difficulty = 2, -- Heroic 
		shortName = "CM (HC)"
	},
	[1511] = {
		id = "", -- Priory of the Sacred flame
		difficulty = 2, -- Heroic 
		shortName = "POSF (HC)"
	},
	[1519] = {
		id = 14971, -- Dawnbreaker
		difficulty = 2, -- Heroic 
		shortName = "DAWN (HC)"
	},
	[1521] = {
		id = 14883, -- Stonevault
		difficulty = 2, -- Heroic 
		shortName = "SV (HC)"
	},
	--TODO FIX THESE ↑
}

GFIO.ACTIVITY_ORDER = {
	[1507] = 11030, -- Nerubian palace mythic
	[1506] = 11020, -- Nerubian palace heroic
	[1505] = 11010, -- Nerubian palace normal
	[1289] = 11000, -- Worldboss TheWarWithin (order is Majorpatch in front so 11000 for 11.0)
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