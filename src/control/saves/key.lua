-- 
-- key.lua
--

local Key = {}
Key.__index = Key

setmetatable (Key, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- A keys "block" is the key(s) required to access it's room
-- A keys "choke" is the key(s) required to leave it's room (usually, either empty or itself)
function Key:_init ()
    self.blocks = {}
    self.chokes = {}
end

function Key:addBlock (block)
    if block then
        table.insert (self.blocks, block)
    end
end

function Key:addChoke (choke)
    if choke then
        table.insert (self.chokes, choke)
    end
end

function Key:hasBlock (block)
    if not block then return false end

    for i,v in pairs (self.blocks) do
        if v == block then
            return true
        end
    end

    return false
end

function Key:hasChoke (choke)
    if not choke then return false end

    for i,v in pairs (self.chokes) do
        if v == choke then
            return true
        end
    end
    
    return false
end

function Key:hasBlockRecurse (block, keys)
    if not block then return false end

    if self:hasBlock (block) then return true end

    for i,v in pairs (self.blocks) do
         if keys [v]:hasBlockRecurse (block, keys) then
             return true
         end
    end

    return false
end

function Key:hasChokeRecurse (choke, keys)
    if not choke then return false end

    if self:hasChoke (choke) then return true end

    for i,v in pairs (self.chokes) do
         if keys [v]:hasChokeRecurse (choke, keys) then
             return true
         end
    end

    return false
end

return Key
