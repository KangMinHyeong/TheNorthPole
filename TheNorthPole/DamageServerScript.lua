local KillPart = Script.Parent
local DamageCheck = false

local function DamageCollision(self, character)
   if not character:IsCharacter() or DamageCheck then
       return
   end
   
   if Script.InstantKill then
        character.HP = 0
   else
       DamageCheck = true
       
       character.HP = character.HP - Script.Damage
       wait(Script.Interval)
       
       DamageCheck = false
   end
end
KillPart.OnCollisionEvent:Connect(DamageCollision)


