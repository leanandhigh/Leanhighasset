local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local HatchEvent = ReplicatedStorage.Packages._Index["sleitnick_knit@1.5.1"].knit.Services.EggHatchService.RE.Hatch
local WinsEvent = ReplicatedStorage.Packages._Index["sleitnick_knit@1.5.1"].knit.Services.FightService.RE.GetWinsEvent

task.wait(1)

local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)

local function tryRequire(p)
    local ok, mod = pcall(require, p)
    if ok then return mod end
    return nil
end

local PDC = tryRequire(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local FC = tryRequire(StarterPlayer.StarterPlayerScripts.Controllers.FightController)
local AC = tryRequire(StarterPlayer.StarterPlayerScripts.Controllers.AutoController)
local AreaC = tryRequire(StarterPlayer.StarterPlayerScripts.Controllers.AreaController)
local TC = tryRequire(StarterPlayer.StarterPlayerScripts.Controllers.TrainController)

local disableHatchAnim = true
local rawGmt = getrawmetatable(game)
local oldNamecall = rawGmt.__namecall
local oldNewindex = rawGmt.__newindex

setreadonly(rawGmt, false)

rawGmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if disableHatchAnim and (method == "Fire" or method == "FireServer") and tostring(self) == "Hatch" then
        if self ~= HatchEvent then
            return nil
        end
    end
    return oldNamecall(self, ...)
end)

--------------------------------------------------------------------------------
-- CREATE SCRIPT GUI & MAKE IT UNDESTROYABLE / UNWIPEABLE
--------------------------------------------------------------------------------
local sg = Instance.new("ScreenGui")
sg.Name = "InstantFinishGui"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999999999
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = PlayerGui

-- Intercept game attempts to alter/destroy our ScreenGui
rawGmt.__newindex = newcclosure(function(self, prop, value)
    if self == sg and (prop == "Parent" or prop == "Enabled") then
        if prop == "Parent" and value ~= PlayerGui then
            return nil
        elseif prop == "Enabled" and value == false then
            return nil
        end
    end
    return oldNewindex(self, prop, value)
end)

setreadonly(rawGmt, true)

-- Continuous Ancestry Protection Backup
sg.AncestryChanged:Connect(function(_, parent)
    if parent ~= PlayerGui then
        task.defer(function()
            sg.Parent = PlayerGui
        end)
    end
end)

-- Mobile Screen Button: Toggle Entire UI
local mobileOpenBtn = Instance.new("TextButton")
mobileOpenBtn.Name = "MobileToggleBtn"
mobileOpenBtn.Size = UDim2.new(0, 90, 0, 36)
mobileOpenBtn.Position = UDim2.new(0, 10, 0, 10)
mobileOpenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mobileOpenBtn.Text = "Toggle UI"
mobileOpenBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
mobileOpenBtn.TextSize = 13
mobileOpenBtn.Font = Enum.Font.GothamBold
mobileOpenBtn.ZIndex = 1000
mobileOpenBtn.Parent = sg

local mobCorner = Instance.new("UICorner")
mobCorner.CornerRadius = UDim.new(0, 6)
mobCorner.Parent = mobileOpenBtn

-- Mobile Screen Button: Dedicated Quick Auto-Hatch Button
local mobileHatchBtn = Instance.new("TextButton")
mobileHatchBtn.Name = "MobileHatchBtn"
mobileHatchBtn.Size = UDim2.new(0, 120, 0, 36)
mobileHatchBtn.Position = UDim2.new(0, 105, 0, 10)
mobileHatchBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
mobileHatchBtn.Text = "Auto Hatch: OFF"
mobileHatchBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
mobileHatchBtn.TextSize = 12
mobileHatchBtn.Font = Enum.Font.GothamBold
mobileHatchBtn.ZIndex = 1000
mobileHatchBtn.Parent = sg

local hatchCorner = Instance.new("UICorner")
hatchCorner.CornerRadius = UDim.new(0, 6)
hatchCorner.Parent = mobileHatchBtn

-- Main GUI Panel Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 520)
frame.Position = UDim2.new(0.5, -150, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.08
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ZIndex = 100
frame.Parent = sg

local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(0, 10); uc.Parent = frame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 101
titleBar.Parent = frame
local tc2 = Instance.new("UICorner"); tc2.CornerRadius = UDim.new(0, 10); tc2.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Instant Finish - Horse Race"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.ZIndex = 102
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -27, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 102
closeBtn.Parent = titleBar
local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0, 4); cbc.Parent = closeBtn

local sf = Instance.new("ScrollingFrame")
sf.Size = UDim2.new(1, -10, 1, -37)
sf.Position = UDim2.new(0, 5, 0, 37)
sf.BackgroundTransparency = 1
sf.BorderSizePixel = 0
sf.ScrollBarThickness = 4
sf.CanvasSize = UDim2.new(0, 0, 0, 0)
sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
sf.ZIndex = 101
sf.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = sf

local function makeToggle(text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 34)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    f.BorderSizePixel = 0
    f.ZIndex = 102
    f.Parent = sf
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 5); fc.Parent = f
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.ZIndex = 103
    lbl.Parent = f
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 34, 0, 24)
    btn.Position = UDim2.new(1, -39, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 103
    btn.Parent = f
    local bnc = Instance.new("UICorner"); bnc.CornerRadius = UDim.new(0, 5); bnc.Parent = btn
    local enabled = false
    return btn, function() return enabled end, function(v)
        enabled = v
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 140, 40) or Color3.fromRGB(80, 80, 80)
        btn.Text = enabled and "ON" or "OFF"
        btn.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    end
end

local function makeHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 200, 255)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamBold
    lbl.ZIndex = 102
    lbl.Parent = sf
    return lbl
end

local function makeButton(text, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 102
    btn.Parent = sf
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 5); bc.Parent = btn
    btn.MouseButton1Click:Connect(cb)
    return btn
end

makeHeader("Eggs")
local autoHatch = false
local hb, gh, sh = makeToggle("Auto Hatch Christmas")

local function updateHatchState(state)
    autoHatch = state
    sh(autoHatch)
    mobileHatchBtn.BackgroundColor3 = autoHatch and Color3.fromRGB(0, 140, 40) or Color3.fromRGB(80, 80, 80)
    mobileHatchBtn.Text = autoHatch and "Auto Hatch: ON" or "Auto Hatch: OFF"
    mobileHatchBtn.TextColor3 = autoHatch and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
end

local function toggleHatch()
    updateHatchState(not autoHatch)
end

hb.MouseButton1Click:Connect(toggleHatch)
mobileHatchBtn.MouseButton1Click:Connect(toggleHatch)

makeHeader("Race")
local autoWins = false
local autoWinsDelay = 3
local wb, gw, swins = makeToggle("Auto Claim Wins")
wb.MouseButton1Click:Connect(function()
    autoWins = not autoWins
    swins(autoWins)
end)

makeHeader("Cooldowns")
makeButton("Give Max Strength", function()
    local data = PDC and PDC:GetData()
    if data then
        data.Strength = math.huge
        data.TotalStrength = math.huge
    end
end)

makeHeader("Movement")
local walkSpd = false
local wsb, gws, sws = makeToggle("WalkSpeed x5")
wsb.MouseButton1Click:Connect(function() walkSpd = not walkSpd; sws(walkSpd) end)

local jumpEn = false
local jb, gj, sj = makeToggle("Jump Power x10")
jb.MouseButton1Click:Connect(function() jumpEn = not jumpEn; sj(jumpEn) end)

makeHeader("Auto")
makeButton("Start Auto Train", function()
    if TC then
        local data = PDC and PDC:GetData()
        if data and data.Treadmills then
            for id, unlocked in pairs(data.Treadmills) do
                if unlocked then
                    TC:StartAutoTrain(id)
                    break
                end
            end
        end
    end
end)
makeButton("Stop Auto Train", function()
    if AC then AC:StopAutoTrain() end
end)
makeButton("Start Auto Fight", function()
    if AC and AreaC then
        local area = AreaC:GetCurrentArea()
        if area then AC:StartAutoFight(area) end
    end
end)
makeButton("Stop Auto Fight", function()
    if AC then AC:StopAutoFight() end
end)
makeButton("Stop Auto All", function()
    if AC then
        AC:StopAutoTrain()
        AC:StopAutoFight()
    end
end)

-- Minimize/Close handler
local minimized = false
local function toggleMinimize()
    minimized = not minimized
    sf.Visible = not minimized
    frame.Size = minimized and UDim2.new(0, 300, 0, 32) or UDim2.new(0, 300, 0, 520)
    frame.Position = minimized and UDim2.new(1, -310, 1, -42) or UDim2.new(0.5, -150, 0.5, -260)
    closeBtn.Text = minimized and "+" or "X"
end

closeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Toggle main frame visibility via top-left mobile button
mobileOpenBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- PC Keybindings retained
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        toggleHatch()
    elseif input.KeyCode == Enum.KeyCode.U then
        frame.Visible = not frame.Visible
    end
end)

-- Background Loops
task.spawn(function()
    while true do
        if autoHatch then
            pcall(function()
                HatchEvent:FireServer("Egg_Christmas", 1)
            end)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if autoWins then
            pcall(function()
                WinsEvent:FireServer("WinGate_15", Vector3.new(1830.6431884766, 781.37377929688, -459498.96875))
            end)
            task.wait(autoWinsDelay)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if walkSpd and hum then hum.WalkSpeed = 4000 end
        if jumpEn and hum then hum.JumpPower = 150 end
    end
end)