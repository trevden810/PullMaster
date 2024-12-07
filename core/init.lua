local addonName, PM = ...
PM = LibStub("AceAddon-3.0"):NewAddon("PullMaster", "AceEvent-3.0")

function PM:OnInitialize()
    -- Initialize saved variables
    self.db = LibStub("AceDB-3.0"):New("PullMasterDB", self.defaults)
    
    -- Initialize modules
    self:InitializeModules()
    
    -- Load settings
    self:InitializeSettings()
end

function PM:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:Print("PullMaster loaded! Type /pm for options.")
end

function PM:InitializeModules()
    -- Initialize core modules
    self.tacticalMap = self:GetModule("TacticalMap")
    self.bossMarkers = self:GetModule("BossMarkers")
    self.routePlanner = self:GetModule("RoutePlanner")
end