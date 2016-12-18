-- 
-- map.lua
-- Generates map data
-- Is all in all pretty much the best
-- It's "static", that is, it's functions are called /on/with/ a map
--

local MapGenerate = {}

-- MODULES --

local Area = require ("src.entity.objects.map.area")
local Door = require ("src.entity.objects.map.door")
local Room = require ("src.entity.objects.map.room")
local Map = require ("src.entity.objects.map.map")

local General = require ("src.logic.general")

--   END   --

function MapGenerate.initializeMap (map)
    map:_init (map.xSize, map.ySize)

    local startArea = Area ()

    table.insert (map.areaTypes, startArea)

    map.map [30][10] = Room (startArea) -- initial room
end

function MapGenerate.generateMap (map, seed)
    local newSeed = seed or 0
    General.setSeed (newSeed)
    MapGenerate.initializeMap (map)

    MapGenerate.expandArea (map)
end

function MapGenerate.expandArea (map, x, y, amount)
    local x = x or 30
    local y = y or 10
    local amount = amount or 15
    local result = true
    local lastDir = nil
    local area = map.map [x][y].area

    while amount > 0 and result do
        result,x,y,lastDir = MapGenerate.randomDirectionRoom (map, x, y, General.oppositeDirection (lastDir), area)
        amount = amount - 1
    end

end

function MapGenerate.randomDirectionRoom (map, x, y, oppositeLastDir, area)
    local nextDir = General.randomFourWayDirection (oppositeLastDir)

    if MapGenerate.addRoom (map, x, y, nextDir, area) then
        if nextDir == General.Directions.UP then
            return true, x, y-1, nextDir
        end
        if nextDir == General.Directions.DOWN then
            return true, x, y+1, nextDir
        end
        if nextDir == General.Directions.LEFT then
            return true, x-1, y, nextDir
        end
        if nextDir == General.Directions.RIGHT then
            return true, x+1, y, nextDir
        end
    end

    return false
end

function MapGenerate.addRoom (map, x, y, dir, area)
    if map:isRoom (x, y, dir) then
        return false
    end

    local newRoom = Room (area)

    map.map [x][y].doors [dir] = Room.__HOLEDOOR
    newRoom.doors [General.oppositeDirection (dir)] = Room.__HOLEDOOR

    if dir == General.Directions.UP then
        map.map [x][y-1] = newRoom
    end
    if dir == General.Directions.DOWN then
        map.map [x][y+1] = newRoom
    end
    if dir == General.Directions.LEFT then
        map.map [x-1][y] = newRoom
    end
    if dir == General.Directions.RIGHT then
        map.map [x+1][y] = newRoom
    end

    return true
end
    
return MapGenerate
