PullMaster.config = {
    showMinimap = true,
    showPatrols = true,
    showBossMarkers = true,
    debugMode = false
}

function PullMaster:LoadConfig()
    PullMasterDB = PullMasterDB or self.config
    self.config = PullMasterDB
end

function PullMaster:SaveConfig()
    PullMasterDB = self.config
end