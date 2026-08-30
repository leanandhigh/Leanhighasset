local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()
local Config = ESP.Table

Config['Enabled'] = true
Config['Distance'] = 500

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

Config['Bars']['Health Bar']['Enabled'] = true
Config['Bars']['Health Bar']['ShowText'] = true
Config['Bars']['Health Bar']['Top'] = Color3.fromRGB(0, 255, 0)
Config['Bars']['Health Bar']['Mid'] = Color3.fromRGB(255, 255, 0)
Config['Bars']['Health Bar']['Bot'] = Color3.fromRGB(255, 0, 0)

Config['Bars']['Armor Bar']['Enabled'] = true
Config['Bars']['Armor Bar']['Top'] = Color3.fromRGB(255, 255, 255)
Config['Bars']['Armor Bar']['Mid'] = Color3.fromRGB(220, 220, 220)
Config['Bars']['Armor Bar']['Bot'] = Color3.fromRGB(180, 180, 180)

Config['Texts']['Name']['Enabled'] = true
Config['Texts']['Name']['Color'] = Color3.fromRGB(0, 255, 255)
Config['Texts']['Name']['Type'] = 'DisplayName'

Config['Texts']['Distance']['Enabled'] = true
Config['Texts']['Distance']['Color'] = Color3.fromRGB(0, 255, 255)

Config['Texts']['Weapon']['Enabled'] = true
Config['Texts']['Weapon']['Color'] = Color3.fromRGB(0, 255, 255)

Config['Flags']['Enabled'] = true
Config['Flags']['List']['Walking']['Enabled'] = true
Config['Flags']['List']['Walking']['Text'] = 'Walking'
Config['Flags']['List']['Walking']['Color'] = Color3.fromRGB(255, 80, 80)

Config['Flags']['List']['Jumping']['Enabled'] = true
Config['Flags']['List']['Jumping']['Text'] = 'Jumping'
Config['Flags']['List']['Jumping']['Color'] = Color3.fromRGB(255, 180, 50)

Config['Chams']['Enabled'] = true
Config['Chams']['FillColor'] = Color3.fromRGB(0, 255, 255)
Config['Chams']['OutlineColor'] = Color3.fromRGB(0, 0, 0)
Config['Chams']['FillTransparency'] = 0.61
Config['Chams']['OutlineTransparency'] = 0.21
Config['Chams']['Shading'] = Enum.AdornShading.Default
Config['Chams']['ShadingOutline'] = Enum.AdornShading.Default

Config['OOV']['Enabled'] = true
Config['OOV']['Color'] = Color3.fromRGB(0, 255, 255)
Config['OOV']['Size'] = 18
Config['OOV']['DynamicSize'] = true
Config['OOV']['MinSize'] = 12
Config['OOV']['MaxSize'] = 22
Config['OOV']['Radius'] = 0.35
Config['OOV']['DynamicRadius'] = true
Config['OOV']['MinRadius'] = 0.18
Config['OOV']['MaxRadius'] = 0.42
Config['OOV']['Limit'] = 20
Config['OOV']['ShowName'] = true
Config['OOV']['ShowDistance'] = true
Config['OOV']['ShowWeapon'] = true
Config['OOV']['ShowHealth'] = true
Config['OOV']['ShowHealthText'] = true
Config['OOV']['Blink'] = false
Config['OOV']['BlinkSpeed'] = 4

Config['Skeleton']['Enabled'] = true
Config['Skeleton']['Color'] = Color3.fromRGB(255, 255, 255)
Config['Skeleton']['Thickness'] = 1.5
Config['Skeleton']['Transparency'] = 0
