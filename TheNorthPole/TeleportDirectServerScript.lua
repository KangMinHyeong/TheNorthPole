------------------------------------------------------------------------------------------------------------
--텔레포트로 캐릭터를 이동시키는 스크립트
------------------------------------------------------------------------------------------------------------

local Object = Script.Parent
local TeleportInPad = Object.TeleportIn.InPad
local TeleportOutPad = Object.TeleportOut.OutPad
local WaitCheckServer = false

TeleportInPad.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
TeleportOutPad.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)

------------------------------------------------------------------------------------------------------------
--InPad에 닿으면 OutPad 위치로 이동
local function PlayerTeleport(self, character)

   if character == nil or not character:IsCharacter() then
       return
   end

   if WaitCheckServer then
       return
   end

   local TeleportTime = Object.TeleportIn.TeleportTime
   WaitCheckServer = true
   
   wait(TeleportTime)
   
   local targetID = character:GetPlayerID()
   TeleportInPad:BroadcastEvent("StartFX", targetID)
   wait(0.2)
           
   local teleportOutPadLocation = TeleportOutPad.Location
   local teleportOutPadRotation = TeleportOutPad.Rotation
   local characterTransform = character.Transform
                       
   characterTransform.Location = Vector.new(teleportOutPadLocation.X, teleportOutPadLocation.Y, teleportOutPadLocation.Z + 20)
   characterTransform.Rotation = Vector.new(characterTransform.Rotation.X , characterTransform.Rotation.Y, teleportOutPadRotation.Z-90)
   character.Transform = characterTransform
          
   WaitCheckServer = false

   TeleportInPad:BroadcastEvent("EndFX", targetID)
      
end

TeleportInPad.Collision.OnBeginOverlapEvent:Connect(PlayerTeleport)


