-- 
-- testplayarea.lua
-- A test area, with minimal blocks and a controllable player
--

local TestPlayArea = {}
TestPlayArea.__index = TestPlayArea

setmetatable (TestPlayArea, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Floor = require ("src.entity.nonplayableobjects.room.floor")
local Player = require ("src.entity.playable.player")

--   END   --

function TestPlayArea:_init ()
    self.player = Player (15.0, 10.0)
    self.floor = Floor (0.0, 15.0, 32.0, 3.0)
    self.floorTwo = Floor (8.0, 5.0, 3.0, 7.0)
    self.floorThree = Floor (24.0, 5.0, 3.0, 7.0)
end

function TestPlayArea:update ()
    self.player:update ()

    self.player:floorCollision (self.floor)
    self.player:floorCollision (self.floorTwo)
    self.player:floorCollision (self.floorThree)
end

function TestPlayArea:render ()
    self.player:render ()

    self.floor:render ()
    self.floorTwo:render ()
    self.floorThree:render ()
end

return TestPlayArea
