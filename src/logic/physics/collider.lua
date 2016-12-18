-- 
-- collider.lua
-- Inherets from the rectangle class
-- Provides vSpeed and hSpeed variables, and related functions
--

local Collider = {}
Collider.__index = Collider

local Rectangle = require ("src.logic.rectangle")

setmetatable (Collider, {
    __index = Rectangle,
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Constants = require ("src.logic.general")

--   END   --

function Collider:_init (...)
    Rectangle._init (self, ...)
    self.vSpeed = 0
    self.hSpeed = 0
end

function Collider:set (x, y, width, height)
    self.x = x or self.x
    self.y = y or self.y
    self.width = width or self.width
    self.height = height or self.height
end

function Collider:limits ()
    if (self.vSpeed > Constants.TERMINAL_VERTICAL) then
        self.vSpeed = Constants.TERMINAL_VERTICAL
    end
    if (self.vSpeed < Constants.TERMINAL_VERTICAL * -1) then
        self.vSpeed = Constants.TERMINAL_VERTICAL * -1
    end

    if (self.hSpeed > Constants.TERMINAL_HORIZONTAL) then
        self.hSpeed = Constants.TERMINAL_HORIZONTAL
    end
    if (self.hSpeed < Constants.TERMINAL_HORIZONTAL * -1) then
        self.hSpeed = Constants.TERMINAL_HORIZONTAL * -1
    end
end

function Collider:moveX (val)
    self.x = self.x + (val or 0)
end

function Collider:moveY (val)
    self.y = self.y + (val or 0)
end

function Collider:movePosition (x, y)
    self:moveX (x or self.hSpeed)
    self:moveY (y or self.vSpeed)
end

return Collider
