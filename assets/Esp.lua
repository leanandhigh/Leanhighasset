if getgenv().Library and getgenv().Library.Unload then
    pcall(getgenv().Library.Unload, getgenv().Library)
end

local GetService = setmetatable({}, {
    __index = function(_, Name)
        return game:GetService(Name)
    end,
})

local Workspace, Players, RunService, HttpService = GetService["Workspace"], GetService["Players"], GetService["RunService"], GetService["HttpService"]
local LocalPlayer, Camera = Players.LocalPlayer, Workspace.CurrentCamera
local WorldToViewportPoint, FindFirstChildOfClass, FindFirstChild = Camera.WorldToViewportPoint, game.FindFirstChildOfClass, game.FindFirstChild

local NewVector3, NewVector2, Dim, Dim2, DimOffset = Vector3.new, Vector2.new, UDim.new, UDim2.new, UDim2.fromOffset
local NumSeq = NumberSequence.new
local NumKey = NumberSequenceKeypoint.new

local Format, Clear, Floor, Clamp, Abs, Tan, Rad, Huge, Remove = string.format, table.clear, math.floor, math.clamp, math.abs, math.tan, math.rad, math.huge, table.remove
local Frame, ZeroVector3, CameraPosition, ViewPortY, Updates = 1 / 60, NewVector3(0, 0, 0), NewVector3(0, 0, 0), 0, 0
local CachedFocalLength = 0

local function CameraCache()
    ViewPortY = Camera.ViewportSize.Y
    CachedFocalLength = ViewPortY / (2 * Tan(Rad(Camera.FieldOfView) * 0.5))
end

CameraCache()
Camera:GetPropertyChangedSignal("FieldOfView"):Connect(CameraCache)
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(CameraCache)

getgenv().Library = {
    Directory = "Esp",
    Cache = {},
    Holder = nil,
    Threads = {},
    Connections = {},
    ChamsFolder = nil,
    PlayerChams = {},

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
            ["Box Glow"] = {
                Enabled = true,
                Top = Color3.fromRGB(255, 255, 255),
                Bot = Color3.fromRGB(255, 255, 255),
                Transparency = {0.9, 0.9},
            },
            Gradients = {
                Top = Color3.fromRGB(255, 255, 255),
                Bot = Color3.fromRGB(255, 255, 255),
            },
            Filled = {
                Enabled = true,
                Top = Color3.fromRGB(255, 255, 255),
                Bot = Color3.fromRGB(255, 255, 255),
                Transparency = {1, 0.8},
            },
        },

        Bars = {
            ["Health Bar"] = {
                Enabled = true,
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
            },
            Distance = {
                Enabled = true,
                Color = Color3.fromRGB(255, 255, 255),
            },
            Weapon = {
                Enabled = true,
                Color = Color3.fromRGB(255, 255, 255),
            },
        },

        Chams = {
            Enabled = true,
            FillColor = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            FillTransparency = 0.61,
            OutlineTransparency = 0.21,
            Shading = Enum.AdornShading.Default,
            ShadingOutline = Enum.AdornShading.Default,
        },

        OOV = {
            Enabled = true,
            Color = Color3.fromRGB(0, 255, 255),
            Shape = "Chevron",
            Size = 18,
            DynamicSize = true,
            MinSize = 12,
            MaxSize = 22,
            Radius = 0.35,
            DynamicRadius = true,
            MinRadius = 0.18,
            MaxRadius = 0.42,
            Limit = 6,
            ShowName = true,
            ShowDistance = true,
            ShowWeapon = true,
            ShowHealth = true,
            Blink = false,
            BlinkSpeed = 4,
        },

        Skeleton = {
            Enabled = false,
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1.5,
            Transparency = 0,
        },
    },
}

local Table = Library.Table
local OutlineOffset = Vector3.new(0.09, 0.09, 0.09)
local InlineOffset = Vector3.new(-0.05, -0.05, -0.05)

local function GetBodyParts(Character)
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

local Fonts = {}
do
    local function FontsRegister(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end
        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end
        local Info = {
            name = Name,
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }
        writefile(Name .. ".font", HttpService:JSONEncode(Info))
        return getcustomasset(Name .. ".font")
    end

    Fonts.Tahoma = FontsRegister("Tahoma", 400, "Normal", {
        Id = "Tahoma.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"),
    })
    Fonts.XPTahoma = FontsRegister("XPTahoma", 400, "Normal", {
        Id = "Tahoma8PTBOLD.ttf",
        Font = game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF"),
    })
    Fonts.SmallestPixel = FontsRegister("SmallestPixel", 400, "Normal", {
        Id = "smallest_pixel-7.ttf",
        Font = game:HttpGet("https://raw.githubusercontent.com/sametexe001/luas/main/smallest_pixel-7.ttf"),
    })
    Fonts.ProggyClean = FontsRegister("ProggyClean", 400, "Normal", {
        Id = "ProggyClean.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/main/fonts/ProggyClean.ttf"),
    })

    Library.ProggyTiny = Font.new(Fonts.ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Library.TahomaBold = Font.new(Fonts.XPTahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Library.ProggyClean = Font.new(Fonts.ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Library.Tahoma = Font.new(Fonts.Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Library.SmallestPixel = Font.new(Fonts.SmallestPixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

Library.__index = Library

function Library:CreateObjects(Name, Prop)
    local New = Instance.new(Name)
    for Property, Value in Prop or {} do
        New[Property] = Value
    end
    return New
end

function Library:CreateThreads(Name, Signal, Callback)
    local Connection = Signal:Connect(Callback)
    self.Threads[Name] = Connection
    return Connection
end

Library.Holder = Library:CreateObjects("ScreenGui", {
    Name = "\n",
    Parent = gethui(),
    ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    ResetOnSpawn = false,
    DisplayOrder = 10000,
    IgnoreGuiInset = true,
})

Library.ChamsFolder = Library:CreateObjects("Folder", {
    Name = "Chams",
    Parent = Library.Holder,
})

function Library:BuildChamsForPlayer(Player)
    local PlayerChams = self.PlayerChams
    if PlayerChams[Player] then
        for _, data in ipairs(PlayerChams[Player]) do
            pcall(function()
                data[1]:Destroy()
            end)
        end
    end

    local Character = Player.Character
    local Parts = GetBodyParts(Character)
    local list = {}
    local S = Table.Chams

    for _, Part in ipairs(Parts) do
        local IsHead = Part.Name == "Head"
        for i = 1, 2 do
            local IsOutline = i == 1
            local adorn = Instance.new(IsHead and "CylinderHandleAdornment" or "BoxHandleAdornment")
            adorn.AlwaysOnTop = true
            adorn.ZIndex = IsOutline and -1 or 1
            adorn.Transparency = IsOutline and S.OutlineTransparency or S.FillTransparency
            adorn.AdornCullingMode = Enum.AdornCullingMode.Never
            adorn.Color3 = IsOutline and S.OutlineColor or S.FillColor
            adorn.Shading = IsOutline and (S.ShadingOutline or Enum.AdornShading.Default) or (S.Shading or Enum.AdornShading.Default)
            adorn.Visible = false
            adorn.Parent = self.ChamsFolder
            if IsHead then
                adorn.CFrame = CFrame.Angles(math.pi / 2, 0, 0)
            end
            list[#list + 1] = {adorn, Part, IsOutline}
        end
    end
    PlayerChams[Player] = list
end

function Library:UpdateChams(Player, Data)
    local S = Table.Chams
    local Character = Data.Character or Player.Character
    local PlayerChams = self.PlayerChams

    if not PlayerChams[Player] then
        self:BuildChamsForPlayer(Player)
    end

    local list = PlayerChams[Player]
    if not list then
        return
    end

    local enabled = S.Enabled
        and Table.Enabled
        and Character ~= nil
        and Data.RootPart ~= nil
        and Data.Alive
        and (CameraPosition - Data.RootPart.Position).Magnitude <= Table.Distance

    local CurrentParts = GetBodyParts(Character)
    if #list ~= #CurrentParts * 2 then
        self:BuildChamsForPlayer(Player)
        list = PlayerChams[Player]
    end

    for _, data in ipairs(list) do
        local adorn, Part, IsOutline = data[1], data[2], data[3]
        if not enabled or not Character or not Part or not Part.Parent then
            adorn.Adornee = nil
            adorn.Visible = false
            continue
        end

        local IsHead = Part.Name == "Head"
        local Size = Part.Size
        if IsHead then
            adorn.Height = Size.Y + 0.35
            adorn.Radius = (Size.X / 2) + (IsOutline and 0.15 or 0.05)
        else
            adorn.Size = Size + (IsOutline and OutlineOffset or InlineOffset)
        end

        adorn.Adornee = Part
        adorn.Visible = true
        adorn.Shading = IsOutline and (S.ShadingOutline or Enum.AdornShading.Default) or (S.Shading or Enum.AdornShading.Default)
        if IsOutline then
            adorn.Color3 = S.OutlineColor
            adorn.Transparency = S.OutlineTransparency
        else
            adorn.Color3 = S.FillColor
            adorn.Transparency = S.FillTransparency
        end
    end
end

function Library:ClearChamsForPlayer(Player)
    local list = self.PlayerChams[Player]
    if not list then
        return
    end
    for _, data in ipairs(list) do
        pcall(function()
            data[1].Adornee = nil
            data[1].Visible = false
            data[1]:Destroy()
        end)
    end
    self.PlayerChams[Player] = nil
end

function Library:DestroyDrawings(Objects)
    if not Objects then
        return
    end
    for _, key in ipairs({"OOVArrow", "OOVArrowOutline", "OOVQuad", "OOVQuadOutline"}) do
        if Objects[key] then
            pcall(function()
                Objects[key].Visible = false
                Objects[key]:Remove()
            end)
            Objects[key] = nil
        end
    end
    if Objects.Skeleton then
        for _, bone in ipairs(Objects.Skeleton) do
            pcall(function()
                bone.Line.Visible = false
                bone.Line:Remove()
            end)
        end
        Objects.Skeleton = nil
    end
end

function Library:HideAllVisuals(Data)
    local Objects = Data and Data.Objects
    if not Objects then
        return
    end
    if Objects.TargetHolder then
        Objects.TargetHolder.Visible = false
    end
    if Objects.OOVArrow then
        Objects.OOVArrow.Visible = false
    end
    if Objects.OOVArrowOutline then
        Objects.OOVArrowOutline.Visible = false
    end
    if Objects.OOVQuad then
        Objects.OOVQuad.Visible = false
    end
    if Objects.OOVQuadOutline then
        Objects.OOVQuadOutline.Visible = false
    end
    if Objects.OOVName then
        Objects.OOVName.Visible = false
    end
    if Objects.OOVDistance then
        Objects.OOVDistance.Visible = false
    end
    if Objects.OOVWeapon then
        Objects.OOVWeapon.Visible = false
    end
    if Objects.OOVHealthOutline then
        Objects.OOVHealthOutline.Visible = false
    end
    if Objects.OOVHealthText then
        Objects.OOVHealthText.Visible = false
    end
    if Objects.Skeleton then
        for _, bone in ipairs(Objects.Skeleton) do
            bone.Line.Visible = false
        end
    end
end

function Library:InitEsp(Data)
    local Objects = Data.Objects

    Objects.OOVArrow = CreateDrawing("Triangle", {
        Visible = false,
        Filled = true,
        Thickness = 1,
        Color = Table.OOV.Color,
        Transparency = 1,
        ZIndex = 3,
    })

    Objects.OOVArrowOutline = CreateDrawing("Triangle", {
        Visible = false,
        Filled = false,
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 1,
        ZIndex = 2,
    })

    Objects.OOVQuad = CreateDrawing("Quad", {
        Visible = false,
        Filled = true,
        Thickness = 1,
        Color = Table.OOV.Color,
        Transparency = 1,
        ZIndex = 3,
    })

    Objects.OOVQuadOutline = CreateDrawing("Quad", {
        Visible = false,
        Filled = false,
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 1,
        ZIndex = 2,
    })

    Objects.OOVName = self:CreateObjects("TextLabel", {
        Parent = self.Holder,
        FontFace = Library.TahomaBold,
        TextSize = 11,
        TextColor3 = Table.OOV.Color,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = NewVector2(0.5, 1),
        ZIndex = 51,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.OOVName,
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.OOVDistance = self:CreateObjects("TextLabel", {
        Parent = self.Holder,
        FontFace = Library.SmallestPixel,
        TextSize = 10,
        TextColor3 = Table.OOV.Color,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = NewVector2(0.5, 0),
        ZIndex = 51,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.OOVDistance,
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.OOVWeapon = self:CreateObjects("TextLabel", {
        Parent = self.Holder,
        FontFace = Library.SmallestPixel,
        TextSize = 10,
        TextColor3 = Table.OOV.Color,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = NewVector2(0.5, 0),
        ZIndex = 51,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.OOVWeapon,
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.OOVHealthOutline = self:CreateObjects("Frame", {
        Parent = self.Holder,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Visible = false,
        Size = DimOffset(3, 20),
        AnchorPoint = NewVector2(1, 0.5),
        ZIndex = 50,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.OOVHealthOutline,
        Thickness = 1,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.OOVHealthBar = self:CreateObjects("Frame", {
        Parent = Objects.OOVHealthOutline,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        AnchorPoint = NewVector2(0, 1),
        Position = Dim2(0, 0, 1, 0),
        Size = Dim2(1, 0, 1, 0),
        ZIndex = 51,
    })
    Objects.OOVHealthGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.OOVHealthBar,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Table.Bars["Health Bar"].Top),
            ColorSequenceKeypoint.new(0.5, Table.Bars["Health Bar"].Mid),
            ColorSequenceKeypoint.new(1, Table.Bars["Health Bar"].Bot),
        }),
    })

    Objects.OOVHealthText = self:CreateObjects("TextLabel", {
        Parent = self.Holder,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Right,
        TextYAlignment = Enum.TextYAlignment.Center,
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = NewVector2(1, 0.5),
        ZIndex = 52,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.OOVHealthText,
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.Skeleton = {}
    local SkeletonJoints = {
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
    for i = 1, #SkeletonJoints do
        Objects.Skeleton[i] = {
            Line = CreateDrawing("Line", {
                Visible = false,
                Thickness = Table.Skeleton.Thickness,
                Color = Table.Skeleton.Color,
                Transparency = 1 - Table.Skeleton.Transparency,
                ZIndex = 1,
            }),
            From = SkeletonJoints[i][1],
            To = SkeletonJoints[i][2],
        }
    end

    Objects.TargetHolder = self:CreateObjects("Frame", {
        Parent = self.Holder,
        Visible = false,
        BackgroundTransparency = 1,
        Position = Dim2(0, 0, 0, 0),
        Size = Dim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects.TopHolder = self:CreateObjects("Frame", {
        Parent = Objects.TargetHolder,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        AnchorPoint = NewVector2(0, 1),
        Position = Dim2(0, -2, 0, -5),
        Size = Dim2(1, 4, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.BottomHolder = self:CreateObjects("Frame", {
        Parent = Objects.TargetHolder,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = Dim2(0, -2, 1, 3),
        Size = Dim2(1, 4, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.LeftHolder = self:CreateObjects("Frame", {
        Parent = Objects.TargetHolder,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        AnchorPoint = NewVector2(1, 0),
        Position = Dim2(0, -5, 0, -2),
        Size = Dim2(0, 0, 1, 4),
        BorderSizePixel = 0,
    })
    Objects.RightHolder = self:CreateObjects("Frame", {
        Parent = Objects.TargetHolder,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Position = Dim2(1, 5, 0, -2),
        Size = Dim2(0, 0, 1, 4),
        BorderSizePixel = 0,
    })

    Objects.TopTextHolder = self:CreateObjects("Frame", {
        Parent = Objects.TopHolder,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = Dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.BottomTextHolder = self:CreateObjects("Frame", {
        Parent = Objects.BottomHolder,
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = Dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.LeftTextHolder = self:CreateObjects("Frame", {
        Parent = Objects.LeftHolder,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Size = Dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.RightTextHolder = self:CreateObjects("Frame", {
        Parent = Objects.RightHolder,
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Size = Dim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects.LeftBarHolder = self:CreateObjects("Frame", {
        Parent = Objects.LeftHolder,
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = false,
        BackgroundTransparency = 1,
        Size = Dim2(0, 0, 1, 0),
        BorderSizePixel = 0,
    })
    Objects.BottomBarHolder = self:CreateObjects("Frame", {
        Parent = Objects.BottomHolder,
        LayoutOrder = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        BackgroundTransparency = 1,
        Size = Dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects.TopTextHolder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = Dim(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.BottomTextHolder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = Dim(0, -1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.LeftTextHolder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = Dim(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.RightTextHolder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = Dim(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.LeftBarHolder,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = Dim(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.BottomBarHolder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = Dim(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.TopHolder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = Dim(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.BottomHolder,
        Padding = Dim(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.LeftHolder,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = Dim(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    self:CreateObjects("UIListLayout", {
        Parent = Objects.RightHolder,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = Dim(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIPadding", {Parent = Objects.TopTextHolder, PaddingBottom = Dim(0, 0)})
    self:CreateObjects("UIPadding", {Parent = Objects.BottomTextHolder, PaddingTop = Dim(0, -1)})
    self:CreateObjects("UIPadding", {Parent = Objects.LeftTextHolder, PaddingTop = Dim(0, -3)})
    self:CreateObjects("UIPadding", {Parent = Objects.RightTextHolder, PaddingTop = Dim(0, -3)})
    self:CreateObjects("UIPadding", {Parent = Objects.LeftBarHolder, PaddingRight = Dim(0, 0)})
    self:CreateObjects("UIPadding", {Parent = Objects.BottomBarHolder, PaddingTop = Dim(0, 2)})
    self:CreateObjects("UIPadding", {Parent = Objects.LeftHolder, PaddingRight = Dim(0, 1)})

    Objects.BoxGlow = self:CreateObjects("ImageLabel", {
        Parent = Objects.TargetHolder,
        Image = "rbxassetid://110204605000367",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(NewVector2(21, 21), NewVector2(79, 79)),
        AutomaticSize = Enum.AutomaticSize.XY,
        ImageTransparency = 0.65,
        ResampleMode = Enum.ResamplerMode.Pixelated,
        BackgroundTransparency = 1,
        Position = Dim2(0, -21, 0, -21),
        Size = Dim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.BoxGlowGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.BoxGlow,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        }),
        Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
    })
    self:CreateObjects("UIPadding", {
        Parent = Objects.BoxGlow,
        PaddingTop = Dim(0, 21),
        PaddingBottom = Dim(0, 20),
        PaddingLeft = Dim(0, 21),
        PaddingRight = Dim(0, 20),
    })

    Objects.BoxOutlineHolder = self:CreateObjects("Frame", {
        Parent = Objects.BoxGlow,
        Visible = false,
        BackgroundTransparency = 1,
        Size = Dim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.BoxOutline = self:CreateObjects("UIStroke", {
        Parent = Objects.BoxOutlineHolder,
        Thickness = 3,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })
    Objects.BoxOutlineGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.BoxOutline,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        }),
        Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
    })

    Objects.BoxInlineHolder = self:CreateObjects("Frame", {
        Parent = Objects.BoxGlow,
        Visible = false,
        BackgroundTransparency = 1,
        Position = Dim2(0, -1, 0, -1),
        Size = Dim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.BoxInline = self:CreateObjects("UIStroke", {
        Parent = Objects.BoxInlineHolder,
        Color = Color3.fromRGB(255, 255, 255),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })
    Objects.BoxInlineGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.BoxInline,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        }),
        Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
    })

    Objects.BoxFill = self:CreateObjects("Frame", {
        Parent = Objects.BoxGlow,
        Visible = false,
        BackgroundTransparency = 0,
        Size = Dim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })
    Objects.BoxFillGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.BoxFill,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        }),
        Transparency = NumSeq({NumKey(0, 1), NumKey(1, 1)}),
    })

    Objects.HealthBarOutline = self:CreateObjects("Frame", {
        Parent = Objects.LeftBarHolder,
        ZIndex = 5,
        LayoutOrder = 0,
        Visible = false,
        BackgroundTransparency = 0,
        Size = Dim2(0, 1, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.HealthBarOutline,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })
    Objects.HealthBar = self:CreateObjects("Frame", {
        Parent = Objects.HealthBarOutline,
        ZIndex = 6,
        AnchorPoint = NewVector2(0, 1),
        Position = Dim2(0, 0, 1, 0),
        Size = Dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ClipsDescendants = true,
    })
    Objects.HealthBarGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.HealthBar,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Table.Bars["Health Bar"].Top),
            ColorSequenceKeypoint.new(0.5, Table.Bars["Health Bar"].Mid),
            ColorSequenceKeypoint.new(1, Table.Bars["Health Bar"].Bot),
        }),
        Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
    })
    Objects.HealthBarText = self:CreateObjects("TextLabel", {
        Parent = Objects.HealthBarOutline,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        ZIndex = 10,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        AnchorPoint = NewVector2(0.5, 0.5),
        Position = Dim2(0.5, 0, 1, 0),
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.HealthBarText,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.ArmorBarOutline = self:CreateObjects("Frame", {
        Parent = Objects.BottomBarHolder,
        ZIndex = 5,
        LayoutOrder = 0,
        Visible = false,
        BackgroundTransparency = 0,
        Size = Dim2(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        ClipsDescendants = true,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.ArmorBarOutline,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })
    Objects.ArmorBar = self:CreateObjects("Frame", {
        Parent = Objects.ArmorBarOutline,
        ZIndex = 6,
        Size = Dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    })
    Objects.ArmorBarGradient = self:CreateObjects("UIGradient", {
        Parent = Objects.ArmorBar,
        Rotation = 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Table.Bars["Armor Bar"].Top),
            ColorSequenceKeypoint.new(0.5, Table.Bars["Armor Bar"].Mid),
            ColorSequenceKeypoint.new(1, Table.Bars["Armor Bar"].Bot),
        }),
        Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
    })
    Objects.ArmorBarText = self:CreateObjects("TextLabel", {
        Parent = Objects.ArmorBar,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        ZIndex = 10,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        AnchorPoint = NewVector2(0.5, 0.5),
        Position = Dim2(0.5, 0, 0.5, 0),
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.ArmorBarText,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.TargetName = self:CreateObjects("TextLabel", {
        Parent = Objects.TopTextHolder,
        FontFace = Library.TahomaBold,
        TextSize = 12,
        LayoutOrder = 2,
        TextColor3 = Table.Texts.Name.Color,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.TargetName,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.Distance = self:CreateObjects("TextLabel", {
        Parent = Objects.BottomTextHolder,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        LayoutOrder = 2,
        TextColor3 = Table.Texts.Distance.Color,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.Distance,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.WalkFlag = self:CreateObjects("TextLabel", {
        Parent = Objects.RightTextHolder,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        LayoutOrder = 1,
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Text = "Walking",
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.WalkFlag,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.JumpFlag = self:CreateObjects("TextLabel", {
        Parent = Objects.RightTextHolder,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        LayoutOrder = 2,
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Text = "Jumping",
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.JumpFlag,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects.Weapon = self:CreateObjects("TextLabel", {
        Parent = Objects.BottomTextHolder,
        FontFace = Library.SmallestPixel,
        TextSize = 9,
        LayoutOrder = 3,
        TextColor3 = Table.Texts.Weapon.Color,
        Text = "none",
        TextXAlignment = Enum.TextXAlignment.Center,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    self:CreateObjects("UIStroke", {
        Parent = Objects.Weapon,
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })
end

function Library:CalculateBox(Data)
    local RootPart = Data.RootPart
    if not RootPart then
        return nil, nil, nil, nil, false
    end

    local RootScreen, OnScreen = WorldToViewportPoint(Camera, RootPart.Position)
    if not OnScreen then
        return nil, nil, nil, nil, false
    end

    local BoundingBox = Table.Boxes["Bounding Box"]
    if BoundingBox.Enabled then
        local Children = Data.Children
        if not Children then
            return nil, nil, nil, nil, false
        end

        local IncludeAccessories = Data.IncludeAccessories
        local ScrMinX, ScrMinY = Huge, Huge
        local ScrMaxX, ScrMaxY = -Huge, -Huge
        local HasValidParts = false

        for _, Part in Children do
            if Part:IsA("BasePart") and Part.Transparency ~= 1 and Part ~= RootPart then
                local Parent = Part.Parent
                if Parent == nil then
                    continue
                end
                if not IncludeAccessories and Parent:IsA("Accessory") then
                    continue
                end

                local PartScreen, PartOnScreen = WorldToViewportPoint(Camera, Part.Position)
                if not PartOnScreen or PartScreen.Z <= 0 then
                    continue
                end

                HasValidParts = true
                local Cf = Part.CFrame
                local Sz = Part.Size
                local HX, HY, HZ = Sz.X * 0.5, Sz.Y * 0.5, Sz.Z * 0.5
                local RX, UY, LZ = Cf.RightVector, Cf.UpVector, Cf.LookVector
                local DepthScale = CachedFocalLength / PartScreen.Z
                local Ex = (Abs(RX.X * HX) + Abs(UY.X * HY) + Abs(LZ.X * HZ)) * DepthScale
                local Ey = (Abs(RX.Y * HX) + Abs(UY.Y * HY) + Abs(LZ.Y * HZ)) * DepthScale
                local PMinX, PMaxX = PartScreen.X - Ex, PartScreen.X + Ex
                local PMinY, PMaxY = PartScreen.Y - Ey, PartScreen.Y + Ey

                if PMinX < ScrMinX then ScrMinX = PMinX end
                if PMaxX > ScrMaxX then ScrMaxX = PMaxX end
                if PMinY < ScrMinY then ScrMinY = PMinY end
                if PMaxY > ScrMaxY then ScrMaxY = PMaxY end
            end
        end

        if not HasValidParts then
            return nil, nil, nil, nil, false
        end

        local PadX = BoundingBox.BoxX
        local PadY = BoundingBox.BoxY
        local W = (ScrMaxX - ScrMinX) + PadX
        local H = (ScrMaxY - ScrMinY) + PadY
        return W, H, ScrMinX - (PadX * 0.5), ScrMinY - (PadY * 0.5), true
    else
        local Scale = (RootPart.Size.Y * ViewPortY) / (RootScreen.Z * 2)
        local W, H = 3 * Scale, 4.5 * Scale
        return W, H, RootScreen.X - (W * 0.5), RootScreen.Y - (H * 0.5), OnScreen
    end
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
        LastW = nil,
        LastH = nil,
        LastX = nil,
        LastY = nil,
        WalkActive = false,
        JumpActive = false,
        IncludeAccessories = Table.Boxes["Bounding Box"].IncludeAcsessories,
        LastGlowTop = nil,
        LastGlowBot = nil,
        LastGlowT1 = nil,
        LastGlowT2 = nil,
        LastGradTop = nil,
        LastGradBot = nil,
        LastFillTop = nil,
        LastFillBot = nil,
        LastFillT1 = nil,
        LastFillT2 = nil,
        LastDist = nil,
        LastDistColor = nil,
        LastDisplayName = nil,
        LastNameColor = nil,
        LastHealthTop = nil,
        LastHealthMid = nil,
        LastHealthBot = nil,
        LastHealthFloor = nil,
        LastRatio = nil,
        LastArmorTop = nil,
        LastArmorMid = nil,
        LastArmorBot = nil,
        LastArmorFloor = nil,
        LastArmorRatio = nil,
        LastWeapon = nil,
        LastWeaponColor = nil,
    }

    self:InitEsp(Data)
    self.Cache[Player] = Data
    self:BuildChamsForPlayer(Player)

    local function BindHealth(Humanoid)
        if Data.Conns.Health then
            Data.Conns.Health:Disconnect()
        end
        if Data.Conns.Died then
            Data.Conns.Died:Disconnect()
        end
        Data.Humanoid = Humanoid
        Data.Health = Humanoid.Health
        Data.MaxHealth = Humanoid.MaxHealth
        Data.Alive = Humanoid.Health > 0
        Data.Conns.Health = Humanoid.HealthChanged:Connect(function(NewHealth)
            Data.Alive = NewHealth > 0
            Data.Health = NewHealth
        end)
        Data.Conns.Died = Humanoid.Died:Connect(function()
            Data.Alive = false
        end)
    end
    Data.BindHealth = BindHealth

    local function BindTool(Character)
        if Data.Conns.ToolAdded then
            Data.Conns.ToolAdded:Disconnect()
        end
        if Data.Conns.ToolRemoved then
            Data.Conns.ToolRemoved:Disconnect()
        end
        if Data.Children then
            for _, Child in Data.Children do
                if Child:IsA("Tool") then
                    Data.CurrentTool = Child.Name
                    break
                end
            end
        end
        Data.Conns.ToolAdded = Character.ChildAdded:Connect(function(Child)
            if Child:IsA("Tool") then
                Data.CurrentTool = Child.Name
            end
        end)
        Data.Conns.ToolRemoved = Character.ChildRemoved:Connect(function(Child)
            if Child:IsA("Tool") then
                Data.CurrentTool = nil
            end
        end)
    end
    Data.BindTool = BindTool

    local function BindChildren(Character)
        if Data.Conns.ChildAdded then
            Data.Conns.ChildAdded:Disconnect()
        end
        if Data.Conns.ChildRemoved then
            Data.Conns.ChildRemoved:Disconnect()
        end
        local Children = Character:GetChildren()
        Data.Children = Children
        Data.Conns.ChildAdded = Character.ChildAdded:Connect(function(Child)
            Children[#Children + 1] = Child
        end)
        Data.Conns.ChildRemoved = Character.ChildRemoved:Connect(function(Child)
            for I = #Children, 1, -1 do
                if Children[I] == Child then
                    Remove(Children, I)
                    break
                end
            end
        end)
        Data.BindTool(Character)
    end
    Data.BindChildren = BindChildren

    local function BindFlags(Humanoid)
        if Data.Conns.MoveDir then
            Data.Conns.MoveDir:Disconnect()
        end
        if Data.Conns.StateChange then
            Data.Conns.StateChange:Disconnect()
        end
        local Objects = Data.Objects
        Data.JumpActive = false
        Data.WalkActive = false
        Objects.WalkFlag.Visible = false
        Objects.JumpFlag.Visible = false

        Data.Conns.MoveDir = Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
            local Walking = Humanoid.MoveDirection ~= ZeroVector3
            if Walking and not Data.WalkActive then
                Data.WalkActive = true
                if Data.JumpActive then
                    Objects.WalkFlag.LayoutOrder = 2
                else
                    Objects.WalkFlag.LayoutOrder = 1
                    Objects.JumpFlag.LayoutOrder = 2
                end
                Objects.WalkFlag.Visible = true
            elseif not Walking and Data.WalkActive then
                Data.WalkActive = false
                Objects.WalkFlag.Visible = false
                if Data.JumpActive then
                    Objects.JumpFlag.LayoutOrder = 1
                end
            end
        end)

        Data.Conns.StateChange = Humanoid.StateChanged:Connect(function(_, NewState)
            local Jumping = NewState == Enum.HumanoidStateType.Jumping or NewState == Enum.HumanoidStateType.Freefall
            if Jumping and not Data.JumpActive then
                Data.JumpActive = true
                if Data.WalkActive then
                    Objects.JumpFlag.LayoutOrder = 2
                else
                    Objects.JumpFlag.LayoutOrder = 1
                    Objects.WalkFlag.LayoutOrder = 2
                end
                Objects.JumpFlag.Visible = true
            elseif not Jumping and Data.JumpActive then
                Data.JumpActive = false
                Objects.JumpFlag.Visible = false
                if Data.WalkActive then
                    Objects.WalkFlag.LayoutOrder = 1
                end
            end
        end)
    end
    Data.BindFlags = BindFlags

    local function OnCharacter(Character)
        Data.Character = Character
        Data.RootPart = nil
        Data.Humanoid = nil
        Data.Children = nil
        Data.Alive = false
        Data.WalkActive = false
        Data.JumpActive = false
        self:HideAllVisuals(Data)

        if not Character or not Character.Parent then
            return
        end

        local RootPart = FindFirstChild(Character, "HumanoidRootPart")
        if not RootPart then
            RootPart = Character:WaitForChild("HumanoidRootPart", 10)
        end
        local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
        if not Humanoid then
            Humanoid = Character:WaitForChild("Humanoid", 10)
        end
        if not RootPart or not Humanoid or not Character.Parent then
            return
        end

        Data.RootPart = RootPart
        Data.Humanoid = Humanoid
        Data.BindChildren(Character)
        Data.BindHealth(Humanoid)
        Data.BindFlags(Humanoid)
        self:BuildChamsForPlayer(Player)
    end

    Data.Conns.CharAdded = Player.CharacterAdded:Connect(function(Character)
        task.defer(OnCharacter, Character)
    end)
    if Player.Character and Player.Character.Parent then
        task.defer(OnCharacter, Player.Character)
    end
end

function Library:RemoveTarget(Player)
    local Data = self.Cache[Player]
    if not Data then
        return
    end

    for _, Conn in Data.Conns do
        pcall(function()
            Conn:Disconnect()
        end)
    end
    Clear(Data.Conns)

    self:HideAllVisuals(Data)
    self:DestroyDrawings(Data.Objects)

    if Data.Objects.TargetHolder then
        pcall(function()
            Data.Objects.TargetHolder:Destroy()
        end)
    end
    if Data.Objects.OOVName then
        pcall(function()
            Data.Objects.OOVName:Destroy()
        end)
    end
    if Data.Objects.OOVDistance then
        pcall(function()
            Data.Objects.OOVDistance:Destroy()
        end)
    end
    if Data.Objects.OOVWeapon then
        pcall(function()
            Data.Objects.OOVWeapon:Destroy()
        end)
    end
    if Data.Objects.OOVHealthOutline then
        pcall(function()
            Data.Objects.OOVHealthOutline:Destroy()
        end)
    end
    if Data.Objects.OOVHealthText then
        pcall(function()
            Data.Objects.OOVHealthText:Destroy()
        end)
    end

    Clear(Data.Objects)
    self:ClearChamsForPlayer(Player)
    self.Cache[Player] = nil
end

function Library:Update(Player, Data)
    local Objects = Data.Objects

    if not Data.RootPart or not Data.Alive then
        self:HideAllVisuals(Data)
        self:UpdateChams(Player, Data)
        return
    end

    local RootPos = Data.RootPart.Position
    local Distance = Floor((CameraPosition - RootPos).Magnitude)

    if Distance > Table.Distance then
        self:HideAllVisuals(Data)
        self:UpdateChams(Player, Data)
        return
    end

    local W, H, X, Y, OnScreen = self:CalculateBox(Data)

    if not OnScreen or not W then
        if Objects.TargetHolder then
            Objects.TargetHolder.Visible = false
        end
        if Objects.Skeleton then
            for _, bone in ipairs(Objects.Skeleton) do
                bone.Line.Visible = false
            end
        end

        local OOV = Table.OOV
        local oovAllowed = Library.OOVAllowed and Library.OOVAllowed[Player]
        if OOV.Enabled and oovAllowed then
            local Viewport = Camera.ViewportSize
            local cx, cy = Viewport.X * 0.5, Viewport.Y * 0.5

            local screenPos = WorldToViewportPoint(Camera, RootPos)
            local sx, sy = screenPos.X, screenPos.Y
            if screenPos.Z < 0 then
                sx = Viewport.X - sx
                sy = Viewport.Y - sy
            end

            local dx, dy = sx - cx, sy - cy
            local len = math.sqrt(dx * dx + dy * dy)
            if len < 0.001 then
                dx, dy, len = 0, -1, 1
            end
            local Direction = NewVector2(dx / len, dy / len)

            local DynamicRange = 150
            local t = Clamp(Distance / DynamicRange, 0, 1)

            local Radius
            if OOV.DynamicRadius == true then
                Radius = OOV.MinRadius + (OOV.MaxRadius - OOV.MinRadius) * t
            else
                Radius = OOV.Radius
            end

            local Size
            if OOV.DynamicSize == true then
                Size = OOV.MaxSize - (OOV.MaxSize - OOV.MinSize) * t
            else
                Size = OOV.Size
            end

            local Edge = math.min(Viewport.X, Viewport.Y) * Radius
            local Tip = NewVector2(
                Clamp(cx + Direction.X * Edge, Size + 2, Viewport.X - Size - 2),
                Clamp(cy + Direction.Y * Edge, Size + 2, Viewport.Y - Size - 2)
            )

            local function Rotate(dir, rad)
                local c, s = math.cos(rad), math.sin(rad)
                return NewVector2(dir.X * c - dir.Y * s, dir.X * s + dir.Y * c)
            end

            local Alpha = 1
            if OOV.Blink then
                Alpha = (math.sin(os.clock() * OOV.BlinkSpeed) + 1) * 0.5
            end

            local Out = Direction
            local PointTip = Tip
            local PointTail = Tip - Out * Size
            local Wing = Size * 0.5
            local PointL = PointTip - Out * (Size * 0.35) + Rotate(Out, 1.35) * Wing
            local PointR = PointTip - Out * (Size * 0.35) + Rotate(Out, -1.35) * Wing

            Objects.OOVArrow.Visible = false
            Objects.OOVArrowOutline.Visible = false
            Objects.OOVQuadOutline.Visible = false

            local Quad = Objects.OOVQuad
            Quad.PointA = PointTip
            Quad.PointB = PointL
            Quad.PointC = PointTail
            Quad.PointD = PointR
            Quad.Filled = true
            Quad.Color = OOV.Color
            Quad.Transparency = Alpha
            Quad.Visible = true

            local CenterX = (PointTip.X + PointL.X + PointTail.X + PointR.X) * 0.25
            local CenterY = (PointTip.Y + PointL.Y + PointTail.Y + PointR.Y) * 0.25

            if OOV.ShowName then
                local NameText = (Table.Texts.Name.Type == "Name") and Player.Name or Player.DisplayName
                Objects.OOVName.FontFace = Library.TahomaBold
                Objects.OOVName.TextSize = 11
                Objects.OOVName.Text = NameText
                Objects.OOVName.TextColor3 = OOV.Color
                Objects.OOVName.TextTransparency = 1 - Alpha
                Objects.OOVName.Position = DimOffset(CenterX, CenterY - Size * 0.95 - 6)
                Objects.OOVName.Visible = true
            else
                Objects.OOVName.Visible = false
            end

            local OffsetY = Size * 0.95 + 8

            if OOV.ShowDistance then
                Objects.OOVDistance.TextSize = 9
                Objects.OOVDistance.Text = Format("%dst", Distance)
                Objects.OOVDistance.TextColor3 = OOV.Color
                Objects.OOVDistance.TextTransparency = 1 - Alpha
                Objects.OOVDistance.Position = DimOffset(CenterX, CenterY + OffsetY)
                Objects.OOVDistance.Visible = true
                OffsetY = OffsetY + 14
            else
                Objects.OOVDistance.Visible = false
            end

            if OOV.ShowWeapon then
                Objects.OOVWeapon.TextSize = 9
                Objects.OOVWeapon.Text = Data.CurrentTool or "none"
                Objects.OOVWeapon.TextColor3 = OOV.Color
                Objects.OOVWeapon.TextTransparency = 1 - Alpha
                Objects.OOVWeapon.Position = DimOffset(CenterX, CenterY + OffsetY)
                Objects.OOVWeapon.Visible = true
            else
                Objects.OOVWeapon.Visible = false
            end

            if OOV.ShowHealth then
                local Health = Data.Health or 0
                local MaxHealth = Data.MaxHealth or 100
                local Ratio = Clamp(Health / MaxHealth, 0, 1)
                local BarH = math.max(Size * 1.2, 14)

                Objects.OOVHealthOutline.Size = DimOffset(3, BarH)
                Objects.OOVHealthOutline.AnchorPoint = NewVector2(1, 0.5)
                Objects.OOVHealthOutline.Position = DimOffset(CenterX - Size * 0.95 - 10, CenterY)
                Objects.OOVHealthOutline.BackgroundTransparency = 1 - Alpha
                Objects.OOVHealthBar.Size = Dim2(1, 0, Ratio, 0)
                Objects.OOVHealthBar.BackgroundTransparency = 1 - Alpha
                Objects.OOVHealthGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Table.Bars["Health Bar"].Top),
                    ColorSequenceKeypoint.new(0.5, Table.Bars["Health Bar"].Mid),
                    ColorSequenceKeypoint.new(1, Table.Bars["Health Bar"].Bot),
                })
                Objects.OOVHealthOutline.Visible = true

                Objects.OOVHealthText.Text = Format("%d", Floor(Health))
                Objects.OOVHealthText.TextTransparency = 1 - Alpha
                Objects.OOVHealthText.AnchorPoint = NewVector2(1, 0.5)
                Objects.OOVHealthText.Position = DimOffset(CenterX - Size * 0.95 - 14, CenterY + (BarH * 0.5) - (BarH * Ratio))
                Objects.OOVHealthText.Visible = true
            else
                Objects.OOVHealthOutline.Visible = false
                Objects.OOVHealthText.Visible = false
            end
        else
            self:HideAllVisuals(Data)
        end

        self:UpdateChams(Player, Data)
        return
    end

    if Objects.OOVArrow then
        Objects.OOVArrow.Visible = false
    end
    if Objects.OOVArrowOutline then
        Objects.OOVArrowOutline.Visible = false
    end
    if Objects.OOVQuad then
        Objects.OOVQuad.Visible = false
    end
    if Objects.OOVQuadOutline then
        Objects.OOVQuadOutline.Visible = false
    end
    if Objects.OOVName then
        Objects.OOVName.Visible = false
    end
    if Objects.OOVDistance then
        Objects.OOVDistance.Visible = false
    end
    if Objects.OOVWeapon then
        Objects.OOVWeapon.Visible = false
    end
    if Objects.OOVHealthOutline then
        Objects.OOVHealthOutline.Visible = false
    end
    if Objects.OOVHealthText then
        Objects.OOVHealthText.Visible = false
    end

    W = Floor(W)
    H = Floor(H)
    X = Floor(X)
    Y = Floor(Y)

    if not Objects.TargetHolder.Visible then
        Objects.TargetHolder.Visible = true
    end

    local DirtySizes = Data.LastW ~= W or Data.LastH ~= H
    local DirtyPosition = Data.LastX ~= X or Data.LastY ~= Y

    if DirtyPosition then
        Objects.TargetHolder.Position = DimOffset(X, Y)
        Data.LastX = X
        Data.LastY = Y
    end

    if DirtySizes then
        Objects.TargetHolder.Size = DimOffset(W, H)
        Objects.BoxGlow.Size = DimOffset(W, H)
        Objects.BoxOutlineHolder.Size = DimOffset(W, H)
        Objects.BoxInlineHolder.Size = DimOffset(W + 2, H + 2)
        Objects.BoxFill.Size = DimOffset(W, H)
        Data.LastW = W
        Data.LastH = H
    end

    local BoxesCfg = Table.Boxes
    local TextsCfg = Table.Texts

    if BoxesCfg.Enabled then
        if BoxesCfg["Box Glow"].Enabled then
            if Objects.BoxGlow.ImageTransparency ~= 0 then
                Objects.BoxGlow.ImageTransparency = 0
            end
            local GlowTop = BoxesCfg["Box Glow"].Top
            local GlowBot = BoxesCfg["Box Glow"].Bot
            if Data.LastGlowTop ~= GlowTop or Data.LastGlowBot ~= GlowBot then
                Objects.BoxGlowGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, GlowTop),
                    ColorSequenceKeypoint.new(1, GlowBot),
                })
                Data.LastGlowTop = GlowTop
                Data.LastGlowBot = GlowBot
            end
            local T1 = BoxesCfg["Box Glow"].Transparency[1]
            local T2 = BoxesCfg["Box Glow"].Transparency[2]
            if Data.LastGlowT1 ~= T1 or Data.LastGlowT2 ~= T2 then
                Objects.BoxGlowGradient.Transparency = NumSeq({NumKey(0, T1), NumKey(1, T2)})
                Data.LastGlowT1 = T1
                Data.LastGlowT2 = T2
            end
        else
            if Objects.BoxGlow.ImageTransparency ~= 1 then
                Objects.BoxGlow.ImageTransparency = 1
            end
        end

        if not Objects.BoxOutlineHolder.Visible then
            Objects.BoxOutlineHolder.Visible = true
        end
        if not Objects.BoxInlineHolder.Visible then
            Objects.BoxInlineHolder.Visible = true
        end

        local GradTop = BoxesCfg.Gradients.Top
        local GradBot = BoxesCfg.Gradients.Bot
        if Data.LastGradTop ~= GradTop or Data.LastGradBot ~= GradBot then
            Objects.BoxInlineGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, GradTop),
                ColorSequenceKeypoint.new(1, GradBot),
            })
            Data.LastGradTop = GradTop
            Data.LastGradBot = GradBot
        end

        if BoxesCfg.Filled.Enabled then
            if not Objects.BoxFill.Visible then
                Objects.BoxFill.Visible = true
            end
            local FillTop = BoxesCfg.Filled.Top
            local FillBot = BoxesCfg.Filled.Bot
            local FillT1 = BoxesCfg.Filled.Transparency[1]
            local FillT2 = BoxesCfg.Filled.Transparency[2]
            if Data.LastFillTop ~= FillTop or Data.LastFillBot ~= FillBot then
                Objects.BoxFillGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, FillTop),
                    ColorSequenceKeypoint.new(1, FillBot),
                })
                Data.LastFillTop = FillTop
                Data.LastFillBot = FillBot
            end
            if Data.LastFillT1 ~= FillT1 or Data.LastFillT2 ~= FillT2 then
                Objects.BoxFillGradient.Transparency = NumSeq({NumKey(0, FillT1), NumKey(1, FillT2)})
                Data.LastFillT1 = FillT1
                Data.LastFillT2 = FillT2
            end
        else
            if Objects.BoxFill.Visible then
                Objects.BoxFill.Visible = false
            end
        end
    else
        if Objects.BoxGlow.ImageTransparency ~= 1 then
            Objects.BoxGlow.ImageTransparency = 1
        end
        if Objects.BoxOutlineHolder.Visible then
            Objects.BoxOutlineHolder.Visible = false
        end
        if Objects.BoxInlineHolder.Visible then
            Objects.BoxInlineHolder.Visible = false
        end
        if Objects.BoxFill.Visible then
            Objects.BoxFill.Visible = false
        end
    end

    if TextsCfg.Name.Enabled then
        if not Objects.TargetName.Visible then
            Objects.TargetName.Visible = true
        end
        local NameText = (TextsCfg.Name.Type == "Name") and Player.Name or Player.DisplayName
        if Data.LastDisplayName ~= NameText then
            Objects.TargetName.Text = NameText
            Data.LastDisplayName = NameText
        end
        local NameColor = TextsCfg.Name.Color
        if Data.LastNameColor ~= NameColor then
            Objects.TargetName.TextColor3 = NameColor
            Data.LastNameColor = NameColor
        end
    else
        if Objects.TargetName.Visible then
            Objects.TargetName.Visible = false
        end
    end

    if TextsCfg.Distance.Enabled then
        if not Objects.Distance.Visible then
            Objects.Distance.Visible = true
        end
        if Data.LastDist ~= Distance then
            Objects.Distance.Text = Format("%dst", Distance)
            Data.LastDist = Distance
        end
        local DistColor = TextsCfg.Distance.Color
        if Data.LastDistColor ~= DistColor then
            Objects.Distance.TextColor3 = DistColor
            Data.LastDistColor = DistColor
        end
    else
        if Objects.Distance.Visible then
            Objects.Distance.Visible = false
        end
    end

    local HealthCfg = Table.Bars["Health Bar"]
    local ArmorCfg = Table.Bars["Armor Bar"]

    if HealthCfg.Enabled then
        local Health = Data.Health or 0
        local MaxHealth = Data.MaxHealth or 100
        local Ratio = Clamp(Health / MaxHealth, 0, 1)

        if not Objects.LeftBarHolder.Visible then
            Objects.LeftBarHolder.Visible = true
        end
        if not Objects.HealthBarOutline.Visible then
            Objects.HealthBarOutline.Visible = true
        end
        if Data.LastRatio ~= Ratio then
            Objects.HealthBar.Size = Dim2(1, 0, Ratio, 0)
            Data.LastRatio = Ratio
        end

        local GradTop = HealthCfg.Top
        local GradMid = HealthCfg.Mid
        local GradBot = HealthCfg.Bot
        if Data.LastHealthTop ~= GradTop or Data.LastHealthMid ~= GradMid or Data.LastHealthBot ~= GradBot then
            Objects.HealthBarGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, GradTop),
                ColorSequenceKeypoint.new(0.5, GradMid),
                ColorSequenceKeypoint.new(1, GradBot),
            })
            Data.LastHealthTop = GradTop
            Data.LastHealthMid = GradMid
            Data.LastHealthBot = GradBot
        end

        if not Objects.HealthBarText.Visible then
            Objects.HealthBarText.Visible = true
        end
        local FlooredHealth = Floor(Health)
        if Data.LastHealthFloor ~= FlooredHealth then
            Objects.HealthBarText.Text = Format("%d", FlooredHealth)
            Objects.HealthBarText.Position = Dim2(1, -10, 1 - Ratio, 1)
            Data.LastHealthFloor = FlooredHealth
        end
    else
        if Objects.HealthBarOutline.Visible then
            Objects.HealthBarOutline.Visible = false
        end
        if Objects.HealthBarText.Visible then
            Objects.HealthBarText.Visible = false
        end
        if not ArmorCfg.Enabled and Objects.LeftBarHolder.Visible then
            Objects.LeftBarHolder.Visible = false
        end
    end

    if ArmorCfg.Enabled then
        local Ratio = Clamp(Data.Armor / Data.MaxArmor, 0, 1)
        if not Objects.BottomBarHolder.Visible then
            Objects.BottomBarHolder.Visible = true
        end
        if not Objects.ArmorBarOutline.Visible then
            Objects.ArmorBarOutline.Visible = true
        end
        if Data.LastArmorRatio ~= Ratio then
            Objects.ArmorBar.Size = Dim2(Ratio, 0, 1, 0)
            Data.LastArmorRatio = Ratio
        end

        local GradTop = ArmorCfg.Top
        local GradMid = ArmorCfg.Mid
        local GradBot = ArmorCfg.Bot
        if Data.LastArmorTop ~= GradTop or Data.LastArmorMid ~= GradMid or Data.LastArmorBot ~= GradBot then
            Objects.ArmorBarGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, GradTop),
                ColorSequenceKeypoint.new(0.5, GradMid),
                ColorSequenceKeypoint.new(1, GradBot),
            })
            Data.LastArmorTop = GradTop
            Data.LastArmorMid = GradMid
            Data.LastArmorBot = GradBot
        end

        if Ratio < 1 then
            if not Objects.ArmorBarText.Visible then
                Objects.ArmorBarText.Visible = true
            end
            local FlooredArmor = Floor(Data.Armor)
            if Data.LastArmorFloor ~= FlooredArmor then
                Objects.ArmorBarText.Text = Format("%d", FlooredArmor)
                Data.LastArmorFloor = FlooredArmor
            end
        else
            if Objects.ArmorBarText.Visible then
                Objects.ArmorBarText.Visible = false
            end
        end
    else
        if Objects.BottomBarHolder.Visible then
            Objects.BottomBarHolder.Visible = false
        end
        if Objects.ArmorBarOutline.Visible then
            Objects.ArmorBarOutline.Visible = false
        end
        if Objects.ArmorBarText.Visible then
            Objects.ArmorBarText.Visible = false
        end
    end

    local WeaponCfg = TextsCfg.Weapon
    if WeaponCfg.Enabled then
        if not Objects.Weapon.Visible then
            Objects.Weapon.Visible = true
        end
        local CurrentTool = Data.CurrentTool or "none"
        if Data.LastWeapon ~= CurrentTool then
            Objects.Weapon.Text = CurrentTool
            Data.LastWeapon = CurrentTool
        end
        local WeaponColor = WeaponCfg.Color
        if Data.LastWeaponColor ~= WeaponColor then
            Objects.Weapon.TextColor3 = WeaponColor
            Data.LastWeaponColor = WeaponColor
        end
    else
        if Objects.Weapon.Visible then
            Objects.Weapon.Visible = false
        end
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
                    bone.Line.Transparency = 1 - SkelCfg.Transparency
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

Library:CreateThreads("Renderer", RunService.RenderStepped, function()
    if not Table.Enabled then
        for _, Data in Library.Cache do
            Library:HideAllVisuals(Data)
        end
        for _, list in pairs(Library.PlayerChams) do
            for _, data in ipairs(list) do
                data[1].Visible = false
                data[1].Adornee = nil
            end
        end
        return
    end

    local Now = os.clock()
    if Now - Updates < Frame then
        return
    end
    Updates = Now
    CameraPosition = Camera.CFrame.Position

    local OOVCandidates = {}
    for Player, Data in Library.Cache do
        if Player.Parent and Data.RootPart and Data.Alive then
            local dist = (CameraPosition - Data.RootPart.Position).Magnitude
            if dist <= Table.Distance then
                local _, onScreen = WorldToViewportPoint(Camera, Data.RootPart.Position)
                if not onScreen then
                    OOVCandidates[#OOVCandidates + 1] = {Player = Player, Dist = dist}
                end
            end
        end
    end
    table.sort(OOVCandidates, function(a, b)
        return a.Dist < b.Dist
    end)
    local allowed = {}
    local maxArrows = math.max(Table.OOV.Limit or 6, 0)
    for i = 1, math.min(#OOVCandidates, maxArrows) do
        allowed[OOVCandidates[i].Player] = true
    end
    Library.OOVAllowed = allowed

    for Player, Data in Library.Cache do
        if not Player.Parent then
            Library:RemoveTarget(Player)
        else
            Library:Update(Player, Data)
        end
    end
end)

for _, Player in Players:GetPlayers() do
    Library:AddTarget(Player)
end

Library:CreateThreads("PlayerAdded", Players.PlayerAdded, function(Player)
    Library:AddTarget(Player)
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
    if self.Holder then
        self.Holder:Destroy()
        self.Holder = nil
    end
    Clear(self.Cache)
    Clear(self.PlayerChams)
end

return Library
