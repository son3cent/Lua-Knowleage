if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- if true then return end

-- repeat wait() until game.Players.LocalPlayer
-- game.Players.LocalPlayer:WaitForChild("Character")
-- game.Players.LocalPlayer.Character:WaitForChild("Head")
-- game.Players.LocalPlayer.Character:WaitForChild("Dodge")
-- game.Players.LocalPlayer.Character:WaitForChild("Skyjump")
-- game.Players.LocalPlayer.Character:WaitForChild("Soru")

repeat
    wait()
until game:GetService('Players').LocalPlayer
repeat
    wait()
until game:GetService('Players').LocalPlayer.Character
repeat
    wait()
until game:GetService('Players').LocalPlayer.Character:WaitForChild("Head")
repeat
    wait()
until game:GetService('Players').LocalPlayer:FindFirstChild("PlayerGui");
repeat
    wait()
until game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild("Main");

if not (game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635) then
    return
end

local HeeMenGui = {}

local function tempDestroy()
    Drawing.clear()
    if HeeMenGui.Events then
        for k, v in pairs(HeeMenGui.Events) do
            v:Disconnect()
        end
    end

    for i, v in pairs(game:GetService("Players"):GetChildren()) do
        if v.Character then
            if v.Character:FindFirstChild("Head") then
                if v.Character.Head:FindFirstChild('NameEsp') then
                    v.Character.Head:FindFirstChild('NameEsp'):Destroy()
                end
                if v.Character.Head:FindFirstChild('InfoEsp') then
                    v.Character.Head:FindFirstChild('InfoEsp'):Destroy()
                end
            end
        end
    end
end

if getgenv().HeeMenGui then
    HeeMenGui = getgenv().HeeMenGui
    HeeMenGui.Destroy = tempDestroy
    HeeMenGui.Destroy()
end

HeeMenGui = nil
getgenv().HeeMenGui = nil

wait(1)

HeeMenGui = {}
HeeMenGui.Config = {
    GuiName = "HeeMenGui",
    Show = true,
    Dragable = false,
    LastUiPosition = nil,
    FruitFinderHop = false,
    AimBot = false
}
HeeMenGui.Destroy = tempDestroy
HeeMenGui.Name = tostring(HeeMenGui.Config.GuiName)
HeeMenGui.ScreenGui = game.CoreGui:FindFirstChild(HeeMenGui.Name)
HeeMenGui.CombatScreenGui = game.CoreGui:FindFirstChild("CombatScreenGui")
HeeMenGui.Mouse = game:GetService("Players").LocalPlayer:GetMouse()
HeeMenGui.OnCombat = false
HeeMenGui.LoadingAbilities = false
HeeMenGui.FruitExists = false
HeeMenGui.FruitFinderHopCountDown = 50
HeeMenGui.UI = {}
HeeMenGui.Print = function(message)
    if type(message) == "string" then
        print(string.format('[%s] %s', HeeMenGui.Name, message))
    elseif type(message) == "table" then
        print(string.format('[%s] %s', HeeMenGui.Name, type(message)))
        for k, v in pairs(message) do
            print(string.format('    %s - %s', k, type(v)))
        end
    else
        print(string.format('[%s] %s', HeeMenGui.Name, type(message)))
    end
end
HeeMenGui.LoadConfig = function()
    -- assert(FileName or FileName == "string", "oopsies");    
    local File = string.format("HeeMenGui/%s.json", game.Players.LocalPlayer.Name)
    if isfile(File) then
        local ConfigData = game:GetService("HttpService"):JSONDecode(readfile(File))
        for Index, Value in next, ConfigData do
            HeeMenGui.Config[Index] = Value
        end
    end
end
HeeMenGui.SaveConfig = function()
    if not isfolder("HeeMenGui") then
        makefolder("HeeMenGui");
    end

    HeeMenGui.Print(HeeMenGui.Config)
    local File = string.format("HeeMenGui/%s.json", game.Players.LocalPlayer.Name)
    HeeMenGui.Print(File)
    writefile(File, game:GetService("HttpService"):JSONEncode(HeeMenGui.Config))
end
HeeMenGui.StringToUDim2 = function(value)
    value = string.gsub(value, "{", "")
    value = string.gsub(value, "}", "")
    value = string.gsub(value, " ", "")
    return UDim2.new(table.unpack(string.split(value, ",")))
end
HeeMenGui.Load = function(name)
    if name then
        HeeMenGui.Name = name
        HeeMenGui.Config.GuiName = name
    end

    if HeeMenGui.ScreenGui then
        HeeMenGui.ScreenGui:Destroy()
    end

    wait(1)

    if HeeMenGui.Config.LastUiPosition then
        HeeMenGui.UI.LastUiPosition = HeeMenGui.StringToUDim2(HeeMenGui.Config.LastUiPosition)
    else
        HeeMenGui.UI.LastUiPosition = UDim2.new(0, 300, 0, -35)
    end

    HeeMenGui.ScreenGui = Instance.new("ScreenGui")
    HeeMenGui.ScreenGui.Name = HeeMenGui.Name
    HeeMenGui.ScreenGui.Parent = game.CoreGui

    HeeMenGui.UI.Main = Instance.new("Frame")
    HeeMenGui.UI.Main.Name = "Main"
    HeeMenGui.UI.Main.Parent = HeeMenGui.ScreenGui
    HeeMenGui.UI.Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    HeeMenGui.UI.Main.ClipsDescendants = true
    HeeMenGui.UI.Main.Position = HeeMenGui.UI.LastUiPosition
    HeeMenGui.UI.Main.Size = UDim2.new(1, -600, 0, 30)
    HeeMenGui.UI.Main.BorderSizePixel = 3
    HeeMenGui.UI.Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    -- Main.Enabled = false

    HeeMenGui.UI.MainUICorner = Instance.new("UICorner")
    HeeMenGui.UI.MainUICorner.Name = "MainUICorner"
    HeeMenGui.UI.MainUICorner.Parent = HeeMenGui.UI.Main

    HeeMenGui.UI.TopMain = Instance.new("Frame")
    HeeMenGui.UI.TopMain.Name = "TopMain"
    HeeMenGui.UI.TopMain.Parent = HeeMenGui.UI.Main
    HeeMenGui.UI.TopMain.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    HeeMenGui.UI.TopMain.Size = UDim2.new(1, 0, 0, 30)

    -- MakeDraggable(TopMain, Main)

    HeeMenGui.UI.TopMainUICorner = Instance.new("UICorner")
    HeeMenGui.UI.TopMainUICorner.Name = "TopMainUICorner"
    HeeMenGui.UI.TopMainUICorner.Parent = HeeMenGui.UI.TopMain

    HeeMenGui.UI.TopMainLine = Instance.new("Frame")
    HeeMenGui.UI.TopMainLine.Name = "TopMainLine"
    HeeMenGui.UI.TopMainLine.Parent = HeeMenGui.UI.TopMain
    HeeMenGui.UI.TopMainLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    HeeMenGui.UI.TopMainLine.BorderSizePixel = 0
    HeeMenGui.UI.TopMainLine.Position = UDim2.new(0, 0, 0.833333313, 0)
    HeeMenGui.UI.TopMainLine.Size = UDim2.new(1, 0, 0, 5)

    HeeMenGui.UI.ShowName = Instance.new("TextLabel")
    HeeMenGui.UI.ShowName.Name = "ShowName"
    HeeMenGui.UI.ShowName.Parent = HeeMenGui.UI.TopMain
    HeeMenGui.UI.ShowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeeMenGui.UI.ShowName.BackgroundTransparency = 1
    HeeMenGui.UI.ShowName.Position = UDim2.new(0, 0, 0, 0)
    HeeMenGui.UI.ShowName.Size = UDim2.new(1, 0, 0, 30)
    HeeMenGui.UI.ShowName.Font = Enum.Font.SourceSansSemibold
    HeeMenGui.UI.ShowName.RichText = true
    HeeMenGui.UI.ShowName.Text = game:GetService("Players").LocalPlayer.Name
    HeeMenGui.UI.ShowName.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeeMenGui.UI.ShowName.TextSize = 20.000
    HeeMenGui.UI.ShowName.Text = HeeMenGui.Name

    HeeMenGui.UI.ToggleButton = Instance.new("Frame")
    HeeMenGui.UI.ToggleButton.Name = "ToggleButton"
    HeeMenGui.UI.ToggleButton.Parent = HeeMenGui.UI.TopMain
    HeeMenGui.UI.ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    HeeMenGui.UI.ToggleButton.Position = UDim2.new(1, -50, 0, 5)
    HeeMenGui.UI.ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    HeeMenGui.UI.ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    HeeMenGui.UI.ToggleButton.BackgroundTransparency = 0
    HeeMenGui.UI.ToggleButton.BorderSizePixel = 2;
    HeeMenGui.UI.ToggleButton.BorderMode = Enum.BorderMode.Inset;

    HeeMenGui.UI.InnerToggleButton = Instance.new("Frame")
    HeeMenGui.UI.InnerToggleButton.Name = "InnerToggleButton"
    HeeMenGui.UI.InnerToggleButton.Parent = HeeMenGui.UI.ToggleButton
    HeeMenGui.UI.InnerToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeeMenGui.UI.InnerToggleButton.Position = UDim2.new(0, 2, 0, 2)
    HeeMenGui.UI.InnerToggleButton.BorderColor3 = Color3.new(0, 0, 0);
    HeeMenGui.UI.InnerToggleButton.Size = UDim2.new(0, 12, 0, 12)
    HeeMenGui.UI.InnerToggleButton.BackgroundTransparency = 1
    HeeMenGui.UI.InnerToggleButton.BorderSizePixel = 0

    if HeeMenGui.Config.isDock then
        HeeMenGui.UI.Main.Position = UDim2.new(0, 300, 0, -35)
        HeeMenGui.UI.InnerToggleButton.BackgroundTransparency = 0
    end

    HeeMenGui.UI.ToggleButton.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            HeeMenGui.Config.isDock = not HeeMenGui.Config.isDock
            if HeeMenGui.Config.isDock then
                HeeMenGui.UI.InnerToggleButton.BackgroundTransparency = 0
                HeeMenGui.UI.Main.Position = UDim2.new(0, 300, 0, -35) -- .204, .687
            else
                HeeMenGui.UI.InnerToggleButton.BackgroundTransparency = 1
                HeeMenGui.UI.Main.Position = HeeMenGui.UI.LastUiPosition
            end
            HeeMenGui.SaveConfig()
        end
    end)

    HeeMenGui.UI.FruitFinderHop = Instance.new("Frame")
    HeeMenGui.UI.FruitFinderHop.Name = "FruitFinderHop"
    HeeMenGui.UI.FruitFinderHop.Parent = HeeMenGui.UI.TopMain
    HeeMenGui.UI.FruitFinderHop.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    HeeMenGui.UI.FruitFinderHop.Position = UDim2.new(0, 50, 0, 5)
    HeeMenGui.UI.FruitFinderHop.BorderColor3 = Color3.fromRGB(255, 255, 255)
    HeeMenGui.UI.FruitFinderHop.Size = UDim2.new(0, 20, 0, 20)
    HeeMenGui.UI.FruitFinderHop.BackgroundTransparency = 0
    HeeMenGui.UI.FruitFinderHop.BorderSizePixel = 2;
    HeeMenGui.UI.FruitFinderHop.BorderMode = Enum.BorderMode.Inset;

    HeeMenGui.UI.InnerFruitFinderHop = Instance.new("Frame")
    HeeMenGui.UI.InnerFruitFinderHop.Name = "InnerFruitFinderHop"
    HeeMenGui.UI.InnerFruitFinderHop.Parent = HeeMenGui.UI.FruitFinderHop
    HeeMenGui.UI.InnerFruitFinderHop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeeMenGui.UI.InnerFruitFinderHop.Position = UDim2.new(0, 2, 0, 2)
    HeeMenGui.UI.InnerFruitFinderHop.BorderColor3 = Color3.new(0, 0, 0);
    HeeMenGui.UI.InnerFruitFinderHop.Size = UDim2.new(0, 12, 0, 12)
    HeeMenGui.UI.InnerFruitFinderHop.BackgroundTransparency = 1
    HeeMenGui.UI.InnerFruitFinderHop.BorderSizePixel = 0

    if HeeMenGui.Config.FruitFinderHop then
        HeeMenGui.UI.InnerFruitFinderHop.BackgroundTransparency = 0
    end

    HeeMenGui.UI.FruitFinderHop.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            HeeMenGui.Config.FruitFinderHop = not HeeMenGui.Config.FruitFinderHop
            if HeeMenGui.Config.FruitFinderHop then
                HeeMenGui.FruitFinderHopCountDown = 50
                HeeMenGui.FruitExists = false
                HeeMenGui.UI.InnerFruitFinderHop.BackgroundTransparency = 0
            else
                HeeMenGui.UI.InnerFruitFinderHop.BackgroundTransparency = 1
            end
            HeeMenGui.SaveConfig()
        end
    end)

    HeeMenGui.UI.CloseButton = Instance.new("ImageButton")
    HeeMenGui.UI.CloseButton.Name = "close"
    HeeMenGui.UI.CloseButton.Parent = HeeMenGui.UI.TopMain
    HeeMenGui.UI.CloseButton.BackgroundTransparency = 1.000
    HeeMenGui.UI.CloseButton.Position = UDim2.new(1, -27, 0, 3)
    HeeMenGui.UI.CloseButton.Size = UDim2.new(0, 24, 0, 24)
    HeeMenGui.UI.CloseButton.ZIndex = 2
    HeeMenGui.UI.CloseButton.Image = "rbxassetid://3926305904"
    HeeMenGui.UI.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    HeeMenGui.UI.CloseButton.ImageRectSize = Vector2.new(24, 24)
    HeeMenGui.UI.CloseButton.MouseButton1Click:Connect(function()
        -- game.TweenService:Create(close, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        --     ImageTransparency = 1
        -- }):Play()
        -- wait()
        -- game.TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        -- 	Size = UDim2.new(0,0,0,0),
        -- 	Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        -- }):Play()
        -- wait(1)
        HeeMenGui.ScreenGui:Destroy()
        HeeMenGui.Destroy()
    end)

    HeeMenGui.UI.Dragging = nil
    HeeMenGui.UI.DragInput = nil
    HeeMenGui.UI.DragStart = nil
    HeeMenGui.UI.StartPosition = nil
    HeeMenGui.UI.TopMain.InputBegan:Connect(function(input)
        if not HeeMenGui.Config.isDock and
            (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            HeeMenGui.UI.Dragging = true
            HeeMenGui.UI.DragStart = input.Position
            HeeMenGui.UI.StartPosition = HeeMenGui.UI.Main.Position
            -- ShowName.Text = tostring(Main.Position)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    HeeMenGui.UI.Dragging = false
                end
            end)
        end
    end)

    HeeMenGui.UI.TopMain.InputChanged:Connect(function(input)
        if not HeeMenGui.Config.isDock and
            (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            HeeMenGui.UI.DragInput = input
        end
    end)

    HeeMenGui.ScreenGui.Enabled = HeeMenGui.Config.Show

    HeeMenGui.FOV_CIRCLE = Drawing.new("Circle")
    HeeMenGui.FOV_CIRCLE.Thickness = 4
    HeeMenGui.FOV_CIRCLE.NumSides = 100
    HeeMenGui.FOV_CIRCLE.Radius = 60
    HeeMenGui.FOV_CIRCLE.Filled = false
    HeeMenGui.FOV_CIRCLE.Visible = false
    HeeMenGui.FOV_CIRCLE.ZIndex = 999
    HeeMenGui.FOV_CIRCLE.Transparency = 1
    HeeMenGui.FOV_CIRCLE.Color = Color3.fromRGB(255, 0, 0)
end
HeeMenGui.ShowServerList = function()

    local ServerListGui = game.CoreGui:FindFirstChild("ServerListGui")

    if ServerListGui then
        ServerListGui:Destroy()
    end

    if not ServerListGui then
        ServerListGui = Instance.new("ScreenGui")
        ServerListGui.Name = "ServerListGui"
        ServerListGui.Parent = game.CoreGui
    end

    local Main = ServerListGui:FindFirstChild("Main")
    if not Main then
        Main = Instance.new("Frame")
        Main.Name = "Main"
        Main.Parent = ServerListGui
        Main.BackgroundTransparency = 0
        Main.ClipsDescendants = true
        Main.Position = UDim2.new(0, 0, 0, 0)
        Main.Size = UDim2.new(1, 0, 1, 0)
    end

    -- local FuitInfo = Main:FindFirstChild("FuitInfo")
    -- if not FuitInfo then
    --     FuitInfo = Instance.new("TextLabel")
    --     FuitInfo.Name = "FuitInfo"
    --     FuitInfo.Parent = Main
    --     FuitInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    --     FuitInfo.BackgroundTransparency = 1
    --     FuitInfo.Position = UDim2.new(0, 0, 0, 0)
    --     FuitInfo.Size = UDim2.new(1, 1, 1, 1)
    --     FuitInfo.Font = Enum.Font.DenkOne
    --     FuitInfo.RichText = true
    --     FuitInfo.Text = "N/A"
    --     FuitInfo.TextColor3 = Color3.fromRGB(255, 0, 0)
    --     FuitInfo.TextSize = 20
    --     FuitInfo.TextXAlignment = Enum.TextXAlignment.Center
    --     FuitInfo.TextYAlignment = Enum.TextYAlignment.Top
    --     FuitInfo.TextStrokeTransparency = 0.5
    -- end
end
HeeMenGui.GetMousePosition = function()
    -- return GetMouseLocation(UserInputService)
    return game:GetService('UserInputService'):GetMouseLocation()
end
HeeMenGui.NumFormat = function(value, point)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    right = string.gsub(right, "%.", "")
    right = tonumber(right)
    point = tonumber(point)
    if point == nil then
        if right then
            right = "." .. right
        else
            right = ""
        end
    else
        if right then
            right = string.sub(right, 1, point)
        else
            right = ""
        end
        if string.len(right) < point then
            right = right .. string.rep("0", point - string.len(right))
        end
        if not (point == 0) then
            right = "." .. right
        end
    end

    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. tostring(right)
end
HeeMenGui.GetPositionOnScreen = function(Vector)
    local Camera = workspace.CurrentCamera
    local Vec3, OnScreen = Camera.WorldToScreenPoint(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end
HeeMenGui.GetPlayerDistance = function(target)
    local distance = 0
    local real_distance = 0

    if target.Character then
        if target.Character:FindFirstChild("Head") then
            local lpHead = game:GetService('Players').LocalPlayer.Character.Head
            local tpHead = target.Character.Head
            distance = math.floor((lpHead.Position - tpHead.Position).Magnitude / 3)
            real_distance = math.floor((lpHead.Position - tpHead.Position).Magnitude / 3)
            distance = math.floor(distance / 100)
            if distance < 10 then
                distance = 109 - distance
            elseif distance > 100 then
                distance = 0
            else
                distance = 100 - distance
            end
            local base_distance = math.floor(distance / 10) + 5
            local sub_distance = math.floor(distance / 100) * math.fmod(distance, 100)
            distance = math.floor((base_distance + sub_distance) * 2)

        end
    end

    return real_distance, distance
end
HeeMenGui.GetClosestPlayer = function(isCombat)
    local targetPlayer = nil
    local onCombatPlayer = nil
    local combatDistance = 360
    local targetDistance = 100
    for k, v in pairs(game:GetService("Players"):GetChildren()) do
        if not (v.Name == game:GetService("Players").LocalPlayer.Name) then
            if v.Character then
                local HumanoidRootPart = game.FindFirstChild(v.Character, "HumanoidRootPart")
                local Humanoid = game.FindFirstChild(v.Character, "Humanoid")
                if HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
                    local ScreenPosition, OnScreen = HeeMenGui.GetPositionOnScreen(HumanoidRootPart.Position)
                    if OnScreen then
                        local Distance = (HeeMenGui.GetMousePosition() - ScreenPosition).Magnitude
                        local real_distance, range = HeeMenGui.GetPlayerDistance(v)
                        if Distance <= combatDistance and real_distance <= 200 then
                            onCombatPlayer = v
                            combatDistance = Distance
                        end
                        if Distance <= targetDistance then
                            targetPlayer = v
                            targetDistance = Distance
                        end
                        -- if Distance <= DistanceToMouse and real_distance <= 200 then
                        --     onCombatPlayer = v
                        --     DistanceToMouse = Distance
                        -- end
                    end
                end
            end
        end
    end

    if isCombat then
        return onCombatPlayer
    elseif onCombatPlayer then
        return onCombatPlayer
    else
        return targetPlayer
    end
end
HeeMenGui.PlayerEsp = function()
    if not HeeMenGui.Config.AimBot then
        for i, v in pairs(game:GetService("Players"):GetChildren()) do
            if v.Character then
                if v.Character:FindFirstChild("Head") then
                    if v.Character.Head:FindFirstChild('NameEsp') then
                        v.Character.Head:FindFirstChild('NameEsp'):Destroy()
                    end
                    -- if v.Character.Head:FindFirstChild('InfoEsp') then
                    --     v.Character.Head:FindFirstChild('InfoEsp'):Destroy()
                    -- end
                end
            end
        end

        return
    end

    for i, v in pairs(game:GetService("Players"):GetChildren()) do
        if not (v.Name == game:GetService("Players").LocalPlayer.Name) then
            if v.Character then
                if v.Character:FindFirstChild("Head") then
                    if v.Character.Head:FindFirstChild('NameEsp') then
                        local distance, range = HeeMenGui.GetPlayerDistance(v)
                        local TextNameEsp = v.Character.Head['NameEsp']:FindFirstChild("TextNameEsp")
                        -- local TextInfoEsp = v.Character.Head['InfoEsp'].TextLabel
                        local TextInfoEsp = v.Character.Head['NameEsp']:FindFirstChild("TextInfoEsp")
                        TextNameEsp.TextColor3 = Color3.new(255, 255, 255)
                        TextNameEsp.TextColor3 = Color3.new(255, 255, 255)
                        TextNameEsp.TextSize = range
                        -- if v.Team == game.Players.LocalPlayer.Team then
                        -- 	v.Character.Head['NameEsp'].TextLabel.TextColor3 = Color3.new(0, 127, 255)
                        -- 	v.Character.Head['InfoEsp'].TextLabel.TextColor3 = Color3.new(0, 127, 255)
                        -- end
                        -- v.Character.Head['NameEsp'].Size = UDim2.new(0, 200, 0, range)
                        -- v.Character.Head['InfoEsp'].Size = UDim2.new(0, 200, 0, (range + 20))
                        -- v.Character.Head['NameEsp'].TextLabel.ZIndex = 1
                        -- v.Character.Head['InfoEsp'].TextLabel.ZIndex = 1
                        local cHealth = v.Character.Humanoid.Health or 0
                        local mHealth = v.Character.Humanoid.MaxHealth or 1
                        TextNameEsp.Text = tostring(math.floor(cHealth * 100 / mHealth)) .. '%'

                        TextInfoEsp.Text = v.Name .. "\n"
                        TextInfoEsp.Text = TextInfoEsp.Text .. tostring(distance) .. "m\n"
                        TextInfoEsp.Text = TextInfoEsp.Text .. v.Data.LastSpawnPoint.Value

                        -- if targetLock then
                        -- 	if targetLock.Name == v.Name and distance > 400 then
                        -- 		targetLock = nil
                        -- 	end
                        -- end
                        -- v.Character.Head['InfoEsp'].Size = UDim2.new(0, 400, 0, 80)
                        -- v.Character.Head['InfoEsp'].TextLabel.TextSize = 14
                        -- v.Character.Head['InfoEsp'].TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
                        -- v.Character.Head['InfoEsp'].TextLabel.BackgroundTransparency = 1
                    else
                        local bill = Instance.new('BillboardGui', v.Character.Head)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(0, 200, 0, 100)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true
                        local health = Instance.new('TextLabel')
                        -- health.Font = "Roboto"
                        health.Font = Enum.Font.DenkOne
                        -- health.TextScaled = true
                        -- health.FontSize = "Size14"
                        health.Name = "TextNameEsp"
                        health.Parent = bill
                        health.TextSize = 14
                        health.TextWrapped = true
                        health.Text = v.Name
                        health.Size = UDim2.new(1, 0, 0, 50)
                        health.Position = UDim2.new(0, 0, 0, 0)
                        health.TextYAlignment = Enum.TextYAlignment.Bottom
                        health.TextXAlignment = Enum.TextXAlignment.Center
                        health.BackgroundTransparency = 1
                        health.TextStrokeTransparency = 0.5
                        health.TextColor3 = Color3.new(255, 255, 255)
                        health.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        health.ZIndex = 999

                        -- local bill2 = Instance.new('BillboardGui', v.Character.Head)
                        -- bill2.Name = 'InfoEsp'
                        -- bill2.ExtentsOffset = Vector3.new(0, 1, 0)
                        -- bill2.Size = UDim2.new(0, 400, 0, 160)
                        -- bill2.Adornee = v.Character.Head
                        -- bill2.AlwaysOnTop = true
                        local info = Instance.new('TextLabel')
                        info.Font = Enum.Font.DenkOne
                        info.Name = 'TextInfoEsp'
                        info.Parent = bill
                        -- info.FontSize = Enum.FontSize.Size14
                        info.TextSize = 14
                        info.Text = v.Name
                        info.Position = UDim2.new(0, 0, 0, 50)
                        info.Size = UDim2.new(1, 0, 1, 0)
                        info.TextYAlignment = Enum.TextYAlignment.Top
                        info.TextXAlignment = Enum.TextXAlignment.Center
                        info.BackgroundTransparency = 1
                        info.TextStrokeTransparency = 0.5
                        info.TextColor3 = Color3.new(255, 255, 255)
                        info.ZIndex = 998
                    end
                end
            end
        end
    end
end
HeeMenGui.FruitEsp = function()
    for i, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") then
            local fruitMesh = ""
            if v.Name == "Fruit " then
                for j, w in pairs(v:GetChildren()) do
                    if string.find(w.Name, "Meshes") then
                        fruitMesh = w.Name .. ' - '
                        break
                    end
                end
            end
            local fruitDistance = math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position -
                                                 v.Handle.Position).Magnitude / 3)
            if not v.Handle:FindFirstChild('NameEsp') then
                local bill = Instance.new('BillboardGui', v.Handle)
                bill.Name = 'NameEsp'
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1, 400, 1, 60)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel', bill)
                name.Font = "GothamBold"
                name.FontSize = Enum.FontSize.Size18
                name.TextWrapped = true
                name.Size = UDim2.new(1, 0, 1, 0)
                name.TextYAlignment = Enum.TextYAlignment.Bottom
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(255, 0, 0)
                name.Text = (v.Name .. '\n' .. fruitMesh .. fruitDistance .. ' M')
            else
                v.Handle['NameEsp'].TextLabel.Text = (v.Name .. '\n' .. fruitMesh .. fruitDistance .. ' M')
            end
        end
    end
end
HeeMenGui.HopLowPlayer = function()
    local url = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
    local Site = nil
	Site = game.HttpService:JSONDecode(game:HttpGet(url))
	Site = game.HttpService:JSONDecode(game:HttpGet(url .. "&cursor=" .. Site.nextPageCursor))
	Site = game.HttpService:JSONDecode(game:HttpGet(url .. "&cursor=" .. Site.nextPageCursor))
    -- setclipboard('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
    -- https://games.roblox.com/v1/games/7449423635/servers/Public?sortOrder=Asc&limit=100
    -- Site.nextPageCursor
    local selectIndex = math.random(4, 9)
    local skipCount = 0
    for i, v in pairs(Site.data) do
        if v.playing then
            skipCount = skipCount + 1
        end
        if skipCount == selectIndex then
            -- game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport', v.id)
			print(v.id)
			print(v.playing)
			wait(3)
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
            break
        end
    end
end
HeeMenGui.LoadFruitFinderHop = function()

    local fruitFullInfo = ""

    for i, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") then
            local fruitMesh = ""
            if v.Name == "Fruit " then
                for j, w in pairs(v:GetChildren()) do
                    if string.find(w.Name, "Meshes") then
                        fruitMesh = w.Name .. ' - '
                    end
                    fruitFullInfo = fruitFullInfo .. w.Name .. "\n"
                end
                if fruitMesh == "" then
                    for j, w in pairs(v.Fruit:GetChildren()) do
                        fruitFullInfo = fruitFullInfo .. w.Name .. "\n"
                    end
                    HeeMenGui.FruitExists = true
                end
            end
            local fruitDistance = math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position -
                                                 v.Handle.Position).Magnitude / 3)
            if not v.Handle:FindFirstChild('NameEsp') then
                local bill = Instance.new('BillboardGui', v.Handle)
                bill.Name = 'NameEsp'
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1, 400, 1, 60)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel', bill)
                name.Font = "GothamBold"
                name.FontSize = Enum.FontSize.Size18
                name.TextWrapped = true
                name.Size = UDim2.new(1, 0, 1, 0)
                name.TextYAlignment = Enum.TextYAlignment.Bottom
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(255, 0, 0)
                name.Text = (v.Name .. '\n' .. fruitMesh .. fruitDistance .. ' M')
            else
                v.Handle['NameEsp'].TextLabel.Text = (v.Name .. '\n' .. fruitMesh .. fruitDistance .. ' M')
            end
        end
    end

    if HeeMenGui.Config.FruitFinderHop and not HeeMenGui.FruitExists then
        fruitFullInfo = "N/A\nHopping in " .. HeeMenGui.NumFormat(HeeMenGui.FruitFinderHopCountDown / 10, 1)
    end

    local FruitInfoGui = game.CoreGui:FindFirstChild("FruitInfoGui")
    if HeeMenGui.FruitExists or HeeMenGui.Config.FruitFinderHop then
        if not FruitInfoGui then
            FruitInfoGui = Instance.new("ScreenGui")
            FruitInfoGui.Name = "FruitInfoGui"
            FruitInfoGui.Parent = game.CoreGui
        end

        local Main = FruitInfoGui:FindFirstChild("Main")
        if not Main then
            Main = Instance.new("Frame")
            Main.Name = "Main"
            Main.Parent = FruitInfoGui
            Main.BackgroundTransparency = 1
            Main.ClipsDescendants = true
            Main.Position = UDim2.new(0, 0, 0, 0)
            Main.Size = UDim2.new(1, 0, 1, 0)
        end

        local FuitInfo = Main:FindFirstChild("FuitInfo")
        if not FuitInfo then
            FuitInfo = Instance.new("TextLabel")
            FuitInfo.Name = "FuitInfo"
            FuitInfo.Parent = Main
            FuitInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            FuitInfo.BackgroundTransparency = 1
            FuitInfo.Position = UDim2.new(0, 0, 0, 0)
            FuitInfo.Size = UDim2.new(1, 1, 1, 1)
            FuitInfo.Font = Enum.Font.DenkOne
            FuitInfo.RichText = true
            FuitInfo.Text = ""
            FuitInfo.TextColor3 = Color3.fromRGB(255, 0, 0)
            FuitInfo.TextSize = 20
            FuitInfo.TextXAlignment = Enum.TextXAlignment.Center
            FuitInfo.TextYAlignment = Enum.TextYAlignment.Top
            FuitInfo.TextStrokeTransparency = 0.5
        end

        FuitInfo.Text = fruitFullInfo
    elseif FruitInfoGui then
        FruitInfoGui:Destroy()
    end

end
HeeMenGui.LoadAbilities = function()
    HeeMenGui.LoadingAbilities = true

    game.Players.LocalPlayer.Character:WaitForChild("Dodge")
    game.Players.LocalPlayer.Character:WaitForChild("Skyjump")
    game.Players.LocalPlayer.Character:WaitForChild("Soru")
    HeeMenGui.FnDodge = nil
    HeeMenGui.FnGeppo = nil
    HeeMenGui.FnSoru = nil
    for i, v in pairs(getgc()) do
        if not HeeMenGui.FnDodge and type(v) == "function" and getfenv(v).script ==
            game.Players.LocalPlayer.Character.Dodge then
            local info = getinfo(v)
            if info and info.nups == 18 and info.what == "Lua" then
                HeeMenGui.FnDodge = v
            end
        elseif not HeeMenGui.FnGeppo and type(v) == "function" and getfenv(v).script ==
            game.Players.LocalPlayer.Character.Skyjump then
            local info = getinfo(v)
            if info and info.nups == 12 and info.what == "Lua" then
                HeeMenGui.FnGeppo = v
            end
        elseif not fnSoru and type(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Soru then
            local info = getinfo(v)
            if info and info.nups == 11 and info.what == "Lua" then
                HeeMenGui.FnSoru = v
            end
        end

        if HeeMenGui.FnDodge and HeeMenGui.FnGeppo and HeeMenGui.FnSoru then
            break
        end
    end

    HeeMenGui.LoadingAbilities = false
end
HeeMenGui.LoadCombatScreenGui = function()

    -- game.CoreGui:FindFirstChild("CombatScreenGui")
    -- local ScreenGui = HeeMenGui.CombatScreenGui

    if HeeMenGui.OnCombat then
        -- ScreenGui:Destroy()
        if not HeeMenGui.CombatScreenGui then
            HeeMenGui.CombatScreenGui = Instance.new("ScreenGui")
            HeeMenGui.CombatScreenGui.Name = "CombatScreenGui"
            HeeMenGui.CombatScreenGui.Parent = game.CoreGui
        end

        local Main = HeeMenGui.CombatScreenGui:FindFirstChild("Main")
        if not Main then
            Main = Instance.new("Frame")
            Main.Name = "Main"
            Main.Parent = HeeMenGui.CombatScreenGui
            Main.BackgroundTransparency = 1
            Main.ClipsDescendants = true
            Main.Position = UDim2.new(0, 0, 0, 0)
            Main.Size = UDim2.new(1, 0, 1, 0)
        end

        local myBounty = Main:FindFirstChild("MyBounty")
        if not myBounty then
            myBounty = Instance.new("TextLabel")
            myBounty.Name = "MyBounty"
            myBounty.Parent = Main
            myBounty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            myBounty.BackgroundTransparency = 1
            myBounty.Position = UDim2.new(0, 0, 0, -75)
            myBounty.Size = UDim2.new(1, 1, 1, 1)
            myBounty.Font = Enum.Font.DenkOne
            myBounty.RichText = true
            myBounty.TextColor3 = Color3.fromRGB(255, 255, 255)
            myBounty.TextSize = 40
            myBounty.TextXAlignment = Enum.TextXAlignment.Center
            myBounty.TextYAlignment = Enum.TextYAlignment.Bottom
            myBounty.TextStrokeTransparency = 0.5
        end

        myBounty.Text = HeeMenGui.NumFormat(game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value)
    elseif HeeMenGui.CombatScreenGui then
        HeeMenGui.CombatScreenGui:Destroy()
        HeeMenGui.CombatScreenGui = nil
    end

    -- local PlayerInfo = Instance.new("Frame")
    -- PlayerInfo.Name = "PlayerInfoMain"
    -- PlayerInfo.Parent = CustomAimbotGui
    -- PlayerInfo.BackgroundTransparency = 1
    -- PlayerInfo.ClipsDescendants = true
    -- PlayerInfo.Position = UDim2.new(0.202, 0, 0.70, 0)
    -- PlayerInfo.Size = UDim2.new(0, 400, 0, 316)

    -- local ShowName = Instance.new("TextLabel")
    -- ShowName.Name = "TargetName"
    -- ShowName.Parent = Main
    -- ShowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    -- ShowName.BackgroundTransparency = 1
    -- ShowName.Position = UDim2.new(0, 0, 0, 24)
    -- ShowName.Size = UDim2.new(1, 1, 1, 1)
    -- ShowName.Font = Enum.Font.DenkOne
    -- ShowName.RichText = true
    -- ShowName.Text = 'N/A'
    -- ShowName.TextColor3 = Color3.fromRGB(255, 255, 255)
    -- ShowName.TextSize = 40
    -- ShowName.TextXAlignment = Enum.TextXAlignment.Center
    -- ShowName.TextYAlignment = Enum.TextYAlignment.Top
    -- ShowName.TextStrokeTransparency = 0.5

    -- local targetBounty = Instance.new("TextLabel")
    -- targetBounty.Name = "TargetBounty"
    -- targetBounty.Parent = Main
    -- targetBounty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    -- targetBounty.BackgroundTransparency = 1
    -- targetBounty.Position = UDim2.new(0, 0, 0, 0)
    -- targetBounty.Size = UDim2.new(1, 1, 1, 1)
    -- targetBounty.Font = Enum.Font.DenkOne
    -- targetBounty.RichText = true
    -- targetBounty.Text = "-"
    -- targetBounty.TextColor3 = Color3.fromRGB(255, 255, 255)
    -- targetBounty.TextSize = 26
    -- targetBounty.TextXAlignment = Enum.TextXAlignment.Center
    -- targetBounty.TextYAlignment = Enum.TextYAlignment.Top
    -- targetBounty.TextStrokeTransparency = 0.5
end
HeeMenGui.CombatFunc = function()
    if HeeMenGui.OnCombat then
        if not HeeMenGui.LoadingAbilities then
            if not HeeMenGui.FnDodge or not HeeMenGui.FnGeppo or not HeeMenGui.FnSoru then
                HeeMenGui.LoadAbilities()
            end
        end

        if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end

        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            local minkAgility = game:GetService("ReplicatedStorage").FX.Agility:Clone()
            minkAgility.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end

        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 80
    else
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Agility:Destroy()
        end

        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 60
    end
    HeeMenGui.LoadCombatScreenGui()
end
HeeMenGui.Events = {}
HeeMenGui.Events.InputBegan = game:GetService("UserInputService").InputBegan:Connect(function(io, p)
    if not game:GetService("UserInputService"):GetFocusedTextBox() then
        if io.KeyCode == Enum.KeyCode.F10 then
            HeeMenGui.Config.Show = not HeeMenGui.Config.Show
            HeeMenGui.ScreenGui.Enabled = HeeMenGui.Config.Show
            HeeMenGui.SaveConfig()
        elseif io.KeyCode == Enum.KeyCode.M then
            HeeMenGui.Print(HeeMenGui.Name)
            if HeeMenGui.Config.FruitFinderHop then
                HeeMenGui.HopLowPlayer()
            end
        elseif io.KeyCode == Enum.KeyCode.O then
            HeeMenGui.ShowServerList()
        elseif io.KeyCode == Enum.KeyCode.L then
            HeeMenGui.Config.AimBot = not HeeMenGui.Config.AimBot
            HeeMenGui.SaveConfig()
        elseif io.KeyCode == Enum.KeyCode.B then
            -- if targetPlayer then
            -- 	targetLock = targetPlayer
            -- elseif targetLock then
            -- 	targetLock = nil
            -- end
            -- game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport', game.JobId)
            -- game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId,
            --     game.Players.LocalPlayer)
        elseif io.KeyCode == Enum.KeyCode.J then
            HeeMenGui.OnCombat = not HeeMenGui.OnCombat
            -- if not HeeMenGui.FnDodge or not HeeMenGui.FnGeppo or not HeeMenGui.FnSoru then
            -- 	HeeMenGui.LoadAbilities()
            -- end
        elseif io.KeyCode == Enum.KeyCode.P then
            HeeMenGui.LoadAbilities()
        elseif io.KeyCode == Enum.KeyCode.N then
            HeeMenGui.FruitExists = true
        end
    end
end)
HeeMenGui.Events.InputChanged = game:GetService("UserInputService").InputChanged:Connect(function(input)
    if not HeeMenGui.Config.isDock and input == HeeMenGui.UI.DragInput and HeeMenGui.UI.Dragging then
        local Delta = input.Position - HeeMenGui.UI.DragStart
        local pos = UDim2.new(HeeMenGui.UI.StartPosition.X.Scale, HeeMenGui.UI.StartPosition.X.Offset + Delta.X,
            HeeMenGui.UI.StartPosition.Y.Scale, HeeMenGui.UI.StartPosition.Y.Offset + Delta.Y)
        HeeMenGui.UI.Main.Position = pos
        HeeMenGui.UI.LastUiPosition = HeeMenGui.UI.Main.Position
        HeeMenGui.UI.ShowName.Text = tostring(pos)
        HeeMenGui.Config.LastUiPosition = tostring(HeeMenGui.UI.LastUiPosition)
        HeeMenGui.SaveConfig()
    end
end)
HeeMenGui.Events.Idled = game:GetService("Players").LocalPlayer.Idled:connect(function(character)
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
HeeMenGui.Events.CharacterAdded = game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    wait(2)
    HeeMenGui.LoadAbilities()
end)
HeeMenGui.Events.RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()

    if not HeeMenGui then
        return
    end

    HeeMenGui.PlayerEsp()

    HeeMenGui.FruitEsp()

    HeeMenGui.CombatFunc()

    HeeMenGui.LoadFruitFinderHop()

	if HeeMenGui.FOV_CIRCLE then
		HeeMenGui.FOV_CIRCLE.Visible = false
	end
    local TargetLockGui = game.CoreGui:FindFirstChild("TargetLockGui")
    local target = HeeMenGui.GetClosestPlayer()
    if target and HeeMenGui.Config.AimBot then
        local distance, range = HeeMenGui.GetPlayerDistance(target)
        local TextNameEsp = target.Character.Head['NameEsp']:FindFirstChild("TextNameEsp")
        local TextInfoEsp = target.Character.Head['NameEsp']:FindFirstChild("TextInfoEsp")
        -- TextNameEsp.TextColor3 = Color3.new(255, 0, 0)
        -- TextInfoEsp.TextColor3 = Color3.new(255, 0, 0)
        local cHealth = target.Character.Humanoid.Health or 0
        local mHealth = target.Character.Humanoid.MaxHealth or 1

        local txtInfo = ""
        txtInfo = txtInfo .. "Level: " .. target.Data.Level.Value .. '\n'
        txtInfo = txtInfo .. "Name: " .. target.DisplayName .. '\n'
        txtInfo = txtInfo .. "ID: " .. target.Name .. '\n'
        txtInfo = txtInfo .. "Race: " .. target.Data.Race.Value .. '\n'
        txtInfo = txtInfo .. "Team: " .. tostring(target.Team) .. '\n'
        txtInfo = txtInfo .. "B/H: " .. HeeMenGui.NumFormat(target.leaderstats["Bounty/Honor"].Value) .. '\n'
        txtInfo = txtInfo .. "Distance: " .. distance .. '\n'
        txtInfo = txtInfo .. "Loc: " .. target.Data.LastSpawnPoint.Value .. '\n'

        if distance <= 200 then
            TextNameEsp.Text = ""
            TextInfoEsp.Text = ""
        end
        -- TextNameEsp.Text = tostring(math.floor(cHealth * 100 / mHealth)) .. '-' .. target.DisplayName
        -- TextNameEsp.ZIndex = 999
        -- target.Character.Head['InfoEsp'].TextLabel.ZIndex = 999
        -- HeeMenGui.UI.ShowName.Text = tostring(target.Name) .. " || " .. tostring(distance) .. "M" -- v.Data.LastSpawnPoint.Value
        -- targetBounty.Text = numFormat(target.leaderstats["Bounty/Honor"].Value)

        if not TargetLockGui then
            TargetLockGui = Instance.new("ScreenGui")
            TargetLockGui.Name = "TargetLockGui"
            TargetLockGui.Parent = game.CoreGui
        end

        local Main = TargetLockGui:FindFirstChild("Main")
        if not Main then
            Main = Instance.new("Frame")
            Main.Name = "Main"
            Main.Parent = TargetLockGui
            Main.BackgroundTransparency = 1
            Main.ClipsDescendants = true
            Main.Position = UDim2.new(0, 0, 0, 0)
            Main.Size = UDim2.new(0, 400, 0, 400)
        end

        local HealtInfo = Main:FindFirstChild("TargetHealtInfo")
        if not HealtInfo then
            HealtInfo = Instance.new("TextLabel")
            HealtInfo.Name = "TargetHealtInfo"
            HealtInfo.Parent = Main
            HealtInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HealtInfo.BackgroundTransparency = 1
            HealtInfo.Position = UDim2.new(0, 0, 0, 0)
            HealtInfo.Size = UDim2.new(1, 1, 1, 0)
            HealtInfo.Font = Enum.Font.DenkOne
            HealtInfo.RichText = true
            HealtInfo.Text = ""
            HealtInfo.TextColor3 = Color3.fromRGB(255, 0, 0)
            HealtInfo.TextSize = 40
            HealtInfo.TextXAlignment = Enum.TextXAlignment.Left
            HealtInfo.TextYAlignment = Enum.TextYAlignment.Top
            HealtInfo.TextStrokeTransparency = 0.5
        end

        local ShowInfo = Main:FindFirstChild("PlayerInfo")
        if not ShowInfo then
            ShowInfo = Instance.new("TextLabel")
            ShowInfo.Name = "PlayerInfo"
            ShowInfo.Parent = Main
            ShowInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ShowInfo.BackgroundTransparency = 1
            ShowInfo.Position = UDim2.new(0, 0, 0, healthInfoSize)
            ShowInfo.Size = UDim2.new(1, 1, 1, 1)
            ShowInfo.Font = Enum.Font.DenkOne
            ShowInfo.RichText = true
            ShowInfo.Text = ""
            ShowInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
            ShowInfo.TextSize = 24
            ShowInfo.TextXAlignment = Enum.TextXAlignment.Left
            ShowInfo.TextYAlignment = Enum.TextYAlignment.Top
            ShowInfo.TextStrokeTransparency = 0.5
        end

        if distance <= 200 then
            HealtInfo.Size = UDim2.new(1, 1, 1, 40)
            HealtInfo.Text = tostring(math.floor(cHealth * 100 / mHealth)) .. '%'
            ShowInfo.Position = UDim2.new(0, 0, 0, 40)
        else
            HealtInfo:Destroy()
            ShowInfo.Position = UDim2.new(0, 0, 0, 0)
        end

        ShowInfo.Text = txtInfo

        -- local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Camera, target.Character.Position);
        -- mouse_box.Position = Vector2.new(Vec3.X, Vec3.Y)
        local Camera = workspace.CurrentCamera
        local targetPos = target.Character.Head or target.Character.PrimaryPart
        local Vec3, OnScreen = Camera.WorldToViewportPoint(Camera, targetPos.Position)
        -- Main.Position = Vector2.new(Vec3.X, Vec3.Y)
        -- HeeMenGui.UI.ShowName.Text = tostring(HeeMenGui.GetMousePosition()) .. ' - ' .. tostring(Vec3)
        -- HeeMenGui.FOV_CIRCLE.Radius = 100 - (distance / 2)
        -- if HeeMenGui.FOV_CIRCLE.Radius < 20 then
        -- 	HeeMenGui.FOV_CIRCLE.Radius = 20
        -- end
        local camZ = Vector3.zAxis * Camera.CFrame.Position
        local headZ = Vector3.zAxis * target.Character.Head.Position
        local magnitude = (camZ - headZ).Magnitude
        if magnitude < 4 then
            magnitude = 4
        elseif magnitude > 60 then
            magnitude = 60
        end
        local fovRadius = 100 - ((magnitude - 4) * 80 / 56)
        HeeMenGui.FOV_CIRCLE.Radius = fovRadius
        -- HeeMenGui.UI.ShowName.Text = 'current zoom level: ' .. fovRadius

        if distance <= 200 then
            HeeMenGui.FOV_CIRCLE.Visible = true
            HeeMenGui.FOV_CIRCLE.Position = Vector2.new(Vec3.X, Vec3.Y)
            Main.Position = UDim2.new(0, Vec3.X + 10 + fovRadius, 0, Vec3.Y - 35 - 20)
        else
            local mPos = HeeMenGui.GetMousePosition()
            Main.Position = UDim2.new(0, mPos.X + 20, 0, mPos.Y - 35)
        end

        -- HeeMenGui.UI.ShowName.Text = tostring(Vec3)
    elseif TargetLockGui then
        TargetLockGui:Destroy()
    end

    -- HeeMenGui.FOV_CIRCLE.Visible = true
    -- HeeMenGui.FOV_CIRCLE.Radius = 360
    -- HeeMenGui.FOV_CIRCLE.Position = mPos

    -- if HeeMenGui.FruitFinderHop then
    --     HeeMenGui.UI.ShowName.Text = tostring(HeeMenGui.FruitFinderHopCountDown)
    -- end

    -- HeeMenGui.FOV_CIRCLE.Visible = HeeMenGui.OnCombat
    -- HeeMenGui.FOV_CIRCLE.Position = HeeMenGui.GetMousePosition()

    -- HeeMenGui.UI.ShowName.Text = tostring(HeeMenGui.GetMousePosition())

	if HeeMenGui.UI.ShowName then
		HeeMenGui.UI.ShowName.Text = tostring(HeeMenGui.Config.AimBot)
	end

end)
HeeMenGui.HookMetaMethod = function(fn, self, Index)
    -- if tostring(self) == "deviceEvent" then
    -- 	getHookIndex(tostring(self))
    -- end
    -- if Index == "KeyCode" then
    -- 	-- getHookIndex(self)
    -- else
    -- if Index == "UserInputType" and self.KeyCode == Enum.KeyCode.R then
    -- 	-- getHookIndex(self.KeyCode == Enum.KeyCode.R)
    -- 	isBlink = true
    -- 	-- getHookIndex(self.KeyCode)
    -- 	-- return oldIndex(self, Index)
    -- 	-- getHookIndex(self, Index)
    -- else
    if self == HeeMenGui.Mouse and HeeMenGui.Config.AimBot then
        -- getHookIndex(self)
        local target = HeeMenGui.GetClosestPlayer(true)
        if not checkcaller() and target then
            -- local HitPart = target.Character.HumanoidRootPart
            local HitPart = target.Character.Head
            if Index == "Target" or Index == "target" then
                return HitPart
            elseif Index == "Hit" or Index == "hit" then
                -- getHookIndex(Index)
                -- if isBlink then
                -- isBlink = false
                -- 	return oldIndex(self, Index)
                -- else
                -- HeeMenGui.Print(Index)
                return HitPart.CFrame + (HitPart.Velocity * 0.2)
                -- end
            elseif Index == "X" or Index == "x" then
                return self.X
            elseif Index == "Y" or Index == "y" then
                return self.Y
            elseif Index == "UnitRay" then
                return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
            end
        end
    end

    return fn(self, Index)
end

-- HeeMenGui.__index = HeeMenGui

HeeMenGui.LoadConfig()

HeeMenGui.Load()

-- HeeMenGui.UI.ShowName.Text = tostring(HeeMenGui.Config.AimBot)
-- HeeMenGui.LoadAbilities()

if game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
    HeeMenGui.OnCombat = true
end

getgenv().HeeMenGui = HeeMenGui

if not getgenv().HeeMenGuiHookMetaMethod then
    getgenv().HeeMenGuiHookMetaMethod = hookmetamethod(game, "__index", newcclosure(function(self, Index)
        if getgenv().HeeMenGui then
            if getgenv().HeeMenGui.HookMetaMethod then
                return getgenv().HeeMenGui.HookMetaMethod(getgenv().HeeMenGuiHookMetaMethod, self, Index)
            end
        end

        return getgenv().HeeMenGuiHookMetaMethod(self, Index)
        -- if tostring(self) == "deviceEvent" then
        -- 	getHookIndex(tostring(self))
        -- end
        -- if Index == "KeyCode" then
        -- 	-- getHookIndex(self)
        -- else
        -- if Index == "UserInputType" and self.KeyCode == Enum.KeyCode.R then
        -- 	-- getHookIndex(self.KeyCode == Enum.KeyCode.R)
        -- 	isBlink = true
        -- 	-- getHookIndex(self.KeyCode)
        -- 	-- return oldIndex(self, Index)
        -- 	-- getHookIndex(self, Index)
        -- else
        -- if self == HeeMenGui.Mouse then
        -- 	-- getHookIndex(self)
        -- 	local target = HeeMenGui.GetClosestPlayer(true)
        -- 	if not checkcaller() and target then
        -- 		-- local HitPart = target.Character.HumanoidRootPart
        -- 		local HitPart = target.Character.Head
        -- 		if Index == "Target" or Index == "target" then
        -- 			return HitPart
        -- 		elseif Index == "Hit" or Index == "hit" then
        -- 			-- getHookIndex(Index)
        -- 			-- if isBlink then
        -- 			-- isBlink = false
        -- 			-- 	return oldIndex(self, Index)
        -- 			-- else
        -- 			-- HeeMenGui.Print(Index)
        -- 			return HitPart.CFrame + (HitPart.Velocity * 0.2)
        -- 			-- end
        -- 		elseif Index == "X" or Index == "x" then
        -- 			return self.X
        -- 		elseif Index == "Y" or Index == "y" then
        -- 			return self.Y
        -- 		elseif Index == "UnitRay" then
        -- 			return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
        -- 		end
        -- 	end
        -- end

    end))
end

while getgenv().HeeMenGui and wait(0.1) do
    if HeeMenGui.OnCombat then
        if HeeMenGui.FnDodge then
            -- setupvalue(HeeMenGui.FnDodge, 6, 0) -- cooldown
            setupvalue(HeeMenGui.FnDodge, 7, 10)
            setupvalue(HeeMenGui.FnDodge, 10, 240)
        end
        if HeeMenGui.FnGeppo then
            -- setupvalue(HeeMenGui.FnGeppo, 6, 1) -- energy use
            -- setupvalue(HeeMenGui.FnGeppo, 7, 2)
            setupvalue(HeeMenGui.FnGeppo, 9, 0) -- jump count
        end
        if HeeMenGui.FnSoru then
            -- setupvalue(HeeMenGui.FnSoru, 2, 2) -- 15
            -- setupvalue(HeeMenGui.FnSoru, 3, 400)
            setupvalue(HeeMenGui.FnSoru, 9, {
                LastAfter = 0,
                LastUse = 0
            })
        end
    end
    if HeeMenGui.Config.FruitFinderHop and not HeeMenGui.FruitExists then
        HeeMenGui.FruitFinderHopCountDown = HeeMenGui.FruitFinderHopCountDown - 1
        if HeeMenGui.FruitFinderHopCountDown <= 0 then
            HeeMenGui.HopLowPlayer()
        end
    end
end

-- repeat wait(.1)
-- until not getgenv().HeeMenGui
