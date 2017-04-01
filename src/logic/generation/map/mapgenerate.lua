-- 
--
--

local MapGenerate = {}

local General = require ("src.logic.general")
local MapElement = require ("src.entity.map.mapelement")
local Helper = require ("src.logic.generation.map.helper")

-- Complete the map generation of the given save file/class
function MapGenerate._generate (save)
    -- set map sizes
    MapGenerate.mapSizes (save.mapframes)

    -- set map positions
    MapGenerate.mapPositions (save.mapframes)

    -- set home position
    MapGenerate.homePosition (save.mapframes [1])

    -- connect map by joint hallways
    MapGenerate.mapLinks (save.mapframes)

    -- set key room positions
    MapGenerate.keyPositions (save.mapframes)

    -- connect home, keys and elevator (s)
    Helper.connectMap (save.mapframes)
end

function MapGenerate.mapSizes (frames)
    for _,frame in pairs (frames) do
        local w = 15 + General.randomInt (5 * #frame.keys)
        local h = 15 + General.randomInt (5 * #frame.keys)

        frame:setRect (0, 0, w, h)
    end
end

function MapGenerate.mapPositions (frames)
    for _,frame in pairs (frames) do
        if _>1 then -- Map 1 (home) is in position 0,0
            local connect = frame.mapConnections [1]
            local x2, y2 = connect.rect.x, connect.rect.y

            local w1, h1 = frame.rect.width, frame.rect.height
            local w2, h2 = connect.rect.width, connect.rect.height

            local function variedX ()
                return (x2 - w1) + General.randomInt (w2 - 1)
            end

            local function variedY ()
                return (y2 - h1) + General.randomInt (h2 - 1)
            end

            -- Add in random direction, but not up
            repeat
                local dir = General.randomFourWayDirection (General.Directions.UP)

                frame.connectDirection = dir

                if (dir == General.Directions.LEFT) then
                    -- Add map to left
                    frame.rect.x = x2 - w1 - 1

                    frame.rect.y = variedY ()
                end

                if (dir == General.Directions.RIGHT) then
                    -- Add map to right
                    frame.rect.x = x2 + w2 + 1

                    frame.rect.y = variedY ()
                end

                if (dir == General.Directions.DOWN) then
                    -- Add map to bottom
                    frame.rect.y = y2 + h2
                    
                    frame.rect.y = frame.rect.y + General.randomInt (h2)

                    frame.rect.x = variedX ()
                end
            until not MapGenerate.mapOverlapPrevious (_, frames)
        end
    end
end

-- Set the home room position
function MapGenerate.homePosition (frame)
    local home = MapElement ()
    home:setRect (0, frame.rect.y, 1, 1)

    home.rect.x = frame.rect.x + 1 + General.randomInt (math.floor (frame.rect.width / 2) - 5)
    home.rect.width = (math.floor (frame.rect.width/2) - home.rect.x) * 2
    home.rect.height = General.randomInt (frame.rect.height - 5) + 3

    frame:setHome (home)
end

function MapGenerate.mapOverlapPrevious (index, frames)
    for i=index - 1, 1, -1 do
        -- Check for overlap
        if frames [index].rect:intersects (frames [i].rect) then
            return true
        end
    end

    return false
end

-- Creates elevators / transfer rooms between the maps
function MapGenerate.mapLinks (frames)
    for i=2, #frames do
        MapGenerate.linkMap (frames [i])
    end
end

function MapGenerate.linkMap (frame)
    local connect = frame.mapConnections [1]

    local x1, y1 = frame.rect.x, frame.rect.y
    local x2, y2 = connect.rect.x, connect.rect.y

    local w1, h1 = frame.rect.width, frame.rect.height
    local w2, h2 = connect.rect.width, connect.rect.height

    local function variedX ()
        if x1 > x2 then
            if (x1 + w1) > (x2 + w2) then
                return (x1 + General.randomInt (x2 + w2 - x1) - 1)
            else
                return (x1 + General.randomInt (x1 + w1 - x1) - 1)
            end
        else
            if (x1 + w1) > (x2 + w2) then
                return (x2 + General.randomInt (x2 + w2 - x2) - 1)
            else
                return (x2 + General.randomInt (x1 + w1 - x2) - 1)
            end
        end
    end

    local function variedY ()
        if y1 > y2 then
            if (y1 + h1) > (y2 + h2) then
                return (y1 + General.randomInt (y2 + h2 - y1) - 1)
            else
                return (y1 + General.randomInt (y1 + h1 - y1) - 1)
            end
        else
            if (y1 + h1) > (y2 + h2) then
                return (y2 + General.randomInt (y2 + h2 - y2) - 1)
            else
                return (y2 + General.randomInt (y1 + h1 - y2) - 1)
            end
        end
    end

    local x, y, w, h

    if frame.connectDirection == General.Directions.DOWN then
        x = variedX ()
        y = y2 + h2 - 1
        w = 1
        h = y1 - (y2 + h2) + 2
    end

    if frame.connectDirection == General.Directions.LEFT then
        x = x1 + w1 - 1
        y = variedY ()
        w = 3
        h = 1
    end

    if frame.connectDirection == General.Directions.RIGHT then
        x = x2 + w2 - 1
        y = variedY ()
        w = 3
        h = 1
    end

    local elevator = MapElement ()

    elevator:setRect (x, y, w, h)

    frame:addElevatorIn (elevator)
    connect:addElevatorOut (elevator)
end

function MapGenerate.keyPositions (frames)
    for _,frame in pairs (frames) do
        for _,key in pairs (frame.keys) do
            MapGenerate.addKey (frame, key)
        end
    end
end

function MapGenerate.addKey (frame, key)
    local addX, addY = 0, 0
    key:setRect (addX, addY, 1, 1)

    repeat
        addX = frame.rect.x + General.randomInt (frame.rect.width) - 1

        addY = frame.rect.y + General.randomInt (frame.rect.height) - 1

        key.rect.x = addX
        key.rect.y = addY
    until Helper.isClear (frame, key)
end

return MapGenerate
