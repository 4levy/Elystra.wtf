local tween_s = game:GetService("TweenService")
local TweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local lp = game.Players.LocalPlayer

local teleport_table = {
    spawn = Vector3.new(339, 7, 185),
    gunStore = Vector3.new(493, 7, 1163),
    carstore = Vector3.new(203, 8, 1211),
    hospital = Vector3.new(-183, 8, 1507),
    policestation = Vector3.new(788, 14, -31),
    MilitaryBase = Vector3.new(2980, 7, 2653),
    diyStore = Vector3.new(-287, 7, -11),
}

local function createFollowPlatform(character)
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(6, 1, 6)
    platform.Anchored = true
    platform.Transparency = 0.5
    platform.Parent = workspace
    
    local connection = game:GetService("RunService").Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            platform.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
            platform.Color = Color3.fromHSV(tick() % 1, 1, 1)
        else
            platform:Destroy()
            connection:Disconnect()
        end
    end)
    
    return platform, connection
end

local function teleport(v)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        warn("Character or HumanoidRootPart not found!")
        return
    end

    local character = lp.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character.HumanoidRootPart

    if humanoid then
        local sitConnection
        sitConnection = humanoid.Seated:Connect(function(active)
            if active then
                humanoid.Jump = true
                humanoid.Sit = false
            end
        end)

        local originalCollisions = {}
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisions[part] = part.CanCollide
                part.CanCollide = false
            end
        end

        local originalVelocity = root.Velocity
        local originalState = humanoid:GetState()
        
        root.Velocity = Vector3.new(0, 0, 0)
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        local cf = CFrame.new(v)
        local tween = tween_s:Create(root, TweenInfo, {
            CFrame = cf,
            Velocity = Vector3.new(0, 0, 0)
        })
        
        local stateConn = humanoid.StateChanged:Connect(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        local followPlatform, platformConnection = createFollowPlatform(character)
        
        tween:Play()
        tween.Completed:Wait()
        
        stateConn:Disconnect()
        sitConnection:Disconnect()
        platformConnection:Disconnect()
        followPlatform:Destroy()
        humanoid:ChangeState(originalState)

        for part, canCollide in pairs(originalCollisions) do
            if part then
                part.CanCollide = canCollide
            end
        end

        task.wait(0.1)
    end
end

getgenv().Config = {
    Invite = "NO_DISCORD_INVITE",
    Version = "0.0.1",
}
getgenv().luaguardvars = {
    DiscordName = "4levy",
}
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Other/main/1"))()
library:init() -- Initalizes Library Do Not Delete This

local Window = library.NewWindow({
    title = "Elystra.wtf | Beta | " .. getgenv().Config.Version,
    size = UDim2.new(0, 525, 0, 650)
})

local tabs = {
    AutoFarm = Window:AddTab("Auto Farm"),
    Combat = Window:AddTab("Combat"),
    Player = Window:AddTab("Player"),
    Teleport = Window:AddTab("Teleport"),
    Misc = Window:AddTab("Misc"),
    Settings = library:CreateSettingsTab(Window),
}

-- 1 = Set Section Box To The Left
-- 2 = Set Section Box To The Right
local sections = {
    AutoFarmSection = tabs.AutoFarm:AddSection("Auto Farm", 1),
    AutoFarmSettings = tabs.AutoFarm:AddSection("Settings", 2),
    
    CombatMain = tabs.Combat:AddSection("Combat", 1),
    CombatSettings = tabs.Combat:AddSection("Settings", 2),
    
    TeleportLocations = tabs.Teleport:AddSection("Locations", 1),
    TeleportSettings = tabs.Teleport:AddSection("Settings", 2),
    
    PlayerMain = tabs.Player:AddSection("Player", 1),

    MiscMain = tabs.Misc:AddSection("Misc", 1),
    MiscSettings = tabs.Misc:AddSection("Settings", 2),
}

local safePosition = Vector3.new(1816, 5890, 13751)

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(6, 1, 6)
    platform.Anchored = true
    platform.Transparency = 0.5
    platform.Position = safePosition - Vector3.new(0, 2, 0)
    platform.Parent = workspace
    
    task.spawn(function()
        while platform.Parent do
            for i = 0, 1, 0.01 do
                platform.Color = Color3.fromHSV(i, 1, 1)
                task.wait(0.1)
            end
        end
    end)
    
    return platform
end

local function initAutoEat()
    local inventory = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("InventoryEvent")
    local player = game:GetService("Players").LocalPlayer
    local threshold = 50 
    
    _G.AutoEatLoop = true
    task.spawn(function()
        while _G.AutoEatLoop do
            if player:FindFirstChild("Hunger") and player:FindFirstChild("Thristy") then
                local hunger = player.Hunger.Value
                local thirst = player.Thristy.Value
                
                if hunger < threshold then
                    inventory:FireServer("Use", "Hamburger")
                    task.wait(0.1)
                    inventory:FireServer("Use", "Hot Dog")
                    task.wait(0.2)
                end
                
                if thirst < threshold then
                    inventory:FireServer("Use", "Water")
                    task.wait(0.1)
                    inventory:FireServer("Use", "Cola")
                    task.wait(0.2)
                end
            end
            task.wait(1)
        end
    end)
end

initAutoEat()

sections.AutoFarmSection:AddToggle({
    enabled = true,
    text = "Auto Farm cement",
    flag = "AutoFarm_Enable",
    tooltip = "Automatically steals cement",
    risky = true,
    callback = function(value)
        if value then
            _G.AutoFarm = true
            local platform = createPlatform()
            local wantedFrame = game:GetService("Players").LocalPlayer.PlayerGui.Menu.WANTED_Frame
            
            task.spawn(function()
                while _G.AutoFarm do
                    if wantedFrame.Visible then
                        teleport(safePosition)
                        task.wait(1)
                        continue
                    end
                    
                    local cementsFolder = workspace.Grey_Jobs.CementsFolder
                    if cementsFolder then
                        for _, cementBase in ipairs(cementsFolder:GetChildren()) do
                            if not _G.AutoFarm or wantedFrame.Visible then break end
                            
                            if cementBase and cementBase:FindFirstChild("Base") then
                                local prompt = cementBase.Base.Attachment.ProximityPrompt
                                if prompt then
                                    teleport(cementBase.Base.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.3)
                                    
                                    prompt.MaxActivationDistance = math.huge
                                    prompt.HoldDuration = 0
                                    fireproximityprompt(prompt)
                                    
                                    teleport(safePosition)
                                    task.wait(0.1)
                                end
                            end
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.1)
                end
                
                if platform then platform:Destroy() end
            end)
        else
            _G.AutoFarm = false
        end
    end
})

sections.AutoFarmSection:AddToggle({
    enabled = true,
    text = "Auto Farm Wires",
    flag = "AutoFarm_Wires",
    tooltip = "Automatically steals wires",
    risky = true,
    callback = function(value)
        if value then
            _G.AutoFarm = true
            local platform = createPlatform()
            local wantedFrame = game:GetService("Players").LocalPlayer.PlayerGui.Menu.WANTED_Frame
            
            task.spawn(function()
                while _G.AutoFarm do
                    if wantedFrame.Visible then
                        teleport(safePosition)
                        task.wait(1)
                        continue
                    end
                    
                    local wiresFolder = workspace.Grey_Jobs.Wires
                    if wiresFolder then
                        for _, wireBase in ipairs(wiresFolder:GetChildren()) do
                            if not _G.AutoFarm or wantedFrame.Visible then break end
                            
                            if wireBase and wireBase:FindFirstChild("Attachment") then
                                local prompt = wireBase.Attachment.ProximityPrompt
                                if prompt then
                                    teleport(wireBase.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.3)
                                    
                                    prompt.MaxActivationDistance = math.huge
                                    prompt.HoldDuration = 0
                                    fireproximityprompt(prompt)
                                    
                                    teleport(safePosition)
                                    task.wait(0.1)
                                end
                            end
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.1)
                end
                
                if platform then platform:Destroy() end
            end)
        else
            _G.AutoFarm = false
        end
    end
})

sections.AutoFarmSection:AddToggle({
    enabled = true,
    text = "Auto Farm Mail Delivery ( Soon )",
    flag = "AutoFarm_Mail",
    tooltip = "Automatically delivers mail",
    risky = true,
    callback = function(value)
        if value then
            library:SendNotification("UnderDeveloped", 5, Color3.new(1, 0, 0)) 
        end
    end
})

sections.AutoFarmSection:AddToggle({
    enabled = true,
    text = "Auto Farm Tree ( Soon )",
    flag = "AutoFarm_Tree",
    tooltip = "Automatically farms trees",
    risky = true,
    callback = function(value)
        if value then
            library:SendNotification("UnderDeveloped", 5, Color3.new(1, 0, 0)) 
        end
    end
})

sections.AutoFarmSection:AddToggle({
    enabled = true,
    text = "Auto Arrest Criminals ( Soon )",
    flag = "AutoFarm_Criminals",
    tooltip = "Automatically arrests criminals",
    risky = true,
    callback = function(value)
        if value then
            library:SendNotification("UnderDeveloped", 5, Color3.new(1, 0, 0)) 
        end
    end
})




-- Combat Tab Elements

sections.CombatMain:AddButton({
    text = "Teleport to player",
    flag = "Combat_TeleportPlayer",
    tooltip = "Teleport to a player",
    risky = false,
    callback = function(value)
        library:SendNotification("UnderDeveloped", 5, Color3.new(1, 0, 0))
    end
})

-- Player Tab Elements
sections.PlayerMain:AddToggle({
    enabled = true,
    text = "Infinite Jump",
    flag = "Player_InfiniteJump",
    tooltip = "Enable infinite jump and bypass stamina",
    risky = false,
    callback = function(value)
        local player = game.Players.LocalPlayer
        local userInputService = game:GetService("UserInputService")
        
        local connection
        if value then
            connection = userInputService.JumpRequest:Connect(function()
                if player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        for _, v in pairs(player:GetChildren()) do
                            if v:IsA("NumberValue") and (v.Name:lower():match("stamina") or v.Name:lower():match("energy")) then
                                v.Value = 100 
                            end
                        end
                    end
                end
            end)
        else
            if connection then
                connection:Disconnect()
            end
        end
    end
})

sections.PlayerMain:AddToggle({
    enabled = true,
    text = "No Clip",
    flag = "Player_NoClip",
    tooltip = "Enable no clipping through walls",
    risky = false,
    callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not value
            end
        end
        
        character.ChildAdded:Connect(function(child)
            if child:IsA("BasePart") then
                child.CanCollide = not value
            end
        end)
    end
})

sections.PlayerMain:AddSlider({
    text = "Walk Speed", 
    flag = 'Player_WalkSpeed', 
    suffix = "Studs/s", 
    value = 16,
    min = 0, 
    max = 1000,
    increment = 1,
    tooltip = "Adjust walk speed",
    risky = false,
    callback = function(value) 
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
        print("Walk Speed is now: " .. value)
    end
})

sections.PlayerMain:AddSlider({
    text = "Auto Eat", 
    flag = 'Player_AutoEat',
    suffix = "%",
    value = 50,
    min = 1, 
    max = 100,
    increment = 1,
    tooltip = "Auto eat/drink when health/hunger below threshold",
    risky = false,
    callback = function(threshold)
        _G.AutoEatThreshold = threshold
    end
})

sections.PlayerMain:AddToggle({
    enabled = true,
    text = "Auto Buy Food",
    flag = "Player_AutoBuyFood",
    tooltip = "Automatically teleport to and buy food items",
    risky = false,
    callback = function(value)
        if value then
            if _G.AutoBuyFood then return end 
            _G.AutoBuyFood = true
            task.spawn(function()
                while _G.AutoBuyFood and task.wait(0.1) do
                    pcall(function()
                        local foodItems = {
                            ["Hot Dog"] = true,
                            ["Hamburger"] = true,
                            ["Grill Squid"] = true,
                            ["Donut"] = true,
                            ["Icecream"] = true,
                            ["Shrimp Stick"] = true
                        }
                        
                        for _, item in pairs(workspace.BuyItem:GetChildren()) do
                            if not _G.AutoBuyFood then break end
                            if foodItems[item.Name] then
                                local prompt = item:FindFirstChild("ProximityPrompt")
                                if prompt then
                                    teleport(item.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.2)
                                    
                                    for i = 1, 3 do -- Try 3 times
                                        prompt.MaxActivationDistance = math.huge
                                        prompt.HoldDuration = 0
                                        fireproximityprompt(prompt)
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                        task.wait(1)
                    end)
                end
            end)
        else
            _G.AutoBuyFood = false
        end
    end
})

sections.PlayerMain:AddToggle({
    enabled = true,
    text = "Auto Buy Drink",
    flag = "Player_AutoBuyDrink",
    tooltip = "Automatically teleport to and buy drink items",
    risky = false,
    callback = function(value)
        if value then
            if _G.AutoBuyDrink then return end 
            _G.AutoBuyDrink = true
            task.spawn(function()
                while _G.AutoBuyDrink and task.wait(0.1) do
                    pcall(function()
                        local drinks = {
                            ["Water"] = true,
                            ["Cola"] = true,
                            ["Coffee"] = true,
                            ["Smoothie"] = true
                        }
                        
                        for _, item in pairs(workspace.BuyItem:GetChildren()) do
                            if not _G.AutoBuyDrink then break end
                            if drinks[item.Name] then
                                local prompt = item:FindFirstChild("ProximityPrompt")
                                if prompt then
                                    teleport(item.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.2)
                                    
                                    for i = 1, 3 do -- Try 3 times
                                        prompt.MaxActivationDistance = math.huge
                                        prompt.HoldDuration = 0
                                        fireproximityprompt(prompt)
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                        task.wait(1)
                    end)
                end
            end)
        else
            _G.AutoBuyDrink = false
        end
    end
})

sections.PlayerMain:AddButton({
    enabled = true,
    text = "Reset Player",
    flag = "Player_Reset",
    tooltip = "Reset your character",
    risky = false,
    callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
        end
    end
})

-- Teleport Tab Elements
sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Spawn",
    flag = "Teleport_Spawn",
    tooltip = "Teleport to spawn",
    risky = false,
    callback = function(value)
        teleport(teleport_table.spawn)
    end
})

sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Gun Store",
    flag = "Teleport_GunStore",
    tooltip = "Teleport to gun store",
    risky = false,
    callback = function(value)
        teleport(teleport_table.gunStore)
    end
})

sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Car Store",
    flag = "Teleport_CarStore",
    tooltip = "Teleport to car store",
    risky = false,
    callback = function(value)
        teleport(teleport_table.carstore)
    end
})

sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Hospital",
    flag = "Teleport_Hospital",
    tooltip = "Teleport to hospital",
    risky = false,
    callback = function(value)
        teleport(teleport_table.hospital)
    end
})


sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Police Station",
    flag = "Teleport_PoliceStation",
    tooltip = "Teleport to police station",
    risky = false,
    callback = function(value)
        teleport(teleport_table.policestation)
    end
})

sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Military Base",
    flag = "Teleport_MilitaryBase",
    tooltip = "Teleport to military base",
    risky = false,
    callback = function(value)
        teleport(teleport_table.MilitaryBase)
    end
})

sections.TeleportLocations:AddButton({
    enabled = true,
    text = "D.I.Y Store",
    flag = "Teleport_DIYStore",
    tooltip = "Teleport to D.I.Y store",
    risky = false,
    callback = function(value)
        teleport(teleport_table.diyStore)
    end
})



sections.TeleportLocations:AddSeparator({
    text = "Special Locations"
})

sections.TeleportLocations:AddButton({
    enabled = true,
    text = "Secret Area",
    flag = "Teleport_Secret",
    tooltip = "Teleport to secret area",
    risky = true,
    confirm = true,
    callback = function(value)
        print("Teleporting to Secret Area")
    end
})

-- Misc Tab Elements
sections.MiscMain:AddButton({
    enabled = true,
    text = "Click Teleport Tool",
    flag = "Teleport_Tool",
    tooltip = "Give yourself a teleport tool",
    callback = function(value)
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
    end
})

sections.MiscMain:AddButton({
    enabled = true,
    text = "Ragdoll",
    flag = "Misc_Ragdoll",
    tooltip = "Enable ragdoll effect",
    callback = function()
        local args = {
            "Ragdoll"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("OnDeathEvent"):FireServer(unpack(args))
    end
})

sections.MiscMain:AddButton({
    enabled = true,
    text = "unRagdoll",
    flag = "Misc_unRagdoll",
    tooltip = "Enable unragdoll effect",
    callback = function()
        local args = {
            "Unragdoll"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("OnDeathEvent"):FireServer(unpack(args))
        
    end
})

local AntiRagdollEnabled = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OnDeathEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("OnDeathEvent")

local function setupAntiRagdoll()
    local function unragdollOnRagdoll(char)
        if not AntiRagdollEnabled then return end
        char.DescendantAdded:Connect(function(desc)
            if desc:IsA("Motor6D") and desc.Name == "RagdollConstraint" then
                task.wait(0.1)
                OnDeathEvent:FireServer("Unragdoll")
            end
        end)
    end

    local player = game:GetService("Players").LocalPlayer
    player.CharacterAdded:Connect(unragdollOnRagdoll)

    if player.Character then
        unragdollOnRagdoll(player.Character)
    end
end

setupAntiRagdoll()

sections.MiscMain:AddToggle({
    text = "Anti-Ragdoll",
    flag = "Misc_AntiRagdoll",
    tooltip = "Automatically remove ragdoll effect",
    state = true,
    callback = function(state)
        AntiRagdollEnabled = state
    end
})

sections.MiscMain:AddColor({
    enabled = true,
    text = "UI Accent Color",
    flag = "Misc_AccentColor",
    tooltip = "Change UI accent color",
    color = Color3.new(255, 0, 0),
    trans = 0,
    open = false,
    callback = function(color)
        print("Color changed")
    end
})

library:SendNotification("Elystra.wtf Loaded Successfully", 5, Color3.new(255, 0, 0))
--Window:SetOpen(true) -- Either Close Or Open Window
