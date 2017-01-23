-- 
-- player.lua
-- Handles things related to player rendering
-- Really, pretty neat, pretty fun
-- Version: 2.0
-- Last Refactor Dec. 21st 2016
-- Quality: Needs work / re-thinking game design wise
--

local PlayerRender = {}
--PlayerRender.__index = PlayerRender

PlayerRender.__tileSize = 32
PlayerRender.__tileInverse = 1/32
PlayerRender.__spriteSheet = love.graphics.newImage ("resources/sprites/player/playerbasenu.png")
PlayerRender.__spriteSheet:setFilter ("nearest", "nearest")
PlayerRender.__quads = {}

PlayerRender.__frame = 1
PlayerRender.__frameRate = 0.9
PlayerRender.__currentRate = 0.0

-- MODULES --

local General = require ("src.logic.general")
local LightLines = require ("src.boundary.render.lightlines")
local Lights = require ("src.boundary.render.lights")
local Quads = require ("src.logic.quads")
local PlayerCollider = require ("src.logic.physics.playercollider")

--   END   --

Quads.generateQuads (PlayerRender.__quads, PlayerRender.__spriteSheet, PlayerRender.__tileSize)

function PlayerRender.render (pa, player, shader)
    Lights.circle (player.hitbox.x + 0.5, player.hitbox.y + 0.5, 5, 70)

    love.graphics.setBlendMode ("alpha", "alphamultiply")
    LightLines.startLines ()
    PlayerRender.scanLines (pa, player) -- Lines: x == (12/32) or (20/32), y == 3/32 or 4/32 or 3.5/32
    LightLines.endLines ()

    --love.graphics.setBlendMode ("alpha", "alphamultiply")
    love.graphics.setShader (shader)

    PlayerRender.drawPlayer (player)
end

function PlayerRender.updateRender (player)
    if player.hitbox.state == PlayerCollider.STATES.FALLING or player.hitbox.state == PlayerCollider.STATES.JUMPING or player.hitbox.state == PlayerCollider.STATES.EDGE then
        PlayerRender.__frame = 5
    else
        if player.hitbox.hSpeed == 0 then
            PlayerRender.__frame = 1
        else
            PlayerRender.__currentRate = PlayerRender.__currentRate + math.abs (player.hitbox.hSpeed)
            if PlayerRender.__currentRate > PlayerRender.__frameRate then
                PlayerRender.__frame = PlayerRender.__frame + 1
                PlayerRender.__currentRate = PlayerRender.__currentRate - PlayerRender.__frameRate
            end

            if PlayerRender.__frame > 4 then
                PlayerRender.__frame = 1
            end
        end
    end
end

function PlayerRender.drawPlayer (player)
    local scaleFactor = 1
    local drawX = player.hitbox.x
    if not (player.hitbox.playerDir == General.Directions.UPRIGHT or
        player.hitbox.playerDir == General.Directions.RIGHT or
        player.hitbox.playerDir == General.Directions.DOWNRIGHT) then
            scaleFactor = -1
            drawX = drawX + 1
    end

    love.graphics.draw (PlayerRender.__spriteSheet, PlayerRender.__quads [PlayerRender.__frame], drawX, player.hitbox.y, 0, PlayerRender.__tileInverse * scaleFactor, PlayerRender.__tileInverse)
end

function PlayerRender.scanLines (pa, player)
    if player:facingRight () then
        PlayerRender.scanRight (pa, player)
        PlayerRender.rightBeams (pa, player)
    else
        PlayerRender.scanLeft (pa, player)
        PlayerRender.leftBeams (pa, player)
    end
end

function PlayerRender.rightBeams (pa, player)
    LightLines.renderLine (pa, player.hitbox.x + 0.625, player.hitbox.y + 0.12, (player.hitbox.x + 16.5), (player.hitbox.y + 0.5 + 6), nil, true)
    LightLines.renderLine (pa, player.hitbox.x + 0.625, player.hitbox.y + 0.12, (player.hitbox.x + 16.5), (player.hitbox.y + 0.5 - 12), nil, true)
end

function PlayerRender.leftBeams (pa, player)
    LightLines.renderLine (pa, player.hitbox.x + 0.375, player.hitbox.y + 0.12, (player.hitbox.x - 16.5), (player.hitbox.y + 0.5 + 6), nil, true)
    LightLines.renderLine (pa, player.hitbox.x + 0.375, player.hitbox.y + 0.12, (player.hitbox.x - 16.5), (player.hitbox.y + 0.5 - 12), nil, true)
end

-- Player var lineRays has range 0 - 2
function PlayerRender.scanRight (pa, player)
    LightLines.renderLine (pa, player.hitbox.x + 0.625, player.hitbox.y + 0.12, (player.hitbox.x + 16.5), (player.hitbox.y + 0.5 - 12) + (9 * player.lineRays), nil, true)
    LightLines.renderLine (pa, player.hitbox.x + 0.625, player.hitbox.y + 0.12, (player.hitbox.x + 16.5), (player.hitbox.y + 0.5 - 12) + (9 * (2 - player.lineRays)), nil, true)
end

function PlayerRender.scanLeft (pa, player)
    LightLines.renderLine (pa, player.hitbox.x + 0.375, player.hitbox.y + 0.12, (player.hitbox.x - 16.5), (player.hitbox.y + 0.5 - 12) + (9 * player.lineRays), nil, true)
    LightLines.renderLine (pa, player.hitbox.x + 0.375, player.hitbox.y + 0.12, (player.hitbox.x - 16.5), (player.hitbox.y + 0.5 - 12) + (9 * (2 - player.lineRays)), nil, true)
end

function PlayerRender.backlinesRight (pa, player)
    LightLines.renderLine (pa, player.hitbox.x + 0.5, player.hitbox.y + 0.6, (player.hitbox.x + 16.5), (player.hitbox.y + 0.5 + 6), nil, true)
    LightLines.renderLine (pa, player.hitbox.x + 0.5, player.hitbox.y + 0.6, (player.hitbox.x + 16.5), (player.hitbox.y + 0.5 - 12), nil, true)
end

function PlayerRender.backlinesLeft (pa, player)
    LightLines.renderLine (pa, player.hitbox.x + 0.5, player.hitbox.y + 0.6, (player.hitbox.x - 16.5), (player.hitbox.y + 0.5 + 6), nil, true)
    LightLines.renderLine (pa, player.hitbox.x + 0.5, player.hitbox.y + 0.6, (player.hitbox.x - 16.5), (player.hitbox.y + 0.5 - 12), nil, true)
end

return PlayerRender
