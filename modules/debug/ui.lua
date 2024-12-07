local addonName, PM = ...
local Debug = PM:GetModule("Debug")

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