local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()
local Developer = "..."
local Version = "0.0.1"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local autoFarmEnabled = false
local isRespawning = false
local lastPosition = Vector3.new(0, 50, 0)

-- Create the main window
local Window = Luna:CreateWindow({
    Name = "Elystra.wtf",
    Subtitle = "Version " .. Version,
    LogoID = 82795327169782,
    LoadingEnabled = true,
    LoadingTitle = "Elystra.wtf Loading...",
    LoadingSubtitle = "by " .. Developer,
    ConfigSettings = {
        ConfigFolder = "LunaDemoConfig"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Luna Example Key",
        Subtitle = "Key System",
        Note = "HWID key system recommended",
        SaveInRoot = false,
        SaveKey = true,
        Key = {"Example Key"},
        SecondAction = {
            Enabled = true,
            Type = "Link",
            Parameter = ""
        }
    }
})

-- ✅ Luna notification wrapper
local function notify(title, text, icon, color)
    Luna:Notification({
        Title = title or "Notice",
        Icon = icon or "info",
        ImageSource = "Material",
        Content = text or "",
        Color = color or Color3.fromRGB(255, 255, 255)
    })
end

-- Create a tab
local Tab = Window:CreateTab({
    Name = "Auto Farm",
    Icon = "home",
    ImageSource = "Material",
    ShowTitle = true
})

Tab:CreateSection("Auto Farm")


local function updateCharacterReferences()
    character = player.Character
    if character then
        humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
        humanoid = character:WaitForChild("Humanoid", 10)
        if humanoidRootPart then
            lastPosition = humanoidRootPart.Position
        end
        if humanoid then
            humanoid.Died:Connect(function()
                print("Player died! Pausing auto farm...")
                isRespawning = true
                wait(0.5)
            end)
        end
    end
end

local function waitForRespawn()
    if isRespawning then
        print("Waiting for respawn...")
        local newCharacter = player.CharacterAdded:Wait()
        character = newCharacter
        humanoidRootPart = character:WaitForChild("HumanoidRootPart", 30)
        humanoid = character:WaitForChild("Humanoid", 30)
        if humanoidRootPart and humanoid then
            humanoid.Died:Connect(function()
                print("Player died! Pausing auto farm...")
                isRespawning = true
                wait(0.5)
            end)
            wait(2)
            print("Respawn complete! Resuming auto farm...")
            isRespawning = false
            notify("Auto Farm", "Respawned successfully! Resuming collection...", "check_circle", Color3.fromRGB(0, 255, 0))
        else
            warn("Failed to get character components after respawn!")
            isRespawning = false
        end
    end
end

local function findProximityPrompts()
    local prompts = {}
    local jelliesFolder = workspace:FindFirstChild("Jellies")
    if not jelliesFolder then
        return prompts
    end
    
    for _, child in pairs(jelliesFolder:GetChildren()) do
        local function searchForPrompts(obj)
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                table.insert(prompts, obj)
            end
            for _, subChild in pairs(obj:GetChildren()) do
                searchForPrompts(subChild)
            end
        end
        searchForPrompts(child)
    end
    return prompts
end

local function safeTeleportTo(position)
    if isRespawning then
        return false
    end
    if not character or not humanoidRootPart then
        updateCharacterReferences()
        if not humanoidRootPart then
            return false
        end
    end
    
    lastPosition = humanoidRootPart.Position
    local success, error = pcall(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
        local targetCFrame = CFrame.new(position + Vector3.new(0, 5, 0))
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    end)
    
    if not success then
        warn("Teleport failed: " .. tostring(error))
        return false
    end
    return true
end

local function safeTriggerPrompt(prompt)
    if isRespawning or not prompt or not prompt.Parent or not prompt.Enabled then
        return false
    end
    
    local success, error = pcall(function()
        prompt.MaxActivationDistance = math.huge
        prompt.HoldDuration = 0
        fireproximityprompt(prompt)
    end)
    
    if success then
        return true
    else
        warn("Failed to trigger prompt: " .. tostring(error))
        return false
    end
end

function startAutoFarm()
    spawn(function()
        print("Starting auto farm...")
        while autoFarmEnabled do
            if isRespawning then
                waitForRespawn()
                continue
            end
            
            if not character or not humanoidRootPart then
                updateCharacterReferences()
                wait(1)
                continue
            end
            
            local prompts = findProximityPrompts()
            if #prompts == 0 then
                wait(2)
                continue
            end
            
            for _, prompt in pairs(prompts) do
                if not autoFarmEnabled then
                    break
                end
                if isRespawning then
                    break
                end
                
                if prompt and prompt.Parent and prompt.Enabled then
                    local promptParent = prompt.Parent
                    local position
                    
                    if promptParent:IsA("BasePart") then
                        position = promptParent.Position
                    elseif promptParent:FindFirstChild("HumanoidRootPart") then
                        position = promptParent.HumanoidRootPart.Position
                    elseif promptParent:FindFirstChildOfClass("BasePart") then
                        position = promptParent:FindFirstChildOfClass("BasePart").Position
                    end
                    
                    if position then
                        local distance = (humanoidRootPart.Position - position).Magnitude
                        if distance > 10 then
                            if safeTeleportTo(position) then
                                wait(0.2)
                            else
                                continue
                            end
                        end
                        
                        if safeTriggerPrompt(prompt) then
                            task.wait(1)
                        end
                    end
                end
                wait(0.1)
            end
            wait(0.5)
        end
        print("Auto farm stopped.")
    end)
end

local AutoFarmJellyBear = Tab:CreateToggle({
    Name = "Auto Farm Jelly Bear (Event)",
    Description = "Automatically farms jelly bears with teleportation and respawn handling",
    CurrentValue = false,
    Callback = function(Value)
        autoFarmEnabled = Value
        if autoFarmEnabled then
            updateCharacterReferences()
            startAutoFarm()
            notify("Auto Farm", "Started jelly bear farming!", "play_arrow", Color3.fromRGB(0, 255, 0))
        else
            notify("Auto Farm", "Stopped farming", "stop", Color3.fromRGB(255, 0, 0))
        end
    end
})

local StatusLabel = Tab:CreateLabel("Farm Status: Ready to farm jelly bears!")
spawn(function()
    while true do
        if autoFarmEnabled then
            local status = isRespawning and "Respawning..." or "Farming Active"
            StatusLabel:Set("Farm Status: " .. status)
        else
            StatusLabel:Set("Farm Status: Stopped")
        end
        wait(1)
    end
end)

local AutoFarmMailDeliver = Tab:CreateToggle({
    Name = "Auto Farm Mail Delivery",
    Description = "Coming Soon - Mail delivery automation",
    CurrentValue = false,
    Callback = function(Value)
        notify("Coming Soon", "Mail delivery feature will be added in future updates!", "info", Color3.fromRGB(255, 255, 0))
    end
})

local AutoFarmMango = Tab:CreateToggle({
    Name = "Auto Farm Mango",
    Description = "Coming Soon - Mango farming automation",
    CurrentValue = false,
    Callback = function(Value)
        notify("Coming Soon", "Mango farming feature will be added in future updates!", "info", Color3.fromRGB(255, 255, 0))
    end
})

ProximityPromptService.PromptTriggered:Connect(function(prompt, triggerPlayer)
    if triggerPlayer == player and autoFarmEnabled and prompt.Parent and prompt.Parent.Parent == workspace.Jellies then
        print("Successfully collected jelly: " .. (prompt.Parent.Name or "Unknown"))
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    print("New character spawned!")
    character = newCharacter
    updateCharacterReferences()
end)

updateCharacterReferences()

spawn(function()
    while true do
        if autoFarmEnabled and not isRespawning then
            local success, error = pcall(function()
                local prompts = findProximityPrompts()
                for _, prompt in pairs(prompts) do
                    if autoFarmEnabled and prompt.Enabled and not isRespawning then
                        local promptParent = prompt.Parent
                        if promptParent and promptParent:IsA("BasePart") and humanoidRootPart then
                            local distance = (humanoidRootPart.Position - promptParent.Position).Magnitude
                            prompt.MaxActivationDistance = math.huge
                            prompt.HoldDuration = 0
                            if distance <= 20 then
                                safeTriggerPrompt(prompt)
                            end
                        end
                    end
                end
            end)
            if not success then
                warn("Monitoring error: " .. tostring(error))
            end
        end
        wait(0.3)
    end
end)

-- Initial notification
notify("Welcome!", "Elystra.wtf loaded successfully", "notifications_active", Color3.fromRGB(0, 255, 255))

-- Always add this at the end to autoload config
Luna:LoadAutoloadConfig()
