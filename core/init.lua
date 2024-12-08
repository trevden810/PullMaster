PullMaster = PullMaster or {}
local addonName = "PullMaster"

function PullMaster:OnInitialize()
    self.version = "1.0.0"
    self:InitializeModules()
    self:InitializeCommands()
    print("|cFF33FF99PullMaster|r: Loaded version " .. self.version)
end

function PullMaster:InitializeModules()
    -- Initialize all modules
    if self.tactical_map then self.tactical_map:Initialize() end
    if self.boss_markers then self.boss_markers:Initialize() end
    if self.route_planner then self.route_planner:Initialize() end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "PullMaster" then
        PullMaster:OnInitialize()
    end
end)