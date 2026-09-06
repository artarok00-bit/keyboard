-- [[ НАВИГАТОР — ТОЧКИ И КОПИРОВАНИЕ ]]
-- Вкладка "ДОБАВИТЬ": кнопка добавить точку
-- Вкладка "ТОЧКИ": список точек + кнопка "КОПИРОВАТЬ"

local Player = game.Players.LocalPlayer
local ClipboardService = game:GetService("ClipboardService")
local UserInputService = game:GetService("UserInputService")

local Points = {}
local Minimized = false
local CurrentTab = "Add"

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Navigator"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 460)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -230)
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
TitleText.Size = UDim2.new(0.6, 0, 1, 0)
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

-- ===== ВКЛАДКИ =====
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 38)
TabBar.Position = UDim2.new(0, 0, 0, 46)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local AddTab = Instance.new("TextButton")
AddTab.Size = UDim2.new(0.5, 0, 1, 0)
AddTab.Position = UDim2.new(0, 0, 0, 0)
AddTab.Text = "➕ ДОБАВИТЬ"
AddTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AddTab.TextSize = 14
AddTab.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
AddTab.BorderSizePixel = 0
AddTab.Font = Enum.Font.GothamSemibold
AddTab.Parent = TabBar

local PointsTab = Instance.new("TextButton")
PointsTab.Size = UDim2.new(0.5, 0, 1, 0)
PointsTab.Position = UDim2.new(0.5, 0, 0, 0)
PointsTab.Text = "📍 ТОЧКИ"
PointsTab.TextColor3 = Color3.fromRGB(180, 180, 210)
PointsTab.TextSize = 14
PointsTab.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
PointsTab.BorderSizePixel = 0
PointsTab.Font = Enum.Font.GothamSemibold
PointsTab.Parent = TabBar

-- ===== КОНТЕНТ =====
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -84)
Content.Position = UDim2.new(0, 0, 0, 84)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ===== ВКЛАДКА "ДОБАВИТЬ" =====
local AddPanel = Instance.new("Frame")
AddPanel.Size = UDim2.new(1, 0, 1, 0)
AddPanel.BackgroundTransparency = 1
AddPanel.Parent = Content

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0.85, 0, 0, 60)
AddBtn.Position = UDim2.new(0.075, 0, 0.1, 0)
AddBtn.Text = "📌 ДОБАВИТЬ ТОЧКУ"
AddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.TextSize = 18
AddBtn.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
AddBtn.BorderSizePixel = 0
AddBtn.Font = Enum.Font.GothamSemibold
AddBtn.Parent = AddPanel
local AddCorner = Instance.new("UICorner")
AddCorner.CornerRadius = UDim.new(0, 10)
AddCorner.Parent = AddBtn

local AddStatus = Instance.new("TextLabel")
AddStatus.Size = UDim2.new(0.9, 0, 0, 30)
AddStatus.Position = UDim2.new(0.05, 0, 0.35, 0)
AddStatus.Text = "🟢 Подойди в нужное место и нажми кнопку"
AddStatus.TextColor3 = Color3.fromRGB(180, 180, 210)
AddStatus.TextSize = 13
AddStatus.TextXAlignment = Enum.TextXAlignment.Center
AddStatus.BackgroundTransparency = 1
AddStatus.Font = Enum.Font.Gotham
AddStatus.Parent = AddPanel

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.85, 0, 0, 40)
ClearBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
ClearBtn.Text = "🗑 ОЧИСТИТЬ ВСЕ ТОЧКИ"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.TextSize = 14
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
ClearBtn.BorderSizePixel = 0
ClearBtn.Font = Enum.Font.GothamSemibold
ClearBtn.Parent = AddPanel
local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 8)
ClearCorner.Parent = ClearBtn

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.9, 0, 0, 22)
StatusText.Position = UDim2.new(0.05, 0, 0.8, 0)
StatusText.Text = "🟢 Готов"
StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusText.TextSize = 13
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = AddPanel

-- ===== ВКЛАДКА "ТОЧКИ" =====
local PointsPanel = Instance.new("Frame")
PointsPanel.Size = UDim2.new(1, 0, 1, 0)
PointsPanel.BackgroundTransparency = 1
PointsPanel.Visible = false
PointsPanel.Parent = Content

local PointsList = Instance.new("ScrollingFrame")
PointsList.Size = UDim2.new(0.85, 0, 0, 300)
PointsList.Position = UDim2.new(0.075, 0, 0.03, 0)
PointsList.BackgroundColor3 = Color3.fromRGB(18, 22, 40)
PointsList.BorderSizePixel = 0
PointsList.ScrollBarThickness = 4
PointsList.CanvasSize = UDim2.new(0, 0, 0, 0)
PointsList.Parent = PointsPanel
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

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.85, 0, 0, 40)
CopyBtn.Position = UDim2.new(0.075, 0, 0.82, 0)
CopyBtn.Text = "📋 КОПИРОВАТЬ ВСЕ КООРДИНАТЫ"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 14
CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 120)
CopyBtn.BorderSizePixel = 0
CopyBtn.Font = Enum.Font.GothamSemibold
CopyBtn.Parent = PointsPanel
local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 8)
CopyCorner.Parent = CopyBtn

local CopyStatus = Instance.new("TextLabel")
CopyStatus.Size = UDim2.new(0.9, 0, 0, 20)
CopyStatus.Position = UDim2.new(0.05, 0, 0.91, 0)
CopyStatus.Text = "📋 Нажми кнопку, чтобы скопировать координаты"
CopyStatus.TextColor3 = Color3.fromRGB(150, 150, 180)
CopyStatus.TextSize = 11
CopyStatus.TextXAlignment = Enum.TextXAlignment.Center
CopyStatus.BackgroundTransparency = 1
CopyStatus.Font = Enum.Font.Gotham
CopyStatus.Parent = PointsPanel

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
    AddStatus.Text = "✅ Точка " .. #Points .. " сохранена!"
    AddStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
    task.wait(0.8)
    AddStatus.Text = "🟢 Подойди в нужное место и нажми кнопку"
    AddStatus.TextColor3 = Color3.fromRGB(180, 180, 210)
end

local function ClearPoints()
    Points = {}
    PointsCount.Text = "0"
    UpdateList()
    StatusText.Text = "🗑 Точки очищены"
    StatusText.TextColor3 = Color3.fromRGB(200, 200, 100)
    AddStatus.Text = "🟢 Подойди в нужное место и нажми кнопку"
    AddStatus.TextColor3 = Color3.fromRGB(180, 180, 210)
end

local function CopyPoints()
    if #Points == 0 then
        CopyStatus.Text = "❌ Нет точек для копирования"
        CopyStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    local text = ""
    for i, pos in ipairs(Points) do
        text = text .. string.format("%.1f, %.1f, %.1f\n", pos.X, pos.Y, pos.Z)
    end
    ClipboardService:SetText(text)
    CopyStatus.Text = "✅ " .. #Points .. " точек скопировано!"
    CopyStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
end

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====

AddTab.MouseButton1Click:Connect(function()
    CurrentTab = "Add"
    AddPanel.Visible = true
    PointsPanel.Visible = false
    AddTab.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
    AddTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    PointsTab.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
    PointsTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

PointsTab.MouseButton1Click:Connect(function()
    CurrentTab = "Points"
    AddPanel.Visible = false
    PointsPanel.Visible = true
    PointsTab.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
    PointsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddTab.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
    AddTab.TextColor3 = Color3.fromRGB(180, 180, 210)
    UpdateList()
end)

-- ===== КНОПКИ =====

AddBtn.MouseButton1Click:Connect(AddPoint)
ClearBtn.MouseButton1Click:Connect(ClearPoints)
CopyBtn.MouseButton1Click:Connect(CopyPoints)

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Content.Visible = not Minimized
    TabBar.Visible = not Minimized
    MinBtn.Text = Minimized and "+" or "─"
    MainFrame.Size = Minimized and UDim2.new(0, 380, 0, 46) or UDim2.new(0, 380, 0, 460)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ===== ГОРЯЧАЯ КЛАВИША =====
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.P then AddBtn.MouseButton1Click:Connect() end
end)

print("✅ НАВИГАТОР загружен!")
print("📌 P — добавить точку | Вкладка ТОЧКИ — скопировать координаты")
