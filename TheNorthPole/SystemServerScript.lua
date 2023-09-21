local Group = Script.Parent
local StartLine = Group.Trigger.StartLine
local EndLine = Group.Trigger.EndLine


-------------------------------------------------------------------------------------
-- 종료 후 이동 처리 --
local function ReStart(player)
   if player == nil or not Script.IsRespawnAfterClear then
       return
   end
   
   player:RemoveCheckPoint() --체크포인트를 삭제
   player:RespawnCharacter() --캐릭터를 리스폰 처리   
end
Game:ConnectEventFunction("ReStartServer", ReStart)


local function Fail(player)
   if player == nil then
       return
   end
   
   player:RemoveCheckPoint() --체크포인트를 삭제
end
Game:ConnectEventFunction("FailServer", Fail)
