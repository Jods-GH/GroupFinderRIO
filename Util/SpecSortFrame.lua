local appName, GFIO = ...
local AceGUI = LibStub("AceGUI-3.0")

---comment creates a toggle for a spec (a clickable icon)
---@param specID number
---@param info table
---@param frame AceGUIWidget
local function createSpecToggle(specID, info, frame)
    local specToggle = AceGUI:Create("Icon")
    frame:AddChild(specToggle)
    specToggle:SetUserData("order", info.order)
    specToggle:SetImage(info.icon)
    specToggle:SetImageSize(25, 25) 
    specToggle:SetWidth(25)
    specToggle:SetHeight(25)
    if GFIO.db.profile.spec[specID] then
        specToggle.image:SetDesaturated(false)
    else
        specToggle.image:SetDesaturated(true)
    end
    specToggle:SetCallback("OnClick", function() 
        GFIO.db.profile.spec[specID] = not GFIO.db.profile.spec[specID] 
        if GFIO.db.profile.spec[specID] then
            specToggle.image:SetDesaturated(false)
        else
            specToggle.image:SetDesaturated(true)
        end
    end)

end
---comment sorts the spec icons by the order set in the spec list
---@param a AceGUIWidget
---@param b AceGUIWidget
---@return boolean
local sortSpecs = function(a,b) 
    return a:GetUserData("order") < b:GetUserData("order") 
end
---comment creates the main frame for the spec icons
---@return AceGUIWidget
local function createMainFrame()
    GFIO.specSelectFrame = AceGUI:Create("Window")
    GFIO.specSelectFrame:SetHeight(130)
    GFIO.specSelectFrame:SetParent(PVEFrame)
    GFIO.specSelectFrame:SetPoint("TOPLEFT", PVEFrame, "BOTTOMLEFT", 0, -30)
    GFIO.specSelectFrame:SetPoint("TOPRIGHT", PVEFrame, "BOTTOMRIGHT", 0, -30)
    GFIO.specSelectFrame.closebutton:Hide()
    GFIO.specSelectFrame:EnableResize(false)
    GFIO.specSelectFrame:SetFullWidth(true)
    GFIO.specSelectFrame:SetFullHeight(true)
    GFIO.specSelectFrame:SetTitle(GFIO.getLocalisation("enableSpecPriority"))
    GFIO.specSelectFrame:SetLayout("Flow")
    GFIO.specSelectFrame:Hide()
    return GFIO.specSelectFrame
end
---comment creates a InlineGroup for the spec icons
---@return AceGUIWidget
local function createSpecLine()
    local line = AceGUI:Create("InlineGroup")
    line:SetLayout("Flow")
    line.frame:SetFrameLevel(GFIO.specSelectFrame.frame:GetFrameLevel() +1)
    line:SetFullWidth(true)
    line:SetRelativeWidth(1)
    line.titletext:Hide()
    line.titletext = nil
    line:SetParent(GFIO.specSelectFrame)
    return line
end
---comment creates spacers between the spec icons to format them better
---@param start number
---@param finish number
---@param frame AceGUIWidget
local function createSpacers(start, finish, frame)
    for i=start, finish do
        local spacer = AceGUI:Create("Label")
        spacer:SetWidth(25)
        spacer:SetHeight(25)
        spacer:SetUserData("order", i) 
        frame:AddChild(spacer)
    end
end
---comment creates the spec frame or returns it if it already exists
---@return AceGUIWidget
GFIO.createOrShowSpecSelectFrame = function()
    if GFIO.specSelectFrame then
        GFIO.specSelectFrame:Show()
        return GFIO.specSelectFrame
    end
    -- main frame
    createMainFrame()
    -- tank and healer frame
    local tankHeal = createSpecLine()
    tankHeal:SetPoint("TOPLEFT",GFIO.specSelectFrame.frame,"TOPLEFT",0,0)
    tankHeal:SetPoint("BOTTOMLEFT",GFIO.specSelectFrame.frame,"TOPLEFT",0,-35)
    tankHeal:SetPoint("TOPRIGHT",GFIO.specSelectFrame.frame,"TOPRIGHT",0, 0)
    tankHeal:SetPoint("BOTTOMRIGHT",GFIO.specSelectFrame.frame,"TOPRIGHT",0,-35)
    for specId,info in pairs (GFIO.SpecList.tank) do
        createSpecToggle(specId,info, tankHeal)
    end
    createSpacers(#tankHeal.children+1,#tankHeal.children+2, tankHeal)
    for specId,info  in pairs (GFIO.SpecList.healer) do
        createSpecToggle(specId,info,tankHeal)
    end
    table.sort(tankHeal.children, sortSpecs)
    tankHeal:DoLayout()
    -- dps frame
    local dps = createSpecLine()
    dps:SetPoint("TOPLEFT",GFIO.specSelectFrame.frame,"TOPLEFT",0,-35)
    dps:SetPoint("BOTTOMLEFT",GFIO.specSelectFrame.frame,"TOPLEFT",0,-130)
    dps:SetPoint("TOPRIGHT",GFIO.specSelectFrame.frame,"TOPRIGHT",0,-35)
    dps:SetPoint("BOTTOMRIGHT",GFIO.specSelectFrame.frame,"TOPRIGHT",0,-130)
    for specId,info in pairs (GFIO.SpecList.meleedps) do
        createSpecToggle(specId,info, dps)
    end
    createSpacers(#dps.children+1,#dps.children+2, dps)
    for specId,info in pairs (GFIO.SpecList.rangedps) do
        createSpecToggle(specId, info, dps)
    end
    table.sort(dps.children, sortSpecs)
    dps:DoLayout()
 
    LFGListFrame.ApplicationViewer:HookScript("OnShow", function() 
        GFIO.specSelectFrame:Show() 
        GFIO.specSelectFrame:EnableResize(false) 
    end)
    LFGListFrame.ApplicationViewer:HookScript("OnHide", function() 
        GFIO.specSelectFrame:Hide()
    end)
    return GFIO.specSelectFrame
end