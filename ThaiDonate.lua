local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function safeCall(func)
    return function(...)
        local success, err = pcall(func, ...)
        if not success then
            warn("Error in function: " .. tostring(err))
        end
    end
end

local CoinFarmer = {
    autoFarmEnabled = false,
    currentCoinIndex = 1,
    miningAttempts = 0,
    maxMiningAttempts = 5,
    
    init = function(self)
        self.player = Players.LocalPlayer
        self:updateCharacter()
        
        self.player.CharacterAdded:Connect(function()
            self:updateCharacter()
            if self.autoFarmEnabled then
                self:startFarming()
            end
        end)
    end,
    
    updateCharacter = function(self)
        self.character = self.player.Character or self.player.CharacterAdded:Wait()
        self.humanoid = self.character:WaitForChild("Humanoid")
        self.rootPart = self.character:WaitForChild("HumanoidRootPart")
        self.backpack = self.player:WaitForChild("Backpack")
    end,
    
    preventStuck = function(self)
        if self.humanoid.Sit then
            self.humanoid.Jump = true
            self.humanoid.Sit = false
        end
        
        local stuckConnection
        stuckConnection = self.humanoid.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Seated then
                self.humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
        return stuckConnection
    end,
    
    equipPickaxe = function(self)
        local pickaxe = self.backpack:FindFirstChild("Pickaxe")
        if pickaxe then
            pickaxe.Parent = self.character
        end
    end,
    
    teleportToCoin = function(self, coin)
        if not coin or not coin:FindFirstChild("MeshPart") then return false end
        
        local targetPosition = coin.MeshPart.Position + Vector3.new(0, 3, 0)
        
        local originalCollisions = {}
        for _, part in ipairs(self.character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisions[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        
        local stuckConnection = self:preventStuck()
        
        local tween = TweenService:Create(
            self.rootPart, 
            TweenInfo.new(0.5, Enum.EasingStyle.Linear), 
            {CFrame = CFrame.new(targetPosition)}
        )
        
        tween:Play()
        tween.Completed:Wait()
        
        if stuckConnection then
            stuckConnection:Disconnect()
        end

        for part, canCollide in pairs(originalCollisions) do
            if part and part.Parent then
                part.CanCollide = canCollide
            end
        end
        
        return true
    end,
    
    mineCoin = function(self, coin)
        if not coin or not coin:FindFirstChild("MeshPart") then return false end
        
        local meshPart = coin.MeshPart
        local prompt = meshPart:FindFirstChildOfClass("ProximityPrompt")
        if not prompt then return false end
        
        local coinValue = meshPart:FindFirstChild("Value")
        if coinValue and coinValue.Value <= 0 then return false end
        
        for _ = 1, self.maxMiningAttempts do
            if not self.autoFarmEnabled then break end
            
            pcall(function()
                fireproximityprompt(prompt)
            end)
            
            task.wait(0.25)
        end
        
        return true
    end,

    startFarming = function(self)
        if not self.autoFarmEnabled then return end
        
        local coins = workspace:FindFirstChild("CoinContainer")
        if not coins or #coins:GetChildren() == 0 then 
            task.wait(1)
            return self:startFarming() 
        end
        
        local coinList = coins:GetChildren()
        
        if self.currentCoinIndex > #coinList then
            self.currentCoinIndex = 1
        end
        
        local currentCoin = coinList[self.currentCoinIndex]
        if not currentCoin then 
            self.currentCoinIndex = self.currentCoinIndex + 1
            return self:startFarming() 
        end

        if self:teleportToCoin(currentCoin) then
            self:equipPickaxe()
            self:mineCoin(currentCoin)
        end
        
        self.currentCoinIndex = self.currentCoinIndex + 1
        
        task.spawn(function()
            self:startFarming()
        end)
    end,
    
    toggleAutoFarm = function(self, enabled)
        self.autoFarmEnabled = enabled
        self.currentCoinIndex = 1
        
        if enabled then
            self:startFarming()
        end
    end
}

local Window = Fluent:CreateWindow({
    Title = "Elystra.wtf",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "coins" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- UI Elements
do
    local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarm", {
        Title = "Auto Farm Coins",
        Default = false,
        Callback = function(value)
            CoinFarmer:toggleAutoFarm(value)
        end
    })

    local MiningAttemptsInput = Tabs.Main:AddInput("MiningAttempts", {
        Title = "Max Mining Attempts",
        Default = tostring(CoinFarmer.maxMiningAttempts),
        Placeholder = "5",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            CoinFarmer.maxMiningAttempts = tonumber(Value) or 4
        end
    })

    local StatusLabel = Tabs.Main:AddParagraph({
        Title = "Farm Status",
        Content = "Idle"
    })

    spawn(function()
        while true do
            if CoinFarmer.autoFarmEnabled then
                StatusLabel:SetContent(string.format(
                    "Farming - Current Coin Index: %d", 
                    CoinFarmer.currentCoinIndex
                ))
            else
                StatusLabel:SetContent("Idle")
            end
            task.wait(1)
        end
    end)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("CoinFarmerScript")
SaveManager:SetFolder("CoinFarmerScript/game-specific")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
CoinFarmer:init()

Fluent:Notify({
    Title = "Elystra.wtf",
    Content = "Loaded!",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()