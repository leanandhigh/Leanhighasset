local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Drawing%20esp.lua"))()
local Config = ESP.Table

Config.Enabled = true
Config.Distance = 500

Config.Boxes.Enabled = true
Config.Boxes["Bounding Box"].Enabled = true
Config.Boxes["Bounding Box"].IncludeAcsessories = false
Config.Boxes["Bounding Box"].BoxX = 0
Config.Boxes["Bounding Box"].BoxY = 0

Config.Boxes.Filled.Enabled = true
Config.Boxes.Filled.Top = Color3.fromRGB(0, 255, 255)
Config.Boxes.Filled.Bot = Color3.fromRGB(0, 120, 255)
Config.Boxes.Filled.Transparency = {0.85, 0.85}

Config.Bars["Health Bar"].Enabled = false
Config.Bars["Health Bar"].ShowText = false
Config.Bars["Health Bar"].Top = Color3.fromRGB(0, 255, 0)
Config.Bars["Health Bar"].Mid = Color3.fromRGB(255, 255, 0)
Config.Bars["Health Bar"].Bot = Color3.fromRGB(255, 0, 0)

Config.Bars["Armor Bar"].Enabled = false
Config.Bars["Armor Bar"].Top = Color3.fromRGB(255, 255, 255)
Config.Bars["Armor Bar"].Mid = Color3.fromRGB(220, 220, 220)
Config.Bars["Armor Bar"].Bot = Color3.fromRGB(180, 180, 180)

Config.Texts.Name.Enabled = true
Config.Texts.Name.Color = Color3.fromRGB(255, 255, 255)
Config.Texts.Name.Type = "Name"

Config.Texts.Distance.Enabled = true
Config.Texts.Distance.Color = Color3.fromRGB(180, 180, 180)

Config.Texts.Weapon.Enabled = true
Config.Texts.Weapon.Color = Color3.fromRGB(255, 200, 100)

Config.Flags.Enabled = true
Config.Flags.List.Walking = {
	Enabled = true,
	Text = "Walking",
	Color = Color3.fromRGB(255, 255, 255),
}
Config.Flags.List.Jumping = {
	Enabled = true,
	Text = "Jumping",
	Color = Color3.fromRGB(255, 200, 50),
}
Config.Flags.List.Running = {
	Enabled = true,
	Text = "Running",
	Color = Color3.fromRGB(100, 200, 255),
}
Config.Flags.List.Ragdoll = {
	Enabled = true,
	Text = "Ragdoll",
	Color = Color3.fromRGB(128, 128, 128),
}
Config.Flags.List.Dead = {
	Enabled = true,
	Text = "Dead",
	Color = Color3.fromRGB(255, 50, 50),
}

Config.Chams.Enabled = true
Config.Chams.FillColor = Color3.fromRGB(0, 255, 255)
Config.Chams.OutlineColor = Color3.fromRGB(0, 0, 0)
Config.Chams.FillTransparency = 0.61

Config.Chams.OutlineTransparency = 0.21

Config.OOV.Enabled = true
Config.OOV.Color = Color3.fromRGB(0, 255, 255)
Config.OOV.Size = 18
Config.OOV.Radius = 0.35
Config.OOV.Limit = 6
Config.OOV.ShowName = true
Config.OOV.ShowDistance = true
Config.OOV.ShowWeapon = true
Config.OOV.ShowHealth = false
Config.OOV.ShowHealthText = false
Config.OOV.Blink = false
Config.OOV.BlinkSpeed = 4

Config.Skeleton.Enabled = false
Config.Skeleton.Color = Color3.fromRGB(255, 255, 255)
Config.Skeleton.Thickness = 1.5
Config.Skeleton.Transparency = 0

Config.CustomData.GetHealth = function(Player, Character)
	local hum = Character and Character:FindFirstChildOfClass("Humanoid")
	if not hum then return 0, 100 end
	return hum.Health, hum.MaxHealth
end

Config.CustomData.GetWeapon = function(Player, Character)
	if not Character then return "none" end
	local eq = Character:FindFirstChild("Equipped")
	if eq then
		local m = eq:FindFirstChildOfClass("Model") or eq:FindFirstChildOfClass("Tool")
		if m then return m.Name end
	end
	local tool = Character:FindFirstChildOfClass("Tool")
	return tool and tool.Name or "none"
end

Config.CustomData.GetFlags = function(Player, Character)
	local hum = Character and Character:FindFirstChildOfClass("Humanoid")
	local stateName = ""
	if hum then
		pcall(function() stateName = hum:GetState().Name end)
	end
	return {
		Walking = hum and hum.MoveDirection.Magnitude > 0.08 and stateName ~= "Jumping" and stateName ~= "Freefall",
		Jumping = stateName == "Jumping" or stateName == "Freefall",
		Running = hum and hum.MoveDirection.Magnitude > 0.08 and (hum.WalkSpeed or 16) > 18,
		Ragdoll = stateName == "Physics" or stateName == "Ragdoll",
		Dead = hum and hum.Health <= 0,
	}
end

-- ESP:Unload()
