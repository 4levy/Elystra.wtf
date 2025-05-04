local placeId = game.PlaceId

local scripts = {
    [6925849909] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/CityBanna.lua"))()
    end,
}

local defaultScript = function()
    print("Executing Default Script for an unrecognized Place ID")
end

if scripts[placeId] then
    scripts[placeId]()
else
    defaultScript()
end
