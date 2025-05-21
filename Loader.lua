local CONFIG = {
    VERSION = "0.0.3a",
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
local GameScripts = {
    [114116662845070] = {
        name = "City Banna",
        script = "CityBanna.lua"
    },
    [77837537595343] = {
        name = "Banna Town",
        script = "BannaTown.lua"
    },
    [115842829430610] = {
        name = "Thai Donate",
        script = "ThaiDonate.lua"
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
                player:Kick("\n⭐ Elystra.wtf ⭐\n\nThis game is not currently supported!.")
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
