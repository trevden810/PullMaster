PullMaster.ui = {}

function PullMaster.ui:Initialize()
    self.mainFrame = CreateFrame("Frame", "PullMasterMainFrame", UIParent)
    self.mainFrame:SetSize(300, 200)
    self.mainFrame:SetPoint("CENTER")
    
    local button = CreateFrame("Button", nil, self.mainFrame, "UIPanelButtonTemplate")
    button:SetSize(100, 25)
    button:SetPoint("CENTER")
    button:SetText("Test PullMaster")
    button:SetScript("OnClick", function()
        PullMaster:ShowOptions()
    end)
end