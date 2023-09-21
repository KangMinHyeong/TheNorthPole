local Item = Script.Parent.Parent.Parent
local Collider = Script.Parent

Item.Base.Bullet.Enable = false
Collider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)

local function GetItem(self, character)
   if not character:IsCharacter() then
       return
   end
   
   local playerID = character:GetPlayerID()
   local player = Game:GetPlayer(playerID)
   local size = player:GetInventorySize()
   
   for i = 1, size do
       if player:GetInventoryItem(i) ~= nil and player:GetInventoryItem(i).Name == Item.Name then -- 인벤토리에 같은 아이템이 있다면
           player:DeleteItem(i) -- i번 아이템을 삭제 (중복 장착 시 초기화)
           break
       end
   end
   
   
   local check = false
   for i = 1, size do
       if player:GetInventoryItem(i) == nil then
           check = true
       end
   end
   
   if check then
       player:GiveItem(Item)

       for i = 1, size do
           if player:GetInventoryItem(i) ~= nil and player:GetInventoryItem(i).Name == Item.Name then -- 인벤토리에 같은 아이템이 있다면
               player:EquipInventoryItem(i)               
              
           end 
       end
   end
end
Collider.Collision.OnBeginOverlapEvent:Connect(GetItem)


local function DeleteItem(character)
   if character:IsCharacter() ~= true then
       return
   end
   
   local playerID = character:GetPlayerID()
   local player = Game:GetPlayer(playerID)
   local size = player:GetInventorySize()
   
   for i = 1, size do
       if player:GetInventoryItem(i) ~= nil and player:GetInventoryItem(i).Name == Item.Name then -- 인벤토리에 같은 아이템이 있다면
           player:DeleteItem(i) -- i번 아이템을 삭제
           break
       end
   end   
end
Game.OnDeathCharacter:Connect(DeleteItem)