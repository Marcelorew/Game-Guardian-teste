-- SCRIPT UNIFICADO FLUTUANTE PARA ROBLOX -- Criado por Geovanny

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local HttpService = game:GetService("HttpService")

-- UI FLUTUANTE local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui) mainFrame.Size = UDim2.new(0, 300, 0, 400) mainFrame.Position = UDim2.new(0.5, -150, 0.3, 0) mainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 255) mainFrame.Active = true mainFrame.Draggable = true mainFrame.BorderSizePixel = 0

local closeButton = Instance.new("TextButton", mainFrame) closeButton.Size = UDim2.new(0, 30, 0, 30) closeButton.Position = UDim2.new(1, -35, 0, 5) closeButton.Text = "X" closeButton.BackgroundColor3 = Color3.new(1, 0, 0) closeButton.TextColor3 = Color3.new(1, 1, 1) closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local logBox = Instance.new("TextLabel", mainFrame) logBox.Size = UDim2.new(1, -10, 0.6, -40) logBox.Position = UDim2.new(0, 5, 0.2, 0) logBox.Text = "[LOG DE ALTERAÇÕES]" logBox.TextColor3 = Color3.new(1, 1, 1) logBox.TextWrapped = true logBox.TextYAlignment = Enum.TextYAlignment.Top logBox.BackgroundTransparency = 1 logBox.TextXAlignment = Enum.TextXAlignment.Left logBox.Font = Enum.Font.Code logBox.TextSize = 14 logBox.ClipsDescendants = true

local playerCountLabel = Instance.new("TextLabel", mainFrame) playerCountLabel.Size = UDim2.new(1, -10, 0, 20) playerCountLabel.Position = UDim2.new(0, 5, 0, 40) playerCountLabel.TextColor3 = Color3.new(1, 1, 1) playerCountLabel.BackgroundTransparency = 1 playerCountLabel.Font = Enum.Font.SourceSans playerCountLabel.TextSize = 18 playerCountLabel.Text = "Jogadores por perto: 0"

local tempoLabel = Instance.new("TextLabel", mainFrame) tempoLabel.Size = UDim2.new(1, -10, 0, 20) tempoLabel.Position = UDim2.new(0, 5, 0, 65) tempoLabel.TextColor3 = Color3.new(1, 1, 1) tempoLabel.BackgroundTransparency = 1 tempoLabel.Font = Enum.Font.SourceSans tempoLabel.TextSize = 18

local toggleButton = Instance.new("TextButton", mainFrame) toggleButton.Size = UDim2.new(1, -10, 0, 30) toggleButton.Position = UDim2.new(0, 5, 0, 95) toggleButton.Text = "Modo Aleatório: ON" toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) toggleButton.TextColor3 = Color3.new(1, 1, 1)

local randomMode = true toggleButton.MouseButton1Click:Connect(function() randomMode = not randomMode toggleButton.Text = "Modo Aleatório: " .. (randomMode and "ON" or "OFF") end)

-- FUNÇÃO PRINCIPAL DE ALTERAÇÃO local function alterarJogador(jogador) if jogador == LocalPlayer then return end local log = "["..jogador.Name.."]\n" local components = {}

for i = 1, 30 do
    local componente = Instance.new("BoolValue")
    componente.Name = "Comp"..math.random(1000,9999)
    componente.Value = (math.random() > 0.5)
    componente.Parent = jogador:FindFirstChildOfClass("Model") or jogador.Character or jogador
    table.insert(components, componente.Name .. "=" .. tostring(componente.Value))
end

local som = Instance.new("Sound")
som.SoundId = "rbxassetid://142376088"  -- som base
som.Volume = math.random(5, 10)
som.PlaybackSpeed = math.random(50,150)/100
som.Looped = false
som.Parent = jogador:FindFirstChildOfClass("Model") or jogador.Character or jogador
som:Play()

log = log .. "ÁUDIO=ok | " .. table.concat(components, ", ")
return log

end

-- LOOP PRINCIPAL local ultimoTempo = tick() RunService.Heartbeat:Connect(function() local jogadores = Players:GetPlayers() local perto = 0 for _, p in ipairs(jogadores) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude if dist < 100 then perto += 1 end end end playerCountLabel.Text = "Jogadores por perto: " .. perto

local tempoRestante = math.max(0, 15 - (tick() - ultimoTempo))
tempoLabel.Text = string.format("Tempo p/ próxima alteração: %.1f s", tempoRestante)

if randomMode and tick() - ultimoTempo >= 15 then
    ultimoTempo = tick()
    local logs = {}
    local todos = {}
    for _, p in ipairs(jogadores) do
        if p ~= LocalPlayer then
            table.insert(todos, p)
        end
    end
    for i = 1, math.min(12, #todos) do
        local alvo = todos[math.random(1, #todos)]
        table.remove(todos, table.find(todos, alvo))
        local resultado = alterarJogador(alvo)
        table.insert(logs, resultado)
    end

    local textoLog = table.concat(logs, "\n\n")
    local atual = logBox.Text
    atual = atual .. "\n\n" .. textoLog
    local linhas = string.split(atual, "\n")
    if #linhas > 100 then
        linhas = { unpack(linhas, #linhas-99, #linhas) }
    end
    logBox.Text = table.concat(linhas, "\n")
end

end)

-- FIM DO SCRIPT

