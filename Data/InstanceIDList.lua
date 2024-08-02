local _, GFIO  = ...
--- ActiviTyID to ZoneID
---@class Raid
GFIO.RAIDS = {
	[1146] = {}, -- Worldboss dragonflight
	
	[1189] = {
		id = 14030, -- Vault
		difficulty = 1 -- normal
	},
	[1190] = {
		id = 14030, -- Vault
		difficulty = 2 -- heroic
	},
	[1191] = {
		id = 14030, -- Vault
		difficulty = 3 -- mythic
	},
	[1235] = {
		id = 14663, -- Aberrus
		difficulty = 1 -- normal
	},
	[1236] = {
		id = 14663, -- Aberrus
		difficulty = 2 -- heroic
	},
	[1237] = {
		id = 14663, -- Aberrus
		difficulty = 3 -- mythic
	},
	[1251] = {
		id = 14643, -- Amidrassil
		difficulty = 1 -- normal
	},
	[1252] = {
		id = 14643, -- Amidrassil
		difficulty = 2 -- heroic
	},
	[1253] = {
		id = 14643, -- Amidrassil
		difficulty = 3 -- mythic
	},

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