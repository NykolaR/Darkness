-- 
-- explore.lua
-- A control class for the game while exploring
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

--   END   --

Explore.State = {INTRO = 1, PLAY = 2, OUTRO = 3, ENDGAME = 4}
Explore.RunState = {PLAY = 1, MAP = 2}

function Explore:_init (seeds)
    self.seeds = seeds or {General.Random:random (1000000000)}
    self.state = Explore.State.PLAY
    self.runState = Explore.RunState.PLAY
    self.paused = false

    -- Create maps
    self.maps = Map ()
    MapGenerate.generateMap (map, seeds [1])

    -- Create player
    self.player = Player (29 * 23 + 10.5, 9 * 23 + 10.0)

    -- Create play area
    self.playArea = PlayArea (self.map, self.player)

    -- Create area select
    self.areaSelect = nil
end

function Explore:update ()
    if Input.keyPressed (Input.KEYS.MAP) then
        if self.runState == Explore.RunState.PLAY then
            self.runState = Explore.RunState.MAP
        else
            self.runState = Explore.RunState.PLAY
        end
    end

    if not paused then
        if self.runState == Explore.RunState.PLAY then
            self.playArea:update ()
        elseif self.runState == Explore.RunState.MAP then
            self.map:update ()
        end
    end
end

function Explore:render ()
    self.playArea:render ()

    if self.runState == Explore.RunState.MAP then
        self.map:render ()
    end
end

return Explore
