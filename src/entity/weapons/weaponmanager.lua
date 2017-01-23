-- 
-- weaponmanager.lua
--

local WeaponManager = {}

WeaponManager.__WEAPONS = {}

-- MODULES --

local Weapon = require ("src.entity.weapons.weapon")

--   END   --

function WeaponManager.updateAndRender (dt)
    for i,v in pairs (WeaponManager.__WEAPONS) do
        if v.active then
            v:update (dt)
            v:render ()
        end
    end
end

function WeaponManager.clearWeapons ()
    WeaponManager.__WEAPONS = {}
end

function WeaponManager.update (dt)
    for i,v in pairs (WeaponManager.__WEAPONS) do
        if v.active then
            v:update (dt)
        end
    end
end

function WeaponManager.render ()
    for i, v in pairs (WeaponManager.__WEAPONS) do
        if v.active then
            v:render ()
        end
    end
end

function WeaponManager.addWeapon (weapon)
    for i,v in pairs (WeaponManager.__WEAPONS) do
        if not v.active then
            v:_copy (weapon)
            v:reset ()
            return
        end
    end

    local addWeapon = Weapon (weapon)
    table.insert (WeaponManager.__WEAPONS, addWeapon)
    addWeapon:reset ()

    print ("Num weapons: " .. #WeaponManager.__WEAPONS)
end

function WeaponManager.collision (object)
    for i, v in pairs (WeaponManager.__WEAPONS) do
        if v.active then
            if v.hitbox:intersects (object.hitbox) then
                v:collision (object)
            end
        end
    end
end

return WeaponManager
