-- 
--
--

local Class = require ("src.class")

local MapElement = Class.new ()

local Rectangle = require ("src.logic.rectangle")

-- Blocks: key (s) required to begin interaction with the element
-- Chokes: key (s) required to end interaction with the element
function MapElement:_init ()
    self.blocks = {}
    self.chokes = {}
end

function MapElement:addBlock (block)
    table.insert (self.blocks, block)
end

function MapElement:addChoke (choke)
    table.insert (self.chokes, choke)
end

function MapElement:hasBlock (block)
    return self:_has (self.blocks, block)
end

function MapElement:hasChoke (choke)
    return self:_has (self.chokes, choke)
end

local TYPES = {BLOCK = 1, CHOKE = 2}

function MapElement:hasBlockRecurse (block)
    return self:_hasRecurse (self.blocks, block, TYPES.BLOCK)
end

function MapElement:hasChokeRecurse (choke)
    return self:_hasRecurse (self.chokes, choke, TYPES.CHOKE)
end

function MapElement:_has (table, element)
    if not element then return false end

    for _,value in pairs (table) do
        if value == element then
            return true
        end
    end

    return false
end

function MapElement:_hasRecurse (table, element, recType)
    if not element then return false end

    if self:_has (table, element) then return true end

    for _,value in pairs (table) do
        if recType == TYPES.BLOCK then
            if value:_hasRecurse (value.blocks, element, recType) then
                return true
            end
        end

        if recType == TYPES.CHOKE then
            if value:_hasRecurse (value.blocks, element, recType) then
                return true
            end
        end
    end

    return false
end

function MapElement:setRect (x, y, w, h)
    self.rect = Rectangle (x, y, w, h)
end

return MapElement
