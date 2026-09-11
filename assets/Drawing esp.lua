local GetService = setmetatable({}, {
	__index = function(_, Name)
		return game:GetService(Name)
	end,
})
local Workspace, Players, RunService, HttpService = GetService["Workspace"], GetService["Players"], GetService["RunService"], GetService["HttpService"]
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local NewVector3, NewVector2 = Vector3.new, Vector2.new
local Format, Clear, Floor, Clamp, Abs, Huge = string.format, table.clear, math.floor, math.clamp, math.abs, math.huge
local function WorldToViewportPoint(a, b)
	local worldPos = b or a
	local cam = Workspace.CurrentCamera
	if not cam or not worldPos then
		return NewVector3(0, 0, 0), false
	end
	Camera = cam
	return cam:WorldToViewportPoint(worldPos)
end
local Frame, ZeroVector3, CameraPosition, Updates = 1 / 60, NewVector3(0, 0, 0), NewVector3(0, 0, 0), 0
local MathConfig = {
	textYOffset = 2,
	headPositionOffset = Vector3.new(0, 1, 0),
	legPositionOffset = Vector3.new(0, -3.5, 0),
	leftArmOffset = CFrame.new(-1.5, 0, 0),
	rightArmOffset = CFrame.new(1.5, 0, 0),
	dynamicXSize = false,
}
local function CameraCache()
	local cam = Workspace.CurrentCamera
	if not cam then return end
	Camera = cam
end
local function calculateXSize(armScreenPositionX, baseScreenPositionX, distanceFromCamera, fieldOfView)
	return math.max(math.abs(armScreenPositionX - baseScreenPositionX) * 3, (500 / math.max(distanceFromCamera, 1)) / ((fieldOfView or 70) / 70))
end
CameraCache()
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	Camera = Workspace.CurrentCamera
	CameraCache()
end)
local DrawingFont = (Drawing.Fonts and (Drawing.Fonts.UI or Drawing.Fonts.System or Drawing.Fonts.Plex)) or 1
local DrawingFontSmall = DrawingFont
local TextSizeMain = 13
local TextSizeSmall = 11
local Library = {
	Directory = "Esp",
	Cache = {},
	Threads = {},
	Connections = {},
	ChamsFolder = nil,
	PlayerChams = {},
	FlagStates = {},
	OOVAllowed = {},
	Table = {
		Enabled = true,
		Distance = 7520,
		Boxes = {
			Enabled = true,
			["Bounding Box"] = {
				Enabled = true,
				IncludeAcsessories = false,
				BoxX = 0,
				BoxY = 0,
			},
			Gradients = {
				Top = Color3.fromRGB(255, 255, 255),
				Bot = Color3.fromRGB(255, 255, 255),
			},
			Filled = {
				Enabled = true,
				Top = Color3.fromRGB(255, 255, 255),
				Bot = Color3.fromRGB(255, 255, 255),
				Transparency = {0.85, 0.85},
			},
		},
		Bars = {
			["Health Bar"] = {
				Enabled = false,
				ShowText = true,
				Top = Color3.fromRGB(0, 255, 0),
				Mid = Color3.fromRGB(255, 170, 0),
				Bot = Color3.fromRGB(255, 0, 0),
			},
			["Armor Bar"] = {
				Enabled = false,
				Top = Color3.fromRGB(255, 255, 255),
				Mid = Color3.fromRGB(220, 220, 220),
				Bot = Color3.fromRGB(180, 180, 180),
			},
		},
		Texts = {
			Name = {
				Enabled = true,
				Color = Color3.fromRGB(255, 255, 255),
				Type = "DisplayName",
				Size = 13,
			},
			Distance = {
				Enabled = true,
				Color = Color3.fromRGB(255, 255, 255),
				Size = 11,
			},
			Weapon = {
				Enabled = true,
				Color = Color3.fromRGB(255, 255, 255),
				Size = 11,
			},
		},
		Flags = {
			Enabled = true,
			Size = 11,
			List = {
				Walking = {
					Enabled = true,
					Text = "Walking",
					Color = Color3.fromRGB(255, 0, 0),
				},
				Jumping = {
					Enabled = true,
					Text = "Jumping",
					Color = Color3.fromRGB(255, 0, 0),
				},
			},
		},
		Chams = {
			Enabled = true,
			FillColor = Color3.fromRGB(255, 255, 255),
			OutlineColor = Color3.fromRGB(0, 0, 0),
			FillTransparency = 0.61,
			OutlineTransparency = 0.21,
			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		},
		OOV = {
			Enabled = true,
			Color = Color3.fromRGB(0, 255, 255),
			Size = 18,
			Radius = 0.35,
			Limit = 6,
			ShowName = true,
			ShowDistance = true,
			ShowWeapon = true,
		},
		Skeleton = {
			Enabled = false,
			Color = Color3.fromRGB(255, 255, 255),
			Thickness = 1.5,
			Transparency = 0,
		},
		CustomData = {
			GetHealth = nil,
			GetArmor = nil,
			GetWeapon = nil,
			GetFlags = nil,
		},
		CustomGetBodyParts = nil,
		CustomSkeletonJoints = nil,
	},
}
local Table = Library.Table
local function GetBodyParts(Character)
	if Table.CustomGetBodyParts then
		return Table.CustomGetBodyParts(Character)
	end
	if not Character then
		return {}
	end
	local Parts = {}
	for _, Obj in Character:GetDescendants() do
		if Obj:IsA("BasePart")
			and Obj.Transparency < 1
			and not Obj:FindFirstAncestorOfClass("Accessory")
			and not Obj:FindFirstAncestorOfClass("Tool")
			and Obj.Name ~= "HumanoidRootPart"
			and Obj.Name ~= "Handle"
		then
			table.insert(Parts, Obj)
		end
	end
	return Parts
end
local function CreateDrawing(Type, Props)
	local Obj = Drawing.new(Type)
	for k, v in pairs(Props or {}) do
		Obj[k] = v
	end
	return Obj
end
local function SafeRemove(obj)
	if not obj then return end
	pcall(function()
		obj.Visible = false
		obj:Remove()
	end)
end
Library.__index = Library
function Library:CreateThreads(Name, Signal, Callback)
	local Connection = Signal:Connect(Callback)
	self.Threads[Name] = Connection
	return Connection
end
do
	local parent = nil
	pcall(function()
		if type(gethui) == "function" then parent = gethui() end
	end)
	if not parent then
		pcall(function() parent = game:GetService("CoreGui") end)
	end
	if parent then
		Library.ChamsFolder = Instance.new("Folder")
		Library.ChamsFolder.Name = "LeanESP_Chams"
		Library.ChamsFolder.Parent = parent
	end
end
function Library:BuildChamsForPlayer(Player)
	local existing = self.PlayerChams[Player]
	if existing then
		pcall(function() existing:Destroy() end)
		self.PlayerChams[Player] = nil
	end
	local Character = Player.Character
	do
		local folder = Workspace:FindFirstChild("Characters")
		if folder then
			local m = folder:FindFirstChild(Player.Name)
			if m and m:IsA("Model") then Character = m end
		end
	end
	if not Character or not self.ChamsFolder then
		return
	end
	local S = Table.Chams
	local hl = Instance.new("Highlight")
	hl.Name = "ESPCham"
	hl.Enabled = false
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.FillColor = S.FillColor
	hl.OutlineColor = S.OutlineColor
	hl.FillTransparency = S.FillTransparency
	hl.OutlineTransparency = S.OutlineTransparency
	hl.Adornee = Character
	hl.Parent = self.ChamsFolder
	self.PlayerChams[Player] = hl
end
function Library:UpdateChams(Player, Data)
	local S = Table.Chams
	local Character = Data.Character or Player.Character
	local hl = self.PlayerChams[Player]
	if not hl or not hl.Parent then
		self:BuildChamsForPlayer(Player)
		hl = self.PlayerChams[Player]
	end
	if not hl then return end
	local enabled = S.Enabled
		and Table.Enabled
		and Character ~= nil
		and Data.RootPart ~= nil
		and Data.Alive
		and (CameraPosition - Data.RootPart.Position).Magnitude <= Table.Distance
	if not enabled then
		hl.Enabled = false
		hl.Adornee = nil
		return
	end
	if hl.Adornee ~= Character then
		hl.Adornee = Character
	end
	hl.FillColor = S.FillColor
	hl.OutlineColor = S.OutlineColor
	hl.FillTransparency = S.FillTransparency
	hl.OutlineTransparency = S.OutlineTransparency
	if S.DepthMode then
		hl.DepthMode = S.DepthMode
	end
	hl.Enabled = true
end
function Library:ClearChamsForPlayer(Player)
	local hl = self.PlayerChams[Player]
	if not hl then return end
	pcall(function()
		hl.Adornee = nil
		hl.Enabled = false
		hl:Destroy()
	end)
	self.PlayerChams[Player] = nil
end
function Library:DestroyDrawings(Objects)
	if not Objects then return end
	for key, obj in pairs(Objects) do
		if type(obj) == "table" and obj.Line then
			SafeRemove(obj.Line)
		elseif typeof(obj) ~= "Instance" then
			SafeRemove(obj)
		end
		Objects[key] = nil
	end
end
function Library:HideAllVisuals(Data)
	local Objects = Data and Data.Objects
	if not Objects then return end
	for key, obj in pairs(Objects) do
		if type(obj) == "table" and obj.Line then
			obj.Line.Visible = false
		elseif obj and obj.Visible ~= nil then
			obj.Visible = false
		end
	end
	if Objects.Flags then
		for _, f in pairs(Objects.Flags) do
			if f then f.Visible = false end
		end
	end
	if Objects.Skeleton then
		for _, bone in ipairs(Objects.Skeleton) do
			if bone.Line then bone.Line.Visible = false end
		end
	end
end
function Library:InitEsp(Data)
	local Objects = Data.Objects
	Objects.BoxOutline = CreateDrawing("Square", {
		Visible = false,
		Filled = false,
		Thickness = 3,
		Color = Color3.new(0, 0, 0),
		ZIndex = 1,
	})
	Objects.Box = CreateDrawing("Square", {
		Visible = false,
		Filled = false,
		Thickness = 1,
		Color = Table.Boxes.Gradients.Top,
		ZIndex = 2,
	})
	Objects.BoxFill = CreateDrawing("Square", {
		Visible = false,
		Filled = true,
		Thickness = 0,
		Color = Table.Boxes.Filled.Top,
		Transparency = 0.8,
		ZIndex = 0,
	})
	Objects.Name = CreateDrawing("Text", {
		Visible = false,
		Center = true,
		Outline = true,
		Size = (Table.Texts.Name and Table.Texts.Name.Size) or TextSizeMain,
		Font = DrawingFont,
		Color = Table.Texts.Name.Color,
		Text = "",
		ZIndex = 3,
	})
	Objects.Distance = CreateDrawing("Text", {
		Visible = false,
		Center = true,
		Outline = true,
		Size = (Table.Texts.Distance and Table.Texts.Distance.Size) or TextSizeSmall,
		Font = DrawingFontSmall,
		Color = Table.Texts.Distance.Color,
		Text = "",
		ZIndex = 3,
	})
	Objects.Weapon = CreateDrawing("Text", {
		Visible = false,
		Center = true,
		Outline = true,
		Size = (Table.Texts.Weapon and Table.Texts.Weapon.Size) or TextSizeSmall,
		Font = DrawingFontSmall,
		Color = Table.Texts.Weapon.Color,
		Text = "",
		ZIndex = 3,
	})
	Objects.HealthBarOutline = CreateDrawing("Square", {
		Visible = false,
		Filled = true,
		Thickness = 0,
		Color = Color3.new(0, 0, 0),
		ZIndex = 1,
	})
	Objects.HealthBar = CreateDrawing("Square", {
		Visible = false,
		Filled = true,
		Thickness = 0,
		Color = Color3.new(0, 1, 0),
		ZIndex = 2,
	})
	Objects.HealthText = CreateDrawing("Text", {
		Visible = false,
		Center = false,
		Outline = true,
		Size = TextSizeSmall,
		Font = DrawingFontSmall,
		Color = Color3.new(1, 1, 1),
		Text = "",
		ZIndex = 3,
	})
	Objects.ArmorBarOutline = CreateDrawing("Square", {
		Visible = false,
		Filled = true,
		Thickness = 0,
		Color = Color3.new(0, 0, 0),
		ZIndex = 1,
	})
	Objects.ArmorBar = CreateDrawing("Square", {
		Visible = false,
		Filled = true,
		Thickness = 0,
		Color = Color3.new(1, 1, 1),
		ZIndex = 2,
	})
	Objects.OOVArrow = CreateDrawing("Triangle", {
		Visible = false,
		Filled = true,
		Thickness = 1,
		Color = Table.OOV.Color,
		ZIndex = 3,
	})
	Objects.OOVArrowOutline = CreateDrawing("Triangle", {
		Visible = false,
		Filled = false,
		Thickness = 2,
		Color = Color3.new(0, 0, 0),
		ZIndex = 2,
	})
	Objects.OOVName = CreateDrawing("Text", {
		Visible = false,
		Center = true,
		Outline = true,
		Size = TextSizeSmall,
		Font = DrawingFontSmall,
		Color = Table.OOV.Color,
		Text = "",
		ZIndex = 3,
	})
	Objects.OOVDistance = CreateDrawing("Text", {
		Visible = false,
		Center = true,
		Outline = true,
		Size = TextSizeSmall,
		Font = DrawingFontSmall,
		Color = Table.OOV.Color,
		Text = "",
		ZIndex = 3,
	})
	Objects.OOVWeapon = CreateDrawing("Text", {
		Visible = false,
		Center = true,
		Outline = true,
		Size = TextSizeSmall,
		Font = DrawingFontSmall,
		Color = Table.OOV.Color,
		Text = "",
		ZIndex = 3,
	})
	Objects.Flags = {}
	Objects.Skeleton = {}
	local joints = Table.CustomSkeletonJoints or {
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
	for _, pair in ipairs(joints) do
		Objects.Skeleton[#Objects.Skeleton + 1] = {
			From = pair[1],
			To = pair[2],
			Line = CreateDrawing("Line", {
				Visible = false,
				Thickness = Table.Skeleton.Thickness or 1.5,
				Color = Table.Skeleton.Color,
				ZIndex = 2,
			}),
		}
	end
end
function Library:CalculateBox(Data)
	local RootPart = Data.RootPart
	local Character = Data.Character
	if not RootPart then
		return nil, nil, nil, nil, false
	end
	local cam = Camera or Workspace.CurrentCamera
	if not cam then
		return nil, nil, nil, nil, false
	end
	local rootPosition = RootPart.Position
	local rootCFrame = RootPart.CFrame
	local head = Character and Character:FindFirstChild("Head")
	local headWorld = (head and head.Position or rootPosition) + MathConfig.headPositionOffset
	local legWorld = rootPosition + MathConfig.legPositionOffset
	local headScreen, onScreen = WorldToViewportPoint(cam, headWorld)
	if not onScreen or headScreen.Z <= 0 then
		return nil, nil, nil, nil, false
	end
	local legScreen = WorldToViewportPoint(cam, legWorld)
	local camCFrame = cam.CFrame
	local fov = cam.FieldOfView
	local distanceFromCamera = (camCFrame.Position - rootPosition).Magnitude
	local baseCFrame = (MathConfig.dynamicXSize and rootCFrame) or CFrame.lookAt(rootPosition, camCFrame.Position)
	local leftArmWorld = (baseCFrame * MathConfig.leftArmOffset).Position
	local armScreen = WorldToViewportPoint(cam, leftArmWorld)
	local headV = NewVector2(headScreen.X, headScreen.Y)
	local legV = NewVector2(legScreen.X, legScreen.Y)
	local baseScreen = headV + ((legV - headV) / 2)
	local width = math.max(calculateXSize(armScreen.X, baseScreen.X, distanceFromCamera, fov), 3)
	local rawHeight = headV.Y - legV.Y
	local height = math.abs(rawHeight)
	if height < 4 then height = 4 end
	local BoundingBox = Table.Boxes["Bounding Box"]
	local PadX = (BoundingBox and BoundingBox.BoxX) or 0
	local PadY = (BoundingBox and BoundingBox.BoxY) or 0
	local W = width + PadX
	local H = height + PadY
	local topY = math.min(headV.Y, legV.Y)
	local X = baseScreen.X - W * 0.5
	local Y = topY
	return W, H, X, Y, true
end
local function lerpColor(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end
local function healthColor(ratio, cfg)
	ratio = Clamp(ratio, 0, 1)
	if ratio > 0.5 then
		return lerpColor(cfg.Mid, cfg.Top, (ratio - 0.5) * 2)
	end
	return lerpColor(cfg.Bot, cfg.Mid, ratio * 2)
end
function Library:CollectFlags(Player, Data)
	local list = Table.Flags and Table.Flags.List
	if not list or not Table.Flags.Enabled then
		return {}
	end
	local out = {}
	local custom = Table.CustomData and Table.CustomData.GetFlags
	local flags = nil
	if type(custom) == "function" then
		local ok, res = pcall(custom, Player, Data.Character)
		if ok and type(res) == "table" then flags = res end
	end
	local hum = Data.Humanoid
	local stateName = ""
	pcall(function()
		if hum then stateName = hum:GetState().Name end
	end)
	for key, cfg in pairs(list) do
		if type(cfg) == "table" and cfg.Enabled then
			local on = false
			if flags and flags[key] ~= nil then
				on = flags[key] and true or false
			elseif key == "Walking" then
				on = hum and hum.MoveDirection.Magnitude > 0.08 and stateName ~= "Jumping" and stateName ~= "Freefall"
			elseif key == "Jumping" then
				on = stateName == "Jumping" or stateName == "Freefall"
			elseif key == "Running" then
				on = hum and hum.MoveDirection.Magnitude > 0.08 and (hum.WalkSpeed or 16) > 18
			elseif key == "Dead" then
				on = (Data.Health or 0) <= 0
			elseif key == "Ragdoll" then
				on = stateName == "Physics" or stateName == "Ragdoll"
			end
			if on then
				out[#out + 1] = { Text = cfg.Text or key, Color = cfg.Color or Color3.new(1, 1, 1) }
			end
		end
	end
	return out
end
function Library:Update(Player, Data)
	local Objects = Data.Objects
	if not Objects or not Objects.Box then
		self:InitEsp(Data)
		Objects = Data.Objects
	end
	local W, H, X, Y, onScreen = self:CalculateBox(Data)
	local Distance = 0
	if Data.RootPart then
		Distance = Floor((CameraPosition - Data.RootPart.Position).Magnitude)
	end
	local oovCfg = Table.OOV
	local isOov = oovCfg and oovCfg.Enabled and not onScreen and self.OOVAllowed and self.OOVAllowed[Player]
	if isOov and Data.RootPart then
		self:HideAllVisuals(Data)
		local center = Camera.ViewportSize / 2
		local relative = Camera.CFrame:PointToObjectSpace(Data.RootPart.Position)
		local ang = math.atan2(-relative.Y, relative.X)
		local dir = NewVector2(math.cos(ang), math.sin(ang))
		local radius = (oovCfg.Radius or 0.35) * math.min(Camera.ViewportSize.X, Camera.ViewportSize.Y) * 0.5
		local size = oovCfg.Size or 18
		local tip = center + dir * radius
		local perp = NewVector2(-dir.Y, dir.X)
		local left = tip - dir * (size * 0.55) + perp * (size * 0.42)
		local right = tip - dir * (size * 0.55) - perp * (size * 0.42)
		local col = oovCfg.Color
		Objects.OOVArrow.PointA = tip
		Objects.OOVArrow.PointB = left
		Objects.OOVArrow.PointC = right
		Objects.OOVArrow.Color = col
		Objects.OOVArrow.Visible = true
		Objects.OOVArrowOutline.PointA = tip
		Objects.OOVArrowOutline.PointB = left
		Objects.OOVArrowOutline.PointC = right
		Objects.OOVArrowOutline.Visible = true
		local yOff = size * 0.7
		if oovCfg.ShowName then
			local nameText = (Table.Texts.Name.Type == "Name") and Player.Name or Player.DisplayName
			Objects.OOVName.Text = nameText
			Objects.OOVName.Color = col
			Objects.OOVName.Position = tip + NewVector2(0, yOff)
			Objects.OOVName.Visible = true
			yOff = yOff + Objects.OOVName.TextBounds.Y + 2
		end
		if oovCfg.ShowDistance then
			Objects.OOVDistance.Text = Format("%dst", Distance)
			Objects.OOVDistance.Color = col
			Objects.OOVDistance.Position = tip + NewVector2(0, yOff)
			Objects.OOVDistance.Visible = true
			yOff = yOff + Objects.OOVDistance.TextBounds.Y + 2
		end
		if oovCfg.ShowWeapon then
			Objects.OOVWeapon.Text = Data.CurrentTool or "none"
			Objects.OOVWeapon.Color = col
			Objects.OOVWeapon.Position = tip + NewVector2(0, yOff)
			Objects.OOVWeapon.Visible = true
		end
		return
	end
	if not onScreen or not W then
		self:HideAllVisuals(Data)
		return
	end
	if Objects.OOVArrow then Objects.OOVArrow.Visible = false end
	if Objects.OOVArrowOutline then Objects.OOVArrowOutline.Visible = false end
	if Objects.OOVName then Objects.OOVName.Visible = false end
	if Objects.OOVDistance then Objects.OOVDistance.Visible = false end
	if Objects.OOVWeapon then Objects.OOVWeapon.Visible = false end
	W, H, X, Y = Floor(W), Floor(H), Floor(X), Floor(Y)
	local pos = NewVector2(X, Y)
	local size = NewVector2(W, H)
	local BoxesCfg = Table.Boxes
	if BoxesCfg.Enabled then
		Objects.BoxOutline.Position = pos
		Objects.BoxOutline.Size = size
		Objects.BoxOutline.Visible = true
		Objects.Box.Position = pos
		Objects.Box.Size = size
		Objects.Box.Color = BoxesCfg.Gradients.Top
		Objects.Box.Visible = true
		if BoxesCfg.Filled.Enabled then
			Objects.BoxFill.Position = pos
			Objects.BoxFill.Size = size
			Objects.BoxFill.Color = BoxesCfg.Filled.Top
			local tr = BoxesCfg.Filled.Transparency
			Objects.BoxFill.Transparency = type(tr) == "table" and (tr[1] or 0.8) or 0.8
			Objects.BoxFill.Visible = true
		else
			Objects.BoxFill.Visible = false
		end
	else
		Objects.Box.Visible = false
		Objects.BoxOutline.Visible = false
		Objects.BoxFill.Visible = false
	end
	local TextsCfg = Table.Texts
	local topY = Y
	local botY = Y + H
	local nameSize = (TextsCfg.Name and TextsCfg.Name.Size) or TextSizeMain
	local distSize = (TextsCfg.Distance and TextsCfg.Distance.Size) or TextSizeSmall
	local wepSize = (TextsCfg.Weapon and TextsCfg.Weapon.Size) or TextSizeSmall
	if TextsCfg.Name.Enabled then
		local nameText = (TextsCfg.Name.Type == "Name") and Player.Name or Player.DisplayName
		Objects.Name.Text = nameText
		Objects.Name.Color = TextsCfg.Name.Color
		Objects.Name.Size = nameSize
		Objects.Name.Font = DrawingFont
		Objects.Name.Position = NewVector2(X + W * 0.5, topY - Objects.Name.TextBounds.Y - 2)
		Objects.Name.Visible = true
	else
		Objects.Name.Visible = false
	end
	local below = botY + 2
	if TextsCfg.Distance.Enabled then
		Objects.Distance.Text = Format("%dst", Distance)
		Objects.Distance.Color = TextsCfg.Distance.Color
		Objects.Distance.Size = distSize
		Objects.Distance.Font = DrawingFontSmall
		Objects.Distance.Position = NewVector2(X + W * 0.5, below)
		Objects.Distance.Visible = true
		below = below + Objects.Distance.TextBounds.Y + 1
	else
		Objects.Distance.Visible = false
	end
	if TextsCfg.Weapon.Enabled then
		Objects.Weapon.Text = Data.CurrentTool or "none"
		Objects.Weapon.Color = TextsCfg.Weapon.Color
		Objects.Weapon.Size = wepSize
		Objects.Weapon.Font = DrawingFontSmall
		Objects.Weapon.Position = NewVector2(X + W * 0.5, below)
		Objects.Weapon.Visible = true
	else
		Objects.Weapon.Visible = false
	end
	local HealthCfg = Table.Bars["Health Bar"]
	if HealthCfg.Enabled then
		local Health = Data.Health or 0
		local MaxHealth = Data.MaxHealth or 100
		local Ratio = Clamp(Health / MaxHealth, 0, 1)
		local barW = 3
		local barX = X - barW - 3
		Objects.HealthBarOutline.Position = NewVector2(barX - 1, Y - 1)
		Objects.HealthBarOutline.Size = NewVector2(barW + 2, H + 2)
		Objects.HealthBarOutline.Visible = true
		local fillH = H * Ratio
		Objects.HealthBar.Position = NewVector2(barX, Y + (H - fillH))
		Objects.HealthBar.Size = NewVector2(barW, fillH)
		Objects.HealthBar.Color = healthColor(Ratio, HealthCfg)
		Objects.HealthBar.Visible = true
		if HealthCfg.ShowText then
			Objects.HealthText.Text = Format("%d", Floor(Health))
			Objects.HealthText.Position = NewVector2(barX - Objects.HealthText.TextBounds.X - 2, Y + (H - fillH) - Objects.HealthText.TextBounds.Y * 0.5)
			Objects.HealthText.Visible = true
		else
			Objects.HealthText.Visible = false
		end
	else
		Objects.HealthBarOutline.Visible = false
		Objects.HealthBar.Visible = false
		Objects.HealthText.Visible = false
	end
	local ArmorCfg = Table.Bars["Armor Bar"]
	if ArmorCfg.Enabled then
		local Ratio = Clamp((Data.Armor or 0) / math.max(Data.MaxArmor or 100, 1), 0, 1)
		local barH = 3
		local barY = Y + H + 2
		Objects.ArmorBarOutline.Position = NewVector2(X - 1, barY - 1)
		Objects.ArmorBarOutline.Size = NewVector2(W + 2, barH + 2)
		Objects.ArmorBarOutline.Visible = true
		Objects.ArmorBar.Position = NewVector2(X, barY)
		Objects.ArmorBar.Size = NewVector2(W * Ratio, barH)
		Objects.ArmorBar.Color = ArmorCfg.Top
		Objects.ArmorBar.Visible = true
	else
		Objects.ArmorBarOutline.Visible = false
		Objects.ArmorBar.Visible = false
	end
	local flagLines = self:CollectFlags(Player, Data)
	if not Objects.Flags then Objects.Flags = {} end
	local flagSize = (Table.Flags and Table.Flags.Size) or TextSizeSmall
	local flagX = X + W + 4
	local flagY = Y
	for i, entry in ipairs(flagLines) do
		local d = Objects.Flags[i]
		if not d then
			d = CreateDrawing("Text", {
				Visible = false,
				Center = false,
				Outline = true,
				Size = flagSize,
				Font = DrawingFontSmall,
				ZIndex = 3,
			})
			Objects.Flags[i] = d
		end
		d.Text = entry.Text
		d.Color = entry.Color
		d.Size = flagSize
		d.Font = DrawingFontSmall
		d.Position = NewVector2(flagX, flagY + (i - 1) * (flagSize + 2))
		d.Visible = true
	end
	for i = #flagLines + 1, #Objects.Flags do
		if Objects.Flags[i] then Objects.Flags[i].Visible = false end
	end
	local SkelCfg = Table.Skeleton
	if SkelCfg.Enabled and Data.Character and Objects.Skeleton then
		local Char = Data.Character
		for _, bone in ipairs(Objects.Skeleton) do
			local PartA = Char:FindFirstChild(bone.From)
			local PartB = Char:FindFirstChild(bone.To)
			if PartA and PartB and PartA:IsA("BasePart") and PartB:IsA("BasePart") then
				local PosA, OnA = WorldToViewportPoint(Camera, PartA.Position)
				local PosB, OnB = WorldToViewportPoint(Camera, PartB.Position)
				if OnA and OnB and PosA.Z > 0 and PosB.Z > 0 then
					bone.Line.From = NewVector2(PosA.X, PosA.Y)
					bone.Line.To = NewVector2(PosB.X, PosB.Y)
					bone.Line.Color = SkelCfg.Color
					bone.Line.Thickness = SkelCfg.Thickness
					bone.Line.Transparency = 1 - (SkelCfg.Transparency or 0)
					bone.Line.Visible = true
				else
					bone.Line.Visible = false
				end
			else
				bone.Line.Visible = false
			end
		end
	else
		if Objects.Skeleton then
			for _, bone in ipairs(Objects.Skeleton) do
				bone.Line.Visible = false
			end
		end
	end
	self:UpdateChams(Player, Data)
end
function Library:AddTarget(Player)
	if Player == LocalPlayer or self.Cache[Player] then
		return
	end
	local Data = {
		Player = Player,
		Objects = {},
		Conns = {},
		Character = nil,
		RootPart = nil,
		Humanoid = nil,
		Children = nil,
		Health = 0,
		MaxHealth = 100,
		Armor = 100,
		MaxArmor = 100,
		CurrentTool = nil,
		Alive = false,
	}
	function Data.BindHealth(Hum)
		if Data.Conns.Health then Data.Conns.Health:Disconnect() end
		if Data.Conns.MaxHealth then Data.Conns.MaxHealth:Disconnect() end
		if not Hum then return end
		Data.Health = Hum.Health
		Data.MaxHealth = Hum.MaxHealth
		Data.Alive = Hum.Health > 0
		Data.Conns.Health = Hum:GetPropertyChangedSignal("Health"):Connect(function()
			Data.Health = Hum.Health
			Data.Alive = Hum.Health > 0
		end)
		Data.Conns.MaxHealth = Hum:GetPropertyChangedSignal("MaxHealth"):Connect(function()
			Data.MaxHealth = Hum.MaxHealth
		end)
	end
	function Data.BindChildren(Char)
		Data.Children = GetBodyParts(Char)
		local tool = Char:FindFirstChildOfClass("Tool")
		Data.CurrentTool = tool and tool.Name or nil
		local eq = Char:FindFirstChild("Equipped")
		if eq then
			local m = eq:FindFirstChildOfClass("Model") or eq:FindFirstChildOfClass("Tool")
			if m then Data.CurrentTool = m.Name end
		end
		if Table.CustomData and type(Table.CustomData.GetWeapon) == "function" then
			local ok, w = pcall(Table.CustomData.GetWeapon, Player, Char)
			if ok and w then Data.CurrentTool = tostring(w) end
		end
		if Table.CustomData and type(Table.CustomData.GetHealth) == "function" then
			local ok, h, mh = pcall(Table.CustomData.GetHealth, Player, Char)
			if ok and type(h) == "number" then
				Data.Health = h
				if type(mh) == "number" then Data.MaxHealth = mh end
			end
		end
		if Table.CustomData and type(Table.CustomData.GetArmor) == "function" then
			local ok, a, ma = pcall(Table.CustomData.GetArmor, Player, Char)
			if ok and type(a) == "number" then
				Data.Armor = a
				if type(ma) == "number" then Data.MaxArmor = ma end
			end
		end
	end
	function Data.TryBind()
		local Char = Player.Character
		local folder = Workspace:FindFirstChild("Characters")
		if folder then
			local m = folder:FindFirstChild(Player.Name)
			if m and m:IsA("Model") then Char = m end
		end
		if not Char or not Char.Parent then return end
		local Root = Char:FindFirstChild("HumanoidRootPart") or Char.PrimaryPart
		local Hum = Char:FindFirstChildOfClass("Humanoid")
		if not Root or not Hum then return end
		Data.Character = Char
		Data.RootPart = Root
		Data.Humanoid = Hum
		Data.Alive = Hum.Health > 0
		Data.BindHealth(Hum)
		Data.BindChildren(Char)
		Library:BuildChamsForPlayer(Player)
	end
	self.Cache[Player] = Data
	self:InitEsp(Data)
	Data.TryBind()
	Data.Conns.CharAdded = Player.CharacterAdded:Connect(function()
		task.defer(Data.TryBind)
		task.delay(0.3, Data.TryBind)
	end)
	Data.Conns.CharRemoving = Player.CharacterRemoving:Connect(function()
		Data.Character = nil
		Data.RootPart = nil
		Data.Humanoid = nil
		Data.Alive = false
		Library:HideAllVisuals(Data)
		Library:ClearChamsForPlayer(Player)
	end)
end
function Library:RemoveTarget(Player)
	local Data = self.Cache[Player]
	if not Data then return end
	for _, c in pairs(Data.Conns) do
		pcall(function() c:Disconnect() end)
	end
	self:HideAllVisuals(Data)
	self:DestroyDrawings(Data.Objects)
	if Data.Objects.Flags then
		for _, d in pairs(Data.Objects.Flags) do SafeRemove(d) end
	end
	if Data.Objects.Skeleton then
		for _, bone in ipairs(Data.Objects.Skeleton) do SafeRemove(bone.Line) end
	end
	self:ClearChamsForPlayer(Player)
	self.Cache[Player] = nil
end
Library:CreateThreads("Renderer", RunService.RenderStepped, function()
	if not Table.Enabled then
		for _, Data in Library.Cache do
			Library:HideAllVisuals(Data)
		end
		for _, hl in pairs(Library.PlayerChams) do
			if hl then
				hl.Enabled = false
				hl.Adornee = nil
			end
		end
		return
	end
	local Now = os.clock()
	if Now - Updates < Frame then
		return
	end
	Updates = Now
	local cam = Workspace.CurrentCamera
	if not cam then return end
	Camera = cam
	CameraPosition = cam.CFrame.Position
	local maxDist = tonumber(Table.Distance) or 7520
	local OOVCandidates = {}
	for Player, Data in Library.Cache do
		if not Player.Parent then
			Library:RemoveTarget(Player)
			continue
		end
		if Data.Character and Data.RootPart then
			Data.BindChildren(Data.Character)
		end
		if not Data.RootPart or not Data.Alive then
			Library:HideAllVisuals(Data)
			local hl = Library.PlayerChams[Player]
			if hl then
				hl.Enabled = false
				hl.Adornee = nil
			end
			continue
		end
		local dist = (CameraPosition - Data.RootPart.Position).Magnitude
		if dist > maxDist then
			Library:HideAllVisuals(Data)
			local hl = Library.PlayerChams[Player]
			if hl then
				hl.Enabled = false
				hl.Adornee = nil
			end
			continue
		end
		if Table.OOV and Table.OOV.Enabled then
			local _, onScreen = WorldToViewportPoint(Camera, Data.RootPart.Position)
			if not onScreen then
				OOVCandidates[#OOVCandidates + 1] = {Player = Player, Dist = dist}
			end
		end
		Library:Update(Player, Data)
	end
	table.sort(OOVCandidates, function(a, b)
		return a.Dist < b.Dist
	end)
	local allowed = {}
	local maxArrows = math.max(Table.OOV and Table.OOV.Limit or 6, 0)
	for i = 1, math.min(#OOVCandidates, maxArrows) do
		allowed[OOVCandidates[i].Player] = true
	end
	Library.OOVAllowed = allowed
end)
local function RefreshAllPlayers()
	Camera = Workspace.CurrentCamera or Camera
	for _, Player in Players:GetPlayers() do
		if Player ~= LocalPlayer then
			if not Library.Cache[Player] then
				Library:AddTarget(Player)
			end
			local Data = Library.Cache[Player]
			if Data and Data.TryBind then
				pcall(Data.TryBind)
			end
		end
	end
end
RefreshAllPlayers()
task.defer(RefreshAllPlayers)
task.delay(0.25, RefreshAllPlayers)
task.delay(1, RefreshAllPlayers)
task.delay(3, RefreshAllPlayers)
Library:CreateThreads("PlayerAdded", Players.PlayerAdded, function(Player)
	Library:AddTarget(Player)
	task.defer(function()
		local Data = Library.Cache[Player]
		if Data and Data.TryBind then Data.TryBind() end
	end)
end)
Library:CreateThreads("LocalCharacterAdded", LocalPlayer.CharacterAdded, function()
	Camera = Workspace.CurrentCamera
	CameraCache()
	task.defer(RefreshAllPlayers)
	task.delay(0.5, RefreshAllPlayers)
end)
if LocalPlayer.Character then
	task.defer(RefreshAllPlayers)
end
Library:CreateThreads("RebindMissing", RunService.Heartbeat, function()
	local now = os.clock()
	if now - (Library._lastRebind or 0) < 0.35 then return end
	Library._lastRebind = now
	for Player, Data in pairs(Library.Cache) do
		if Player.Parent and Data and (not Data.RootPart or not Data.RootPart.Parent or not Data.Alive) then
			if Data.TryBind then pcall(Data.TryBind) end
		end
	end
end)
Library:CreateThreads("PlayerRemoving", Players.PlayerRemoving, function(Player)
	Library:RemoveTarget(Player)
end)
function Library:Unload()
	for Player in self.Cache do
		self:RemoveTarget(Player)
	end
	for _, Conn in self.Connections do
		Conn:Disconnect()
	end
	Clear(self.Connections)
	for _, Conn in self.Threads do
		Conn:Disconnect()
	end
	Clear(self.Threads)
	if self.ChamsFolder then
		pcall(function() self.ChamsFolder:Destroy() end)
		self.ChamsFolder = nil
	end
	Clear(self.Cache)
	Clear(self.PlayerChams)
	if rawget(getgenv(), "ESP") == self then
		getgenv().ESP = nil
	end
end
do
	local function bindCharsFolder(folder)
		if not folder then return end
		folder.ChildAdded:Connect(function(child)
			if not child:IsA("Model") then return end
			local plr = Players:FindFirstChild(child.Name)
			if plr and plr ~= LocalPlayer then
				task.defer(function()
					if not Library.Cache[plr] then Library:AddTarget(plr) end
					local Data = Library.Cache[plr]
					if Data and Data.TryBind then pcall(Data.TryBind) end
				end)
			end
		end)
	end
	local cf = Workspace:FindFirstChild("Characters")
	if cf then
		bindCharsFolder(cf)
	else
		Workspace.ChildAdded:Connect(function(c)
			if c.Name == "Characters" then bindCharsFolder(c) end
		end)
	end
end
getgenv().ESP = Library
return Library
