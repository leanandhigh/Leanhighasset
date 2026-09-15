--[[
	ESP Example — custom models (Workspace.Characters)
	Core: Esp.lua  (updated with CustomData.GetCharacter)

	Usage:
	  1) load the core
	  2) set Config (visuals)
	  3) set Config.CustomData.GetCharacter  ← most important for custom models
	  4) optional: GetHealth / GetArmor / GetWeapon / GetFlags / CustomGetBodyParts
]]

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()

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
-- ESP:Unload()
