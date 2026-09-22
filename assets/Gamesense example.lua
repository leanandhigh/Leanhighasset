--[[
    Lean.high - Full UI Setup Example
    Core is loaded via loadstring; all menu setup lives here.
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Gamesense.lua"))()

local Players = game:GetService("Players")

local Window = Library:Window({CloseBind = Enum.KeyCode.Home})
local Rage = Window:CreateTab({Icon = "rbxassetid://18248771514"})
local AntiAim = Window:CreateTab({Icon = "rbxassetid://15453313321"})
local Aimbot = Window:CreateTab({Icon = "rbxassetid://15453335745"})
local Visuals = Window:CreateTab({Icon = "rbxassetid://15453344494"})
local Settings = Window:CreateTab({Icon = "rbxassetid://15453349637"})
local Weapons = Window:CreateTab({Icon = "rbxassetid://15453354931"})
local PlayerList = Window:CreateTab({Icon = "rbxassetid://15453359751"})
local Configs = Window:CreateTab({Icon = "rbxassetid://15453364412"})
local Lua = Window:CreateTab({Icon = "rbxassetid://18240049800"})
local ActualPlayerList

Window:SetTab(1)
AntiAim:Section({Fill = true})
AntiAim:Section({Fill = true, Side = "Right"})

do -- Rage
    Rage:ImageDropdown({
        Name = "Weapon type",
        Flag = "RageWeaponType",
        Options = {
            ["Global"] = {Icon = "rbxassetid://18657040454", Order = 1},
            ["Double Barrel SG"] = {Icon = "rbxassetid://18205706952", Order = 2},
            ["Revolver"] = {Icon = "rbxassetid://18205704829", Order = 3},
            ["LMG"] = {Icon = "rbxassetid://18205822505", Order = 4}
        },
        Default = "Global"
    })

    Rage:Section({Fill = true, Side = "Right"})
    local RageSection = Rage:Section({Fill = true})
    local Toggle1, Toggle2, Toggle3, Test

    local g = RageSection:Toggle({Callback = function(State)
        if not Toggle1 then return end
        Toggle1:SetVisible(State)
        Toggle2:SetVisible(State)
        Toggle3:SetVisible(State)
    end})
    g:ColorPicker()
    g:ColorPicker()
    g:Keybind()

    Toggle1 = RageSection:Toggle({Hidden = true, Callback = function(State)
        if not Test then return end
        Test:SetVisible(State)
    end})
    Toggle1:Keybind({Default = Enum.KeyCode.Q, Mode = "On hotkey"})
    Test = RageSection:Slider({Name = "", Hidden = true, Default = 50})
    Toggle2 = RageSection:List({Hidden = true})
    Toggle3 = RageSection:Button({Confirmation = true, Hidden = true})

    RageSection:Dropdown({Content = {"Option 1", "Option 2"}})
    RageSection:Label()
    RageSection:MultiBox({Content = {"Option 1", "Option 2"}})
end

do -- Visuals
    local VisualsSubSection, VisualsSubSection2, VisualsSubSection3, VisualsSubSection4 = Visuals:SubSection({
        Name = "Category",
        Options = {
            "rbxassetid://18334627891",
            "rbxassetid://18334630306",
            "rbxassetid://18334626899",
            "rbxassetid://18334625304"
        }
    })
    VisualsSubSection2:Section({Side = "Right", Fill = true})
    VisualsSubSection2:Section({Fill = true})
    VisualsSubSection4:Section({Side = "Right", Fill = true})
    VisualsSubSection4:Section({Fill = true})

    local PreviewVisualSection = VisualsSubSection:Section({Side = "Right", Size = 150})
    VisualsSubSection:Section({Side = "Right", Fill = true})
    VisualsSubSection:Section({Fill = true})

    local Slider1, Slider2
    PreviewVisualSection:Dropdown({Content = {"test2", "Test3"}})
    PreviewVisualSection:MultiBox({Content = {"test2", "Test3"}})
    PreviewVisualSection:Toggle({Risky = true, Callback = function(State)
        if not (Slider1 and Slider2) then return end
        Slider1:SetVisible(State)
        Slider2:SetVisible(State)
    end})
    Slider1 = PreviewVisualSection:Slider({Hidden = true})
    Slider2 = PreviewVisualSection:Slider({
        Name = "FOV",
        Hidden = true,
        Min = 0,
        Max = 11,
        Default = 5,
        Decimal = 1,
        Ending = "°",
        Disable = {"Disabled", 0, 11}
    })
end

do -- Settings
    local SettingsSection = Settings:Section({Name = "Settings", Side = "Right", Fill = true})
    SettingsSection:Label({Message = "Menu key"}):Keybind({
        Default = Enum.KeyCode.Insert,
        UseMode = false,
        Callback = function(Key)
            Library.UI.CloseBind = Key
        end
    })
    SettingsSection:Label({Message = "Menu color"}):ColorPicker({
        Default = Library.Theme.Default.Accent,
        Callback = function(Color)
            Library:UpdateColor("Accent", Color)
            Library:UpdateColor("SecondAccent", Color3.fromRGB(
                math.max(math.floor(Color.R * 255) - 12, 0),
                math.max(math.floor(Color.G * 255) - 12, 0),
                math.max(math.floor(Color.B * 255) - 12, 0)
            ))
        end
    })
    SettingsSection:Toggle({
        Name = "Watermark",
        Default = true,
        Flag = "ShowWatermark",
        Callback = function(State)
            Library:ToggleWatermark(State)
        end
    })
    SettingsSection:Toggle({
        Name = "Keybind List",
        Default = true,
        Flag = "ShowKeybindList",
        Callback = function(State)
            Library:ToggleKeybindList(State)
        end
    })
    SettingsSection:Toggle({
        Name = "Spectator List",
        Default = true,
        Flag = "ShowSpectatorList",
        Callback = function(State)
            Library:ToggleSpectatorList(State)
        end
    })
    SettingsSection:Button({Name = "Unload", Callback = Library.Unload})
    SettingsSection:Button({Name = "Disable all", Callback = Library.Disable})
end

do -- Weapons
    local WeaponsSection = Weapons:Section({Name = "Weapons", Fill = true})
    WeaponsSection:Dropdown({Name = "Weapon", Content = {"Global", "Rifle", "Shotgun", "Pistol"}})
end

do -- Aimbot
    Aimbot:SubSection({
        Name = "Category",
        Options = {
            "rbxassetid://18686402989",
            "rbxassetid://18657040454",
            "rbxassetid://18205704829",
            "rbxassetid://18205706952",
            "rbxassetid://18205822505"
        }
    })
end

do -- PlayerList
    local PlayerSection = PlayerList:Section({Name = "Players", Fill = true})
    local PlayerAdjustments = PlayerList:Section({Name = "Adjustments", Fill = true, Side = "Right"})
    ActualPlayerList = PlayerSection:List({Flag = "PlayerListCurrentPlayer", Size = 300})
    PlayerSection:Button({Name = "View player", Callback = function()
        local Name = Library.Flags["PlayerListCurrentPlayer"] and Library.Flags["PlayerListCurrentPlayer"]:Get()
        local Player = Name and Players:FindFirstChild(Name)
        if Player then
            Library:ViewPlayer(Player)
        end
    end})
    for _, Player in Players:GetPlayers() do
        ActualPlayerList:AddValue(Player.Name, {
            Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        })
    end
    PlayerAdjustments:Toggle({Name = "Whitelisted"})
end

do -- Configs
    local ConfigSection = Configs:Section({Name = "Configs", Fill = true})
    local LuaSection = Configs:Section({Name = "LUA", Side = "Right", Fill = true})
    local ConfigList = ConfigSection:List({Size = 200, Flag = "CurrentConfig"})
    Library:UpdateConfigList(ConfigList, "Add")
    ConfigSection:Button({Name = "Update config", Callback = function()
        if Library.Flags["CurrentConfig"] and Library.Flags["CurrentConfig"]:Get() then
            writefile("Lean.high/Configs/" .. Library.Flags["CurrentConfig"]:Get() .. ".cfg", Library:GetConfig())
        end
    end})
    ConfigSection:Button({Name = "Load config", Callback = function()
        if Library.Flags["CurrentConfig"] and Library.Flags["CurrentConfig"]:Get() then
            Library:LoadConfig(readfile("Lean.high/Configs/" .. Library.Flags["CurrentConfig"]:Get() .. ".cfg"))
        end
    end})
    ConfigSection:TextBox({Flag = "ConfigName"})
    ConfigSection:Button({Name = "Create config", Callback = function()
        local ConfigName = Library.Flags["ConfigName"] and Library.Flags["ConfigName"]:Get() or ""
        if ConfigName ~= "" and not isfile("Lean.high/Configs/" .. ConfigName .. ".cfg") then
            writefile("Lean.high/Configs/" .. ConfigName .. ".cfg", Library:GetConfig())
            ConfigList:AddValue(ConfigName)
        end
    end})
    ConfigSection:Button({Name = "Refresh list", Callback = function()
        Library:UpdateConfigList(ConfigList, "Remove")
        Library:UpdateConfigList(ConfigList, "Add")
    end})
    LuaSection:List({Size = 75})
    LuaSection:Button({Name = "Load script"})
    LuaSection:Button({Name = "Unload script"})
    LuaSection:Button({Name = "Refresh list"})
end

do -- Lua
    Lua:Section({Name = "Tab A", Fill = true})
    Lua:Section({Name = "Tab B", Side = "Right", Fill = true})
end

do -- Connections
    Library:Connection(Players.PlayerAdded, function(Player)
        if not ActualPlayerList then return end
        ActualPlayerList:AddValue(Player.Name, {
            Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        })
    end)
    Library:Connection(Players.PlayerRemoving, function(Player)
        if not ActualPlayerList then return end
        ActualPlayerList:AddValue(Player.Name, {
            Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        })
    end)
end

Library:Init()
