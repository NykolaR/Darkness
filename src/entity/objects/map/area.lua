-- 
-- area.lua
-- A map Area. Contains an access int, an array of rooms in the area,
-- and a boolean of whether the doors in the area have been set
--

local Area = {}
Area.__index = Area

setmetatable (Area, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local General = require ("src.logic.general")

--   END   --

function Area:_init (room, distance)
    self.areaIndex = 0
    self.areaRooms = {}
    self.distanceFromRoot = distance or 0
    self.dark = false

    self.color = General.randomColor ()

    if room then table.insert (self.areaRooms, room) end
end

function Area:addRoom (room)
    if room then
        table.insert (self.areaRooms, room)
    end
end

function Area:getLastRoom ()
    return self.areaRooms [#self.areaRooms]
end

return Area
