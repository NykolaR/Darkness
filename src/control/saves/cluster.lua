-- 
-- cluster.lua
--

local Cluster = {}
Cluster.__index = Cluster

setmetatable (Cluster, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- A cluster is the same as a key, but it contains a set of keys
-- It represents an area of a map, or a map itself
function Cluster:_init ()
    self.keys = {}
    self.blocks = {}
    self.chokes = {}
end

function Cluster:addKey (key)
    if key then
        table.insert (self.keys, key)
    end
end

function Cluster:addBlock (block)
    if block then
        table.insert (self.blocks, block)
    end
end

function Cluster:addChoke (choke)
    if choke then
        table.insert (self.chokes, choke)
    end
end

return Cluster
