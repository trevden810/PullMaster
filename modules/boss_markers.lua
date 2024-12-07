local addonName, PM = ...
local BossMarkers = PM:NewModule("BossMarkers", "AceEvent-3.0")

function BossMarkers:OnInitialize()
    self.activeMarkers = {}
    self.frame = self:CreateMarkerFrame()
end

function BossMarkers:CreateMarkerFrame()
    local f = CreateFrame("Frame", "PullMasterBossMarkers", UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetAllPoints()
    f:Hide()
    return f
end

function BossMarkers:CreateBossMarker(bossData)
    local marker = CreateFrame("Frame", nil, self.frame)
    marker:SetSize(24, 24)
    
    -- Base icon
    local icon = marker:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
    
    -- Position indicator
    local x = bossData.position.x * self.frame:GetWidth()
    local y = bossData.position.y * self.frame:GetHeight()
    marker:SetPoint("CENTER", self.frame, "BOTTOMLEFT", x, y)
    
    -- Add tooltip
    marker:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(bossData.name, 1, 0.82, 0)
        
        if bossData.level then
            GameTooltip:AddLine(string.format("Level %d", bossData.level), 1, 1, 1)
        end
        
        if bossData.abilities then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Abilities:")
            for _, ability in ipairs(bossData.abilities) do
                local cooldown = ability.cooldown and string.format(" (CD: %ds)", ability.cooldown) or ""
                GameTooltip:AddLine(string.format("- %s%s", ability.name, cooldown), 0.82, 0.82, 0.82)
            end
        end
        
        if bossData.tips then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Tips:")
            for _, tip in ipairs(bossData.tips) do
                GameTooltip:AddLine(string.format("- %s", tip), 0, 1, 0)
            end
        end
        
        GameTooltip:Show()
    end)
    
    marker:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- Store reference
    self.activeMarkers[bossData.id] = marker
    
    return marker
end

function BossMarkers:AddBoss(bossData)
    self:CreateBossMarker(bossData)
end

function BossMarkers:RemoveBoss(bossID)
    local marker = self.activeMarkers[bossID]
    if marker then
        marker:Hide()
        marker:SetParent(nil)
        self.activeMarkers[bossID] = nil
    end
end

function BossMarkers:Show()
    self.frame:Show()
end

function BossMarkers:Hide()
    self.frame:Hide()
end

function BossMarkers:Toggle()
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end