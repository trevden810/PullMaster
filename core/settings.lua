PullMaster.settings = {}

function PullMaster.settings:Initialize()
    self.defaults = {
        minimap = { hide = false },
        patrols = { enabled = true },
        routes = { enabled = true }
    }
    
    PullMasterCharDB = PullMasterCharDB or self.defaults
    self.current = PullMasterCharDB
end