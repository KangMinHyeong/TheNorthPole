------------------------------------------------------------------------------------------------------------
--물리를 처리하는 스크립트
------------------------------------------------------------------------------------------------------------

local Object = Script.Parent 

local Force = Script.Force
local UpForce = Script.UpForce

Object.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)

------------------------------------------------------------------------------------------------------------
--닿은 캐릭터를 넉백
local function CharacterCollision(self, character)
   if character == nil or not character:IsCharacter() then
       return
   end
   
   local selfLocation = self.Location
   local targetLocation = character.Location
   character:AddForce(Vector.new((targetLocation.X - selfLocation.X) * Force, (targetLocation.Y - selfLocation.Y) * Force, UpForce))
   Object:BroadcastEvent("Hit", targetLocation)
end
Object.Collision.OnBeginOverlapEvent:Connect(CharacterCollision)




