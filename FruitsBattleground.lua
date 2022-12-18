if not game:IsLoaded() then
    game.Loaded:Wait()
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local teleportService = game:GetService("TeleportService")
local players = game:GetService("Players")
local httpService = game:GetService("HttpService")

local replicator = replicatedStorage:WaitForChild("Replicator")
local player = players.LocalPlayer
local mainData = player:WaitForChild("MAIN_DATA")
local gems = mainData:WaitForChild("Gems")

local Settings = httpService:JSONDecode(readfile("fruitFolder/Settings.json"))

replicator:InvokeServer("FruitsHandler", "SwitchSlot", {Slot = Settings.Slot})

while true do
    if gems.Value < 80 then
        local currentTime = os.date("%X")
        replicator:InvokeServer("Core", "UpdateSettings", {["\255"] = true, ["\255"] = true, ["\255"] = true, ["\255"] = true, ["\255"] = true})
        syn.queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/MyScripts/main/FruitsBattleground.lua", true))()]])
        teleportService:Teleport(game.PlaceId, player)
        teleportService.TeleportInitFailed:Connect(function()
            rconsolewarn(string.format("%s - Teleport Failed. Retrying.", currentTime))
            teleportService:Teleport(game.PlaceId, player)
        end)
        rconsolewarn(string.format("%s - Out of gems. Rolling data back.", currentTime))
        break
    end
    
    local fruit = replicator:InvokeServer("FruitsHandler", "Spin", {Type = "Fast"})
    local currentTime = os.date("%X")
    
    if fruit == nil then
        continue
    end
    
    if table.find(Settings.Wanted, fruit) then
        rconsolewarn(string.format("%s - Congrats! you got: [%s]", currentTime, fruit))
        break
    end
    
    rconsolewarn(string.format("%s - You got: [%s]", currentTime, fruit))
    
    task.wait(.2)
end
