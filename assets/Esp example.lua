local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()
local Config = ESP.Table

-- Master
Config['Enabled'] = true
Config['Distance'] = 500

-- Boxes
Config['Boxes']['Enabled'] = true

Config['Boxes']['Bounding Box']['Enabled'] = true
Config['Boxes']['Bounding Box']['IncludeAcsessories'] = false
Config['Boxes']['Bounding Box']['BoxX'] = 2
Config['Boxes']['Bounding Box']['BoxY'] = 6

Config['Boxes']['Box Glow']['Enabled'] = true
Config['Boxes']['Box Glow']['Top'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Box Glow']['Bot'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Box Glow']['Transparency'] = {0.9, 0.9}

Config['Boxes']['Gradients']['Top'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Gradients']['Bot'] = Color3.fromRGB(0, 255, 255)

Config['Boxes']['Filled']['Enabled'] = true
Config['Boxes']['Filled']['Top'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Filled']['Bot'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Filled']['Transparency'] = {1, 0.75}

-- Bars
Config['Bars']['Health Bar']['Enabled'] = true
Config['Bars']['Health Bar']['Top'] = Color3.fromRGB(0, 255, 0)
Config['Bars']['Health Bar']['Mid'] = Color3.fromRGB(255, 255, 0)
Config['Bars']['Health Bar']['Bot'] = Color3.fromRGB(255, 0, 0)

Config['Bars']['Armor Bar']['Enabled'] = false
Config['Bars']['Armor Bar']['Top'] = Color3.fromRGB(255, 255, 255)
Config['Bars']['Armor Bar']['Mid'] = Color3.fromRGB(220, 220, 220)
Config['Bars']['Armor Bar']['Bot'] = Color3.fromRGB(180, 180, 180)

-- Texts
Config['Texts']['Name']['Enabled'] = true
Config['Texts']['Name']['Color'] = Color3.fromRGB(0, 255, 255)

Config['Texts']['Distance']['Enabled'] = true
Config['Texts']['Distance']['Color'] = Color3.fromRGB(0, 255, 255)

Config['Texts']['Weapon']['Enabled'] = true
Config['Texts']['Weapon']['Color'] = Color3.fromRGB(0, 255, 255)

-- Chams
Config['Chams']['Enabled'] = true
Config['Chams']['FillColor'] = Color3.fromRGB(0, 0, 0)
Config['Chams']['OutlineColor'] = Color3.fromRGB(255, 255, 255)
Config['Chams']['FillTransparency'] = 0
Config['Chams']['OutlineTransparency'] = 0
Config['Chams']['Shading'] = Enum.AdornShading.Default
Config['Chams']['ShadingOutline'] = Enum.AdornShading.Default

-- Unload example
-- ESP:Unload()
