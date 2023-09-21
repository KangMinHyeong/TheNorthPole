------------------------------------------------------------------------------------------------------------
--오브젝트를 회전하게 하는 스크립트
------------------------------------------------------------------------------------------------------------

local Base = Script.Parent

local RotTime = Script.RotTime
local RotRandom = Script.RotRandom

------------------------------------------------------------------------------------------------------------
--회전을 설정
if RotRandom then
   local check = math.random(0,1)
   if check == 0 then
       Base.Track:AddLocalRot("RotHammer", Vector.new(0, 0, 360), RotTime)
   else
       Base.Track:AddLocalRot("RotHammer", Vector.new(0, 0, -360), RotTime)
   end
else
   Base.Track:AddLocalRot("RotHammer", Vector.new(0, 0, 360), RotTime)
end
Base.Track:PlayTransformTrack("RotHammer", Enum.TransformPlayType.Repeat, InfinityPlay)


