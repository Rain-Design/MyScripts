local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Shaman") then
    CoreGui.Shaman:Destroy()
end

local library = {
    Flags = {}
}

function library:Window(Info)
Info.Text = Info.Text or "Shaman"

local window = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Shaman"
screenGui.Parent = CoreGui

local main = Instance.new("Frame")
main.Name = "Main"
main.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Position = UDim2.new(0.361, 0, 0.308, 0)
main.Size = UDim2.new(0, 450, 0, 321)
main.Parent = screenGui

local uICorner = Instance.new("UICorner")
uICorner.Name = "UICorner"
uICorner.CornerRadius = UDim.new(0, 5)
uICorner.Parent = main

local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topbar.Size = UDim2.new(0, 450, 0, 31)
topbar.Parent = main
topbar.ZIndex = 2

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        		
        input.Changed:Connect(function()
        	if input.UserInputState == Enum.UserInputState.End then
        		dragging = false
        	end
        end)
    end
end)

topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)


local uICorner1 = Instance.new("UICorner")
uICorner1.Name = "UICorner"
uICorner1.Parent = topbar

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0, 0, 0.625, 0)
frame.Size = UDim2.new(0, 450, 0, 11)
frame.Parent = topbar

local frame1 = Instance.new("Frame")
frame1.Name = "Frame"
frame1.AnchorPoint = Vector2.new(0.5, 1)
frame1.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
frame1.BorderSizePixel = 0
frame1.Position = UDim2.new(0.5, 0, 1, 0)
frame1.Size = UDim2.new(0, 450, 0, 1)
frame1.ZIndex = 2
frame1.Parent = frame

local uIGradient = Instance.new("UIGradient")
uIGradient.Name = "UIGradient"
uIGradient.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(183, 248, 219)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 167, 194)),
})
uIGradient.Enabled = false
uIGradient.Parent = frame1

local textLabel = Instance.new("TextLabel")
textLabel.Name = "TextLabel"
textLabel.Font = Enum.Font.GothamBold
textLabel.Text = Info.Text
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 12
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.BackgroundColor3 = Color3.fromRGB(237, 237, 237)
textLabel.BackgroundTransparency = 1
textLabel.Position = UDim2.new(0.015, 0, 0, 0)
textLabel.Size = UDim2.new(0, 51, 0, 30)
textLabel.ZIndex = 2
textLabel.Parent = topbar

local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Image = "rbxassetid://10664057093"
closeButton.ImageColor3 = Color3.fromRGB(237, 237, 237)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(0.947, 0, 0.194, 0)
closeButton.Size = UDim2.new(0, 17, 0, 17)
closeButton.ZIndex = 2
closeButton.Parent = topbar

local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Image = "rbxassetid://10664064072"
minimizeButton.ImageColor3 = Color3.fromRGB(237, 237, 237)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Position = UDim2.new(0.893, 0, 0.194, 0)
minimizeButton.Size = UDim2.new(0, 17, 0, 17)
minimizeButton.ZIndex = 2
minimizeButton.Parent = topbar

local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabContainer.Position = UDim2.new(0, 0, 0.0935, 0)
tabContainer.Size = UDim2.new(0, 114, 0, 291)
tabContainer.Parent = main

local uICorner2 = Instance.new("UICorner")
uICorner2.Name = "UICorner"
uICorner2.CornerRadius = UDim.new(0, 5)
uICorner2.Parent = tabContainer

local fix = Instance.new("Frame")
fix.Name = "Fix"
fix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
fix.BorderSizePixel = 0
fix.Position = UDim2.new(0.895, 0, 0, 0)
fix.Size = UDim2.new(0, 11, 0, 285)
fix.Parent = tabContainer

local fix1 = Instance.new("Frame")
fix1.Name = "Fix"
fix1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
fix1.BorderSizePixel = 0
fix1.Position = UDim2.new(0, 0, -0.00351, 0)
fix1.Size = UDim2.new(0, 11, 0, 79)
fix1.Parent = tabContainer

local scrollingContainer = Instance.new("ScrollingFrame")
scrollingContainer.Name = "ScrollingContainer"
scrollingContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingContainer.CanvasSize = UDim2.new()
scrollingContainer.ScrollBarImageColor3 = Color3.fromRGB(56, 56, 56)
scrollingContainer.ScrollBarThickness = 2
scrollingContainer.Active = true
scrollingContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scrollingContainer.BackgroundTransparency = 1
scrollingContainer.BorderSizePixel = 0
scrollingContainer.Size = UDim2.new(0, 114, 0, 285)
scrollingContainer.ZIndex = 2
scrollingContainer.Parent = tabContainer

function window:Tab(Info)
Info.Text = Info.Text or "Tab"

local tab = {}

local tabButton = Instance.new("Frame")
tabButton.Name = "TabButton"
tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabButton.BackgroundTransparency = 1
tabButton.Size = UDim2.new(0, 113, 0, 27)
tabButton.Parent = scrollingContainer

local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabFrame.BackgroundTransparency = 0.96
tabFrame.BorderSizePixel = 0
tabFrame.Position = UDim2.new(0.067, -5, 0.013, 3)
tabFrame.Size = UDim2.new(0, 107, 0, 23)
tabFrame.ZIndex = 2
tabFrame.Parent = tabButton

local tabTextButton = Instance.new("TextButton")
tabTextButton.Name = "TabTextButton"
tabTextButton.Font = Enum.Font.SourceSans
tabTextButton.Text = ""
tabTextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
tabTextButton.TextSize = 14
tabTextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabTextButton.BackgroundTransparency = 1
tabTextButton.Size = UDim2.new(0, 107, 0, 23)
tabTextButton.Parent = tabFrame

local uICorner3 = Instance.new("UICorner")
uICorner3.Name = "UICorner"
uICorner3.CornerRadius = UDim.new(0, 3)
uICorner3.Parent = tabFrame

local textLabel1 = Instance.new("TextLabel")
textLabel1.Name = "TextLabel"
textLabel1.Font = Enum.Font.GothamBold
textLabel1.Text = Info.Text
textLabel1.TextColor3 = Color3.fromRGB(237, 237, 237)
textLabel1.TextSize = 11
textLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textLabel1.BackgroundTransparency = 1
textLabel1.Size = UDim2.new(0, 108, 0, 23)
textLabel1.ZIndex = 2
textLabel1.Parent = tabFrame

local uIStroke = Instance.new("UIStroke")
uIStroke.Name = "UIStroke"
uIStroke.Color = Color3.fromRGB(68, 68, 68) -- 183, 248, 219
uIStroke.Transparency = 0.45
uIStroke.Parent = tabFrame

local selected = Instance.new("Frame")
selected.Name = "Selected"
selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
selected.BackgroundTransparency = 0.1
selected.Visible = false
selected.BorderSizePixel = 0
selected.Position = UDim2.new(0.067, -5, 0.013, 3)
selected.Size = UDim2.new(0, 108, 0, 23)
selected.Parent = tabButton

local uICorner4 = Instance.new("UICorner")
uICorner4.Name = "UICorner"
uICorner4.CornerRadius = UDim.new(0, 3)
uICorner4.Parent = selected

local uIGradient1 = Instance.new("UIGradient")
uIGradient1.Name = "UIGradient"
uIGradient1.Parent = selected
uIGradient1.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(183, 248, 219)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
})
uIGradient1.Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 0.5),
  NumberSequenceKeypoint.new(0.688, 0.725),
  NumberSequenceKeypoint.new(1, 0.506),
})

local leftContainer = Instance.new("ScrollingFrame")
leftContainer.Name = "LeftContainer"
leftContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
leftContainer.CanvasSize = UDim2.new()
leftContainer.ScrollBarThickness = 0
leftContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
leftContainer.BorderSizePixel = 0
leftContainer.Position = UDim2.new(0.253, 0, 0.0935, 0)
leftContainer.Selectable = false
leftContainer.Size = UDim2.new(0, 168, 0, 287)
leftContainer.Parent = main
leftContainer.Visible = false

local uIListLayout2 = Instance.new("UIListLayout")
uIListLayout2.Name = "UIListLayout"
uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout2.Parent = leftContainer

local uIPadding2 = Instance.new("UIPadding")
uIPadding2.Name = "UIPadding"
uIPadding2.PaddingLeft = UDim.new(0, 4)
uIPadding2.PaddingTop = UDim.new(0, 3)
uIPadding2.Parent = leftContainer

local rightContainer = Instance.new("ScrollingFrame")
rightContainer.Name = "RightContainer"
rightContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
rightContainer.CanvasSize = UDim2.new()
rightContainer.ScrollBarThickness = 0
rightContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
rightContainer.BorderSizePixel = 0
rightContainer.Position = UDim2.new(0.627, 0, 0.0935, 0)
rightContainer.Selectable = false
rightContainer.Size = UDim2.new(0, 168, 0, 287)
rightContainer.Parent = main
rightContainer.Visible = false

local uIListLayout3 = Instance.new("UIListLayout")
uIListLayout3.Name = "UIListLayout"
uIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout3.Parent = rightContainer

local uIPadding3 = Instance.new("UIPadding")
uIPadding3.Name = "UIPadding"
uIPadding3.PaddingLeft = UDim.new(0, 2)
uIPadding3.PaddingTop = UDim.new(0, 3)
uIPadding3.Parent = rightContainer

local uICorner8 = Instance.new("UICorner")
uICorner8.Name = "UICorner"
uICorner8.CornerRadius = UDim.new(0, 3)
uICorner8.Parent = rightContainer

function tab:Section(Info)
Info.Text = Info.Text or "Section"
Info.Side = Info.Side or "Left"

local SizeY = 27

local sectiontable = {}

local Side
local Closed = false
    
if Info.Side == "Left" then
    Side = leftContainer
    else
    Side = rightContainer
end
    
local section = Instance.new("Frame")
section.Name = "Section"
section.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
section.BackgroundTransparency = 1
section.Size = UDim2.new(0, 162, 0, 27)
section.Parent = Side

local sectionFrame = Instance.new("Frame")
sectionFrame.Name = "SectionFrame"
sectionFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
sectionFrame.ClipsDescendants = true
sectionFrame.Size = UDim2.new(0, 162, 0, 23)
sectionFrame.Parent = section

sectionFrame.ChildAdded:Connect(function(v)
    if v.ClassName == "Frame" then
        SizeY = SizeY + 23
    end
end)

local uIStroke3 = Instance.new("UIStroke")
uIStroke3.Name = "UIStroke"
uIStroke3.Color = Color3.fromRGB(52, 52, 52)
uIStroke3.Parent = sectionFrame

local uICorner7 = Instance.new("UICorner")
uICorner7.Name = "UICorner"
uICorner7.CornerRadius = UDim.new(0, 3)
uICorner7.Parent = sectionFrame

local uIListLayout1 = Instance.new("UIListLayout")
uIListLayout1.Name = "UIListLayout"
uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout1.Parent = sectionFrame

local uIPadding1 = Instance.new("UIPadding")
uIPadding1.Name = "UIPadding"
uIPadding1.PaddingTop = UDim.new(0, 23)
uIPadding1.Parent = sectionFrame

local sectionName = Instance.new("TextLabel")
sectionName.Name = "SectionName"
sectionName.Font = Enum.Font.GothamBold
sectionName.Text = Info.Text
sectionName.TextColor3 = Color3.fromRGB(217, 217, 217)
sectionName.TextSize = 11
sectionName.TextXAlignment = Enum.TextXAlignment.Left
sectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sectionName.BackgroundTransparency = 1
sectionName.Position = UDim2.new(0.0488, 0, 0, 0)
sectionName.Size = UDim2.new(0, 128, 0, 23)
sectionName.Parent = section

local sectionButton = Instance.new("ImageButton")
sectionButton.Name = "SectionButton"
sectionButton.Image = "rbxassetid://10664195729"
sectionButton.ImageColor3 = Color3.fromRGB(217, 217, 217)
sectionButton.AnchorPoint = Vector2.new(1, 0)
sectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sectionButton.BackgroundTransparency = 1
sectionButton.Position = UDim2.new(1, -5, 0, 5)
sectionButton.Size = UDim2.new(0, 13, 0, 13)
sectionButton.ZIndex = 2
sectionButton.Parent = section

sectionButton.MouseButton1Click:Connect(function()
    Closed = not Closed
    
    TweenService:Create(section, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = Closed and UDim2.new(0, 162, 0, SizeY + 4) or UDim2.new(0, 162, 0, 27)}):Play()
    TweenService:Create(sectionFrame, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = Closed and UDim2.new(0, 162, 0, SizeY) or UDim2.new(0, 162, 0, 23)}):Play()
    TweenService:Create(sectionButton, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Rotation = Closed and 45 or 0}):Play()
end)

function sectiontable:Button(Info)
Info.Text = Info.Text or "Button"
Info.Callback = Info.Callback or function() end
    
local button = Instance.new("Frame")
button.Name = "Button"
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundTransparency = 1
button.Size = UDim2.new(0, 162, 0, 27)
button.Parent = sectionFrame

local buttonText = Instance.new("TextLabel")
buttonText.Name = "ButtonText"
buttonText.Font = Enum.Font.GothamBold
buttonText.Text = Info.Text
buttonText.TextColor3 = Color3.fromRGB(217, 217, 217)
buttonText.TextSize = 11
buttonText.TextXAlignment = Enum.TextXAlignment.Left
buttonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
buttonText.BackgroundTransparency = 1
buttonText.Position = UDim2.new(0.0488, 0, 0, 0)
buttonText.Size = UDim2.new(0, 156, 0, 27)
buttonText.Parent = button

local textButton = Instance.new("TextButton")
textButton.Name = "TextButton"
textButton.Font = Enum.Font.SourceSans
textButton.Text = ""
textButton.TextColor3 = Color3.fromRGB(0, 0, 0)
textButton.TextSize = 14
textButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textButton.BackgroundTransparency = 1
textButton.Size = UDim2.new(0, 162, 0, 27)
textButton.Parent = button

textButton.MouseButton1Click:Connect(function()
    pcall(Info.Callback)
end)
end

function sectiontable:Toggle(Info)
Info.Text = Info.Text or "Toggle"
Info.Flag = Info.Flag or Info.Text
Info.Callback = Info.Callback or function() end

library.Flags[Info.Flag] = false

local Toggled = false

local toggle = Instance.new("Frame")
toggle.Name = "Toggle"
toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle.BackgroundTransparency = 1
toggle.Size = UDim2.new(0, 162, 0, 27)
toggle.Parent = sectionFrame

local toggleText = Instance.new("TextLabel")
toggleText.Name = "ToggleText"
toggleText.Font = Enum.Font.GothamBold
toggleText.Text = Info.Text
toggleText.TextColor3 = Color3.fromRGB(217, 217, 217)
toggleText.TextSize = 11
toggleText.TextXAlignment = Enum.TextXAlignment.Left
toggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleText.BackgroundTransparency = 1
toggleText.Position = UDim2.new(0.0488, 0, 0, 0)
toggleText.Size = UDim2.new(0, 156, 0, 27)
toggleText.Parent = toggle

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Text = ""
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundTransparency = 1
toggleButton.Size = UDim2.new(0, 162, 0, 27)
toggleButton.Parent = toggle

local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
toggleFrame.BorderSizePixel = 0
toggleFrame.Position = UDim2.new(0.883, 0, 0.222, 0)
toggleFrame.Size = UDim2.new(0, 15, 0, 15)
toggleFrame.Parent = toggle

local toggleUICorner = Instance.new("UICorner")
toggleUICorner.Name = "ToggleUICorner"
toggleUICorner.CornerRadius = UDim.new(0, 3)
toggleUICorner.Parent = toggleFrame

local checkIcon = Instance.new("ImageLabel")
checkIcon.Name = "CheckIcon"
checkIcon.Image = "rbxassetid://10665913527"
checkIcon.ImageColor3 = Color3.fromRGB(217, 217, 217)
checkIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
checkIcon.BackgroundTransparency = 1
checkIcon.Size = UDim2.new(0, 15, 0, 15)
checkIcon.Visible = false
checkIcon.Parent = toggleFrame

toggleButton.MouseButton1Click:Connect(function()
    Toggled = not Toggled
    library.Flags[Info.Flag] = Toggled
    
    checkIcon.Visible = Toggled and true or false
    pcall(Info.Callback, Toggled)
end)

end

return sectiontable
end

tabTextButton.MouseButton1Click:Connect(function()
    task.spawn(function()
    for _,v in pairs(main:GetChildren()) do
        if v.Name == "LeftContainer" or v.Name == "RightContainer" then
            v.Visible = false
        end
    end
    end)
    for _,v in pairs(scrollingContainer:GetChildren()) do
        if v ~= tabButton and v.Name == "TabButton" then
            TweenService:Create(v.TabFrame, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = .96}):Play()
        end
    end
    TweenService:Create(tabFrame, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = .85}):Play()
    leftContainer.Visible = true
    rightContainer.Visible = true
end)

function tab:Select()
    task.spawn(function()
    for _,v in pairs(main:GetChildren()) do
        if v.Name == "LeftContainer" or v.Name == "RightContainer" then
            v.Visible = false
        end
    end
    end)
    for _,v in pairs(scrollingContainer:GetChildren()) do
        if v ~= tabButton and v.Name == "TabButton" then
            TweenService:Create(v.TabFrame, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = .96}):Play()
        end
    end
    TweenService:Create(tabFrame, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = .85}):Play()
    leftContainer.Visible = true
    rightContainer.Visible = true
end

return tab
end

local uIListLayout = Instance.new("UIListLayout")
uIListLayout.Name = "UIListLayout"
uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout.Parent = scrollingContainer

local uIPadding = Instance.new("UIPadding")
uIPadding.Name = "UIPadding"
uIPadding.Parent = scrollingContainer

local frame2 = Instance.new("Frame")
frame2.Name = "Frame"
frame2.AnchorPoint = Vector2.new(1, 0.5)
frame2.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
frame2.BorderSizePixel = 0
frame2.Position = UDim2.new(1, 0, 0.501, 0)
frame2.Size = UDim2.new(0, 1, 0, 284)
frame2.Parent = tabContainer

local uIStroke2 = Instance.new("UIStroke")
uIStroke2.Name = "UIStroke"
uIStroke2.Color = Color3.fromRGB(61, 61, 61)
uIStroke2.Parent = main

return window
end

return library