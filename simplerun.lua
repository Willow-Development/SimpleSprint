local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local maxStamina = 100
local currentStamina = maxStamina
local staminaDrainRate = 10
local staminaRegenRate = 5
local isSprinting = false
local canSprint = true
local minStaminaToSprint = 0.25

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local staminaFrame = Instance.new("Frame")
staminaFrame.Size = UDim2.new(0.2, 0, 0.05, 0)
staminaFrame.Position = UDim2.new(0.01, 0, 0.95, 0)
staminaFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
staminaFrame.BorderSizePixel = 0
staminaFrame.BackgroundTransparency = 0.5
staminaFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = staminaFrame

local staminaBar = Instance.new("Frame")
staminaBar.Size = UDim2.new(1, 0, 1, 0)
staminaBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
staminaBar.BorderSizePixel = 0
staminaBar.Parent = staminaFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 10)
barCorner.Parent = staminaBar

local function updateStaminaBar()
    local size = currentStamina / maxStamina
    staminaBar.Size = UDim2.new(size, 0, 1, 0)

    if size <= 0.25 then
        staminaBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    elseif size <= 0.5 then
        staminaBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    else
        staminaBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end

local function startSprinting()
    if canSprint and currentStamina > maxStamina * minStaminaToSprint then
        humanoid.WalkSpeed = 24
        isSprinting = true
    else
        isSprinting = false
    end
end

local function stopSprinting()
    humanoid.WalkSpeed = 16
    isSprinting = false
end

game:GetService("RunService").RenderStepped:Connect(function()
    if isSprinting then
        currentStamina = currentStamina - staminaDrainRate * game:GetService("RunService").Heartbeat:Wait()
        if currentStamina <= 0 then
            currentStamina = 0
            stopSprinting()
        end
        updateStaminaBar()
    elseif currentStamina < maxStamina then
        currentStamina = currentStamina + staminaRegenRate * game:GetService("RunService").Heartbeat:Wait()
        if currentStamina > maxStamina then
            currentStamina = maxStamina
        end
        updateStaminaBar()
    end
end)

userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        startSprinting()
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        stopSprinting()
    end
end)
