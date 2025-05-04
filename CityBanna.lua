local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local UI = Venyx.new({
    title = "Elystra.wtf | Beta | V0.0.1"
    
})

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
    
    local startPos = humanoidRootPart.Position
    local distance = (startPos - pos).Magnitude
    local time = distance / (speed * 6) 
    
    local heightOffset = math.min(distance * 0.15, 15)
    local midPoint = startPos + (pos - startPos) * 0.5 + Vector3.new(0, heightOffset, 0)
    
    local info = TweenInfo.new(
        time * 0.5, 
        Enum.EasingStyle.Linear, 
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local waypoints = {
        CFrame.new(startPos),
        CFrame.new(midPoint),
        CFrame.new(pos)
    }
    
    for i = 2, #waypoints do
        local tween = TweenService:Create(humanoidRootPart, info, {
            CFrame = waypoints[i]
        })
        tween:Play()
        tween.Completed:Wait()
    end
end

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
local SectionA = AutoFarm:addSection({ title = "Auto Farm Gold" })

local autoPromptEnabled = false
local autoSellEnabled = false
local alwaysEnablePrompt = false
local autoTweenEnabled = false
local tweenPlatform = nil

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
    title = "Auto Prompt ทอง",
    callback = function(value)
        autoPromptEnabled = value
    end
})

SectionA:addToggle({
    title = "Auto Sell ทอง",
    callback = function(value)
        autoSellEnabled = value
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Vector3.new(51.839500, 69.451118, 6.100793))
    end
})

SectionA:addToggle({
    title = "Enable Prompt เมื่อร้านปิด",
    callback = function(value)
        alwaysEnablePrompt = value
    end
})

SectionA:addToggle({
    title = "Auto Tween",
    callback = function(value)
        autoTweenEnabled = value
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

local function teleportTo(cframe)
    local hrp = getHRP()
    hrp.CFrame = cframe
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

local function getPlayerNames()
    local names = table.create(#Players:GetPlayers() - 1)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local function spectatePlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = targetPlayer.Character.Humanoid
        Camera.CameraType = Enum.CameraType.Custom
        print("Now spectating:", playerName)
    else
        warn("Could not spectate player:", playerName)
    end
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

local function stopSpectating()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
        Camera.CameraType = Enum.CameraType.Custom
        print("Stopped spectating.")
    end
end

local function transferMoney(amount, playerName)
    if amount <= 0 then
        UI:Notify({
            title = "Transfer Error",
            text = "Please enter a valid amount!"
        })
        return
    end
    
    pcall(function()
        local args = {
            "Transfer",
            amount,
            playerName
        }
        
        local result = game:GetService("ReplicatedStorage"):WaitForChild("BankFolder"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
        
        if result then
            UI:Notify({
                title = "Transfer Success",
                text = "Transferred $" .. amount .. " to " .. playerName
            })
        end
    end)
end

local function createPlayerDropdown()
    -- Remove existing dropdown
    if dropdown then
        dropdown:Remove()
        dropdown = nil
    end
    
    local playerList = getPlayerNames()
    
    -- Reset selected player if they're no longer in game
    if selectedPlayerName then
        local playerStillExists = false
        for _, name in ipairs(playerList) do
            if name == selectedPlayerName then
                playerStillExists = true
                break
            end
        end
        if not playerStillExists then
            selectedPlayerName = nil
        end
    end
    
    -- Create new dropdown with current player list
    if #playerList > 0 then
        dropdown = SectionB:addDropdown({
            title = "Select Player",
            list = playerList,
            callback = function(name)
                selectedPlayerName = name
                UI:Notify({
                    title = "Player Selected",
                    text = "Selected: " .. name
                })
            end
        })
    else
        UI:Notify({
            title = "Player List",
            text = "No other players found!"
        })
    end
end

local function refreshAllDropdowns()
    pcall(function()
        local prevSelectedPlayer = selectedPlayerName
        local prevTradePlayer = selectedTradePlayer
        
        if dropdown then
            dropdown:Remove()
            dropdown = nil
        end
        if tradeDropdown then
            tradeDropdown:Remove()
            tradeDropdown = nil
        end
        
        selectedPlayerName = nil
        selectedTradePlayer = nil
        
        local playerList = getPlayerNames() 
        
        if #playerList > 0 then
            dropdown = SectionB:addDropdown({
                title = "Select Player",
                list = playerList,
                default = prevSelectedPlayer,
                callback = function(name)
                    selectedPlayerName = name
                    UI:Notify({
                        title = "Player Selected",
                        text = "Selected: " .. name
                    })
                end
            })
            
            tradeDropdown = TradeSection:addDropdown({
                title = "Select Player",
                list = playerList,
                default = prevTradePlayer,
                callback = function(name)
                    selectedTradePlayer = name
                    UI:Notify({
                        title = "Trade Player Selected",
                        text = "Selected: " .. name
                    })
                end
            })
        end
        
        UI:Notify({
            title = "Refresh Complete",
            text = "Player lists have been updated"
        })
    end)
end

SectionB:addButton({
    title = "Refresh Player List",
    callback = refreshAllDropdowns
})

createPlayerDropdown()

Players.PlayerAdded:Connect(function(player)
    task.wait(0.1) 
    refreshAllDropdowns()
end)

Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1) 
    if player.Name == selectedPlayerName then
        selectedPlayerName = nil
    end
    refreshAllDropdowns()
end)

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
local MiscSection2 = Misc:addSection({ title = "Ui" })

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
MiscSection2:addButton({
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
        tradeDropdown:Remove()
        tradeDropdown = nil
    end
    
    local playerList = getPlayerNames()
    
    if selectedTradePlayer then
        local playerStillExists = false
        for _, name in ipairs(playerList) do
            if name == selectedTradePlayer then
                playerStillExists = true
                break
            end
        end
        if not playerStillExists then
            selectedTradePlayer = nil
        end
    end
    
    if #playerList > 0 then
        tradeDropdown = TradeSection:addDropdown({
            title = "Select Player",
            list = playerList,
            callback = function(name)
                selectedTradePlayer = name
                UI:Notify({
                    title = "Trade Player Selected",
                    text = "Selected: " .. name
                })
            end
        })
    else
        UI:Notify({
            title = "Player List",
            text = "No other players found!"
        })
    end
end

TradeSection:addButton({
    title = "Refresh List",
    callback = refreshAllDropdowns
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

-- Rainbow Theme Toggle
Colors:addToggle({
    title = "Rainbow Theme",
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
