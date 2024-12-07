local addonName, PM = ...

-- Default settings
PM.defaults = {
    profile = {
        performance = {
            updateRate = 0.5,
            showFPS = true,
        },
        visual = {
            showBossMarkers = true,
            showPullRoutes = true,
            useClassColors = true,
            opacity = 0.8,
        },
        sound = {
            enableAlerts = true,
            volume = 0.7,
        },
        minimap = {
            hide = false,
        },
    },
}

-- Slash commands
SLASH_COMMANDS = {
    ["help"] = function()
        PM:Print("PullMaster commands:")
        PM:Print("/pm config - Open configuration")
        PM:Print("/pm toggle - Show/hide main window")
        PM:Print("/pm route - Start route planning")
    end,
    ["config"] = function()
        PM:OpenSettings()
    end,
    ["toggle"] = function()
        PM:ToggleMainWindow()
    end,
    ["route"] = function()
        PM:StartRoutePlanning()
    end,
}

SLASH_PM1 = "/pm"
SLASH_PM2 = "/pullmaster"

SlashCmdList["PULLMASTER"] = function(msg)
    local command = strlower(msg)
    if SLASH_COMMANDS[command] then
        SLASH_COMMANDS[command]()
    else
        SLASH_COMMANDS["help"]()
    end
end