local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Esp.lua"))()
local Config = ESP.Table

-- ===== BASIC SETTINGS =====
Config.Enabled = true
Config.Distance = 500

-- ===== BOXES (your existing config) =====
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

-- ===== FLAGS (fully dynamic – define any flags you need) =====
Config.Flags.Enabled = true
Config.Flags.List = {
    Walking   = { Enabled = true, Text = "Walking",   Color = Color3.fromRGB(255, 80, 80) },
    Jumping   = { Enabled = true, Text = "Jumping",   Color = Color3.fromRGB(255, 180, 50) },
    Sprinting = { Enabled = true, Text = "Sprinting", Color = Color3.fromRGB(0, 255, 255) },
    Crouching = { Enabled = true, Text = "Crouching", Color = Color3.fromRGB(255, 255, 0) },
    Flying    = { Enabled = true, Text = "Flying",    Color = Color3.fromRGB(255, 0, 255) },
    Swimming  = { Enabled = true, Text = "Swimming",  Color = Color3.fromRGB(0, 100, 255) },
    Climbing  = { Enabled = true, Text = "Climbing",  Color = Color3.fromRGB(255, 165, 0) },
    Falling   = { Enabled = true, Text = "Falling",   Color = Color3.fromRGB(255, 0, 0) },
    Ragdoll   = { Enabled = true, Text = "Ragdoll",   Color = Color3.fromRGB(128, 128, 128) },
    Dead      = { Enabled = true, Text = "Dead",      Color = Color3.fromRGB(0, 0, 0) },
    -- Add more custom flags as needed
}

-- ===== CHAMS =====
Config.Chams.Enabled = true
Config.Chams.FillColor = Color3.fromRGB(0, 255, 255)
Config.Chams.OutlineColor = Color3.fromRGB(0, 0, 0)
Config.Chams.FillTransparency = 0.61
Config.Chams.OutlineTransparency = 0.21
Config.Chams.Shading = Enum.AdornShading.Default
Config.Chams.ShadingOutline = Enum.AdornShading.Default

-- ===== OOV =====
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
--  CUSTOM DATA FUNCTIONS
--  These override the default Humanoid/Tool logic.
--  Every frame they are called; they MUST return fresh data.
-- ============================================================

-- 1. Custom Health – supports both Humanoid and custom values
Config.CustomData.GetHealth = function(Player, Character)
    local hum = Character:FindFirstChildOfClass("Humanoid")
    if hum then
        return hum.Health, hum.MaxHealth
    end
    -- Fallback to custom values
    local healthVal = Character:FindFirstChild("Health")
    local maxHealthVal = Character:FindFirstChild("MaxHealth")
    local health = healthVal and healthVal.Value or 0
    local maxHealth = maxHealthVal and maxHealthVal.Value or 100
    return health, maxHealth
end

-- 2. Custom Armor – supports custom values only
Config.CustomData.GetArmor = function(Player, Character)
    local armorVal = Character:FindFirstChild("Armor")
    local maxArmorVal = Character:FindFirstChild("MaxArmor")
    local armor = armorVal and armorVal.Value or 0
    local maxArmor = maxArmorVal and maxArmorVal.Value or 100
    return armor, maxArmor
end

-- 3. Custom Weapon – supports StringValue or attribute
Config.CustomData.GetWeapon = function(Player, Character)
    local weaponVal = Character:FindFirstChild("CurrentWeapon")
    if weaponVal then
        return weaponVal.Value
    end
    return Character:GetAttribute("CurrentWeapon") or "none"
end

-- 4. Custom Flags – fully dynamic, resets every frame
Config.CustomData.GetFlags = function(Player, Character)
    -- Start with all flags set to false
    local flags = {}
    for name, _ in pairs(Config.Flags.List) do
        flags[name] = false
    end

    -- Early exit if no character
    if not Character then
        return flags
    end

    local hum = Character:FindFirstChildOfClass("Humanoid")
    if not hum then
        return flags
    end

    -- Helper to get state name safely
    local stateName = ""
    local ok, state = pcall(function() return hum:GetState() end)
    if ok then
        stateName = tostring(state)
    end

    -- Get move direction string (for some games)
    local ms = ""
    local moveDir = hum.MoveDirection
    if moveDir and moveDir ~= Vector3.new(0,0,0) then
        ms = "Walking"
    end
    -- Some games store movement in an attribute or custom property
    local customMove = Character:GetAttribute("MovementState")
    if customMove then
        ms = customMove
    end

    -- Helper to check a condition and set flag
    local function setFlag(name, condition)
        if condition then flags[name] = true end
    end

    -- ---- DETECTIONS ----

    -- Walking: move direction not zero AND not jumping etc.
    setFlag("Walking", ms == "Walking" or (moveDir and moveDir ~= Vector3.new(0,0,0) and stateName ~= "Jumping" and stateName ~= "Freefall"))

    -- Jumping: state is Jumping or Freefall
    setFlag("Jumping", stateName == "Jumping" or stateName == "Freefall")

    -- Sprinting: often attribute or specific state
    setFlag("Sprinting", Character:GetAttribute("Sprinting") == true or ms == "Sprinting")

    -- Crouching: check CameraOffset.Y < -0.5 (standard Roblox crouch)
    setFlag("Crouching", (hum.CameraOffset and hum.CameraOffset.Y < -0.5) or Character:GetAttribute("Crouching") == true)

    -- Flying: state is Flying or attribute
    setFlag("Flying", stateName == "Flying" or Character:GetAttribute("Flying") == true)

    -- Swimming: state is Swimming
    setFlag("Swimming", stateName == "Swimming")

    -- Climbing: state is Climbing
    setFlag("Climbing", stateName == "Climbing")

    -- Falling: state is FallingDown (not freefall)
    setFlag("Falling", stateName == "FallingDown")

    -- Ragdoll: state is Physics
    setFlag("Ragdoll", stateName == "Physics")

    -- Dead: health <= 0
    setFlag("Dead", hum.Health <= 0)

    -- Return the complete flags table – every flag is explicitly set
    return flags
end

-- Optional: Custom body parts and skeleton joints (if needed)
-- Config.CustomGetBodyParts = function(Character) ... end
-- Config.CustomSkeletonJoints = { ... }

-- ===== NOW THE ESP WILL USE THESE CUSTOM FUNCTIONS =====
-- Flags will appear when conditions are true and disappear immediately when false.
-- Death will hide the ESP because GetHealth returns 0 => Data.Alive = false.

-- To unload: ESP:Unload()
