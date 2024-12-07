local addonName, PM = ...
local Profiler = PM:NewModule("Profiler", "AceConsole-3.0")

function Profiler:OnInitialize()
    self.profiles = {}
    self.activeProfiles = {}
    self.isEnabled = false
end

function Profiler:StartProfiling(name)
    if not self.isEnabled then return end
    
    self.activeProfiles[name] = {
        startTime = debugprofilestop(),
        calls = 0
    }
end

function Profiler:StopProfiling(name)
    if not self.isEnabled then return end
    
    local profile = self.activeProfiles[name]
    if profile then
        local duration = debugprofilestop() - profile.startTime
        profile.calls = profile.calls + 1
        
        if not self.profiles[name] then
            self.profiles[name] = {
                totalTime = 0,
                calls = 0,
                maxTime = 0,
                minTime = math.huge
            }
        end
        
        local stats = self.profiles[name]
        stats.totalTime = stats.totalTime + duration
        stats.calls = stats.calls + 1
        stats.maxTime = math.max(stats.maxTime, duration)
        stats.minTime = math.min(stats.minTime, duration)
        
        self.activeProfiles[name] = nil
    end
end

function Profiler:GetStats()
    local stats = {}
    for name, profile in pairs(self.profiles) do
        stats[name] = {
            averageTime = profile.totalTime / profile.calls,
            totalTime = profile.totalTime,
            calls = profile.calls,
            maxTime = profile.maxTime,
            minTime = profile.minTime
        }
    end
    return stats
end

function Profiler:ResetStats()
    wipe(self.profiles)
    wipe(self.activeProfiles)
end

function Profiler:Enable()
    self.isEnabled = true
    PM:GetModule("Debug"):Log(PM.Debug.LEVELS.INFO, "Profiler enabled")
end

function Profiler:Disable()
    self.isEnabled = false
    self:ResetStats()
    PM:GetModule("Debug"):Log(PM.Debug.LEVELS.INFO, "Profiler disabled")
end

function Profiler:Toggle()
    if self.isEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Profiler:PrintStats()
    local Debug = PM:GetModule("Debug")
    local stats = self:GetStats()
    
    Debug:Log(Debug.LEVELS.INFO, "Performance Profile Results:")
    Debug:Log(Debug.LEVELS.INFO, "%-30s %10s %10s %10s %10s %10s",
        "Name", "Calls", "Total(ms)", "Avg(ms)", "Min(ms)", "Max(ms)")
    Debug:Log(Debug.LEVELS.INFO, string.rep("-", 80))
    
    for name, data in pairs(stats) do
        Debug:Log(Debug.LEVELS.INFO, "%-30s %10d %10.2f %10.2f %10.2f %10.2f",
            name,
            data.calls,
            data.totalTime,
            data.averageTime,
            data.minTime,
            data.maxTime)
    end
end

-- Profile decorator for functions
function Profiler:ProfileFunction(name, func)
    if not self.isEnabled then return func end
    
    return function(...)
        self:StartProfiling(name)
        local results = {func(...)}
        self:StopProfiling(name)
        return unpack(results)
    end
end

-- Usage example:
-- local function to_profile = Profiler:ProfileFunction("PatternAnalysis", PatternAnalysis)
-- to_profile()  -- Will be profiled
