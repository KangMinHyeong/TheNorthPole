------------------------------------------------------------------------------------------------------------
--연출을 처리하는 스크립트
------------------------------------------------------------------------------------------------------------

local Object = Script.Parent
local TeleportInPad = Object.TeleportIn.InPad

local StartList = Object.TeleportIn.StartFX:GetChildList()
local EndList = Object.TeleportOut.EndFX:GetChildList()
local EndTrailList = Object.TeleportOut.EndTrailFX:GetChildList()

------------------------------------------------------------------------------------------------------------
--텔레포트 시작시 이펙트와 소리를 재생
local function StartFX(playerID)

   if playerID == nil then
       return
   end
           
   local StartTarget = Game:GetRemotePlayerCharacter(playerID)

   for i = 1, #StartList do
       if StartList[i]:IsFX() then
           StartTarget:CreateFX(StartList[i], Enum.Bone.Body)
       elseif StartList[i]:IsSound() then
           StartList[i]:Play()    
       end
   end
   
end
TeleportInPad:ConnectEventFunction("StartFX", StartFX)

------------------------------------------------------------------------------------------------------------
--텔레포트 종료시 이펙트와 소리를 재생
local function EndFX(playerID)

   if playerID == nil then
       return
   end
   
   local EndTarget = Game:GetRemotePlayerCharacter(playerID)

   for i = 1, #EndList do
       if EndList[i]:IsFX() then
           EndTarget:CreateFX(EndList[i], Enum.Bone.Body)
       elseif EndList[i]:IsSound() then
           EndList[i]:Play()
       end
   end

   for i = 1, #EndTrailList do
       if EndTrailList[i]:IsFX() then
           EndTarget:CreateFX(EndTrailList[i], Enum.Bone.Root)   
       end
   end
   
    if EndTarget:IsMyCharacter() then
       local Endrotation = EndTarget.Rotation
       local CurrentCamRotation = LocalPlayer:GetControlRotation()
                               
       local vector = Vector.new(CurrentCamRotation.X, Endrotation.Z, Endrotation.Y)
       LocalPlayer:SetControlRotation(vector)  
   end
   
end
TeleportInPad:ConnectEventFunction("EndFX", EndFX)