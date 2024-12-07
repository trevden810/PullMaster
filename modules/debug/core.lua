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

function Debug:Log(level, message, ...)
    if level <= self.debugLevel then
        local timestamp = date("%H:%M:%S")
        local formatted = string.format(message, ...)
        local colored = string.format("|cff%s%s|r", DEBUG_COLORS[level], formatted)
        local entry = string.format("%s: %s", timestamp, colored)
        
        table.insert(self.logs, entry)
        if #self.logs > self.maxLogs then
            table.remove(self.logs, 1)
        end
        
        if self.debugFrame:IsShown() then
            self:UpdateDebugDisplay()
        end
        
        -- Also print to chat if it's an error
        if level == Debug.LEVELS.ERROR then
            print("PullMaster Error: " .. formatted)
        end
    end
end

function Debug:HandleDebugCommand(input)
    if not input or input == "" then
        self:ToggleDebugFrame()
        return
    end
    
    local command, rest = strsplit(" ", input, 2)
    command = strlower(command)
    
    if command == "level" then
        local level = tonumber(rest)
        if level and level >= 1 and level <= 5 then
            self:SetDebugLevel(level)
            self:Log(Debug.LEVELS.INFO, "Debug level set to: " .. level)
        end
    elseif command == "test" then
        self:RunTests(rest)
    elseif command == "profile" then
        self:ToggleProfiling()
    end
end