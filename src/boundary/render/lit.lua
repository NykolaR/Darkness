-- 
-- lit.lua
-- where ya render anything light multiplies from
--

local Lit = {}

Lit.canvas = love.graphics.newCanvas (love.graphics.getWidth (), love.graphics.getHeight ())

function Lit.clear ()
    love.graphics.setCanvas (Lit.canvas)
    love.graphics.clear (0, 0, 0, 0)
end

return Lit
