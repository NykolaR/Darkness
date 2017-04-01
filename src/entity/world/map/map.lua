-- 
-- map.lua
-- The map class contains data about a single floor in a world
--

local Map = {}
Map.__index = Map

setmetatable (Map, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local General = require ("src.logic.general")
local MapScreen = require ("src.boundary.render.mapscreen")

--   END   --

function Map:_init (xSize, ySize)
    self.xSize = xSize or 60
    self.ySize = ySize or 60
    --self.numRooms = numRooms or 200
    self.map = {} -- 2D ARRAY OF ROOMS
    self.doorTypes = {} -- MAP DOORS
    self.areaTypes = {} -- MAP AREAS

    for i=1, self.xSize, 1 do
        self.map [i] = {}
    end

    self.itemTypes = {} -- MAP ITEMS
    
    self.mapScreen = MapScreen (self)
end

function Map:isRoom (x, y, dir)
    if (x <= 1 or y <= 1 or x >= (self.xSize - 1) or y >= (self.ySize - 1)) then
        return true
    end

    if dir then
        if dir == General.Directions.UP then
            return self.map [x][y-1]
        end

        if dir == General.Directions.DOWN then
            return self.map [x][y+1]
        end

        if dir == General.Directions.LEFT then
            return self.map [x-1][y]
        end

        if dir == General.Directions.RIGHT then
            return self.map [x+1][y]
        end
    end

    return self.map [x][y]
end

function Map:render ()
    self.mapScreen:render ()
end

function Map:update ()
    self.mapScreen:update ()
end

return Map
