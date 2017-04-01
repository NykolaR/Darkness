-- 
-- area.lua
-- Area creation/loading from map
--

local Area = {}

-- MODULES --

local Room = require ("src.logic.generation.room")
local Constants = require ("src.logic.general")

--   END   --

function Area.loadArea (playArea, frame)
    local map = map or playArea.map

    playArea.ENVIRONMENT = {}
    playArea.ENEMIES = {}
    playArea.PLAYERCOLLIDES = {}
    playArea.ENEMYCOLLIDES = {}

    -- create map outline then fill
    --local grid = Area.fillGrid (frame)

    if frame.home then
        local hr = frame.home.rect
        for y = hr.y, (hr.y + hr.height) do
            for x = hr.x, (hr.x + hr.width) do
                Room.addRoomNew (frame.home, (x - 1) * Constants.ROOMSIZE, (y - 1) * Constants.ROOMSIZE, playArea)
            end
        end
    end

    --[[
    for y=1, map.ySize, 1 do
        for x=1, map.xSize, 1 do
            if map.map [x][y] then
                Room.addRoomNew (map.map [x][y], (x - 1) * Constants.ROOMSIZE, (y - 1) * Constants.ROOMSIZE, playArea)
            end
        end
    end
    ]]

end

local rtypes = {KEY = 1, LINK = 2, CONNECT = 3, HOME = 4}

function Area.fillGrid (frame)
    local grid = {}
    if frame.home then
        Area.lonk (grid, frame.home.rect, rtypes.HOME)
    end

    for _,key in pairs (frame.keys) do

    end

    return grid
end

function Area.lonk (grid, rect, rtype)

end

return Area
