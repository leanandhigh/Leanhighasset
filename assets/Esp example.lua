local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()
local Config = ESP.Table

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
Config.Chams.Shading = Enum.AdornShading.Default
Config.Chams.ShadingOutline = Enum.AdornShading.Default

Config.OOV.Enabled = true
Config.OOV.Color = Color3.fromRGB(0, 255, 255)
Config.OOV.NameColor = Color3.fromRGB(255, 255, 255)
Config.OOV.DistanceColor = Color3.fromRGB(180, 180, 180)
Config.OOV.WeaponColor = Color3.fromRGB(255, 200, 100)
Config.OOV.Size = 18
Config.OOV.DynamicSize = true
Config.OOV.MinSize = 12
Config.OOV.MaxSize = 22
Config.OOV.Radius = 0.35
Config.OOV.DynamicRadius = true
Config.OOV.MinRadius = 0.18
Config.OOV.MaxRadius = 0.42
Config.OOV.Limit = 20
Config.OOV.ShowName = true
Config.OOV.ShowDistance = true
Config.OOV.ShowWeapon = true
Config.OOV.ShowHealth = true
Config.OOV.ShowHealthText = true
Config.OOV.Blink = false
Config.OOV.BlinkSpeed = 4

Config.Skeleton.Enabled = true
Config.Skeleton.Color = Color3.fromRGB(255, 255, 255)
Config.Skeleton.Thickness = 1.5
Config.Skeleton.Transparency = 0

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
	if hum then
		return hum.Health, hum.MaxHealth
	end
	local healthVal = Character and Character:FindFirstChild("Health")
	local maxHealthVal = Character and Character:FindFirstChild("MaxHealth")
	return (healthVal and healthVal.Value or 0), (maxHealthVal and maxHealthVal.Value or 100)
end

Config.CustomData.GetArmor = function(Player, Character)
	local armorVal = Character and Character:FindFirstChild("Armor")
	local maxArmorVal = Character and Character:FindFirstChild("MaxArmor")
	return (armorVal and armorVal.Value or 0), (maxArmorVal and maxArmorVal.Value or 100)
end

Config.CustomData.GetWeapon = function(Player, Character)
	if not Character then return "none" end
	local weaponVal = Character:FindFirstChild("CurrentWeapon")
	if weaponVal then return weaponVal.Value end
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

	local moveDir = hum.MoveDirection
	local moving = moveDir and moveDir.Magnitude > 0.08

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

--Esp:Unload()
