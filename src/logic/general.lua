-- 
-- general.lua
-- General logic things
-- Mostly contains constants, a few functions though
--

local General = {}

General.Directions = {UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4,
    UPRIGHT = 5, DOWNRIGHT = 6, DOWNLEFT = 7, UPLEFT = 8, HORIZONTAL = 9, VERTICAL = 10}
General.GRAVITY = -0.01 -- 0.3 / 32.0 * -1
General.TERMINAL_VERTICAL = 0.375
General.TERMINAL_HORIZONTAL = 0.375
General.DEFAULTFRICTION = 0.01 -- 0.3 / 32.0

General.Random = love.math.newRandomGenerator (0)
General.ROOMSIZE = 23

General.dt = 0

-- Returns a random direction that *isn't* the argument direction
function General.randomFourWayDirection (notDirection)
    local nd = notDirection or 0
    local retVal = nd

    while (nd == retVal) do
        retVal = General.Random:random (1, 4)
    end
    return retVal
end

function General.oppositeDirection (dir)
    if not dir then return 0 end

    if dir == 1 then return 3 end
    if dir == 2 then return 4 end
    if dir == 3 then return 1 end
    if dir == 4 then return 2 end
    if dir == 5 then return 6 end
    if dir == 6 then return 5 end
    return 0
end

function General.numTrues (intable)
    local count = 0
    for i=1, #intable do
        if intable [i] == true then count = count + 1 end
    end
    return count
end

function General.allEqual (x1, x2, x3, x4)
    return (x1 == x2) and (x1 == x3) and (x1 == x4) and (x2 == x3) and (x2 == x4) and (x3 == x4)
end

function General.randomColor ()
    return {General.Random:random (0, 255), General.Random:random (0, 255), General.Random:random (0, 255)}
end

function General.randomFloatColor ()
    return {General.Random:random (), General.Random:random (), General.Random:random ()}
end

function General.setSeed (seed)
    General.Random:setSeed (seed)
end

function General.randomInt (high)
    local high = high or 1000000000000
    return General.Random:random (1, high)
end

function General.bool ()
    return (General.Random:random (2) == 1)
end

return General
