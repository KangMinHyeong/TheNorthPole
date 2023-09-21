local Item = Script.Parent.Parent
local DefaultCharacterSetting = Toybox.CharacterSetting

local GunCamera = Item.PlayerSetting.GunCamera
local PlayerCamera = Workspace.MainCamera  

local IsChangeAni = Item.PlayerSetting.IsChangeAni
local IsChangeCamera = Item.PlayerSetting.IsChangeCam

local DefaultInputMode = ScriptClient.DefaultCamera.InputMode


---------------------------아이템 장착-------------------------------

---- 아이템 장착시 캐릭터 애니메이션 변경    
local function EquipAni(CharacterSetting) 
    local Player = LocalPlayer:GetRemotePlayer()
    local remoteCharacter = Player:GetCharacter()    
   
    Game:ChangeCharacterAnimStateMachine(remoteCharacter, Game:GetAnimStateMachineSetting("GunCharacterAnim"), CharacterSetting.AnimationSetting)   
end  


---- 아이템 장착시 카메라 변경
local function EquipCam(PrePlayerRot, GunCamera) 
    local Player = LocalPlayer:GetRemotePlayer()
    local remoteCharacter = Player:GetCharacter()  
    
    LocalPlayer:ResetIgnoreLookInput() 
    GunCamera.Parent = remoteCharacter
    GunCamera:SetLookAtTarget(nil)     
   
    LocalPlayer:SetControlRotation(Vector.new(PrePlayerRot.X, PrePlayerRot.Y, PrePlayerRot.Z))
end

---- 아이템 장착시 연결 함수(Client)
local function EquipItem(Player)     
    if not Player:GetCharacter():IsMyCharacter() then
        return
    end
    
    Input:DeactiveGroup("DefaultInput")
    Input:RemoveAxisKeyEvent("DefaultInput", "ZoomInOut", Enum.Key.MouseWheelAxis)
    Input:ActiveGroup("DefaultInput")    
    
    ------------캐릭터 모션 변경 루틴------------ 
    local CharacterSetting = Item.PlayerSetting.GunCharacterSetting    
    
    if CharacterSetting ~= nil and IsChangeAni then        
        EquipAni(CharacterSetting)
    else
        if CharacterSetting == nil and IsChangeAni then
            print("===== There is No Gun Character Setting ! ====")
        end
    end
            
    LocalPlayer:SetInputMode(Enum.InputMode.Game)
        
    ------------카메라 변경 루틴------------      
    if IsChangeCamera == false then
        LogWarning("총을 장착했을 때 정상 동작하지 않는다면, 총 토이/PlayerSetting의 IsChangeCam 프로퍼티를 true로 변경")
        return
    end    
    
    local PrePlayerRot = LocalPlayer:GetControlRotation()
        
    repeat wait(0.1) until Player:GetEquipItem("EquipSlot_1")    
    local GunCamera = LocalPlayer:SetCurrentCamera(GunCamera)  
    
    if GunCamera ~= nil then
        EquipCam(PrePlayerRot, GunCamera)
    else
        print("===== There is No Gun Camera ! ====")
        return
    end
end
Item.EquipEvent:Connect(EquipItem)



-------------------------아이템 해제--------------------------------

---- 아이템 해제시 캐릭터 애니메이션 변경
local function UnEquipAni(CharacterSetting)    
    local Player = LocalPlayer:GetRemotePlayer()
    local remoteCharacter = Player:GetCharacter()  

    Game:ChangeCharacterAnimStateMachine(remoteCharacter, Game:GetAnimStateMachineSetting("DefaultCharacterAnim"), CharacterSetting.AnimationSetting)
end    


---- 아이템 해제시 카메라 변경
local function UnEquipCam(PrePlayerRot, PlayerCamera)    
    local Player = LocalPlayer:GetRemotePlayer()
    local remoteCharacter = Player:GetCharacter()  
    
    LocalPlayer:ResetIgnoreLookInput() 
    PlayerCamera.Parent = remoteCharacter
    PlayerCamera:SetLookAtTarget(nil) 
   
    LocalPlayer:SetControlRotation(Vector.new(PrePlayerRot.X, PrePlayerRot.Y, PrePlayerRot.Z))      
end

---- 아이템 해제시 연결 함수(Client)
local function UnEquipItem(Player) 
    if not Player:GetCharacter():IsMyCharacter() then
        return
    end    
    
    Input:DeactiveGroup("DefaultInput")
    Input:AddAxisKeyEvent("DefaultInput", "ZoomInOut", Enum.Key.MouseWheelAxis, -50)
    Input:ActiveGroup("DefaultInput")

    ------------캐릭터 모션 복원 루틴------------
        
    if DefaultCharacterSetting ~= nil then
        UnEquipAni(DefaultCharacterSetting)
    else
        print("===== There is No Default Character Setting ! ====")
    end 
    
           
    if DefaultInputMode == 1 then
        LocalPlayer:SetInputMode(Enum.InputMode.Game)
    elseif DefaultInputMode == 2 then 
        LocalPlayer:SetInputMode(Enum.InputMode.UI)
    elseif DefaultInputMode == 3 then 
        LocalPlayer:SetInputMode(Enum.InputMode.GameAndUI)
    else                      
        LocalPlayer:SetInputMode(Enum.InputMode.Game)
    end    
    
    ------------카메라 복원 루틴------------ 
    if IsChangeCamera == false then
        return
    end    
    
    local PrePlayerRot = LocalPlayer:GetControlRotation()
    local PlayerCamera = LocalPlayer:SetCurrentCamera(PlayerCamera)  
    
    if PlayerCamera ~= nil then
        UnEquipCam(PrePlayerRot, PlayerCamera)
    else
        print("===== There is No Default Camera ! ====")
        return
    end
end
Item.UnEquipEvent:Connect(UnEquipItem)

