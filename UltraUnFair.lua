local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/BECK/main/Library.lua', true))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Mouse = Player:GetMouse()

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
local ShowDrops = ReplicatedStorage:WaitForChild("ShowDrops")
local function DecodeStats()
    return HttpService:JSONDecode(Player.Stats.Value)
end

local Crafting = {
    ["Elite-Tier"] = {Needed = 5, Ticket = "Common"},
    ["High-Tier"] = {Needed = 5, Ticket = "Elite-Tier"},
    ["God-Tier"] = {Needed = 5, Ticket = "High-Tier"},
    ["Mythical"] = {Needed = 4, Ticket = "God-Tier"},
    ["Divine"] = {Needed = 3, Ticket = "Mythical"}
}

local function GetStored()
    local Stored = DecodeStats().Stored
    
    return Stored
end

local function Waypoint(pos)
    local Part = Instance.new("Part", workspace)
    
	Part.Anchored = true
	Part.Shape = "Ball"
	Part.Color = Color3.fromRGB(52, 235, 103)
	Part.Material = Enum.Material.Neon
	Part.Size = Vector3.new(1, 1, 1)
	Part.CanCollide = false
	Part.CFrame = pos
	
	return Part
end

Waypoint(CFrame.new(-97.0014801, 163.821426, -31.000473, 1, 0, 0, 0, 1, 0, 0, 0, 1))

--[[
local function SendEmbed(title, message, color)
    color = color or 0x6f03fc
    
    local Data = {
    	["embeds"] = {{
    		["color"] =  color,
    		["timestamp"] = tostring(DateTime.now():ToIsoDate()),
    		["fields"] = {
    			{
    				["name"] = title,
    				["value"] = message,
    				["inline"] = true
    			},
    			},
    			["footer"] = {
    			["text"] = "Notification"
    			}
    	}}
    }
    
    local EncodedData = HttpService:JSONEncode(Data)
    
    syn.request({Url = "", Method = "POST", Headers = {["Content-Type"] = "application/json"  }, Body = EncodedData})
end
--]]
--//

--// Anti AFK
task.spawn(function()
    while true do
        VirtualInputManager:SendMouseMoveEvent(math.random(50,400),math.random(0,350),game)
        task.wait(600)
    end
end)
--//

local Window = Library:Window({
    Text = "Ultra unFair"
})

local Tab2 = Window:Tab({
    Text = "Miscellaneous",
    Image = 7072707647,
    Description = "item, spinning, others"
})

local Section5 = Tab2:Section({
    Text = "Auto-Roll",
    Side = "Right"
})

local Section6 = Tab2:Section({
    Text = "Crafting",
    Side = "Left"
})

local Section7 = Tab2:Section({
    Text = "Item-Roll",
    Side = "Left"
})

Library:Notify({
    Text = "Autofarm and Kill-Aura have been patched. I removed them to avoid bans.",
    Timeout = 15
})

local Craft = false
Section6:Check({
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

local Got = false
local RollCheck

local AutoRoll = false
local Ignore = false
local MinimumLevel = 10
local SelectedSlot
local Keep20 = false
local Slot = 1
local Chosen

local function UpdateSlot(slot)
    if SelectedSlot == nil then return end
    
    local AbilitySlot = GetStored()[slot]
    
    SelectedSlot:Set({
        Text = "Slot: "..AbilitySlot.Ability.." ("..tostring(AbilitySlot.Potential)..")"
    })
end

local function OnChosen(v, p)
    Library:Notify({
            Text = "Congratulations! You have spun a "..p.." "..v
        })
        
    Got = true
            
    RollCheck:Set(false)
end

--[[ShowDrops.OnClientEvent:Connect(function(contrib, tickets, money, experience, gold, _)
    local TicketsWon = {}
    
    for _, v in pairs(tickets) do
        if v > 0 then
            table.insert(TicketsWon, _)
        end
    end

    SendEmbed("You have killed a boss.", "Contribution: "..tostring(math.ceil(contrib * 100) / 10).."\nMoney: "..tostring(money).."\nExp: "..tostring(experience).."\nGold: "..tostring(gold).."\nTickets: "..table.concat(TicketsWon, ", "))
end)--]]

Claim.OnClientInvoke = function(v, p)
    if Keep20 then
        if p >= 20 then
        OnChosen(v, p)
        
        return false, Slot
        end
    end
    
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

    p = 1
    
    return false, false
end

script:Destroy()

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
        
            RollCheck:Set(false)
            
        end
        
        while AutoRoll and not Got do
            warn("working")
            Reroll:InvokeServer()
            task.wait(.5)
        end
        
    end
})

Section5:Check({
    Text = "Ignore Level",
    Callback = function(v)
        Ignore = v
    end
})

Section5:Check({
    Text = "Keep 20.0",
    Callback = function(v)
        Keep20 = v
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
        
        UpdateSlot(v)
    end
})

SelectedSlot = Section5:Label({
    Text = "Slot: "
})

Section5:Label({
    Text = "OBS: Don't spin manually atm!"
})
task.spawn(function()
    while true do
        UpdateSlot(Slot)
        task.wait(1)
    end
end)

UpdateSlot(1)

local AutoItemRoll = false
local RollItem
local ItemDelay = 0.5
local RollItemLevel = 6
local FastMode = false
local Blacklisted
local BlacklistedLevel
local ItemRollCheck

local function MassUpgrade(item, level)
    local Upgrade = {}

    local ItemTable = DecodeStats()[item.."s"]
        
    for _, v in ipairs(ItemTable) do
        if v.Level <= level then
            if Blacklisted ~= nil and table.find(Blacklisted, v.Name) and v.Level >= BlacklistedLevel then continue end
            
            table.insert(Upgrade, _)
        end
    end
        
    game:GetService("ReplicatedStorage").UpgradeItem:InvokeServer(item, Upgrade)
end

ItemRollCheck = Section7:Check({
    Text = "Enabled",
    Tooltip = "Spins for the desired item and uses the items below the minimum level to upgrade the item",
    Callback = function(v)
        AutoItemRoll = v
        
        if RollItem == nil and AutoItemRoll then
            Library:Notify({
                Text = "You have to choose an item before enabling this.",
                Timeout = 10
            })
            
            ItemRollCheck:Set(false)
            
            return
        end
        
        local Quantity
        
        while AutoItemRoll do
            Quantity = #DecodeStats()[RollItem.."s"]
            
            if Quantity >= 25 then
                while true do
                    if Quantity < 25 or not AutoItemRoll then
                        break
                    end
                    
                    MassUpgrade(RollItem, RollItemLevel)
                    
                    task.wait(.25)
                    
                    Quantity = #DecodeStats()[RollItem.."s"]
                    
                    task.wait(.75)
                end
            end
            
            game:GetService("ReplicatedStorage").RollGear:InvokeServer(RollItem)
            
            if FastMode then
                if Quantity < 24 then
                    for i = 1, 4 do
                        if not AutoItemRoll then break end
                        game:GetService("ReplicatedStorage").RollGear:InvokeServer(RollItem)
                    end
                end
            end
            
            task.wait(ItemDelay)
        end
    end
})

Section7:Dropdown({
    Text = "Item",
    List = {"Fist", "Relic"},
    Callback = function(v)
        RollItem = v
    end
})

Section7:Slider({
    Text = "Delay",
    Minimum = 0.1,
    Default = .5,
    Maximum = 1,
    Incrementation = .1,
    Callback = function(v)
        ItemDelay = v
    end
})

Section7:Check({
    Text = "Fast-Mode",
    Tooltip = "Rolls faster. You can be banned if any staff notices that you're getting rare items way too fast.",
    Callback = function(v)
        FastMode = v
    end
})

Section7:Slider({
    Text = "Minimum Level",
    Minimum = 2,
    Default = 6,
    Incrementation = 0.1,
    Maximum = 10,
    Callback = function(v)
        RollItemLevel = v
    end
})

local FistsTable = {}

for _, v in pairs(Info.Fists) do
    table.insert(FistsTable, _)
end

Section7:Dropdown({
    Text = "Fist Blacklist",
    Tooltip = "Fists you don't want to be used to upgrade the item.",
    MultiSelect = true,
    List = FistsTable,
    Callback = function(v)
        Blacklisted = v
    end
})

Section7:Slider({
    Text = "Blacklisted Level",
    Tooltip = "The minimum level of the blacklisted fist you want to keep.",
    Minimum = 2,
    Default = 6,
    Maximum = 10,
    Incrementation = 0.1,
    Callback = function(v)
        BlacklistedLevel = v
    end
})

Tab2:Select()
