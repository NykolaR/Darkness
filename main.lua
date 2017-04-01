-- 
-- main.lua
--

-- MODULES --

local Input = require ("src.boundary.input")
local General = require ("src.logic.general")
--local Explore = require ("src.control.gamestates.explore")
local GameCreate = require ("src.control.gamecreate")

--   END   --

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)        
        
--[[ GAME GLOBALS --

SCREEN_WIDTH = 32
SCREEN_WIDTH_HALF = 16
SCREEN_HEIGHT = 18
SCREEN_HEIGHT_HALF = 9

-- END GLOBALS  --]]

--1024
--576

General.Random:setSeed (os.time ())
local SCREEN_CANVAS = love.graphics.newCanvas (love.graphics.getWidth (), love.graphics.getHeight ())
SCREEN_CANVAS:setFilter ("nearest", "nearest")

local explore = nil

function love.load ()
    love.graphics.setLineWidth (0.01)
    love.graphics.setLineJoin ("miter")
    love.mouse.setVisible (false)

    love.graphics.setNewFont (24)
    
    explore = GameCreate.createSave ()
end

function love.update (dt)
    General.dt = dt

    Input.handleInputs ()
    checkQuit ()

    explore:update ()
end

function love.draw ()
    love.graphics.setCanvas (SCREEN_CANVAS)
    love.graphics.clear (0, 0, 0, 0)

    explore:render ()

    -- Clear render alterations for final render
    love.graphics.setBlendMode ("alpha", "premultiplied")
    love.graphics.setColor (255, 255, 255)
    love.graphics.setCanvas ()
    love.graphics.setShader ()

    love.graphics.draw (SCREEN_CANVAS)
end

function checkQuit ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
end
