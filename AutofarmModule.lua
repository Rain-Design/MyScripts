local Module = {}

function Module:GetCharacter()
local HumanoidRootPart = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not HumanoidRootPart then
        return
    end

    return HumanoidRootPart
end

function Module:GetDistance(Pos)
local Character = Module:GetCharacter()

if not Character then
    return
end

return (Character.Position - Pos.p).Magnitude
end

function Module:Tween(Pos,Speed)

local Character = Module:GetCharacter()

if not Character then
    return
end

local Distance = Module:GetDistance(Pos)
local MyTween = game:GetService("TweenService"):Create(Character,TweenInfo.new(Distance / Speed),{CFrame = Pos})

return MyTween, Distance
end

return Module