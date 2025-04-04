# Game-Guardian-teste
-- Botão MP
local ScreenGui = Instance.new("ScreenGui")
local MPButton = Instance.new("TextButton")
local SearchBox = Instance.new("TextBox")
local ResultsFrame = Instance.new("Frame")
local UpdateButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MPGui"

-- Botão
MPButton.Parent = ScreenGui
MPButton.Position = UDim2.new(0, 20, 0, 20)
MPButton.Size = UDim2.new(0, 100, 0, 40)
MPButton.Text = "MP"

-- Caixa de pesquisa
SearchBox.Parent = ScreenGui
SearchBox.Position = UDim2.new(0, 130, 0, 20)
SearchBox.Size = UDim2.new(0, 100, 0, 40)
SearchBox.Visible = false
SearchBox.PlaceholderText = "Pesquisar número"

-- Resultados
ResultsFrame.Parent = ScreenGui
ResultsFrame.Position = UDim2.new(0, 20, 0, 70)
ResultsFrame.Size = UDim2.new(0, 400, 0, 200)
ResultsFrame.BackgroundTransparency = 0.5
ResultsFrame.Visible = false

-- Botão para atualizar
UpdateButton.Parent = ScreenGui
UpdateButton.Position = UDim2.new(0, 430, 0, 70)
UpdateButton.Size = UDim2.new(0, 100, 0, 40)
UpdateButton.Text = "Atualizar"
UpdateButton.Visible = false

-- Função para conversão
local function convertValue(val)
    return {
        Decimal = tonumber(val),
        Binario = "0b" .. string.format("%b", val),
        Hexa = "0x" .. string.format("%X", val),
    }
end

-- Simula um código do mapa (por exemplo, parte da memória/variáveis)
local mapaCodigo = {
    [1] = 2,
    [2] = 4,
    [3] = 8,
    [4] = 15,
    [5] = 4, -- valor duplicado
}

-- Ao clicar em MP
MPButton.MouseButton1Click:Connect(function()
    SearchBox.Visible = true
end)

-- Ao pesquisar
SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ResultsFrame:ClearAllChildren()
        ResultsFrame.Visible = true
        UpdateButton.Visible = true

        local buscar = tonumber(SearchBox.Text)
        if not buscar then return end

        local y = 0
        for id, valor in pairs(mapaCodigo) do
            if valor == buscar then
                local info = convertValue(valor)

                local label = Instance.new("TextBox")
                label.Parent = ResultsFrame
                label.Position = UDim2.new(0, 0, 0, y * 30)
                label.Size = UDim2.new(0, 380, 0, 30)
                label.Text = "ID "..id..": "..info.Decimal.." | "..info.Binario.." | "..info.Hexa
                label.Name = tostring(id)
                label.ClearTextOnFocus = false

                y = y + 1
            end
        end
    end
end)

-- Atualizar os valores
UpdateButton.MouseButton1Click:Connect(function()
    for _, child in pairs(ResultsFrame:GetChildren()) do
        if child:IsA("TextBox") then
            local id = tonumber(child.Name)
            local novoValor = tonumber(child.Text:match("ID %d+: (%d+)"))
            if novoValor then
                mapaCodigo[id] = novoValor
                print("Atualizado ID "..id.." para "..novoValor)
            end
        end
    end
end)
