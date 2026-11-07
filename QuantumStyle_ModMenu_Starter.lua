-- Quantum-inspired Roblox Studio mod-menu starter
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Original UI styling; intended for a Roblox experience you own/control.
-- This is a framework, not a universal cheat. Weapon firing and server-authoritative
-- abilities must be connected to your own game's systems.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local COLORS = {
    background = Color3.fromRGB(17, 18, 24),
    panel = Color3.fromRGB(26, 28, 37),
    panel2 = Color3.fromRGB(34, 37, 48),
    accent = Color3.fromRGB(145, 95, 255),
    accent2 = Color3.fromRGB(70, 210, 230),
    text = Color3.fromRGB(240, 242, 250),
    muted = Color3.fromRGB(155, 160, 178),
    off = Color3.fromRGB(70, 73, 86),
    on = Color3.fromRGB(120, 80, 220),
}

local gui = Instance.new("ScreenGui")
gui.Name = "QuantumInspiredMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = object
end

local function stroke(object, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.accent
    s.Transparency = transparency or 0.25
    s.Thickness = 1
    s.Parent = object
end

-- Movable floating launcher button.
local launcher = Instance.new("TextButton")
launcher.Name = "FloatingMenuButton"
launcher.Size = UDim2.fromOffset(54, 54)
launcher.Position = UDim2.new(0, 24, 0.5, -27)
launcher.BackgroundColor3 = COLORS.panel
launcher.Text = "Q"
launcher.TextColor3 = COLORS.text
launcher.TextSize = 24
launcher.Font = Enum.Font.GothamBold
launcher.AutoButtonColor = true
launcher.Parent = gui
corner(launcher, 18)
stroke(launcher, COLORS.accent, 0)

local dragging, dragStart, startPos, moved = false, nil, nil, false
launcher.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        moved = false
        dragStart = input.Position
        startPos = launcher.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then moved = true end
        launcher.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(440, 420)
panel.Position = UDim2.new(0.5, -220, 0.5, -210)
panel.BackgroundColor3 = COLORS.background
panel.Visible = false
panel.Parent = gui
corner(panel, 14)
stroke(panel, COLORS.accent, 0.15)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = COLORS.panel
header.Parent = panel
corner(header, 14)
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 0)
title.Size = UDim2.new(1, -70, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "QUANTUM  /  MOD MENU"
title.TextColor3 = COLORS.text
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -42, 0, 9)
close.BackgroundColor3 = COLORS.panel2
close.Text = "×"
close.TextColor3 = COLORS.text
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.Parent = header
corner(close, 8)

-- Make the main panel draggable by its header.
local panelDragging, panelDragStart, panelStartPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        panelDragging = true
        panelDragStart = input.Position
        panelStartPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then panelDragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if panelDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - panelDragStart
        panel.Position = UDim2.new(panelStartPos.X.Scale, panelStartPos.X.Offset + d.X, panelStartPos.Y.Scale, panelStartPos.Y.Offset + d.Y)
    end
end)

local tabBar = Instance.new("Frame")
tabBar.BackgroundTransparency = 1
tabBar.Position = UDim2.fromOffset(12, 58)
tabBar.Size = UDim2.new(1, -24, 0, 34)
tabBar.Parent = panel
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabBar

local content = Instance.new("ScrollingFrame")
content.Name = "FeatureList"
content.Position = UDim2.fromOffset(12, 102)
content.Size = UDim2.new(1, -24, 1, -114)
content.BackgroundColor3 = COLORS.panel
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = COLORS.accent
content.CanvasSize = UDim2.new()
content.Parent = panel
corner(content, 10)
local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = content
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.fromOffset(0, list.AbsoluteContentSize.Y + 20)
end)

local state = {}
local callbacks = {}
local activeTab = "Combat"
local rows = {}

local function addToggle(name, category, callback, description)
    state[name] = false
    callbacks[name] = callback
    table.insert(rows, {name = name, category = category, description = description or "", callback = callback})
end

-- Working camera-side aim assist for your own experience.
-- It selects the closest visible character head inside the configured FOV.
local aimEnabled = false
local aimFov = 120
local aimSmoothness = 0.18
local aimNPCs = true
local aimPlayers = true
local aimConnection

local function isAlive(model)
    local hum = model and model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function isTargetAllowed(model)
    if not model or model == LocalPlayer.Character or not isAlive(model) then return false end
    local targetPlayer = Players:GetPlayerFromCharacter(model)
    if targetPlayer then return aimPlayers end
    return aimNPCs
end

local function getClosestHead()
    local camera = Workspace.CurrentCamera
    if not camera then return nil end
    local center = camera.ViewportSize / 2
    local bestHead, bestDistance = nil, aimFov
    local candidates = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then table.insert(candidates, player.Character) end
    end
    if aimNPCs then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                table.insert(candidates, obj)
            end
        end
    end
    for _, model in ipairs(candidates) do
        if isTargetAllowed(model) then
            local head = model:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                local point, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and point.Z > 0 then
                    local distance = (Vector2.new(point.X, point.Y) - center).Magnitude
                    if distance < bestDistance then
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        params.FilterDescendantsInstances = {LocalPlayer.Character}
                        local ray = Workspace:Raycast(camera.CFrame.Position, head.Position - camera.CFrame.Position, params)
                        if ray and ray.Instance and ray.Instance:IsDescendantOf(model) then
                            bestDistance, bestHead = distance, head
                        end
                    end
                end
            end
        end
    end
    return bestHead
end

addToggle("Head Aim Assist", "Combat", function(on)
    aimEnabled = on
    if aimConnection then aimConnection:Disconnect(); aimConnection = nil end
    if on then
        aimConnection = RunService.RenderStepped:Connect(function()
            local camera = Workspace.CurrentCamera
            local head = getClosestHead()
            if camera and head then
                local goal = CFrame.lookAt(camera.CFrame.Position, head.Position)
                camera.CFrame = camera.CFrame:Lerp(goal, math.clamp(aimSmoothness, 0.01, 1))
            end
        end)
    end
end, "Camera-side head tracking; works on player characters and NPCs.")
addToggle("Target Players", "Combat", function(on) aimPlayers = on end)
addToggle("Target NPCs", "Combat", function(on) aimNPCs = on end)
addToggle("Line Of Sight", "Combat", function(on) state["Line Of Sight"] = on end, "Visibility is checked by the aim-assist raycast.")
addToggle("FOV Ring", "Visuals", function(on) state["FOV Ring"] = on end, "Placeholder hook: add your preferred Drawing/UI circle implementation.")
addToggle("Head ESP", "Visuals", function(on) state["Head ESP"] = on end, "Placeholder hook: connect to your game's character highlighting system.")
addToggle("NPC ESP", "Visuals", function(on) state["NPC ESP"] = on end)
addToggle("Player ESP", "Visuals", function(on) state["Player ESP"] = on end)
addToggle("Show Target Name", "Visuals", function(on) state["Show Target Name"] = on end)
addToggle("Show Target Distance", "Visuals", function(on) state["Show Target Distance"] = on end)
addToggle("Team Check", "Combat", function(on) state["Team Check"] = on end)
addToggle("Aim Smoothing", "Combat", function(on) aimSmoothness = on and 0.18 or 1 end)
addToggle("Auto Target Switch", "Combat", function(on) state["Auto Target Switch"] = on end)
addToggle("Triggerbot Enabled", "Combat", function(on) state["Triggerbot Enabled"] = on end, "Integration hook only: connect this to your own weapon input/validated server fire event.")
addToggle("Auto Reload", "Combat", function(on) state["Auto Reload"] = on end, "Connect to your own weapon system.")
addToggle("Recoil Control", "Combat", function(on) state["Recoil Control"] = on end, "Connect to your own weapon camera/recoil code.")
addToggle("Spread Control", "Combat", function(on) state["Spread Control"] = on end, "Connect to your own weapon accuracy code.")
addToggle("Hitmarker", "Visuals", function(on) state["Hitmarker"] = on end)
addToggle("Damage Numbers", "Visuals", function(on) state["Damage Numbers"] = on end)
addToggle("Crosshair", "Visuals", function(on) state["Crosshair"] = on end)
addToggle("Custom Crosshair", "Visuals", function(on) state["Custom Crosshair"] = on end)
addToggle("Tracer Effects", "Visuals", function(on) state["Tracer Effects"] = on end)
addToggle("Impact Effects", "Visuals", function(on) state["Impact Effects"] = on end)
addToggle("Low Graphics", "World", function(on) state["Low Graphics"] = on end)
addToggle("Fullbright", "World", function(on) state["Fullbright"] = on end, "Connect to a reversible Lighting preset in your game.")
addToggle("No Fog", "World", function(on) state["No Fog"] = on end)
addToggle("World Color", "World", function(on) state["World Color"] = on end)
addToggle("Hide Particles", "World", function(on) state["Hide Particles"] = on end)
addToggle("Hide Shadows", "World", function(on) state["Hide Shadows"] = on end)
addToggle("Camera Shake Off", "World", function(on) state["Camera Shake Off"] = on end)
addToggle("Field Of View", "Player", function(on) state["Field Of View"] = on end)
addToggle("Sprint Mode", "Player", function(on) state["Sprint Mode"] = on end, "Connect to your game's movement controller.")
addToggle("Slide Mode", "Player", function(on) state["Slide Mode"] = on end)
addToggle("Double Jump", "Player", function(on) state["Double Jump"] = on end)
addToggle("Dash", "Player", function(on) state["Dash"] = on end)
addToggle("Wall Jump", "Player", function(on) state["Wall Jump"] = on end)
addToggle("Air Control", "Player", function(on) state["Air Control"] = on end)
addToggle("Footstep Effects", "Player", function(on) state["Footstep Effects"] = on end)
addToggle("Movement Trails", "Visuals", function(on) state["Movement Trails"] = on end)
addToggle("Safe Respawn", "Player", function(on) state["Safe Respawn"] = on end)
addToggle("Spawn Effects", "Player", function(on) state["Spawn Effects"] = on end)
addToggle("Spectate Target", "Player", function(on) state["Spectate Target"] = on end)
addToggle("Free Camera", "Player", function(on) state["Free Camera"] = on end)
addToggle("Camera Follow", "Player", function(on) state["Camera Follow"] = on end)
addToggle("Third Person", "Player", function(on) state["Third Person"] = on end)
addToggle("First Person", "Player", function(on) state["First Person"] = on end)
addToggle("UI Sounds", "Settings", function(on) state["UI Sounds"] = on end)
addToggle("Notifications", "Settings", function(on) state["Notifications"] = on end)
addToggle("Compact Menu", "Settings", function(on) state["Compact Menu"] = on end)
addToggle("Remember Settings", "Settings", function(on) state["Remember Settings"] = on end, "Persistence requires a server DataStore implementation.")
addToggle("Streamer Mode", "Settings", function(on) state["Streamer Mode"] = on end)
addToggle("Performance Stats", "Settings", function(on) state["Performance Stats"] = on end)
addToggle("Debug Overlay", "Settings", function(on) state["Debug Overlay"] = on end)
addToggle("Menu Blur", "Settings", function(on) state["Menu Blur"] = on end)
addToggle("Menu Animations", "Settings", function(on) state["Menu Animations"] = on end)
addToggle("Color Theme", "Settings", function(on) state["Color Theme"] = on end)
addToggle("Reset Menu Position", "Settings", function(on)
    if on then launcher.Position = UDim2.new(0, 24, 0.5, -27); state["Reset Menu Position"] = false end
end)

local function clearRows()
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function renderTab(tab)
    activeTab = tab
    clearRows()
    for _, item in ipairs(rows) do
        if item.category == tab then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -2, 0, item.description ~= "" and 58 or 42)
            row.BackgroundColor3 = COLORS.panel2
            row.Parent = content
            corner(row, 8)
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Position = UDim2.fromOffset(10, 3)
            label.Size = UDim2.new(1, -90, 0, 22)
            label.Font = Enum.Font.GothamSemibold
            label.Text = item.name
            label.TextColor3 = COLORS.text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row
            if item.description ~= "" then
                local desc = Instance.new("TextLabel")
                desc.BackgroundTransparency = 1
                desc.Position = UDim2.fromOffset(10, 25)
                desc.Size = UDim2.new(1, -20, 0, 27)
                desc.Font = Enum.Font.Gotham
                desc.Text = item.description
                desc.TextColor3 = COLORS.muted
                desc.TextSize = 10
                desc.TextWrapped = true
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.TextYAlignment = Enum.TextYAlignment.Top
                desc.Parent = row
            end
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.fromOffset(54, 25)
            toggle.Position = UDim2.new(1, -64, 0, 8)
            toggle.BackgroundColor3 = state[item.name] and COLORS.on or COLORS.off
            toggle.Text = state[item.name] and "ON" or "OFF"
            toggle.TextColor3 = COLORS.text
            toggle.TextSize = 10
            toggle.Font = Enum.Font.GothamBold
            toggle.Parent = row
            corner(toggle, 7)
            toggle.Activated:Connect(function()
                state[item.name] = not state[item.name]
                toggle.Text = state[item.name] and "ON" or "OFF"
                toggle.BackgroundColor3 = state[item.name] and COLORS.on or COLORS.off
                if item.callback then item.callback(state[item.name]) end
            end)
        end
    end
end

local categories = {"Combat", "Visuals", "Player", "World", "Settings"}
for _, category in ipairs(categories) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.fromOffset(76, 30)
    tab.BackgroundColor3 = category == activeTab and COLORS.on or COLORS.panel2
    tab.Text = category
    tab.TextColor3 = COLORS.text
    tab.TextSize = 10
    tab.Font = Enum.Font.GothamSemibold
    tab.Parent = tabBar
    corner(tab, 7)
    tab.Activated:Connect(function()
        for _, sibling in ipairs(tabBar:GetChildren()) do
            if sibling:IsA("TextButton") then sibling.BackgroundColor3 = COLORS.panel2 end
        end
        tab.BackgroundColor3 = COLORS.on
        renderTab(category)
    end)
end

renderTab(activeTab)
launcher.Activated:Connect(function()
    if moved then return end
    panel.Visible = not panel.Visible
end)
close.Activated:Connect(function() panel.Visible = false end)

print("Quantum-inspired menu loaded. Review integration notes before using gameplay hooks.")
