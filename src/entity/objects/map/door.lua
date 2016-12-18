-- 
-- door.lua
-- types:
-- | -1 -> wall |
-- 0 -> hole |
-- 1+ -> locked door
--

local Door = {}
Door.__index = Door

setmetatable (Door, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

function Door:_init (doorType)
    self.doorType = doorType or -1
end

function Door:set (doorType)
    self.doorType = doorType or self.doorType
end

function Door.areEqual (doorOne, doorTwo)
    if (doorOne.doorType == doorTwo.doorType) then
        return true
    end
    return false
end

return Door
