local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Ссылка на CSV-файл с премиум-пользователями (ваша ссылка)
local premiumUsersURL = "https://raw.githubusercontent.com/Mathersg4/software/refs/heads/main/premium.csv"

-- Функция для загрузки данных по URL
local function fetchData(url)
    local success, response = pcall(game.HttpGet, game, url)
    if not success then
        warn("Failed to fetch data from: " .. url)
        return nil
    end
    return response
end

-- Загрузка списка премиум-пользователей из CSV
local function loadPremiumUsers()
    local csvData = fetchData(premiumUsersURL)
    if csvData then
        local lines = csvData:split("\n")
        for _, line in ipairs(lines) do
            local parts = line:split(",")
            if #parts >= 1 and parts[1] ~= "" then
                local userId = parts[1]
                table.insert(shared.premiumUserIds, userId)
            end
        end
        print("Loaded premium users:", #shared.premiumUserIds)
    else
        warn("Failed to load premium users data.")
    end
end

-- Функция для хеширования UserId
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

-- Функция для проверки премиум-статуса
local function isPremiumUser(player)
    local hashedUserId = simpleHash(tostring(player.UserId))
    return table.find(shared.premiumUserIds, hashedUserId) ~= nil
end

-- Функция для изменения интерфейса премиум-пользователей
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

-- Основная логика
loadPremiumUsers() -- Загружаем список премиум-пользователей

-- Возвращаем функции, если они нужны в основном скрипте
return {
    isPremiumUser = isPremiumUser,
    checkIfPremiumUser = checkIfPremiumUser,
    loadPremiumUsers = loadPremiumUsers,
}
