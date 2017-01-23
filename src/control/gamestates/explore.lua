-- 
-- explore.lua
-- A control class for the game while exploring
-- Version: 1.0
-- Last Refactor:
-- Quality: WIP
--

local Explore = {}
Explore.__index = Explore

setmetatable (Explore, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Map = require ("src.entity.objects.map.map")
local MapGeneration = require ("src.logic.generation.map.map")
local PlayArea = require ("src.control.gamestates.playarea")
local Player = require ("src.entity.playable.player")
local General = require ("src.logic.general")
local Input = require ("src.boundary.input.input")

local Lights = require ("src.boundary.render.lights")
local LightLines = require ("src.boundary.render.lightlines")

--   END   --

Explore.State = {INTRO = 1, PLAY = 2, OUTRO = 3, ENDGAME = 4}
Explore.RunState = {PLAY = 1, MAP = 2, PAUSE = 3}

function Explore:_init (seeds)
    self.seeds = seeds or {General.Random:random (1000000000)}
    self.state = Explore.State.PLAY
    self.runState = Explore.RunState.PLAY
    self.paused = false

    -- Create maps
    self.maps = {Map ()}
    MapGeneration.generateMap (self.maps [1], self.seeds [1])

    -- Create player
    self.player = Player (29 * 23 + 10.5, 9 * 23 + 10.0)

    -- Create play area
    self.playArea = PlayArea (self.maps [1], self.player)

    -- Create area select
    self.areaSelect = nil
end

function Explore:update (dt)
    if Input.keyPressed (Input.KEYS.MAP) and not (self.runState == Explore.RunState.PAUSE) then
        if self.runState == Explore.RunState.PLAY then
            self.runState = Explore.RunState.MAP
        elseif self.runState == Explore.RunState.MAP then
            self.runState = Explore.RunState.PLAY
        end
    end

    if Input.keyPressed (Input.KEYS.PAUSE) and not (self.runState == Explore.RunState.MAP) then
        if self.runState == Explore.RunState.PLAY then
            self.runState = Explore.RunState.PAUSE
        elseif self.runState == Explore.RunState.PAUSE then
            self.runState = Explore.RunState.PLAY
        end
    end
   
    if not paused then
        if self.runState == Explore.RunState.PLAY then
            self.playArea:update (dt)
        elseif self.runState == Explore.RunState.MAP then
            self.maps [1]:update ()
        end
    end
end

function Explore:render ()
    love.graphics.setBlendMode ("add", "alphamultiply")

    self.playArea:render ()

    if self.runState == Explore.RunState.MAP then
        self.maps [1]:render ()
        love.graphics.setColor (255, 255, 255)
    end

    love.graphics.origin ()

    love.graphics.setBlendMode ("alpha", "premultiplied")

    LightLines.render ()
    Lights.render ()

    if self.runState == Explore.RunState.MAP or self.runState == Explore.RunState.PAUSE then
        LightLines.lock = true
    else
        LightLines.lock = false
        LightLines.clear ()
    end
end

return Explore
