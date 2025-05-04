local placeId = game.PlaceId

local scripts = {
    [6925849909] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/CityBanna.lua"))()
    end,
}

local defaultScript = function()
    local player = game.Players.LocalPlayer
    if player then
        pcall(function()
            player:Kick("\nElystra.wtf\n\nThis game is not supported!")
        end)
    end
    task.wait(1)
    game:Shutdown()
end

if scripts[placeId] then
    scripts[placeId]()
else
    defaultScript()
end

-- // loadstring(game:HttpGet("https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/Loader.lua"))()
