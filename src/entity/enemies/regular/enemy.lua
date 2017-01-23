-- 
-- enemy.lua
--

local Enemy = {}
Enemy.__index = Enemy

Enemy.__TYPES = {GROUNDED = 1, FLYING = 2, WATER = 3}

local Creature = require ("src.entity.enemies.creature")

setmetatable (Enemy, {
    __index = Creature,
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Collider = require ("src.logic.physics.collider")

--   END   --

function Enemy:_init (gravityDir)
    self.gravity = gravityDir
    self.enemyType = Enemy.__TYPES.GROUNDED

    self.maxHealth = General.randomInt (150) + 50
    self.contactDamage = (General.randomInt (11) + 3) * -1
    self.health = self.maxHealth

    self.hitbox = Collider ()
end

function Enemy:update (dt)

end

function Enemy:render ()
    self.hitbox:render ()
end

function Enemy:AI ()
    --self.ai:act ()
end

function Enemy:collision (object)

end

return Enemy
