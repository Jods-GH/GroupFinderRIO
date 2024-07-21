local appName, GFIO = ...

---comment helper to get score from a RaiderIo profile
---@param profile table
---@return integer? Mainscore
---@return integer currentScore
local function getScoreForRioProfile(profile)
    if not profile.mythicKeystoneProfile then
        return nil, 0 
    end
    if not GFIO.db.profile.useMainScore then
        return nil, profile.mythicKeystoneProfile.currentScore
    end
    if (profile.mythicKeystoneProfile.mainCurrentScore and profile.mythicKeystoneProfile.mainCurrentScore>0) and profile.mythicKeystoneProfile.mainCurrentScore> profile.mythicKeystoneProfile.currentScore then
     return profile.mythicKeystoneProfile.mainCurrentScore, profile.mythicKeystoneProfile.currentScore
    end
    return nil, profile.mythicKeystoneProfile.currentScore   
end
---comment helper to get the score for the Leader of a searchResult
---@param searchResult LfgSearchResultData
---@return number? Mainscore
---@return number currentScore
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
---comment helper to wrap a string in the raiderio score color
---@param score number
---@return string
local function colorScore(score)
    local r,g,b,a = RaiderIO.GetScoreColor(score)
    local color = CreateColor(r,g,b,a)
    local colorHexString = color:GenerateHexColor()
    local coloredScore = WrapTextInColorCode(score, colorHexString)
    return coloredScore
end

---comment hooked to the updateLfgListEntry function to add the score to the group finder list
---@param entry table
local function updateLfgListEntry(entry, ...)
    if not GFIO.db.profile.addScoreToGroup then return end
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
---comment compares two different search results to sort them by score
---@param a number
---@param b number
---@return boolean
local function compareSearchEntries(a,b)
    local mainScoreA, scoreA = getScoreForLeader(C_LFGList.GetSearchResultInfo(a))
    if mainScoreA and (not scoreA or mainScoreA>scoreA) then
        scoreA = mainScoreA
    end
    local mainScoreB, scoreB = getScoreForLeader(C_LFGList.GetSearchResultInfo(b))
    if mainScoreB and (not scoreB or  mainScoreB>scoreB) then
        scoreB = mainScoreB
    end
    return GFIO.sortFunc(scoreA,scoreB)
end
---comment hooked to the sortSearchResults function to calls compareSearchEntries to sort the search results
---@param results any
local function sortSearchResults(results)
    if (not LFGListFrame.SearchPanel:IsShown()) or results.categoryID ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS  or not GFIO.db.profile.sortGroupsByScore then
        return
    end
    table.sort(results.results , compareSearchEntries)
end
---comment helper to get the score for an applicant
---@param applicantID number
---@param numMember number
---@return integer? MainScore
---@return number Score
---@return number ItemLevel
---@return number specID
local function getScoreForApplicant(applicantID, numMember)
    local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel, factionGroup, raceID, specID = C_LFGList.GetApplicantMemberInfo(applicantID, numMember)
    itemLevel = itemLevel or 0
    if RaiderIO.GetProfile(name,1) then -- check if you can somehow get faction of an application
        local profile = RaiderIO.GetProfile(name,1)
        local mainScore, score = getScoreForRioProfile(profile)
        if dungeonScore and score and dungeonScore>score then
            score = dungeonScore
        end
        return mainScore, score or 0, itemLevel, specID
    elseif RaiderIO.GetProfile(name,2) then
        local profile = RaiderIO.GetProfile(name,2)
        local mainScore, score = getScoreForRioProfile(profile)
        if dungeonScore and score and dungeonScore>score then
            score = dungeonScore
        end
        return mainScore, score or 0, itemLevel, specID
    else
        return nil, dungeonScore or 0, itemLevel, specID
    end
end
---comment helper to get the score for an application
---@param applicationID number
---@return number Score
---@return number ItemLevel
---@return boolean SpecIdsActive
local function getScoreForApplication(applicationID)
    -- we are calculating the average score and ilvl of a group to sort by
    local applicantInfo = C_LFGList.GetApplicantInfo(applicationID)
    local score = 0
    local ilvl = 0
    local specIDs = false
    for i= 0,applicantInfo.numMembers do 
        local applicantMainScore, applicantScore, applicantIlvl, specID = getScoreForApplicant(applicationID,i)
        if applicantMainScore then
            score = score + applicantMainScore
        else
            score = score + applicantScore
        end
        ilvl = ilvl + applicantIlvl
        if specID and GFIO.db.profile.spec[specID] then
            specIDs = true
        end
    end 
    score = score/applicantInfo.numMembers
    ilvl = ilvl/applicantInfo.numMembers
    return score, ilvl, specIDs
end
---comment compares two different applicants to sort them by score
---@param a number
---@param b number
---@return boolean
local function compareApplicants(a,b)
    local scoreA,ilvlA,specIDsA = getScoreForApplication(a)
    local scoreB,ilvlB,specIDsB = getScoreForApplication(b)
    if specIDsA and not specIDsB then
        return true
    elseif specIDsB and not specIDsA then
        return false
    end
    if scoreA == scoreB then
        return GFIO.sortFunc(ilvlA,ilvlB)
    end
    return GFIO.sortFunc(scoreA,scoreB) 
end
---comment hooked to the sortApplicants function to calls compareApplicants to sort the applicants
---@param applicants table
local function sortApplications(applicants)
    if (not LFGListFrame.ApplicationViewer:IsShown()) or not GFIO.db.profile.sortApplicants then -- need to add checking for in dungeon queue
        return
    end
    local entryData = C_LFGList.GetActiveEntryInfo()
    local activityInfoTable= C_LFGList.GetActivityInfoTable(entryData.activityID)
    if activityInfoTable.categoryID ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS then return end
    table.sort(applicants, compareApplicants)
end
local groupFinderRioRatingInfoFrames = {}
---comment helper to create or get the ratingInfoFrame for a searchResult
---@param searchResult any
---@return unknown
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
        ratingInfoFrame.Note:SetSize(15,15)
        ratingInfoFrame.Note:Hide()
        groupFinderRioRatingInfoFrames[searchResult] = ratingInfoFrame
        return ratingInfoFrame

    end
end
---comment hooked to the updateApplicationListEntry function to adjust an application
---@param member frame
---@param appID number
---@param memberIdx number
local function updateApplicationListEntry(member, appID, memberIdx)
    local name = member.Name:GetText()
    local applicantInfo = C_LFGList.GetApplicantInfo(appID)
    local mainScore, score, itemLevel = getScoreForApplicant(appID, memberIdx)
    if (GFIO.db.profile.showKeyLevel) then
        local entryData = C_LFGList.GetActiveEntryInfo()
        local bestDungeonScoreForListing = C_LFGList.GetApplicantDungeonScoreForListing(appID, memberIdx, entryData.activityID)
        local color = "FFFF0000"
        if (bestDungeonScoreForListing.finishedSuccess) then
            color = "FF33FF00"
        end
        local run = bestDungeonScoreForListing.bestRunLevel or 0
        local bestrunLevel = WrapTextInColorCode(run, color)
        name = name.. "("..bestrunLevel..")"
        member.Name:SetText(name)
    end
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
    if GFIO.db.profile.showNote and applicantInfo.comment and applicantInfo.comment~="" then
        ratingInfoFrame.Note:Show()
        ratingInfoFrame.Note:SetPoint("RIGHT",member.RoleIcon1,"LEFT",0,0)
    else
        ratingInfoFrame.Note:Hide()
    end
    ratingInfoFrame:Show()
end


hooksecurefunc("LFGListSearchEntry_Update", updateLfgListEntry);
hooksecurefunc("LFGListUtil_SortSearchResults",sortSearchResults);
hooksecurefunc("LFGListUtil_SortApplicants", sortApplications);
hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", updateApplicationListEntry);



