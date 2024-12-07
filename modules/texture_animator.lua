local addonName, PM = ...
local TextureAnimator = PM:NewModule("TextureAnimator")

-- Animation presets
TextureAnimator.ANIMATION_TYPES = {
    ROTATE = "rotate",
    PULSE = "pulse",
    FADE = "fade",
    BOUNCE = "bounce",
    PATROL = "patrol"
}

-- Animation defaults
local defaults = {
    rotate = {
        duration = 2,
        degrees = 360
    },
    pulse = {
        duration = 1,
        minScale = 0.8,
        maxScale = 1.2
    },
    fade = {
        duration = 1,
        minAlpha = 0.3,
        maxAlpha = 1.0
    },
    bounce = {
        duration = 1,
        height = 10
    },
    patrol = {
        duration = 4,
        width = 50
    }
}

function TextureAnimator:CreateAnimation(frame, texture, animType, options)
    if not frame or not texture then return end
    
    options = options or {}
    local settings = {}
    for k, v in pairs(defaults[animType] or {}) do
        settings[k] = options[k] or v
    end
    
    local ag = texture:CreateAnimationGroup()
    
    if animType == self.ANIMATION_TYPES.ROTATE then
        local rotation = ag:CreateAnimation("Rotation")
        rotation:SetDuration(settings.duration)
        rotation:SetDegrees(settings.degrees)
        rotation:SetOrigin("CENTER", 0, 0)
        
    elseif animType == self.ANIMATION_TYPES.PULSE then
        local grow = ag:CreateAnimation("Scale")
        grow:SetDuration(settings.duration/2)
        grow:SetScale(settings.maxScale, settings.maxScale)
        grow:SetOrder(1)
        
        local shrink = ag:CreateAnimation("Scale")
        shrink:SetDuration(settings.duration/2)
        shrink:SetScale(1/settings.maxScale, 1/settings.maxScale)
        shrink:SetOrder(2)
        
    elseif animType == self.ANIMATION_TYPES.FADE then
        local fadeOut = ag:CreateAnimation("Alpha")
        fadeOut:SetDuration(settings.duration/2)
        fadeOut:SetFromAlpha(settings.maxAlpha)
        fadeOut:SetToAlpha(settings.minAlpha)
        fadeOut:SetOrder(1)
        
        local fadeIn = ag:CreateAnimation("Alpha")
        fadeIn:SetDuration(settings.duration/2)
        fadeIn:SetFromAlpha(settings.minAlpha)
        fadeIn:SetToAlpha(settings.maxAlpha)
        fadeIn:SetOrder(2)
        
    elseif animType == self.ANIMATION_TYPES.BOUNCE then
        local up = ag:CreateAnimation("Translation")
        up:SetDuration(settings.duration/2)
        up:SetOffset(0, settings.height)
        up:SetOrder(1)
        
        local down = ag:CreateAnimation("Translation")
        down:SetDuration(settings.duration/2)
        down:SetOffset(0, -settings.height)
        down:SetOrder(2)
        
    elseif animType == self.ANIMATION_TYPES.PATROL then
        local right = ag:CreateAnimation("Translation")
        right:SetDuration(settings.duration/2)
        right:SetOffset(settings.width, 0)
        right:SetOrder(1)
        
        local left = ag:CreateAnimation("Translation")
        left:SetDuration(settings.duration/2)
        left:SetOffset(-settings.width, 0)
        left:SetOrder(2)
    end
    
    ag:SetLooping("REPEAT")
    return ag
end

-- Patrol specific animations for mobs
function TextureAnimator:CreatePatrolAnimation(frame, path, options)
    if not frame or not path or #path < 2 then return end
    
    local ag = frame:CreateAnimationGroup()
    local totalDuration = options.duration or (#path * 2)
    local segmentDuration = totalDuration / #path
    
    for i = 1, #path do
        local currentPoint = path[i]
        local nextPoint = path[i % #path + 1]
        
        local translation = ag:CreateAnimation("Translation")
        translation:SetDuration(segmentDuration)
        translation:SetOrder(i)
        
        -- Calculate offset from current to next point
        local xOffset = nextPoint.x - currentPoint.x
        local yOffset = nextPoint.y - currentPoint.y
        translation:SetOffset(xOffset, yOffset)
        
        -- Optional smooth movement
        if options.smooth then
            translation:SetSmoothing("IN_OUT")
        end
    end
    
    ag:SetLooping("REPEAT")
    return ag
end

-- Warning indicators for boss abilities
function TextureAnimator:CreateWarningAnimation(frame, abilityType)
    local ag = frame:CreateAnimationGroup()
    
    if abilityType == "cast" then
        -- Cast bar animation
        local grow = ag:CreateAnimation("Scale")
        grow:SetDuration(0.2)
        grow:SetScale(1.2, 1.2)
        grow:SetOrder(1)
        
        local shrink = ag:CreateAnimation("Scale")
        shrink:SetDuration(0.2)
        shrink:SetScale(1/1.2, 1/1.2)
        shrink:SetOrder(2)
        
    elseif abilityType == "aoe" then
        -- AoE warning animation
        local fadeIn = ag:CreateAnimation("Alpha")
        fadeIn:SetDuration(0.5)
        fadeIn:SetFromAlpha(0)
        fadeIn:SetToAlpha(0.8)
        fadeIn:SetOrder(1)
        
        local fadeOut = ag:CreateAnimation("Alpha")
        fadeOut:SetDuration(0.5)
        fadeOut:SetFromAlpha(0.8)
        fadeOut:SetToAlpha(0)
        fadeOut:SetOrder(2)
    end
    
    ag:SetLooping("REPEAT")
    return ag
end

-- Performance optimized animation updates
function TextureAnimator:OnUpdate(elapsed)
    -- Only update visible animations
    for frame, animations in pairs(self.activeAnimations) do
        if frame:IsVisible() then
            for _, anim in pairs(animations) do
                if anim.elapsed then
                    anim.elapsed = anim.elapsed + elapsed
                    if anim.elapsed >= anim.duration then
                        anim.elapsed = 0
                        if anim.onLoop then
                            anim:onLoop()
                        end
                    end
                end
            end
        end
    end
end