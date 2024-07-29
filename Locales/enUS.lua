local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local L = AceLocale:NewLocale(appName, "enUS", true)

if L then
    L["AccessOptionsMessage"] = "Access the options via /gfio"
    L["useMainScore"] = "Use Main Score"
    L["useMainScoreDescription"] = "Use the Main Score instead of the current Score for display and sort"
    L["sortAscending"] = "Sort Ascending"
    L["sortAscendingDescription"] = "Sort the list in Ascending order instead of descending"
    L["enableSpecPriority"] = "Enable Spec Priority"
    L["addonOptions"] = "Addon Options"
    L["applicantView"] = "Applicant View"
    L["groupView"] = "Group View"
    L["showNote"] = "Show Note"
    L["showNoteDescription"] = "Show an icon if an Applicant has added a Note"
    L["showKeyLevel"] = "Show Key Level"
    L["showKeyLevelDescription"] = "Show the highest completed Key Level of the Applicant for the current Dungeon"
    L["sortApplicants"] = "Sort Applicants"
    L["sortApplicantsDescription"] = "Sort the Applicants - rule is Spec Priority > (Main) Score > Item Level"
    L["addScoreToGroup"] = "Add Score to Group"
    L["addScoreToGroupDescription"] = "Add the Score of the GroupLeader to the Group View"
    L["sortGroupsByScore"] = "Sort Groups by Score"
    L["sortGroupsByScoreDescription"] = "Sort the Groups by the Score of the GroupLeader"
    L["groupNameBeforeScore"] = "Group Name before Score"
    L["groupNameBeforeScoreDescription"] = "Show the Group Name before the Score of the GroupLeader instead of after"
    L["disableSpecSelector"] = "Disable Spec Selector"
    L["disableSpecSelectorDescription"] = "Disable the Spec Selector in the Application view which can be used to prioritise specs in searching"
    L["showLanguage"] = "Show Language"
    L["showLanguageDescription"] = "Show the Language of Applicants and the GroupLeader"
    L["showCurrentScoreInGroup"] = "Show Current Score in Group"
    L["showCurrentScoreInGroupDescription"] = "Show the current Score of the GroupLeader in the Group View"
    
    GFIO.localisation = L
end