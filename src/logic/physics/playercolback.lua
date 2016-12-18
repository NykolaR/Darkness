-- 
-- playercollider.lua
--

local PlayerCollider = {}

-- MODULES --

local Constants = require ("src.logic.general")
local PlayerLimits = require ("src.logic.physics.playerlimits")
local Input = require ("src.boundary.input.input")
local Collider = require ("src.logic.physics.collider")

--   END   --

PlayerCollider.__index = Collider

PlayerCollider.STATES = {STANDING = 1, FALLING = 2, JUMPING = 3, EDGE = 4}

function PlayerCollider.new (x, y)
    return setmetatable ({
        collider = Collider.new (x or 0, y or 0, 1, 1),
        limits = PlayerLimits.new (),
        state = PlayerCollider.STATES.FALLING,
        direction = false,
        grounded = false,
        leftWall = false,
        rightWall = false,
        grip = false,
        roof = false,
        currentFloor = nil,
        movementMultiplier = 1,
        playerDir = Constants.Directions.RIGHT
    }, PlayerCollider)
end

function PlayerCollider:act ()
    self.collider:setLastPosition ()
    self:horizontalMovement ()
    self:verticalMovement ()
    self:friction ()
    self:actLimits ()

    -- TODO TODO TODO TODO
    -- movement multiplier --

    self.collider:movePosition ()

    self:setState ()

    self.grounded = false
    self.roof = false
    self.leftWall = false
    self.rightWall = false
    self.grip = false
    self.movementMultiplier = 1
end

function PlayerCollider:actLimits ()
    self.collider:limits ()
end

function PlayerCollider:setFloor (newFloor)
    self.currentFloor = newFloor or nil
end

function PlayerCollider:verticalMovement ()
    if (self.grounded or self.roof or self.collider.vSpeed < 0 and (not Input.keyDown (Input.KEYS.JUMP))) then
        self.collider.vSpeed = 0
    end

    if (self.collider.vSpeed >= 0 and (self.leftWall and Input.keyDown (Input.KEYS.LEFT)) or (self.rightWall and Input.keyDown (Input.KEYS.RIGHT))) then
        self.collider.vSpeed = self.limits.GRIPFALL
    else
        self.collider.vSpeed = self.collider.vSpeed - Constants.GRAVITY
    end

    if Input.keyPressed (Input.KEYS.JUMP) then
        if grounded then
            self.collider.vSpeed = self.limits.JUMP
        else
            if (self.leftWall and Input.keyDown (Input.KEYS.LEFT) and self.grip) then
                self.collider.vSpeed = self.limits.WALLJUMPVERT
                self.collider.hSpeed = self.limits.WALLJUMPHORI
            elseif (self.rightWall and Input.keyDown (Input.KEYS.RIGHT) and self.grip) then
                self.collider.vSpeed = self.limits.WALLJUMPVERT
                self.collider.hSpeed = self.liimts.WALLJUMPHORI * -1
            end
        end
    end
end

function PlayerCollider:horizontalMovement ()
    if ((self.collider.hSpeed > 0 and self.rightWall) or (self.collider.hSpeed < 0 and self.leftWall)) then
        self.collider.hSpeed = 0
    end

    if Input.keyDown (Input.KEYS.LEFT) then
        if self.grounded then
            if Input.keyDown (Input.KEYS.SPRINT) then
                self.collider.hSpeed = self.collider.hSpeed - 0.02
                if self.collider.hSpeed < (self.limits.SPRINTCAP * -1) then
                    self.collider.hSpeed = self.limits.SPRINTCAP * -1
                end
            else
                self.collider.hSpeed = self.collider.hSpeed - 0.015
                if self.collider.hSpeed < (self.limits.RUNCAP * -1) then
                    self.collider.hSpeed = self.limits.RUNCAP * -1
                end
            end
        else
            self.collider.hSpeed = self.collider.hSpeed - 0.006
        end
    end

    if Input.keyDown (Input.KEYS.RIGHT) then
        if self.grounded then
            if Input.keyDown (Input.KEYS.SPRINT) then
                self.collider.hSpeed = self.collider.hSpeed + 0.02
                if self.collider.hSpeed > (self.limits.SPRINTCAP) then
                    self.collider.hSpeed = self.limits.SPRINTCAP
                end
            else
                self.collider.hSpeed = self.collider.hSpeed + 0.015
                if self.collider.hSpeed > (self.limits.RUNCAP) then
                    self.collider.hSpeed = self.limits.RUNCAP
                end
            end
        else
            self.collider.hSpeed = self.collider.hSpeed + 0.006
        end
    end

end

function PlayerCollider:friction ()
    if self.currentFloor.friction then
        self.frictionValue = self.currentFloor.friction
    else
        self.frictionValue = Constants.DEFAULTFRICTION
    end

    if self.grounded then
        if self.collider.hSpeed > self.frictionValue then
            self.collider.hSpeed = self.collider.hSpeed - self.frictionValue
        elseif self.collider.hSpeed > 0 then
            self.collider.hSpeed = 0
        end

        if self.collider.hSpeed < (self.frictionValue * -1) then
            self.collider.hSpeed = self.collider.hSpeed + self.frictionValue
        elseif self.collider.hSpeed < 0 then
            self.collider.hSpeed = 0
        end
    end
end

function PlayerCollider:setState ()
    if self.grounded then
        self.state = PlayerCollider.STATES.STANDING
    else
        if self.leftWall or self.rightWall then
            self.state = PlayerCollider.STATES.EDGE
        else
            if self.collider.vSpeed < 0 then
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
        if self.collider.hSpeed > 0 then
            self.direction = false
            if Input.keyDown (Input.KEYS.UP) then
                --if playerDir != UPRIGHT, woggle position
                self.playerDir = Constants.Directions.UPRIGHT
            elseif Input.keyDown (Input.KEYS.DOWN) then
                self.playerDir = Constants.Directions.DOWNRIGHT
            else
                self.playerDir = Constants.Directions.RIGHT
            end
        elseif self.collider.hSpeed < 0 then
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

return PlayerCollider
