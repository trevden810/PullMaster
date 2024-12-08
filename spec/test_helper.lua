-- Mock WoW API functions
_G.DEFAULT_CHAT_FRAME = {
    AddMessage = function() end
}

_G.GetTime = function()
    return 0
}

_G.UnitName = function(unit)
    return "TestPlayer"

end

_G.UnitGUID = function(unit)
    return "Player-1234"
end

_G.CreateFrame = function(type, name, parent)
    return {
        type = type,
        name = name,
        parent = parent,
        SetPoint = function() end,
        SetSize = function() end,
        Show = function() end,
        Hide = function() end
    }
end

-- Test helper functions
function assertTableEquals(t1, t2)
    if type(t1) ~= 'table' or type(t2) ~= 'table' then
        error("Both arguments must be tables")
    end
    
    for k, v in pairs(t1) do
        if type(v) == 'table' then
            assertTableEquals(v, t2[k])
        else
            assert(v == t2[k], string.format("Values differ at key %s: %s ~= %s", k, tostring(v), tostring(t2[k])))
        end
    end
    
    for k, v in pairs(t2) do
        assert(t1[k] ~= nil, string.format("Key %s exists in t2 but not in t1", k))
    end
end
