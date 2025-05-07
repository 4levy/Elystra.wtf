local tween_s = game:GetService("TweenService")
local TweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local lp = game.Players.LocalPlayer

local teleport_table = {
    spawn = Vector3.new(339, 7, 185)
}

local function teleport(v)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        warn("Character or HumanoidRootPart not found!")
        return
    end

    local humanoid = lp.Character:FindFirstChild("Humanoid")
    local root = lp.Character.HumanoidRootPart

    if humanoid then
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
        end)
        
        tween:Play()
        tween.Completed:Wait()
        
        stateConn:Disconnect()
        humanoid:ChangeState(originalState)
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

local safePosition = Vector3.new(802, -118, -8)

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
    tooltip = "Automatically steals and sells cement",
    risky = true,
    callback = function(value)
        if value then
            _G.AutoFarm = true
            local platform = createPlatform()
            local wantedFrame = game:GetService("Players").LocalPlayer.PlayerGui.Menu.WANTED_Frame
            
            wantedFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                if not wantedFrame.Visible and _G.AutoFarm then
                    task.spawn(function()
                        teleport(safePosition)
                        task.wait(1)
                        _G.AutoFarm = true
                    end)
                end
            end)
            
            task.spawn(function()
                while _G.AutoFarm do
                    if not wantedFrame.Visible then
                        local cementsFolder = workspace.Grey_Jobs.CementsFolder
                        if cementsFolder then
                            local cementBase = cementsFolder:GetChildren()[3]
                            if not cementBase or not cementBase:FindFirstChild("Base") then
                                cementBase = cementsFolder:FindFirstChild("Cement")
                            end
                            
                            if cementBase and cementBase:FindFirstChild("Base") then
                                local prompt = cementBase.Base.Attachment.ProximityPrompt
                                if prompt then
                                    teleport(cementBase.Base.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.3)
                                    
                                    prompt.MaxActivationDistance = math.huge
                                    prompt.HoldDuration = 0
                                    fireproximityprompt(prompt)
                                    
                                    teleport(safePosition)
                                    
                                    local startTime = tick()
                                    while tick() - startTime < 300 and _G.AutoFarm do
                                        local backpack = lp.Backpack
                                        for _, item in pairs(backpack:GetChildren()) do
                                            if item.Name == "Cement bag" then
                                                local args = {"Cement bag", 1}
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SellEvent"):FireServer(unpack(args))
                                                task.wait(0.1)
                                            end
                                        end
                                        
                                        if wantedFrame.Visible then break end
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    else
                        local startTime = tick()
                        while tick() - startTime < 300 and _G.AutoFarm do
                            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                local currentPos = lp.Character.HumanoidRootPart.Position
                                if (currentPos - safePosition).Magnitude > 5 then
                                    teleport(safePosition)
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
    tooltip = "Automatically steals and sells wires",
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
                                    
                                    local backpack = lp.Backpack
                                    for _, item in pairs(backpack:GetChildren()) do
                                        if item.Name == "Wire" then
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SellEvent"):FireServer("Wire", 1)
                                            task.wait(0.1)
                                        end
                                    end
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
                while _G.AutoBuyFood do
                    local foodItems = {"Hot Dog", "Hamburger", "Grill Squid", "Donut", "Icecream", "Shrimp Stick"}
                    
                    for _, item in pairs(workspace.BuyItem:GetChildren()) do
                        if table.find(foodItems, item.Name) and _G.AutoBuyFood then
                            teleport(item.Position)
                            task.wait(0.2)
                            
                            local prompt = item:FindFirstChild("ProximityPrompt")
                            if prompt then
                                prompt.MaxActivationDistance = math.huge
                                fireproximityprompt(prompt)
                                task.wait(0.5)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            _G.AutoBuyFood = false
            for _, tween in pairs(tween_s:GetChildren()) do
                tween:Cancel()
            end
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
                while _G.AutoBuyDrink do
                    local drinks = {"Water", "Cola", "Coffee", "Smoothie"}
                    
                    for _, item in pairs(workspace.BuyItem:GetChildren()) do
                        if table.find(drinks, item.Name) and _G.AutoBuyDrink then
                            teleport(item.Position)
                            task.wait(0.2)
                            
                            local prompt = item:FindFirstChild("ProximityPrompt")
                            if prompt then
                                prompt.MaxActivationDistance = math.huge
                                fireproximityprompt(prompt)
                                task.wait(0.5)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            _G.AutoBuyDrink = false
            for _, tween in pairs(tween_s:GetChildren()) do
                tween:Cancel()
            end
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
    confirm = true,
    callback = function(value)
        teleport(teleport_table.spawn)
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

sections.MiscMain:AddBind({
    text = "Panic Button",
    flag = "Misc_Panic",
    nomouse = true,
    noindicator = false,
    tooltip = "Press to disable all features",
    mode = "toggle",
    bind = Enum.KeyCode.P,
    risky = false,
    keycallback = function(value)
        print("Panic button pressed!")
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
