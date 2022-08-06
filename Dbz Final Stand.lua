local Whitelist = {
    "Kung Fu";
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Mouse = Player:GetMouse()

local Character = Player.Character or Player.CharacterAdded:Wait()

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Live = game:GetService("Workspace").Live

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/Libraries/main/Revenant.lua", true))()
local Flags = Library.Flags

local Window = Library:Window({
    Text = "Final Stand"
})

Window:Toggle({
    Text = "Autofarm",
    Flag = "Autofarm"
})

local function Tween(Args)
    Args.CFrame = Args.CFrame or warn("No CFrame.")
    Args.Speed = Speed or 35
    
    local Tw = TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new((Player.Character.HumanoidRootPart.Position - Args.CFrame.p).Magnitude / Args.Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = Args.CFrame})
    Tw:Play()
    
    local Completed = false
    
    local Connection
    Connection = Tw.Completed:Connect(function()
        Completed = true
    end)
    
    task.spawn(function()
    while not Completed do
        if not Flags.Autofarm then
            Tw:Cancel()
            Connection:Disconnect()
            break
        end
        task.wait()
    end
    end)
    
end

local function Check(str)
    for _,v in pairs(Whitelist) do
        if string.match(str, v) then
            return true
        end
    end
    return false
end

local function NearestEnemy()
    local Enemy, Distance = nil, math.huge
    
    for _,v in pairs(Live:GetChildren()) do
        if v.Name ~= Player.Name and Check(v.Name) and not v:FindFirstChild("Speak") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local Magnitude = (Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            
            if Magnitude < Distance then
                Enemy, Distance = v, Magnitude
            end
        end
    end
    return Enemy, Distance
end

coroutine.wrap(function()
    RunService.Stepped:Connect(function()
        if Flags.Autofarm then
            pcall(function() Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) end)
        end
    end)
end)()

coroutine.wrap(function()
    RunService.Stepped:Connect(function()
        if Flags.Autofarm then
        pcall(function()
            for _,v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    end
    end)
end)()

coroutine.wrap(function()
while true do
    if Flags.Autofarm then
        pcall(function() Player.Backpack.ServerTraits.Input:FireServer({ "md" }, Mouse.Hit, Enum.UserInputType.MouseButton1, false) end)
    end
    wait(.3)
end
end)()

local Enemy, Distance
while true do
    if Flags.Autofarm then
    Enemy, Distance = NearestEnemy()
    
    if Enemy ~= nil and Character and Character:FindFirstChild("HumanoidRootPart") then
        if Distance > 5 then
        Tween({
            CFrame = Enemy.HumanoidRootPart.CFrame - Enemy.HumanoidRootPart.CFrame.lookVector * 6,
            Speed = 150
        })
        else
        Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame - Enemy.HumanoidRootPart.CFrame.lookVector * 6
        end
    end
    end
    task.wait()
end
