--[[ 
THE FORGE PREMIUM SCRIPT - PC
All-in-One | GUI Premium
]]

-- Anti duplicação
if game.CoreGui:FindFirstChild("ForgePremiumPC") then
    game.CoreGui.ForgePremiumPC:Destroy()
end

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ForgePremiumPC"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,460,0,480)
main.Position = UDim2.new(0.5,-230,0.5,-240)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,45)
title.Text = "🔥 THE FORGE PREMIUM | PC"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,170,0)
title.BackgroundTransparency = 1

-- Função botão
local function Button(text, y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,36)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.BorderSizePixel = 0
    return b
end

-- Estados
local AutoFarm = false
local ESPEnabled = false
local NoClip = false

-- Botões
local farmBtn = Button("⛏ Auto Farm [OFF]", 60)
local espBtn  = Button("👁 ESP Completo [OFF]", 105)
local tpBoss  = Button("⚡ Teleport Boss", 150)
local tpOre   = Button("⚡ Teleport Minério Próximo", 195)
local speedBtn= Button("🏃 Speed + Jump", 240)
local noclipB = Button("🚪 NoClip [OFF]", 285)
local hopBtn  = Button("🌍 Server Hop", 330)

-- AUTO FARM
farmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    farmBtn.Text = AutoFarm and "⛏ Auto Farm [ON]" or "⛏ Auto Farm [OFF]"

    task.spawn(function()
        while AutoFarm do
            pcall(function()
                mouse1click()
            end)
            task.wait(math.random(12,18)/100)
        end
    end)
end)

-- ESP COMPLETO
local function CreateESP(model, color)
    if model:FindFirstChild("ForgeESP") then return end
    local box = Instance.new("BoxHandleAdornment", model)
    box.Name = "ForgeESP"
    box.Adornee = model
    box.Size = model:GetExtentsSize()
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = color
    box.Transparency = 0.5
end

espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = ESPEnabled and "👁 ESP Completo [ON]" or "👁 ESP Completo [OFF]"

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            if ESPEnabled then
                if v.Name:lower():find("ore") then
                    CreateESP(v, Color3.fromRGB(0,255,0))
                elseif v.Name:lower():find("boss") then
                    CreateESP(v, Color3.fromRGB(255,0,0))
                elseif Players:GetPlayerFromCharacter(v) then
                    CreateESP(v, Color3.fromRGB(0,170,255))
                end
            elseif v:FindFirstChild("ForgeESP") then
                v.ForgeESP:Destroy()
            end
        end
    end
end)

-- TELEPORT BOSS
tpBoss.MouseButton1Click:Connect(function()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("boss") then
            player.Character.HumanoidRootPart.CFrame = v:GetPivot()
        end
    end
end)

-- TELEPORT MINÉRIO PRÓXIMO
tpOre.MouseButton1Click:Connect(function()
    local hrp = player.Character.HumanoidRootPart
    local closest, dist = nil, math.huge

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("ore") then
            local p = v:GetPivot().Position
            local d = (hrp.Position - p).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end

    if closest then
        hrp.CFrame = closest:GetPivot()
    end
end)

-- SPEED / JUMP
speedBtn.MouseButton1Click:Connect(function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 45
        hum.JumpPower = 80
    end
end)

-- NOCLIP
noclipB.MouseButton1Click:Connect(function()
    NoClip = not NoClip
    noclipB.Text = NoClip and "🚪 NoClip [ON]" or "🚪 NoClip [OFF]"
end)

RunService.Stepped:Connect(function()
    if NoClip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- SERVER HOP
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId)
end)

print("🔥 THE FORGE PREMIUM PC SCRIPT CARREGADO COM SUCESSO")
