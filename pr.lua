local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Easter Update 2025 MM2TradeScamGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true -- Make GUI movable

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "MM2 TRADE SCAM By valiuss_"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0.8
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.TextWrapped = true
title.Parent = frame

local function createButton(text, color, yPos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = color
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 16
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button

    return button
end

local function sendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 4;
    })
end

local tradeFreeze = createButton("❄️ Trade Freeze", Color3.fromRGB(66, 135, 245), 60)
tradeFreeze.MouseButton1Click:Connect(function()
    sendNotification("❄️ Trade Freeze", "Trade Freeze Activated!")
end)

local bypass = createButton("⚙️ Bypass", Color3.fromRGB(250, 210, 80), 100)
bypass.MouseButton1Click:Connect(function()
    sendNotification("⚙️ Bypass", "Bypass Mode Enabled!")
end)

local toggle = createButton("⛔ Toggle: OFF", Color3.fromRGB(200, 50, 50), 140)
local isToggled = false
toggle.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    toggle.Text = isToggled and "✅ Toggle: ON" or "⛔ Toggle: OFF"
    sendNotification("Toggle", isToggled and "✅ Feature Enabled!" or "⛔ Feature Disabled!")
end)

local version = Instance.new("TextLabel")
version.Size = UDim2.new(1, 0, 0, 20)
version.Position = UDim2.new(0, 0, 1, -20)
version.BackgroundTransparency = 1
version.Text = "Version: v3"
version.TextColor3 = Color3.fromRGB(200, 200, 200)
version.TextSize = 12
version.Font = Enum.Font.SourceSans
version.Parent = frame
