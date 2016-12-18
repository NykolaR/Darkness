-- 
-- floor.lua
-- Default floor
-- Nothing special with this floor... yet...
--

local Floor = {}
Floor.__index = Floor

setmetatable (Floor, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Collider = require ("src.logic.physics.collider")

--   END   --

function Floor:_init (...)
    self.hitbox = Collider (...)
    self.friction = 0.005
    self.damageOverTime = 0
end

function Floor:render ()
    love.graphics.setColor (255, 255, 255)
    self.hitbox:render ()
end

return Floor
