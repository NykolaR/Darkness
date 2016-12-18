-- 
-- area.lua
-- Area creation/loading from map
--

local Area = {}

-- MODULES --

local Room = require ("src.logic.generation.room")
local Constants = require ("src.logic.general")

--   END   --

function Area.loadArea (playArea, map)
    local map = map or playArea.map

    playArea.ENVIRONMENT = {}
    playArea.ENEMIES = {}
    playArea.PLAYERCOLLIDES = {}
    playArea.ENEMYCOLLIDES = {}

    for y=1, map.ySize, 1 do
        for x=1, map.xSize, 1 do
            if map.map [x][y] then
                Room.addRoomNew (map.map [x][y], (x - 1) * Constants.ROOMSIZE, (y - 1) * Constants.ROOMSIZE, playArea)
            end
        end
    end
end

return Area
