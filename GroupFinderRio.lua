local function getScoreForRioProfile(profile)
    if (profile.mythicKeystoneProfile.mainCurrentScore and profile.mythicKeystoneProfile.mainCurrentScore>0) and profile.mythicKeystoneProfile.mainCurrentScore> profile.mythicKeystoneProfile.currentScore then
     return profile.mythicKeystoneProfile.mainCurrentScore, profile.mythicKeystoneProfile.currentScore
    end   
    return nil, profile.mythicKeystoneProfile.currentScore
end

local function getScoreForLeader(searchResult)
    local leaderName = searchResult.leaderName
    if not leaderName and searchResult.leaderOverallDungeonScore and not searchResult.isDelisted then 
        return nil, searchResult.leaderOverallDungeonScore 
    elseif not leaderName or searchResult.isDelisted then 
        return nil, 0
    end
    local leaderFullName = leaderName:find("-")~=nil and leaderName or leaderName.."-"..GetNormalizedRealmName()
    local faction = searchResult.leaderFactionGroup
    if RaiderIO.GetProfile(leaderFullName,faction) then
        local profile = RaiderIO.GetProfile(leaderFullName,faction)
        local mainScore, score = getScoreForRioProfile(profile)
        return  mainScore or 0, score or 0
    else
        return nil, searchResult.leaderOverallDungeonScore or 0
    end
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
    local activityInfoTable = C_LFGList.GetActivityInfoTable(searchResult.activityID)
    if (not LFGListFrame.SearchPanel:IsShown() or activityInfoTable.categoryID ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS or not searchResult.leaderName) then
        return
    end
    local mainScore,score = getScoreForLeader(searchResult)
    if mainScore and mainScore>score then
        entry.Name:SetText("["..colorScore(mainScore).."] "..colorScore(score) .. "   -    ".. entry.Name:GetText())
    else
        entry.Name:SetText(colorScore(score) .. "   -    ".. entry.Name:GetText())
    end
end
local function compareSearchEntries(a,b)
    local mainScoreA, scoreA = getScoreForLeader(C_LFGList.GetSearchResultInfo(a))
    if mainScoreA and (not scoreA or mainScoreA>scoreA) then
        scoreA = mainScoreA
    end
    local mainScoreB, scoreB = getScoreForLeader(C_LFGList.GetSearchResultInfo(b))
    if mainScoreB and (not scoreB or  mainScoreB>scoreB) then
        scoreB = mainScoreB
    end
    return scoreA > scoreB
end

local function sortSearchResults(results)
    if (not LFGListFrame.SearchPanel:IsShown()) or results.categoryID ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS then
        return
    end
    table.sort(results.results , compareSearchEntries)
end

local function getScoreForApplicant(applicantID, numMember)
    local name, class, _, _, itemLevel, _, _, _, _, _, _, dungeonScore, _ = C_LFGList.GetApplicantMemberInfo(applicantID, numMember)
    itemLevel = itemLevel or 0
    if RaiderIO.GetProfile(name,1) then -- check if you can somehow get faction of an application
        local profile = RaiderIO.GetProfile(name,1)
        local mainScore, score = getScoreForRioProfile(profile)
        return mainScore, score or 0, itemLevel
    elseif RaiderIO.GetProfile(name,2) then
        local profile = RaiderIO.GetProfile(name,2)
        local mainScore, score = getScoreForRioProfile(profile)
        return mainScore, score or 0, itemLevel 
    else
        return nil, dungeonScore or 0, itemLevel
    end
end

local function getScoreForApplication(applicationID)
    -- we are calculating the average score and ilvl of a group to sort by
    local applicantInfo = C_LFGList.GetApplicantInfo(applicationID)
    local score = 0
    local ilvl = 0
    for i= 0,applicantInfo.numMembers do 
        local applicantMainScore, applicantScore, applicantIlvl = getScoreForApplicant(applicationID,i)
        if applicantMainScore then
            score = score + applicantMainScore
        else
            score = score + applicantScore
        end
        ilvl = ilvl + applicantIlvl
    end 
    score = score/applicantInfo.numMembers
    ilvl = ilvl/applicantInfo.numMembers
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
local groupFinderRioRatingInfoFrames = {}
local function getRatingInfoFrame(searchResult)
    if groupFinderRioRatingInfoFrames[searchResult] then
        return groupFinderRioRatingInfoFrames[searchResult]
    else
        local ratingInfoFrame = CreateFrame("Frame")
        ratingInfoFrame:SetFrameStrata("HIGH")
        ratingInfoFrame:SetSize(30,20)
        ratingInfoFrame:SetPoint("TOP")

        ratingInfoFrame.Rating = ratingInfoFrame:CreateFontString("ratingString", "ARTWORK", "GameFontNormalSmall")
        ratingInfoFrame.Rating:SetSize(40,10)
        ratingInfoFrame.Rating:SetPoint("CENTER",ratingInfoFrame,"CENTER")
        ratingInfoFrame.Rating:SetJustifyH("LEFT")

        ratingInfoFrame.Note = ratingInfoFrame:CreateTexture("noteimage", "ARTWORK")
        ratingInfoFrame.Note:SetAtlas("transmog-icon-chat")
        ratingInfoFrame.Note:SetSize(20,20)
        ratingInfoFrame.Note:SetAllPoints(ratingInfoFrame)
        ratingInfoFrame.Note:Hide()
        groupFinderRioRatingInfoFrames[searchResult] = ratingInfoFrame
        return ratingInfoFrame

    end
end
local function updateApplicationListEntry(member, appID, memberIdx)
    local name = member.Name:GetText()
    local applicantInfo = C_LFGList.GetApplicantInfo(appID)
    local mainScore, score, itemLevel = getScoreForApplicant(appID, memberIdx)
    local ratingInfoFrame = getRatingInfoFrame(member)
    if not ratingInfoFrame then
        return
    end
    ratingInfoFrame:SetParent(member)
    ratingInfoFrame:SetPoint("TOP",member,"TOP")
    ratingInfoFrame:SetPoint("RIGHT",member.RoleIcon1,"LEFT",-10,0)
    if mainScore then
        ratingInfoFrame.Rating:SetText("["..mainScore.."]")
        ratingInfoFrame.Rating:SetTextColor(RaiderIO.GetScoreColor(mainScore))
    else
        ratingInfoFrame.Rating:SetText(score)
        ratingInfoFrame.Rating:SetTextColor(RaiderIO.GetScoreColor(score))
    end
    ratingInfoFrame.Rating:SetPoint("LEFT",member.Rating,"LEFT")
    ratingInfoFrame.Rating:SetPoint("TOP",member.Rating,"TOP")
    ratingInfoFrame.Rating:SetPoint("BOTTOM",member.Rating,"BOTTOM")
    member.Rating:Hide()

    if applicantInfo.comment and applicantInfo.comment~="" then
        ratingInfoFrame.Note:Show()
    else
        ratingInfoFrame.Note:Hide()
    end
    ratingInfoFrame:Show()
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
    if event == "LFG_LIST_APPLICANT_UPDATED" then
        local applicantID = ...
        local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
        if not applicantInfo or applicantInfo.applicationStatus == APPLICATION_CANCELED or applicantInfo.applicationStatus == APPLICATION_TIMEDOUT then
            C_LFGList.RefreshApplicants()
        end
	end
end)


