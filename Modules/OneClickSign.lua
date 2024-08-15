local _, GFIO  = ...

local isHooked = false;

GFIO.hookFunc = function()
    hooksecurefunc("LFGListSearchEntry_OnClick", function (self, button)
        if not GFIO.db.profile.oneClickSignup then return end
        local panel = LFGListFrame.SearchPanel
        if button == "LeftButton" and LFGListSearchPanelUtil_CanSelectResult(self.resultID) and 
        LFGListFrame.SearchPanel.ScrollBox:IsVisible() == true and 
        panel.SignUpButton:IsEnabled() and LFGListFrame.SearchPanel.ScrollBox:IsMouseOver() == true then
            if panel.selectedResult ~= self.resultID then
                LFGListSearchPanel_SelectResult(panel, self.resultID)
            end
            LFGListSearchPanel_SignUp(panel)
        end
    end)
    LFGListApplicationDialog:HookScript("OnShow", function(self)
        if not GFIO.db.profile.oneClickSignup then return end
        if self.SignUpButton:IsEnabled() and not IsShiftKeyDown() and LFGListFrame.SearchPanel.ScrollBox:IsVisible() == true 
                and LFGListFrame.SearchPanel.ScrollBox:IsMouseOver() == true  then
            self.SignUpButton:Click()
        end
    end)
end