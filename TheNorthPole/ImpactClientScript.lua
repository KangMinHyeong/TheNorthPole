------------------------------------------------------------------------------------------------------------
--연출을 처리하는 스크립트
------------------------------------------------------------------------------------------------------------

local Object = Script.Parent

local HitSound = Object.HitSound
local HitCheck = false

------------------------------------------------------------------------------------------------------------
--캐릭터가 닿았을때 소리를 재생
local function Hit(location)
    if not HitCheck then
        HitCheck = true
        Game:PlaySound(HitSound, location)
        wait(0.3)
        HitCheck = false
    end
end   
Object:ConnectEventFunction("Hit", Hit)


