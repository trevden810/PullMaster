-- PullMaster Core
PullMaster = {}
local addonName = "PullMaster"

function PullMaster:OnLoad()
    self.version = "1.0.0-beta"
    self.patrols = {}
    self.routes = {}
    self:InitializeUI()
    print(string.format("|cFF33FF99%s|r: Loaded version %s", addonName, self.version))
end

function PullMaster:InitializeUI()
    -- Create main frame
    self.mainFrame = CreateFrame("Frame", "PullMasterFrame", UIParent)
    self.mainFrame:SetSize(200, 100)
    self.mainFrame:SetPoint("CENTER")
    
    -- Add test button
    local button = CreateFrame("Button", nil, self.mainFrame, "UIPanelButtonTemplate")
    button:SetSize(100, 25)
    button:SetPoint("CENTER")
    button:SetText("Test Addon")
    button:SetScript("OnClick", function()
        self:TestFunction()
    end)
end

function PullMaster:TestFunction()
    print("PullMaster test function executed successfully!")
end

-- Event Frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        PullMaster:OnLoad()
    end
end)