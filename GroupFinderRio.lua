local function getScoreForRioProfile(profile)
    if (profile.mythicKeystoneProfile.mainCurrentScore and profile.mythicKeystoneProfile.mainCurrentScore>0) and profile.mythicKeystoneProfile.mainCurrentScore> profile.mythicKeystoneProfile.currentScore then
     return profile.mythicKeystoneProfile.mainCurrentScore
    end   
    return profile.mythicKeystoneProfile.currentScore
end

local function getScoreForLeader(searchResult)
    local leaderName = searchResult.leaderName
    local leaderFullName = leaderName:find("-")~=nil and leaderName or leaderName.."-"..GetNormalizedRealmName()
    local faction = searchResult.leaderFactionGroup
    local score = 0
    if RaiderIO.GetProfile(leaderFullName,faction) then
        local profile = RaiderIO.GetProfile(leaderFullName,faction)
        score = getScoreForRioProfile(profile) or 0
    else
        score = searchResult.leaderOverallDungeonScore or 0 
    end
    return score
end

local function colorScore(score)
    local r,g,b,a = RaiderIO.GetScoreColor(score)
    local color = CreateColor(r,g,b,a)
    local colorHexString = color:GenerateHexColor()
    local coloredScore = WrapTextInColorCode(score, colorHexString)
    return coloredScore
end


local function updateLfgListEntry(entry, ...)
    local searchResultID = entry.GetData().resultID
    local searchResult = C_LFGList.GetSearchResultInfo(searchResultID)
    if (not LFGListFrame.SearchPanel:IsShown() or searchResult.categoryID ~= DUNGEON_CATEGORY_ID or not searchResult.leaderName) then
        return
    end
    local score = getScoreForLeader(searchResult)
    entry.Name:SetText(colorScore(score) .. "   -    ".. entry.Name:GetText())
end
local function compareSearchEntries(a,b)
    return getScoreForLeader(C_LFGList.GetSearchResultInfo(a)) > getScoreForLeader(C_LFGList.GetSearchResultInfo(b))
end
local DUNGEON_CATEGORY_ID = 2
local function sortSearchResults(results)
    if (not LFGListFrame.SearchPanel:IsShown()) or results.categoryID ~= DUNGEON_CATEGORY_ID then
        return
    end
    table.sort(results.results , compareSearchEntries)
end

local function getScoreForApplicant(applicantID, numMember)
    local name, _, _, _, itemLevel, _, _, _, _, _, _, dungeonScore, _ = C_LFGList.GetApplicantMemberInfo(applicantID, numMember)
    local score = 0
    itemLevel = itemLevel or 0
    if RaiderIO.GetProfile(name,1) then
        local profile = RaiderIO.GetProfile(name,1)
        score = getScoreForRioProfile(profile) or 0
    elseif RaiderIO.GetProfile(name,2) then
        local profile = RaiderIO.GetProfile(name,2)
        score = getScoreForRioProfile(profile) or 0
    else
        score = dungeonScore or 0 
    end
    return score, itemLevel
end

local function getScoreForApplication(applicationID)
    local applicantInfo = C_LFGList.GetApplicantInfo(applicationID)
    local score = 0
    local ilvl = 0
    for i= 0,applicantInfo.numMembers do 
        local applicantScore, applicantIlvl = getScoreForApplicant(applicationID,i)
        score = score + applicantScore
        ilvl = ilvl + applicantIlvl
    end 
    score = score/applicantInfo.numMembers
    return score, ilvl
end

local function compareApplicants(a,b)
    local scoreA,ilvlA= getScoreForApplication(a)
    local scoreB,ilvlB= getScoreForApplication(b)
    if scoreA == scoreB then
        return ilvlA > ilvlB
    end
    return scoreA > scoreB 
end
local function sortApplications(applicants)
    if (not LFGListFrame.ApplicationViewer:IsShown()) then -- need to add checking for in dungeon queue
        return
    end
    table.sort(applicants, compareApplicants)
end

local function updateApplicationListEntry(member, appID, memberIdx)
    local name = member.Name:GetText()
    local score, ilvl = getScoreForApplicant(appID, memberIdx)
    member.Name:SetText(colorScore(score).." - "..name)
end


local frame = CreateFrame("Frame")
hooksecurefunc("LFGListSearchEntry_Update", updateLfgListEntry);
hooksecurefunc("LFGListUtil_SortSearchResults",sortSearchResults);
hooksecurefunc("LFGListUtil_SortApplicants", sortApplications);
hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", updateApplicationListEntry);

local APPLICATION_CANCELED = "cancelled"
local APPLICATION_TIMEDOUT = "timedout"
frame:RegisterEvent("LFG_LIST_APPLICANT_UPDATED")
frame:SetScript("OnEvent",function(self,event,...)
    if event == "LFG_LIST_SEARCH_RESULT_UPDATED" then
        local searchResultID = ...
        print("----------------")
        print(searchResultID)
        print(getScoreForLeader(C_LFGList.GetSearchResultInfo(searchResultID)))
    elseif event == "LFG_LIST_APPLICANT_UPDATED" then
        local applicantID = ...
        local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
        if not applicantInfo or applicantInfo.applicationStatus == APPLICATION_CANCELED or applicantInfo.applicationStatus == APPLICATION_TIMEDOUT then
            C_LFGList.RefreshApplicants()
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if RaiderIO then
            local testprofile = RaiderIO.GetProfile("player") or RaiderIO.GetProfile("Nerfmeta-Area52",1)
            DevTools_Dump(testprofile)
            DevTool:AddData(testprofile,"testprofile")
            local score = 0;
            if (testprofile) then
                -- use main score if bigger then 0 or current score
                score = testprofile.mythicKeystoneProfile.mainCurrentScore and testprofile.mythicKeystoneProfile.mainCurrentScore>0 or testprofile.mythicKeystoneProfile.currentScore
            else
                score = 0
            end
            print("RaiderIO Score: "..score)
        else
            print("RaiderIO is not loaded")
        end
        
    end
	
end)
