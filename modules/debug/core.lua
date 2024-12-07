local addonName, PM = ...
local Debug = PM:NewModule("Debug", "AceConsole-3.0")

-- Debug levels
Debug.LEVELS = {
    ERROR = 1,
    WARN = 2,
    INFO = 3,
    DEBUG = 4,
    TRACE = 5
}

-- Color coding for debug levels
local DEBUG_COLORS = {
    [Debug.LEVELS.ERROR] = "FF0000", -- Red
    [Debug.LEVELS.WARN] = "FFA500",  -- Orange
    [Debug.LEVELS.INFO] = "00FF00",  -- Green
    [Debug.LEVELS.DEBUG] = "ADD8E6", -- Light Blue
    [Debug.LEVELS.TRACE] = "808080"  -- Gray
}

function Debug:OnInitialize()
    self.debugLevel = Debug.LEVELS.INFO
    self.logs = {}
    self.maxLogs = 1000
    
    -- Register slash commands
    self:RegisterChatCommand("pmtest", "HandleDebugCommand")
    
    -- Create debug frame
    self:CreateDebugFrame()
end