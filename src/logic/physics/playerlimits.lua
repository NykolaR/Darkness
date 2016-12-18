-- 
-- playerlimits.lua
-- Contains a bunch of limiting variables for the player
-- Can be used in map generation algorithms
--

local PlayerLimits = {}
PlayerLimits.__index = {}

function PlayerLimits.new (a, b, c, d, e, f)
    return setmetatable ({
        RUNCAP = a or 0.16,
        SPRINTCAP = b or 0.3,
        JUMP = c or -0.3,
        WALLJUMPVERT = d or -0.25,
        WALLJUMPHORI = e or 0.25,
        GRIPFALL = f or 0.03
    }, PlayerLimits)
end

return PlayerLimits
