local function getScoreForLeader(searchResult)
    local leaderName = searchResult.leaderName
    local leaderFullName = leaderName:find("-")~=nil and leaderName or leaderName.."-"..GetNormalizedRealmName()
    local faction = searchResult.leaderFactionGroup
    local score = 0
    if RaiderIO.GetProfile(leaderFullName,faction) then
        local profile = RaiderIO.GetProfile(leaderFullName,faction)
        score = profile.mythicKeystoneProfile.mainCurrentScore and profile.mythicKeystoneProfile.mainCurrentScore>0 or profile.mythicKeystoneProfile.currentScore
    else
        score = searchResult.leaderOverallDungeonScore or 0 
    end
    return score
end

local function updateLfgListEntry(entry, ...)
    local searchResultID = entry.GetData().resultID
    local searchResult = C_LFGList.GetSearchResultInfo(searchResultID)
    if (not LFGListFrame.SearchPanel:IsShown() or searchResult.categoryID ~= DUNGEON_CATEGORY_ID or not searchResult.leaderName) then
        return
    end
    local score = getScoreForLeader(searchResult)
    local r,g,b,a = RaiderIO.GetScoreColor(score)
    local color = CreateColor(r,g,b,a)
    local colorHexString = color:GenerateHexColor()
    local coloredScore = WrapTextInColorCode(score, colorHexString)
    entry.Name:SetText(coloredScore .. "   -    ".. entry.Name:GetText())
end
local function compareSearchEntries(a,b)
    return getScoreForLeader(C_LFGList.GetSearchResultInfo(a)) > getScoreForLeader(C_LFGList.GetSearchResultInfo(b))
end
local DUNGEON_CATEGORY_ID = 2
local function sortSearchResults(results)
    if (not LFGListFrame.SearchPanel:IsShown()) or results.categoryID ~= DUNGEON_CATEGORY_ID then
        return
    end
    DevTool:AddData(results,"results")
    table.sort(results.results , compareSearchEntries)
end

local frame = CreateFrame("Frame")
hooksecurefunc("LFGListSearchEntry_Update", updateLfgListEntry);
hooksecurefunc("LFGListUtil_SortSearchResults",sortSearchResults);
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent",function(self,event,...)
    if event == "LFG_LIST_SEARCH_RESULT_UPDATED" then
        local searchResultID = ...
        print("----------------")
        print(searchResultID)
        print(getScoreForLeader(C_LFGList.GetSearchResultInfo(searchResultID)))
    
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
