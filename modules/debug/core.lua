PullMaster.debug = {}

function PullMaster.debug:Log(message)
    if PullMaster.config.debugMode then
        print("|cFF33FF99PullMaster Debug:|r", message)
    end
end