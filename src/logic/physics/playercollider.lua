-- 
-- playercollider.lua
-- Inherits from the Collider class
-- Provides many player variables and functions
-- Mostly pertains to movement
--

local PlayerCollider = {}
PlayerCollider.__index = PlayerCollider
local Collider = require ("src.logic.physics.collider")

setmetatable (PlayerCollider, {
    __index = Collider,
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- MODULES --

local Constants = require ("src.logic.general")
local PlayerLimits = require ("src.logic.physics.playerlimits")
local Input = require ("src.boundary.input.input")
local Rectangle = require ("src.logic.rectangle")

--   END   --

PlayerCollider.STATES = {STANDING = 1, FALLING = 2, JUMPING = 3, EDGE = 4}

function PlayerCollider:_init (x, y)
    Collider._init (self, x, y, 1, 1)
    self.limits = PlayerLimits.new ()
    self.state = PlayerCollider.STATES.FALLING
    self.direction = false
    self.grounded = false
    self.leftWall = false
    self.rightWall = false
    self.grip = false
    self.roof = false
    self.currentFloor = nil
    self.movementMultiplier = 1
    self.playerDir = Constants.Directions.RIGHT
end

-- Performs all movements for frame
-- Calls subroutines
function PlayerCollider:act ()
    self:setLastPosition ()
    self:horizontalMovement ()
    self:verticalMovement ()
    self:friction ()
    Collider.limits (self)

    -- TODO TODO TODO TODO
    -- movement multiplier --
    self.vSpeed = self.vSpeed * self.movementMultiplier
    self.hSpeed = self.hSpeed * self.movementMultiplier

    self:movePosition ()

    self:setState ()

    self.grounded = false
    self.roof = false
    self.leftWall = false
    self.rightWall = false
    self.grip = false
    self.movementMultiplier = 1
end

-- Sets the floor to the arg
function PlayerCollider:setFloor (newFloor)
    self.currentFloor = newFloor or nil
end

-- Vert. movement (including input polling)
function PlayerCollider:verticalMovement ()
    if (self.grounded or self.roof or self.vSpeed < 0 and (not Input.keyDown (Input.KEYS.JUMP))) then
        self.vSpeed = 0
    end

    if (self.vSpeed >= 0 and ((self.leftWall and Input.keyDown (Input.KEYS.LEFT)) or (self.rightWall and Input.keyDown (Input.KEYS.RIGHT)))) then
        self.vSpeed = self.limits.GRIPFALL
    else
        self.vSpeed = self.vSpeed - Constants.GRAVITY
    end

    if Input.keyPressed (Input.KEYS.JUMP) then
        if self.grounded then
            self.vSpeed = self.limits.JUMP
        else
            if (self.leftWall and Input.keyDown (Input.KEYS.LEFT) and self.grip) then
                self.vSpeed = self.limits.WALLJUMPVERT
                self.hSpeed = self.limits.WALLJUMPHORI
            elseif (self.rightWall and Input.keyDown (Input.KEYS.RIGHT) and self.grip) then
                self.vSpeed = self.limits.WALLJUMPVERT
                self.hSpeed = self.limits.WALLJUMPHORI * -1
            end
        end
    end
end

-- Hori. movement (including input polling)
function PlayerCollider:horizontalMovement ()
    if ((self.hSpeed > 0 and self.rightWall) or (self.hSpeed < 0 and self.leftWall)) then
        self.hSpeed = 0
    end

    if Input.keyDown (Input.KEYS.LEFT) then
        if self.grounded then
            if Input.keyDown (Input.KEYS.SPRINT) then
                self.hSpeed = self.hSpeed - 0.02
                if self.hSpeed < (self.limits.SPRINTCAP * -1) then
                    self.hSpeed = self.limits.SPRINTCAP * -1
                end
            else
                self.hSpeed = self.hSpeed - 0.015
                if self.hSpeed < (self.limits.RUNCAP * -1) then
                    self.hSpeed = self.limits.RUNCAP * -1
                end
            end
        else
            self.hSpeed = self.hSpeed - 0.006
        end
    end

    if Input.keyDown (Input.KEYS.RIGHT) then
        if self.grounded then
            if Input.keyDown (Input.KEYS.SPRINT) then
                self.hSpeed = self.hSpeed + 0.02
                if self.hSpeed > (self.limits.SPRINTCAP) then
                    self.hSpeed = self.limits.SPRINTCAP
                end
            else
                self.hSpeed = self.hSpeed + 0.015
                if self.hSpeed > (self.limits.RUNCAP) then
                    self.hSpeed = self.limits.RUNCAP
                end
            end
        else
            self.hSpeed = self.hSpeed + 0.006
        end
    end

end

-- Slows player down if grounded
function PlayerCollider:friction ()
    if self.currentFloor then
        self.frictionValue = self.currentFloor.friction
    else
        self.frictionValue = Constants.DEFAULTFRICTION
    end

    if self.grounded then
        if self.hSpeed > self.frictionValue then
            self.hSpeed = self.hSpeed - self.frictionValue
        elseif self.hSpeed > 0 then
            self.hSpeed = 0
        end

        if self.hSpeed < (self.frictionValue * -1) then
            self.hSpeed = self.hSpeed + self.frictionValue
        elseif self.hSpeed < 0 then
            self.hSpeed = 0
        end
    end
end

-- Sets the player state
-- Helps with animation
function PlayerCollider:setState ()
    if self.grounded then
        self.state = PlayerCollider.STATES.STANDING
    else
        if self.leftWall or self.rightWall then
            self.state = PlayerCollider.STATES.EDGE
        else
            if self.vSpeed < 0 then
                self.state = PlayerCollider.STATES.JUMPING
            else
                self.state = PlayerCollider.STATES.FALLING
            end
        end
    end

    if self.leftWall or self.rightWall then
        if self.leftWall then
            self.direction = false
            if Input.keyDown (Input.KEYS.UP) then
                self.playerDir = Constants.Directions.UPRIGHT
            elseif Input.keyDown (Input.KEYS.DOWN) then
                self.playerDir = Constants.Directions.DOWNRIGHT
            else
                self.playerDir = Constants.Directions.RIGHT
            end
        else
            self.direction = true
            if Input.keyDown (Input.KEYS.UP) then
                self.playerDir = Constants.Directions.UPLEFT
            elseif Input.keyDown (Input.KEYS.DOWN) then
                self.playerDir = Constants.Directions.DOWNLEFT
            else
                self.playerDir = Constants.Directions.LEFT
            end
        end
    else
        if self.hSpeed > 0 then
            self.direction = false
            if Input.keyDown (Input.KEYS.UP) then
                --if playerDir != UPRIGHT, woggle position
                self.playerDir = Constants.Directions.UPRIGHT
            elseif Input.keyDown (Input.KEYS.DOWN) then
                self.playerDir = Constants.Directions.DOWNRIGHT
            else
                self.playerDir = Constants.Directions.RIGHT
            end
        elseif self.hSpeed < 0 then
            self.direction = true
            if Input.keyDown (Input.KEYS.UP) then
                --if playerDir != UPLEFT, woggle position
                self.playerDir = Constants.Directions.UPLEFT
            elseif Input.keyDown (Input.KEYS.DOWN) then
                self.playerDir = Constants.Directions.DOWNLEFT
            else
                self.playerDir = Constants.Directions.LEFT
            end
        end
    end     
end

-- Render function for debug
function PlayerCollider:render ()
    love.graphics.setColor (0, 255, 255)
    love.graphics.rectangle ("fill", self.x, self.y, self.width, self.height)
end

return PlayerCollider
