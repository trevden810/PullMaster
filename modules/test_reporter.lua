local addonName, PM = ...
local TestReporter = PM:NewModule("TestReporter", "AceEvent-3.0")

-- Classic UI compatible colors
local COLORS = {
    SUCCESS = "|cFF00FF00",  -- Green
    FAILURE = "|cFFFF0000",  -- Red
    WARNING = "|cFFFFFF00",  -- Yellow
    INFO = "|cFF69CCF0",     -- Light Blue
    RESET = "|r"
}

function TestReporter:OnInitialize()
    self:CreateReportFrame()
    self.testResults = {}
    self.currentSuite = nil
end

function TestReporter:CreateReportFrame()
    -- Create main frame using Classic UI elements
    local f = CreateFrame("Frame", "PullMasterTestReport", UIParent)
    f:SetWidth(500)
    f:SetHeight(400)
    f:SetPoint("CENTER")
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()

    -- Title text
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 15, -15)
    title:SetText("PullMaster Test Results")

    -- Create scroll frame using Classic elements
    local sf = CreateFrame("ScrollFrame", "PullMasterTestReportScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", 12, -32)
    sf:SetPoint("BOTTOMRIGHT", -30, 40)

    local content = CreateFrame("Frame")
    content:SetSize(455, 800)
    sf:SetScrollChild(content)

    -- Results text
    local text = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOPLEFT")
    text:SetPoint("TOPRIGHT")
    text:SetJustifyH("LEFT")
    text:SetSpacing(3)

    -- Close button (using Classic style)
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)

    -- Export button
    local export = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    export:SetSize(80, 22)
    export:SetPoint("BOTTOMRIGHT", -10, 10)
    export:SetText("Export")
    export:SetScript("OnClick", function() self:ExportResults() end)

    self.frame = f
    self.content = content
    self.text = text
end

function TestReporter:StartTestSuite(suiteName)
    self.currentSuite = {
        name = suiteName,
        startTime = GetTime(),
        tests = {},
        passed = 0,
        failed = 0,
        warnings = 0
    }
end

function TestReporter:RecordTestResult(testName, passed, details)
    if not self.currentSuite then return end

    table.insert(self.currentSuite.tests, {
        name = testName,
        passed = passed,
        details = details,
        duration = debugprofilestop(),
        memory = collectgarbage("count")
    })

    if passed then
        self.currentSuite.passed = self.currentSuite.passed + 1
    else
        self.currentSuite.failed = self.currentSuite.failed + 1
    end

    self:UpdateDisplay()
end

function TestReporter:EndTestSuite()
    if not self.currentSuite then return end

    self.currentSuite.endTime = GetTime()
    self.currentSuite.duration = self.currentSuite.endTime - self.currentSuite.startTime

    table.insert(self.testResults, self.currentSuite)
    self.currentSuite = nil

    self:UpdateDisplay()
end

function TestReporter:UpdateDisplay()
    if not self.text then return end

    local lines = {}

    -- Display current suite if active
    if self.currentSuite then
        table.insert(lines, self:FormatSuite(self.currentSuite))
    end

    -- Display previous results
    for _, suite in ipairs(self.testResults) do
        table.insert(lines, self:FormatSuite(suite))
    end

    self.text:SetText(table.concat(lines, "\n"))
end

function TestReporter:FormatSuite(suite)
    local lines = {}
    
    -- Suite header
    table.insert(lines, string.format("%s%s%s", 
        COLORS.INFO,
        suite.name,
        COLORS.RESET
    ))

    -- Suite statistics
    table.insert(lines, string.format("Tests: %d Passed: %s%d%s Failed: %s%d%s Duration: %.2fs",
        #suite.tests,
        COLORS.SUCCESS, suite.passed, COLORS.RESET,
        COLORS.FAILURE, suite.failed, COLORS.RESET,
        suite.duration or 0
    ))

    -- Individual test results
    for _, test in ipairs(suite.tests) do
        local status = test.passed and 
            COLORS.SUCCESS.."✓"..COLORS.RESET or 
            COLORS.FAILURE.."✗"..COLORS.RESET

        table.insert(lines, string.format("%s %s (%.2fms)",
            status,
            test.name,
            test.duration or 0
        ))

        if test.details then
            table.insert(lines, "  "..test.details)
        end
    end

    return table.concat(lines, "\n")
end

function TestReporter:ExportResults()
    -- Create export frame
    local f = CreateFrame("Frame", "PullMasterTestExport", UIParent)
    f:SetSize(500, 400)
    f:SetPoint("CENTER")
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })

    -- Create EditBox for copying
    local eb = CreateFrame("EditBox", nil, f)
    eb:SetMultiLine(true)
    eb:SetFontObject(ChatFontNormal)
    eb:SetWidth(470)
    eb:SetHeight(370)
    eb:SetPoint("TOPLEFT", 15, -15)
    eb:SetText(self:GenerateExportText())
    eb:HighlightText()
    eb:SetFocus(true)
    eb:SetScript("OnEscapePressed", function() f:Hide() end)

    f:Show()
end

function TestReporter:GenerateExportText()
    local lines = {
        "PullMaster Test Results Export",
        string.format("Generated: %s", date("%Y-%m-%d %H:%M:%S")),
        ""
    }

    for _, suite in ipairs(self.testResults) do
        table.insert(lines, string.format("Test Suite: %s", suite.name))
        table.insert(lines, string.format("Duration: %.2f seconds", suite.duration or 0))
        table.insert(lines, string.format("Pass Rate: %.1f%%", 
            (suite.passed / #suite.tests) * 100))
        table.insert(lines, "")

        for _, test in ipairs(suite.tests) do
            table.insert(lines, string.format("%s - %s",
                test.passed and "PASS" or "FAIL",
                test.name
            ))
            if test.details then
                table.insert(lines, "  " .. test.details)
            end
        end
        table.insert(lines, "")
    end

    return table.concat(lines, "\n")
end

-- Slash command handler
SLASH_COMMANDS = {
    ["report"] = function()
        TestReporter:ToggleReport()
    end,
    ["export"] = function()
        TestReporter:ExportResults()
    end,
    ["clear"] = function()
        wipe(TestReporter.testResults)
        TestReporter:UpdateDisplay()
    end
}

function TestReporter:ToggleReport()
    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self:UpdateDisplay()
        self.frame:Show()
    end
end