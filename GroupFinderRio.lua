local addonName, GFIO = ...
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
    if not GFIO.db.profile.useMainInfo then
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
if GFIO.DEBUG_MODE then
    GFIO.RIOProfiles = {}
end
---comment helper to get Progress from a RaiderIo profile
---@param profile table
---@return integer maxBosses
---@return bossData? charData
---@return bossData? maindata
local function getProgressForRioProfile(profile, instanceID, activeDifficulty)
    if GFIO.DEBUG_MODE then
        DevTools_Dump(profile)
    end
    if not profile.raidProfile or not profile.raidProfile.raidProgress then
        return 0, nil, nil
    end
    local bosscount = 0 
    ---@class bossData
    local charData = {
        bosskills = 0,
        highestDifficultyKilledBosses = 0,
        difficulty = 0,
    }
    ---@class bossData
    local maindata = {
        bosskills = 0,
        highestDifficultyKilledBosses = 0,
        difficulty = 0,
    }
    if GFIO.DEBUG_MODE then
        if not GFIO.RIOProfiles[profile.name.."-"..profile.realm] then
            GFIO.RIOProfiles[profile.name.."-"..profile.realm] = profile
            DevTool:AddData(GFIO.RIOProfiles,"RIOProfiles")
        end
    end
    for _,raid in pairs(profile.raidProfile.raidProgress) do
        if raid.raid.id == instanceID then -- this actually breaks in awakened seasons we might need to do sth about that
            bosscount = raid.raid.bossCount
            local kills = 0 
            for _, value in pairs (raid.progress) do
                if value.difficulty == activeDifficulty then
                    kills = value.kills
                    break
                end
            end
            local highestDifficultyKilledBosses = raid.progress[#raid.progress].kills
            local difficulty = raid.progress[#raid.progress].difficulty
            if raid.isMainProgress then
                maindata.bosskills = kills
                maindata.highestDifficultyKilledBosses = highestDifficultyKilledBosses
                maindata.difficulty = difficulty
            else
                charData.bosskills = kills
                charData.highestDifficultyKilledBosses = highestDifficultyKilledBosses
                charData.difficulty = difficulty
            end
        end
    end
    
    return bosscount , charData, maindata 
end


---comment helper to get the score for the Leader of a searchResult
---@param searchResult LfgSearchResultData
---@return number? Mainscore
---@return number currentScore
---@return string shortLanguage
local function getScoreForLeader(searchResult)
    local leaderName = searchResult.leaderName
    if not leaderName and searchResult.leaderOverallDungeonScore and not searchResult.isDelisted then 
        return nil, searchResult.leaderOverallDungeonScore , ""
    elseif not leaderName then 
        return nil, 0 , ""
    end
    local leaderFullName = leaderName:find("-")~=nil and leaderName or leaderName.."-"..GetNormalizedRealmName()
    local faction = searchResult.leaderFactionGroup
    local shortLanguage  = ""
    if leaderFullName then
        local realm = leaderFullName:match("-(.+)") or GetNormalizedRealmName()
        local language = realm and GFIO.REALMS[realm] or ""
        shortLanguage = GFIO.LANGUAGES[language] or ""
    end

    if RaiderIO and RaiderIO.GetProfile(leaderFullName,faction) then
        local profile = RaiderIO.GetProfile(leaderFullName,faction)
        local mainScore, score = getScoreForRioProfile(profile,nil)
        if score< searchResult.leaderOverallDungeonScore then
            return mainScore, searchResult.leaderOverallDungeonScore, shortLanguage
        end
        return  mainScore or 0, score or 0, shortLanguage
    else
        return nil, searchResult.leaderOverallDungeonScore or 0, shortLanguage
    end
end

---comment helper to get the RaidProgress for the Leader of a searchResult
---@param searchResult LfgSearchResultData
---@return number? maxBosses
---@return bossData? charData
---@return bossData? mainData
---@return string? shortLanguage
---@return number? difficulty
local function getProgressForLeader(searchResult)
    local leaderName = searchResult.leaderName
    local raidZone = GFIO.RAIDS[searchResult.activityID]
    if not leaderName or searchResult.isDelisted or not raidZone or raidZone == {} then 
        return nil, nil, nil, nil, nil
    end
    local leaderFullName = leaderName:find("-")~=nil and leaderName or leaderName.."-"..GetNormalizedRealmName()
    local faction = searchResult.leaderFactionGroup
    local shortLanguage  = ""
    if leaderFullName then
        local realm = leaderFullName:match("-(.+)") or GetNormalizedRealmName()
        local language = realm and GFIO.REALMS[realm] or ""
        shortLanguage = GFIO.LANGUAGES[language] or ""
    end
    if RaiderIO and RaiderIO.GetProfile(leaderFullName,faction) then
        local profile = RaiderIO.GetProfile(leaderFullName,faction)
        local maxBosses,charData, mainData = getProgressForRioProfile(profile,raidZone.id, raidZone.difficulty)
        return maxBosses, charData, mainData, shortLanguage, raidZone.difficulty
    else
        return nil, nil, nil, shortLanguage, raidZone.difficulty
    end
end

---comment helper to get the color for a score either using RaiderIO coloring or the ingame coloring of wow
---@param score any
---@return number r
---@return number g
---@return number b
---@return number a
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
---comment helper to get the color for a progress by using the ingame rarity coloring of wow. Normal = copper, Heroic = rare, Mythic = epic
---@param difficulty number
---@return number r
---@return number g
---@return number b
---@return number a
local function getProgressColor(difficulty)
    if difficulty == 1 then
        return 30/255, 1, 0, 1
    elseif difficulty == 2 then
        return 0,112/255,221/255,1
    elseif difficulty == 3 then
        return 163/255, 53/255, 238/255, 1
    else
        return 1,1,1,1
    end
end

---comment helper to wrap a string in the rarity color
---@param string string
---@param difficulty number
---@return string
local function colorRaidProgress(string, difficulty)
    local r,g,b,a = getProgressColor(difficulty)
    local color = CreateColor(r,g,b,a)
    local colorHexString = color:GenerateHexColor()
    return WrapTextInColorCode(string, colorHexString)  
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
---comment helper to adjust group titles for mplus
---@param searchResult LfgSearchResultData
---@param entry table
---@return string
local function updateMplusData(searchResult,entry)
    local mainScore,score, shortLanguage = getScoreForLeader(searchResult)
    local orginalText = entry.Name:GetText()
    local additionalInfo = ""
    local languageTag = ""
    local highestKey = ""
    local orginalText = WrapTextInColorCode(orginalText, GFIO.Color.BlizzardGameColor)
    if GFIO.db.profile.showKeyLevelLeader and searchResult.leaderDungeonScoreInfo and 
        searchResult.leaderDungeonScoreInfo.bestRunLevel and searchResult.leaderDungeonScoreInfo.bestRunLevel >0 then
        local scoreInfo = searchResult.leaderDungeonScoreInfo
        local color = scoreInfo.finishedSuccess and GFIO.Color.TimedKeyColor or GFIO.Color.DepletedKeyColor
        local run = scoreInfo.bestRunLevel or 0
        local chestPrefix = ""
        for i= 1, scoreInfo.bestLevelIncrement do
            chestPrefix= chestPrefix.."+"
        end
        if chestPrefix~="" then
            run = chestPrefix.." "..run
        end
        local bestrunLevel = WrapTextInColorCode(run, color)
        highestKey = bestrunLevel
    end
    if GFIO.db.profile.showInfoInActivityName and GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        local colorCodedText = WrapTextInColorCode(shortLanguage, GFIO.Color.BlizzardGameColor) -- use game default font color
        languageTag = colorCodedText.. " "
    elseif not GFIO.db.profile.showInfoInActivityName and GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        languageTag = shortLanguage.. " "
    end
    if GFIO.db.profile.addScoreToGroup then
        if GFIO.db.profile.useMainInfo and mainScore and score and mainScore>score then
            if GFIO.db.profile.showCurrentScoreInGroup and score> 0 then
                additionalInfo = additionalInfo.. "["..colorScore(mainScore).."] "..colorScore(score)
            else
                additionalInfo = additionalInfo.."["..colorScore(mainScore).."]" 
            end
        elseif score and score>0 then
            additionalInfo = additionalInfo..colorScore(score)
        end
    end

    local activityName = entry.ActivityName:GetText()
    if GFIO.db.profile.shortenActivityName and GFIO.DUNGEONS[searchResult.activityID] then
        local dungeon = GFIO.DUNGEONS[searchResult.activityID]
        activityName = dungeon.shortName
    end

    if GFIO.db.profile.showInfoInActivityName then
        if additionalInfo ~= "" then
            entry.ActivityName:SetText(languageTag.." " ..activityName.. " - "..additionalInfo)
        else
            entry.ActivityName:SetText(languageTag.." " ..activityName)
        end
        if highestKey and highestKey~="" then
            return "("..highestKey..") - ".. orginalText
        end
        return orginalText
    end

    if activityName ~= "" and activityName ~= entry.ActivityName:GetText() then
        entry.ActivityName:SetText(languageTag.." "..activityName)
    elseif languageTag ~= "" then
        entry.ActivityName:SetText(languageTag.." "..entry.ActivityName:GetText())
    end
    if GFIO.db.profile.groupNameBeforeScore then
        if highestKey and highestKey~="" then
            if additionalInfo ~= "" then
                return orginalText.." - ("..highestKey.. ") - "..additionalInfo 
            else
                return orginalText.." - ("..highestKey.. ")"
            end
        end
        if additionalInfo ~= "" then
            return orginalText.. " - "..additionalInfo
        end
        return orginalText
    else
        if highestKey and highestKey~="" then
            if additionalInfo ~= "" then
                return "("..highestKey..") "..additionalInfo.." - "..orginalText
            else
                return "("..highestKey..") "..orginalText
            end
        elseif additionalInfo ~= "" then
            return additionalInfo.." - "..orginalText
        else
            return orginalText
        end
    end
end
---comment
---@param searchResult LfgSearchResultData
---@param activityInfoTable GroupFinderActivityInfo
---@param entry table
local function updateRaidData(searchResult,activityInfoTable,entry)
    local maxBosses, charData, mainData, shortLanguage, difficulty = getProgressForLeader(searchResult)
    local orginalText = entry.Name:GetText()
    local additionalInfo = ""
    if GFIO.db.profile.showInfoInActivityName and GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        local colorCodedText = WrapTextInColorCode(shortLanguage, GFIO.Color.BlizzardGameColor) -- use game default font color
        additionalInfo = colorCodedText.. " "
    elseif not GFIO.db.profile.showInfoInActivityName and GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        additionalInfo = shortLanguage.. " "
    end
    if charData and charData.bosskills and charData.bosskills~=0 and maxBosses and maxBosses ~=0 then
        additionalInfo = additionalInfo .. colorRaidProgress(charData.bosskills.."/"..maxBosses, difficulty).. " "
    end
    if GFIO.db.profile.addHighestDifficulty and charData and charData.difficulty and difficulty and charData.difficulty ~= difficulty and charData.highestDifficultyKilledBosses~= 0 then
        if charData.bosskills ~= 0 then
            additionalInfo = additionalInfo.. colorRaidProgress("("..charData.highestDifficultyKilledBosses.."/"..maxBosses..")", charData.difficulty).. " "
        else
            additionalInfo = additionalInfo.. colorRaidProgress(charData.highestDifficultyKilledBosses.."/"..maxBosses, charData.difficulty).. " "    
        end
        
    end
    if GFIO.db.profile.useMainInfo and GFIO.db.profile.addHighestDifficulty and mainData and mainData.difficulty and difficulty and mainData.difficulty >= difficulty and mainData.highestDifficultyKilledBosses~= 0 then
        additionalInfo = additionalInfo.. colorRaidProgress("["..mainData.highestDifficultyKilledBosses.."/"..maxBosses.."]", mainData.difficulty).. " "
    elseif GFIO.db.profile.useMainInfo and mainData and mainData.bosskills and mainData.bosskills~=0 and maxBosses and maxBosses ~=0 then
        additionalInfo = additionalInfo .. colorRaidProgress("["..mainData.bosskills.."/"..maxBosses.."]",difficulty).. " "
    end
    local activityName = entry.ActivityName:GetText()
    if GFIO.db.profile.shortenActivityName and GFIO.RAIDS[searchResult.activityID] then
        local raid = GFIO.RAIDS[searchResult.activityID]
        activityName = raid.shortName
    end
    if GFIO.db.profile.showInfoInActivityName then
        entry.ActivityName:SetText(additionalInfo..activityName)
        return orginalText
    elseif activityName ~= "" and activityName ~= entry.ActivityName:GetText() then
        entry.ActivityName:SetText(activityName)
        return additionalInfo..orginalText
    else
        return additionalInfo..orginalText
    end
end

if GFIO.DEBUG_MODE then
    GFIO.RAIDLIST = {}
end
local GROUP_FINDER_CATEGORY_ID_RAIDS = 3


---comment hooked to the updateLfgListEntry function to add the score to the group finder list
---@param entry table
local function updateLfgListEntry(entry, ...)
    if not GFIO.db.profile.addScoreToGroup and not GFIO.db.profile.showLanguage then return end
    
    local searchResultID = entry.GetData().resultID
    local searchResult = C_LFGList.GetSearchResultInfo(searchResultID)
    local activityInfoTable = C_LFGList.GetActivityInfoTable(searchResult.activityID)
    if (not LFGListFrame.SearchPanel:IsShown() or searchResult.isDelisted) then
        return
    end
    local groupName = "" --""
    if activityInfoTable.categoryID == GROUP_FINDER_CATEGORY_ID_DUNGEONS then
        groupName = updateMplusData(searchResult,entry)
    elseif activityInfoTable.categoryID == GROUP_FINDER_CATEGORY_ID_RAIDS then
        groupName = updateRaidData(searchResult,activityInfoTable, entry)
    end

    if GFIO.DEBUG_MODE then
        groupName = groupName.. "["..searchResult.activityID.."]"
        if not GFIO.RAIDLIST[searchResult.activityID] then
            GFIO.RAIDLIST[searchResult.activityID] = activityInfoTable.fullName
            DevTool:AddData(GFIO.RAIDLIST,"RAIDLIST")
            return
        elseif GFIO.RAIDLIST[searchResult.activityID] ~= activityInfoTable.fullName then
            print(GFIO.RAIDLIST[searchResult.activityID])
            print(activityInfoTable.fullName)
            return
        end
    end
    if groupName ~= "" then
        entry.Name:SetText(groupName)
    end
end

---comment compares two different search results to sort them by score
---@param a number
---@param b number
---@return boolean
local function compareSearchEntriesMplus(a,b)
    if not a then 
        return false
    elseif not b then 
        return true
    end
    local _, appStatusA, pendingStatusA, appDurationA = C_LFGList.GetApplicationInfo(a)
    local _, appStatusB, pendingStatusB, appDurationB = C_LFGList.GetApplicationInfo(b)
    local isApplicationA = appStatusA ~= "none" or pendingStatusA or false
    local isApplicationB= appStatusB ~= "none" or pendingStatusB or false
    if isApplicationA ~= isApplicationB then 
        return isApplicationA 
    end
    if appDurationA ~= appDurationB then 
        return appDurationA > appDurationB 
    end
    local searchResultA = C_LFGList.GetSearchResultInfo(a)
    local searchResultB = C_LFGList.GetSearchResultInfo(b)

    if not searchResultA or not searchResultB then
        return a>b
    elseif searchResultA.hasSelf ~= searchResultB.hasSelf then
        return searchResultA.hasSelf
    elseif searchResultA.isDelisted ~= searchResultB.isDelisted then
        return searchResultB.isDelisted
    end
   
    local mainScoreA, scoreA = getScoreForLeader(searchResultA)
    if mainScoreA and (not scoreA or mainScoreA>scoreA) then
        scoreA = mainScoreA
    end
    local mainScoreB, scoreB = getScoreForLeader(searchResultB)
    if mainScoreB and (not scoreB or  mainScoreB>scoreB) then
        scoreB = mainScoreB
    end


    if scoreA and scoreB and scoreA> 0 or scoreB>0 then
        return GFIO.sortFunc(scoreA,scoreB)
    elseif not scoreA or not scoreB and scoreA ~= scoreB then
        return not scoreB
    elseif searchResultA.activityID ~= searchResultB.activityID then
        return GFIO.sortFunc(searchResultA.activityID,searchResultB.activityID)
    end
    return GFIO.sortFunc(searchResultA.age,searchResultB.age)
end

---comment compares two different search results to sort them by raidProgress
---@param a number
---@param b number
---@return boolean
local function compareSearchEntriesRaid(a,b)

    local _, appStatusA, pendingStatusA, appDurationA = C_LFGList.GetApplicationInfo(a)
    local _, appStatusB, pendingStatusB, appDurationB = C_LFGList.GetApplicationInfo(b)
    local isApplicationA = appStatusA ~= "none" or pendingStatusA or false
    local isApplicationB= appStatusB ~= "none" or pendingStatusB or false
    if isApplicationA ~= isApplicationB then 
        return isApplicationA 
    end
    if appDurationA ~= appDurationB then 
        return appDurationA > appDurationB 
    end

    local searchResultA = C_LFGList.GetSearchResultInfo(a)
    local searchResultB = C_LFGList.GetSearchResultInfo(b)
    if searchResultA.hasSelf and not searchResultB.hasSelf then
        return true
    elseif searchResultB.hasSelf and not searchResultA.hasSelf then
        return false   
    elseif searchResultA.isDelisted and searchResultB.isDelisted then
        return a>b -- avoid race condition by randomly sorting the searchResultId not like it matters what we do here
    elseif not searchResultA.isDelisted and searchResultB.isDelisted then
        return true
    elseif searchResultA.isDelisted and not searchResultB.isDelisted then
        return false
    end

    if GFIO.DEBUG_MODE then -- use this to gather raid ids for the raidlist
        assert(GFIO.RAIDS[searchResultA.activityID], "No Raid Data for ID: "..searchResultA.activityID)
        assert(GFIO.RAIDS[searchResultB.activityID], "No Raid Data for ID: "..searchResultB.activityID)
        assert(GFIO.ACTIVITY_ORDER[searchResultA.activityID] , "Activity ID has no order: "..searchResultA.activityID)
        assert(GFIO.ACTIVITY_ORDER[searchResultB.activityID] , "Activity ID has no order: "..searchResultB.activityID)
    end


    if not GFIO.ACTIVITY_ORDER[searchResultA.activityID] or not GFIO.ACTIVITY_ORDER[searchResultB.activityID] 
        or not GFIO.RAIDS[searchResultA.activityID] or not GFIO.RAIDS[searchResultB.activityID] then
        return searchResultA.activityID > searchResultB.activityID
    end

    if searchResultA.activityID ~= searchResultB.activityID then
        return GFIO.sortFunc(GFIO.ACTIVITY_ORDER[searchResultA.activityID], GFIO.ACTIVITY_ORDER[searchResultB.activityID])
    end
    local _, charDataA, mainDataA, _, difficultyA = getProgressForLeader(searchResultA)
    local _, charDataB, mainDataB, _, difficultyB = getProgressForLeader(searchResultB)
    
    if not charDataA and not charDataB then
        return a>b  -- avoid race condition by randomly sorting the searchResultId not like it matters what we do here
    elseif charDataA and not charDataB then
        return true
    elseif not charDataA and charDataB then
        return false
    end

    if difficultyA ~= difficultyB then
        return GFIO.sortFunc(difficultyA,difficultyB)
    end
    assert(difficultyA , "difficultyA is nil for activity".. searchResultA.activityID)
    assert(difficultyB , "difficultyB is nil for activity".. searchResultB.activityID)
    assert(mainDataA and mainDataA.difficulty , "maindataA difficulty is nil")
    assert(mainDataB and mainDataB.difficulty , "maindataB difficulty is nil")
    if mainDataA and mainDataB and mainDataA.difficulty >difficultyA and mainDataA.difficulty == mainDataB.difficulty and mainDataA.bosskills == mainDataB.bosskills then
        if charDataA.difficulty ~= charDataB.difficulty then
            return GFIO.sortFunc(charDataA.difficulty, charDataB.difficulty)
        elseif GFIO.db.profile.addHighestDifficulty and charDataA.highestDifficultyKilledBosses ~= charDataB.highestDifficultyKilledBosses then
            return GFIO.sortFunc(charDataA.highestDifficultyKilledBosses,charDataB.highestDifficultyKilledBosses)
        else
            return GFIO.sortFunc(charDataA.bosskills,charDataB.bosskills)
        end
    end
    if GFIO.db.profile.useMainInfo and mainDataA and charDataA and (mainDataA.difficulty >difficultyA or (mainDataA.difficulty == difficultyA and 
        (mainDataA.highestDifficultyKilledBosses>charDataA.highestDifficultyKilledBosses 
            or mainDataA.bosskills>charDataA.bosskills))) then
        charDataA = mainDataA
    end
    if GFIO.db.profile.useMainInfo and mainDataB and charDataB and (mainDataB.difficulty>difficultyB or (mainDataB.difficulty == difficultyB and 
        (mainDataB.highestDifficultyKilledBosses>charDataB.highestDifficultyKilledBosses 
            or mainDataB.bosskills>charDataB.bosskills))) then
        charDataB = mainDataB
    end
    if charDataA.difficulty ~= charDataB.difficulty then
        return GFIO.sortFunc(charDataA.difficulty, charDataB.difficulty)
    elseif GFIO.db.profile.addHighestDifficulty and charDataA.highestDifficultyKilledBosses ~= charDataB.highestDifficultyKilledBosses then
        return GFIO.sortFunc(charDataA.highestDifficultyKilledBosses,charDataB.highestDifficultyKilledBosses)
    end

    return GFIO.sortFunc(charDataA.bosskills,charDataB.bosskills)

end
---comment hooked to the sortSearchResults function to calls compareSearchEntries to sort the search results
---@param entry any
local function sortSearchResults(entry)
    if not PVEFrame:IsShown() or not LFGListFrame.SearchPanel:IsShown()or not GFIO.db.profile.sortGroupsByScore then
        return
    end
    if not entry.categoryID then -- we are in PGF sorting
        local results = CopyTable(entry)
        if LFGListFrame.CategorySelection.selectedCategory == GROUP_FINDER_CATEGORY_ID_DUNGEONS then
            table.sort(results, compareSearchEntriesMplus) 
        elseif LFGListFrame.CategorySelection.selectedCategory == GROUP_FINDER_CATEGORY_ID_RAIDS then
            table.sort(results, compareSearchEntriesRaid)
        end
        return
    end
    local results = CopyTable(entry.results)
    if entry.categoryID == GROUP_FINDER_CATEGORY_ID_DUNGEONS then
        table.sort(results, compareSearchEntriesMplus) 
    elseif entry.categoryID == GROUP_FINDER_CATEGORY_ID_RAIDS then
        table.sort(results, compareSearchEntriesRaid)
    end
    -- publish
    LFGListFrame.SearchPanel.results = results
    LFGListFrame.SearchPanel.totalResults = #results
    LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
    --[[
    local dataProvider = CreateDataProvider();
    local results = self.results;
    for index = 1, #results.results do
        dataProvider:Insert({resultID=results.results[index]});
    end
    LFGListFrame.SearchPanel.results = results.results
    LFGListFrame.SearchPanel.totalResults = #results.results
    LFGListFrame.SearchPanel.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
    LFGListFrame.SearchPanel.ScrollBox:Update()
    DevTool:AddData(LFGListFrame.SearchPanel,"searchpanel")
    ]]
end

---comment helper to get the timed keys from a RaiderIo profile
---@param profile any
---@return timedKeystonesList
local function getTimedKeys(profile)
    ---@class timedKeystonesList
    ---@field fivePlus number
    ---@field tenPlus number
    ---@field fifteenPlus number
    ---@field twentyPlus number
    ---@return table
    local keys = {}
    if not profile.mythicKeystoneProfile then
        return keys
    end
    keys.fivePlus = profile.mythicKeystoneProfile.keystoneFivePlus or 0
    keys.tenPlus = profile.mythicKeystoneProfile.keystoneTenPlus or 0
    keys.fifteenPlus = profile.mythicKeystoneProfile.keystoneFifteenPlus or 0
    keys.twentyPlus = profile.mythicKeystoneProfile.keystoneTwentyPlus or 0
    return keys
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
---@return number raceID
---@return table timedKeystonesList
local function getApplicantInfoForKeys(applicantID, numMember)
    local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel, factionGroup, raceID, specID = C_LFGList.GetApplicantMemberInfo(applicantID, numMember)
    itemLevel = itemLevel or 0
    local shortLanguage  = ""
    if name then
        local realm = name:match("-(.+)") or GetNormalizedRealmName()
        local language = realm and GFIO.REALMS[realm] or ""
        shortLanguage = GFIO.LANGUAGES[language] or ""
    end
    if RaiderIO and RaiderIO.GetProfile(name,factionGroup) then
        local profile = RaiderIO.GetProfile(name,factionGroup)
        local mainScore, score, isMainRole = getScoreForRioProfile(profile,assignedRole)
        if dungeonScore and score and dungeonScore>score then
            score = dungeonScore
        end
        return mainScore, score or 0, itemLevel, specID, name, shortLanguage, tank, healer, damage, isMainRole, raceID, getTimedKeys(profile)
    else
        return nil, dungeonScore or 0, itemLevel, specID, name, shortLanguage, tank, healer, damage, true, raceID, nil
    end
end
---comment
---@param applicantID any
---@param numMember any
---@param entryData LfgEntryData
---@return integer? maxBosses
---@return bossData? charData
---@return bossData? mainData
---@return number itemLevel
---@return number specID
---@return string name
---@return string language
---@return boolean tank
---@return boolean healer
---@return boolean damage
local function getApplicantInfoForRaid(applicantID, numMember, entryData)
    local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel, factionGroup, raceID, specID = C_LFGList.GetApplicantMemberInfo(applicantID, numMember)
    itemLevel = itemLevel or 0
    local shortLanguage  = ""
    if name then
        local realm = name:match("-(.+)") or GetNormalizedRealmName()
        local language = realm and GFIO.REALMS[realm] or ""
        shortLanguage = GFIO.LANGUAGES[language] or ""
    end
    if RaiderIO and RaiderIO.GetProfile(name,factionGroup) and GFIO.RAIDS[entryData.activityID] then
        local profile = RaiderIO.GetProfile(name,factionGroup)
        local raidZone = GFIO.RAIDS[entryData.activityID]
        local maxBosses, charData, mainData = getProgressForRioProfile(profile, raidZone.id , raidZone.difficulty)
        return maxBosses, charData, mainData, itemLevel, specID, name, shortLanguage, tank, healer, damage
    else
        return nil, nil, nil, itemLevel, specID, name, shortLanguage, tank, healer, damage
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
        local applicantMainScore, applicantScore, applicantIlvl, specID, name,_, tank, healer, damage, isMainRole = getApplicantInfoForKeys(applicationID,i)
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
local function compareApplicantsDungeons(a,b)
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
        if ilvlA == ilvlB then
            return GFIO.sortFunc(a,b)
        end
        return GFIO.sortFunc(ilvlA,ilvlB)
    end
    return GFIO.sortFunc(scoreA,scoreB) 
end
---comment helper to get the raidProgress for an application
---@param applicationID number
---@return number avgKilledBosses
---@return number avgDifficulty
---@return number ItemLevel
---@return boolean SpecIdsActive
---@return boolean CanFit this is an application we cant check any multi asignments cause that calculation will get hardcore expensive with recursive calls etc
local function getProgressForApplication(applicationID)
    -- we are calculating the average score and ilvl of a group to sort by
    local applicantInfo = C_LFGList.GetApplicantInfo(applicationID)
    local entryData = C_LFGList.GetActiveEntryInfo()
    local raidZone = GFIO.RAIDS[entryData.activityID]
    if not raidZone then
        return 0,0,0, false, false
    end
    local difficulty = raidZone.difficulty
    local killedBosses = 0
    local ilvl = 0
    local specIDs = false
    local group = GetGroupMemberCounts()
    local dpsSpots = 3-group.DAMAGER
    local tankSpots = 1-group.TANK
    local healerSpots = 1-group.HEALER
    local groupExceedsMembers = applicantInfo.numMembers > (dpsSpots + tankSpots + healerSpots)
    local maxAvailableBosses
    for i= 0,applicantInfo.numMembers do 
        local maxBosses,charData, mainData, itemLevel, specID, name, shortLanguage, tank, healer, damage = getApplicantInfoForRaid(applicationID,i,entryData)
        if not maxAvailableBosses then
            maxAvailableBosses = maxBosses
        end
        if tank and not healer and not damage then
            tankSpots = tankSpots - 1
        elseif not tank and healer and not damage then
            healerSpots = healerSpots - 1
        elseif not tank and not healer and damage then
            dpsSpots = dpsSpots - 1
        end
        if mainData and mainData.difficulty and charData and charData.difficulty and mainData.difficulty > charData.difficulty or 
            mainData and charData and mainData.difficulty == charData.difficulty and mainData.highestDifficultyKilledBosses > charData.highestDifficultyKilledBosses or
            mainData and charData and mainData.difficulty == charData.difficulty and mainData.bosskills > charData.bosskills then
            charData = mainData
        end
        if charData then
            if charData.difficulty > raidZone.difficulty then
                killedBosses = killedBosses + charData.highestDifficultyKilledBosses*charData.difficulty
            else
                killedBosses = killedBosses + charData.bosskills*difficulty
            end
        end
        ilvl = ilvl + itemLevel
        if specID and GFIO.db.profile.spec[specID] then
            specIDs = true
        end
    end 
    ilvl = ilvl/applicantInfo.numMembers
    if not maxAvailableBosses then
        if groupExceedsMembers then
            return 0, 0, ilvl, specIDs, false
        elseif tankSpots < 0 or healerSpots < 0 or dpsSpots < 0 then
            return 0, 0, ilvl, specIDs, false
        else
            return 0, 0, ilvl, specIDs, true
        end
    end
    -- this looks like magic but what we actually do is we just add all the killed bosses multiplied by their difficulty. 
    -- This means if you kill the last boss of a 8/8 raid on mythic it's "worth" 24 kills. 
    -- If we now want to go the other direction we divide total number of kills by max bosses 
    -- to get difficulty and use modulo to get amount of bosses killed on said difficulty.
    local avgKilledBosses = killedBosses/applicantInfo.numMembers % maxAvailableBosses
    local avgDifficulty = floor(killedBosses/applicantInfo.numMembers/maxAvailableBosses)
    if groupExceedsMembers then
        return avgKilledBosses, avgDifficulty, ilvl, specIDs, false
    elseif tankSpots < 0 or healerSpots < 0 or dpsSpots < 0 then
        return avgKilledBosses, avgDifficulty, ilvl, specIDs, false
    end
    return avgKilledBosses, avgDifficulty, ilvl, specIDs, true
end
---comment compares two different applicants to sort them by raid progress
---@param a number
---@param b number
---@return boolean
local function compareApplicantsRaid(a,b)
    local avgKilledBossesA, avgDifficultyA, ilvlA, specIDsA, CanFitA  = getProgressForApplication(a)
    local avgKilledBossesB, avgDifficultyB, ilvlB, specIDsB, CanFitB  = getProgressForApplication(b)
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
    if avgDifficultyA ~= avgDifficultyB then
        return GFIO.sortFunc(avgDifficultyA, avgDifficultyB)
    end
    if avgKilledBossesA == avgKilledBossesB then
        if ilvlA == ilvlB then
            return GFIO.sortFunc(a,b)
        end
        return GFIO.sortFunc(ilvlA,ilvlB)
    end
    return GFIO.sortFunc(avgKilledBossesA,avgKilledBossesB) 
end
---comment hooked to the sortApplicants function to calls compareApplicants to sort the applicants
---@param applicants table
local function sortApplications(applicants)
    if (not LFGListFrame.ApplicationViewer:IsShown()) or not GFIO.db.profile.sortApplicants then -- need to add checking for in dungeon queue
        return
    end
    local entryData = C_LFGList.GetActiveEntryInfo()
    local activityInfoTable= C_LFGList.GetActivityInfoTable(entryData.activityID)
    if activityInfoTable.categoryID == GROUP_FINDER_CATEGORY_ID_DUNGEONS then 
        table.sort(applicants, compareApplicantsDungeons)
    elseif activityInfoTable.categoryID == GROUP_FINDER_CATEGORY_ID_RAIDS then
        table.sort(applicants, compareApplicantsRaid)
    end
end
GFIO.sortApplications = sortApplications
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
---comment helper to update an application for dungeons
---@param member frame
---@param appID integer
---@param memberIdx integer
local function updateApplicationForDungeons(member, appID, memberIdx)
    local applicantInfo = C_LFGList.GetApplicantInfo(appID)
    local mainScore, score, itemLevel, specID, name, shortLanguage,_,_,_,isMainRole, raceID, keystoneList = getApplicantInfoForKeys(appID,memberIdx)
    if CustomNames then
        local customName = CustomNames.Get(name)
        if name ~= customName then
            member.Name:SetText(customName)
        end
    end
    if raceID and GFIO.db.profile.showRaceIcon then   
        local raceInfo = C_CreatureInfo.GetRaceInfo(raceID)
        member.Name:SetText(member.Name:GetText().." "..CreateAtlasMarkup("raceicon-"..raceInfo.clientFileString.."-female", 16, 16))
    end
    local ratingInfoFrame = getRatingInfoFrame(member)
    if not ratingInfoFrame then
        return
    end
    local additionalInfo = ""

    if GFIO.db.profile.showLanguage and shortLanguage and shortLanguage~="" then
        additionalInfo = shortLanguage
    end
    if (GFIO.db.profile.showKeyLevelApplicants) then
        local entryData = C_LFGList.GetActiveEntryInfo()
        local bestDungeonScoreForListing = C_LFGList.GetApplicantDungeonScoreForListing(appID, memberIdx, entryData.activityID)
        if bestDungeonScoreForListing and bestDungeonScoreForListing.bestRunLevel and bestDungeonScoreForListing.bestRunLevel >0 then
            local color = bestDungeonScoreForListing.finishedSuccess and GFIO.Color.TimedKeyColor or GFIO.Color.DepletedKeyColor
            local run = bestDungeonScoreForListing.bestRunLevel or 0
            local chestPrefix = ""
            for i= 1, bestDungeonScoreForListing.bestLevelIncrement do
                chestPrefix= chestPrefix.."+"
            end
            if chestPrefix ~= "" then
                run = chestPrefix.." "..run
            end
            local bestrunLevel = WrapTextInColorCode(run, color)
            additionalInfo = additionalInfo.." "..bestrunLevel
        end
    end
    if GFIO.db.profile.showTimedKeys and keystoneList then
        if GFIO.db.profile.showTimedKeys == 100 then
            if keystoneList.twentyPlus  and keystoneList.twentyPlus >0 then
                additionalInfo = additionalInfo.." ["..keystoneList.twentyPlus.." x 20+]"
            elseif keystoneList.fifteenPlus  and keystoneList.fifteenPlus >0 then
                additionalInfo = additionalInfo.." ["..keystoneList.fifteenPlus.." x 15+]"
            elseif keystoneList.tenPlus  and keystoneList.tenPlus >0 then
                additionalInfo = additionalInfo.." ["..keystoneList.tenPlus.." x 10+]"
            elseif keystoneList.fivePlus  and keystoneList.fivePlus >0 then
                additionalInfo = additionalInfo.." ["..keystoneList.fivePlus.." x 5+]"
            end
        elseif GFIO.db.profile.showTimedKeys == 20 and keystoneList.twentyPlus and keystoneList.twentyPlus >0 then
            additionalInfo = additionalInfo.." ["..keystoneList.twentyPlus.." x 20+]"
        elseif GFIO.db.profile.showTimedKeys == 15 and keystoneList.fifteenPlus and keystoneList.fifteenPlus >0 then
            additionalInfo = additionalInfo.." ["..keystoneList.fifteenPlus.." x 15+]"
        elseif GFIO.db.profile.showTimedKeys == 10 and keystoneList.tenPlus and keystoneList.tenPlus >0 then
            additionalInfo = additionalInfo.." ["..keystoneList.tenPlus.." x 10+]"
        elseif GFIO.db.profile.showTimedKeys == 5 and keystoneList.fivePlus and keystoneList.fivePlus >0 then
            additionalInfo = additionalInfo.." ["..keystoneList.fivePlus.." x 5+]"
        end
    end
    if additionalInfo ~= "" then
        ratingInfoFrame.AdditionalInfo:SetPoint("BOTTOM",member,"BOTTOM",0,0)
        ratingInfoFrame.AdditionalInfo:SetPoint("LEFT",member.Name,"LEFT",2,0)
        ratingInfoFrame.AdditionalInfo:SetPoint("RIGHT",member.RoleIcon1,"RIGHT",2,0)
        ratingInfoFrame.AdditionalInfo:SetText(additionalInfo) 
        member.Name:SetPoint("TOP",member,"TOP",0,0)
    else
        ratingInfoFrame.AdditionalInfo:SetText("") 
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
---comment helper to update an application for raids
---@param member frame
---@param appID integer
---@param memberIdx integer
local function updateApplicationForRaids(member, appID, memberIdx) 
    local applicantInfo = C_LFGList.GetApplicantInfo(appID)
    local entryData = C_LFGList.GetActiveEntryInfo()
    local maxBosses,charData,mainData, itemLevel, specID, name, shortLanguage, _, _, _ = getApplicantInfoForRaid(appID, memberIdx, entryData)
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
        additionalInfo = shortLanguage.. " "
    end
    if GFIO.RAIDS[entryData.activityID] then
        local raidZone = GFIO.RAIDS[entryData.activityID]
        local difficulty = raidZone.difficulty
        if charData and charData.bosskills and charData.bosskills~=0 and maxBosses and maxBosses ~=0 then
            additionalInfo = additionalInfo .. colorRaidProgress(charData.bosskills.."/"..maxBosses,difficulty).. " "
        end
        if GFIO.db.profile.addHighestDifficulty and charData and charData.difficulty and difficulty and charData.difficulty ~= difficulty and charData.highestDifficultyKilledBosses~= 0 then
            if charData.bosskills ~= 0 then
                additionalInfo = additionalInfo.. colorRaidProgress("("..charData.highestDifficultyKilledBosses.."/"..maxBosses..")", charData.difficulty).. " "
            else
                additionalInfo = additionalInfo.. colorRaidProgress(charData.highestDifficultyKilledBosses.."/"..maxBosses, charData.difficulty).. " "    
            end
            
        end
        if GFIO.db.profile.useMainInfo and GFIO.db.profile.addHighestDifficulty and mainData and mainData.difficulty and difficulty and mainData.difficulty >= difficulty and mainData.highestDifficultyKilledBosses~= 0 then
            additionalInfo = additionalInfo.. colorRaidProgress("["..mainData.highestDifficultyKilledBosses.."/"..maxBosses.."]", mainData.difficulty).. " "
        elseif GFIO.db.profile.useMainInfo and mainData and mainData.bosskills and mainData.bosskills~=0 and maxBosses and maxBosses ~=0 then
            additionalInfo = additionalInfo .. colorRaidProgress("["..mainData.bosskills.."/"..maxBosses.."]",difficulty).. " "
        end
    end
    if additionalInfo ~= "" then
        ratingInfoFrame.AdditionalInfo:SetPoint("BOTTOM",member,"BOTTOM",0,0)
        ratingInfoFrame.AdditionalInfo:SetPoint("LEFT",member.Name,"LEFT",2,0)
        ratingInfoFrame.AdditionalInfo:SetPoint("RIGHT",member.RoleIcon1,"RIGHT",2,0)
        ratingInfoFrame.AdditionalInfo:SetText(additionalInfo) 
        member.Name:SetPoint("TOP",member,"TOP",0,0)
    else
        ratingInfoFrame.AdditionalInfo:SetText("") 
    end
    ratingInfoFrame:SetParent(member)
    ratingInfoFrame:SetPoint("TOP",member,"TOP")
    ratingInfoFrame:SetPoint("RIGHT",member.RoleIcon1,"LEFT",-10,0)
    

    if GFIO.db.profile.showNote and applicantInfo.comment and applicantInfo.comment~="" then
        ratingInfoFrame.Note:Show()
        ratingInfoFrame.Note:SetPoint("RIGHT",member.RoleIcon1,"LEFT",-2,0)
    else
        ratingInfoFrame.Note:Hide()
    end
    ratingInfoFrame:Show()
end

---comment hooked to the updateApplicationListEntry function to adjust an application
---@param member frame
---@param appID number
---@param memberIdx number
local function updateApplicationListEntry(member, appID, memberIdx)
    local entryData = C_LFGList.GetActiveEntryInfo()
    local activityInfoTable= C_LFGList.GetActivityInfoTable(entryData.activityID)
    -- could maybe instead show something different we'll see
    if activityInfoTable.categoryID == GROUP_FINDER_CATEGORY_ID_DUNGEONS then 
        updateApplicationForDungeons(member, appID, memberIdx)
    elseif activityInfoTable.categoryID == GROUP_FINDER_CATEGORY_ID_RAIDS then
        updateApplicationForRaids(member, appID, memberIdx)
    end
    
end
local runningTimer
local function HandleSearchResultUpdated()
    runningTimer = nil
    if LFGListFrame.CategorySelection.selectedCategory == GROUP_FINDER_CATEGORY_ID_DUNGEONS then
        LFGListSearchPanel_UpdateResultList(LFGListFrame.SearchPanel)
    elseif LFGListFrame.CategorySelection.selectedCategory == GROUP_FINDER_CATEGORY_ID_RAIDS then
        LFGListSearchPanel_UpdateResultList(LFGListFrame.SearchPanel)
    end
end
 -- sometimes leaderinfo is not imediatly available so we have to resort. this is ass but what can you do
 local frame = CreateFrame("Frame", addonName .. "EventFrame")
 frame:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED")
 frame:SetScript("OnEvent", function(self, event, ...)
    if not PVEFrame:IsShown() or not LFGListFrame.SearchPanel:IsShown()or not GFIO.db.profile.sortGroupsByScore or not GFIO.db.profile.resortGroupsConstantly then
        return
    end
    if event == "LFG_LIST_SEARCH_RESULT_UPDATED" and (not runningTimer or runningTimer:IsCancelled()) then
        runningTimer = C_Timer.NewTimer(3,HandleSearchResultUpdated)
    end
 end)

--hooksecurefunc("LFGListSearchPanel_UpdateResults",sortSearchResults); -- This reorders to often so we don't do it
if PremadeGroupsFilter and PremadeGroupsFilter.OverwriteSortSearchResults then
    PremadeGroupsFilter.OverwriteSortSearchResults(addonName, sortSearchResults)
    hooksecurefunc("LFGListUtil_SortSearchResults",sortSearchResults);
else
    hooksecurefunc("LFGListSearchPanel_UpdateResultList",sortSearchResults); -- for some reason update results doesn't work on initial loading of the search results LFGListUtil_SortSearchResults
end
hooksecurefunc("LFGListSearchEntry_Update", updateLfgListEntry);
hooksecurefunc("LFGListUtil_SortApplicants", sortApplications);
hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", updateApplicationListEntry);

