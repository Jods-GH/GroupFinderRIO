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
      useMainScore = {
        name = GFIO.getLocalisation("useMainScore"),
        desc = GFIO.getLocalisation("useMainScoreDescription"),
        order = 30,
        width = "full",
        type = "toggle",
        set = function(info,val)  GFIO.db.profile.useMainScore = val end, --Sets value of SavedVariables depending on toggles
        get = function(info)
            return  GFIO.db.profile.useMainScore --Sets value of toggles depending on SavedVariables 
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
            showKeyLevel = {
              name = GFIO.getLocalisation("showKeyLevel"),
              desc = GFIO.getLocalisation("showKeyLevelDescription"),
              order = 30,
              width = "full",
              type = "toggle",
              set = function(info,val)  GFIO.db.profile.showKeyLevel = val end, --Sets value of SavedVariables depending on toggles
              get = function(info)
                  return  GFIO.db.profile.showKeyLevel --Sets value of toggles depending on SavedVariables 
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
          }
        }
  }
}
