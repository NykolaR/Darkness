-- 
--
--

local Class = require ("src.class")
local MapElement = require ("src.entity.map.mapelement")

local MapFrame = Class.new (MapElement)

local General = require ("src.logic.general")

function MapFrame:_init ()
    MapElement._init (self)
    self.seed = General.randomInt ()
    self.mapConnections = {}
    self.keys = {}

    self.elevatorsOut = {}
    self.elevatorsIn = {}

    self.links = {} -- vertical map connectors
    self.connects = {} -- connections from links to rooms
end

function MapFrame:addMapConnection (map)
    table.insert (self.mapConnections, map)
end

function MapFrame:getConnections ()
    return #self.mapConnections
end

function MapFrame:setHome (home)
    self.home = home or true
end

function MapFrame:addKey (key)
    table.insert (self.keys, key)
end

function MapFrame:addElevatorOut (elevator)
    table.insert (self.elevatorsOut, elevator)
end

function MapFrame:addElevatorIn (elevator)
    table.insert (self.elevatorsIn, elevator)
end

function MapFrame:addLink (link)
    table.insert (self.links, link)
end

function MapFrame:addConnect (connect)
    table.insert (self.connects, connect)
end

return MapFrame
