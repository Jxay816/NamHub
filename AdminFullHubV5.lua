-- Hoài Băng Full Hub V5 - Whitelist: 288sjsjajabaj
-- Các tính năng: Key System, One-Tap Teleport (Draggable), No Cooldown, Auto Farm Trophy, Anti-Kick, Anti-AFK
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. HỆ THỐNG KEY BẢO MẬT
if CoreGui:FindFirstChild("AdminFullHub") then CoreGui.AdminFullHub:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminFullHub"
ScreenGui.Parent = CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = ScreenGui
KeyFrame.Size = UDim2.new(0, 250, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local KeyInput = Instance.new("TextBox")
KeyInput.Parent = KeyFrame
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.PlaceholderText = "NHẬP KEY: 859532"
KeyInput.Text = ""

local KeyBtn = Instance.new("TextButton")
KeyBtn.Parent = KeyFrame
KeyBtn.Size = UDim2.new(0.6, 0, 0, 35)
KeyBtn.Position = UDim2.new(0.2, 0, 0.7, 0)
KeyBtn.Text = "XÁC NHẬN"
KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- 2. NÚT OPEN DI CHUYỂN ĐƯỢC
local MainBtn = Instance.new("TextButton")
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 80, 0, 40)
MainBtn.Position = UDim2.new(0, 10, 0.4, 0)
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MainBtn.Text = "OPEN"
MainBtn.Visible = false
MainBtn.Draggable = true
MainBtn.Active = true

-- 3. CÁC TÍNH NĂNG CHÍNH
local isWaitingForTele = false

-- Hàm tắt trạng thái Tele
local function DeactivateTele()
    isWaitingForTele = false
    MainBtn.Text = "OPEN"
    MainBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end

-- Khi nhập đúng Key 1
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "Bu lon t đi" then
        KeyFrame.Visible = false
        MainBtn.Visible = true
        
        -- Kích hoạt Auto Farm Trophy Thật (Chạy ngầm)
        task.spawn(function()
            while true do
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("trophy") or v.Name:lower():find("brainrot")) then
                        v:FireServer()
                    end
                end
                task.wait(0.1)
            end
        end)
        
        -- ===== ANTI-KICK =====
        task.spawn(function()
            while true do
                local char = Player.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        humanoid.Health = 100
                    end
                end
                task.wait(0.5)
            end
        end)
        
        -- ===== ANTI-AFK =====
        task.spawn(function()
            while true do
                local args = {
                    [1] = "Idle",
                    [2] = false
                }
                game:GetService("Players"):FindFirstChild(Player.Name):FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Idle, false)
                task.wait(30) -- Di chuyển mỗi 30 giây
                local char = Player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    root.CFrame = root.CFrame + Vector3.new(0, 0.1, 0)
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Xử lý Click Teleport Một Lần
MainBtn.MouseButton1Click:Connect(function()
    if not isWaitingForTele then
        isWaitingForTele = true
        MainBtn.Text = "READY..."
        MainBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    else
        DeactivateTele()
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp or not isWaitingForTele then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Chống chạm nhầm Joystick bên trái
        if input.Position.X < (UIS:GetMouseLocation().X / 3) then return end
        
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and Mouse.Hit then
            root.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0))
            DeactivateTele() -- Tele xong tự tắt
        end
    end
end)