local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/BECK/main/Library.lua', true))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Info = require(ReplicatedStorage:WaitForChild("Info"))

local Abilities = {"All (Minimum Level)"}

for _, v in pairs(Info.Abilities) do
    if v.Unobtainable == true then continue end
    
    table.insert(Abilities, _)
end

local Claim = ReplicatedStorage:WaitForChild("ClaimAbility")
local Reroll = ReplicatedStorage:WaitForChild("Reroll")

local KingValue = ReplicatedStorage:WaitForChild("KingValue")
local BossValue = ReplicatedStorage:WaitForChild("Boss")

local function DecodeStats()
    return HttpService:JSONDecode(Player.Stats.Value)
end

--// Attack

local AuraType = "Others"

local Types = {
    Others = {
        Distance = 10,
        Delay = .3
    },
    EnergyBlade = {
        Distance = 20,
        Delay = .05
    }
}

local PunchID = 1

local Ability = DecodeStats().Ability

local function Punch(v)
    if Ability ~= "Energy Blades" then
    AuraType = "Others"
    
    if PunchID > 6 then
        PunchID = 1
    end
    
    local Multiplier = 1
    
    if PunchID == 6 then
        Multiplier = 2
    end
    
    game:GetService("ReplicatedStorage").Punch:FireServer(v.Humanoid, PunchID, Player.Character.Cancellations.Value, nil, "DamageMultiplier: "..tostring(Multiplier))
    
    PunchID = PunchID + 1
    else
    AuraType = "EnergyBlade"
        
    game:GetService("ReplicatedStorage").Damage:FireServer("DualSwordHeavy", v.Humanoid, Player.Character.Cancellations.Value, {[1] = v.Humanoid})
    end
end
--//

--// Utilities
local function GetDistance(v)
    if not Player.Character:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("HumanoidRootPart") then return math.huge end

    return (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
end

local function Highlight(v)
    local Inst = Instance.new("Highlight", v)
    Inst.Name = "Highlight"
    
    Inst.FillColor = Color3.fromRGB(0, 255, 0)
    Inst.FillTransparency = .3
    Inst.OutlineTransparency = 1
    Inst.Adornee = v
end

local HideTable = {
    "hpbar",
    "Jack",
    "King",
    "LeftGlow",
    "RightGlow",
    "face"
}

local function Hide()
    if not Player.Character:FindFirstChild("Head") then return end
    
    for _, v in pairs(Player.Character.Head:GetChildren()) do
        if table.find(HideTable, v.Name) then
            v:Destroy()
        end
    end
    
    for _, v in pairs(Player.Character:GetChildren()) do
        if v.ClassName == "Accessory" or v.ClassName == "Pants" or v.ClassName == "Shirt" then
            v:Destroy()
        end
    end
end

local function BossSpawned()
    local Boss = BossValue.Value
    
    if Boss ~= nil then
        if tostring(Boss) == "Arlo" then
            if Boss:FindFirstChild("CurrentBarrier") then
                return false
            end
        end
        return true
    end
    
    return false
end

local function IsBoss(v)
    if v == BossValue.Value then
        return true
    end
    
    return false
end

local Crafting = {
    ["Elite-Tier"] = {Needed = 5, Ticket = "Common"},
    ["High-Tier"] = {Needed = 5, Ticket = "Elite-Tier"},
    ["God-Tier"] = {Needed = 5, Ticket = "High-Tier"},
    ["Mythical"] = {Needed = 3, Ticket = "God-Tier"},
    ["Divine"] = {Needed = 2, Ticket = "Mythical"}
}

local function PowerUp()
    if Player.Character and not Player.Character:FindFirstChild("ActiveAbility") then
        ReplicatedStorage.ToggleAbility:InvokeServer(true)
    end
end
--//

--// Anti AFK
task.spawn(function()
    while true do
        VirtualInputManager:SendMouseMoveEvent(math.random(50,400),math.random(0,350),game)
        task.wait(600)
    end
end)
--//

--// Quests
local Quest = "Low-Tier"

local Quests = {
    ["Low-Tier"] = {
        Targets = {"Cripple"},
        Name = "Real Amgogus"
    },
    ["Mid-Tier"] = {
        Targets = {"Crail"},
        Name = "Gaming Disorder"
    },
    ["High-Tier"] = {
        Targets = {"Remi", "Blyke", "Isen"},
        Name = "Kingdom"
    },
    ["God-Tier"] = {
        Targets = {"Arlo", "John", "Seraphina"},
        Name = "Rigged Game"
    },
    ["Mythical-Tier"] = {
        Targets = {"Seer"},
        Name = "Trouble in the backrooms"
    }
}

local function HandleQuest()
    if Player.PlayerGui:FindFirstChild("MainClient") and Player.PlayerGui.MainClient:FindFirstChild("Quest") then
        if Player.PlayerGui.MainClient.Quest.Visible then
            if Player.PlayerGui.MainClient.Quest.Folder.Objective.progress.Text:split("/")[1] == game:GetService("Players").LocalPlayer.PlayerGui.MainClient.Quest.Folder.Objective.progress.Text:split("/")[2] then
                game:GetService("ReplicatedStorage").TakeQuest:FireServer("Completed")
            end
            else
            game:GetService("ReplicatedStorage").TakeQuest:FireServer(Quests[Quest].Name)
        end
    end
end
--//

local Autofarm = false

--// Anti-TP Bypass
local Bypassed = false
local AntiState

local function HideOnSpawn()
    if Autofarm then
        while true do
            if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character.Head:FindFirstChild("hpbar") then
                break
            end
            task.wait()
        end
            
        Hide()
    end
end

local Character = Player.Character or Player.CharacterAdded:Wait()

Character.Humanoid.Died:Connect(function()
    Bypassed = false
    
    HideOnSpawn()
    
    AntiState:Set({
        Text = "Anti-TP: Not bypassed"
    })
end)

Player.CharacterAdded:Connect(function(v)
    v:WaitForChild("Humanoid").Died:Connect(function()
        Bypassed = false
        
        HideOnSpawn()
        
        AntiState:Set({
            Text = "Anti-TP: Not bypassed"
        })
    end)
end)

task.spawn(function()

while not AntiState do
    warn("Loading Anti-TP Bypass.")
    task.wait(.5)
end

while true do
    if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
        if not Player.Character:FindFirstChild("TPExemption") then
            local BossTP = Player.PlayerGui.Reroll.bosstp
            if BossTP.Visible then
                local OldC = Player.Character.HumanoidRootPart.CFrame
                
                firesignal(BossTP.Yes.MouseButton1Click)
                Bypassed = true
                
                AntiState:Set({
                    Text = "Anti-TP: Bypassed"
                })
                
                task.wait(1.5)
                
                Player.Character.HumanoidRootPart.CFrame = OldC
            end
        end
    end
    task.wait(1)
end
end)
--//

local Window = Library:Window({
    Text = "Ultra unFair"
})

local Tab = Window:Tab({
    Text = "Farming",
    Image = 7733674239,
    Description = "mobs, bosses, players"
})

local Tab2 = Window:Tab({
    Text = "Miscellaneous",
    Image = 7072707647,
    Description = "item, mass upgrade"
})

local Section = Tab:Section({
    Text = "Mobs"
})

local Section2 = Tab:Section({
    Text = "Players",
    Side = "Right"
})

local Section3 = Tab2:Section({
    Text = "Items"
})

local Section4 = Tab:Section({
    Text = "State",
    Side = "Right"
})

local Section5 = Tab2:Section({
    Text = "Auto-Roll",
    Side = "Right"
})

local MobAura = false
local Bosses = false

local FarmCheck
local MobAuraCheck

local KillingState

KillingState = Section4:Label({
    Text = "Killing: None"
})

FarmCheck = Section:Check({
    Text = "Auto-farm",
    Flag = "Autofarm",
    Callback = function(bool)
        Autofarm = bool
        
        local Old = Player.Character.HumanoidRootPart.CFrame
        
        if not Bypassed and bool then
            Library:Notify({
                Text = "The autofarm is going to start when the anti-tp is bypassed.",
                Timeout = 10
            })
            while true do
                if Bypassed then
                    break
                end
                task.wait()
            end
        end
        
        if Autofarm and not MobAura then
            MobAuraCheck:Set(true)
        end
        
        if Autofarm then
            Hide()
        end
        
        while Autofarm do
            for _, v in pairs(workspace:GetChildren()) do
                if not Autofarm then break end
                if IsBoss(v) and v:FindFirstChild("CurrentBarrier") then continue end
                if (table.find(Quests[Quest].Targets, v.Name) or Bosses and IsBoss(v) and not v:FindFirstChild("CurrentBarrier")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    
                    HandleQuest()
                    
                    if IsBoss(v) and not MobAura then
                        MobAuraCheck:Set(true)
                    end
                    
                    if Bosses and BossSpawned() and IsBoss(v) then
                        task.wait(.8)
                    end
                    
                    PowerUp()
                    
                    while v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 do
                        if not Autofarm or not Bypassed then
                            break
                        end
                        
                        if ((Bosses and BossSpawned() and not IsBoss(v)) or not Player.Character:FindFirstChild("HumanoidRootPart")) then
                            break
                        end
                        
                        --// Arlo Barrier Check
                        if Bosses and IsBoss(v) and v:FindFirstChild("CurrentBarrier") then
                            break
                        end
                        --//
                        
                        if Player.Character and not Player.Character:FindFirstChild("HumanoidRootPart") then
                            break
                        end
                        
                        KillingState:Set({
                            Text = "Killing: "..v.Name.." ("..tostring(math.floor(v.Humanoid.Health))..")"
                        })
                        
                        Hide()
                        Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame - v.HumanoidRootPart.CFrame.lookVector * 3
                        
                        task.wait()
                    end
                    
                    KillingState:Set({
                        Text = "Killing: None"
                    })
                    
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = Old
                    end
                    
                    HandleQuest()
                end
            end
        task.wait()
        end
    end
})

Section:Check({
    Text = "Bosses",
    Callback = function(v)
        Bosses = v
    end
})

Section:Dropdown({
    Text = "Quest",
    List = {"Low-Tier", "Mid-Tier", "High-Tier", "God-Tier", "Mythical-Tier"},
    Callback = function(v)
        Quest = v
    end
})

MobAuraCheck = Section:Check({
    Text = "Kill-Aura",
    Tooltip = "Use energy blades for more efficiency.",
    Keybind = Enum.KeyCode.Z,
    Callback = function(bool)
        MobAura = bool
        
        Ability = DecodeStats().Ability
        
        while MobAura do
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Level") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and Player.Character:FindFirstChild("Cancellations") then
                    if GetDistance(v) < Types[AuraType].Distance then
                        Punch(v)
                        
                        if not v:FindFirstChild("Highlight") then
                            Highlight(v)
                            else
                            v.Highlight.Enabled = true
                        end
                        
                        else
                        if v:FindFirstChild("Highlight") then
                            v.Highlight.Enabled = false
                        end
                    end
                end
            end
            task.wait(Types[AuraType].Delay)
        end
    end
})

local PlayerAura = false
local PlayerAuraCheck

PlayerAuraCheck = Section2:Check({
    Text = "Kill-Aura",
    Callback = function(bool)
        PlayerAura = bool
        
        Ability = DecodeStats().Ability
        
        while PlayerAura do
            for _, v in pairs(Players:GetPlayers()) do
                if v.Name ~= Player.Name and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    if GetDistance(v.Character) < Types[AuraType].Distance then
                        Punch(v.Character)
                        
                        if not v.Character:FindFirstChild("Highlight") then
                            Highlight(v.Character)
                            else
                            v.Character.Highlight.Enabled = true
                        end
                        
                        else
                        if v.Character:FindFirstChild("Highlight") then
                            v.Character.Highlight.Enabled = false
                        end
                    end
                end
            end
            task.wait(Types[AuraType].Delay)
        end
    end
})

Section2:Button({
    Text = "Get King",
    Tooltip = "Teleport and kill the current king.",
    Callback = function()
        local King = Players[KingValue.Value]
        
        if King == Player then
            Library:Notify({
                Text = "You are the king.",
                Timeout = 10
            })
            return
        end
        
        if not Bypassed then
            Library:Notify({
                Text = "The Anti-TP was not bypassed yet.",
                Timeout = 10
            })
            
            return
        end
        
        if not PlayerAura then
            PlayerAuraCheck:Set(true)
        end
        
        Hide()
        
        if King.Character and King.Character:FindFirstChild("Humanoid") and King.Character:FindFirstChild("HumanoidRootPart") then
            
            local Old = Player.Character.HumanoidRootPart.CFrame
            
            while true do
                if not King.Character:FindFirstChild("HumanoidRootPart") or King.Character:FindFirstChild("Humanoid") and King.Character.Humanoid.Health <= 0 then
                    break
                end
                
                
                Player.Character.HumanoidRootPart.CFrame = King.Character.HumanoidRootPart.CFrame - King.Character.HumanoidRootPart.CFrame.lookVector * 3
                
                task.wait()
            end
            
            PlayerAuraCheck:Set(false)
            
            Player.Character.HumanoidRootPart.CFrame = Old
            
            Hide()
            
        end
    end
})

local Item
local Level = 2

Section3:Dropdown({
    Text = "Item",
    List = {"Fist", "Relic"},
    Callback = function(v)
        Item = v
    end
})

Section3:Slider({
    Text = "Minimum Level",
    Minimum = 2,
    Default = 6,
    Maximum = 10,
    Incrementation = .1,
    Callback = function(v)
        Level = v
    end
})

Section3:Button({
    Text = "Mass Upgrade",
    Tooltip = "Uses all the items lesser or equal to the minimum level to upgrade your eqquiped item.",
    Callback = function()
        if not Item then
            return
        end
        
        local Upgrade = {}

        local ItemTable = DecodeStats()[Item.."s"]
        
        for _, v in ipairs(ItemTable) do
            if v.Level <= Level then
                table.insert(Upgrade, _)
            end
        end
        
        game:GetService("ReplicatedStorage").UpgradeItem:InvokeServer(Item, Upgrade)
    end
})

local Craft = false
Section3:Check({
    Text = "Ticket Crafting",
    Callback = function(v)
        Craft = v
        
        while Craft do
            local Tickets = DecodeStats().Tickets
            
            for ticket, v in pairs(Crafting) do
                if Tickets[v.Ticket] >= v.Needed then
                    game:GetService("ReplicatedStorage").Reroll:InvokeServer("Craft", ticket)
                end
                task.wait(.2)
            end
            task.wait()
        end
    end
})

AntiState = Section4:Label({
    Text = "Anti-TP: Not bypassed"
})

local Got = false
local RollCheck

local AutoRoll = false
local Ignore = false
local MinimumLevel = 10
local Slot = 1
local Chosen

local function OnChosen(v, p)
    Library:Notify({
            Text = "Congratulations! You have spun a "..p.." "..v
        })
        
    Got = true
            
    RollCheck:Set(false)
end

Claim.OnClientInvoke = function(v, p) -- egg salad had this idea first.
    if table.find(Chosen, "All (Minimum Level)") then
        if p >= MinimumLevel then
        OnChosen(v, p)
        
        return false, Slot
        end
    end
    
    if Ignore then
        if table.find(Chosen, v) then
            OnChosen(v, p)
            
            return false, Slot
        end
    end
    
    if table.find(Chosen, v) and p >= MinimumLevel then
        OnChosen(v, p)
        
        return false, Slot
    end
    
    Library:Notify({
        Text = "You have spun a "..p.." "..v,
        Timeout = 5
    })
    
    return false, false
end

RollCheck = Section5:Check({
    Text = "Enabled",
    Callback = function(v)
        AutoRoll = v
        
        if not AutoRoll then
            Got = false
        end
        
        if Chosen == nil and AutoRoll then
            Library:Notify({
                Text = "You have to choose one or more abilities.",
                Timeout = 10
            })
        
            while true do
                if Chosen ~= nil or not AutoRoll then
                    break
                end
                task.wait()
            end
            
        end
        
        while AutoRoll and not Got do
            warn("working")
            Reroll:InvokeServer()
            task.wait(2)
        end
        
    end
})

Section5:Check({
    Text = "Ignore Level",
    Callback = function(v)
        Ignore = v
    end
})

Section5:Dropdown({
    Text = "Abilities",
    List = Abilities,
    MultiSelect = true,
    Callback = function(v)
        Chosen = v
    end
})

Section5:Slider({
    Text = "Minimum Level",
    Minimum = 1,
    Default = 10,
    Maximum = 20,
    Incrementation = 0.1,
    Callback = function(v)
        MinimumLevel = v
    end
})

Section5:Slider({
    Text = "Slot",
    Minimum = 1,
    Default = 1,
    Incrementation = 1,
    Maximum = Player.MaxStored.Value,
    Callback = function(v)
        Slot = v
    end
})

Tab:Select()
