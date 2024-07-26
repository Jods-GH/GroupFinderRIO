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
    specToggle:SetImageSize(35, 35) 
    specToggle:SetWidth(35)
    specToggle:SetHeight(35)
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
---@return table|frame
local function createMainFrame()
    local frame = CreateFrame("Frame", "GFIO_SpecSelectFrame", PVEFrame, "PortraitFrameTemplate")
    frame:SetHeight(200)
    frame:SetMovable(true)
    frame.TitleContainer:SetScript("OnMouseDown", function(self, button) frame:StartMoving() end)
    frame.TitleContainer:SetScript("OnMouseUp", function(self, button) frame:StopMovingOrSizing() end)
    frame:SetParent(PVEFrame)
    frame:SetPoint("TOPLEFT", PVEFrame, "BOTTOMLEFT", 0, -50)
    frame:SetPoint("TOPRIGHT", PVEFrame, "BOTTOMRIGHT", 0, -50)
    frame.CloseButton:Hide()
    frame:SetTitle(GFIO.getLocalisation("enableSpecPriority"))
    local color = CreateColorFromHexString("ff1f1e21") -- PANEL_BACKGROUND_COLOR
    local r, g, b = color:GetRGB()
    frame.Bg:SetColorTexture(r, g, b, 0.8)
    frame.Bg.colorTexture = {r, g, b, 0.8}
    frame:SetFrameStrata("DIALOG")
    --frame:SetPortraitShown(false)
    frame:SetPortraitTextureRaw("Interface\\AddOns\\GroupFinderRio\\Files\\GroupFinderRio.tga")
    --frame:SetBackdrop(PaneBackdrop)
    if not LFGListFrame.ApplicationViewer:IsShown() then
        frame:Hide()
    end
    return frame
end
---comment creates a InlineGroup for the spec icons
---@return AceGUIWidget
local function createSpecLine()
    local line = AceGUI:Create("InlineGroup")
    line:SetLayout("Flow")
    line:SetParent(GFIO.specSelectFrame)
    line.frame:SetParent(GFIO.specSelectFrame)
    line.frame:SetFrameStrata("DIALOG")
    line.frame:SetFrameLevel(GFIO.specSelectFrame:GetFrameLevel() + 1)
    line:SetFullWidth(true)
    line:SetRelativeWidth(1)
    line.titletext:Hide()
    line.titletext = nil
    line.frame:GetChildren():ClearBackdrop() -- get backdrop and border outta here
    line:SetWidth(GFIO.specSelectFrame:GetWidth()/2)
    line:SetHeight(GFIO.specSelectFrame:GetHeight()/2)
    return line
end
---comment creates the spec frame or returns it if it already exists
---@return AceGUIWidget
GFIO.createOrShowSpecSelectFrame = function()
    if GFIO.db.profile.disableSpecSelector then
        if GFIO.specSelectFrame then
            GFIO.specSelectFrame:Hide()
        end
        return nil
    end
    if GFIO.specSelectFrame then
        GFIO.specSelectFrame:Show()
        return GFIO.specSelectFrame
    end
    -- main frame
    GFIO.specSelectFrame = createMainFrame()
    -- tank and healer frame
    local tank = createSpecLine()
    tank:SetPoint("TOPLEFT",GFIO.specSelectFrame,"TOPLEFT",35,0)
    tank:SetPoint("TOPRIGHT",GFIO.specSelectFrame,"TOP",0, 0)
    tank:SetPoint("BOTTOMLEFT",GFIO.specSelectFrame,"LEFT",35,0)
    tank:SetPoint("BOTTOMRIGHT",GFIO.specSelectFrame,"CENTER",0, 0)
    for specId,info in pairs (GFIO.SpecList.tank) do
        createSpecToggle(specId,info, tank)
    end
    table.sort(tank.children, sortSpecs)
    tank:DoLayout()

--[[ debug
    local debugIcon = CreateFrame("Frame",nil,GFIO.specSelectFrame)
    debugIcon.tex = debugIcon:CreateTexture()
    debugIcon.tex:SetAllPoints(debugIcon)
    debugIcon.tex:SetTexture("134400")
    debugIcon:SetWidth(20)
    debugIcon:SetHeight(20)
    debugIcon:SetParent(GFIO.specSelectFrame)
    debugIcon:SetPoint("CENTER",GFIO.specSelectFrame,"CENTER",0,0)
    DevTool:AddData(tank, "tank")
]]--debug 
    local heal = createSpecLine()
    heal:SetPoint("TOPLEFT",GFIO.specSelectFrame,"TOP",0,0)
    heal:SetPoint("TOPRIGHT",GFIO.specSelectFrame,"TOPRIGHT",0, 0)
    heal:SetPoint("BOTTOMLEFT",GFIO.specSelectFrame,"CENTER",0,0)
    heal:SetPoint("BOTTOMRIGHT",GFIO.specSelectFrame,"RIGHT",0, 0)
    for specId,info  in pairs (GFIO.SpecList.healer) do
        createSpecToggle(specId,info,heal)
    end
    table.sort(heal.children, sortSpecs)
    heal:DoLayout()
    -- dps frame

    local meleeDps = createSpecLine()
    --meleeDps:SetPoint("TOPLEFT",GFIO.specSelectFrame,"LEFT",0,0)
    -- meleeDps:SetPoint("TOPRIGHT",GFIO.specSelectFrame,"CENTER",0,0)
    meleeDps:SetPoint("BOTTOMLEFT",GFIO.specSelectFrame,"BOTTOMLEFT",0,0)
    meleeDps:SetPoint("BOTTOMRIGHT",GFIO.specSelectFrame,"BOTTOM",0,0)
    for specId,info in pairs(GFIO.SpecList.meleedps) do
        createSpecToggle(specId, info, meleeDps)
    end
    table.sort(meleeDps.children, sortSpecs)
    meleeDps:DoLayout()
    
    local rangeDps = createSpecLine()
    --rangeDps:SetPoint("TOPLEFT",GFIO.specSelectFrame,"CENTER",0,0)
    --rangeDps:SetPoint("TOPRIGHT",GFIO.specSelectFrame,"RIGHT",0,0)
    rangeDps:SetPoint("BOTTOMLEFT",GFIO.specSelectFrame,"BOTTOM",0,0)
    rangeDps:SetPoint("BOTTOMRIGHT",GFIO.specSelectFrame,"BOTTOMRIGHT",0,0)

    for specId,info in pairs(GFIO.SpecList.rangedps) do
        createSpecToggle(specId, info, rangeDps)
    end
    table.sort(rangeDps.children, sortSpecs)
    rangeDps:DoLayout()
 
    LFGListFrame.ApplicationViewer:HookScript("OnShow", function() 
        GFIO.specSelectFrame:Show() 
    end)
    LFGListFrame.ApplicationViewer:HookScript("OnHide", function() 
        GFIO.specSelectFrame:Hide()
    end)
    return GFIO.specSelectFrame
end