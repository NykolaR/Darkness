-- gamestate.lua
-- Controls the general save files
-- This includes creating, loading, and writing saves
-- Version: 0.1
-- Last Refactor: 
-- Quality: WIP
--

local GameState = {}

local General = require ("src.logic.general")
local Explore = require ("src.control.gamestates.explore")
local Key = require ("src.control.saves.key")

-- Create a save game
function GameState.set (save)
    General.Random:setSeed (os.time ())
    local seed = General.randomInt ()
    return GameState.createSaveGame (seed)
end

function GameState.loadSave (save)
    local seed = loadSeed ()

    return GameState.createSaveGame (seed)
end

function GameState.loadSeed ()
    return General.randomInt ()
end

function GameState.createSaveGame (seed)
    if not seed then
        return nil
    end

    General.setSeed (seed)

    local save = {}

    -- Number of maps (therefore main clusters) in the save game
    save.numberOfMaps = General.randomInt (4)

    -- Number of keys in the save game
    -- At least = the number of maps in the game + 1
    -- At most = 3 times the number of maps (3 keys per map)

    -- save.numberOfKeys = save.numberOfMaps + General.randomInt (save.numberOfMaps * 2)
    save.numberOfKeys = (save.numberOfMaps + 4) + General.randomInt (math.floor (save.numberOfMaps / 2))
    save.numberOfWeapons = General.randomInt (save.numberOfMaps) - 1

    -- Set keys per map
    -- keysPerMap (save)

    save.keys = {}

    GameState.generateKeys (save)

    -- return save

    return Explore ({General.randomInt ()})
end

--[[
keysPerMap = function (save)
    local placed = 0
    save.keysPlaced = {}

    for i=1, save.numberOfMaps do
        save.keysPlaced [i] = 1
        placed = placed + 1
    end

    while (placed < save.numberOfKeys) do
        local rand = General.randomInt (save.numberOfMaps)
        save.keysPlaced [i] = save.keysPlaced [i] + 1
        placed = placed + 1
    end
end
--]]

-- Create a heirarchy of keys
function GameState.generateKeys (save)
    -- TODO
   
    -- Initial key. No blocks
    save.keys [1] = Key ()

    for i=2, save.numberOfKeys do
        save.keys [i] = Key ()
        
        -- Give key random blocks
        for j=(i - 1), 1, -1 do
            if General.bool () then
                -- Add block (if isn't already there)
                if not save.keys [i]:hasBlockRecurse (j, save.keys) then
                    save.keys [i]:addBlock (j)
                end
            end
        end
    end

    for i=1, save.numberOfKeys do
        print ("Key: " .. i .. ", Blocks: ")
        for j,v in pairs (save.keys [i].blocks) do
            print (v .. " ")
        end
    end


end

return GameState

--[[
-- 
-- Steps to generate map:
--
--]]
