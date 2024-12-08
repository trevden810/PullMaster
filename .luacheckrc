-- Global objects defined by WoW
globals = {
    "DEFAULT_CHAT_FRAME",
    "GetTime",
    "UnitName",
    "UnitGUID",
    "CreateFrame",
    "SlashCmdList",
    "SLASH_PULLMASTER1",
    "UIParent",
}

-- Ignore unused self parameter in methods
self = false

-- Globals that we write to
readwrite = {
    'PullMaster',
}

-- Files to ignore
exclude_files = {
    "libs/",
}

-- Relaxed WoW addon standards
max_line_length = 120
allow_defined_top = true
