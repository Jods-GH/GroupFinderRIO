local appName, GFIO = ...
local SharedMedia = LibStub("LibSharedMedia-3.0") 
---@type AceConfigOptionsTable
GFIO.options = {
  name = GFIO.getLocalisation("addonOptions"),
    type = "group",
    args = {
      sortAscending = {
        name = GFIO.getLocalisation("sortAscending"),
        desc = GFIO.getLocalisation("sortAscendingDescription"),
        order = 30,
        width = "full",
        type = "toggle",
        set = function(info,val)  GFIO.db.profile.sortAscending = val end, --Sets value of SavedVariables depending on toggles
        get = function(info)
            return  GFIO.db.profile.sortAscending --Sets value of toggles depending on SavedVariables 
        end,
      },
      useMainInfo = {
        name = GFIO.getLocalisation("useMainInfo"),
        desc = GFIO.getLocalisation("useMainInfoDescription"),
        order = 30,
        width = "full",
        type = "toggle",
        set = function(info,val)  GFIO.db.profile.useMainInfo = val end, --Sets value of SavedVariables depending on toggles
        get = function(info)
            return  GFIO.db.profile.useMainInfo --Sets value of toggles depending on SavedVariables 
        end,
      },
      showLanguage = {
        name = GFIO.getLocalisation("showLanguage"),
        desc = GFIO.getLocalisation("showLanguageDescription"),
        order = 30,
        width = "full",
        type = "toggle",
        set = function(info,val)  GFIO.db.profile.showLanguage = val end, --Sets value of SavedVariables depending on toggles
        get = function(info)
            return  GFIO.db.profile.showLanguage --Sets value of toggles depending on SavedVariables 
        end,
      },
      addHighestDifficulty = {
        name = GFIO.getLocalisation("addHighestDifficulty"),
        desc = GFIO.getLocalisation("addHighestDifficultyDescription"),
        order = 30,
        width = "full",
        type = "toggle",
        set = function(info,val)  GFIO.db.profile.addHighestDifficulty = val end, --Sets value of SavedVariables depending on toggles
        get = function(info)
            return  GFIO.db.profile.addHighestDifficulty --Sets value of toggles depending on SavedVariables 
        end,
      },
      
      applicantView = {
        name = GFIO.getLocalisation("applicantView"),
          type = "group",
          args = {
            showNote = {
              name = GFIO.getLocalisation("showNote"),
              desc = GFIO.getLocalisation("showNoteDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.showNote = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.showNote --Sets value of toggles depending on SavedVariables 
              end,
            },
            showKeyLevelApplicants = {
              name = GFIO.getLocalisation("showKeyLevelApplicants"),
              desc = GFIO.getLocalisation("showKeyLevelApplicantsDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.showKeyLevelApplicants = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.showKeyLevelApplicants --Sets value of toggles depending on SavedVariables 
              end,
            },
            sortApplicants = {
              name = GFIO.getLocalisation("sortApplicants"),
              desc = GFIO.getLocalisation("sortApplicantsDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.sortApplicants = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.sortApplicants --Sets value of toggles depending on SavedVariables 
              end,
            },
            useOfWrongRoleHighlight = {
              name = GFIO.getLocalisation("useOfWrongRoleHighlight"),
              desc = GFIO.getLocalisation("useOfWrongRoleHighlightDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.useOfWrongRoleHighlight = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.useOfWrongRoleHighlight --Sets value of toggles depending on SavedVariables 
              end,
            },
            wrongRoleScoreLimitForSorting= {
              name = GFIO.getLocalisation("wrongRoleScoreLimitForSorting"),
              desc = GFIO.getLocalisation("wrongRoleScoreLimitForSortingDescription"),
              order = 31,
              type = "range",
              softMin = 0,
              softMax = 5000,
              bigStep = 1,
              set = function(info,val)  
                GFIO.db.profile.wrongRoleScoreLimitForSorting = val
               end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.wrongRoleScoreLimitForSorting  --Sets value of toggles depending on SavedVariables 
              end  
            },           
            disableSpecSelector = {
              name = GFIO.getLocalisation("disableSpecSelector"),
              desc = GFIO.getLocalisation("disableSpecSelectorDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.disableSpecSelector = val GFIO.createOrShowSpecSelectFrame() end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.disableSpecSelector --Sets value of toggles depending on SavedVariables 
              end,
            },
            
                  
          }
      },
      groupView = {
        name = GFIO.getLocalisation("groupView"),
          type = "group",
          args = {
            addScoreToGroup = {
              name = GFIO.getLocalisation("addScoreToGroup"),
              desc = GFIO.getLocalisation("addScoreToGroupDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.addScoreToGroup = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.addScoreToGroup --Sets value of toggles depending on SavedVariables 
              end,
            },
            sortGroupsByScore = {
              name = GFIO.getLocalisation("sortGroupsByScore"),
              desc = GFIO.getLocalisation("sortGroupsByScoreDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.sortGroupsByScore = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.sortGroupsByScore --Sets value of toggles depending on SavedVariables 
              end,
            },
            showCurrentScoreInGroup = {
              name = GFIO.getLocalisation("showCurrentScoreInGroup"),
              desc = GFIO.getLocalisation("showCurrentScoreInGroupDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.showCurrentScoreInGroup = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.showCurrentScoreInGroup --Sets value of toggles depending on SavedVariables 
              end,
            },
            groupNameBeforeScore = {
              name = GFIO.getLocalisation("groupNameBeforeScore"),
              desc = GFIO.getLocalisation("groupNameBeforeScoreDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.groupNameBeforeScore = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.groupNameBeforeScore --Sets value of toggles depending on SavedVariables 
              end,
            },
            shortenActivityName = {
              name = GFIO.getLocalisation("shortenActivityName"),
              desc = GFIO.getLocalisation("shortenActivityNameDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.shortenActivityName = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.shortenActivityName --Sets value of toggles depending on SavedVariables 
              end,
            },
            showKeyLevelLeader = {
              name = GFIO.getLocalisation("showKeyLevelLeader"),
              desc = GFIO.getLocalisation("showKeyLevelLeaderDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.showKeyLevelLeader = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.showKeyLevelLeader --Sets value of toggles depending on SavedVariables 
              end,
            },
            showInfoInActivityName = {
              name = GFIO.getLocalisation("showInfoInActivityName"),
              desc = GFIO.getLocalisation("showInfoInActivityNameDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.showInfoInActivityName = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.showInfoInActivityName --Sets value of toggles depending on SavedVariables 
              end,
            },
            oneClickSignup = {
              name = GFIO.getLocalisation("oneClickSignup"),
              desc = GFIO.getLocalisation("oneClickSignupDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.oneClickSignup = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.oneClickSignup --Sets value of toggles depending on SavedVariables 
              end,
            },
          }
        }
  }
}
