-- 
-- playarea.lua
-- General play area
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
local LightLines = require ("src.boundary.render.lightlines")

--   END   --

PlayArea.lightShader = love.graphics.newShader ("resources/shaders/lightlines.glsl")

function PlayArea:_init (map, player)
    self.player = player or Player (29 * 23 + 10.5, 9 * 23 + 10.0)
    self.ENVIRONMENT = {}
    self.ENEMIES = {}
    self.PLAYERCOLLIDES = {}
    self.ENEMYCOLLIDES = {}

    Area.loadArea (self, map)
    PlayArea.lightShader:send ("second", self.player.secondColor)
end

function PlayArea:update ()
    self.player:update ()

    for i,v in pairs (self.ENVIRONMENT) do
        self.player:floorCollision (v)
    end
end

function PlayArea:render ()
    love.graphics.translate ((self.player.hitbox.x - 16) * -1, (self.player.hitbox.y - 12) * -1)

    --self.player:render ()
    love.graphics.setColor (self.player.color)
    love.graphics.setShader (PlayArea.lightShader)
    for i,v in pairs (self.ENVIRONMENT) do
        --v:render ()

        LightLines.renderLine (self, self.player.hitbox.x + (self.player.hitbox.width / 2), self.player.hitbox.y + (self.player.hitbox.height / 2), v.hitbox.x + (v.hitbox.width / 2), v.hitbox.y + (v.hitbox.height / 2))
    end
    love.graphics.setShader ()
end

return PlayArea
