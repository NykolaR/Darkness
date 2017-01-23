-- 
-- main.lua
--

-- MODULES --

local Input = require ("src.boundary.input.input")
local General = require ("src.logic.general")
local Explore = require ("src.control.gamestates.explore")
local GameState = require ("src.control.saves.gamestate")

--   END   --

-- GAME GLOBALS --

SCREEN_WIDTH = 32
SCREEN_WIDTH_HALF = 16
SCREEN_HEIGHT = 18
SCREEN_HEIGHT_HALF = 9

-- END GLOBALS  --

--1024
--576

General.Random:setSeed (os.time ())
local SCREEN_CANVAS = love.graphics.newCanvas (love.graphics.getWidth (), love.graphics.getHeight ())
SCREEN_CANVAS:setFilter ("nearest", "nearest")
--local explore = Explore ()
local explore = GameState.set ()

function love.load ()
    love.graphics.setLineWidth (0.01)
    love.graphics.setLineJoin ("miter")
    love.mouse.setVisible (false)

    love.graphics.setNewFont (24)
end

function love.update (dt)
    Input.handleInputs ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end

    explore:update ()
end

function love.draw ()
    love.graphics.setCanvas (SCREEN_CANVAS)
    love.graphics.clear (0, 0, 0, 0)

    explore:render ()

    love.graphics.setBlendMode ("alpha", "premultiplied")
    love.graphics.setColor (255, 255, 255)
    love.graphics.setCanvas ()
    love.graphics.setShader ()

    love.graphics.draw (SCREEN_CANVAS)

    --memoryApprox ()
    --shaderSwitches ()
end

function memoryApprox ()
    local str = string.format ("Approx. mem: %0.2f MB", love.graphics.getStats ().texturememory / 1024 / 1024)

    love.graphics.print (str, 10, 10)
end

function shaderSwitches ()
    local num = love.graphics.getStats ().shaderswitches
    local str = "err"
    if num then
        str = string.format ("Shader switches: %i", num)
    end

    love.graphics.print (str, 10, 28)
end
