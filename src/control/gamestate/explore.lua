local Class = require ("src.class")

local Explore = Class.new ()

local MapRender = require ("src.boundary.render.mapscreen")
local Player = require ("src.entity.playable.player")
local PlayArea = require ("src.control.gamestate.playarea")
local Input = require ("src.boundary.input")
local LightLines = require ("src.boundary.render.lightlines")
local Lights = require ("src.boundary.render.lights")

local State = {INTRO = 1, PLAY = 2, OUTRO = 3, ENDGAME = 4}
local RunState = {PLAY = 1, MAP = 2, PAUSE = 3}

function Explore:_init (save)
    self.state = State.PLAY
    self.runState = RunState.PLAY
    self.paused = false

    self.save = save

    self.player = Player ()
    self.playArea = PlayArea (self.save, self.player)

    self.areaSelect = nil
end

function Explore:update ()
    if Input.keyPressed (Input.KEYS.MAP) and not (self.runState == RunState.PAUSE) then
        if self.runState == RunState.PLAY then
            self.runState = RunState.MAP
        elseif self.runState == RunState.MAP then
            self.runState = RunState.PLAY
        end
    end

    if Input.keyPressed (Input.KEYS.PAUSE) and not (self.runState == RunState.MAP) then
        if self.runState == RunState.PLAY then
            self.runState = RunState.PAUSE
        elseif self.runState == RunState.PAUSE then
            self.runState = RunState.PLAY
        end
    end
   
    if not paused then
        if self.runState == RunState.PLAY then
            self.playArea:update ()
        elseif self.runState == RunState.MAP then
            self.maps [1]:update ()
        end
    end
end

function Explore:render ()
    love.graphics.setBlendMode ("add", "alphamultiply")

    self.playArea:render ()

    if self.runState == RunState.MAP then
        -- Render maps
        MapRender.render (self.save)
    end

    love.graphics.origin ()

    love.graphics.setBlendMode ("alpha", "premultiplied")

    LightLines.render ()
    Lights.render ()

    if self.runState == RunState.MAP or self.runState == RunState.PAUSE then
        LightLines.lock = true
    else
        LightLines.lock = false
        LightLines.clear ()
    end
end

return Explore
