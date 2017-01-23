-- 
-- lights.lua
-- where ya render lights
--

local Lights = {}

local Lit = require ("src.boundary.render.lit")

Lights.canvas = love.graphics.newCanvas (love.graphics.getWidth (), love.graphics.getHeight ())
Lights.canvas:setFilter ("nearest", "nearest")

Lights.circleTex = love.graphics.newImage ("resources/sprites/effects/circle.png")

function Lights.clear ()
    love.graphics.setCanvas (Lights.canvas)
    love.graphics.clear (0, 0, 0, 0)
end

function Lights.multiply ()
    love.graphics.setCanvas (Lights.canvas)
    love.graphics.origin ()
    love.graphics.setBlendMode ("multiply", "premultiplied")
    love.graphics.draw (Lit.canvas)
    love.graphics.setCanvas ()
end

function Lights.circle (x, y, radius, alpha)
    local lastCanvas = love.graphics.getCanvas ()
    love.graphics.setCanvas (Lights.canvas)
    local r,g,b = love.graphics.getColor ()
    local radius = radius or 0.5
    local alpha = alpha or 100
    love.graphics.setColor (r, g, b, alpha)

    love.graphics.draw (Lights.circleTex, x - radius, y - radius, 0, radius / 128, radius / 128)

    love.graphics.setCanvas (lastCanvas)
    love.graphics.setColor (r, g, b, 255)
end

function Lights.render ()
    love.graphics.draw (Lights.canvas)
end

return Lights
