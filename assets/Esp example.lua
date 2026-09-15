--[[
	ESP Example — full optional hooks (BloxStrike / Workspace.Characters)
]]

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()
-- local ESP = loadstring(readfile("Esp.lua"))()
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
-- Body parts (R15 shells under Workspace.Characters)
----------------------------------------------------------------
Config.CustomGetBodyParts = function(Character)
	if not Character then return {} end
	local Names = {
		Head = true, UpperTorso = true, LowerTorso = true,
		LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
		RightUpperArm = true, RightLowerArm = true, RightHand = true,
		LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
		RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
	}
	local Parts = {}
	for _, Obj in Character:GetChildren() do
		if Names[Obj.Name] and Obj:IsA("BasePart") and Obj.Transparency < 1 then
			Parts[#Parts + 1] = Obj
		end
	end
	if #Parts == 0 then
		for _, Obj in Character:GetDescendants() do
			if Names[Obj.Name] and Obj:IsA("BasePart") and Obj.Transparency < 1 then
				Parts[#Parts + 1] = Obj
			end
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
}

----------------------------------------------------------------
-- Full optional CustomData (overrides core defaults)
----------------------------------------------------------------
Config.CustomData = Config.CustomData or {}

Config.CustomData.GetCharacter = function(Player)
	if not Player then return nil end
	local folder = workspace:FindFirstChild("Characters")
	if folder then
		local m = folder:FindFirstChild(Player.Name)
			or folder:FindFirstChild(tostring(Player.UserId))
		if not m and Player.DisplayName then
			m = folder:FindFirstChild(Player.DisplayName)
		end
		if m and m:IsA("Model") and m.Parent then
			return m
		end
	end
	local pc = Player.Character
	if pc and pc.Parent and pc:GetAttribute("CharacterType") == "PlayerCustomCharacter" then
		return pc
	end
	return pc
end

Config.CustomData.GetHealth = function(Player, Character)
	if not Character then return 0, 100 end
	local h = Character:GetAttribute("Health")
	local m = Character:GetAttribute("MaxHealth")
	if typeof(h) == "number" then
		return h, (typeof(m) == "number" and m > 0 and m) or 100
	end
	local hum = Character:FindFirstChildOfClass("Humanoid")
	if hum then
		return hum.Health, hum.MaxHealth
	end
	return 0, 100
end

Config.CustomData.GetArmor = function(Player, Character)
	local raw = Player and Player:GetAttribute("Armor")
	if typeof(raw) == "string" and raw ~= "" then
		local ok, data = pcall(function()
			return game:GetService("HttpService"):JSONDecode(raw)
		end)
		if ok and type(data) == "table" then
			return tonumber(data.Health) or 0, 100
		end
	elseif typeof(raw) == "number" then
		return raw, 100
	end
	return 0, 100
end

Config.CustomData.GetWeapon = function(Player, Character)
	local raw = Player and Player:GetAttribute("CurrentEquipped")
	if typeof(raw) == "string" and raw ~= "" then
		local ok, data = pcall(function()
			return game:GetService("HttpService"):JSONDecode(raw)
		end)
		if ok and type(data) == "table" and typeof(data.Name) == "string" then
			return data.Name
		end
	end
	if Character then
		local w = Character:FindFirstChild("CurrentWeapon")
		if w then return w.Value end
		local attr = Character:GetAttribute("CurrentWeapon")
		if attr then return attr end
	end
	return "none"
end

Config.CustomData.GetFlags = function(Player, Character)
	local flags = {
		Walking = false,
		Jumping = false,
		Sprinting = false,
		Crouching = false,
		Flying = false,
		Swimming = false,
		Climbing = false,
		Falling = false,
		Ragdoll = false,
		Dead = false,
	}
	if not Character then return flags end

	flags.Dead = Character:GetAttribute("Dead") == true
		or (typeof(Character:GetAttribute("Health")) == "number" and Character:GetAttribute("Health") <= 0)
	flags.Sprinting = Character:GetAttribute("Sprinting") == true
	flags.Crouching = Character:GetAttribute("Crouching") == true

	local hum = Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local stateName = ""
		pcall(function() stateName = hum:GetState().Name end)
		local moving = hum.MoveDirection and hum.MoveDirection.Magnitude > 0.08
		flags.Walking = moving and stateName ~= "Jumping" and stateName ~= "Freefall"
		flags.Jumping = stateName == "Jumping" or stateName == "Freefall"
		flags.Flying = stateName == "Flying" or Character:GetAttribute("Flying") == true
		flags.Swimming = stateName == "Swimming"
		flags.Climbing = stateName == "Climbing"
		flags.Falling = stateName == "FallingDown"
		flags.Ragdoll = stateName == "Physics" or stateName == "Ragdoll"
	end
	return flags
end

-- ESP:Unload()
