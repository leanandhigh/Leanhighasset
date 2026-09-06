local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()
local Config = ESP.Table

-- ===== BASIC SETTINGS =====
Config.Enabled = true
Config.Distance = 500

-- ===== BOXES =====
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

-- ===== BARS =====
Config.Bars["Health Bar"].Enabled = true
Config.Bars["Health Bar"].ShowText = true
Config.Bars["Health Bar"].Top = Color3.fromRGB(0, 255, 0)
Config.Bars["Health Bar"].Mid = Color3.fromRGB(255, 255, 0)
Config.Bars["Health Bar"].Bot = Color3.fromRGB(255, 0, 0)

Config.Bars["Armor Bar"].Enabled = true
Config.Bars["Armor Bar"].Top = Color3.fromRGB(255, 255, 255)
Config.Bars["Armor Bar"].Mid = Color3.fromRGB(220, 220, 220)
Config.Bars["Armor Bar"].Bot = Color3.fromRGB(180, 180, 180)

-- ===== TEXTS =====
Config.Texts.Name.Enabled = true
Config.Texts.Name.Color = Color3.fromRGB(0, 255, 255)
Config.Texts.Name.Type = "DisplayName"

Config.Texts.Distance.Enabled = true
Config.Texts.Distance.Color = Color3.fromRGB(0, 255, 255)

Config.Texts.Weapon.Enabled = true
Config.Texts.Weapon.Color = Color3.fromRGB(0, 255, 255)

-- ===== FLAGS (fully dynamic) =====
Config.Flags.Enabled = true
Config.Flags.List = {
    Walking = { Enabled = true, Text = "Walking", Color = Color3.fromRGB(255, 80, 80) },
    Jumping = { Enabled = true, Text = "Jumping", Color = Color3.fromRGB(255, 180, 50) },
    Sprinting = { Enabled = true, Text = "Sprinting", Color = Color3.fromRGB(0, 255, 255) },
    Crouching = { Enabled = true, Text = "Crouching", Color = Color3.fromRGB(255, 255, 0) },
    Flying = { Enabled = true, Text = "Flying", Color = Color3.fromRGB(255, 0, 255) },
    Swimming = { Enabled = true, Text = "Swimming", Color = Color3.fromRGB(0, 100, 255) },
    Climbing = { Enabled = true, Text = "Climbing", Color = Color3.fromRGB(255, 165, 0) },
    Falling = { Enabled = true, Text = "Falling", Color = Color3.fromRGB(255, 0, 0) },
    Ragdoll = { Enabled = true, Text = "Ragdoll", Color = Color3.fromRGB(128, 128, 128) },
    Dead = { Enabled = true, Text = "Dead", Color = Color3.fromRGB(0, 0, 0) },
}

-- ===== CHAMS =====
Config.Chams.Enabled = true
Config.Chams.FillColor = Color3.fromRGB(0, 255, 255)
Config.Chams.OutlineColor = Color3.fromRGB(0, 0, 0)
Config.Chams.FillTransparency = 0.61
Config.Chams.OutlineTransparency = 0.21
Config.Chams.Shading = Enum.AdornShading.Default
Config.Chams.ShadingOutline = Enum.AdornShading.Default

-- ===== OFF‑SCREEN INDICATORS =====
Config.OOV.Enabled = true
Config.OOV.Color = Color3.fromRGB(0, 255, 255)
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

-- ===== SKELETON =====
Config.Skeleton.Enabled = true
Config.Skeleton.Color = Color3.fromRGB(255, 255, 255)
Config.Skeleton.Thickness = 1.5
Config.Skeleton.Transparency = 0

-- ============================================================
--  CUSTOMISATION FOR NON‑STANDARD GAMES
--  Override the default humanoid/tool detection with your own.
--  These functions are called every frame, so keep them lightweight.
-- ============================================================

-- 1. Custom health – Example: read from an IntValue named "Health" inside the character
Config.CustomData.GetHealth = function(Player, Character)
    local healthVal = Character:FindFirstChild("Health")
    local maxHealthVal = Character:FindFirstChild("MaxHealth")
    local health = healthVal and healthVal.Value or 100
    local maxHealth = maxHealthVal and maxHealthVal.Value or 100
    return health, maxHealth
end

-- 2. Custom armor – Example: read from an IntValue named "Armor"
Config.CustomData.GetArmor = function(Player, Character)
    local armorVal = Character:FindFirstChild("Armor")
    local maxArmorVal = Character:FindFirstChild("MaxArmor")
    local armor = armorVal and armorVal.Value or 0
    local maxArmor = maxArmorVal and maxArmorVal.Value or 100
    return armor, maxArmor
end

-- 3. Custom weapon – Example: read from a StringValue or attribute "CurrentWeapon"
Config.CustomData.GetWeapon = function(Player, Character)
    local weaponVal = Character:FindFirstChild("CurrentWeapon")
    if weaponVal then
        return weaponVal.Value
    end
    -- Or via attribute:
    -- return Character:GetAttribute("CurrentWeapon") or "none"
    return "none"
end

-- 4. Custom flags – Return a table of flagName = true/false
--    The flags must match the names defined in Config.Flags.List.
Config.CustomData.GetFlags = function(Player, Character)
    -- Example: read attributes or custom values
    return {
        Walking = Character:GetAttribute("IsWalking") or false,
        Jumping = Character:GetAttribute("IsJumping") or false,
        Sprinting = Character:GetAttribute("IsSprinting") or false,
        Crouching = Character:GetAttribute("IsCrouching") or false,
        Flying = Character:GetAttribute("IsFlying") or false,
        Swimming = Character:GetAttribute("IsSwimming") or false,
        Climbing = Character:GetAttribute("IsClimbing") or false,
        Falling = Character:GetAttribute("IsFalling") or false,
        Ragdoll = Character:GetAttribute("IsRagdoll") or false,
        Dead = Character:GetAttribute("IsDead") or false,
    }
end

-- 5. (Optional) Custom body parts for boxes and chams
--    Return a list of BasePart objects to be used for bounding box and chams.
Config.CustomGetBodyParts = function(Character)
    if not Character then return {} end
    local parts = {}
    for _, obj in Character:GetDescendants() do
        if obj:IsA("BasePart") and obj.Transparency < 1 and obj.Name ~= "HumanoidRootPart" then
            table.insert(parts, obj)
        end
    end
    return parts
end

-- 6. (Optional) Custom skeleton joints – define the bone connections
--    Each entry is { "PartA", "PartB" } – the library will draw a line between them.
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

-- ===== THE ESP WILL NOW USE THESE CUSTOM FUNCTIONS =====

-- If you ever want to disable a custom function, set it back to nil:
-- Config.CustomData.GetHealth = nil   -- falls back to Humanoid.Health
-- Config.CustomData.GetFlags = nil    -- falls back to walking/jumping only (simple)

-- To unload: ESP:Unload()
