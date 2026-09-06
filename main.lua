-- [[ НАВИГАТОР LITE — ТОЧКИ С КОПИРОВАНИЕМ ]]
-- Подошёл → нажал "+" → точка сохранена
-- Нажал "📋 КОПИРОВАТЬ" → координаты в буфер

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ClipboardService = game:GetService("ClipboardService")

-- ===== ДАННЫЕ =====
local Points = {}
local Speed = 50
local IsLoop = false
local LoopDelay = 1
local IsFlying = false
local CurrentIndex = 1
local BodyVelocity = nil
local BodyGyro = nil
local FlyConnection = nil
local Minimized = false

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NavigatorLite"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 460)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = MainFrame

-- ===== ШАПКА =====
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.5, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.Text = "🧭 НАВИГАТОР"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local PointsCount = Instance.new("TextLabel")
PointsCount.Size = UDim2.new(0.15, 0, 1, 0)
PointsCount.Position = UDim2.new(0.8, 0, 0, 0)
PointsCount.Text = "0"
PointsCount.TextColor3 = Color3.fromRGB(100, 200, 255)
PointsCount.TextSize = 26
PointsCount.TextXAlignment = Enum.TextXAlignment.Right
PointsCount.BackgroundTransparency = 1
PointsCount.Font = Enum.Font.GothamBold
PointsCount.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.86, 0, 0.08, 0)
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.93, 0, 0.08, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ===== КОНТЕНТ =====
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -46)
Content.Position = UDim2.new(0, 0, 0, 46)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ===== СПИСОК ТОЧЕК =====
local PointsList = Instance.new("ScrollingFrame")
PointsList.Size = UDim2.new(0.85, 0, 0, 130)
PointsList.Position = UDim2.new(0.075, 0, 0.02, 0)
PointsList.BackgroundColor3 = Color3.fromRGB(18, 22, 40)
PointsList.BorderSizePixel = 0
PointsList.ScrollBarThickness = 4
PointsList.CanvasSize = UDim2.new(0, 0, 0, 0)
PointsList.Parent = Content
local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = PointsList

local function UpdateList()
    for _, child in pairs(PointsList:GetChildren()) do child:Destroy() end
    PointsList.CanvasSize = UDim2.new(0, 0, 0, #Points * 22)
    for i, pos in ipairs(Points) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.Position = UDim2.new(0, 0, 0, (i-1) * 20)
        label.Text = string.format("%d: %.1f, %.1f, %.1f", i, pos.X, pos.Y, pos.Z)
        label.TextColor3 = Color3.fromRGB(200, 200, 235)
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.Parent = PointsList
    end
end

-- ===== ВЕРХНИЙ РЯД КНОПОК =====
local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0.3, 0, 0, 36)
AddBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
AddBtn.Text = "➕ ДОБАВИТЬ"
AddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.TextSize = 13
AddBtn.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
AddBtn.BorderSizePixel = 0
AddBtn.Font = Enum.Font.GothamSemibold
AddBtn.Parent = Content
local AddCorner = Instance.new("UICorner")
AddCorner.CornerRadius = UDim.new(0, 8)
AddCorner.Parent = AddBtn

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.2, 0, 0, 36)
ClearBtn.Position = UDim2.new(0.4, 0, 0.32, 0)
ClearBtn.Text = "🗑 ОЧИСТИТЬ"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.TextSize = 12
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
ClearBtn.BorderSizePixel = 0
ClearBtn.Font = Enum.Font.GothamSemibold
ClearBtn.Parent = Content
local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 8)
ClearCorner.Parent = ClearBtn

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.25, 0, 0, 36)
CopyBtn.Position = UDim2.new(0.65, 0, 0.32, 0)
CopyBtn.Text = "📋 КОПИРОВАТЬ"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 11
CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 120)
CopyBtn.BorderSizePixel = 0
CopyBtn.Font = Enum.Font.GothamSemibold
CopyBtn.Parent = Content
local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 8)
CopyCorner.Parent = CopyBtn

-- ===== СТАРТ/СТОП =====
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.42, 0, 0, 40)
StartBtn.Position = UDim2.new(0.05, 0, 0.44, 0)
StartBtn.Text = "🚀 СТАРТ"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.TextSize = 15
StartBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
StartBtn.BorderSizePixel = 0
StartBtn.Font = Enum.Font.GothamSemibold
StartBtn.Parent = Content
local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 8)
StartCorner.Parent = StartBtn

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.42, 0, 0, 40)
StopBtn.Position = UDim2.new(0.53, 0, 0.44, 0)
StopBtn.Text = "⏹ СТОП"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 15
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
StopBtn.BorderSizePixel = 0
StopBtn.Font = Enum.Font.GothamSemibold
StopBtn.Parent = Content
local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 8)
StopCorner.Parent = StopBtn

-- ===== НАСТРОЙКИ =====
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.2, 0, 0, 18)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.57, 0)
SpeedLabel.Text = "🚀 СКОРОСТЬ"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
SpeedLabel.TextSize = 11
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = Content

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.15, 0, 0, 28)
SpeedInput.Position = UDim2.new(0.05, 0, 0.62, 0)
SpeedInput.Text = "50"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextSize = 14
SpeedInput.BackgroundColor3 = Color3.fromRGB(18, 22, 40)
SpeedInput.BorderSizePixel = 0
SpeedInput.TextXAlignment = Enum.TextXAlignment.Center
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.Parent = Content
local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedInput

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val and val > 0 then Speed = val end
end)

local LoopBtn = Instance.new("TextButton")
LoopBtn.Size = UDim2.new(0.15, 0, 0, 28)
LoopBtn.Position = UDim2.new(0.25, 0, 0.62, 0)
LoopBtn.Text = "🔁 ВЫКЛ"
LoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoopBtn.TextSize = 11
LoopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
LoopBtn.BorderSizePixel = 0
LoopBtn.Font = Enum.Font.GothamSemibold
LoopBtn.Parent = Content
local LoopCorner = Instance.new("UICorner")
LoopCorner.CornerRadius = UDim.new(0, 6)
LoopCorner.Parent = LoopBtn

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(0.15, 0, 0, 18)
DelayLabel.Position = UDim2.new(0.5, 0, 0.57, 0)
DelayLabel.Text = "⏱ ЗАДЕРЖКА"
DelayLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
DelayLabel.TextSize = 11
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.BackgroundTransparency = 1
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.Parent = Content

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(0.12, 0, 0, 28)
DelayInput.Position = UDim2.new(0.5, 0, 0.62, 0)
DelayInput.Text = "1"
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.TextSize = 14
DelayInput.BackgroundColor3 = Color3.fromRGB(18, 22, 40)
DelayInput.BorderSizePixel = 0
DelayInput.TextXAlignment = Enum.TextXAlignment.Center
DelayInput.Font = Enum.Font.Gotham
DelayInput.Parent = Content
local DelayCorner = Instance.new("UICorner")
DelayCorner.CornerRadius = UDim.new(0, 6)
DelayCorner.Parent = DelayInput

DelayInput.FocusLost:Connect(function()
    local val = tonumber(DelayInput.Text)
    if val and val > 0 then LoopDelay = val end
end)

-- ===== СТАТУС =====
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.9, 0, 0, 22)
StatusText.Position = UDim2.new(0.05, 0, 0.78, 0)
StatusText.Text = "🟢 Готов"
StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusText.TextSize = 13
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = Content

-- ===== ФУНКЦИИ =====

local function AddPoint()
    local char = Player.Character
    if not char then
        StatusText.Text = "❌ Персонаж не найден"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        StatusText.Text = "❌ RootPart не найден"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    table.insert(Points, root.Position)
    PointsCount.Text = #Points
    UpdateList()
    StatusText.Text = "✅ Точка " .. #Points .. " добавлена"
    StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
end

local function ClearPoints()
    if IsFlying then StopFlight() end
    Points = {}
    PointsCount.Text = "0"
    UpdateList()
    StatusText.Text = "🗑 Точки очищены"
    StatusText.TextColor3 = Color3.fromRGB(200, 200, 100)
end

local function CopyPoints()
    if #Points == 0 then
        StatusText.Text = "❌ Нет точек для копирования"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    local text = ""
    for i, pos in ipairs(Points) do
        text = text .. string.format("%.1f, %.1f, %.1f\n", pos.X, pos.Y, pos.Z)
    end
    ClipboardService:SetText(text)
    StatusText.Text = "✅ " .. #Points .. " точек скопировано!"
    StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
end

local function StopFlight()
    IsFlying = false
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        end
    end
    StartBtn.Text = "🚀 СТАРТ"
    StartBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    if StatusText.Text ~= "✅ Маршрут пройден!" then
        StatusText.Text = "⏹ Остановлен"
        StatusText.TextColor3 = Color3.fromRGB(200, 200, 100)
    end
end

local function StartFlight()
    if #Points == 0 then
        StatusText.Text = "❌ Нет точек!"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    if IsFlying then return end
    IsFlying = true
    CurrentIndex = 1

    local char = Player.Character
    if not char then
        IsFlying = false
        StatusText.Text = "❌ Персонаж не найден"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then
        IsFlying = false
        StatusText.Text = "❌ Ошибка персонажа"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end

    StatusText.Text = "✈️ Летим к точке 1/" .. #Points
    StatusText.TextColor3 = Color3.fromRGB(100, 200, 255)
    StartBtn.Text = "ЛЕТИТ..."
    StartBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 100)

    hum.PlatformStand = true
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    BodyVelocity.Parent = root

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = root.CFrame
    BodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    BodyGyro.Parent = root

    if FlyConnection then FlyConnection:Disconnect() end

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not IsFlying then
            StopFlight()
            return
        end
        if not char or not root then
            StopFlight()
            return
        end

        local currentPos = root.Position
        local target = Points[CurrentIndex]
        local dist = (target - currentPos).Magnitude

        if dist < 3 then
            CurrentIndex = CurrentIndex + 1
            if CurrentIndex > #Points then
                if IsLoop then
                    StopFlight()
                    StatusText.Text = "🔄 Зацикливание... " .. LoopDelay .. "с"
                    StatusText.TextColor3 = Color3.fromRGB(100, 200, 255)
                    task.wait(LoopDelay)
                    StartFlight()
                else
                    StatusText.Text = "✅ Маршрут пройден!"
                    StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
                    StopFlight()
                end
                return
            end
            StatusText.Text = "✈️ Точка " .. CurrentIndex .. "/" .. #Points
            return
        end

        local dir = (target - currentPos).Unit
        if BodyVelocity then
            BodyVelocity.Velocity = dir * Speed
        end
        if BodyGyro then
            BodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + dir)
        end
    end)
end

-- ===== КНОПКИ =====

AddBtn.MouseButton1Click:Connect(AddPoint)
ClearBtn.MouseButton1Click:Connect(ClearPoints)
CopyBtn.MouseButton1Click:Connect(CopyPoints)

StartBtn.MouseButton1Click:Connect(function()
    if IsFlying then StopFlight() else StartFlight() end
end)

StopBtn.MouseButton1Click:Connect(StopFlight)

LoopBtn.MouseButton1Click:Connect(function()
    IsLoop = not IsLoop
    LoopBtn.Text = IsLoop and "🔁 ВКЛ" or "🔁 ВЫКЛ"
    LoopBtn.BackgroundColor3 = IsLoop and Color3.fromRGB(123, 63, 252) or Color3.fromRGB(60, 60, 100)
end)

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Content.Visible = not Minimized
    MinBtn.Text = Minimized and "+" or "─"
    MainFrame.Size = Minimized and UDim2.new(0, 360, 0, 46) or UDim2.new(0, 360, 0, 460)
end)

CloseBtn.MouseButton1Click:Connect(function()
    StopFlight()
    ScreenGui:Destroy()
end)

-- ===== ГОРЯЧИЕ КЛАВИШИ =====
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.P then AddBtn.MouseButton1Click:Connect() end
    if input.KeyCode == Enum.KeyCode.F then StartBtn.MouseButton1Click:Connect() end
    if input.KeyCode == Enum.KeyCode.G then StopBtn.MouseButton1Click:Connect() end
end)

Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if IsFlying then StopFlight() end
end)

print("✅ НАВИГАТОР LITE загружен!")
print("📌 P — добавить | 📋 КОПИРОВАТЬ — скопировать координаты")
