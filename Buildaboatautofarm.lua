local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()
local Window = Library:Window({
    Title = "AuroraX",
    Desc = "???",
    Icon = 133631767716010,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 400, 0, 200)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "show AuroraX"
    }
})

local TabFarm = Window:Tab({Title = "Farm", Icon = "leaf"})
local TabInfo = Window:Tab({Title = "Info", Icon = "info"})

local player = game.Players.LocalPlayer
local autoFarmEnabled = false
local flySpeed = 350

local stepLabel = Instance.new("TextLabel")
stepLabel.Size = UDim2.new(1, -10, 0, 20)
stepLabel.Position = UDim2.new(0,5,0,5)
stepLabel.BackgroundTransparency = 1
stepLabel.TextColor3 = Color3.fromRGB(255,255,255)
stepLabel.Font = Enum.Font.SourceSansBold
stepLabel.TextSize = 14
stepLabel.TextXAlignment = Enum.TextXAlignment.Left
stepLabel.Text = "Current Step: Idle"
stepLabel.Parent = TabFarm.Container

local function noclipEnable()
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
    pcall(function()
        local PhysicsService = game:GetService("PhysicsService")
        PhysicsService:SetPartCollisionGroup(char.HumanoidRootPart, "NoclipGroup")
    end)
end

local function noclipDisable()
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if autoFarmEnabled then
        noclipEnable()
    else
        noclipDisable()
    end
end)

local function smoothFly(destination, speed)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    while (hrp.Position - destination).Magnitude > 5 and autoFarmEnabled do
        local direction = (destination - hrp.Position).Unit
        bv.Velocity = direction * speed
        bg.CFrame = CFrame.new(hrp.Position, destination)
        task.wait(0.03)
    end

    bv:Destroy()
    bg:Destroy()
    humanoid.PlatformStand = false
end

local points = {
    "VoteLaunchRE",
    Vector3.new(-55, 80, 630),
    Vector3.new(-55, 80, 8725),
    Vector3.new(-55, -356, 9209),
    Vector3.new(-55, -357, 9486),
    "ClaimRiverResultsGold"
}

task.spawn(function()
    while true do
        if autoFarmEnabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not char or not hrp then task.wait(1) continue end

            stepLabel.Text = "Current Step: 1 - Start adventure"
            if workspace:FindFirstChild("CamoZone") and workspace.CamoZone:FindFirstChild("VoteLaunchRE") then
                for i = 1,5 do
                    workspace.CamoZone.VoteLaunchRE:FireServer()
                    task.wait(0.2)
                end
            end
            task.wait(2)

            stepLabel.Text = "Current Step: 2 - Fly to river"
            noclipEnable()
            smoothFly(points[2], flySpeed)

            stepLabel.Text = "Current Step: 3 - Fly through gates"
            noclipDisable()
            smoothFly(points[3], flySpeed)

            stepLabel.Text = "Current Step: 4 - Fly to waterfall"
            smoothFly(points[4], flySpeed)

            stepLabel.Text = "Current Step: 5 - Fly to treasure chest"
            smoothFly(points[5], flySpeed)
            task.wait(20)

            stepLabel.Text = "Current Step: 6 - Claim coin"
            if workspace:FindFirstChild("ClaimRiverResultsGold") then
                workspace.ClaimRiverResultsGold:FireServer()
            end
            task.wait(5)
        else
            stepLabel.Text = "Current Step: Idle"
            task.wait(0.5)
        end
    end
end)

TabFarm:Toggle({
    Title = "Auto Farm Coin",
    Desc = "On/Off Auto Farm Coin",
    Value = false,
    Callback = function(v)
        autoFarmEnabled = v
        stepLabel.Text = v and "Current Step: Starting..." or "Current Step: Idle"
        if v then
            noclipEnable()
        else
            noclipDisable()
        end
    end
})

TabInfo:Section({Title="Info & About"})

TabInfo:Button({
    Title = "Tiktok: @mew_city1090",
    Desc = "Nhấn để sao chép liên kết TikTok",
    Callback = function()
        setclipboard("https://www.tiktok.com/@mew_city1090?_t=ZS-90N47llLYUU&_r=1")
    end
})
