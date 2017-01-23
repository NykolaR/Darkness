-- 
-- conf.lua
--

function love.conf (t)
    t.window.title = "Darkness"
    t.window.fullscreentype = "desktop"
    t.window.fullscreen = false

    t.window.width = 1280
    --t.window.height = 720
    t.window.height = 576

    t.modules.touch = false
end
