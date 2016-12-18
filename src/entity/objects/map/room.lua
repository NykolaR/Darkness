-- 
-- room.lua
--
-- DOOR TYPE -1 = WALL
-- DOOR TYPE  0 = NO DOOR
-- DOOR TYPE  1 = ITEM ONE DOOR (DEFAULT ITEM)
-- DOOR TYPE  2 = ITEM TWO DOOR
-- [...]
-- DOOR TYPE  n = FINAL ITEM DOOR
--

local Room = {}
Room.__index = Room

Room.ROOMSTATE = {EMPTY = 1, RANDOM = 2, HORIHALLWAY = 3, VERTHALLWAY = 4, ITEM = 5, BOSS = 6}
Room.ROOMTYPES = {WALL = -1, HOLE = 0}

setmetatable (Room, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Constants = require ("src.logic.general")
local Door = require ("src.entity.objects.map.door")

--   END   --

Room.__WALLDOOR = Door ()
Room.__HOLEDOOR = Door (0)

function Room:_init (area, roomstate)
    self.area = area
    if not area then print ("WARNING: ROOM AREA NOT SET") end
    self.roomstate = roomstate or Room.ROOMSTATE.EMPTY
    self.doors = {Room.__WALLDOOR, Room.__WALLDOOR, Room.__WALLDOOR, Room.__WALLDOOR}
    self.playerVisited = false
end

function Room:setDoor (direction, door)
    self.doors [direction] = door or self.doors [direction]
end

function Room:setDoorWall (direction)
    self.doors [direction] = Room.__WALLDOOR
end

function Room.areaEqual (roomOne, roomTwo)
    local same = true

    if (roomOne.access == roomTwo.access) and (not (roomOne.access == nil)) then
        for i=1, i<5, 1 do
            if not Door.areaEqual (roomOne.doors [i], roomTwo.doors [i]) then
                same = false
            end
        end
    else
        same = false
    end
    return same
end

return Room
