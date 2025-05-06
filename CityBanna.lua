local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local UI = Venyx.new({
    title = "Elystra.wtf | Beta | V0.0.2"
    
})

local currentNotification = nil

local oldNotify = UI.Notify
UI.Notify = function(self, options)
    if currentNotification then
        pcall(function()
            currentNotification:Destroy()
            currentNotification = nil
        end)
    end
    
    currentNotification = oldNotify(self, options)

    task.spawn(function()
        task.wait(3)
        if currentNotification then
            pcall(function()
                currentNotification:Destroy()
                currentNotification = nil 
            end)
        end
    end)
    
    return currentNotification
end

local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

local function tweenTo(pos, speed)
    if not humanoidRootPart then return end
    
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Sit = false
    end
    
    local startPos = humanoidRootPart.Position
    local distance = (startPos - pos).Magnitude
    local time = distance / (speed or 150) 
    
    local info = TweenInfo.new(
        time,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(humanoidRootPart, info, {
        CFrame = CFrame.new(pos) * CFrame.new(0, 2, 0) 
    })

    local sitPrevention
    sitPrevention = RunService.Heartbeat:Connect(function()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Sit = false
        end
    end)

    local success, err = pcall(function()
        tween:Play()
        tween.Completed:Wait()
    end)
    
    if sitPrevention then
        sitPrevention:Disconnect()
    end
    
    if not success then
        warn("Tween failed:", err)
        tween:Cancel()
    end
    
    return success
end

-- // Mobile UI Handler
local function createMobileButton()
    local ScreenGui = Instance.new("ScreenGui")
    local OpenButton = Instance.new("TextButton")
    local CloseButton = Instance.new("TextButton")
    
    ScreenGui.Name = "MobileUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    OpenButton.Name = "OpenUI"
    OpenButton.Parent = ScreenGui
    OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenButton.Position = UDim2.new(0.85, 0, 0.8, 0)
    OpenButton.Size = UDim2.new(0, 50, 0, 50)
    OpenButton.Font = Enum.Font.GothamBold
    OpenButton.Text = "OPEN"
    OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenButton.TextSize = 14.000
    OpenButton.TextWrapped = true
    OpenButton.Visible = true
    OpenButton.Active = true
    OpenButton.Draggable = true
    
    CloseButton.Name = "CloseUI"
    CloseButton.Parent = ScreenGui
    CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CloseButton.Position = UDim2.new(0.85, 0, 0.8, 0)
    CloseButton.Size = UDim2.new(0, 50, 0, 50)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "CLOSE"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14.000
    CloseButton.TextWrapped = true
    CloseButton.Visible = false
    CloseButton.Active = true
    CloseButton.Draggable = true
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 8)
    corner1.Parent = OpenButton
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = CloseButton

    OpenButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(OpenButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    OpenButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(OpenButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end)

    CloseButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end)
    
    OpenButton.MouseButton1Click:Connect(function()
        UI:toggle()
        OpenButton.Visible = false
        CloseButton.Visible = true
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        UI:toggle()
        CloseButton.Visible = false
        OpenButton.Visible = true
    end)
    
    return ScreenGui
end

local mobileUI = createMobileButton()

-- // Themes config 
local Themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

UI:Notify({
    title = "Loaded!",
    text = "Use at ur own risk",
})

-- // Auto Farm Page
local AutoFarm = UI:addPage({ title = "Auto Farm", icon = 5012544693 })
local SectionA = AutoFarm:addSection({ title = "Auto Farm" })
local SectionB = AutoFarm:addSection({ title = "Auto Sell" })

local autoPromptEnabled = false
local autoSellEnabled = false
local alwaysEnablePrompt = false
local autoTweenEnabled = false
local tweenPlatform = nil
local autoFarmGoldEnabled = false

local function createTweenPlatform(position)
    if tweenPlatform then
        tweenPlatform:Destroy()
    end
    
    tweenPlatform = Instance.new("Part")
    tweenPlatform.Anchored = true
    tweenPlatform.Size = Vector3.new(15, 1, 15)
    tweenPlatform.Position = position + Vector3.new(0, -4.5, 0)
    tweenPlatform.Transparency = 0.5
    tweenPlatform.BrickColor = BrickColor.new("Really White")
    tweenPlatform.CanCollide = true
    tweenPlatform.Name = "TweenPlatform"
    tweenPlatform.Parent = workspace

    local platformConnection
    platformConnection = RunService.Heartbeat:Connect(function()
        if not tweenPlatform or not autoTweenEnabled then
            if platformConnection then
                platformConnection:Disconnect()
            end
            return
        end
        
        if humanoidRootPart then
            tweenPlatform.Position = humanoidRootPart.Position + Vector3.new(0, -4.5, 0)
        end
    end)
end

local function safeTweenTo(pos, speed)
    if not humanoidRootPart then return end
    
    if not tweenPlatform then
        createTweenPlatform(humanoidRootPart.Position)
    end
    
    local distance = (humanoidRootPart.Position - pos).Magnitude
    local time = distance / speed
    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

SectionA:addToggle({
    title = "Auto Farm Gold",
    callback = function(value)
        autoFarmGoldEnabled = value
        
        autoPromptEnabled = value
        alwaysEnablePrompt = value
        autoTweenEnabled = value
        
        for _, toggle in pairs(SectionA:GetComponents()) do
            if toggle.Type == "Toggle" then
                if toggle.Title == "Auto Prompt ทอง" or 
                   toggle.Title == "Enable Prompt เมื่อร้านปิด" or
                   toggle.Title == "Auto Tween" then
                    toggle:Set(value)
                end
            end
        end
    end
})

local autoTrashConnection

SectionA:addToggle({
    title = "Auto Collect Trash",
    callback = function(enabled)
        if enabled then
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            autoTrashConnection = true 

            local function sellTrash()
                humanoidRootPart.CFrame = CFrame.new(Vector3.new(51.839500, 69.451118, 6.100793))
                task.wait(0.5)
                local args = { [1] = "Sell", [2] = "Trash" }
                game:GetService("ReplicatedStorage"):WaitForChild("GLOBAL_VALUES"):WaitForChild("ConfigrationFolder"):WaitForChild("GlobalEvent"):FireServer(unpack(args))
            end

            local function teleportAndHoldPrompt(prompt)
                if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local part = prompt.Parent
                    if part and part:IsA("BasePart") then
                        humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.25)
                        pcall(function()
                            prompt:InputHoldBegin()
                            task.wait(8)
                            prompt:InputHoldEnd()
                        end)
                        task.wait(0.3)
                        return true
                    end
                end
                return false
            end

            task.spawn(function()
                while autoTrashConnection do
                    local foundTrash = false
                    
                    local prompts = workspace:FindFirstChild("SpawnTrashFolder")
                    if prompts then
                        local spawns = prompts:FindFirstChild("Spawns")
                        if spawns then
                            for _, prompt in ipairs(spawns:GetDescendants()) do
                                if not autoTrashConnection then break end
                                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                                    foundTrash = teleportAndHoldPrompt(prompt)
                                    if foundTrash then break end
                                end
                            end
                        end
                    end
                    
                    if not foundTrash then
                        local garbageFolder = workspace:FindFirstChild("Others")
                        if garbageFolder and garbageFolder:FindFirstChild("Garbage") then
                            for _, prompt in ipairs(garbageFolder.Garbage:GetDescendants()) do
                                if not autoTrashConnection then break end
                                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                                    foundTrash = teleportAndHoldPrompt(prompt)
                                    if foundTrash then break end
                                end
                            end
                        end
                    end

                    if not foundTrash then
                        sellTrash()
                        task.wait(1)
                    end

                    task.wait(0.5)
                end
            end)

        else
            autoTrashConnection = false
        end
    end
})

SectionA:addToggle({
    title = "Auto ClaimGift",
    default = true, 
    callback = function(value)
        _G.autoClaimGift = value
        
        if value then
            for i = 1, 9 do
                local args = {i}
                game:GetService("ReplicatedStorage"):WaitForChild("GiftFolder"):WaitForChild("ClaimGift"):InvokeServer(unpack(args))
            end
            
            if not _G.claimGiftLoop then
                _G.claimGiftLoop = task.spawn(function()
                    while _G.autoClaimGift do
                        for i = 1, 9 do
                            local args = {i}
                            game:GetService("ReplicatedStorage"):WaitForChild("GiftFolder"):WaitForChild("ClaimGift"):InvokeServer(unpack(args))
                        end
                        task.wait(20) 
                    end
                end)
            end
        else
            if _G.claimGiftLoop then
                task.cancel(_G.claimGiftLoop)
                _G.claimGiftLoop = nil
            end
        end
    end
})

task.spawn(function()
    _G.autoClaimGift = true
    SectionA:GetToggle("Auto ClaimGift"):Set(true)
end)

SectionB:addToggle({
    title = "Auto Sell Gold",
    callback = function(value)
        autoSellEnabled = value
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Vector3.new(51.839500, 69.451118, 6.100793))
    end
})

task.spawn(function()
    while true do
        if autoPromptEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
                    local dist = (humanoidRootPart.Position - v.Parent.Position).Magnitude
                    if dist < 10 then
                        pcall(function()
                            v.HoldDuration = 0
                            v:InputHoldBegin()
                            task.wait(0.5)
                            v:InputHoldEnd()
                        end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if autoSellEnabled then
            pcall(function()
                local args = { [1] = "Sell", [2] = "Gold" }
                ReplicatedStorage:WaitForChild("GLOBAL_VALUES"):WaitForChild("ConfigrationFolder"):WaitForChild("GlobalEvent"):FireServer(unpack(args))
            end)
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        if alwaysEnablePrompt then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    pcall(function()
                        v.Enabled = true
                    end)
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if autoTweenEnabled then

            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(Vector3.new(237.833130, 70.167351, 62.568726))

            local firstPos = Vector3.new(242, 70, 56)
            local secondPos = Vector3.new(141, 70, 277)

            safeTweenTo(firstPos, 10)
            
            for _ = 1, 2 do 
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
                        local dist = (humanoidRootPart.Position - v.Parent.Position).Magnitude
                        if dist < 10 then
                            pcall(function()
                                v.HoldDuration = 0
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                            end)
                        end
                    end
                end
            end
            
            safeTweenTo(secondPos, 15)
            
            for _ = 1, 4 do
                if not autoTweenEnabled then break end
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
                        local dist = (humanoidRootPart.Position - v.Parent.Position).Magnitude
                        if dist < 10 then
                            pcall(function()
                                v.HoldDuration = 0
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                            end)
                        end
                    end
                end
                task.wait(0.1)
            end

            safeTweenTo(firstPos, 15)
            
            for _ = 1, 400 do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
                        local dist = (humanoidRootPart.Position - v.Parent.Position).Magnitude
                        if dist < 10 then
                            pcall(function()
                                v.HoldDuration = 0
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                            end)
                        end
                    end
                end
            end
            
            task.wait(50)

            if tweenPlatform then
                tweenPlatform:Destroy()
                tweenPlatform = nil
            end
        else
            if tweenPlatform then
                tweenPlatform:Destroy()
                tweenPlatform = nil
            end
        end
        task.wait(0.1)
    end
end)

-- // END 

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


local PlatformSection = Aroundmap:addSection({ title = "Platform" })

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

PlatformSection:addSlider({
    title = "Platform Height",
    default = 100,
    min = 50,
    max = 500,
    callback = function(value)
        platformHeight = value
        if platform and platformEnabled then
            local currentPos = platform.Position
            platform.Position = Vector3.new(currentPos.X, value, currentPos.Z)
            
            local player = game.Players.LocalPlayer
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(Vector3.new(currentPos.X, value + 3, currentPos.Z))
                end
            end
        end
    end
})

PlatformSection:addColorPicker({
    title = "Platform Color",
    default = Color3.fromRGB(0, 0, 255),
    callback = function(color)
        if platform then
            platform.Color = color
        end
    end
})

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

local function teleportTo(cFrame)
    local hrp = getHRP()
    hrp.CFrame = cFrame
end

local function performHealCycle(originalCFrame, hospitalCFrame, breakSpotCFrame)
    local humanoid = getHumanoid()
    local hrp = getHRP()
    if not humanoid or not hrp then return end

    teleportTo(hospitalCFrame)
    humanoid.PlatformStand = true
    UI:Notify({ title = "Auto Heal", text = "Teleporting to hospital..." })

    local nudgeUp = true
    while humanoid.Health < humanoid.MaxHealth do
        local pos = hrp.Position
        local offset = nudgeUp and Vector3.new(0, 0.1, 0) or Vector3.new(0, -0.1, 0)
        hrp.CFrame = CFrame.new(pos + offset)
        nudgeUp = not nudgeUp
        task.wait(1)
    end
    UI:Notify({ title = "Auto Heal", text = "Healed!" })

    teleportTo(breakSpotCFrame)
    task.wait(2.5)
    UI:Notify({ title = "Auto Heal", text = "Break spot reached." })

    while humanoid.Health < humanoid.MaxHealth do
        local pos = hrp.Position
        local offset = nudgeUp and Vector3.new(0, 0.1, 0) or Vector3.new(0, -0.1, 0)
        hrp.CFrame = CFrame.new(pos + offset)
        nudgeUp = not nudgeUp
        task.wait(1)
    end
    UI:Notify({ title = "Auto Heal", text = "Final heal complete!" })

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
            autoHealEnabled = false 
            local hrp = getHRP()
            local originalCFrame = hrp.CFrame
            local hospitalCFrame = CFrame.new(186.795425, 127.700378, 45739.597656)
            local breakSpotCFrame = CFrame.new(160, 127.7, 45720)
            performHealCycle(originalCFrame, hospitalCFrame, breakSpotCFrame)
            autoHealEnabled = true
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
            region = region:ExpandToGrid(4) 
            local parts = Workspace:FindPartsInRegion3(region, nil, math.huge)
            return #parts > 0
        end

        local function healCycle()
            UI:Notify({ title = "Auto Heal", text = "Loading hospital area..." })
            teleportTo(hospitalCFrame) 
            repeat
                task.wait(0.5)
            until preloadChunk(hospitalCFrame.Position, 32)

            task.wait(0.5)

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


-- // Players

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local selectedPlayerName = nil
local dropdown

local isSpectating = false
local spectateLoop = nil
local targetSpectatePlayer = nil

local function safeGetPlayerNames()
    local names = {}
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player and player.Name and player ~= LocalPlayer then
                table.insert(names, player.Name)
            end
        end
    end)
    return names
end

local function spectatePlayer(playerName)
    if isSpectating then
        stopSpectating()
    end

    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer then 
        UI:Notify({
            title = "Spectate Error",
            text = "Player not found!"
        })
        return 
    end

    isSpectating = true
    targetSpectatePlayer = playerName

    -- Create a loop to maintain spectating
    if spectateLoop then
        spectateLoop:Disconnect()
    end

    spectateLoop = RunService.RenderStepped:Connect(function()
        if not isSpectating then return end
        
        local target = Players:FindFirstChild(targetSpectatePlayer)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = target.Character.Humanoid
            Camera.CameraType = Enum.CameraType.Custom
        else
            stopSpectating()
            UI:Notify({
                title = "Spectate Error",
                text = "Lost target player!"
            })
        end
    end)

    UI:Notify({
        title = "Spectate",
        text = "Now spectating: " .. playerName
    })
end

local function stopSpectating()
    isSpectating = false
    targetSpectatePlayer = nil
    
    if spectateLoop then
        spectateLoop:Disconnect()
        spectateLoop = nil
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
        Camera.CameraType = Enum.CameraType.Custom
    end

    UI:Notify({
        title = "Spectate",
        text = "Stopped spectating"
    })
end

local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame
            UI:Notify({
                title = "Teleport Success",
                text = "Teleported to " .. playerName
            })
        end
    else
        UI:Notify({
            title = "Teleport Error",
            text = "Could not teleport to player!"
        })
    end
end

local function validatePlayer(name)
    if not name then return false end
    local player = Players:FindFirstChild(name)
    return player ~= nil and player ~= LocalPlayer
end

local function updatePlayerLists()
    pcall(function()
        local prevSelectedPlayer = selectedPlayerName
        local prevTradePlayer = selectedTradePlayer
        local playerList = safeGetPlayerNames()

        if dropdown then 
            dropdown:Remove()
            dropdown = nil
            SectionB:UpdateDropdown({}) 
        end
        
        if tradeDropdown then
            tradeDropdown:Remove()
            tradeDropdown = nil
            TradeSection:UpdateDropdown({}) 
        end

        task.wait(0.1) 

        if #playerList > 0 then
            if SectionB and not dropdown then
                dropdown = SectionB:addDropdown({
                    title = "Select Player",
                    list = playerList,
                    default = validatePlayer(prevSelectedPlayer) and prevSelectedPlayer or nil,
                    callback = function(name)
                        if name and Players:FindFirstChild(name) then
                            selectedPlayerName = name
                            UI:Notify({
                                title = "Player Selected",
                                text = "Selected: " .. name
                            })
                        end
                    end
                })
            end
            
            if TradeSection and not tradeDropdown then
                tradeDropdown = TradeSection:addDropdown({
                    title = "Select Player",
                    list = playerList,
                    default = validatePlayer(prevTradePlayer) and prevTradePlayer or nil,
                    callback = function(name)
                        if name and Players:FindFirstChild(name) then
                            selectedTradePlayer = name
                            UI:Notify({
                                title = "Trade Player Selected",
                                text = string.format("Selected: %s (%d players)", name, #playerList)
                            })
                        end
                    end
                })
            end
        end
    end)
end

local function refreshAllDropdowns()
    updatePlayerLists()
end

task.spawn(function()
    updatePlayerLists()
end)

Players.PlayerAdded:Connect(function(player)
    task.wait(0.1) 
    updatePlayerLists()
end)

Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1) 
    updatePlayerLists()
end)

SectionB:addButton({
    title = "Refresh Player List",
    callback = function()
        refreshAllDropdowns()
        UI:Notify({
            title = "Refresh",
            text = "Refreshing player lists..."
        })
    end
})

SectionB:addButton({
    title = "Spectate Player",
    callback = function()
        if selectedPlayerName then
            spectatePlayer(selectedPlayerName)
        else
            UI:Notify({
                title = "Spectate Error",
                text = "No player selected."
            })
        end
    end
})

SectionB:addButton({
    title = "Stop Spectating",
    callback = function()
        stopSpectating()
    end
})

SectionB:addButton({
    title = "Teleport to Player",
    callback = function()
        if selectedPlayerName then
            teleportToPlayer(selectedPlayerName)
        else
            UI:Notify({
                title = "Teleport Error",
                text = "Please select a player first!"
            })
        end
    end
})

local transferAmount = 0

SectionB:addTextbox({
    title = "Transfer Amount",
    default = "0",
    callback = function(value)
        transferAmount = tonumber(value) or 0
    end
})

SectionB:addButton({
    title = "Transfer Money",
    callback = function()
        if not selectedPlayerName then
            UI:Notify({
                title = "Transfer Error",
                text = "Please select a player first!"
            })
            return
        end
        
        transferMoney(transferAmount, selectedPlayerName)
    end
})

local function depositMoney(amount)
    if amount <= 0 then
        UI:Notify({
            title = "Deposit Error",
            text = "Please enter a valid amount!"
        })
        return
    end
    
    pcall(function()
        local args = {
            "Deposit",
            amount
        }
        
        local result = game:GetService("ReplicatedStorage"):WaitForChild("BankFolder"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
        
        if result then
            UI:Notify({
                title = "Deposit Success",
                text = "Deposited $" .. amount .. " into bank"
            })
        end
    end)
end

local function withdrawMoney(amount)
    if amount <= 0 then
        UI:Notify({
            title = "Withdraw Error",
            text = "Please enter a valid amount!"
        })
        return
    end
    
    pcall(function()
        local args = {
            "Withdraw",
            amount
        }
        
        local result = game:GetService("ReplicatedStorage"):WaitForChild("BankFolder"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
        
        if result then
            UI:Notify({
                title = "Withdraw Success",
                text = "Withdrew $" .. amount .. " from bank"
            })
        end
    end)
end

local bankAmount = 0

SectionB:addTextbox({
    title = "Bank Amount",
    default = "0",
    callback = function(value)
        bankAmount = tonumber(value) or 0
    end
})

SectionB:addButton({
    title = "Deposit Money",
    callback = function()
        depositMoney(bankAmount)
    end
})

SectionB:addButton({
    title = "Withdraw Money",
    callback = function()
        withdrawMoney(bankAmount)
    end
})

-- END

SectionB:addSlider({
    title = "Walk Speed",
    default = 16, 
    min = 0,
    max = 1000,
    callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
        
        _G.savedWalkSpeed = value

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


-- // Misc Page
local Misc = UI:addPage({ title = "Misc", icon = 5012544693 })
local MiscSection = Misc:addSection({ title = "Utility" })
local MiscSection2 = Misc:addSection({ title = "Vehicle" })
local MiscSection3 = Misc:addSection({ title = "Ui" })

local antiAFKEnabled = true

Players.LocalPlayer.Idled:Connect(function()
	if antiAFKEnabled then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

MiscSection:addToggle({
    title = "Anti AFK",
    default = true, 
    callback = function(value)
        antiAFKEnabled = value
        print("Anti AFK:", antiAFKEnabled)
    end
})

local uiDestroyed = false

-- // NoClip

local noclipConnection
local noclipEnabled = false

MiscSection:addToggle({
    title = "Noclip",
    callback = function(value)
        noclipEnabled = value

        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        if noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = Players.LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local character = Players.LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and not part.CanCollide then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

MiscSection:addButton({
    title = "Remove Cam Shake",
    callback = function()
        local RunService = game:GetService("RunService")
        local UserGameSettings = UserSettings():GetService("UserGameSettings")
        
        UserGameSettings.CameraShake = 0
        
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("CameraScript") or v:IsA("Camera") then
                pcall(function()
                    v.CameraShake = 0
                    v.CameraShakeInstance = nil
                    v:Destroy()
                end)
            end
        end
        
        UI:Notify({
            title = "Camera Shake",
            text = "Camera shake has been disabled"
        })
    end
})


local function updateVehicleSpeed(speed: number)
    local args = {
        {
            {
                "\009",
                "Speed",
                speed
            }
        }
    }
    RemoteEvent:FireServer(unpack(args))
end

MiscSection2:addSlider({
    title = "Vehicle Speed",
    default = 1,
    min = 1,
    max = 100,
    increment = 1,
    callback = function(value: number)
        updateVehicleSpeed(value)
    end
})


MiscSection2:addButton({
    title = "Vehicle Fly ( One Click Only )",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ReactorCoreDev/VehicleFly/refs/heads/main/main.lua"))()
        UI:Notify({
            title = "Vehicle Fly",
            text = "Credit: ReactorCoreDev"
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
        

        if execCmd then
            execCmd('unview')
        end
        
        if workspace.CurrentCamera then
            workspace.CurrentCamera:Remove()
        end
        
        task.wait(0.1)
        
        repeat task.wait() until speaker.Character

        if workspace.CurrentCamera then
            local humanoid = speaker.Character:FindFirstChildWhichIsA('Humanoid')
            if humanoid then
                workspace.CurrentCamera.CameraSubject = humanoid
            end
            workspace.CurrentCamera.CameraType = "Custom"
        end
        
        speaker.CameraMinZoomDistance = 0.5
        speaker.CameraMaxZoomDistance = 400
        speaker.CameraMode = "Classic"
        
        if speaker.Character and speaker.Character:FindFirstChild("Head") then
            speaker.Character.Head.Anchored = false
        end
    end
})

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
    title = "Turn off PVP",
    default = false,
    callback = function(value)
        local args = {
            "PVP",
            false
        }
        game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer(unpack(args))
        
    end
})

MiscSection:addButton({
    title = "Turn on PVP",
    default = false,
    callback = function(value)
        local args = {
            "PVP",
            true
        }
        game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer(unpack(args))
        
    end
})
local player = Players.LocalPlayer

MiscSection:addButton({
    title = "Reset",
    callback = function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local savedPosition = character.HumanoidRootPart.Position

            player.CharacterAdded:Once(function(newChar)
                local hrp = newChar:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(savedPosition + Vector3.new(0, 5, 0)) 
            end)

            if character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = 0
            end
        end
    end
})

-- // Proper UI Close Button
MiscSection3:addButton({
    title = "Close UI",
    callback = function()
        if tweenPlatform then
            tweenPlatform:Destroy()
            tweenPlatform = nil
        end

        rainbowRunning = false
        autoFarmEnabled = false
        antiAFKEnabled = false
        noclipEnabled = false
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if autoHealConnection then
            autoHealConnection:Disconnect()
            autoHealConnection = nil
        end
        
        if _G.walkSpeedConnection then
            _G.walkSpeedConnection:Disconnect()
            _G.walkSpeedConnection = nil
        end

        local player = game.Players.LocalPlayer
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
            
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        _G.savedWalkSpeed = nil
        
        for _, v in pairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") then
                for _, notification in pairs(v:GetChildren()) do
                    if notification.Name == "Notification" or notification:FindFirstChild("Title") then
                        notification:Destroy()
                    end
                end
            end
        end
        
        uiDestroyed = true
        
        if mobileUI then
            mobileUI:Destroy()
        end
        
        task.spawn(function()
            UI:toggle()
            task.wait(0.5)
            
            for _, v in pairs(CoreGui:GetChildren()) do
                if v:IsA("ScreenGui") and (v.Name:lower():find("venyx") or v.Name:lower():find("elystra")) then
                    v:Destroy()
                end
            end

        end)
    end
})

-- // Trade
local Trading = UI:addPage({ title = "Trade", icon = 5012544693 })
local TradeSection = Trading:addSection({ title = "Trade" })

local selectedTradePlayer = nil
local tradeDropdown

local function createTradeDropdown()
    if tradeDropdown then
        pcall(function()
            tradeDropdown:Remove()
            tradeDropdown = nil
        end)
        task.wait(0.1) 
    end
    
    local playerList = safeGetPlayerNames()
    
    if selectedTradePlayer and not table.find(playerList, selectedTradePlayer) then
        selectedTradePlayer = nil
    end

    if #playerList > 0 and not tradeDropdown then
        tradeDropdown = TradeSection:addDropdown({
            title = "Select Player",
            list = playerList,
            default = selectedTradePlayer,
            callback = function(name)
                if name and Players:FindFirstChild(name) then
                    selectedTradePlayer = name
                    UI:Notify({
                        title = "Trade Player",
                        text = string.format("Selected: %s (%d players online)", name, #playerList)
                    })
                end
            end
        })
    else
        UI:Notify({
            title = "Trade List",
            text = #playerList == 0 and "No players available" or "Refreshed player list"
        })
    end
end

TradeSection:addButton({
    title = "Refresh Trade List",
    callback = function()
        task.spawn(function()
            createTradeDropdown()
        end)
    end
})

TradeSection:addButton({
    title = "Send Trade",
    callback = function()
        if not selectedTradePlayer then
            UI:Notify({
                title = "Trade Error",
                text = "Please select a player first!"
            })
            return
        end

        local targetPlayer = Players:FindFirstChild(selectedTradePlayer)
        if targetPlayer then
            local args = { targetPlayer }
            ReplicatedStorage:WaitForChild("Trade_Folder"):WaitForChild("Trade_Notify"):FireServer(unpack(args))

            UI:Notify({
                title = "Trade Sent",
                text = "Trade request sent to " .. selectedTradePlayer
            })
        else
            UI:Notify({
                title = "Trade Error",
                text = "Player not found!"
            })
        end
    end
})

createTradeDropdown()

Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    refreshAllDropdowns()
end)

Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1)
    if player.Name == selectedTradePlayer then
        selectedTradePlayer = nil
    end
    refreshAllDropdowns()
end)

-- // Theme Page
local Theme = UI:addPage({ title = "Theme", icon = 5012544693 })
local Colors = Theme:addSection({ title = "Colors" })

-- // Add Rainbow Theme toggle first
local rainbowConnection = nil
local rainbowRunning = false

Colors:addToggle({
    title = "RGB Theme",
    callback = function(state)
        rainbowRunning = state
        
        if rainbowRunning then
            if rainbowConnection then
                rainbowConnection:Disconnect()
            end
            
            rainbowConnection = RunService.RenderStepped:Connect(function()
                local hue = tick() % 10 / 10  
                local color = Color3.fromHSV(hue, 1, 1) 


                UI:setTheme({ theme = "TextColor", color3 = color })
                UI:setTheme({ theme = "Glow", color3 = color })
            end)
        else
            if rainbowConnection then
                rainbowConnection:Disconnect()
                rainbowConnection = nil

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
