-- Universal loader by luhnox
local GAME_MAP = {
    [17577256698] = "https://luhnox.vercel.app/api/hutan" -- Hutan [Vercel]
    -- Tambah game lain di sini: [PLACEID] = "VERCEL_URL" atau "RAW_GITHUB_URL"
}

local function safeHttpGet(url)
    local ok, res = pcall(function()
        if syn and syn.request then
            return syn.request({
                Url = url,
                Method = "GET"
            }).Body
        elseif http and http.request then
            return http.request({
                Url = url,
                Method = "GET"
            }).Body
        elseif request then
            return request({
                Url = url,
                Method = "GET"
            }).Body
        elseif game.HttpGet then
            return game:HttpGet(url)
        end
    end)
    if ok and res then
        return res
    end
    error("Failed to fetch: " .. tostring(url))
end

local function showNotSupportedPopup()
    local placeId = game.PlaceId
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Freeze player movement
    local originalWalkSpeed = humanoid.WalkSpeed
    local originalJumpPower = humanoid.JumpPower
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    rootPart.Anchored = true
    
    -- Disable ShiftLock
    local UserInputService = game:GetService("UserInputService")
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    
    -- Lock camera and prevent character rotation
    local Camera = workspace.CurrentCamera
    local originalCameraType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    local cameraPosition = Camera.CFrame
    
    -- Prevent any character rotation
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.D = 100
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- Keep updating camera position to prevent movement
    local cameraConnection = game:GetService("RunService").RenderStepped:Connect(function()
        Camera.CFrame = cameraPosition
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, bodyGyro.CFrame.Rotation.Y, 0)
    end)
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "luhnoxNotSupported"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game:GetService("CoreGui")

    -- Add blur effect
    local blur = Instance.new("BlurEffect")
    blur.Name = "luhnoxBlur"
    blur.Size = 24
    blur.Parent = game:GetService("Lighting")

    -- Background dimmer
    local dimmer = Instance.new("Frame")
    dimmer.Name = "Dimmer"
    dimmer.Size = UDim2.new(1, 0, 1, 0)
    dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dimmer.BackgroundTransparency = 0.4
    dimmer.BorderSizePixel = 0
    dimmer.Parent = screenGui

    -- Main popup container
    local popup = Instance.new("Frame")
    popup.Name = "Popup"
    popup.Size = UDim2.new(0, 550, 0, 280)
    popup.Position = UDim2.new(0.5, 0, 0.5, 0)
    popup.AnchorPoint = Vector2.new(0.5, 0.5)
    popup.BackgroundColor3 = Color3.fromRGB(60, 63, 65)
    popup.BorderSizePixel = 0
    popup.Active = true
    popup.Parent = screenGui

    -- Corner radius
    local popupCorner = Instance.new("UICorner")
    popupCorner.CornerRadius = UDim.new(0, 8)
    popupCorner.Parent = popup

    -- Title section
    local titleSection = Instance.new("Frame")
    titleSection.Name = "TitleSection"
    titleSection.Size = UDim2.new(1, 0, 0, 60)
    titleSection.BackgroundTransparency = 1
    titleSection.Parent = popup

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 1, -5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "Game Not Supported"
    title.TextSize = 24
    title.Font = Enum.Font.SourceSansSemibold
    title.Parent = titleSection

    -- Title separator line
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, -80, 0, 1)
    separator.Position = UDim2.new(0, 40, 1, -5)
    separator.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    separator.BorderSizePixel = 0
    separator.Parent = titleSection

    -- Message container
    local messageContainer = Instance.new("Frame")
    messageContainer.Name = "MessageContainer"
    messageContainer.Size = UDim2.new(1, -80, 0, 130)
    messageContainer.Position = UDim2.new(0, 40, 0, 70)
    messageContainer.BackgroundTransparency = 1
    messageContainer.Parent = popup

    -- Message
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, 0, 1, 0)
    message.BackgroundTransparency = 1
    message.TextColor3 = Color3.fromRGB(200, 200, 200)
    message.Text = "This experience is not currently supported by luhnox loader.\n\nPlaceId: " .. tostring(placeId) ..
                       "\n\nPlease try another game or contact support if you believe this is an error."
    message.TextSize = 16
    message.Font = Enum.Font.SourceSans
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.Parent = messageContainer

    -- Button container
    local btnContainer = Instance.new("Frame")
    btnContainer.Name = "ButtonContainer"
    btnContainer.Size = UDim2.new(1, -80, 0, 42)
    btnContainer.Position = UDim2.new(0, 40, 1, -62)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = popup

    -- Leave button (white/light gray)
    local leaveBtn = Instance.new("TextButton")
    leaveBtn.Name = "LeaveBtn"
    leaveBtn.Size = UDim2.new(0.48, 0, 1, 0)
    leaveBtn.Position = UDim2.new(0, 0, 0, 0)
    leaveBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    leaveBtn.TextColor3 = Color3.fromRGB(40, 40, 40)
    leaveBtn.Text = "Leave"
    leaveBtn.Font = Enum.Font.SourceSansSemibold
    leaveBtn.TextSize = 20
    leaveBtn.AutoButtonColor = false
    leaveBtn.BorderSizePixel = 0
    leaveBtn.Parent = btnContainer

    local leaveCorner = Instance.new("UICorner")
    leaveCorner.CornerRadius = UDim.new(0, 8)
    leaveCorner.Parent = leaveBtn

    -- Reconnect button (white/light gray)
    local reconnectBtn = Instance.new("TextButton")
    reconnectBtn.Name = "ReconnectBtn"
    reconnectBtn.Size = UDim2.new(0.48, 0, 1, 0)
    reconnectBtn.Position = UDim2.new(0.52, 0, 0, 0)
    reconnectBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    reconnectBtn.TextColor3 = Color3.fromRGB(40, 40, 40)
    reconnectBtn.Text = "Reconnect"
    reconnectBtn.Font = Enum.Font.SourceSansSemibold
    reconnectBtn.TextSize = 20
    reconnectBtn.AutoButtonColor = false
    reconnectBtn.BorderSizePixel = 0
    reconnectBtn.Parent = btnContainer

    local reconnectCorner = Instance.new("UICorner")
    reconnectCorner.CornerRadius = UDim.new(0, 8)
    reconnectCorner.Parent = reconnectBtn

    -- Button hover effects
    local function addHoverEffect(button)
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        end)
    end

    addHoverEffect(leaveBtn)
    addHoverEffect(reconnectBtn)

    -- Button events
    leaveBtn.MouseButton1Click:Connect(function()
        cameraConnection:Disconnect()
        bodyGyro:Destroy()
        blur:Destroy()
        screenGui:Destroy()
        wait(0.2)
        game:Shutdown()
    end)

    reconnectBtn.MouseButton1Click:Connect(function()
        cameraConnection:Disconnect()
        bodyGyro:Destroy()
        blur:Destroy()
        screenGui:Destroy()
        wait(0.2)
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId)
    end)
end

local placeId = game.PlaceId
local target = GAME_MAP[placeId]

if target then
    local src = safeHttpGet(target)
    loadstring(src)()
else
    warn("Game not supported. PlaceId: " .. tostring(placeId))
    showNotSupportedPopup()
end
