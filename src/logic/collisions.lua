-- 
-- collisions.lua
-- General collision math
-- Includes general collisions and specific collision functions
--

local Collisions = {}
Collisions.__index = Collisions

-- MODULES --

local Constants = require ("src.logic.general")

--   END   --

Collisions.__hWiggleConst = 0.1 / Constants.TERMINAL_HORIZONTAL
Collisions.__vWiggleConst = 0.1 / Constants.TERMINAL_VERTICAL

function Collisions.floorCollision (self, floor)
    local cols = self.hitbox:collision (floor.hitbox)

    local hWiggle = Collisions.__hWiggleConst * self.hitbox.vSpeed
    local vWiggle = Collisions.__vWiggleConst * self.hitbox.hSpeed

    if hWiggle < 0 then
        hWiggle = hWiggle * -1
    end

    if vWiggle < 0 then
        vWiggle = vWiggle * -1
    end

    if cols [Constants.Directions.DOWN] then
        if self.hitbox.x > (floor.hitbox.x + floor.hitbox.width - hWiggle) then
            self.hitbox.x = floor.hitbox.x + floor.hitbox.width
        elseif self.hitbox.x < (floor.hitbox.x - self.hitbox.width + hWiggle) then
            self.hitbox.x = floor.hitbox.x - self.hitbox.width
        else
            self.hitbox.grounded = true
            self.hitbox.y = floor.hitbox.y - self.hitbox.height
            self.hitbox:setFloor (floor)
        end
    end

    if cols [Constants.Directions.LEFT] then
        if (self.hitbox.y + self.hitbox.height) < (floor.hitbox.y + vWiggle) then
            self.hitbox.y = floor.hitbox.y - self.hitbox.height
        elseif self.hitbox.y > (floor.hitbox.y + floor.hitbox.height - vWiggle) then
            self.hitbox.y = floor.hitbox.y + floor.hitbox.height
        else
            self.hitbox.leftWall = true
            self.hitbox.grip = true
            self.hitbox.x = floor.hitbox.x + floor.hitbox.width
        end
    end

    if cols [Constants.Directions.RIGHT] then
        if (self.hitbox.y + self.hitbox.height) < (floor.hitbox.y + vWiggle) then
            self.hitbox.y = floor.hitbox.y - self.hitbox.height
        elseif self.hitbox.y > (floor.hitbox.y + floor.hitbox.height - vWiggle) then
            self.hitbox.y = floor.hitbox.y + floor.hitbox.height
        else
            self.hitbox.rightWall = true
            self.hitbox.grip = true
            self.hitbox.x = floor.hitbox.x - self.hitbox.width
        end
    end

    if cols [Constants.Directions.UP] then
        if self.hitbox.x > (floor.hitbox.x + floor.hitbox.width - hWiggle) then
            self.hitbox.x = floor.hitbox.x + floor.hitbox.width
        elseif self.hitbox.x < (floor.hitbox.x - self.hitbox.width + hWiggle) then
            self.hitbox.x = floor.hitbox.x - self.hitbox.width
        else
            self.hitbox.roof = true
            self.hitbox.y = floor.hitbox.y + floor.hitbox.height
        end
    end
end

return Collisions
