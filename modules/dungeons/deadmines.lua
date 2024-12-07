local addonName, PM = ...
local Deadmines = PM:NewModule("Deadmines", "AceEvent-3.0")

-- Dungeon Constants
Deadmines.INFO = {
    mapID = 36,      -- Deadmines map ID
    minLevel = 17,
    maxLevel = 26,
    location = "Westfall",
    entrance = {x = 42.6, y = 71.8}  -- Westfall coordinates
}

-- Patrol Data
Deadmines.PATROLS = {
    ENTRANCE_GUARDS = {
        mobID = 634,    -- Defias Miner
        count = 2,      -- Usually patrol in pairs
        level = 19,
        paths = {
            {
                -- Full patrol path from entrance
                {x = 0.231, y = 0.642},  -- Start near entrance
                {x = 0.278, y = 0.621},  -- Check first alcove
                {x = 0.312, y = 0.589},  -- Turn at corner
                {x = 0.278, y = 0.621},  -- Return path
                {x = 0.231, y = 0.642}   -- Back to start
            },
            period = 45  -- Seconds for full patrol route
        }
    },
    
    FOUNDRY_PATROL = {
        mobID = 636,    -- Defias Blacksmith
        count = 1,
        level = 20,
        paths = {
            {
                {x = 0.456, y = 0.523},  -- Start at forge
                {x = 0.478, y = 0.534},  -- Check workbench
                {x = 0.489, y = 0.512},  -- Check supplies
                {x = 0.478, y = 0.534},  -- Return path
                {x = 0.456, y = 0.523}   -- Back to forge
            },
            period = 30
        }
    },
    
    GOBLIN_PATROL = {
        mobID = 642,    -- Sneed's Shredder
        count = 1,
        level = 23,
        paths = {
            {
                {x = 0.567, y = 0.478},  -- Start position
                {x = 0.589, y = 0.456},  -- Check machinery
                {x = 0.601, y = 0.467},  -- Patrol endpoint
                {x = 0.589, y = 0.456},  -- Return path
                {x = 0.567, y = 0.478}   -- Back to start
            },
            period = 35
        }
    }
}

-- Boss Data
Deadmines.BOSSES = {
    RHAHKZOR = {
        id = 644,
        name = "Rhahk'zor",
        level = 22,
        position = {x = 0.345, y = 0.567},
        abilities = {
            {name = "Knockdown", cooldown = 12},
        },
        tips = {
            "Tank him away from the patrol path",
            "Interrupt Knockdown when possible",
            "Pull nearby miners first"
        }
    },
    
    SNEED = {
        id = 642,
        name = "Sneed",
        level = 23,
        position = {x = 0.589, y = 0.478},
        abilities = {
            {name = "Disarm", cooldown = 15},
            {name = "Calling for Help", cooldown = 30}
        },
        tips = {
            "Clear ALL nearby goblins first",
            "Tank with back to wall to prevent adds",
            "Save interrupts for Call for Help"
        }
    },
    
    VANCLEEF = {
        id = 639,
        name = "Edwin VanCleef",
        level = 25,
        position = {x = 0.712, y = 0.445},
        abilities = {
            {name = "Thrash", cooldown = 10},
            {name = "Call Adds", phase = 2}
        },
        tips = {
            "Clear ENTIRE room before pull",
            "Tank him in corner away from stairs",
            "Save cooldowns for phase 2",
            "Kill adds quickly when they spawn"
        }
    }
}

-- Safe Spots (positions where you can safely stop)
Deadmines.SAFE_SPOTS = {
    ENTRANCE = {
        {x = 0.223, y = 0.645, note = "Safe spot before first patrol"},
        {x = 0.267, y = 0.623, note = "Alcove after first corner"}
    },
    FOUNDRY = {
        {x = 0.445, y = 0.523, note = "Safe corner before blacksmith"},
        {x = 0.478, y = 0.545, note = "Behind forge"}
    },
    GOBLIN = {
        {x = 0.556, y = 0.478, note = "Safe spot before Sneed"},
        {x = 0.589, y = 0.489, note = "Corner near machinery"}
    }
}

function Deadmines:OnInitialize()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self.activePatrols = {}
end

function Deadmines:OnEnable()
    self:CheckLocation()
end

function Deadmines:PLAYER_ENTERING_WORLD()
    self:CheckLocation()
end

function Deadmines:ZONE_CHANGED_NEW_AREA()
    self:CheckLocation()
end

function Deadmines:CheckLocation()
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID == self.INFO.mapID then
        self:StartTracking()
    else
        self:StopTracking()
    end
end