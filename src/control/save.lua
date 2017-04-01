-- 
--
--

local Class = require ("src.class")

local Save = Class.new ()

local MapFrame = require ("src.entity.map.mapframe")
local Key = require ("src.entity.map.key")
local General = require ("src.logic.general")

-- Save initialization
function Save:_init (seed)
    self.seed = seed
    self.mapframes = {}
    self.keys = {}

    General.setSeed (seed)

    self:_build ()
end

local MAXMAPS = 4

-- Initializes all important/constant save values
function Save:_build ()
    local numberOfMaps = General.randomInt (MAXMAPS - 2) + 2

    for i=1, numberOfMaps do
        table.insert (self.mapframes, MapFrame ())
    end

    self.mapframes [1]:setHome ()

    local numberOfKeys = math.floor (numberOfMaps / 2)
    numberOfKeys = numberOfKeys + General.randomInt (numberOfMaps)

    self:_generateKeys (numberOfKeys)
    self:_setKeyDepths ()
    self:_connectMaps ()

    self:_addKeysToMaps ()
end

-- Generate the designated number of keys
function Save:_generateKeys (number)
    -- First key, no blocks
    self.keys [1] = Key (1)

    for i=2, number do
        self.keys [i] = Key (i)

        for j=(i-1), 1, -1 do
            if General.bool () then
                -- Add block if not already present
                if not self.keys [i]:hasBlockRecurse (self.keys [j]) then
                    self.keys [i]:addBlock (self.keys [j])
                end
            end
        end
    end
end

function Save:_setKeyDepths ()
    for _,value in pairs (self.keys) do
        local depth = 0
        local check = value

        while (#check.blocks > 0) do
            depth = depth + #check.blocks
            check = check.blocks [1]
        end

        value.depth = depth
    end
end

function Save:_connectMaps ()
    for i=2, #self.mapframes do
        local addMap = self.mapframes [i]

        -- Connect to random maps
        for j=(i-1), 1, -1 do
            if General.bool () then
                if #addMap.mapConnections == 0 then
                    addMap:addMapConnection (self.mapframes [j])
                end
            end
        end

        -- If no connections were made, connect to home
        if #addMap.mapConnections == 0 then
            addMap:addMapConnection (self.mapframes [1])
        end
    end
end

function Save:_addKeysToMaps ()
    for i=1, #self.keys do
        self.mapframes [General.randomInt (#self.mapframes)]:addKey (self.keys [i])
    end
end

return Save
