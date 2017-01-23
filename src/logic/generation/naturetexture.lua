-- 
-- naturetexture.lua
-- Uses Chlandni theorem to simulate organic and inorganic textures onto 2D surfaces
--

local NatureTexture = {}

-- MODULES --

local General = require ("src.logic.general")

--   END   --

-- u (x, y, t) = A * exp (Kx*X + Ky*Y - wt)
-- u (x, y, t) = A * sin (Kx*x) * sin (Ky*y) * cos (wt)
-- A = length, B = height
--
-- u (x, y, t) = A * sin ( n * pi * X / A) * sin (m * pi * Y / b) * cos (wt)
-- Where there are (n-1) nodes running in the y-direction and (m-1) in the x-direction
-- w = 2 * pi * frequency
-- t = ... time?
--

function NatureTexture.generateTexture (tex)
    if not tex then
        return
    end
    love.graphics.setCanvas (tex)
    love.graphics.clear (0, 0, 0, 255)
    
    local a, b = tex:getWidth (), tex:getHeight ()

    local points = {}
    
    for x=1, a do
        points [x] = {}
    end

    local loops = General.Random:random (5, 100)

    for i=1, loops do
        NatureTexture.complicate (points, a, b)
    end

    for x=1, a do
        for y=1, b do
            love.graphics.setColor ((points[x][y]) * 255 / (loops), (points[x][y]) * 255 / (loops), (points[x][y]) * 255 / (loops), 255)
            love.graphics.points (x, y)
        end
    end

    love.graphics.setCanvas ()
end

-- 
-- A magical function! :D
-- Parameters:
-- A - Controls contrast. Generally, ~30+ will create a binary image. 20 is high contrast. 10 is bright. 1&lower create muted images
-- n - Number of columns. Generall want it to be even (Div. by 2?). Can handle non whole numbers
-- m - Number of rows. Div by 2?
-- frequency - Adjusts brightness / contrast. Cyclic to some extent
-- t - effects brightness. Don't know how to control
--
-- phaseX, phaseY - Shift the color used. Can get neat effects if used in extremes. Can cause the texture to loop poorly
--
function NatureTexture.complicate (points, a, b, A, n, m, frequency, t, phaseX, phaseY)
    local A = A or (General.Random:random () + 0.5) * General.Random:random (1, 20)
    local n = n or General.Random:random (2, 40) / 2
    local m = m or General.Random:random (2, 40) / 2
    local frequency = frequency or General.Random:random (1, 300)
    local w = 2 * math.pi * frequency
    local t = t or General.Random:random () * General.Random:random (1, 100)

    local phaseX, phaseY = phaseX or (General.Random:random () - 0.5) * General.Random:random (1, shift or n), phaseY or (General.Random:random () - 0.5) * General.Random:random (1, shift or m)

    for x=1, a do
        for y=1, b do
            if not mult then
                points [x][y] = (points [x][y] or 0) + (A * math.sin (n * math.pi * (x + phaseX) / a) * math.sin (m * math.pi * (y + phaseY) / b) * math.cos (w * t))
            else
                points [x][y] = (points [x][y] or .8) * (A * math.sin (n * math.pi * (x + phaseX) / a) * math.sin (m * math.pi * (y + phaseY) / b) * math.cos (w * t))
            end
        end
    end
end

return NatureTexture
