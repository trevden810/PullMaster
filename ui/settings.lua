PullMaster.ui.settings = {}

function PullMaster.ui.settings:Initialize()
    local panel = CreateFrame("Frame", "PullMasterSettingsPanel")
    panel.name = "PullMaster"
    
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("PullMaster Settings")

    local minimapCheck = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    minimapCheck:SetPoint("TOPLEFT", 20, -50)
    minimapCheck.Text:SetText("Show Minimap Button")
    minimapCheck:SetChecked(PullMaster.config.showMinimap)
    minimapCheck:SetScript("OnClick", function(self)
        PullMaster.config.showMinimap = self:GetChecked()
        PullMaster:SaveConfig()
    end)

    InterfaceOptions_AddCategory(panel)
    self.panel = panel
end