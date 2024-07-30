local appName, GFIO = ...
local CustomNames = C_AddOns.IsAddOnLoaded("CustomNames") and LibStub and LibStub("CustomNames")
---comment helper to get score from a RaiderIo profile
---@param profile table
---@return integer? Mainscore
---@return integer currentScore
---@return boolean isMainRole
local function getScoreForRioProfile(profile, assignedRole)
    if not profile.mythicKeystoneProfile then
        return nil, 0 
    end
    if not GFIO.db.profile.useMainScore then
        return nil, profile.mythicKeystoneProfile.currentScore
    end
    if (profile.mythicKeystoneProfile.mainCurrentScore and profile.mythicKeystoneProfile.mainCurrentScore>0) and profile.mythicKeystoneProfile.mainCurrentScore> profile.mythicKeystoneProfile.currentScore then
        return profile.mythicKeystoneProfile.mainCurrentScore, profile.mythicKeystoneProfile.currentScore, true
    end
    if assignedRole then
        for key,value in pairs(profile.mythicKeystoneProfile.mplusCurrent.roles) do
            if value[1] == "tank" and assignedRole == "TANK" and value[2] == "full" then
                return nil, profile.mythicKeystoneProfile.currentScore, true
            elseif value[1] == "dps" and assignedRole == "DAMAGER" and value[2] == "full" then
                return nil, profile.mythicKeystoneProfile.currentScore, true
            elseif value[1] == "healer" and assignedRole == "HEALER" and value[2] == "full" then
                return nil, profile.mythicKeystoneProfile.currentScore, true
            end
        end
    end
    return nil, profile.mythicKeystoneProfile.currentScore , false  
end
---comment helper to get the score for the Leader of a searchResult
---@param searchResult LfgSearchResultData
---@return number? Mainscore
---@return number currentScore
---@return string shortLanguage
local function getScoreForLeader(searchResult)
    local leaderName = searchResult.leaderName
    if not leaderName and searchResult.leaderOverallDungeonScore and not searchResult.isDelisted then 
        return nil, searchResult.leaderOverallDungeonScore 
    elseif not leaderName or searchResult.isDelisted then 
        return nil, 0
    end
    local leaderFullName = leaderName:find("-")~=nil and leaderName or leaderName.."-"..GetNormalizedRealmName()
    local faction = searchResult.leaderFactionGroup
    local shortLanguage  = ""
    if leaderFullName then
        local realm = leaderFullName:match("-(.+)")
        local language = realm and GFIO.REALMS[realm] or ""
        shortLanguage = GFIO.LANGUAGES[language] or ""
    end

    if RaiderIO and RaiderIO.GetProfile(leaderFullName,faction) then
        local profile = RaiderIO.GetProfile(leaderFullName,faction)
        local mainScore, score = getScoreForRioProfile(profile,nil)
        return  mainScore or 0, score or 0, shortLanguage
    else
        return nil, searchResult.leaderOverallDungeonScore or 0, shortLanguage
    end
end

---comment helper to get the color for a score either using RaiderIO coloring or the ingame coloring of wow
---@param score any
---@return integer
---@return integer
---@return integer
---@return integer
local function getScoreColor(score)
    if RaiderIO then
        return RaiderIO.GetScoreColor(score)
    else
        if score >=480 and score< 960 then
            return 30/255, 1, 0, 1
        elseif score >=960 and score< 1600 then
            return 0,112/255,221/255,1
        elseif score >=1600 and score< 2400 then
            return 163/255, 53/255, 238/255, 1
        elseif score >=2400 then
            return 1, 128/255, 0, 1
        else
            return 1,1,1,1
        end
    end
end
---comment helper to wrap a string in the raiderio score color
---@param score number
---@return string
local function colorScore(score)
    local r,g,b,a = getScoreColor(score)
    local color = CreateColor(r,g,b,a)
    local colorHexString = color:GenerateHexColor()
    local coloredScore = WrapTextInColorCode(score, colorHexString)
    return coloredScore

end

---comment hooked to the updateLfgListEntry function to add the score to the group finder list
---@param entry table
local function updateLfgListEntry(entry, ...)
    if not GFIO.db.profile.addScoreToGroup and not GFIO.db.profile.showLanguage then return end
    local searchResultID = entry.GetData().resultID
    local searchResult = C_LFGList.GetSearchResultInfo(searchResultID)
    local activityInfoTable = C_LFGList.GetActivityInfoTable(searchResult.activityID)
    if (not LFGListFrame.SearchPanel:IsShown() or activityInfoTable.categoryID ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS or not searchResult.leaderName) then
        return
    end
    local mainScore,score, shortLanguage = getScoreForLeader(searchResult)
    local orginalText = entry.Name:GetText()
    local groupName = ""
    if GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        groupName = shortLanguage.. " "
    end
    if GFIO.db.profile.addScoreToGroup and GFIO.db.profile.groupNameBeforeScore then
        if mainScore and mainScore>score then
            if GFIO.db.profile.showCurrentScoreInGroup then
                groupName = orginalText.." "..groupName.. " - ".."["..colorScore(mainScore).."]" 
            else
                groupName = orginalText.." "..groupName.. " - ".."["..colorScore(mainScore).."] "..colorScore(score)
            end
        elseif GFIO.db.profile.showCurrentScoreInGroup then
            groupName = orginalText.." "..groupName.. "   -    ".. colorScore(score)
        elseif GFIO.db.profile.showLanguage then
            groupName = orginalText.." "..groupName
        end
    elseif GFIO.db.profile.addScoreToGroup then
        if mainScore and mainScore>score then
            if GFIO.db.profile.showCurrentScoreInGroup then
                groupName = groupName.."["..colorScore(mainScore).."] "..colorScore(score) .. " - ".. orginalText
            else
                groupName = groupName.."["..colorScore(mainScore).."] - ".. orginalText
            end
        elseif GFIO.db.profile.showCurrentScoreInGroup then
            groupName = groupName..colorScore(score) .. " - ".. orginalText
        elseif GFIO.db.profile.showLanguage then
            groupName = groupName.." - ".. orginalText
        end
    end
    if groupname ~= "" then
        entry.Name:SetText(groupName)
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
---@return string name
---@return string language
---@return boolean tank
---@return boolean healer
---@return boolean damage
---@return boolean isMainRole
local function getApplicantInfo(applicantID, numMember)
    local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel, factionGroup, raceID, specID = C_LFGList.GetApplicantMemberInfo(applicantID, numMember)
    itemLevel = itemLevel or 0
    local shortLanguage  = ""
    if name then
        local realm = name:match("-(.+)")
        local language = realm and GFIO.REALMS[realm] or ""
        shortLanguage = GFIO.LANGUAGES[language] or ""
    end
    if RaiderIO and RaiderIO.GetProfile(name,factionGroup) then -- check if you can somehow get faction of an application
        local profile = RaiderIO.GetProfile(name,factionGroup)
        local mainScore, score, isMainRole = getScoreForRioProfile(profile,assignedRole)
        if dungeonScore and score and dungeonScore>score then
            score = dungeonScore
        end
        return mainScore, score or 0, itemLevel, specID, name, shortLanguage, tank, healer, damage, isMainRole
    else
        return nil, dungeonScore or 0, itemLevel, specID, name, shortLanguage, tank, healer, damage, true
    end
end


---comment helper to get the score for an application
---@param applicationID number
---@return number Score
---@return number ItemLevel
---@return boolean SpecIdsActive
---@return boolean CanFit this is an application we cant check any multi asignments cause that calculation will get hardcore expensive with recursive calls etc
---@return boolean everyoneIsMain if everyone is on his main role or if someone is on alt role
local function getScoreForApplication(applicationID)
    -- we are calculating the average score and ilvl of a group to sort by
    local applicantInfo = C_LFGList.GetApplicantInfo(applicationID)
    local score = 0
    local ilvl = 0
    local specIDs = false
    local group = GetGroupMemberCounts()
    local dpsSpots = 3-group.DAMAGER
    local tankSpots = 1-group.TANK
    local healerSpots = 1-group.HEALER
    local groupExceedsMembers = applicantInfo.numMembers > (dpsSpots + tankSpots + healerSpots)
    local everyoneIsMain = true
    for i= 0,applicantInfo.numMembers do 
        local applicantMainScore, applicantScore, applicantIlvl, specID, name,_, tank, healer, damage, isMainRole = getApplicantInfo(applicationID,i)
        if tank and not healer and not damage then
            tankSpots = tankSpots - 1
        elseif not tank and healer and not damage then
            healerSpots = healerSpots - 1
        elseif not tank and not healer and damage then
            dpsSpots = dpsSpots - 1
        end
        if applicantMainScore then
            score = score + applicantMainScore
        else
            score = score + applicantScore
        end
        ilvl = ilvl + applicantIlvl
        if specID and GFIO.db.profile.spec[specID] then
            specIDs = true
        end
        if not isMainRole then
            everyoneIsMain = false
        end
    end 
    score = score/applicantInfo.numMembers
    ilvl = ilvl/applicantInfo.numMembers
    if groupExceedsMembers then
        return score, ilvl, specIDs, false, everyoneIsMain
    elseif tankSpots < 0 or healerSpots < 0 or dpsSpots < 0 then
        return score, ilvl, specIDs, false, everyoneIsMain
    end
    return score, ilvl, specIDs, true, everyoneIsMain
end
---comment compares two different applicants to sort them by score
---@param a number
---@param b number
---@return boolean
local function compareApplicants(a,b)
    local scoreA,ilvlA,specIDsA,CanFitA, everyoneIsMainA = getScoreForApplication(a)
    local scoreB,ilvlB,specIDsB,CanFitB, everyoneIsMainB = getScoreForApplication(b)
    if CanFitA and not CanFitB then
        return true
    elseif CanFitB and not CanFitA then
        return false
    end
    if specIDsA and not specIDsB then
        return true
    elseif specIDsB and not specIDsA then
        return false
    end
    local difference = GFIO.db.profile.wrongRoleScoreLimitForSorting or 100
    if everyoneIsMainA ~= everyoneIsMainB and scoreA-scoreB<difference  and scoreA-scoreB>-difference then
        if everyoneIsMainA then
            return true
        else
            return false
        end
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

        ratingInfoFrame.AdditionalInfo = ratingInfoFrame:CreateFontString("AdditionalInfoString", "ARTWORK", "GameFontNormalSmall")
        ratingInfoFrame.AdditionalInfo:SetSize(30,10)
        ratingInfoFrame.AdditionalInfo:SetPoint("BOTTOM",ratingInfoFrame,"BOTTOM")
        ratingInfoFrame.AdditionalInfo:SetJustifyH("LEFT")

        ratingInfoFrame.Rating = ratingInfoFrame:CreateFontString("ratingString", "ARTWORK", "GameFontNormalSmall")
        ratingInfoFrame.Rating:SetSize(50,10)
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
    local applicantInfo = C_LFGList.GetApplicantInfo(appID)
    local mainScore, score, itemLevel, specID, name, shortLanguage,_,_,_,isMainRole = getApplicantInfo(appID,memberIdx)
    if CustomNames then
        local customName = CustomNames.Get(name)
        if name ~= customName then
            member.Name:SetText(customName)
        end
    end
    local ratingInfoFrame = getRatingInfoFrame(member)
    if not ratingInfoFrame then
        return
    end
    local additionalInfo = ""

    if GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        additionalInfo = shortLanguage
    end
    if (GFIO.db.profile.showKeyLevel) then
        local entryData = C_LFGList.GetActiveEntryInfo()
        local bestDungeonScoreForListing = C_LFGList.GetApplicantDungeonScoreForListing(appID, memberIdx, entryData.activityID)
        local color = "FFFF0000"
        if (bestDungeonScoreForListing.finishedSuccess) then
            color = "FF33FF00"
        end
        local run = bestDungeonScoreForListing.bestRunLevel or 0
        local chestPrefix = ""
        for i= 1, bestDungeonScoreForListing.bestLevelIncrement do
            chestPrefix= chestPrefix.."+"
        end
        run = chestPrefix.." "..run
        local bestrunLevel = WrapTextInColorCode(run, color)
        member.Name:SetPoint("TOP",member,"TOP",0,0)
        additionalInfo = additionalInfo.." "..bestrunLevel
    end
    if additionalInfo ~= "" then
        ratingInfoFrame.AdditionalInfo:SetPoint("BOTTOM",member,"BOTTOM",0,0)
        ratingInfoFrame.AdditionalInfo:SetPoint("LEFT",member.Name,"LEFT",2,0)
        ratingInfoFrame.AdditionalInfo:SetPoint("RIGHT",member.RoleIcon1,"RIGHT",2,0)
        ratingInfoFrame.AdditionalInfo:SetText(additionalInfo) 
    end
    ratingInfoFrame:SetParent(member)
    ratingInfoFrame:SetPoint("TOP",member,"TOP")
    ratingInfoFrame:SetPoint("RIGHT",member.RoleIcon1,"LEFT",-10,0)
    local textAddition = ""
    if not isMainRole and GFIO.db.profile.useOfWrongRoleHighlight then
        textAddition  = "\124T135768:0\124t"
    end
    if mainScore then
        ratingInfoFrame.Rating:SetText("["..mainScore.."] "..textAddition)
        ratingInfoFrame.Rating:SetTextColor(getScoreColor(mainScore))
    else
        ratingInfoFrame.Rating:SetText(score.." "..textAddition)
        ratingInfoFrame.Rating:SetTextColor(getScoreColor(score))
    end
    ratingInfoFrame.Rating:SetPoint("LEFT",member.Rating,"LEFT")
    member.Rating:Hide()
    if GFIO.db.profile.showNote and applicantInfo.comment and applicantInfo.comment~="" then
        ratingInfoFrame.Note:Show()
        ratingInfoFrame.Note:SetPoint("RIGHT",member.RoleIcon1,"LEFT",-2,0)
    else
        ratingInfoFrame.Note:Hide()
    end
    ratingInfoFrame:Show()
end


hooksecurefunc("LFGListSearchEntry_Update", updateLfgListEntry);
hooksecurefunc("LFGListUtil_SortSearchResults",sortSearchResults);
hooksecurefunc("LFGListUtil_SortApplicants", sortApplications);
hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", updateApplicationListEntry);



