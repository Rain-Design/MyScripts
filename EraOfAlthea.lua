-- May update idk
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/MyLibs/main/Sidebar.lua"))()

local Window = library:CreateWindow()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Enemies = game:GetService("Workspace").NPCS

local tab = Window:CreateTab({
    Text = "Autofarm",
    Icon ="rbxassetid://7733770599"
})

local tab2 = Window:CreateTab({
    Text = "Information",
    Icon ="rbxassetid://7733658271"
})

local MobFarm = false
tab:CreateToggle({
    Text = "Wolf Autofarm",
    Callback = function(bool)
        MobFarm = bool
    end
})

local GetWolfQuest = false
tab:CreateToggle({
    Text = "Get Wolf Quest",
    Callback = function(bool)
        GetWolfQuest = bool
    end
})

local MobsKilledValue, QuestTakenValue = 0, 0

local MobsKilled = tab2:CreateLabel({
    Text = "Mobs Killed: 0"
})

local QuestsTaken = tab2:CreateLabel({
    Text = "Quests Taken: 0"
})

local function GetMob()
    local Mob, Health = nil, math.huge
    
    for _,v in pairs(Enemies:GetChildren()) do
        if v.Name == "Wolf" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Health") and not v:FindFirstChild("Immune") and v.Health.Value > 0 then
            local ActualHealth = v.Health.Value
            
            if ActualHealth < Health then
                Mob, Health = v, ActualHealth
            end
        end
    end
    return Mob
end

local function GetQuest()
    if not Player.PlayerGui:FindFirstChild("Quest") then
    for _,v in pairs(game:GetService("Workspace").Map["Quest Board"].Papers:GetChildren()) do
        if v.SurfaceGui.Frame.QuestName.Text == "Dangerous Wolves" then
        while not Player.PlayerGui:FindFirstChild("Quest") do
        Player.Character.HumanoidRootPart.CFrame = v.CFrame
        fireclickdetector(v.ClickDetector)
        wait(.2)
        end
        QuestTakenValue = QuestTakenValue + 1
        QuestsTaken:Set({
            Text = "Quests Taken: "..tostring(QuestTakenValue)
        })
        end
    end
    end
end

coroutine.wrap(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if MobFarm then
        pcall(function()
            Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end)
        end
    end)
end)()

while true do
    if MobFarm then
    if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Client") and Player.Character.Client:FindFirstChild("Events") and Player.Character.Humanoid.Health > 0 then
        local LightAttack = Player.Character.Client.Events:FindFirstChild("LightAttack")
        if LightAttack then
            local Mob = GetMob()
            if Mob then
                if GetWolfQuest then
                GetQuest()
                end
                while Mob.Health.Value > 0 and Player.Character.Humanoid.Health > 0 do
                    Player.Character.HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame * CFrame.new(0,-2,0)
                    LightAttack:FireServer("SecretCode")
                wait()
                end
                if Player.Character.Humanoid.Health > 0 then
                    warn("Killed: "..tostring(Mob))
                    MobsKilledValue = MobsKilledValue + 1
                    MobsKilled:Set({
                    Text = "Mobs Killed: "..tostring(MobsKilledValue)
                    })
                end
            end
        end
    end
    end
    wait()
end
