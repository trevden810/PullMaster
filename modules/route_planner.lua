local addonName, PM = ...
local RoutePlanner = PM:NewModule("RoutePlanner", "AceEvent-3.0")

function RoutePlanner:OnInitialize()
    self.activeRoute = {}
    self.savedRoutes = {}
    self.frame = self:CreatePlannerFrame()
end

function RoutePlanner:CreatePlannerFrame()
    local f = CreateFrame("Frame", "PullMasterRoutePlanner", UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetAllPoints()
    f:Hide()
    
    -- Create the route layer
    local routes = CreateFrame("Frame", nil, f)
    routes:SetAllPoints()
    f.routes = routes
    
    -- Add click handling for route creation
    f:EnableMouse(true)
    f:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            local x, y = GetCursorPosition()
            local scale = self:GetEffectiveScale()
            x = x / scale / self:GetWidth()
            y = y / scale / self:GetHeight()
            RoutePlanner:AddRoutePoint({x = x, y = y})
        end
    end)
    
    return f
end

function RoutePlanner:AddRoutePoint(position)
    -- Create point marker
    local marker = self:CreateRouteMarker(position)
    
    -- Add to current route
    table.insert(self.activeRoute, {
        position = position,
        marker = marker
    })
    
    -- Update route visualization
    self:UpdateRouteVisualization()
end

function RoutePlanner:CreateRouteMarker(position)
    local marker = CreateFrame("Frame", nil, self.frame.routes)
    marker:SetSize(8, 8)
    
    local texture = marker:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints()
    texture:SetTexture("Interface\\Minimap\\PartyRaidBlips")
    texture:SetTexCoord(0, 0.125, 0, 0.125)
    
    -- Set position
    local x = position.x * self.frame:GetWidth()
    local y = position.y * self.frame:GetHeight()
    marker:SetPoint("CENTER", self.frame, "BOTTOMLEFT", x, y)
    
    -- Add interaction
    marker:EnableMouse(true)
    marker:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            RoutePlanner:RemoveRoutePoint(position)
        end
    end)
    
    return marker
end

function RoutePlanner:RemoveRoutePoint(position)
    for i, point in ipairs(self.activeRoute) do
        if point.position.x == position.x and point.position.y == position.y then
            point.marker:Hide()
            point.marker:SetParent(nil)
            table.remove(self.activeRoute, i)
            break
        end
    end
    
    self:UpdateRouteVisualization()
end

function RoutePlanner:UpdateRouteVisualization()
    -- Clear existing lines
    for _, child in ipairs({self.frame.routes:GetChildren()}) do
        if child.isRouteLine then
            child:Hide()
            child:SetParent(nil)
        end
    end
    
    -- Draw lines between points
    for i = 1, #self.activeRoute - 1 do
        local startPoint = self.activeRoute[i].position
        local endPoint = self.activeRoute[i + 1].position
        
        local line = self.frame.routes:CreateLine(nil, "ARTWORK")
        line.isRouteLine = true
        line:SetThickness(2)
        
        local x1 = startPoint.x * self.frame:GetWidth()
        local y1 = startPoint.y * self.frame:GetHeight()
        local x2 = endPoint.x * self.frame:GetWidth()
        local y2 = endPoint.y * self.frame:GetHeight()
        
        line:SetStartPoint("BOTTOMLEFT", x1, y1)
        line:SetEndPoint("BOTTOMLEFT", x2, y2)
        line:SetColorTexture(0, 0.7, 1, 0.6) -- Light blue, semi-transparent
    end
end

function RoutePlanner:SaveRoute(name)
    if #self.activeRoute < 2 then return end
    
    local route = {
        name = name or string.format("Route %d", #self.savedRoutes + 1),
        points = {},
        timestamp = time()
    }
    
    for _, point in ipairs(self.activeRoute) do
        table.insert(route.points, point.position)
    end
    
    table.insert(self.savedRoutes, route)
    
    -- Save to saved variables
    if not PM.db.char.savedRoutes then
        PM.db.char.savedRoutes = {}
    end
    table.insert(PM.db.char.savedRoutes, route)
end

function RoutePlanner:LoadRoute(index)
    local route = self.savedRoutes[index]
    if not route then return end
    
    -- Clear current route
    self:ClearRoute()
    
    -- Load saved route
    for _, point in ipairs(route.points) do
        self:AddRoutePoint(point)
    end
end

function RoutePlanner:ClearRoute()
    for _, point in ipairs(self.activeRoute) do
        if point.marker then
            point.marker:Hide()
            point.marker:SetParent(nil)
        end
    end
    
    wipe(self.activeRoute)
    self:UpdateRouteVisualization()
end

function RoutePlanner:Show()
    self.frame:Show()
end

function RoutePlanner:Hide()
    self.frame:Hide()
end

function RoutePlanner:Toggle()
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end