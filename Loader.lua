local CONFIG = {
    VERSION = "0.0.5",
    REPO_OWNER = "4levy",
    REPO_NAME = "Elystra.wtf",
    BRANCH = "main",
    CHECK_FOR_UPDATES = true,
    SHOW_NOTIFICATIONS = true,
    DEBUG_MODE = false
}

local Utils = {}
Utils.getRawURL = function(path)
    return string.format(
        "https://raw.githubusercontent.com/%s/%s/refs/heads/%s/%s",
        CONFIG.REPO_OWNER,
        CONFIG.REPO_NAME,
        CONFIG.BRANCH,
        path
    )
end

Utils.log = function(message, level)
    level = level or "INFO"
    if CONFIG.DEBUG_MODE or level == "ERROR" then
        print(string.format("[Elystra.wtf][%s] %s", level, message))
    end
end

Utils.safeHttpGet = function(url)
    local success, result =
        pcall(
        function()
            return game:HttpGet(url)
        end
    )
    if success then
        return success, result
    else
        Utils.log("Failed to fetch " .. url, "ERROR")
        return false, "HTTP request failed"
    end
end

local Notification = {}
Notification.show = function(title, message, duration)
    if not CONFIG.SHOW_NOTIFICATIONS then
        return
    end
    duration = duration or 5
    title = title or "Elystra.wtf"
    pcall(
        function()
            (game:GetService("StarterGui")):SetCore(
                "SendNotification",
                {
                    Title = title,
                    Text = message,
                    Duration = duration,
                    Icon = "rbxassetid://122798567304852"
                }
            )
        end
    )
end

local VersionControl = {}
VersionControl.check = function()
    if not CONFIG.CHECK_FOR_UPDATES then
        return true
    end
    Utils.log("Checking for updates...", "INFO")
    local success, versionData = Utils.safeHttpGet(Utils.getRawURL("version.txt"))
    if not success then
        Utils.log("Failed to check for updates", "WARN")
        return true
    end
    local latestVersion = versionData:match("(%d+%.%d+%.%d+)")
    if not latestVersion then
        Utils.log("Invalid version format received", "WARN")
        return true
    end
    Utils.log("Current version: " .. CONFIG.VERSION, "INFO")
    Utils.log("Latest version: " .. latestVersion, "INFO")
    if latestVersion ~= CONFIG.VERSION then
        Notification.show("Update Available", "A new version is available: " .. latestVersion, 8)
    end
    return true
end

local CityBannaUI = {}

CityBannaUI.createSelectionUI = function()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ElystraSelectionUI"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.Parent = playerGui
    

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⭐ Elystra.wtf - City Banna ⭐"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -40, 0, 30)
    subtitle.Position = UDim2.new(0, 20, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Select which script to load:"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame

    local mainButton = Instance.new("TextButton")
    mainButton.Name = "MainButton"
    mainButton.Size = UDim2.new(0, 160, 0, 50)
    mainButton.Position = UDim2.new(0, 30, 0, 100)
    mainButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "Main Script"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Parent = mainFrame
    
    local mainButtonCorner = Instance.new("UICorner")
    mainButtonCorner.CornerRadius = UDim.new(0, 8)
    mainButtonCorner.Parent = mainButton
    
    local eventButton = Instance.new("TextButton")
    eventButton.Name = "EventButton"
    eventButton.Size = UDim2.new(0, 160, 0, 50)
    eventButton.Position = UDim2.new(0, 210, 0, 100)
    eventButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    eventButton.BorderSizePixel = 0
    eventButton.Text = "Event Script"
    eventButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    eventButton.TextScaled = true
    eventButton.Font = Enum.Font.GothamBold
    eventButton.Parent = mainFrame
    
    local eventButtonCorner = Instance.new("UICorner")
    eventButtonCorner.CornerRadius = UDim.new(0, 8)
    eventButtonCorner.Parent = eventButton
    

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 100, 0, 35)
    closeButton.Position = UDim2.new(0.5, -50, 0, 180)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "Cancel"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.Gotham
    closeButton.Parent = mainFrame
    
    local closeButtonCorner = Instance.new("UICorner")
    closeButtonCorner.CornerRadius = UDim.new(0, 6)
    closeButtonCorner.Parent = closeButton
    
    local function addHoverEffect(button, originalColor, hoverColor)
        button.MouseEnter:Connect(function()
            local tween = game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = hoverColor}
            )
            tween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local tween = game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = originalColor}
            )
            tween:Play()
        end)
    end
    
    addHoverEffect(mainButton, Color3.fromRGB(0, 162, 255), Color3.fromRGB(0, 142, 235))
    addHoverEffect(eventButton, Color3.fromRGB(255, 165, 0), Color3.fromRGB(235, 145, 0))
    addHoverEffect(closeButton, Color3.fromRGB(255, 75, 75), Color3.fromRGB(235, 55, 55))
    
    return screenGui, mainButton, eventButton, closeButton
end

CityBannaUI.loadSelectedScript = function(scriptType)
    local scriptName = scriptType == "main" and "CityBanna.lua" or "CityBannaEvent.lua"
    local scriptDisplayName = scriptType == "main" and "Main Script" or "Event Script"
    
    Notification.show("Elystra.wtf", "Loading " .. scriptDisplayName .. "...", 3)
    Utils.log("Loading " .. scriptDisplayName .. " for City Banna", "INFO")
    
    local success, scriptContent = Utils.safeHttpGet(Utils.getRawURL(scriptName))
    if success then
        Utils.log("Script loaded successfully", "INFO")
        local loadSuccess, loadError =
            pcall(
            function()
                (loadstring(scriptContent))()
            end
        )
        if loadSuccess then
            Notification.show("Elystra.wtf", scriptDisplayName .. " loaded successfully!", 5)
        else
            Utils.log("Error executing script: " .. tostring(loadError), "ERROR")
            Notification.show("Error", "Failed to execute script. Check console for details.", 8)
        end
    else
        Utils.log("Failed to load script content", "ERROR")
        Notification.show("Error", "Failed to download script. Try again later.", 5)
    end
end

local GameScripts = {
    [114116662845070] = {
        name = "City Banna",
        script = "CityBanna.lua",
        status = true,
        hasUI = true  -- New flag to indicate this game has a selection UI
    },
    [77837537595343] = {
        name = "Banna Town",
        script = "BannaTown.lua",
        status = true 
    },
    [115842829430610] = {
        name = "Thai Donate",
        script = "ThaiDonate.lua",
        status = false  
    }
}

local function loadScript()
    local placeId = game.PlaceId
    local player = game.Players.LocalPlayer
    if not player then
        player = game.Players.LocalPlayerAdded:Wait()
    end
    
    Utils.log("Running loader for place ID: " .. placeId, "INFO")
    VersionControl.check()
    
    local gameInfo = GameScripts[placeId]
    if gameInfo then
        if not gameInfo.status then
            Utils.log("Script for " .. gameInfo.name .. " is currently disabled", "INFO")
            Notification.show("Elystra.wtf", gameInfo.name .. " is currently under maintenance", 5)
            wait(3)
            pcall(
                function()
                    player:Kick("\n⭐ Elystra.wtf ⭐\n\n" .. gameInfo.name .. " is currently disabled for maintenance!")
                end
            )
            return
        end
        
        if gameInfo.hasUI and placeId == 114116662845070 then
            Notification.show("Elystra.wtf", "Welcome to " .. gameInfo.name .. "!", 3)
            
            local screenGui, mainButton, eventButton, closeButton = CityBannaUI.createSelectionUI()
            
            mainButton.MouseButton1Click:Connect(function()
                screenGui:Destroy()
                CityBannaUI.loadSelectedScript("main")
            end)
            
            eventButton.MouseButton1Click:Connect(function()
                screenGui:Destroy()
                CityBannaUI.loadSelectedScript("event")
            end)
            
            closeButton.MouseButton1Click:Connect(function()
                screenGui:Destroy()
                Notification.show("Elystra.wtf", "Script loading cancelled", 3)
            end)
            
            game:GetService("Debris"):AddItem(screenGui, 30)
            
        else
            Notification.show("Elystra.wtf", "Loading script for " .. gameInfo.name .. "...", 3)
            Utils.log("Loading script for: " .. gameInfo.name, "INFO")
            local success, scriptContent = Utils.safeHttpGet(Utils.getRawURL(gameInfo.script))
            if success then
                Utils.log("Script loaded successfully", "INFO")
                local loadSuccess, loadError =
                    pcall(
                    function()
                        (loadstring(scriptContent))()
                    end
                )
                if loadSuccess then
                    Notification.show("Elystra.wtf", "Loaded successfully for " .. gameInfo.name, 5)
                else
                    Utils.log("Error executing script: " .. tostring(loadError), "ERROR")
                    Notification.show("Error", "Failed to execute script. Check console for details.", 8)
                end
            else
                Utils.log("Failed to load script content", "ERROR")
                Notification.show("Error", "Failed to download script. Try again later.", 5)
            end
        end
    else
        Utils.log("Game not supported: " .. placeId, "INFO")
        local gameName = "this game"
        pcall(
            function()
                gameName = ((game:GetService("MarketplaceService")):GetProductInfo(placeId)).Name
            end
        )
        Notification.show("Elystra.wtf", "Sorry, " .. gameName .. " is not supported yet!", 5)
        wait(3)
        pcall(
            function()
                player:Kick("\n⭐ Elystra.wtf ⭐\n\nThis game is not currently supported!")
            end
        )
    end
end

local success, error = pcall(loadScript)
if not success then
    Utils.log("Critical error in loader: " .. tostring(error), "ERROR")
    pcall(
        function()
            Notification.show("Critical Error", "Loader failed to run. Please report this issue.", 10)
        end
    )
end

-- // loadstring(game:HttpGet("https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/Loader.lua"))()
