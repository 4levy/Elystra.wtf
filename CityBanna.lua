SectionA:addToggle({
    title = "Auto ClaimGift",
    default = true, 
    callback = function(value)
        _G.autoClaimGift = value
        
        if value then
            for i = 1, 9 do
                local args = {i}
                game:GetService("ReplicatedStorage"):WaitForChild("GiftFolder"):WaitForChild("ClaimGift"):InvokeServer(unpack(args))
            end
            
            if not _G.claimGiftLoop then
                _G.claimGiftLoop = task.spawn(function()
                    while _G.autoClaimGift do
                        for i = 1, 9 do
                            local args = {i}
                            game:GetService("ReplicatedStorage"):WaitForChild("GiftFolder"):WaitForChild("ClaimGift"):InvokeServer(unpack(args))
                        end
                        task.wait(20) 
                    end
                end)
            end
        else
            if _G.claimGiftLoop then
                task.cancel(_G.claimGiftLoop)
                _G.claimGiftLoop = nil
            end
        end
    end
})
