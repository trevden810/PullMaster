SLASH_PULLMASTER1 = "/pullmaster"
SLASH_PULLMASTER2 = "/pm"

SlashCmdList["PULLMASTER"] = function(msg)
    msg = msg:lower()
    if msg == "" or msg == "config" then
        PullMaster:ShowOptions()
    elseif msg == "help" then
        print("|cFF33FF99PullMaster|r commands:")
        print("/pm or /pullmaster - Open options")
        print("/pm help - Show this help message")
    end
end