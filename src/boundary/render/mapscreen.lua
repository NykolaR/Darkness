-- 
-- mapscreen.lua
-- Renders a map
-- Many wows!
--

local MapScreen = {}
MapScreen.__index = MapScreen

setmetatable (MapScreen, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

local General = require ("src.logic.general")

MapScreen.__SQUARESIZE = 6
MapScreen.__WALLSIZE = 1
MapScreen.__TILESIZE = MapScreen.__SQUARESIZE - (MapScreen.__WALLSIZE * 2)

function MapScreen:_init (map)
    self.canvas = love.graphics.newCanvas (map.xSize * MapScreen.__SQUARESIZE, map.ySize * MapScreen.__SQUARESIZE)
    self.canvas:setFilter ("nearest", "nearest")
    self.map = map
end

function MapScreen:updateRender ()
    local lastCanvas = love.graphics.getCanvas ()
    love.graphics.setCanvas (self.canvas)

    for y=1, self.map.ySize, 1 do
        for x=1, self.map.xSize, 1 do
            if self.map.map [x][y] then
                love.graphics.setColor (self.map.map [x][y].area.color)
                love.graphics.rectangle ("fill", x * MapScreen.__SQUARESIZE + MapScreen.__WALLSIZE, y * MapScreen.__SQUARESIZE + MapScreen.__WALLSIZE, MapScreen.__TILESIZE, MapScreen.__TILESIZE)
                self:drawDoors (x, y)
            end
        end
    end

    love.graphics.setCanvas (lastCanvas)
end

function MapScreen:render ()
    self:updateRender ()
    love.graphics.draw (self.canvas, 0, 0, 0, 6, 6)
end

function MapScreen:update ()

end

function MapScreen:drawDoors (x, y)
    if self.map.map [x][y].doors [General.Directions.UP].doorType == 0 then
        love.graphics.rectangle ("fill", x * MapScreen.__SQUARESIZE + MapScreen.__WALLSIZE, y * MapScreen.__SQUARESIZE, MapScreen.__TILESIZE, MapScreen.__WALLSIZE)
    end

    if self.map.map [x][y].doors [General.Directions.DOWN].doorType == 0 then
        love.graphics.rectangle ("fill", x * MapScreen.__SQUARESIZE + MapScreen.__WALLSIZE, y * MapScreen.__SQUARESIZE + MapScreen.__TILESIZE + MapScreen.__WALLSIZE, MapScreen.__TILESIZE, MapScreen.__WALLSIZE)
    end

    if self.map.map [x][y].doors [General.Directions.LEFT].doorType == 0 then
        love.graphics.rectangle ("fill", x * MapScreen.__SQUARESIZE, y * MapScreen.__SQUARESIZE + MapScreen.__WALLSIZE, MapScreen.__WALLSIZE, MapScreen.__TILESIZE)
    end

    if self.map.map [x][y].doors [General.Directions.RIGHT].doorType == 0 then
        love.graphics.rectangle ("fill", x * MapScreen.__SQUARESIZE + MapScreen.__TILESIZE + MapScreen.__WALLSIZE, y * MapScreen.__SQUARESIZE + MapScreen.__WALLSIZE, MapScreen.__WALLSIZE, MapScreen.__TILESIZE)
    end
end

return MapScreen
