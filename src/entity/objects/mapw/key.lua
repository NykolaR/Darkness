-- 
--
--

local Class = require ("src.class")
local MapElement = require ("src.entity.map.mapelement")

local Key = Class.new (MapElement)

-- Key initialization
function Key:_init (index)
    MapElement._init (self)
    self.index = index
    self.depth = 0
end

return Key
