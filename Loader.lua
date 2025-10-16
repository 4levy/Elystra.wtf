local PlaceScripts = {
    [155615604] = "https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/PL.lua",
    [77837537595343] = "https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/BannaTown.lua",
    [114116662845070] = "https://raw.githubusercontent.com/4levy/Elystra.wtf/refs/heads/main/CityBanna.lua"
}

local currentPlaceId = game.PlaceId

if PlaceScripts[currentPlaceId] then
    local scriptUrl = PlaceScripts[currentPlaceId]
    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)

    if success then
        print("Script executed successfully for PlaceId:", currentPlaceId)
    else
        warn("Failed to execute script for PlaceId:", currentPlaceId, err)
    end
else
    print("No script configured for this PlaceId:", currentPlaceId)
end
