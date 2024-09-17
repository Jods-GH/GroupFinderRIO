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
    specToggle:SetUserData("specID", specID)
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
        C_LFGList.RefreshApplicants()
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

---comment
---@param frame AceGUIWidget
---@param subSpecList table
---@param iconId number
local function createSectionToggle(frame, parentGroup, iconId)
    local specsToggle = AceGUI:Create("Icon")
    frame:AddChild(specsToggle)
    specsToggle:SetUserData("order", 0)
    specsToggle:SetImage(iconId) 
    specsToggle:SetImageSize(35, 35) 
    specsToggle:SetWidth(35)
    specsToggle:SetHeight(35)
    local shouldDesaturate = true
    for key,value in pairs(parentGroup.children) do
        if value and value:GetUserData("specID") then
            local specID = value:GetUserData("specID")
            if GFIO.db.profile.spec[specID] then
                shouldDesaturate = false
                break
            end
        end
    end
    specsToggle.image:SetDesaturated(shouldDesaturate)
    specsToggle:SetCallback("OnClick", function() 
        local isactive = true
        for key,value in pairs(parentGroup.children) do
            if value and value:GetUserData("specID") then
                local specID = value:GetUserData("specID")
                if not GFIO.db.profile.spec[specID] then
                    isactive = false
                    break
                end
            end
        end
        for key,value in pairs(parentGroup.children) do
            if value and value:GetUserData("specID") then
                local specID = value:GetUserData("specID")
                GFIO.db.profile.spec[specID] = not isactive
                value.image:SetDesaturated(isactive)

            end
        end
        C_LFGList.RefreshApplicants()
        specsToggle.image:SetDesaturated(isactive)
    end)
end
--136080
local brList = {
    [66]  = true, -- prot pala
    [104] = true, -- guardian druid
    [250] = true, -- blood dk
    [65]  = true, -- holy pala
    [105] = true, -- resto druid
    [70]  = true, -- ret pala
    [103] = true, -- feral druid
    [251] = true, -- frost dk
    [252] = true, -- unholy dk
    [102] = true, -- balance druid
    [265] = true, -- affliction warlock
    [266] = true, -- demonology warlock
    [267] = true, -- destruction warlock
}
--136012
local htList = {
    [264]  = true, -- restoration shaman
    [1468] = true, -- preservation evoker
    [263]  = true, -- enhancement shaman
    [255]  = true, -- survival hunter
    [62]   = true, -- arcane mage
    [63]   = true, -- fire mage
    [64]   = true, -- frost mage
    [253]  = true, -- beast mastery hunter
    [254]  = true, -- marksmanship hunter
    [262]  = true, -- elemental shaman
    [1467] = true, -- devastation evoker
    [1473] = true, -- augmentation evoker
}
local function createExtraSectionToggles(frame,list,iconId, tank, heal, meleeDps, rangeDps)
    local specsToggle = AceGUI:Create("Icon")
    frame:AddChild(specsToggle)
    specsToggle:SetUserData("order", 0)
    specsToggle:SetImage(iconId) 
    specsToggle:SetImageSize(35, 35) 
    specsToggle:SetWidth(35)
    specsToggle:SetHeight(35)
    local shouldDesaturate = true
    for specID in pairs(list) do
        if GFIO.db.profile.spec[specID] then
            shouldDesaturate = false
            break
        end
    end
    specsToggle.image:SetDesaturated(shouldDesaturate)
    specsToggle:SetCallback("OnClick", function() 
        local isactive = true
        for specID in pairs(list) do
            if not GFIO.db.profile.spec[specID] then
                isactive = false
                break
            end
        end
        -- we are lazy and this doesn't run very often so we just iterate through all the frames. We could make an extra list but this is not worth.
        for key,value in pairs(tank.children) do
            if value and value:GetUserData("specID") then
                local specID = value:GetUserData("specID")
                if specID and list[specID] then
                    GFIO.db.profile.spec[specID] = not isactive
                    value.image:SetDesaturated(isactive)
                end
            end
        end
        for key,value in pairs(heal.children) do
            if value and value:GetUserData("specID") then
                local specID = value:GetUserData("specID")
                if specID and list[specID] then
                    GFIO.db.profile.spec[specID] = not isactive
                    value.image:SetDesaturated(isactive)
                end
            end
        end
        for key,value in pairs(meleeDps.children) do
            if value and value:GetUserData("specID") then
                local specID = value:GetUserData("specID")
                if specID and list[specID] then
                    GFIO.db.profile.spec[specID] = not isactive
                    value.image:SetDesaturated(isactive)
                end
            end
        end
        for key,value in pairs(rangeDps.children) do
            if value and value:GetUserData("specID") then
                local specID = value:GetUserData("specID")
                if specID and list[specID] then
                    GFIO.db.profile.spec[specID] = not isactive
                    value.image:SetDesaturated(isactive)
                end
            end
        end
        
        C_LFGList.RefreshApplicants()
        specsToggle.image:SetDesaturated(isactive)
    end)
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
 
    --create section toggles
    local sectionToggles = createSpecLine()
    createSectionToggle(sectionToggles, tank, 135893)
    createSectionToggle(sectionToggles, heal, 135769)
    createExtraSectionToggles(sectionToggles, brList, 136080 , tank, heal, meleeDps, rangeDps) -- battle ress
    createExtraSectionToggles(sectionToggles, htList, 136012, tank, heal, meleeDps, rangeDps) -- blood lust
    createSectionToggle(sectionToggles, meleeDps, 132325)
    createSectionToggle(sectionToggles, rangeDps, 135468)

    sectionToggles:SetPoint("CENTER",GFIO.specSelectFrame,"CENTER",15, 15)

    LFGListFrame.ApplicationViewer:HookScript("OnShow", function() 
        GFIO.specSelectFrame:Show() 
    end)
    LFGListFrame.ApplicationViewer:HookScript("OnHide", function() 
        GFIO.specSelectFrame:Hide()
    end)
    return GFIO.specSelectFrame
end