local Library = loadstring(request({Url = "https://raw.githubusercontent.com/leanandhigh/Leanhighasset/refs/heads/main/assets/Library.lua", Method = "Get"}).Body)()
local Window = Library:Window({
    Logo = "77218680285262",
    FadeTime = 0.3,
})
local Watermark = Library:Watermark("This is a watermark")
local KeybindList = Library:KeybindList()
do
    local CombatPage = Window:Page({Name = "Combat", SubPages = true})
    local PlayerPage = Window:Page({Name = "Player", Columns = 2})
    local VisualsPage = Window:Page({Name = "Visuals", Columns = 2})
    local PlayersPage = Window:Page({Name = "Players", Columns = 2})
    local SettingsPage = Library:CreateSettingsPage(Window, Watermark, KeybindList)

    do -- Combat page
        local WeaponSubPage = CombatPage:SubPage({Name = "Weapon", Columns = 2})
        local AimbotSubPage = CombatPage:SubPage({Name = "Aimbot", Columns = 2})
        do -- Weapon subpage
            local RangedWeaponSection = WeaponSubPage:Section({Name = "Ranged Weapons", Side = 1}) do
                RangedWeaponSection:Toggle({
                    Name = "Enabled",
                    Flag = "RangedWeaponEnabled",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                RangedWeaponSection:Toggle({
                    Name = "Instant hit",
                    Flag = "RangedWeaponInstantHit",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                RangedWeaponSection:Toggle({
                    Name = "Rapid fire",
                    Flag = "RangedWeaponRapidFire",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                RangedWeaponSection:Toggle({
                    Name = "Full auto",
                    Flag = "RangedWeaponFullAuto",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                RangedWeaponSection:Slider({
                    Name = "Reload time",
                    Flag = "RangedWeaponReloadTime",
                    Min = 0,
                    Suffix = "s",
                    Max = 5,
                    Default = 0,
                    Decimals = 0.01,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                RangedWeaponSection:Dropdown({
                    Name = "Mode",
                    Items = {"Burst", "Auto", "Single"},
                    Flag = "RangedWeaponMode",
                    Default = "Burst",
                    Multi = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                local Button = RangedWeaponSection:Button()
                Button:Add("Apply", function()
                    print("Pressed")
                end)
                Button:Add("Reset", function()
                    print("Pressed 2")
                end)
            end
        end
        do -- Aimbot subpage
            local SilentAimSection = AimbotSubPage:Section({Name = "Silent Aim", Side = 1}) do
                SilentAimSection:Toggle({
                    Name = "Enabled",
                    Flag = "SilentAimEnabled",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                local Toggle = SilentAimSection:Toggle({
                    Name = "FoV Circle",
                    Flag = "SilentAimFoVEnabled",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                Toggle:Colorpicker({
                    Name = "FoV",
                    Flag = "SilentAimFoV",
                    Default = Library.Theme.Accent,
                    Alpha = 0,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                Toggle:Colorpicker({
                    Name = "FoV Outline",
                    Flag = "SilentAimFoVOutline",
                    Default = Color3.fromRGB(0, 0, 0),
                    Alpha = 0,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                SilentAimSection:Dropdown({
                    Name = "Bone",
                    Flag = "SilentAimBone",
                    Default = "Head",
                    Multi = false,
                    Items = {"Head", "Penis", "Ass", "Thigh", "Tits"},
                    Callback = function(Value)
                        print(Value)
                    end
                })
                SilentAimSection:Toggle({
                    Name = "Manipulation",
                    Flag = "SilentAimManipulation",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                SilentAimSection:Slider({
                    Name = "Radius",
                    Flag = "FoVRadius",
                    Min = 1,
                    Suffix = "px",
                    Max = 500,
                    Default = 75,
                    Decimals = 1,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                SilentAimSection:Toggle({
                    Name = "Wall Check",
                    Flag = "SilentAimFoVWallCheck",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                SilentAimSection:Toggle({
                    Name = "Team Check",
                    Flag = "SilentAimFoVTeamCheck",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
                SilentAimSection:Toggle({
                    Name = "Death Check",
                    Flag = "SilentAimFoVDeathCheck",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })
            end
            local AimbotSection = AimbotSubPage:Section({Name = "Camera", Side = 2}) do
                AimbotSection:Toggle({
                    Name = "Enabled",
                    Flag = "AimbotEnabled",
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                }):Keybind({
                    Flag = "AimbotKeybind",
                    Default = Enum.KeyCode.E,
                    Mode = "Toggle",
                    Callback = function(Value)
                        print(Value)
                    end
                })
                AimbotSection:Searchbox({
                    Name = "Searchbox",
                    Flag = "Searchbox",
                    Items = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10", "Option 11"},
                    Multi = false,
                    Default = "Option 1",
                    Callback = function(Value)
                        print(Value)
                    end
                })
            end
        end
    end

    do -- Visuals page
        local ESPSection = VisualsPage:Section({Name = "ESP", Side = 1}) do
            local ESPBox = ESPSection:Tabbox()
            local EnemyTab = ESPBox:AddTab("Enemy")
            local TeamTab = ESPBox:AddTab("Team")

            -- Enemy tab
            local BoxESPEnemy = EnemyTab:Toggle({
                Name = "Box",
                Flag = "Boxesp",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            })
            BoxESPEnemy:Colorpicker({
                Name = "Gradient Color 1",
                Flag = "Boxgradientcolor1",
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(Value)
                    print(Value)
                end
            })
            BoxESPEnemy:Colorpicker({
                Name = "Gradient Color 2",
                Flag = "Boxgradientcolor2",
                Default = Color3.fromRGB(255, 100, 0),
                Callback = function(Value)
                    print(Value)
                end
            })
            local FillESPEnemy = EnemyTab:Toggle({
                Name = "Fill box",
                Flag = "Fillesp",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            })
            FillESPEnemy:Colorpicker({
                Name = "Fill Gradient 1",
                Flag = "Fillgradientcolor1",
                Default = Color3.fromRGB(255, 0, 0),
                Alpha = 0.5,
                Callback = function(Value)
                    print(Value)
                end
            })
            FillESPEnemy:Colorpicker({
                Name = "Fill Gradient 2",
                Flag = "Fillgradientcolor2",
                Default = Color3.fromRGB(255, 100, 0),
                Callback = function(Value)
                    print(Value)
                end
            })
            local HealthBarEnemy = EnemyTab:Toggle({
                Name = "Health bar",
                Flag = "Healthesp",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            })
            HealthBarEnemy:Colorpicker({
                Name = "Health Gradient 1",
                Flag = "Healthgradientcolor1",
                Default = Color3.fromRGB(0, 255, 0),
                Callback = function(Value)
                    print(Value)
                end
            })
            HealthBarEnemy:Colorpicker({
                Name = "Health Gradient 2",
                Flag = "Healthgradientcolor2",
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(Value)
                    print(Value)
                end
            })
            EnemyTab:Toggle({
                Name = "Health text",
                Flag = "Healthtext",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            }):Colorpicker({
                Name = "Health Text Color",
                Flag = "Healthtextcolor",
                Default = Color3.fromRGB(255, 255, 255),
                Callback = function(Value)
                    print(Value)
                end
            })

            -- Team tab
            local BoxESPTeam = TeamTab:Toggle({
                Name = "Box",
                Flag = "TeamBoxesp",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            })
            BoxESPTeam:Colorpicker({
                Name = "Gradient Color 1",
                Flag = "TeamBoxgradientcolor1",
                Default = Color3.fromRGB(0, 100, 255),
                Callback = function(Value)
                    print(Value)
                end
            })
            BoxESPTeam:Colorpicker({
                Name = "Gradient Color 2",
                Flag = "TeamBoxgradientcolor2",
                Default = Color3.fromRGB(0, 200, 255),
                Callback = function(Value)
                    print(Value)
                end
            })
            local FillESPTeam = TeamTab:Toggle({
                Name = "Fill box",
                Flag = "TeamFillesp",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            })
            FillESPTeam:Colorpicker({
                Name = "Fill Gradient 1",
                Flag = "TeamFillgradientcolor1",
                Default = Color3.fromRGB(0, 100, 255),
                Alpha = 0.5,
                Callback = function(Value)
                    print(Value)
                end
            })
            FillESPTeam:Colorpicker({
                Name = "Fill Gradient 2",
                Flag = "TeamFillgradientcolor2",
                Default = Color3.fromRGB(0, 200, 255),
                Callback = function(Value)
                    print(Value)
                end
            })
        end
    end
end

local inv = Library:InventoryViewer()
inv:SetPlayer(game.Players.LocalPlayer)
inv:AddTool("gun1", 0)
inv:AddTool("gun1", 0)
inv:AddTool("gun1", 0)
inv:AddTool("gun1", 0)
inv:AddTool("gun1", 0)
inv:AddTool("gun1", 0)
Library:Notification("Loaded!", "test, test test, test test, test test, test test, test test, test test, test test, test test, test test, test test, test test, test ", 5)
getgenv().Library = Library
return Library
