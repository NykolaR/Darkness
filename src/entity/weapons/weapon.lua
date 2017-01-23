-- 
-- weapon.lua
--

local Weapon = {}
Weapon.__index = Weapon

setmetatable (Weapon, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

Weapon.__TYPES = {MELEE = 1, PROJECTILE = 2, SHIELD = 3, BURST = 4}

-- MODULES --

local General = require ("src.logic.general")
local Collider = require ("src.logic.physics.collider")

--   END   --

--
-- Initialization function
-- If copy arg is a number:
--      Creates a weapon to be copied from
--      Sets the host (the player)
--      Primary key affects what it will generate into
--
-- If copy arg is a Weapon:
--      Copies that weapons properties into a new weapon (for use in-game)
function Weapon:_init (copy, host, primaryKey)
    if type (copy) == "number" then
        self:_firstInit (copy, host, primaryKey)
    else
        self:_copy (copy)
    end
end

-- Creates a weapon to be cloned
function Weapon:_firstInit (seed, host, primaryKey)
        self.colorOne, self.colorTwo = Weapon.getColors (seed)
        self.host = host
        self.active = false
        self.hitbox = Collider (0, 0, 0.5, 0.5)

        if primaryKey then
            self:_primaryKey (seed, host)
        else
            self:_melee (seed, host)
        end
end

-- Clones a weapon
function Weapon:_copy (copy)
    self.parent = copy
    
    self.host = copy.host
    self.active = false
    if self.hitbox then
        self.hitbox.x, self.hitbox.y = 0, 0
    else
        self.hitbox = Collider (0, 0, 0.5, 0.5)
    end
    self.hitbox.width, self.hitbox.height = copy.hitbox.width, copy.hitbox.height
end

-- Generates a primary key weapon
function Weapon:_primaryKey (seed, host)
    -- NOT MELEE
    -- Can be projectile, shield, burst (...)
    
    self.dX = 0.3
end

-- Generates a non-primary weapon
function Weapon:_melee (seed, host)

end

-- Returns the (first) color of the weapon
-- This would be the door color of a primary key
function Weapon.getColor (seed)
    General.setSeed (seed)
    return General.randomColor ()
end

-- Returns the first & second color of the weapon
function Weapon.getColors (seed)
    General.setSeed (seed)
    return General.randomColor (), General.randomFloatColor ()
end

-- Weapon update call
-- Possibly changes based on the type of the weapon (given by Weapon.__TYPES)
function Weapon:update (dt)
    self.hitbox:setLastPosition ()
    self.hitbox:moveX (self.dX)
end

-- Render call
-- Possibly changes based on the type
function Weapon:render ()
    self.hitbox:render ()
end

-- Resets the weapon (in game)
function Weapon:reset ()
    self.hitbox.x, self.hitbox.y = self.host.hitbox.x, self.host.hitbox.y

    self.dX = self.parent.dX

    if not self.host:facingRight () then
        self.dX = self.dX * -1
    end

    self.active = true
end

-- Collision call
-- Possibly changes based on Weapon__TYPES
function Weapon:collision (object)
    self.active = false
end

return Weapon
