local Item = Script.Parent.Parent


---------------------------아이템 장착-------------------------------

---- 아이템 장착시 연결 함수(Server)
local function EquipItem(Player)
    Player:GetCharacter():SetOrientRotationToMovement(false)   
end
Item.EquipEvent:Connect(EquipItem)



---------------------------아이템 해제-------------------------------

---- 아이템 해제시 연결 함수(Server)
local function UnEquipItem(Player)
    Player:GetCharacter():SetOrientRotationToMovement(true)    
end
Item.UnEquipEvent:Connect(UnEquipItem)