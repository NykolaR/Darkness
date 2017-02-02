-- 
-- playarea.lua
-- General play area
-- Version: 1.0
-- Last Refactor: 
-- Quality: WIP
--

local PlayArea = {}
PlayArea.__index = PlayArea

setmetatable (PlayArea, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Area = require ("src.logic.generation.area")
local Player = require ("src.entity.playable.player")
local WeaponManager = require ("src.entity.weapons.weaponmanager")
local LightLines = require ("src.boundary.render.lightlines")
local Lights = require ("src.boundary.render.lights")
local Lit = require ("src.boundary.render.lit")

--   END   --

PlayArea.lightShader = love.graphics.newShader ("resources/shaders/lightlines.glsl")
PlayArea.playerShader = love.graphics.newShader ("resources/shaders/player.glsl")

function PlayArea:_init (map, player)
    self.player = player or Player (29 * 23 + 10.5, 9 * 23 + 10.0)
    self.ENVIRONMENT = {}
    self.ENEMIES = {}
    self.PLAYERCOLLIDES = {}
    self.ENEMYCOLLIDES = {}

    Area.loadArea (self, map)
    PlayArea.lightShader:send ("second", self.player.secondColor)
    PlayArea.playerShader:send ("second", self.player.secondColor)
end

function PlayArea:update ()
    self.player:update ()

    --local t1 = love.timer.getTime ()

    WeaponManager.update ()

    for i,v in pairs (self.ENVIRONMENT) do
        self.player:floorCollision (v)
        WeaponManager.collision (v)
    end

    --print ("time: " .. (love.timer.getTime () - t1))
end

function PlayArea:render ()
    local lastCanvas = love.graphics.getCanvas ()

    Lights.clear ()
    Lit.clear ()

    love.graphics.setCanvas (lastCanvas)

    love.graphics.scale (love.graphics.getWidth () / 32, love.graphics.getHeight () / 18)
    love.graphics.translate ((self.player.hitbox.x - 16) * -1, (self.player.hitbox.y - 12) * -1)

    love.graphics.setColor (self.player.color)
    love.graphics.setShader (PlayArea.lightShader)
    -- LIGHT AREA ISH
    --love.graphics.rectangle ("fill", self.player.hitbox.x - 16, self.player.hitbox.y - 12, 32, 32)

    self.player:render (self, PlayArea.playerShader)

    -- save ~ 0.001s not resetting shader here
    --love.graphics.setShader ()
    -- 0.0017 -> 0.0023
    -- 0.0028 -> 0.0035

    WeaponManager.render ()

    love.graphics.setCanvas (Lit.canvas)
    for i,v in pairs (self.ENVIRONMENT) do
        if self:inArea (v.hitbox) then
            v:render ()
        end
    end

    Lights.multiply ()
end

function PlayArea:inArea (rectangle)
    return ( (self.player.hitbox.x - 16) < (rectangle.x + rectangle.width) and (self.player.hitbox.x + 16) > rectangle.x and
        (self.player.hitbox.y - 16) < (rectangle.y + rectangle.height) and (self.player.hitbox.y + 16) > (rectangle.y) )
end

return PlayArea
