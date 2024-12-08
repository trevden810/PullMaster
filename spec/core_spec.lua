describe("PullMaster Core", function()
    local PullMaster
    
    setup(function()
        require("test_helper")
        PullMaster = require("../src/core")
    end)
    
    before_each(function()
        -- Reset state before each test
        PullMaster:Reset()
    end)
    
    describe("Initialization", function()
        it("should initialize with default values", function()
            assert.is_table(PullMaster.options)
            assert.is_table(PullMaster.patrols)
            assert.is_table(PullMaster.routes)
        end)
    end)
    
    describe("Patrol Tracking", function()
        it("should add a new patrol", function()
            local patrol = {
                id = "mob-1",
                name = "Test Mob",
                path = {{x = 0, y = 0}, {x = 10, y = 10}}
            }
            
            PullMaster:AddPatrol(patrol)
            
            assert.equals(1, #PullMaster.patrols)
            assert.same(patrol, PullMaster.patrols[1])
        end)
        
        it("should remove a patrol", function()
            local patrol = {
                id = "mob-1",
                name = "Test Mob",
                path = {{x = 0, y = 0}, {x = 10, y = 10}}
            }
            
            PullMaster:AddPatrol(patrol)
            PullMaster:RemovePatrol("mob-1")
            
            assert.equals(0, #PullMaster.patrols)
        end)
    end)
    
    describe("Route Planning", function()
        it("should calculate safe pull route", function()
            local start = {x = 0, y = 0}
            local target = {x = 20, y = 20}
            local patrols = {
                {
                    id = "mob-1",
                    path = {{x = 10, y = 10}, {x = 10, y = 0}}
                }
            }
            
            local route = PullMaster:CalculateRoute(start, target, patrols)
            
            assert.is_table(route)
            assert.is_true(#route > 0)
        end)
    end)
    
    describe("Options Management", function()
        it("should save and load options", function()
            local newOptions = {
                showPatrols = true,
                showRoutes = false,
                minimapButton = true
            }
            
            PullMaster:SaveOptions(newOptions)
            local loaded = PullMaster:LoadOptions()
            
            assert.same(newOptions, loaded)
        end)
    end)
end)