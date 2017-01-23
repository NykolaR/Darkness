-- 
-- lightlines.lua
-- Renders light lines
-- Pretty awesome TBH. Potential performance increase: remove use of tables in algo
-- Version: 2.0
-- Last Refactored Dec. 21st, 2016
-- Quality: Probably good
--

local LightLines = {}

LightLines.canvas = love.graphics.newCanvas (love.graphics.getWidth (), love.graphics.getHeight ())
LightLines.canvas:setFilter ("nearest", "nearest")
LightLines.lastCanvas = nil

LightLines.lock = false

function LightLines.startLines ()
    LightLines.lastCanvas = love.graphics.getCanvas ()
    love.graphics.setCanvas (LightLines.canvas)
end

function LightLines.endLines ()
    love.graphics.setCanvas (LightLines.lastCanvas)
end

function LightLines.clear ()
    LightLines.startLines ()

    --love.graphics.setColor (240, 240, 240, 255)
    --love.graphics.setBlendMode ("multiply", "alphamultiply")
    --love.graphics.rectangle ("fill", 0, 0, LightLines.canvas:getWidth (), LightLines.canvas:getHeight ())

    love.graphics.setColor (4, 4, 4)
    --love.graphics.setColor (3, 3, 3)
    --love.graphics.setColor (0, 0, 0, 250)
    love.graphics.setBlendMode ("subtract", "alphamultiply")
    love.graphics.rectangle ("fill", 0, 0, LightLines.canvas:getWidth (), LightLines.canvas:getHeight ())

    LightLines.endLines ()
end

function LightLines.render ()
    love.graphics.draw (LightLines.canvas)
end

function LightLines.renderLine (playArea, Cx, Cy, Lx, Ly, lineLength, illuminate)
    local statics = playArea.ENVIRONMENT
    local dynamics = playArea.ENEMIES
    local lineLength = lineLength or 1
    local center = {x = Cx, y = Cy}
    local line = {x = Lx, y = Ly}
    local dist = 10000
    local returnLine = {}

    local collided

    for i,v in pairs (statics) do
        local result, intersect = LightLines.intersecter (center, line, { x = v.hitbox.x, y = v.hitbox.y }, { x = v.hitbox.x + v.hitbox.width, y = v.hitbox.y }, lineLength) -- TOP
        if result then
            if LightLines.dst2 (Cx, Cy, intersect.x, intersect.y) < dist then
                dist = LightLines.dst2 (Cx, Cy, intersect.x, intersect.y)
                returnLine.x = intersect.x
                returnLine.y = intersect.y
                collided = v
            end
        end
        result, intersect = LightLines.intersecter (center, line, { x = v.hitbox.x, y = v.hitbox.y + v.hitbox.height }, { x = v.hitbox.x + v.hitbox.width, y = v.hitbox.y + v.hitbox.height }, lineLength) -- BOTTOM
        if result then
            if LightLines.dst2 (Cx, Cy, intersect.x, intersect.y) < dist then
                dist = LightLines.dst2 (Cx, Cy, intersect.x, intersect.y)
                returnLine.x = intersect.x
                returnLine.y = intersect.y
                collided = v
            end
        end

        result, intersect = LightLines.intersecter (center, line, { x = v.hitbox.x + v.hitbox.width, y = v.hitbox.y }, { x = v.hitbox.x + v.hitbox.width, y = v.hitbox.y + v.hitbox.height }, lineLength) -- RIGHT
        if result then
            if LightLines.dst2 (Cx, Cy, intersect.x, intersect.y) < dist then
                dist = LightLines.dst2 (Cx, Cy, intersect.x, intersect.y)
                returnLine.x = intersect.x
                returnLine.y = intersect.y
                collided = v
            end
        end

        result, intersect = LightLines.intersecter (center, line, { x = v.hitbox.x, y = v.hitbox.y }, { x = v.hitbox.x, y = v.hitbox.y + v.hitbox.height }, lineLength) -- LEFT
        if result then
            if LightLines.dst2 (Cx, Cy, intersect.x, intersect.y) < dist then
                dist = LightLines.dst2 (Cx, Cy, intersect.x, intersect.y)
                returnLine.x = intersect.x
                returnLine.y = intersect.y
                collided = v
            end
        end
    end

    if returnLine.x and returnLine.y then
        if not LightLines.lock then
            love.graphics.line (Cx, Cy, returnLine.x, returnLine.y)
        end
        if illuminate then
            collided:illuminate (returnLine.x, returnLine.y)
        end
    else
        if not LightLines.lock then
            love.graphics.line (Cx, Cy, Lx, Ly)
        end
    end
end

function LightLines.intersecter (c, r, a, b, lineLength)
    -- s (r.x - c.x) - t (b.x - a.x) = a.x - c.x
    -- s (r.y - c.y) - t (b.y - a.y) = a.y - c.y
    -- if 0 <= s, t <= 1 then true
    -- then
    -- xSolve = c.x + s * (r.x - c.x)
    -- ySolve = c.y + s * (r.y - c.y)

    -- s = (a.x - c.x + (t * (b.x - a.x))) / (r.x - c.x)
    --
    -- ( (a.x - c.x + (t * (b.x - a.x))) / (r.x - c.x) ) * (r.y - c.y) - t (b.y - a.y) = a.y - c.y
    -- ( (a.x - c.x + (t * (b.x - a.x))) * (r.y - c.y) = (a.y - c.y + t (b.y - a.y) ) * (r.x - c.x)
    -- (a.x - c.x) * (r.y - c.y) + (t * (b.x - a.x) * (r.y - c.y)) = (a.y - c.y) * (r.x - c.x) + t * (b.y - a.y) * (r.x - c.x)
    -- t * (b.x - a.x) * (r.y - c.y) - t * (b.y - a.y) * (r.x - c.x) = (a.y - c.y) * (r.x - c.x) - (a.x - c.x) * (r.y - c.y)
    -- t * ( (b.x - a.x) * (r.y - c.y) - (b.y - a.y) * (r.x - c.x) ) = (a.y - c.y) * (r.x - c.x) - (a.x - c.x) * (r.y - c.y)
    -- t = ( (a.y - c.y) * (r.x - c.x) - (a.x - c.x) * (r.y - c.y) ) / ( (b.x - a.x) * (r.y - c.y) - (b.y - a.y) * (r.x - c.x) )
    local t = ( (a.y - c.y) * (r.x - c.x) - (a.x - c.x) * (r.y - c.y) ) / ( (b.x - a.x) * (r.y - c.y) - (b.y - a.y) * (r.x - c.x) )

    if t < 0 or t > 1 then
        return false
    end

    local s = (a.x - c.x + (t * (b.x - a.x))) / (r.x - c.x)

    if s < 0 or s > 1 then
        return false
    end

    if s and s > lineLength then
        s = lineLength
    end

    local xSolve = c.x + s * (r.x - c.x)
    local ySolve = c.y + s * (r.y - c.y)

    if xSolve and ySolve then
        return true, {x = xSolve, y = ySolve}
    end

    return false
end

function LightLines.dst2 (x1, y1, x2, y2)
    if x1 and y1 and x2 and y2 then
        return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
    end
    return 0
end

return LightLines
