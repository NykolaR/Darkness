--[[
-- input.lua
-- Input handling
-- Can get key pressed / key held / key released
-- In order to add a key, all that is needed is to add it to the lists at the beginning. Yay!
-- A value can have an infinite number of keys
-- 
-- This will likely be the basis of input for any of my Love games for some time.
--
-- ]]

local input = {}
input ["INPUT"] = {KEY_DOWN = 1, KEY_PRESSED = 2}
input ["KEYS"] = {LEFT = 1, RIGHT = 2, UP = 3, DOWN = 4, JUMP = 5, SPRINT = 6, ACTION_ONE = 7, ACTION_TWO = 8, PAUSE = 9, MAP = 10}
input ["KEYBOARD_KEYS"] = {LEFT = {"left", "a"}, RIGHT = {"right", "d"}, UP = {"up", "w"}, DOWN = {"down", "s"}, JUMP = {"space"}, SPRINT = {"z"}, ACTION_ONE = {"c"}, ACTION_TWO = {"v"}, PAUSE = {"return"}, MAP = {"m"}}
input ["JOYSTICK_KEYS"] = {LEFT = {"dpleft"}, RIGHT = {"dpright"}, UP = {"dpup"}, DOWN = {"dpdown"}, JUMP = {"a"}, SPRINT = {"x"}, ACTION_ONE = {"rightshoulder"}, ACTION_TWO = {"leftshoulder"}, PAUSE = {"start"}, MAP = {"back"}}

input ["keys"] = {}

local Joysticks = love.joystick.getJoysticks ()
if #Joysticks > 0 then
    input.joystick = Joysticks [1]
end

for x = 1, 2 do -- 2 columns
    input.keys [x] = {}

    for y = 1, #input.KEYS do
        input.keys [x][y] = false
    end
end

function input.handleInputs ()
    --input.handleKeyboard ()
    
    if input.joystick then
        input.handleJoystick ()
    else
        input.handleKeyboard ()
    end
end

function input:handleKeyboard ()
    for i,v in pairs (input.KEYBOARD_KEYS) do
        input.checkDown (v, input.KEYS [i])
    end
end

function input:handleJoystick ()
    for i,v in pairs (input.JOYSTICK_KEYS) do
        input.checkJDown (v, input.KEYS [i])
    end
end

function input.checkJDown (joyKey, keyAction)
    local val = false
    for i,v in pairs (joyKey) do
        if input.joystick:isGamepadDown (v) then
            val = true
        end
    end
    input.setKey (keyAction, val)
end

function input.checkDown (keyKeyboard, keyAction)
    local val = false
    for i,v in pairs (keyKeyboard) do
        if love.keyboard.isDown (v or "") then
            val = true
        end
    end
    input.setKey (keyAction, val)
end

function input.setKey (key, value)
    if value then
        if input.keys [input.INPUT.KEY_DOWN][key] then
            -- Input is being held
            input.keys [input.INPUT.KEY_PRESSED][key] = false
            input.keys    [input.INPUT.KEY_DOWN][key] = true
        else
            -- This is the first frame it was pressed
            input.keys    [input.INPUT.KEY_DOWN][key] = true
            input.keys [input.INPUT.KEY_PRESSED][key] = true
        end
    else
        -- Not pressed
        input.keys    [input.INPUT.KEY_DOWN][key] = false
        input.keys [input.INPUT.KEY_PRESSED][key] = false
    end
end

function input.keyPressed (key)
    return input.keys [input.INPUT.KEY_PRESSED][key]
end

function input.keyDown (key)
    return input.keys [input.INPUT.KEY_DOWN][key]
end

return input
