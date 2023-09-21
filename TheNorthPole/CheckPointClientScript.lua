local Object = Script.Parent
local Shape = Object.Shape
local Trigger = Shape.Trigger
local ClickSound = Shape.ClickSound
local CheckUI = Object.CheckPointUI

local color = Color.new(255, 0, 255, 0)
local Overcheck = false

CheckUI.Visible = false


local function SetCheckPoint(self, character)
   if not character:IsCharacter() or not character:IsMyCharacter() or Overcheck then
       return
   end
   
   Overcheck = true
   
   Shape:SetColor(color)
   ClickSound:Play()
   
   CheckUI.Visible = true
   wait(1)
   CheckUI.Visible = false

end
Trigger.Collision.OnBeginOverlapEvent:Connect(SetCheckPoint)


local function EndOver(self, character)
   if not character:IsCharacter() or not character:IsMyCharacter() or not Overcheck then
       return
   end
   
   Overcheck = false   

end
Trigger.Collision.OnEndOverlapEvent:Connect(EndOver)
