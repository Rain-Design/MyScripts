local Module = {}

local Services = {
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService")
}

function Module:Check()

local Character = game.Players.LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
        return true
    end

return false
end

function Module:GetCharacter()

local Character = game.Players.LocalPlayer.Character
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
return Character, HumanoidRootPart
end

function Module:GetDistance(Pos)
local Character,HumanoidRootPart = Module:GetCharacter()

return (HumanoidRootPart.Position - Pos.p).Magnitude
end

function Module:Tween(Pos,Speed)

local Character,HumanoidRootPart = Module:GetCharacter()

local Distance = Module:GetDistance(Pos)
local MyTween = Services.TweenService:Create(HumanoidRootPart,TweenInfo.new(Distance / Speed),{CFrame = Pos})

return MyTween, Distance
end

function Module:Noclip()

local Character = Module:GetCharacter()
coroutine.wrap(function()
    Services.RunService:RenderStepped:Connect(function()
        for _,v in pairs(Character:GetChildren()) do
            if v.ClassName == "BasePart" then
                v.CanCollide = false
            end
        end
    end)
end)()
end

function SetVelocity()

local Character,HumanoidRootPart = Module:GetCharacter()

coroutine.wrap(function()
    Services.RunService:RenderStepped:Connect(function()
        HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end)
end)()
end

return Module