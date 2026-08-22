local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ExistingHolder = CoreGui:FindFirstChild("ESPHolder")
if ExistingHolder then
	ExistingHolder:Destroy()
end

local ExistingOOVHolder = CoreGui:FindFirstChild("OovLabelHolder")
if ExistingOOVHolder then
	ExistingOOVHolder:Destroy()
end

local ESPHolder = Instance.new("ScreenGui")
ESPHolder.Name = "ESPHolder"
ESPHolder.IgnoreGuiInset = true
ESPHolder.ResetOnSpawn = false
ESPHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPHolder.Parent = CoreGui

local OOVHolder = Instance.new("ScreenGui")
OOVHolder.Name = "OovLabelHolder"
OOVHolder.IgnoreGuiInset = true
OOVHolder.ResetOnSpawn = false
OOVHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OOVHolder.Parent = CoreGui

local ChamsFolder = Instance.new("Folder")
ChamsFolder.Name = "Chams"
ChamsFolder.Parent = ESPHolder

Library._ESPHolder = ESPHolder

local function CreateClass(className, properties)
	local instance = typeof(className) == "string" and Instance.new(className) or className

	for property, value in pairs(properties) do
		instance[property] = value
	end

	return instance
end

local FontSystem = {}
FontSystem.__index = FontSystem

function FontSystem.new()
	local self = setmetatable({}, FontSystem)

	self.Folder = ((Library and Library.Folders and Library.Folders.Assets) or "Lean/Assets") .. "/AR2Fonts"
	self.BaseUrl = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/"
	self.Cache = {}
	self.Fallback = Font.fromEnum(Enum.Font.Gotham)
	self.Files = {
		["Windows-XP-Tahoma"] = { File = "windows-xp-tahoma.ttf", Weight = 400 },
		["Minecraft-Standard"] = { File = "MinecraftStandard.ttf", Weight = 400 },
		["Minecraftia"] = { File = "minecraftia.ttf", Weight = 400 },
		["Inter"] = { File = "Inter.ttf", Weight = 400 },
		["Inter-Bold"] = { File = "InterBold.ttf", Weight = 700 },
		["Inter-Medium"] = { File = "InterMedium.ttf", Weight = 500 },
		["Inter-SemiBold"] = { File = "InterSemibold.ttf", Weight = 600 },
		["Verdana"] = { File = "verdana.ttf", Weight = 400 },
		["Verdana-Bold"] = { File = "verdana-bold.ttf", Weight = 700 },
		["Tahoma"] = { File = "tahoma.ttf", Weight = 400 },
		["Tahoma-Bold"] = { File = "tahomabd.ttf", Weight = 700 },
		["Tahoma-8pt-Bold"] = { File = "TAHOMA-8PT-BOLD-WINDOWS-XP.TTF", Weight = 700 },
		["Monaco"] = { File = "Monaco.ttf", Weight = 400 },
		["Roboto-Mono"] = { File = "RobotoMono-Regular.ttf", Weight = 400 },
		["Reactor7"] = { File = "Reactor7.ttf", Weight = 400 },
		["Pixel-Operator"] = { File = "PixelOperator.ttf", Weight = 400 },
		["Poppins-Medium"] = { File = "Poppins-Medium.ttf", Weight = 500 },
		["Prompt-Regular"] = { File = "Prompt-Regular.ttf", Weight = 400 },
		["Prompt-Medium"] = { File = "Prompt-Medium.ttf", Weight = 500 },
		["Lato-Bold"] = { File = "Lato-Bold.ttf", Weight = 700 },
		["Open-Sans-PX"] = { File = "open-sans-px.ttf", Weight = 400 },
		["Lucida-Console"] = { File = "lucida-console.ttf", Weight = 400 },
		["Proggy-Clean"] = { File = "proggy-clean.ttf", Weight = 400 },
		["Proggy-Square"] = { File = "proggy-square.ttf", Weight = 400 },
		["Proggy-Tiny"] = { File = "proggy-tiny.ttf", Weight = 400 },
		["Smallest-Pixel"] = { File = "smallest_pixel-7.ttf", Weight = 400 },
		["Cozette-Vector"] = { File = "cozette-vector.ttf", Weight = 400 },
		["NDS12"] = { File = "NDS12.ttf", Weight = 400 },
		["SGK075"] = { File = "SGK075.ttf", Weight = 400 },
		["Basis33"] = { File = "basis33.ttf", Weight = 400 },
		["Outfit-Medium"] = { File = "Outfit-Medium.ttf", Weight = 500 },
		["Lexend-Medium"] = { File = "Lexend-Medium.ttf", Weight = 500 },
		["Comfortaa"] = { File = "Comfortaa-Regular.ttf", Weight = 400 }
	}

	pcall(function()
		if type(makefolder) == "function" then
			makefolder(self.Folder)
		end
	end)

	return self
end

function FontSystem:GetWeight(weight)
	if weight >= 700 then
		return Enum.FontWeight.Bold
	end

	if weight >= 600 then
		return Enum.FontWeight.SemiBold
	end

	if weight >= 500 then
		return Enum.FontWeight.Medium
	end

	return Enum.FontWeight.Regular
end

function FontSystem:Load(name)
	name = name or "Windows-XP-Tahoma"

	if self.Cache[name] then
		return self.Cache[name]
	end

	if name == "Default" then
		return self.Fallback
	end

	local info = self.Files[name]

	if not info or type(getcustomasset) ~= "function" or type(writefile) ~= "function" then
		return self.Fallback
	end

	local ttfPath = self.Folder .. "/" .. name .. ".ttf"
	local fontPath = self.Folder .. "/" .. name .. ".font"

	if type(isfile) ~= "function" or not isfile(ttfPath) then
		local ok, data = pcall(function()
			return game:HttpGet(self.BaseUrl .. info.File)
		end)

		if not ok or type(data) ~= "string" or #data < 100 then
			return self.Fallback
		end

		local wrote = pcall(writefile, ttfPath, data)

		if not wrote then
			return self.Fallback
		end
	end

	local assetOk, ttfAsset = pcall(getcustomasset, ttfPath)

	if not assetOk or not ttfAsset then
		return self.Fallback
	end

	pcall(function()
		if type(delfile) == "function" and type(isfile) == "function" and isfile(fontPath) then
			delfile(fontPath)
		end
	end)

	local definition = {
		name = name,
		faces = {
			{
				name = "Regular",
				weight = info.Weight,
				style = "normal",
				assetId = ttfAsset
			}
		}
	}

	local saved = pcall(writefile, fontPath, HttpService:JSONEncode(definition))

	if not saved then
		return self.Fallback
	end

	local fontAssetOk, fontAsset = pcall(getcustomasset, fontPath)

	if not fontAssetOk or not fontAsset then
		return self.Fallback
	end

	local fontOk, font = pcall(function()
		return Font.new(fontAsset, self:GetWeight(info.Weight), Enum.FontStyle.Normal)
	end)

	if not fontOk or not font then
		return self.Fallback
	end

	self.Cache[name] = font

	return font
end

function FontSystem:Apply(label, name)
	if not label then
		return
	end

	pcall(function()
		label.FontFace = self:Load(name)
	end)
end

local Adapter = {}

function Adapter:GetEntities()
	local entities = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(entities, player)
		end
	end

	return entities
end

function Adapter:GetCharacter(entity)
	return entity.Character
end

function Adapter:GetRootPart(entity, character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

function Adapter:GetHumanoid(entity, character)
	return character and character:FindFirstChildOfClass("Humanoid")
end

function Adapter:GetHealth(entity, character)
	local humanoid = self:GetHumanoid(entity, character)
	return humanoid and humanoid.Health or 0
end

function Adapter:GetMaxHealth(entity, character)
	local humanoid = self:GetHumanoid(entity, character)
	return humanoid and humanoid.MaxHealth or 100
end

function Adapter:IsAlive(entity, character)
	return self:GetHealth(entity, character) > 0
end

function Adapter:GetName(entity)
	return entity.Name
end

function Adapter:IsTeammate(entity)
	return entity.Team ~= nil and entity.Team == LocalPlayer.Team
end

function Adapter:GetWeapon(entity, character)
	if not character then
		return "None"
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") then
			return child.Name
		end

		if child:IsA("Model") and child.PrimaryPart then
			if child:FindFirstChild("Handle") or child:FindFirstChild("Main") or child:FindFirstChild("Attachments") then
				return child.Name
			end
		end
	end

	return "None"
end

function Adapter:GetChamsParts(entity, character)
	local parts = {}

	if not character then
		return parts
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
			table.insert(parts, child)
		end
	end

	return parts
end

function Adapter:HasForceField(entity, character)
	return character and character:FindFirstChildOfClass("ForceField", true) ~= nil
end

function Adapter:IsWalking(entity, character)
	local humanoid = self:GetHumanoid(entity, character)
	return humanoid and humanoid.MoveDirection.Magnitude > 0.05 or false
end

function Adapter:GetState(entity, character)
	local humanoid = self:GetHumanoid(entity, character)
	return humanoid and humanoid:GetState().Name or "Unknown"
end

function Adapter:IsVisible(entity, character, rootPart)
	if not rootPart then
		return false
	end

	local parameters = RaycastParams.new()
	parameters.FilterType = Enum.RaycastFilterType.Exclude
	parameters.FilterDescendantsInstances = { Camera, LocalPlayer.Character }

	local result = workspace:Raycast(
		Camera.CFrame.Position,
		rootPart.Position - Camera.CFrame.Position,
		parameters
	)

	return not result or result.Instance:IsDescendantOf(character)
end

local BaseESP = {}
BaseESP.__index = BaseESP

function BaseESP.new(config, adapter)
	local self = setmetatable({}, BaseESP)

	self.State = config
	self.Adapter = adapter
	self.Fonts = FontSystem.new()
	self.Entries = {}
	self.Chams = {}
	self.OOVEntries = {}
	self.VisibilityCache = {}
	self.Connection = RunService.RenderStepped:Connect(function(delta)
		self:Update(delta)
	end)

	return self
end

function BaseESP:GetSettings(entity)
	if self.Adapter:IsTeammate(entity) then
		return self.State.TeamESP, true
	end

	return self.State.ESP, false
end

function BaseESP:CreateLabel(parent, layoutOrder, alignment)
	local label = CreateClass("TextLabel", {
		Parent = parent,
		FontFace = Font.fromEnum(Enum.Font.Gotham),
		TextSize = 10,
		TextColor3 = Color3.new(1, 1, 1),
		TextStrokeColor3 = Color3.new(0, 0, 0),
		TextStrokeTransparency = 0,
		BackgroundTransparency = 1,
		RichText = true,
		Visible = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = layoutOrder or 0,
		TextXAlignment = alignment or Enum.TextXAlignment.Center,
		ZIndex = 5
	})

	CreateClass("UIStroke", {
		Parent = label,
		Color = Color3.new(0, 0, 0),
		Thickness = 1
	})

	return label
end

function BaseESP:CreateEntry(entity)
	local container = CreateClass("Frame", {
		Parent = ESPHolder,
		Name = tostring(entity),
		BackgroundTransparency = 1,
		Visible = false,
		Size = UDim2.fromOffset(0, 0)
	})

	local boxHolder = CreateClass("Frame", {
		Parent = container,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 0)
	})

	local outline = CreateClass("UIStroke", {
		Parent = boxHolder,
		Thickness = 3,
		Color = Color3.new(0, 0, 0),
		LineJoinMode = Enum.LineJoinMode.Miter
	})

	local inlineHolder = CreateClass("Frame", {
		Parent = boxHolder,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(-1, -1),
		Size = UDim2.fromOffset(0, 0)
	})

	local inline = CreateClass("UIStroke", {
		Parent = inlineHolder,
		Thickness = 1.4,
		Color = Color3.new(1, 1, 1),
		LineJoinMode = Enum.LineJoinMode.Miter
	})

	local boxGradient = CreateClass("UIGradient", {
		Parent = inline
	})

	local fill = CreateClass("Frame", {
		Parent = boxHolder,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1
	})

	local fillGradient = CreateClass("UIGradient", {
		Parent = fill,
		Rotation = 90
	})

	local topHolder = CreateClass("Frame", {
		Parent = container,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, -2, 0, -5),
		Size = UDim2.new(1, 4, 0, 0)
	})

	CreateClass("UIListLayout", {
		Parent = topHolder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 1),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local bottomHolder = CreateClass("Frame", {
		Parent = container,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -2, 1, 3),
		Size = UDim2.new(1, 4, 0, 0)
	})

	CreateClass("UIListLayout", {
		Parent = bottomHolder,
		Padding = UDim.new(0, 1),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local leftHolder = CreateClass("Frame", {
		Parent = container,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(0, -4, 0, -2),
		Size = UDim2.new(0, 0, 1, 4)
	})

	CreateClass("UIListLayout", {
		Parent = leftHolder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 2)
	})

	local rightHolder = CreateClass("Frame", {
		Parent = container,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 4, 0, -5),
		Size = UDim2.new(0, 0, 1, 4)
	})

	CreateClass("UIListLayout", {
		Parent = rightHolder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 2)
	})

	local healthOutline = CreateClass("Frame", {
		Parent = leftHolder,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		Visible = false,
		Size = UDim2.new(0, 2, 1, 0),
		ZIndex = 5
	})

	CreateClass("UIStroke", {
		Parent = healthOutline,
		Thickness = 1,
		Color = Color3.new(0, 0, 0)
	})

	local healthBar = CreateClass("Frame", {
		Parent = healthOutline,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 6
	})

	local healthGradient = CreateClass("UIGradient", {
		Parent = healthBar,
		Rotation = -90
	})

	local entry = {
		Entity = entity,
		Container = container,
		BoxHolder = boxHolder,
		Outline = outline,
		InlineHolder = inlineHolder,
		BoxGradient = boxGradient,
		Fill = fill,
		FillGradient = fillGradient,
		HealthOutline = healthOutline,
		HealthBar = healthBar,
		HealthGradient = healthGradient,
		Name = self:CreateLabel(topHolder, 1),
		Weapon = self:CreateLabel(bottomHolder, 1),
		Distance = self:CreateLabel(bottomHolder, 2),
		Flags = self:CreateLabel(rightHolder, 1, Enum.TextXAlignment.Left),
		HealthText = self:CreateLabel(container, 0, Enum.TextXAlignment.Right),
		LastHealth = 1,
		HealthTween = nil,
		BoxRotation = 0,
		FillRotation = 0
	}

	entry.Flags.TextYAlignment = Enum.TextYAlignment.Top
	self.Entries[entity] = entry

	return entry
end

function BaseESP:CreateOOVLabel(size)
	local label = CreateClass("TextLabel", {
		Parent = OOVHolder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(200, size + 4),
		TextSize = size,
		TextColor3 = Color3.new(1, 1, 1),
		TextStrokeColor3 = Color3.new(0, 0, 0),
		TextStrokeTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Visible = false,
		ZIndex = 50
	})

	CreateClass("UIStroke", {
		Parent = label,
		Color = Color3.new(0, 0, 0),
		Thickness = 1
	})

	return label
end

function BaseESP:GetOOVEntry(entity)
	local existing = self.OOVEntries[entity]

	if existing then
		return existing
	end

	local arrow
	local outline

	if Drawing and Drawing.new then
		arrow = Drawing.new("Triangle")
		arrow.Filled = true
		arrow.Thickness = 1
		arrow.Visible = false

		outline = Drawing.new("Triangle")
		outline.Filled = false
		outline.Thickness = 1.5
		outline.Visible = false
	end

	local entry = {
		Arrow = arrow,
		Outline = outline,
		Name = self:CreateOOVLabel(15),
		Weapon = self:CreateOOVLabel(13),
		Distance = self:CreateOOVLabel(13)
	}

	self.OOVEntries[entity] = entry

	return entry
end

function BaseESP:HideEntry(entry)
	entry.Container.Visible = false
	entry.HealthOutline.Visible = false
	entry.HealthText.Visible = false
	entry.Name.Visible = false
	entry.Weapon.Visible = false
	entry.Distance.Visible = false
	entry.Flags.Visible = false
end

function BaseESP:HideOOV(entity)
	local entry = self.OOVEntries[entity]

	if not entry then
		return
	end

	if entry.Arrow then
		entry.Arrow.Visible = false
	end

	if entry.Outline then
		entry.Outline.Visible = false
	end

	entry.Name.Visible = false
	entry.Weapon.Visible = false
	entry.Distance.Visible = false
end

function BaseESP:RemoveOOV(entity)
	local entry = self.OOVEntries[entity]

	if not entry then
		return
	end

	self:HideOOV(entity)

	pcall(function()
		if entry.Arrow then
			entry.Arrow:Remove()
		end

		if entry.Outline then
			entry.Outline:Remove()
		end

		entry.Name:Destroy()
		entry.Weapon:Destroy()
		entry.Distance:Destroy()
	end)

	self.OOVEntries[entity] = nil
end

function BaseESP:RemoveChams(entity)
	local list = self.Chams[entity]

	if not list then
		return
	end

	for _, adornment in ipairs(list) do
		adornment:Destroy()
	end

	self.Chams[entity] = nil
end

function BaseESP:UpdateChams(entity, character, settings, rootPart)
	local chams = settings.chams

	if not chams or not chams.enabled or not rootPart then
		self:RemoveChams(entity)
		return
	end

	local parts = self.Adapter:GetChamsParts(entity, character)
	local list = self.Chams[entity]

	if not list or #list ~= #parts * 2 then
		self:RemoveChams(entity)
		list = {}

		for _, part in ipairs(parts) do
			for index = 1, 2 do
				local isOutline = index == 1
				local adornment = Instance.new(part.Name == "Head" and "CylinderHandleAdornment" or "BoxHandleAdornment")
				adornment.AlwaysOnTop = true
				adornment.ZIndex = isOutline and -1 or 1
				adornment.AdornCullingMode = Enum.AdornCullingMode.Never
				adornment.Parent = ChamsFolder
				adornment:SetAttribute("PartName", part.Name)
				adornment:SetAttribute("IsOutline", isOutline)
				table.insert(list, adornment)
			end
		end

		self.Chams[entity] = list
	end

	for _, adornment in ipairs(list) do
		local part = character:FindFirstChild(adornment:GetAttribute("PartName"))
		local isOutline = adornment:GetAttribute("IsOutline")

		if not part or not part:IsA("BasePart") then
			adornment.Adornee = nil
			adornment.Visible = false
		else
			if part.Name == "Head" then
				adornment.CFrame = CFrame.Angles(math.pi / 2, 0, 0)
				adornment.Height = part.Size.Y + 0.35
				adornment.Radius = part.Size.X / 2 + (isOutline and 0.15 or 0.05)
			else
				adornment.Size = part.Size + (isOutline and Vector3.new(0.09, 0.09, 0.09) or Vector3.new(-0.05, -0.05, -0.05))
			end

			adornment.Adornee = part
			adornment.Color3 = isOutline and chams.outlineColor or chams.fillColor
			adornment.Transparency = isOutline and chams.outlineTransparency or chams.fillTransparency
			adornment.Shading = isOutline and (chams.shadingOutline or Enum.AdornShading.Default) or (chams.shading or Enum.AdornShading.Default)
			adornment.Visible = true
		end
	end
end

function BaseESP:CalculateBox(rootPart)
	local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

	if not onScreen or position.Z <= 0 then
		return nil
	end

	local scale = 15 / (position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
	local width = math.floor(2.6 * scale * 1.2)
	local height = math.floor(3.5 * scale * 1.2)

	return width, height, math.floor(position.X - width / 2), math.floor(position.Y - height / 2.3)
end

function BaseESP:UpdateColors(entry, settings)
	local boxGradient = settings.boxGradient or { Color3.new(1, 1, 1), Color3.new(1, 1, 1) }
	local fillGradient = settings.fillGradient or { Color3.new(1, 1, 1), Color3.new(1, 1, 1) }
	local healthGradient = settings.healthGradient or { Color3.new(0, 1, 0), Color3.new(1, 0, 0) }

	entry.BoxGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, boxGradient[1]),
		ColorSequenceKeypoint.new(1, boxGradient[2])
	})

	entry.Fill.BackgroundTransparency = settings.fillTransparency or 0.5
	entry.FillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, fillGradient[1]),
		ColorSequenceKeypoint.new(1, fillGradient[2])
	})

	entry.HealthGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, healthGradient[2]),
		ColorSequenceKeypoint.new(1, healthGradient[1])
	})

	entry.Name.TextColor3 = settings.nameColor or Color3.new(1, 1, 1)
	entry.Weapon.TextColor3 = settings.weaponColor or Color3.new(1, 1, 1)
	entry.Distance.TextColor3 = settings.distanceLabelColor or Color3.new(1, 1, 1)
	entry.HealthText.TextColor3 = settings.healthtextColor or Color3.new(1, 1, 1)
	entry.Flags.TextColor3 = settings.flags and settings.flags.color or Color3.new(1, 1, 1)

	self.Fonts:Apply(entry.Name, settings.nameFont or settings.font)
	self.Fonts:Apply(entry.Weapon, settings.weaponFont or settings.font)
	self.Fonts:Apply(entry.Distance, settings.distanceFont or settings.font)
	self.Fonts:Apply(entry.Flags, settings.flagsFont or settings.font)
	self.Fonts:Apply(entry.HealthText, settings.healthFont or settings.font)
end

function BaseESP:BuildFlags(entity, character, rootPart, settings)
	local output = {}
	local flags = settings.flags or {}
	local selected = flags.selected or {}

	for _, flag in ipairs(selected) do
		if flag == "Visible" then
			local cached = self.VisibilityCache[entity]
			local now = os.clock()

			if not cached or now - cached.Time > 0.1 then
				cached = {
					Time = now,
					Value = self.Adapter:IsVisible(entity, character, rootPart)
				}
				self.VisibilityCache[entity] = cached
			end

			table.insert(output, cached.Value and "Visible" or "Not Visible")
		elseif flag == "Forcefield" and self.Adapter:HasForceField(entity, character) then
			table.insert(output, "FF")
		elseif flag == "Walking" and self.Adapter:IsWalking(entity, character) then
			table.insert(output, "Walking")
		elseif flag == "State" then
			table.insert(output, self.Adapter:GetState(entity, character))
		end
	end

	return table.concat(output, "\n")
end

function BaseESP:UpdateOOV(entity)
	local character = self.Adapter:GetCharacter(entity)
	local settings, teammate = self:GetSettings(entity)
	local mainSettings = self.State.ESP
	local oov = settings.oov or settings.OOV or {}

	if not oov.enabled or not mainSettings.enabled or (teammate and not settings.enabled) then
		self:HideOOV(entity)
		return
	end

	local rootPart = self.Adapter:GetRootPart(entity, character)

	if not character or not rootPart or not self.Adapter:IsAlive(entity, character) then
		self:HideOOV(entity)
		return
	end

	local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

	if mainSettings.distanceESPCheck and distance > mainSettings.maxdist then
		self:HideOOV(entity)
		return
	end

	local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
	local viewport = Camera.ViewportSize
	local margin = oov.margin or 40

	if onScreen and position.Z > 0 and position.X >= margin and position.X <= viewport.X - margin and position.Y >= margin and position.Y <= viewport.Y - margin then
		self:HideOOV(entity)
		return
	end

	local entry = self:GetOOVEntry(entity)
	local relative = Camera.CFrame:PointToObjectSpace(rootPart.Position)
	local angle = math.atan2(-relative.Y, relative.X)
	local direction = Vector2.new(math.cos(angle), math.sin(angle))
	local size = oov.dynamicSize and math.clamp(40 - distance / 150 * 20, 10, 30) or (oov.size or 18)
	local radius = oov.dynamicDistance and math.clamp(10 + distance / 150 * 85, 10, 95) / 400 or (oov.distance or 75) / 400
	local pointA = direction * math.min(viewport.X, viewport.Y) * radius + viewport / 2
	local pointB = pointA - Vector2.new(
		direction.X * math.cos(0.5) - direction.Y * math.sin(0.5),
		direction.X * math.sin(0.5) + direction.Y * math.cos(0.5)
	) * size
	local pointC = pointA - Vector2.new(
		direction.X * math.cos(-0.5) - direction.Y * math.sin(-0.5),
		direction.X * math.sin(-0.5) + direction.Y * math.cos(-0.5)
	) * size
	local color = oov.color or Color3.new(1, 1, 1)
	local alpha = oov.blink and (math.sin(os.clock() * (4 + (oov.blinkSpeed or 0))) + 1) / 2 or 1

	if entry.Arrow then
		entry.Arrow.PointA = pointA
		entry.Arrow.PointB = pointB
		entry.Arrow.PointC = pointC
		entry.Arrow.Color = color
		entry.Arrow.Transparency = alpha
		entry.Arrow.Visible = true

		entry.Outline.PointA = pointA
		entry.Outline.PointB = pointB
		entry.Outline.PointC = pointC
		entry.Outline.Color = Color3.new(color.R * 0.6, color.G * 0.6, color.B * 0.6)
		entry.Outline.Transparency = alpha
		entry.Outline.Visible = true
	end

	local elements = oov.elements or {}
	local showName = elements.Name == true or table.find(elements, "Name") ~= nil
	local showWeapon = elements.Weapon == true or table.find(elements, "Weapon") ~= nil
	local showDistance = elements.Distance == true or table.find(elements, "Distance") ~= nil
	local labelBase = Vector2.new((pointA.X + pointB.X + pointC.X) / 3, (pointA.Y + pointB.Y + pointC.Y) / 3 + size * 0.6)
	local offset = 0
	local nameSize = oov.nameSize or 15
	local weaponSize = oov.weaponSize or 13
	local distanceSize = oov.distanceSize or 13

	self.Fonts:Apply(entry.Name, oov.nameFont or settings.nameFont or settings.font)
	self.Fonts:Apply(entry.Weapon, oov.weaponFont or settings.weaponFont or settings.font)
	self.Fonts:Apply(entry.Distance, oov.distanceFont or settings.distanceFont or settings.font)

	entry.Name.Visible = showName
	entry.Name.TextSize = nameSize
	entry.Name.Size = UDim2.fromOffset(200, nameSize + 4)

	if showName then
		entry.Name.Text = self.Adapter:GetName(entity)
		entry.Name.TextColor3 = oov.nameColor or settings.nameColor or Color3.new(1, 1, 1)
		entry.Name.Position = UDim2.fromOffset(labelBase.X, labelBase.Y + offset)
		offset += nameSize
	end

	entry.Weapon.Visible = showWeapon
	entry.Weapon.TextSize = weaponSize
	entry.Weapon.Size = UDim2.fromOffset(200, weaponSize + 4)

	if showWeapon then
		entry.Weapon.Text = self.Adapter:GetWeapon(entity, character)
		entry.Weapon.TextColor3 = oov.weaponColor or settings.weaponColor or Color3.new(1, 1, 1)
		entry.Weapon.Position = UDim2.fromOffset(labelBase.X, labelBase.Y + offset)
		offset += weaponSize
	end

	entry.Distance.Visible = showDistance
	entry.Distance.TextSize = distanceSize
	entry.Distance.Size = UDim2.fromOffset(200, distanceSize + 4)

	if showDistance then
		entry.Distance.Text = string.format("%dm", math.floor(distance))
		entry.Distance.TextColor3 = oov.distanceColor or settings.distanceLabelColor or Color3.new(1, 1, 1)
		entry.Distance.Position = UDim2.fromOffset(labelBase.X, labelBase.Y + offset)
	end
end

function BaseESP:UpdateEntry(entity, delta)
	local character = self.Adapter:GetCharacter(entity)
	local entry = self.Entries[entity] or self:CreateEntry(entity)
	local settings, teammate = self:GetSettings(entity)
	local mainSettings = self.State.ESP

	if not character or not self.Adapter:IsAlive(entity, character) then
		self:HideEntry(entry)
		self:RemoveChams(entity)
		return
	end

	if not mainSettings.enabled or (teammate and not settings.enabled) then
		self:HideEntry(entry)
		self:RemoveChams(entity)
		return
	end

	local rootPart = self.Adapter:GetRootPart(entity, character)

	if not rootPart then
		self:HideEntry(entry)
		self:RemoveChams(entity)
		return
	end

	local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

	if mainSettings.distanceESPCheck and distance > mainSettings.maxdist then
		self:HideEntry(entry)
		self:RemoveChams(entity)
		return
	end

	self:UpdateChams(entity, character, settings, rootPart)

	local width, height, x, y = self:CalculateBox(rootPart)

	if not width then
		self:HideEntry(entry)
		return
	end

	entry.Container.Visible = true
	entry.Container.Position = UDim2.fromOffset(x, y)
	entry.Container.Size = UDim2.fromOffset(width, height)
	entry.BoxHolder.Size = UDim2.fromOffset(width, height)
	entry.InlineHolder.Size = UDim2.fromOffset(width + 2, height + 2)

	self:UpdateColors(entry, settings)

	if settings.boxGradientUseManual then
		entry.BoxRotation = settings.boxGradientManualRotation
	elseif settings.boxGradientAnimation then
		entry.BoxRotation = (entry.BoxRotation + settings.boxGradientRotationSpeed * delta) % 360
	else
		entry.BoxRotation = 0
	end

	if settings.fillGradientUseManualRotation then
		entry.FillRotation = settings.fillGradientManualRotation
	elseif settings.fillGradientRotationEnabled then
		entry.FillRotation = (entry.FillRotation + settings.fillGradientRotationSpeed * delta) % 360
	else
		entry.FillRotation = 0
	end

	entry.BoxGradient.Rotation = entry.BoxRotation
	entry.FillGradient.Rotation = entry.FillRotation
	entry.BoxHolder.Visible = settings.box
	entry.InlineHolder.Visible = settings.box
	entry.Fill.Visible = settings.box and settings.fill

	local health = self.Adapter:GetHealth(entity, character)
	local maxHealth = math.max(self.Adapter:GetMaxHealth(entity, character), 1)
	local healthRatio = math.clamp(health / maxHealth, 0, 1)

	entry.HealthOutline.Visible = settings.healthbar
	entry.HealthOutline.Size = UDim2.new(0, settings.healthThickness or 2, 1, 0)

	if settings.healthbar then
		if settings.healthanimation and math.abs(healthRatio - entry.LastHealth) > 0.001 then
			if entry.HealthTween then
				entry.HealthTween:Cancel()
			end

			entry.HealthTween = TweenService:Create(
				entry.HealthBar,
				TweenInfo.new(
					settings.healthanimationduration or 0.15,
					Enum.EasingStyle[settings.healthEasingStyle] or Enum.EasingStyle.Quad,
					Enum.EasingDirection[settings.healthEasingDirection] or Enum.EasingDirection.Out
				),
				{
					Size = UDim2.new(1, 0, healthRatio, 0)
				}
			)

			entry.HealthTween:Play()
			entry.LastHealth = healthRatio
		elseif not settings.healthanimation then
			entry.HealthBar.Size = UDim2.new(1, 0, healthRatio, 0)
			entry.LastHealth = healthRatio
		end
	end

	entry.HealthText.Visible = settings.healthbar and settings.healthtext

	if entry.HealthText.Visible then
		entry.HealthText.Text = tostring(math.floor(health))
		entry.HealthText.Size = UDim2.fromOffset(30, 10)
		entry.HealthText.Position = UDim2.new(0, -((settings.healthThickness or 2) + 37), 0, -4)
	end

	entry.Name.Visible = settings.name
	entry.Name.Text = self.Adapter:GetName(entity)

	entry.Weapon.Visible = settings.weapon
	entry.Weapon.Text = self.Adapter:GetWeapon(entity, character)

	entry.Distance.Visible = settings.distance
	entry.Distance.Text = string.format("[%d]", math.floor(distance))

	local flags = settings.flags or {}
	entry.Flags.Visible = flags.enabled == true
	entry.Flags.Text = entry.Flags.Visible and self:BuildFlags(entity, character, rootPart, settings) or ""
end

function BaseESP:RemoveEntry(entity)
	local entry = self.Entries[entity]

	if entry then
		if entry.HealthTween then
			entry.HealthTween:Cancel()
		end

		entry.Container:Destroy()
		self.Entries[entity] = nil
	end

	self.VisibilityCache[entity] = nil
	self:RemoveChams(entity)
	self:RemoveOOV(entity)
end

function BaseESP:Update(delta)
	Camera = workspace.CurrentCamera or Camera

	local active = {}

	for _, entity in ipairs(self.Adapter:GetEntities()) do
		active[entity] = true
		self:UpdateEntry(entity, delta)
		self:UpdateOOV(entity)
	end

	for entity in pairs(self.Entries) do
		if not active[entity] then
			self:RemoveEntry(entity)
		end
	end

	for entity in pairs(self.OOVEntries) do
		if not active[entity] then
			self:RemoveOOV(entity)
		end
	end
end

function BaseESP:Destroy()
	if self.Connection then
		self.Connection:Disconnect()
	end

	for entity in pairs(self.Entries) do
		self:RemoveEntry(entity)
	end

	for entity in pairs(self.OOVEntries) do
		self:RemoveOOV(entity)
	end

	ESPHolder:Destroy()
	OOVHolder:Destroy()
end

local ESP = BaseESP.new(State, Adapter)

Library._ESP = ESP
Library._ESPAdapter = Adapter

return ESP
