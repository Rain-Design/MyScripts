local Module = {}

function Module:GetCharacter()
local HumanoidRootPart = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not HumanoidRootPart then
        return
    end

    return HumanoidRootPart
end

function Module:GetDistance(Part)
local Character = Module:GetCharacter()

if not Character then
    return
end

return (Character.Position - Part.Position).Magnitude
end

function Module:Tween(Pos,Speed)

local Character = Module:GetCharacter()

if not Character then
    return
end

local Distance = (Character.Position - Pos.p).Magnitude
local MyTween = game:GetService("TweenService"):Create(Character,TweenInfo.new(Distance / Speed),{CFrame = Pos})

return MyTween, Distance
end