-- 
-- creature.lua
--

local Creature = {}
Creature.__index = Creature

--[[setmetatable (Creature, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end.
})]]

-- MODULES --

--   END   --

function Creature:setHealth (health)
    if (health > self.maxHealth) then
        self.health = self.maxHealth
    else
        self.health = health
    end
end

function Creature:changeHealth (health)
    self.health = self.health + health
    
    if (self.health > self.maxHealth) then
        self.health = self.maxHealth
    end
end

function Creature:alive ()
    return (self.health > 0)
end

function Creature:dead ()
    return (self.health <= 0)
end

return Creature
