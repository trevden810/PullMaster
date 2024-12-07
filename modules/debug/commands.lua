local addonName, PM = ...
local Debug = PM:GetModule("Debug")

function Debug:SetupSlashCommands()
    self:RegisterChatCommand("pmtest", "HandleDebugCommand")
    self:RegisterChatCommand("pmdebug", "HandleDebugCommand")
 end

function Debug:ClearLogs()
    wipe(self.logs)
    self:UpdateDebugDisplay()
end

function Debug:ExportLogs()
    -- Create export frame
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