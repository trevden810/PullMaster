local addonName, PM = ...
local TestConfig = {
    -- Test environment settings
    ENVIRONMENT = {
        DEBUG_LEVEL = PM.Debug.LEVELS.DEBUG,
        ENABLE_PROFILING = true,
        LOG_TO_FILE = true,
    },
    
    -- Test data
    TEST_PATROLS = {
        LINEAR = {
            points = {
                {x = 0.1, y = 0.1},
                {x = 0.2, y = 0.1},
                {x = 0.3, y = 0.1},
                {x = 0.2, y = 0.1},
                {x = 0.1, y = 0.1}
            },
            period = 10,  -- seconds
            mob_id = 657  -- Defias Watchman
        },
        CIRCULAR = {
            points = {
                {x = 0.5, y = 0.5},
                {x = 0.6, y = 0.5},
                {x = 0.6, y = 0.6},
                {x = 0.5, y = 0.6},
                {x = 0.5, y = 0.5}
            },
            period = 15,  -- seconds
            mob_id = 660  -- Defias Overseer
        }
    },
    
    -- Performance thresholds
    PERFORMANCE = {
        MAX_UPDATE_TIME = 1,     -- milliseconds
        MAX_MEMORY_USAGE = 1024,  -- KB
        FRAME_TIME_WARNING = 16   -- milliseconds (targeting 60 fps)
    },
    
    -- Test scenarios
    SCENARIOS = {
        BASIC = {
            name = "Basic Patrol Detection",
            description = "Tests basic patrol pattern detection",
            setup = function()
                -- Setup code
            end,
            run = function()
                -- Test implementation
            end,
            cleanup = function()
                -- Cleanup code
            end
        },
        PERFORMANCE = {
            name = "Performance Test",
            description = "Tests performance under load",
            setup = function()
                PM:GetModule("Profiler"):Enable()
            end,
            run = function()
                -- Generate load
                for i = 1, 100 do
                    local patrol = TestConfig.TEST_PATROLS.LINEAR
                    PM:GetModule("PatrolAnalyzer"):AnalyzePatrol(patrol)
                end
            end,
            cleanup = function()
                PM:GetModule("Profiler"):PrintStats()
                PM:GetModule("Profiler"):Disable()
            end
        },
        STRESS = {
            name = "Stress Test",
            description = "Tests behavior under extreme conditions",
            setup = function()
                -- Setup stress test
            end,
            run = function()
                -- Stress test implementation
            end,
            cleanup = function()
                -- Cleanup
            end
        }
    },
    
    -- Assertion helpers
    Assert = {
        approximatelyEqual = function(a, b, tolerance)
            tolerance = tolerance or 0.001
            return math.abs(a - b) <= tolerance
        end,
        
        patternMatches = function(detected, expected)
            if detected.type ~= expected.type then
                return false, string.format("Pattern type mismatch: expected %s, got %s",
                    expected.type, detected.type)
            end
            
            if not TestConfig.Assert.approximatelyEqual(detected.period, expected.period, 0.5) then
                return false, string.format("Period mismatch: expected %.2f, got %.2f",
                    expected.period, detected.period)
            end
            
            return true
        end,
        
        performanceWithinLimits = function(stats)
            local maxTime = stats.maxTime or 0
            if maxTime > TestConfig.PERFORMANCE.MAX_UPDATE_TIME then
                return false, string.format("Performance exceeded limits: %.2fms (max allowed: %.2fms)",
                    maxTime, TestConfig.PERFORMANCE.MAX_UPDATE_TIME)
            end
            return true
        end
    }
}

return TestConfig