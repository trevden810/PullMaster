local addonName, PM = ...
local Settings = PM:NewModule("Settings")

function Settings:OnInitialize()
    self:CreateSettingsPanel()
end

function Settings:CreateSettingsPanel()
    local panel = CreateFrame("Frame", "PullMasterSettingsPanel")
    panel.name = "PullMaster"
    
    -- Title
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("PullMaster Settings")
    
    -- Performance section
    local perfHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    perfHeader:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    perfHeader:SetText("Performance Settings")
    
    -- Update rate slider
    local updateSlider = CreateFrame("Slider", "PullMasterUpdateSlider", panel, "OptionsSliderTemplate")
    updateSlider:SetPoint("TOPLEFT", perfHeader, "BOTTOMLEFT", 0, -40)
    updateSlider:SetMinMaxValues(0.1, 1.0)
    updateSlider:SetValueStep(0.1)
    updateSlider:SetWidth(200)
    updateSlider:SetObeyStepOnDrag(true)
    
    _G[updateSlider:GetName() .. "Text"]:SetText("Update Rate")
    _G[updateSlider:GetName() .. "Low"]:SetText("0.1")
    _G[updateSlider:GetName() .. "High"]:SetText("1.0")
    
    updateSlider:SetScript("OnValueChanged", function(self, value)
        PM.db.profile.performance.updateRate = value
        PM:UpdateDisplayRate()
    end)
    
    -- Visual Settings section
    local visualHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    visualHeader:SetPoint("TOPLEFT", updateSlider, "BOTTOMLEFT", 0, -40)
    visualHeader:SetText("Visual Settings")
    
    -- Show Boss Markers checkbox
    local bossMarkers = CreateFrame("CheckButton", "PullMasterBossMarkers", panel, "InterfaceOptionsCheckButtonTemplate")
    bossMarkers:SetPoint("TOPLEFT", visualHeader, "BOTTOMLEFT", 0, -20)
    _G[bossMarkers:GetName() .. "Text"]:SetText("Show Boss Markers")
    
    bossMarkers:SetScript("OnClick", function(self)
        PM.db.profile.visual.showBossMarkers = self:GetChecked()
        PM:UpdateVisuals()
    end)
    
    -- Show Pull Routes checkbox
    local pullRoutes = CreateFrame("CheckButton", "PullMasterPullRoutes", panel, "InterfaceOptionsCheckButtonTemplate")
    pullRoutes:SetPoint("TOPLEFT", bossMarkers, "BOTTOMLEFT", 0, -10)
    _G[pullRoutes:GetName() .. "Text"]:SetText("Show Pull Routes")
    
    pullRoutes:SetScript("OnClick", function(self)
        PM.db.profile.visual.showPullRoutes = self:GetChecked()
        PM:UpdateVisuals()
    end)
    
    -- Use Class Colors checkbox
    local classColors = CreateFrame("CheckButton", "PullMasterClassColors", panel, "InterfaceOptionsCheckButtonTemplate")
    classColors:SetPoint("TOPLEFT", pullRoutes, "BOTTOMLEFT", 0, -10)
    _G[classColors:GetName() .. "Text"]:SetText("Use Class Colors")
    
    classColors:SetScript("OnClick", function(self)
        PM.db.profile.visual.useClassColors = self:GetChecked()
        PM:UpdateVisuals()
    end)
    
    -- Opacity slider
    local opacitySlider = CreateFrame("Slider", "PullMasterOpacitySlider", panel, "OptionsSliderTemplate")
    opacitySlider:SetPoint("TOPLEFT", classColors, "BOTTOMLEFT", 0, -40)
    opacitySlider:SetMinMaxValues(0.1, 1.0)
    opacitySlider:SetValueStep(0.1)
    opacitySlider:SetWidth(200)
    opacitySlider:SetObeyStepOnDrag(true)
    
    _G[opacitySlider:GetName() .. "Text"]:SetText("UI Opacity")
    _G[opacitySlider:GetName() .. "Low"]:SetText("0.1")
    _G[opacitySlider:GetName() .. "High"]:SetText("1.0")
    
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        PM.db.profile.visual.opacity = value
        PM:UpdateVisuals()
    end)
    
    -- Profile section
    local profileHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    profileHeader:SetPoint("TOPLEFT", opacitySlider, "BOTTOMLEFT", 0, -40)
    profileHeader:SetText("Profile Management")
    
    -- Export Profile button
    local exportButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    exportButton:SetPoint("TOPLEFT", profileHeader, "BOTTOMLEFT", 0, -20)
    exportButton:SetText("Export Profile")
    exportButton:SetWidth(120)
    exportButton:SetHeight(25)
    
    exportButton:SetScript("OnClick", function()
        PM:ExportProfile()
    end)
    
    -- Import Profile button
    local importButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    importButton:SetPoint("LEFT", exportButton, "RIGHT", 10, 0)
    importButton:SetText("Import Profile")
    importButton:SetWidth(120)
    importButton:SetHeight(25)
    
    importButton:SetScript("OnClick", function()
        PM:ImportProfile()
    end)
    
    -- Load initial values
    self:LoadSettings(panel)
    
    -- Add to interface options
    InterfaceOptions_AddCategory(panel)
    self.panel = panel
end

function Settings:LoadSettings(panel)
    -- Update all controls to reflect current settings
    _G["PullMasterUpdateSlider"]:SetValue(PM.db.profile.performance.updateRate)
    _G["PullMasterBossMarkers"]:SetChecked(PM.db.profile.visual.showBossMarkers)
    _G["PullMasterPullRoutes"]:SetChecked(PM.db.profile.visual.showPullRoutes)
    _G["PullMasterClassColors"]:SetChecked(PM.db.profile.visual.useClassColors)
    _G["PullMasterOpacitySlider"]:SetValue(PM.db.profile.visual.opacity)
end

function Settings:OpenSettings()
    InterfaceOptionsFrame_OpenToCategory(self.panel)
end