function PullMaster:ShowOptions()
    if not self.ui.settings.panel then
        self.ui.settings:Initialize()
    end
    
    InterfaceOptionsFrame_OpenToCategory("PullMaster")
    InterfaceOptionsFrame_OpenToCategory("PullMaster")
end