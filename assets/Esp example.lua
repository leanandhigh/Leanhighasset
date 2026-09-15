--[[
	ESP Example — custom models (Workspace.Characters)
	Core: Esp.lua  (updated with CustomData.GetCharacter)

	Usage:
	  1) load the core
	  2) set Config (visuals)
	  3) set Config.CustomData.GetCharacter  ← most important for custom models
	  4) optional: GetHealth / GetArmor / GetWeapon / GetFlags / CustomGetBodyParts
]]

local ESP = loadstring(readfile("Esp.lua"))()  -- or HttpGet your hosted Esp.lua
-- local ESP = loadstring(game:HttpGet("YOUR_URL/Esp.lua"))()

local Config = ESP.Table

----------------------------------------------------------------
-- Visuals
----------------------------------------------------------------
Config.Enabled = true
Config.Distance = 500

Config.Boxes.Enabled = true
Config.Boxes["Bounding Box"].Enabled = true
Config.Boxes["Bounding Box"].IncludeAcsessories = false
Config.Boxes["Bounding Box"].BoxX = 2
Config.Boxes["Bounding Box"].BoxY = 6
Config.Boxes["Box Glow"].Enabled = true
Config.Boxes["Box Glow"].Top = Color3.fromRGB(0, 255, 255)
Config.Boxes["Box Glow"].Bot = Color3.fromRGB(0, 255, 255)
Config.Boxes["Box Glow"].Transparency = {0.9, 0.9}
Config.Boxes.Gradients.Top = Color3.fromRGB(0, 255, 255)
Config.Boxes.Gradients.Bot = Color3.fromRGB(0, 255, 255)
Config.Boxes.Filled.Enabled = true
Config.Boxes.Filled.Top = Color3.fromRGB(0, 255, 255)
Config.Boxes.Filled.Bot = Color3.fromRGB(0, 255, 255)
Config.Boxes.Filled.Transparency = {1, 0.75}

Config.Bars["Health Bar"].Enabled = true
Config.Bars["Health Bar"].ShowText = true
Config.Bars["Health Bar"].Top = Color3.fromRGB(0, 255, 0)
Config.Bars["Health Bar"].Mid = Color3.fromRGB(255, 255, 0)
Config.Bars["Health Bar"].Bot = Color3.fromRGB(255, 0, 0)
Config.Bars["Armor Bar"].Enabled = true
Config.Bars["Armor Bar"].Top = Color3.fromRGB(255, 255, 255)
Config.Bars["Armor Bar"].Mid = Color3.fromRGB(220, 220, 220)
Config.Bars["Armor Bar"].Bot = Color3.fromRGB(180, 180, 180)

Config.Texts.Name.Enabled = true
Config.Texts.Name.Color = Color3.fromRGB(0, 255, 255)
Config.Texts.Name.Type = "DisplayName"
Config.Texts.Distance.Enabled = true
Config.Texts.Distance.Color = Color3.fromRGB(0, 255, 255)
Config.Texts.Weapon.Enabled = true
Config.Texts.Weapon.Color = Color3.fromRGB(0, 255, 255)

Config.Flags.Enabled = true
Config.Flags.List = {
	Walking   = { Text = "Walking",   Color = Color3.fromRGB(255, 80, 80) },
	Jumping   = { Text = "Jumping",   Color = Color3.fromRGB(255, 180, 50) },
	Sprinting = { Text = "Sprinting", Color = Color3.fromRGB(0, 255, 255) },
	Crouching = { Text = "Crouching", Color = Color3.fromRGB(255, 255, 0) },
	Flying    = { Text = "Flying",    Color = Color3.fromRGB(255, 0, 255) },
	Swimming  = { Text = "Swimming",  Color = Color3.fromRGB(0, 100, 255) },
	Climbing  = { Text = "Climbing",  Color = Color3.fromRGB(255, 165, 0) },
	Falling   = { Text = "Falling",   Color = Color3.fromRGB(255, 0, 0) },
	Ragdoll   = { Text = "Ragdoll",   Color = Color3.fromRGB(128, 128, 128) },
	Dead      = { Text = "Dead",      Color = Color3.fromRGB(0, 0, 0) },
}

Config.Chams.Enabled = true
Config.Chams.FillColor = Color3.fromRGB(0, 255, 255)
Config.Chams.OutlineColor = Color3.fromRGB(0, 0, 0)
Config.Chams.FillTransparency = 0.61
Config.Chams.OutlineTransparency = 0.21

Config.OOV.Enabled = true
Config.OOV.Color = Color3.fromRGB(0, 255, 255)
Config.OOV.Limit = 20
Config.OOV.ShowName = true
Config.OOV.ShowDistance = true
Config.OOV.ShowWeapon = true

Config.Skeleton.Enabled = true
Config.Skeleton.Color = Color3.fromRGB(255, 255, 255)
Config.Skeleton.Thickness = 1.5

----------------------------------------------------------------
-- CUSTOM MODEL  (BloxStrike / similar)
-- Models live under Workspace.Characters
-- Named by UserId or Player.Name
-- Deleted on death, re-created on respawn
--
-- Core already:
--   • watches Characters.ChildAdded / ChildRemoved
--   • resolves UserId → Name → DisplayName → Player.Character
-- Override GetCharacter only if your path differs.
----------------------------------------------------------------
Config.CustomData.GetCharacter = function(Player)
	if not Player then return nil end
	local folder = workspace:FindFirstChild("Characters")
	if folder then
		local m = folder:FindFirstChild(tostring(Player.UserId))
			or folder:FindFirstChild(Player.Name)
		if not m and Player.DisplayName then
			m = folder:FindFirstChild(Player.DisplayName)
		end
		if m and m:IsA("Model") and m.Parent then
			return m
		end
	end
	-- fallback default character
	return Player.Character
end

Config.CustomGetBodyParts = function(Character)
	if not Character then return {} end
	local Parts = {}
	for _, Obj in Character:GetDescendants() do
		if Obj:IsA("BasePart")
			and Obj.Transparency < 1
			and not Obj:FindFirstAncestorOfClass("Accessory")
			and not Obj:FindFirstAncestorOfClass("Tool")
			and Obj.Name ~= "HumanoidRootPart"
			and Obj.Name ~= "Handle"
		then
			Parts[#Parts + 1] = Obj
		end
	end
	return Parts
end

Config.CustomSkeletonJoints = {
	{"Head", "UpperTorso"},
	{"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"},
	{"LeftUpperArm", "LeftLowerArm"},
	{"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "RightUpperArm"},
	{"RightUpperArm", "RightLowerArm"},
	{"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"},
	{"LeftUpperLeg", "LeftLowerLeg"},
	{"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"},
	{"RightUpperLeg", "RightLowerLeg"},
	{"RightLowerLeg", "RightFoot"},
	{"Head", "Torso"},
	{"Torso", "Left Arm"},
	{"Torso", "Right Arm"},
	{"Torso", "Left Leg"},
	{"Torso", "Right Leg"},
}

Config.CustomData.GetHealth = function(Player, Character)
	local hum = Character and Character:FindFirstChildOfClass("Humanoid")
	if hum then return hum.Health, hum.MaxHealth end
	local h = Character and Character:FindFirstChild("Health")
	local m = Character and Character:FindFirstChild("MaxHealth")
	return (h and h.Value or 0), (m and m.Value or 100)
end

Config.CustomData.GetArmor = function(Player, Character)
	local a = Character and Character:FindFirstChild("Armor")
	local m = Character and Character:FindFirstChild("MaxArmor")
	return (a and a.Value or 0), (m and m.Value or 100)
end

Config.CustomData.GetWeapon = function(Player, Character)
	if not Character then return "none" end
	local w = Character:FindFirstChild("CurrentWeapon")
	if w then return w.Value end
	return Character:GetAttribute("CurrentWeapon") or "none"
end

Config.CustomData.GetFlags = function(Player, Character)
	local flags = {}
	for name in pairs(Config.Flags.List) do
		flags[name] = false
	end
	if not Character then return flags end
	local hum = Character:FindFirstChildOfClass("Humanoid")
	if not hum then return flags end
	local stateName = ""
	pcall(function() stateName = hum:GetState().Name end)
	local moving = hum.MoveDirection and hum.MoveDirection.Magnitude > 0.08
	flags.Walking   = moving and stateName ~= "Jumping" and stateName ~= "Freefall"
	flags.Jumping   = stateName == "Jumping" or stateName == "Freefall"
	flags.Sprinting = Character:GetAttribute("Sprinting") == true
	flags.Crouching = (hum.CameraOffset and hum.CameraOffset.Y < -0.5) or Character:GetAttribute("Crouching") == true
	flags.Flying    = stateName == "Flying" or Character:GetAttribute("Flying") == true
	flags.Swimming  = stateName == "Swimming"
	flags.Climbing  = stateName == "Climbing"
	flags.Falling   = stateName == "FallingDown"
	flags.Ragdoll   = stateName == "Physics" or stateName == "Ragdoll"
	flags.Dead      = hum.Health <= 0
	return flags
end

-- ESP:Unload()
