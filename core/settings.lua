local addonName, PM = ...

function PM:InitializeSettings()
    self.optionsTable = {
        type = "group",
        name = "PullMaster",
        handler = PM,
        args = {
            general = {
                type = "group",
                name = "General",
                order = 1,
                args = {
                    performanceHeader = {
                        type = "header",
                        name = "Performance Settings",
                        order = 1,
                    },
                    updateRate = {
                        type = "range",
                        name = "Update Rate",
                        desc = "How often the display updates (in seconds)",
                        min = 0.1,
                        max = 1.0,
                        step = 0.1,
                        order = 2,
                        get = function(info)
                            return PM.db.profile.performance.updateRate
                        end,
                        set = function(info, value)
                            PM.db.profile.performance.updateRate = value
                            PM:UpdateDisplayRate()
                        end,
                    },
                    showFPS = {
                        type = "toggle",
                        name = "Show FPS",
                        desc = "Show FPS counter in the corner",
                        order = 3,
                        get = function(info)
                            return PM.db.profile.performance.showFPS
                        end,
                        set = function(info, value)
                            PM.db.profile.performance.showFPS = value
                            PM:ToggleFPSDisplay()
                        end,
                    },
                },
            },
            visual = {
                type = "group",
                name = "Visual",
                order = 2,
                args = {
                    visualHeader = {
                        type = "header",
                        name = "Visual Settings",
                        order = 1,
                    },
                    showBossMarkers = {
                        type = "toggle",
                        name = "Show Boss Markers",
                        desc = "Show or hide boss markers on the tactical map",
                        order = 2,
                        get = function(info)
                            return PM.db.profile.visual.showBossMarkers
                        end,
                        set = function(info, value)
                            PM.db.profile.visual.showBossMarkers = value
                            PM:UpdateVisuals()
                        end,
                    },
                    showPullRoutes = {
                        type = "toggle",
                        name = "Show Pull Routes",
                        desc = "Show or hide planned pull routes",
                        order = 3,
                        get = function(info)
                            return PM.db.profile.visual.showPullRoutes
                        end,
                        set = function(info, value)
                            PM.db.profile.visual.showPullRoutes = value
                            PM:UpdateVisuals()
                        end,
                    },
                },
            },
        },
    }
    
    -- Register settings
    LibStub("AceConfig-3.0"):RegisterOptionsTable("PullMaster", self.optionsTable)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PullMaster")
end