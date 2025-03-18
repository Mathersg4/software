shared.premiumUserIds = shared.premiumUserIds or {}
local csvData = game:HttpGet("https://raw.githubusercontent.com/vertex-peak/API/refs/heads/main/API.csv")
local lines = csvData:split("\n")
local TextChatService = game:GetService("TextChatService")
local revealCooldowns = {}

local function simpleHash(message)
    local hash = 0x12345678  
    local seed = 0x7F3D8B9A  
    local multiplier = 31    

    for i = 1, #message do
        local byte = string.byte(message, i)  
        hash = (hash * multiplier + byte + seed) % 0x100000000  
        hash = bit32.lshift(hash, 5) + bit32.rshift(hash, 27)
        hash = hash % 0x100000000 
    end

    return string.format("%08x", hash)
end

for _, line in ipairs(lines) do
    local parts = line:split(",")
    if #parts == 2 and parts[1] ~= "" then
        local robloxUserId = parts[1]
        if robloxUserId then
            table.insert(shared.premiumUserIds, robloxUserId)
        end
    end
end
-- Bored made the premium stuff messy :) 
local function checkIfPremiumUser(player)
    local hashedUserId = simpleHash(tostring(player.UserId)) 
    local Roach = game:GetService("CoreGui"):FindFirstChild("PlayerList")
    for _, premiumId in ipairs(shared.premiumUserIds) do
        if Roach and hashedUserId == premiumId then
            local targetFrame = game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
           repeat task.wait() until targetFrame:FindFirstChild("p_" .. player.UserId)
           local expectedName = "p_" .. player.UserId

            for _, child in ipairs(targetFrame:GetChildren()) do
                if child.Name == expectedName then
                    targetFrame[expectedName].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = "rbxassetid://112567270442515"
                    targetFrame[expectedName].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.TextColor3 = Color3.fromRGB(255, 255, 0)
                    break  
                end
            end
        end
        if hashedUserId == premiumId then
            return true
        end
    end
    return false
end

local function isPremiumUser(player)
    return table.find(shared.premiumUserIds, simpleHash(tostring(player.UserId))) ~= nil
end

if isPremiumUser(Players.LocalPlayer) then 
    shared.premium = true 
else 
    shared.premium = false
end 

if not shared.executed then 
    local function checkPlayerInLeaderboard(player)
        local function waitForGUI()
            if not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainGUI") then return end 
            local leaderboardContainer = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Leaderboard.Container
            for _, child in ipairs(leaderboardContainer:GetChildren()) do
                if child:IsA("Frame") and string.find(child.Name, player.Name) then
                    child.PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    local originalText = child.PlayerLabel.Text
                    if not originalText:match("^%[⭐%]") then
                        child.PlayerLabel.Text = "[⭐] " .. originalText
                    end
                    return true
                end
            end
            return false
        end
    
        waitForGUI() 
    end
    
    local function checkPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if isPremiumUser(player) then
                checkPlayerInLeaderboard(player)
            end
        end
    end
    
    checkPlayers()
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            checkPlayers()
        end)
    end)
    
    Players.LocalPlayer.CharacterAdded:Connect(function(character)
        checkPlayerInLeaderboard(checkPlayers())
    end)
    
    for _, player in ipairs(Players:GetPlayers()) do
        spawn(function()
            if player.Character then
                checkIfPremiumUser(player) 
            end
        end)
    end
    Players.PlayerAdded:Connect(function(player)
        local character = player.CharacterAdded:Wait()
        repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
        checkIfPremiumUser(player) 
    end)
end
