-- 
-- main.lua
--

-- MODULES --

local Input = require ("src.boundary.input.input")
local General = require ("src.logic.general")
local Explore = require ("src.control.gamestates.explore")

--   END   --

-- GAME GLOBALS --

SCREEN_WIDTH = 32
SCREEN_WIDTH_HALF = 16
SCREEN_HEIGHT = 18
SCREEN_HEIGHT_HALF = 9

-- END GLOBALS  --

local SCREEN_CANVAS = love.graphics.newCanvas (love.graphics.getWidth (), love.graphics.getHeight ())

--local Area = require ("src.control.gamestates.testplayarea")
--local area = Area ()

local MapGeneration = require ("src.logic.generation.map.map")
local Map = require ("src.entity.objects.map.map")
local map = Map ()

local area = nil

local PlayArea = require ("src.control.gamestates.playarea")

local gridShader = love.graphics.newShader ("resources/shaders/grid.glsl")

function love.load ()
    love.graphics.setLineWidth (0.04)
    love.graphics.setLineJoin ("miter")
    General.Random:setSeed (os.time ())
    MapGeneration.generateMap (map, General.Random:random (1, 100000))
    area = PlayArea (map)
    love.mouse.setVisible (false)
end

function love.update (dt)
    Input.handleInputs ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end

    area:update ()
end

function love.draw ()
    love.graphics.setCanvas (SCREEN_CANVAS)
    love.graphics.clear ()
    
    love.graphics.push ()
    love.graphics.scale (love.graphics.getWidth () / 32, love.graphics.getHeight () / 18)

    --love.graphics.setShader (gridShader)

    love.graphics.setBlendMode ("add", "alphamultiply")
    area:render ()

    love.graphics.pop ()

    love.graphics.setBlendMode ("alpha", "premultiplied")
    if Input.keyDown (Input.KEYS.MAP) then
        map:render ()
    end

    love.graphics.setColor (255, 255, 255)
    love.graphics.setCanvas ()

    love.graphics.setShader ()
    love.graphics.draw (SCREEN_CANVAS)
end
