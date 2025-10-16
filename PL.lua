-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer


-- Tracks
local antiShieldEnabled = false
local antiTasedEnabled = false
local gunRemotesChildConn = nil
local repChildConn = nil
local returnOnDeathEnabled = false
local lastDeathPosition = nil

-- Position value
local gunposition_base = {
    ["M4A1"] = Vector3.new(847, 101, 2217),
    ["M9"] = Vector3.new(814, 101, 2217),
    ["Remington 870"] = Vector3.new(820, 101, 2218),
    ["AK-47"] = Vector3.new(-937, 94, 2050)
}

local guns_in_order = {"M4A1", "M9", "Remington 870", "AK-47"}

local function teleportTo(pos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")

    if root and pos then
        root.CFrame = CFrame.new(pos)
    end
end

local function teleportSequence()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local originalCFrame = root.CFrame

    for _, gunName in ipairs(guns_in_order) do
        local pos = gunposition_base[gunName]
        if pos then
            teleportTo(pos)
            task.wait(1)
        end
    end

    teleportTo(originalCFrame.Position)

    Window:Notify({
        Title = "Done",
        Desc = "Returned!",
        Time = 3
    })
end

-- a

-- sheild
local function removeShields()
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            if torso then
                local shield = torso:FindFirstChild("ShieldFolder")
                if shield then
                    shield:Destroy()
                    print("Destroyed ShieldFolder from", player.Name)
                end
            end

            local shieldAnywhere = character:FindFirstChild("ShieldFolder")
            if shieldAnywhere then
                shieldAnywhere:Destroy()
                print("Destroyed ShieldFolder from", player.Name)
            end
        end
    end
end

-- shield checker
RunService.Heartbeat:Connect(function()
    if antiShieldEnabled then
        removeShields()
    end
end)

-- Create Main Window
local Window = Library:Window({
    Title = "Prisonlife.lua",
    Desc = "EPAhFGUcz3jG3uk4qg7JenIk9POxXamI",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "suckmadick"
    }
})

-- Sidebar Vertical Separator
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0) -- adjust if needed
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui") -- Or Window.Gui if accessible

-- Tab

Window:Line()

local Items = Window:Tab({Title = "Items", Icon = "tag"}) do
    Items:Section({Title = "Items"})
    Items:Button({
        Title = "Get all guns",
        Callback = function()
        Window:Notify({
            Title = "Info",
            Desc = "Wait..",
            Time = 3
        })
            teleportSequence()
        end
    })
end
Window:Line()

local Misc = Window:Tab({Title = "Misc", Icon = "wrench"}) do

    Misc:Section({Title = "Misc"})
    Misc:Button({
        Title = "Remove all Doors",
        Desc = "aaaaaaaaa",
        Callback = function()
            local doorsParent = workspace:FindFirstChild("Doors")
            if doorsParent then
                for _, obj in ipairs(doorsParent:GetChildren()) do
                    obj:Destroy()
                end
            end

            local cellDoorsParent = workspace:FindFirstChild("a_door")
            if cellDoorsParent then
                for _, obj in ipairs(cellDoorsParent:GetChildren()) do
                    obj:Destroy()
                end
            end

            Window:Notify({
                Title = "Info",
                Desc = "yaa~!!",
                Time = 3
            })
        end
    })

    Misc:Button({
        Title = "AntiTaze",
        Desc = "AAAAAAAAAAAAAAAAAA!!!",
        Callback = function()
            Window:Notify({
                Title = "Info",
                Desc = "yaa~!!",
                Time = 3
            })
            local gunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
            if not gunRemotes then
                print("GunRemotes not found")
                return
            end
            local found = false
            for _, desc in pairs(gunRemotes:GetDescendants()) do
                if desc and desc.Name == "PlayerTased" then
                    local ok, err = pcall(function() desc:Destroy() end)
                    if ok then
                        found = true
                        print("Destroyed PlayerTased:", desc:GetFullName())
                    else
                        warn("Failed to destroy PlayerTased:", err)
                    end
                end
            end

            if not found then
                print("PlayerTased not found under GunRemotes")
                if type(Window) == "table" and type(Window.Notify) == "function" then
                    Window.Notify({ Title = "Info", Desc = "PlayerTased not found", Time = 3 })
                end
                return
            end

            local placeholder = Instance.new("RemoteEvent")
            placeholder.Name = "PlayerTased"
            placeholder.Parent = gunRemotes

            if type(Window) == "table" and type(Window.Notify) == "function" then
                Window.Notify({ Title = "Info", Desc = "PlayerTased destroyed (placeholder added)", Time = 3 })
            else
                print("PlayerTased destroyed (placeholder added)")
            end
        end
    })
    Misc:Toggle({
        Title = "Anti-Shield (L shield users)",
        Desc = "Removes all shields in when enabled",
        Value = false,
        Callback = function(state)
            antiShieldEnabled = state
            if state then
                Window.Notify({
                    Title = "Info",
                    Desc = "Anti-Shield Enabled",
                    Time = 3
                })
            else
                Window.Notify({
                    Title = "Info",
                    Desc = "Anti-Shield Disabled",
                    Time = 3
                })
            end
        end
    })
end


Window:Line()
local Extra = Window:Tab({Title = "Settings", Icon = "wrench"}) do
    Extra:Section({Title = "Config"})
    Extra:Button({
        Title = "Show Message",
        Desc = "Display a popup",
        Callback = function()
            Window:Notify({
                Title = "Fluent UI",
                Desc = "Everything works fine!",
                Time = 3
            })
        end
    })
end

-- Final Notification
Window:Notify({
    Title = "Elystra.wtf",
    Desc = "Loaded",
    Time = 4
})
