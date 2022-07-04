local Module = {}

function Module:GetCharacter()
local Character = game.Players.LocalPlayer.Character
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Character and HumanoidRootPart then
        return
    end

    return Character, HumanoidRootPart
end

function Module:CharacterCheck()

local Character,HumanoidRootPart = Module:GetCharacter()

if Character and HumanoidRootPart then
    return true
end

return false
end

function Module:GetDistance(Pos)
local Character,HumanoidRootPart = Module:GetCharacter()

return (HumanoidRootPart.Position - Pos.p).Magnitude
end

function Module:Tween(Pos,Speed)

local Character,HumanoidRootPart = Module:GetCharacter()

local Distance = Module:GetDistance(Pos)
local MyTween = game:GetService("TweenService"):Create(HumanoidRootPart,TweenInfo.new(Distance / Speed),{CFrame = Pos})

return MyTween, Distance
end

return Module