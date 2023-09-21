local Object = Script.Parent
local Shape = Object.Shape
local Trigger = Shape.Trigger
local CheckSpawnPoint = Game:AddSpawnPoint(Shape)

CheckSpawnPoint:SetSpawnType(Enum.PointSpawnType.Area, 100)


local function SetCheckPoint(self, character)
   if character == nil then
       return
   end
   if not character:IsCharacter() then
       return
   end
   if character:IsDie() then
       return
   end
   
   local player = character:GetPlayer()
   
   player:SetCheckPoint(CheckSpawnPoint)
   
end
Trigger.Collision.OnBeginOverlapEvent:Connect(SetCheckPoint)






