-- 
-- room.lua
-- Room creation
--

local Room = {}

-- MODULES --

local Floor = require ("src.entity.nonplayableobjects.room.floor")
local Constants = require ("src.logic.general")
local RoomObj = require ("src.entity.objects.map.room")

--   END   --

Room.BLOCKTYPE = {FLOOR = 1, DOOR = 2, WALL = 3, ITEM = 4, EMPTY = 5, DONTFILL = 6, AIRWALL = 7, ENEMY = 8}

function Room.addRoomNew (room, xShift, yShift, playArea)

    if room.doors [Constants.Directions.UP].doorType == RoomObj.ROOMTYPES.WALL then
        table.insert (playArea.ENVIRONMENT, Floor (-1.0, -1.0, 25.0, 2.0, xShift, yShift))
    end

    if room.doors [Constants.Directions.DOWN].doorType == RoomObj.ROOMTYPES.WALL then
        table.insert (playArea.ENVIRONMENT, Floor (-1.0, 22.0, 25.0, 2.0, xShift, yShift))
    end

    if room.doors [Constants.Directions.RIGHT].doorType == RoomObj.ROOMTYPES.WALL then
        table.insert (playArea.ENVIRONMENT, Floor (22.0, -1.0, 2.0, 25.0, xShift, yShift))
    end

    if room.doors [Constants.Directions.LEFT].doorType == RoomObj.ROOMTYPES.WALL then
        table.insert (playArea.ENVIRONMENT, Floor (-1.0, -1.0, 2.0, 25.0, xShift, yShift))
    end
    
    --table.insert (playArea.ENVIRONMENT, Floor (0.0, 15.0, 23.0, 3.0, xShift, yShift))
    table.insert (playArea.ENVIRONMENT, Floor (5.0, 3.0, 3.0, 15.0, xShift, yShift))
    table.insert (playArea.ENVIRONMENT, Floor (15.0, 3.0, 3.0, 15.0, xShift, yShift))
end

return Room
