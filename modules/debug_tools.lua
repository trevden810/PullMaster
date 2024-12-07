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

function Debug:CreateDebugFrame()
    local f = CreateFrame("Frame", "PullMasterDebugFrame", UIParent, "BackdropTemplate")
    f:SetSize(500, 400)
    f:SetPoint("CENTER")
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11},
    })
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()
    
    -- Add title
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("PullMaster Debug")
    
    -- Add scrollframe for logs
    local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", 12, -40)
    sf:SetPoint("BOTTOMRIGHT", -30, 40)
    
    local content = CreateFrame("Frame", nil, sf)
    content:SetSize(400, 1000)
    sf:SetScrollChild(content)
    
    -- Text display
    local text = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOPLEFT")
    text:SetJustifyH("LEFT")
    text:SetWidth(400)
    
    -- Close button
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)
    
    -- Control buttons
    local clear = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    clear:SetSize(80, 22)
    clear:SetPoint("BOTTOMLEFT", 12, 10)
    clear:SetText("Clear")
    clear:SetScript("OnClick", function() self:ClearLogs() end)
    
    local export = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    export:SetSize(80, 22)
    export:SetPoint("LEFT", clear, "RIGHT", 5, 0)
    export:SetText("Export")
    export:SetScript("OnClick", function() self:ExportLogs() end)
    
    self.debugFrame = f
    self.logText = text
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

function Debug:UpdateDebugDisplay()
    if not self.logText then return end
    self.logText:SetText(table.concat(self.logs, "\n"))
end

function Debug:ToggleDebugFrame()
    if self.debugFrame:IsShown() then
        self.debugFrame:Hide()
    else
        self:UpdateDebugDisplay()
        self.debugFrame:Show()
    end
end

function Debug:ClearLogs()
    wipe(self.logs)
    self:UpdateDebugDisplay()
end

function Debug:ExportLogs()
    -- Create a frame for copying logs
    local f = CreateFrame("Frame", "PullMasterExportFrame", UIParent, "BackdropTemplate")
    f:SetSize(500, 400)
    f:SetPoint("CENTER")
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11},
    })
    
    local eb = CreateFrame("EditBox", nil, f)
    eb:SetMultiLine(true)
    eb:SetFontObject(ChatFontNormal)
    eb:SetWidth(470)
    eb:SetHeight(370)
    eb:SetPoint("TOPLEFT", 15, -15)
    eb:SetText(table.concat(self.logs, "\n"))
    eb:HighlightText()
    eb:SetFocus(true)
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
    
    f:Show()
end