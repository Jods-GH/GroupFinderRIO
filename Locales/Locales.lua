local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local currentLocale = LibStub ('AceLocale-3.0'):GetLocale (appName, true)---@type MyAddonLocale
GFIO.getLocalisation = function(Object)
      return currentLocale[Object]
end
