-- 
--
--

local GameCreate = {}

local General = require ("src.logic.general")
local Explore = require ("src.control.gamestate.explore")
local Save = require ("src.control.save")
local MapGenerate = require ("src.logic.generation.map.mapgenerate")

-- Creates a new save game
-- Argument: save slot
function GameCreate.createSave (save)
    General.Random:setSeed (os.time ())

    for i=1, 5 do
        General.randomInt ()
    end

    local seed = General.randomInt ()
    return Explore (GameCreate.createNewSaveGame (seed))
end

-- Loads a save game
-- TODO
function GameCreate.loadSave (save)

end

-- Builds the "save" table
function GameCreate.createNewSaveGame (seed)
    --General.setSeed (seed)
    local save = Save (seed)

    MapGenerate._generate (save)

    return save
end

return GameCreate
