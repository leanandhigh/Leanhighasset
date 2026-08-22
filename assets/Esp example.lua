local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()

local Config = ESP.Table

Config['Enabled'] = true
Config['Distance'] = 500

-- Boxes
Config['Boxes']['Enabled'] = true
Config['Boxes']['Gradients']['Top'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Gradients']['Bot'] = Color3.fromRGB(0, 255, 255)

Config['Boxes']['Bounding Box']['Enabled'] = true
Config['Boxes']['Bounding Box']['BoxY'] = 6
Config['Boxes']['Bounding Box']['BoxX'] = 2

Config['Boxes']['Box Glow']['Enabled'] = true
Config['Boxes']['Box Glow']['Top'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Box Glow']['Bot'] = Color3.fromRGB(0, 255, 255)
Config['Boxes']['Box Glow']['Transparency'] = {0.9, 0.9}

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

-- Text
Config['Texts']['Name']['Enabled'] = true
Config['Texts']['Name']['Color'] = Color3.fromRGB(0, 255, 255)

Config['Texts']['Distance']['Enabled'] = true
Config['Texts']['Distance']['Color'] = Color3.fromRGB(0, 255, 255)

Config['Texts']['Weapon']['Enabled'] = true
Config['Texts']['Weapon']['Color'] = Color3.fromRGB(0, 255, 255)

--unload example
--[[ 
	local InputService = game:GetService("UserInputService")

	InputService.InputBegan:Connect(function(Input, Processed)
		if not Processed and Input.KeyCode == Enum.KeyCode.Delete then
			ESP:Unload()
		end
	end) ]]
