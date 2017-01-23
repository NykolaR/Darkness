-- 
-- floor.lua
-- Default floor
-- Nothing special with this floor... yet...
-- Version: 1.0
-- Last Refactor: 
-- Quality: Good
--

local Floor = {}
Floor.__index = Floor
Floor.tex = love.graphics.newCanvas (32, 32)

-- MODULES --

local TexGen = require ("src.logic.generation.naturetexture")
TexGen.generateTexture (Floor.tex)
Floor.tex:setFilter ("nearest", "nearest")

--   END   --

setmetatable (Floor, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Collider = require ("src.logic.physics.collider")
local Lights = require ("src.boundary.render.lights")

--   END   --

function Floor:_init (...)
    self.hitbox = Collider (...)
    -- self.friction = 0.005
    -- self.damageOverTime = 1
end

function Floor:render ()
    love.graphics.setColor (255, 255, 255)
    --self.hitbox:render ()
    for x=0, self.hitbox.width - 1 do
        for y=0, self.hitbox.height - 1 do
            love.graphics.draw (Floor.tex, self.hitbox.x + x, self.hitbox.y + y, 0, 1 / 32, 1 / 32)
        end
    end
end

function Floor:illuminate (x, y)
    Lights.circle (x, y)
end

return Floor
