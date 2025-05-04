-- // Initialising the UI
local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UI = Venyx.new({
    title = "Elystra.wtf | Beta"
})


-- // Themes config 
local Themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- // Notify user with welcome message
UI:Notify({
    title = "Loaded!",
    text = "Use at ur own risk",
})

-- // Auto Farm Page
local AutoFarm = UI:addPage({ title = "Auto Farm", icon = 5012544693 })
local SectionA = AutoFarm:addSection({ title = "Section A" })
local SectionB = AutoFarm:addSection({ title = "Section B" })

SectionA:addToggle({
    title = "Gold Farm",
    callback = function(value) print("Toggled", value) end
})

SectionA:addButton({
    title = "Button",
    callback = function() print("Clicked") end
})

-- // Custom Platform Function
local platformEnabled = true
local platform = nil
local platformHeight = 100 
local function togglePlatform()
    if platformEnabled then
        -- Remove platform
        if platform then
            platform:Destroy()
            platform = nil
        end
        platformEnabled = false
        return false
    else
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        platform = Instance.new("Part")
        platform.Name = "CustomPlatform"
        platform.Size = Vector3.new(10, 1, 10)  
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.SmoothPlastic
        platform.BrickColor = BrickColor.new("Really blue")
        platform.Transparency = 0.5
        local currentPos = hrp.Position
        platform.Position = Vector3.new(currentPos.X, platformHeight, currentPos.Z)
        platform.Parent = workspace
        hrp.CFrame = CFrame.new(Vector3.new(currentPos.X, platformHeight + 3, currentPos.Z))
        platformEnabled = true
        return true
    end
end

local Aroundmap = UI:addPage({ title = "Teleport", icon = 5012544693 })
local SectionA = Aroundmap:addSection({ title = "Teleport" })

SectionA:addButton({
    title = "จุดเกิด",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Vector3.new(-164.698227, 68.938667, 40.272659))
    end
})

SectionA:addButton({
    title = "เซเว่น",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Vector3.new(-182.096725, 69.933716, 218.444443))
    end
})

SectionA:addButton({
    title = "โรงพยาบาล",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Vector3.new(18.806509, 68.744102, 346.443726))
    end
})

SectionA:addButton({
    title = "สถานีตำรวจ",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Vector3.new(191.728683, 67.196495, 676.351379))
    end
})


-- Add Platform Section
local PlatformSection = Aroundmap:addSection({ title = "Platform" })

-- Toggle for platform
PlatformSection:addToggle({
    title = "Custom Platform",
    callback = function(value)
        local platformStatus = togglePlatform()
        
        if platformStatus then
            UI:Notify({
                title = "Platform",
                text = "Platform created at height " .. tostring(platformHeight),
            })
        else
            UI:Notify({
                title = "Platform",
                text = "Platform removed",
            })
        end
    end
})

-- Platform height slider
PlatformSection:addSlider({
    title = "Platform Height",
    default = 100,
    min = 50,
    max = 500,
    callback = function(value)
        platformHeight = value
        if platform and platformEnabled then
            -- Update existing platform height
            local currentPos = platform.Position
            platform.Position = Vector3.new(currentPos.X, value, currentPos.Z)
            
            -- Move player to updated platform if they want
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(Vector3.new(currentPos.X, value + 3, currentPos.Z))
                end
            end
        end
    end
})

-- Platform color picker
PlatformSection:addColorPicker({
    title = "Platform Color",
    default = Color3.fromRGB(0, 0, 255), -- Default blue
    callback = function(color)
        if platform then
            platform.Color = color
        end
    end
})

-- Platform transparency slider
PlatformSection:addSlider({
    title = "Platform Transparency",
    default = 0.5,
    min = 0,
    max = 0.9,
    callback = function(value)
        if platform then
            platform.Transparency = value
        end
    end
})

-- Platform size slider
PlatformSection:addSlider({
    title = "Platform Size",
    default = 10,
    min = 5,
    max = 50,
    callback = function(value)
        if platform then
            platform.Size = Vector3.new(value, 1, value)
        end
    end
})

local Combat = UI:addPage({ title = "Combat", icon = 5012544693 })
local SectionA = Combat:addSection({ title = "Warp" })
local SectionB = Combat:addSection({ title = "Player" })

-- // Improved Auto Heal
local autoHealEnabled = false
local autoHealMinHealth = 50
local autoHealSafeReturn = true
local autoHealConnection = nil

local function getLocalPlayer()
    return game.Players.LocalPlayer
end

local function getCharacter()
    local player = getLocalPlayer()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

local function teleportTo(cframe)
    local hrp = getHRP()
    hrp.CFrame = cframe
end

local function performHealCycle(originalCFrame, hospitalCFrame, breakSpotCFrame)
    local humanoid = getHumanoid()
    local hrp = getHRP()
    if not humanoid or not hrp then return end

    -- Step 1: Go to hospital
    teleportTo(hospitalCFrame)
    humanoid.PlatformStand = true
    UI:Notify({ title = "Auto Heal", text = "Teleporting to hospital..." })

    -- Step 2: Nudge while healing
    local nudgeUp = true
    while humanoid.Health < humanoid.MaxHealth do
        local pos = hrp.Position
        local offset = nudgeUp and Vector3.new(0, 0.1, 0) or Vector3.new(0, -0.1, 0)
        hrp.CFrame = CFrame.new(pos + offset)
        nudgeUp = not nudgeUp
        task.wait(1)
    end
    UI:Notify({ title = "Auto Heal", text = "Healed!" })

    -- Step 3: Go to break spot
    teleportTo(breakSpotCFrame)
    task.wait(2.5)
    UI:Notify({ title = "Auto Heal", text = "Break spot reached." })

    -- Step 4: Heal again if needed
    while humanoid.Health < humanoid.MaxHealth do
        local pos = hrp.Position
        local offset = nudgeUp and Vector3.new(0, 0.1, 0) or Vector3.new(0, -0.1, 0)
        hrp.CFrame = CFrame.new(pos + offset)
        nudgeUp = not nudgeUp
        task.wait(1)
    end
    UI:Notify({ title = "Auto Heal", text = "Final heal complete!" })

    -- Step 5: Return to original position if enabled
    humanoid.PlatformStand = false
    if autoHealSafeReturn then
        teleportTo(originalCFrame)
        UI:Notify({ title = "Auto Heal", text = "Returned to original position." })
    end
end

local function startAutoHealLoop()
    if autoHealConnection then autoHealConnection:Disconnect() end
    autoHealConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoHealEnabled then return end
        local humanoid = getHumanoid()
        if humanoid and humanoid.Health < autoHealMinHealth then
            autoHealEnabled = false -- Prevent re-entry
            local hrp = getHRP()
            local originalCFrame = hrp.CFrame
            local hospitalCFrame = CFrame.new(186.795425, 127.700378, 45739.597656)
            local breakSpotCFrame = CFrame.new(160, 127.7, 45720)
            performHealCycle(originalCFrame, hospitalCFrame, breakSpotCFrame)
            autoHealEnabled = true -- Re-enable after healing
        end
    end)
end

local function stopAutoHealLoop()
    if autoHealConnection then
        autoHealConnection:Disconnect()
        autoHealConnection = nil
    end
end

SectionA:addButton({
    title = "Auto Heal",
    callback = function()
        local humanoid = getHumanoid()
        if not humanoid then
            UI:Notify({ title = "Auto Heal", text = "No humanoid found!" })
            return
        end
        if humanoid.Health >= humanoid.MaxHealth then
            UI:Notify({ title = "Auto Heal", text = "Health is already full!" })
            return
        end

        local hrp = getHRP()
        local originalCFrame = hrp.CFrame
        local hospitalCFrame = CFrame.new(186.795425, 127.700378, 45739.597656)
        local breakSpotCFrame = CFrame.new(160, 127.7, 45720)

        local function preloadChunk(position, radius)
            local region = Region3.new(position - Vector3.new(radius, radius, radius), position + Vector3.new(radius, radius, radius))
            region = region:ExpandToGrid(4) -- aligns to 4x4x4 voxels
            local parts = Workspace:FindPartsInRegion3(region, nil, math.huge)
            return #parts > 0
        end

        local function healCycle()
            -- Step 0: Preload hospital area
            UI:Notify({ title = "Auto Heal", text = "Loading hospital area..." })
            teleportTo(hospitalCFrame) -- Temporarily teleport to trigger streaming
            repeat
                task.wait(0.5)
            until preloadChunk(hospitalCFrame.Position, 32)

            task.wait(0.5) -- Give a little buffer

            -- Step 1: Begin healing cycle
            repeat
                teleportTo(hospitalCFrame)
                humanoid.PlatformStand = true
                UI:Notify({ title = "Auto Heal", text = "At hospital..." })
                task.wait(2)

                teleportTo(breakSpotCFrame)
                UI:Notify({ title = "Auto Heal", text = "At break spot..." })
                task.wait(2)
            until humanoid.Health >= humanoid.MaxHealth

            humanoid.PlatformStand = false

            if autoHealSafeReturn then
                teleportTo(originalCFrame)
                UI:Notify({ title = "Auto Heal", text = "Returned to original position." })
            end

            UI:Notify({ title = "Auto Heal", text = "Healing complete!" })
        end

        task.spawn(healCycle)
    end
})


SectionB:addSlider({
    title = "Walk Speed",
    default = 16, -- Default Roblox walk speed
    min = 0,
    max = 1000,
    callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
        
        -- Store the value for when character respawns
        _G.savedWalkSpeed = value
        
        -- Add character added connection if it doesn't exist
        if not _G.walkSpeedConnection then
            _G.walkSpeedConnection = player.CharacterAdded:Connect(function(char)
                local humanoid = char:WaitForChild("Humanoid")
                if humanoid and _G.savedWalkSpeed then
                    humanoid.WalkSpeed = _G.savedWalkSpeed
                end
            end)
        end
    end
})

-- // Theme Page
local Theme = UI:addPage({ title = "Theme", icon = 5012544693 })
local Colors = Theme:addSection({ title = "Colors" })

-- // Add Rainbow Theme toggle first
local rainbowConnection = nil
local rainbowRunning = false

-- Rainbow Theme Toggle
Colors:addToggle({
    title = "Rainbow Theme",
    callback = function(state)
        rainbowRunning = state
        
        if rainbowRunning then
            -- Disconnect any existing connection
            if rainbowConnection then
                rainbowConnection:Disconnect()
            end
            
            -- Create a new rainbow effect
            rainbowConnection = RunService.RenderStepped:Connect(function()
                local hue = tick() % 10 / 10  -- Adjust the speed of the rainbow effect
                local color = Color3.fromHSV(hue, 1, 1) -- Generate a color from HSV

                -- Apply the color to the themes dynamically
                UI:setTheme({ theme = "TextColor", color3 = color })
                UI:setTheme({ theme = "Glow", color3 = color })
            end)
        else
            -- Stop the rainbow effect if the toggle is off
            if rainbowConnection then
                rainbowConnection:Disconnect()
                rainbowConnection = nil
                
                -- Reset to default themes
                UI:setTheme({ theme = "Glow", color3 = Themes.Glow })
                UI:setTheme({ theme = "TextColor", color3 = Themes.TextColor })
            end
        end
    end
})

-- // Add regular theme color pickers
for theme, color in pairs(Themes) do
    Colors:addColorPicker({
        title = theme,
        default = color,
        callback = function(color3)
            UI:setTheme({ theme = theme, color3 = color3 })
        end
    })
end

-- // Misc Page
local Misc = UI:addPage({ title = "Misc", icon = 5012544693 })
local MiscSection = Misc:addSection({ title = "Utility" })
local MiscSection2 = Misc:addSection({ title = "Ui" })

local antiAFKEnabled = true

Players.LocalPlayer.Idled:Connect(function()
	if antiAFKEnabled then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-- UI Toggle
MiscSection:addToggle({
    title = "Anti AFK",
    default = true, 
    callback = function(value)
        antiAFKEnabled = value
        print("Anti AFK:", antiAFKEnabled)
    end
})

local uiDestroyed = false

MiscSection:addButton({
    title = "Click Teleport Tool",
    callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        
        tool.Activated:Connect(function()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            pos = CFrame.new(pos.X, pos.Y, pos.Z)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
        end)
        
        tool.Parent = game.Players.LocalPlayer.Backpack
        
        UI:Notify({
            title = "!",
            text = "Click Teleport Tool Added to Backpack"
        })
    end
})

MiscSection:addButton({
    title = "Fix Cam",
    callback = function()
        local speaker = game.Players.LocalPlayer
        
        if StopFreecam then
            StopFreecam()
        end
        
        -- Unview command (assuming execCmd is defined elsewhere)
        if execCmd then
            execCmd('unview')
        end
        
        -- Remove and recreate camera
        if workspace.CurrentCamera then
            workspace.CurrentCamera:Remove()
        end
        
        task.wait(0.1)
        
        -- Wait for character to load if not already loaded
        repeat task.wait() until speaker.Character

        -- Set camera properties
        if workspace.CurrentCamera then
            local humanoid = speaker.Character:FindFirstChildWhichIsA('Humanoid')
            if humanoid then
                workspace.CurrentCamera.CameraSubject = humanoid
            end
            workspace.CurrentCamera.CameraType = "Custom"
        end
        
        -- Set player camera properties
        speaker.CameraMinZoomDistance = 0.5
        speaker.CameraMaxZoomDistance = 400
        speaker.CameraMode = "Classic"
        
        -- Unanchor head if it exists
        if speaker.Character and speaker.Character:FindFirstChild("Head") then
            speaker.Character.Head.Anchored = false
        end
    end
})

-- // Proper UI Close Button
MiscSection2:addButton({
    title = "Close UI",
    callback = function()
        rainbowRunning = false
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        uiDestroyed = true
        
        task.spawn(function()
            -- First toggle off for visual effect
            UI:toggle()
            task.wait(0.5) -- Give a small delay before destroying
            
            for _, v in pairs(CoreGui:GetChildren()) do
                if v:IsA("ScreenGui") and v.Name:lower():find("venyx") then
                    v:Destroy()
                end
            end
            
        end)
    end
})

-- // END Key toggler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.End and not uiDestroyed then
        UI:toggle()
    end
end)

-- // Load
UI:SelectPage({
    page = UI.pages[1],
    toggle = true
})
