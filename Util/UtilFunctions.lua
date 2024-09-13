local appName, GFIO = ...
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
GFIO.Util = GFIO.Util  or {}
GFIO.Util.Functions = GFIO.Util.Functions  or {}
---comment helper to open the AceConfig options frame
GFIO.CreateOptionsFrame = function() 
    AceConfigDialog:Open(appName)
end
---comment helper to print debug messages
---@param msg string
GFIO.DebugPrint = function(msg)
    if GFIO.db and GFIO.db.profile.DebugMode == true then
        GFIO.self:Print(msg)
    end
end
---comment helper to dump tables to the
---@param table any
GFIO.DebugDump =  function(table)
    if GFIO.db and GFIO.db.profile.DebugMode == true then
        DevTools_Dump(table)
    end
end
---comment helper to sort depending on if sortAscending option is toggled
---@param a any
---@param b any
---@return boolean
GFIO.sortFunc = function(a,b)
    if not a and not b then
        return true
    elseif a and not b then
        return true
    elseif b and not a then
        return false
    end
    if GFIO.db.profile.sortAscending then
        return a < b
    else
        return a > b
    end
end



