-- 
-- player.lua
-- The player object
-- Manages player health, weapons, etc
-- Does not manage player movement and collisions
--

local Player = {}
Player.__index = Player

setmetatable (Player, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local PlayerCollider = require ("src.logic.physics.playercollider")
local Collisions = require ("src.logic.collisions")
local General = require ("src.logic.general")

--   END   --

function Player:_init (x, y)
    self.hitbox = PlayerCollider (x, y)
    self.blocksLight = false
    self.health = 100
    self.weaponType = 0
    self.access = 0
    self.hurt = 0
    self.heal = 0
    self.maxHealth = 100

    self.color = General.randomColor ()
    self.secondColor = General.randomFloatColor ()
end

function Player:takeDamage ()

end

function Player:render ()
    self.hitbox:render ()
end

function Player:update ()
    self.hitbox:act ()
end

function Player:floorCollision (floor)
    if (self.hitbox:intersects (floor.hitbox)) then
        Collisions.floorCollision (self, floor)
    end
end

return Player
