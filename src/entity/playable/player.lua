-- 
-- player.lua
-- The player object
-- Manages player health, weapons, etc
-- Does not manage player movement and collisions
-- Version: 2.0
-- Last Refactor: 
-- Quality: WIP
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
local PlayerRender = require ("src.boundary.render.player")
local Weapon = require ("src.entity.weapons.weapon")
local WeaponManager = require ("src.entity.weapons.weaponmanager")
local Input = require ("src.boundary.input.input")

--   END   --

function Player:_init (x, y)
    self.hitbox = PlayerCollider (x, y)
    self.blocksLight = false
    self.health = 100
    self.weaponType = General.randomInt ()
    self.weapon = Weapon (self.weaponType, self, true)
    self.access = 0
    self.hurt = 0
    self.heal = 0
    self.maxHealth = 100
    
    self.lineRays = 0.0
    self.lineAngle = 0.0
    self.lineROC = 1.2

    self.color = self.weapon.colorOne
    self.secondColor = self.weapon.colorTwo
end

function Player:facingRight ()
    return self.hitbox:facingRight ()
end

function Player:takeDamage (damageValue)
    self.health = self.health - damageValue
    print (self.health)
end

function Player:render (pa, playerShader)
    PlayerRender.render (pa, self, playerShader)
end

function Player:update ()
    self:floorDamage ()
    self.hitbox:act ()

    if Input.keyPressed (Input.KEYS.ACTION_ONE) then
        WeaponManager.addWeapon (self.weapon)
    end

    self.lineAngle = self.lineAngle + (self.lineROC * General.dt)

    if self.lineAngle < 0 then
        self.lineROC = self.lineROC * -1
        self.lineAngle = 0
    elseif self.lineAngle > math.pi then
        self.lineROC = self.lineROC * -1
        self.lineAngle = math.pi
    end

    self.lineRays = math.sin (self.lineAngle) + 1

    PlayerRender.updateRender (self)
end

function Player:floorDamage ()
    if self.hitbox:getFloorDamage () then
        self:takeDamage (self.hitbox.currentFloor.damageOverTime)
    end
end

function Player:floorCollision (floor)
    if (self.hitbox:intersects (floor.hitbox)) then
        Collisions.floorCollision (self, floor)
    end
end

function Player:renderLine (pa, block)
    PlayerRender.renderLine (pa, self, block)
end

return Player
