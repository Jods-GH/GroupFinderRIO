local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local L = AceLocale:NewLocale(appName, "ruRU")

if L then


-- LocalisationData[""] =
--@localization(locale="ruRU", format="lua_additive_table", handle-subnamespaces="concat")@


GFIO.localisation = L
end