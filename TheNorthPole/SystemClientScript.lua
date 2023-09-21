local Group = Script.Parent
local StartLine = Group.Trigger.StartLine
local EndLine = Group.Trigger.EndLine

local SD_Start = Group.SFX.Start
local SD_Finish = Group.SFX.Finish
local SD_BGM = Group.SFX.BGM
local SD_GameOver = Group.SFX.GameOver
local SD_Fail = Group.SFX.Fail

local DieUI = Group.HUD.DieUI
local FailUI = Group.HUD.FailUI
local TimerHUD = Group.HUD.Timer
local FinishUI = Group.HUD.FinishUI

local TimerCheck = false

local PlayerLife = 0
local playTime = 0
local limitTime = Script.limitTime


-- 스톱워치 모듈을 가져옵니다
local ModuleSW = require(ScriptModule.DefaultModules.StopWatch)
local _stopwatch = nil


-------------------------------------------------------------------------------------
-- UI 숨김 및 조작 초기화 처리 --
local function ClearUI()
   TimerHUD.Visible = false
   FinishUI.Visible = false
   DieUI.Visible = false
   FailUI.Visible = false 
end
ClearUI() -- Camera Play 시 UI가 표시되지 않도록 첫 실행에 호출


-------------------------------------------------------------------------------------
-- StartLine 오버랩 시 타임체크 시작 / 타이머 HUD 출력 --

local function TimerStart(self, character)
   if not character:IsCharacter() or not character:IsMyCharacter() or TimerCheck then
       return
   end
     
   
   TimerCheck = true
   
   -- 라이프 설정 초기화
   if Script.UseLife then   
       PlayerLife = Script.PlayerLife
       TimerHUD.LifeText:SetText("Extra Life: "..math.floor(PlayerLife))
   else
       TimerHUD.LifeText.Visible = false
   end
   
   
   -- 스톱워치가 없으면 하나 만듭니다. Update 이벤트가 가능한 부모오브젝트를 인자로 줍니다
    if _stopwatch == nil then         
         _stopwatch = ModuleSW:new(Script.Parent)   
    end      
            
   -- 스톱워치 시작합니다.
   _stopwatch:start()
   SD_Start:Play()
   
   
   local cube = Workspace.Cube
   
   
   
   local function UpdateEvent(updateTime) 
             
                                
           playTime = _stopwatch._ElapsedTimeSec  
   
   
   if playTime-0.02 > limitTime then
              
               PlayerLife = 0
                           
                              -- 플레이어 라이프 체크
                               if Script.UseLife and PlayerLife <= 1 then  -- 라이프가 1 이하면
                                  
                                  TimerCheck = false
                                 
                                  -- 스톱워치를 정지
                                  if _stopwatch == nil then
                                      return  
                                  end
                                  
                                  _stopwatch:stop()
                                    
                                  FailUI.Visible = true
                               
                                  LocalPlayer:SetEnableMovementControl(false)
                                  LocalPlayer:SetEnableCameraControl(false)  
                                  
                                  Game:SendEventToServer("FailServer") -- 서버로 Fail 이벤트 보냄 (스폰 포인트로 이동)
                                  
                                  SD_GameOver:Play()
                                  _stopwatch = nil
                                  
                                  wait(4)
                                   Game:SendEventToServer("ReStartServer")
                                   ClearUI()
                                    
                                    end
                           
                    
                       
                 end     
   
   end 
      cube.OnUpdateEvent:Connect(UpdateEvent) 
   
    
   
   
   TimerHUD.StartText.Visible = true
   TimerHUD.Visible = true
   TimerHUD.TimeText:SetText("00:00.00")
   
   wait(0.5)
   TimerHUD.StartText.Visible = false
   
   while TimerCheck do       
       TimerHUD.TimeText:SetText(string.format("%02d:%02d.%02d", _stopwatch.Min, _stopwatch.Sec, _stopwatch.MilliSec))
       
       if Script.UseLife then
           TimerHUD.LifeText:SetText("Extra Life: "..math.floor(PlayerLife))
       end
       wait(0.01)
   end
end

StartLine.Collision.OnBeginOverlapEvent:Connect(TimerStart)


-------------------------------------------------------------------------------------
-- EndLine 오버랩 시 타임체크 종료 / 리더보드 UI 출력 --

local function TimerEnd(self, character)
   if not character:IsCharacter() or not character:IsMyCharacter() then
       return
   end
   
   if TimerCheck == false then
       return
   end
   
   TimerCheck = false
   TimerHUD.Visible = false
   
   -- 스톱워치를 정지
   _stopwatch:stop()   
          
   FinishUI.Reward:SetText(string.format("%02d:%02d.%02d", _stopwatch.Min, _stopwatch.Sec, _stopwatch.MilliSec))   
   FinishUI.Visible = true
   
   SD_Finish:Play()
   _stopwatch = nil
   
   wait(2.85)
   ClearUI()

end
EndLine.Collision.OnBeginOverlapEvent:Connect(TimerEnd)


-------------------------------------------------------------------------------------
-- 리더보드 UI 클릭 시 체크 종료 / 스폰포인트로 이동

local function CloseFinishUI(self)

   TimerHUD.Visible = false
   FinishUI.Visible = false
   
   --- 마우스 커서 복원 ---
   LocalPlayer:RestorePreviousInputMode()
   
   --- 컨트롤 On ---
   LocalPlayer:SetEnableMovementControl(true)
   LocalPlayer:SetEnableCameraControl(true)
   
   Game:SendEventToServer("ReStartServer") -- 서버로 ReStart 이벤트 보냄 (스폰 포인트로 이동)
       
end
FinishUI.OKButton.OnPressEvent:Connect(CloseFinishUI)


-------------------------------------------------------------------------------------
-- 스폰 시 처리 (UI 숨김 및 액션 초기화) --
local function SpawnCharacter(character)
   -- 이벤트 발생 플레이어가 나(조작 플레이어)인지 확인하는 절차
   if not character:IsCharacter() or not character:IsMyCharacter() then
       return
   end
   
   ClearUI()       
   
   LocalPlayer:SetEnableMovementControl(true)
   LocalPlayer:SetEnableCameraControl(true)
   
   if TimerCheck then
       TimerHUD.Visible = true
   end   
end
Game.OnSpawnCharacter:Connect(SpawnCharacter) -- 스폰하면 함수 실행


-------------------------------------------------------------------------------------
-- 사망 시 DIE UI 표시 --
local function DeathCharacter(character)

    -- 이벤트 발생 플레이어가 나(조작 플레이어)인지 확인하는 절차
    if not character:IsCharacter() or not character:IsMyCharacter() then
        return
    end
    
    ClearUI()
   
   -- 플레이어 라이프 체크
    if Script.UseLife and PlayerLife <= 1 then  -- 라이프가 1 이하면
       
       TimerCheck = false
      
       -- 스톱워치를 정지합니다
       if _stopwatch == nil then
           return  
       end
       
       _stopwatch:stop()
         
       FailUI.Visible = true
    
       LocalPlayer:SetEnableMovementControl(false)
       LocalPlayer:SetEnableCameraControl(false)  
       
       Game:SendEventToServer("FailServer") -- 서버로 Fail 이벤트 보냄 (스폰 포인트로 이동)
       
       SD_GameOver:Play()
       _stopwatch = nil

   else                     -- 라이프가 0 이하가 아니면
       DieUI.Visible = true
       
       -- 라이프 감소 처리
       if Script.UseLife then 
       
           PlayerLife = PlayerLife - 1       
           DieUI.DieText:SetText("Your remaining life: "..math.floor(PlayerLife))
       
       else
           DieUI.DieText:SetText("You died")
       end
       
       LocalPlayer:SetEnableMovementControl(false)
       LocalPlayer:SetEnableCameraControl(false)
       
       SD_Fail:Play() 
   end   
end
Game.OnDeathCharacter:Connect(DeathCharacter) -- 사망하면 함수 실행


--Game이나 오브젝트에 매프레임마다 호출되는 함수를 연결해요.
      

