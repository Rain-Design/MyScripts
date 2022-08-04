local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/Libraries/main/Revenant.lua", true))()

local Window = Library:Window({
    Text = "Farming"
})

local JobFarming = false
Window:Toggle({
    Text = "Job Farming",
    Callback = function(bool)
        JobFarming = bool
    end
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local PathfindingService = game:GetService("PathfindingService")

local WaypointFolder = Instance.new("Folder", workspace)
WaypointFolder.Name = "WaypointFolder"

local HairColorR
local HairColorG
local HairColorB

for _,v in pairs(Player.Character:GetChildren()) do
    if v.ClassName == "Accessory" and v.AccessoryType == Enum.AccessoryType.Hair then
        HairColorR = v.Handle.Color.R * 255
        HairColorG = v.Handle.Color.G * 255
        HairColorB = v.Handle.Color.B * 255
    end
end

local MainGui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainGui")

local function GetQuestLocationPart()
    local Part = nil
    for _,v in pairs(game:GetService("Workspace").Quests.QuestLocations:GetDescendants()) do
        if v.Name == "Marker" and v.Enabled then
            if v.Parent.ClassName == "Model" then
            Part = v.Parent.PrimaryPart
            else
            Part = v.Parent
            end
        end
    end
    return Part
end

--[[local function GetPosterOrGraffiti()
    local Part, ClickDetector = nil, nil
    for _,v in pairs(game:GetService("Workspace").Quests.Misc:GetDescendants()) do
        if v:FindFirstChild("Marker") and v.Marker.Enabled then
            Part, ClickDetector = v, v.ClickDetector
        end
    end
    return Part, ClickDetector
end--]]

local function GetNearestPoster()
    local Part, Distance = nil, math.huge
    
    for _,v in pairs(game:GetService("Workspace").Quests.Misc:GetDescendants()) do
        if v:FindFirstChild("Marker") and v.Marker.Enabled and v:FindFirstChildOfClass("Decal") and v:FindFirstChildOfClass("Decal").Transparency == 1 then
            local Magnitude = (Player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            
            if Magnitude < Distance then
                Part, Distance = v, Magnitude
            end
        end
    end
    return Part
end

local function GetNearestGraffiti()
    local Part, Distance = nil, math.huge
    
    for _,v in pairs(game:GetService("Workspace").Quests.Misc:GetDescendants()) do
        if v:FindFirstChild("Marker") and v.Marker.Enabled and v:FindFirstChildOfClass("Decal") and v:FindFirstChildOfClass("Decal").Transparency == 0 then
            local Magnitude = (Player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            
            if Magnitude < Distance then
                Part, Distance = v, Magnitude
            end
        end
    end
    return Part
end

local Connection
local QuestHandler
QuestHandler = function()
    local Quest = Player.Character:FindFirstChild("Quest")
    if Quest then
    local QuestName = Quest:FindFirstChild("PlayerQuest").Value
    
    if QuestName == "Cat" or QuestName == "Delivery" or QuestName == "Briefcase" then
    
    local Path = PathfindingService:CreatePath({
        AgentCanJump = true,
        AgentRadius = 4,
        Costs = {
            Metal = math.huge,
            DiamondPlate = math.huge,
            Brick = 3,
            Slate = 2,
            Concrete = 1
        }
    })
    
    local QuestPart = GetQuestLocationPart()
    local ClickDetector
    if QuestName == "Briefcase" then
    ClickDetector = QuestPart.Parent:FindFirstChildOfClass("ClickDetector")
    else
    ClickDetector = QuestPart:FindFirstChildOfClass("ClickDetector")
    end
    warn(ClickDetector)
    
    Path:ComputeAsync(Player.Character.HumanoidRootPart.Position, QuestPart.Position)

    if Path.Status == Enum.PathStatus.Success then
	local Waypoints = Path:GetWaypoints()
	
	for _, Waypoint in pairs(Waypoints) do
	    local Part = Instance.new("Part", WaypointFolder)
	    Part.Anchored = true
		Part.Shape = "Ball"
		Part.Color = Color3.fromRGB(HairColorR, HairColorG, HairColorB)
		Part.Material = "Neon"
		Part.Size = Vector3.new(1, 1, 1)
		Part.CanCollide = false
		Part.Position = Waypoint.Position + Vector3.new(0, 2, 0)
		
		coroutine.wrap(function()
		    wait(3)
		    Part:Destroy()
		end)()
		
		if Waypoint.Action == Enum.PathWaypointAction.Jump then
			Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		if Player.Character:FindFirstChild("Humanoid") then
			Player.Character.Humanoid:MoveTo(Waypoint.Position)
			game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Run", true, Player.Character.LocalHandler.Running)
			Player.Character.Humanoid.MoveToFinished:Wait()
			
		end
	end
	    if ClickDetector ~= nil then
	    while Player.Character:FindFirstChild("Quest") do
		fireclickdetector(ClickDetector)
		wait()
		end
	    end
	    repeat task.wait() until not Player.Character:FindFirstChild("Quest")
    end
elseif QuestName == "Poster" or QuestName == "Graffiti" then
    wait(1)
    
    local Nearest
    
    if QuestName == "Poster" then
        Nearest = GetNearestPoster()
    else
        Nearest = GetNearestGraffiti()
    end
    
    local Decal = Nearest:FindFirstChildOfClass("Decal")
    local ClickDetector = Nearest:FindFirstChildOfClass("ClickDetector")
    warn(Nearest:GetFullName(), ClickDetector)

    local Req = Quest:FindFirstChild("Req").Value
    local Objective = Quest:FindFirstChild("Objective")
    
    local Path = PathfindingService:CreatePath({
        AgentCanJump = true,
        AgentRadius = 4,
        Costs = {
            Metal = math.huge,
            DiamondPlate = math.huge,
            Brick = 3,
            Slate = 2,
            Concrete = 1
        }
    })
    
    Path:ComputeAsync(Player.Character.HumanoidRootPart.Position, Nearest.Position)

    if Path.Status == Enum.PathStatus.Success then
	local Waypoints = Path:GetWaypoints()
	
	for _, Waypoint in pairs(Waypoints) do
	    local Part = Instance.new("Part", WaypointFolder)
	    Part.Anchored = true
		Part.Shape = "Ball"
		Part.Color = Color3.fromRGB(HairColorR, HairColorG, HairColorB)
		Part.Material = "Neon"
		Part.Size = Vector3.new(1, 1, 1)
		Part.CanCollide = false
		Part.Position = Waypoint.Position + Vector3.new(0, 3, 0)
	    
	    coroutine.wrap(function()
		    wait(2)
		    Part:Destroy()
		end)()
	    
		if Waypoint.Action == Enum.PathWaypointAction.Jump then
			Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		if Player.Character:FindFirstChild("Humanoid") then
			Player.Character.Humanoid:MoveTo(Waypoint.Position)
			game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Run", true, Player.Character.LocalHandler.Running)
			Player.Character.Humanoid.MoveToFinished:Wait()
		end
	end
	while Objective.Value <  Req do
	    fireclickdetector(ClickDetector)
	    wait()
	end
	repeat task.wait() until not Player.Character:FindFirstChild("Quest")
    end
    else
    repeat task.wait() until not Player.Character:FindFirstChild("Quest")
    end
else
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Quest")
    repeat task.wait() until Player.Character:FindFirstChild("Quest")
end
end

while true do
    if JobFarming then
        QuestHandler()
    end
    wait()
end
