-- 
--
--

local Helper = {}

local General = require ("src.logic.general")
local MapElement = require ("src.entity.map.mapelement")

function Helper.isClear (frame, room)
    if frame.home and frame.home.rect then
        if room.rect:intersects (frame.home.rect) then
            return false
        end
    end

    for _,elevator in pairs (frame.elevatorsOut) do
        if room.rect:intersects (elevator.rect) then
            return false
        end
    end

    for _,elevator in pairs (frame.elevatorsIn) do
        if room.rect:intersects (elevator.rect) then
            return false
        end
    end

    for _,key in pairs (frame.keys) do
        if not key == room then
            if key.rect then
                if room.rect:intersects (key.rect) then
                    return false
                end
            end
        end
    end

    return true
end

function Helper.connectMap (frames)
    for _,frame in pairs (frames) do
        if frame.home then
            Helper.connectHome (frame)
        else
            Helper.connect (frame)
        end
    end
end

function Helper.connectHome (frame)
    Helper.connect (frame)
end

function Helper.connect (frame)
    if not frame.rect then return end

    local mid = frame.rect.x
    mid = mid + General.randomInt (frame.rect.width - 1)
    
    local min, max = Helper.yExtents (frame)

    local c = MapElement ()
    c:setRect (mid, min, 1, max - min)

    frame:addConnect (c)

    Helper.linkThis (frame.elevatorsOut, frame, mid)
    Helper.linkThis (frame.elevatorsIn, frame, mid)
    Helper.linkThis (frame.keys, frame, mid)
end

function Helper.linkThis (checktable, frame, mid)
    for _,out in pairs (checktable) do
        for x=out.rect.x, (out.rect.x + out.rect.width - 1) do
            for y=out.rect.y, (out.rect.y + out.rect.height - 1) do
                if (x >= frame.rect.x and x < (frame.rect.x + frame.rect.width)) and
                   (y >= frame.rect.y and y < (frame.rect.y + frame.rect.height)) then
                    -- connect
                    local l = MapElement ()
                    if x < mid then
                        l:setRect (x + 1, y, mid - x - 1, 1)
                    else
                        l:setRect (mid + 1, y, x - mid - 1, 1)
                    end

                    frame:addLink (l)
                end
            end
        end
    end
end

-- returns the min and max y values in the frame
function Helper.yExtents (frame)
    local min, max = frame.rect.y + frame.rect.height, frame.rect.y

    local function recCheck (rect)
        min = math.min (rect.y, min)
        max = math.max (rect.y + rect.height, max)
    end

    if frame.home and frame.home.rect then
        min = math.min (frame.home.rect.y + frame.home.rect.height, min)
    end

    for _,elevator in pairs (frame.elevatorsOut) do
        recCheck (elevator.rect)
    end

    for _,elevator in pairs (frame.elevatorsIn) do
        recCheck (elevator.rect)
    end

    for _,key in pairs (frame.keys) do
        recCheck (key.rect)
    end

    min = math.max (min, frame.rect.y)
    max = math.min (max, frame.rect.y + frame.rect.height)

    return min, max
end

function Helper.elevatorOutPoint (frame, elevator, from)
    local x1,y1,x2,y2
    if elevator.rect.width == 3 then
        -- Either left or right
        if elevator.rect.x < frame.rect.x then
            -- Elevator on left edge
            x1,y1 = elevator.rect.x + elevator.rect.width + 1, elevator.rect.y
            x2,y2 = from.rect.x - 1, from.rect.y + General.randomInt (from.rect.height)
        else
            -- Elevator on right edge
            x1,y1 = elevator.rect.x - 1, elevator.rect.y
            x2,y2 = from.rect.x + from.rect.width + 1, from.rect.y + General.randomInt (from.rect.height)
        end
    else
        x1,y1 = elevator.rect.x, elevator.rect.y - 1
        x2,y2 = from.rect.x + General.randomInt (from.rect.width), from.rect.y + from.rect.height + 1
    end

    return x1,y1,x2,y2
end

return Helper
