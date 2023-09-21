------------------------------------------------------------------------------------------------------------
--오브젝트를 회전하게 하는 스크립트
------------------------------------------------------------------------------------------------------------

local Toy = Script.Parent
local Base = Toy.Base 

local Angle = Script.Angle
local MoveTime = Script.MoveTime

local Count = 1
local TweenCheck = false

local TweenObject = require(ScriptModule.DefaultModules.TweenObject)
local Tween = TweenObject.new(Base)

------------------------------------------------------------------------------------------------------------
--회전을 설정
local function Update(UpdateTime)
   if Tween ~= nil then
       if Tween:IsPlaying() == false and TweenCheck == false then
           TweenCheck = true
           if Count == 1 then
               Tween:StartRotationLocal(MoveTime, Vector.new(0, Angle, 0), "InOut")
               Count = Count + 1
           elseif Count == 2 then
               Tween:StartRotationLocal(MoveTime, Vector.new(0, -Angle, 0), "InOut")
               Count = 1
           end
           TweenCheck = false
       end
       Tween:Update(UpdateTime)
   end
end
Base.OnUpdateEvent:Connect(Update)

