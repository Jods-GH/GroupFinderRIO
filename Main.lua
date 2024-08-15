local appName, GFIO = ...
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
---@class MyAddon : AceAddon-3.0, AceConsole-3.0, AceConfig-3.0, AceGUI-3.0, AceConfigDialog-3.0
local GroupFinderRIO = LibStub("AceAddon-3.0"):NewAddon("GroupFinderRIO", "AceConsole-3.0", "AceEvent-3.0")


function GroupFinderRIO:OnInitialize()
	-- Called when the addon is loaded
    self:Print(GFIO.getLocalisation("AccessOptionsMessage"))
    self:RegisterEvent("LFG_LIST_APPLICANT_UPDATED")
    GFIO.self = self
    GFIO.db = LibStub("AceDB-3.0"):New("GroupFinderRIO",GFIO.OptionDefaults, true) -- Generates Saved Variables with default Values (if they don't already exist)

    local OptionTable = {
        type = "group",
        args = {
            profile = AceDBOptions:GetOptionsTable(GFIO.db),
            rest = GFIO.options
    }}
    AceConfig:RegisterOptionsTable(appName,OptionTable) -- 
    AceConfigDialog:AddToBlizOptions(appName, appName)
    self:RegisterChatCommand("gfio", "SlashCommand")
	self:RegisterChatCommand("GFIO", "SlashCommand")
    if not C_AddOns.IsAddOnLoaded("PremadeGroupsFilter") then
        GFIO.hookFunc() -- hooking the LFGListSearchEntry_OnClick function if enabled and premades group filter is disabled
    elseif GFIO.db.profile.oneClickSignup then
        error(GFIO.getLocalisation("OneClickSignupNotAvailable"))
    end
end


function GroupFinderRIO:OnEnable()
	GFIO.createOrShowSpecSelectFrame()
    --Debug
    -- DevTool:AddData(RaiderIO.GetProfile("Lemikedh-ragnaros",1),"RioProfile")
end

function GroupFinderRIO:OnDisable()
	-- Called when the addon is disabled
end

function GroupFinderRIO_AddonCompartmentFunction()
    GroupFinderRIO:SlashCommand("AddonCompartmentFrame")
end

function GroupFinderRIO:SlashCommand(msg) -- called when slash command is used
    if msg == "version" then
        print(GFIO.AddonVersion)
    elseif msg == "classFrame" then
        GFIO.createOrShowSpecSelectFrame()
    else
        GFIO.CreateOptionsFrame() 
    end
end
local APPLICATION_CANCELED = "cancelled"
local APPLICATION_TIMEDOUT = "timedout"
local APPLICATION_INVITED = "inviteaccepted"
local APPLICATION_INVITE_DECLINED = "invitedeclined"
function GroupFinderRIO:LFG_LIST_APPLICANT_UPDATED(event, applicantID)
    if event == "LFG_LIST_APPLICANT_UPDATED" then
        local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
        if not applicantInfo or applicantInfo.applicationStatus == APPLICATION_CANCELED 
            or applicantInfo.applicationStatus == APPLICATION_TIMEDOUT or applicantInfo.applicationStatus == APPLICATION_INVITED 
            or applicantInfo.applicationStatus == APPLICATION_INVITE_DECLINED then
            C_LFGList.RefreshApplicants()
        end
	end
end
