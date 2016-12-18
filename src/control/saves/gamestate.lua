-- gamestate.lua
-- Controls the general save files
-- This includes creating, loading, and writing saves
--

local General = require ("src.logic.general")
local Explore = require ("src.control.gamestates.explore")

return {

-- Create a save game
set = function (save)
    General.Random:setSeed (os.time ())
    local seeds = {General.Random:random (1, 100000000), General.Random:random (1, 1000000000)}
    return Explore (seeds)
end



}
