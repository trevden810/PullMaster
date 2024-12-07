local addonName, PM = ...
local TacticalMap = PM:NewModule("TacticalMap", "AceEvent-3.0")

function TacticalMap:OnInitialize()
    self.activeMarkers = {}
    self.patrolPaths = {}
    self.frame = self:CreateMapFrame()
end

function TacticalMap:CreateMapFrame()
    local f = CreateFrame("Frame", "PullMasterTacticalMap", UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetAllPoints()
    f:Hide()
    
    -- Create the markers layer
    local markers = CreateFrame("Frame", nil, f)
    markers:SetAllPoints()
    f.markers = markers
    
    -- Create the paths layer
    local paths = CreateFrame("Frame", nil, f)
    paths:SetAllPoints()
    paths:SetFrameLevel(markers:GetFrameLevel() - 1)
    f.paths = paths
    
    return f
end

function TacticalMap:CreateMarker(position, markerType)
    local marker = CreateFrame("Frame", nil, self.frame.markers)
    marker:SetSize(16, 16)
    
    local texture = marker:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints()
    
    -- Use appropriate texture based on marker type
    if markerType == "boss" then
        texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
    elseif markerType == "patrol" then
        texture:SetTexture("Interface\\Minimap\\PartyRaidBlips")
        texture:SetTexCoord(0, 0.125, 0, 0.125)
    elseif markerType == "safe" then
        texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
    end
    
    -- Set position
    local x = position.x * self.frame:GetWidth()
    local y = position.y * self.frame:GetHeight()
    marker:SetPoint("CENTER", self.frame, "BOTTOMLEFT", x, y)
    
    return marker
end

function TacticalMap:CreatePatrolPath(points)
    local path = {}
    
    -- Create line segments between points
    for i = 1, #points - 1 do
        local line = self.frame.paths:CreateLine(nil, "ARTWORK")
        line:SetThickness(2)
        
        -- Convert coordinates
        local x1 = points[i].x * self.frame:GetWidth()
        local y1 = points[i].y * self.frame:GetHeight()
        local x2 = points[i+1].x * self.frame:GetWidth()
        local y2 = points[i+1].y * self.frame:GetHeight()
        
        line:SetStartPoint("BOTTOMLEFT", x1, y1)
        line:SetEndPoint("BOTTOMLEFT", x2, y2)
        line:SetColorTexture(1, 1, 0, 0.5) -- Yellow, semi-transparent
        
        table.insert(path, line)
    end
    
    return path
end

function TacticalMap:AddPatrol(patrolData)
    -- Create patrol marker
    local marker = self:CreateMarker(patrolData.points[1], "patrol")
    
    -- Create patrol path
    local path = self:CreatePatrolPath(patrolData.points)
    
    -- Store references
    self.activeMarkers[patrolData.id] = marker
    self.patrolPaths[patrolData.id] = path
    
    -- Start patrol animation
    self:AnimatePatrol(patrolData)
end

function TacticalMap:AnimatePatrol(patrolData)
    local marker = self.activeMarkers[patrolData.id]
    if not marker then return end
    
    local function UpdatePosition(progress)
        local pointIndex = math.floor(progress * (#patrolData.points - 1)) + 1
        local nextIndex = pointIndex % #patrolData.points + 1
        
        local currentPoint = patrolData.points[pointIndex]
        local nextPoint = patrolData.points[nextIndex]
        
        -- Interpolate between points
        local subProgress = (progress * (#patrolData.points - 1)) % 1
        local x = currentPoint.x + (nextPoint.x - currentPoint.x) * subProgress
        local y = currentPoint.y + (nextPoint.y - currentPoint.y) * subProgress
        
        marker:SetPoint("CENTER", self.frame, "BOTTOMLEFT", 
            x * self.frame:GetWidth(), 
            y * self.frame:GetHeight())
    end
    
    -- Create timer for patrol animation
    local elapsed = 0
    marker:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + delta
        if elapsed >= patrolData.period then
            elapsed = 0
        end
        
        local progress = elapsed / patrolData.period
        UpdatePosition(progress)
    end)
end

function TacticalMap:Show()
    self.frame:Show()
end

function TacticalMap:Hide()
    self.frame:Hide()
end

function TacticalMap:Toggle()
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end