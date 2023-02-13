
local ui = game.CoreGui:FindFirstChild("ScreenGui")
if ui then ui:Destroy() end

if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local resume = coroutine.resume 
local create = coroutine.create

local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped
local UserInputService = game:GetService("UserInputService")
local GetMouseLocation = UserInputService.GetMouseLocation

local Camera = workspace.CurrentCamera
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local function getMousePosition()
    return GetMouseLocation(UserInputService)
end

local function numFormat(value)
	local left, num, right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function getPlayerDistance(target)
	distance = math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position - target.Character.Head.Position).Magnitude / 3)
	real_distance = math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position - target.Character.Head.Position).Magnitude / 3)
	distance = math.floor(distance / 100)
	if distance < 10 then
		distance = 109 - distance
	elseif distance > 100 then
		distance = 0
	else
		distance = 100 - distance
	end
	base_distance = math.floor(distance / 10) + 5
	sub_distance = math.floor(distance / 100) * math.fmod(distance, 100)
	distance = math.floor((base_distance + sub_distance) * 2)

	return real_distance, distance
end

local targetPlayer
local targetLock

local function getClosestPlayer()
	targetPlayer = nil
    local DistanceToMouse = 360
	for k, v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Name == game:GetService("Players").LocalPlayer.Name then
			continue
		end

        if not v.Character then continue end

        local HumanoidRootPart = game.FindFirstChild(v.Character, "HumanoidRootPart")
        local Humanoid = game.FindFirstChild(v.Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (getMousePosition() - ScreenPosition).Magnitude
		local real_distance, range = getPlayerDistance(v)
        if Distance <= DistanceToMouse and real_distance <= 200 then
    		targetPlayer = v
			DistanceToMouse = Distance
        end
    end


	if targetLock then
		return targetLock
	else
    	return targetPlayer
	end
end

local function getPlayerInfo()
	local target = nil
    local DistanceToMouse = 100
	for k, v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Name == game:GetService("Players").LocalPlayer.Name then
			continue
		end

        if not v.Character then continue end

        local HumanoidRootPart = game.FindFirstChild(v.Character, "HumanoidRootPart")
        local Humanoid = game.FindFirstChild(v.Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (getMousePosition() - ScreenPosition).Magnitude
		local real_distance, range = getPlayerDistance(v)
        if Distance <= DistanceToMouse then
    		target = v
			DistanceToMouse = Distance
        end
    end
	
	local ui = game.CoreGui:FindFirstChild("PlayerInfoGui")
	if ui then ui:Destroy() end

	if target then
		local PlayerInfoGui = Instance.new("ScreenGui")
		PlayerInfoGui.Name = "PlayerInfoGui"
		PlayerInfoGui.Parent = game.CoreGui

		local Main = Instance.new("Frame")
		Main.Name = "Main"
		Main.Parent = PlayerInfoGui
		Main.BackgroundTransparency = 1
		Main.ClipsDescendants = true
		Main.Position = UDim2.new(0.202, 0, 0.70, 0)
		Main.Size = UDim2.new(0, 400, 0, 316)

		-- local items = {
		-- 	"ID" = target.Name;
		-- 	"Name" = target.DisplayName;
		-- 	"Loc" = target.Data.LastSpawnPoint.Value;
		-- }
		local items = {}
		items["ID"] = target.Name
		items["Name"] = target.DisplayName
		items["Loc"] = target.Data.LastSpawnPoint.Value
		items["Level"] = target.Data.Level.Value
		items["Race"] = target.Data.Race.Value
		items["B/H"] = numFormat(target.leaderstats["Bounty/Honor"].Value)

		local distance, range = getPlayerDistance(target)
		items["Distance"] = distance

		local txtInfo = "ID: " .. target.Name .. '\n'
		txtInfo = txtInfo .. "Name: " .. target.DisplayName .. '\n'
		txtInfo = txtInfo .. "Distance: " .. distance .. '\n'
		txtInfo = txtInfo .. "Loc: " .. target.Data.LastSpawnPoint.Value .. '\n'
		txtInfo = txtInfo .. "Level: " .. target.Data.Level.Value .. '\n'
		txtInfo = txtInfo .. "Race: " .. target.Data.Race.Value .. '\n'
		txtInfo = txtInfo .. "B/H: " .. numFormat(target.leaderstats["Bounty/Honor"].Value)

		local ShowName = Instance.new("TextLabel")
		ShowName.Name = "PlayerInfo"
		ShowName.Parent = Main
		ShowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ShowName.BackgroundTransparency = 1
		ShowName.Position = UDim2.new(0, 0, 0, 0)
		ShowName.Size = UDim2.new(1, 1, 1, 1)
		ShowName.Font = Enum.Font.DenkOne
		ShowName.RichText = true
		ShowName.Text = txtInfo
		ShowName.TextColor3 = Color3.fromRGB(255, 255, 255)
		ShowName.TextSize = 24
		ShowName.TextXAlignment = Enum.TextXAlignment.Left
		ShowName.TextYAlignment = Enum.TextYAlignment.Bottom
		ShowName.TextStrokeTransparency = 0.5

		-- local position = 30
		-- for k,v in pairs(items) do
		-- 	local ShowName = Instance.new("TextLabel")
		-- 	ShowName.Name = "ShowInfo_" .. k
		-- 	ShowName.Parent = Main
		-- 	ShowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		-- 	ShowName.BackgroundTransparency = 1
		-- 	ShowName.Position = UDim2.new(0, 0, 0, position)
		-- 	ShowName.Size = UDim2.new(1, 1, 0, 30)
		-- 	ShowName.Font = Enum.Font.DenkOne
		-- 	ShowName.RichText = true
		-- 	ShowName.Text = k .. ': ' .. v
		-- 	ShowName.TextColor3 = Color3.fromRGB(255, 255, 255)
		-- 	ShowName.TextSize = 24
		-- 	ShowName.TextXAlignment = Enum.TextXAlignment.Left
		-- 	ShowName.TextStrokeTransparency = 0.5
		-- 	position = position + 30
		-- end
	end

	-- return targetPlayer
end

local function fruitEsp()
	for i,v in pairs(game.Workspace:GetChildren()) do
		if string.find(v.Name, "Fruit") then
			local fruitMesh = ""
			if v.Name == "Fruit " then
				for j,w in pairs(v:GetChildren()) do
					if string.find(w.Name, "Meshes") then
						fruitMesh = w.Name .. ' - '
						break
					end
				end
			end
			local fruitDistance = math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3)
			if not v.Handle:FindFirstChild('NameEsp') then
				local bill = Instance.new('BillboardGui',v.Handle)
				bill.Name = 'NameEsp'
				bill.ExtentsOffset = Vector3.new(0, 1, 0)
				bill.Size = UDim2.new(1,400,1,60)
				bill.Adornee = v.Handle
				bill.AlwaysOnTop = true
				local name = Instance.new('TextLabel',bill)
				name.Font = "GothamBold"
				name.FontSize = Enum.FontSize.Size18
				name.TextWrapped = true
				name.Size = UDim2.new(1,0,1,0)
				name.TextYAlignment = Enum.TextYAlignment.Bottom
				name.BackgroundTransparency = 1
				name.TextStrokeTransparency = 0.5
				name.TextColor3 = Color3.fromRGB(255, 0, 0)
				name.Text = (v.Name .. '\n' .. fruitMesh .. fruitDistance ..' M')
			else
				v.Handle['NameEsp'].TextLabel.Text = (v.Name ..'\n' .. fruitMesh .. fruitDistance ..' M')
			end
		end
	end
end

game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

for i, v in pairs(game:GetService("Players"):GetChildren()) do
	if v.Character.Head:FindFirstChild('NameEsp') then
		v.Character.Head:FindFirstChild('NameEsp'):Destroy()
	end
	if v.Character.Head:FindFirstChild('InfoEsp') then
		v.Character.Head:FindFirstChild('InfoEsp'):Destroy()
	end
end

-- local fov_circle = Drawing.new("Circle")
-- fov_circle.Thickness = 1
-- fov_circle.NumSides = 100
-- fov_circle.Radius = 360
-- fov_circle.Filled = false
-- fov_circle.Visible = false
-- fov_circle.ZIndex = 999
-- fov_circle.Transparency = 1
-- fov_circle.Color = Color3.fromRGB(54, 57, 241)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScreenGui"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundTransparency = 1
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.396, 0, 0, 0)
Main.Size = UDim2.new(0, 400, 1, -72)

local ShowName = Instance.new("TextLabel")
ShowName.Name = "MyName"
ShowName.Parent = Main
ShowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShowName.BackgroundTransparency = 1
ShowName.Position = UDim2.new(0, 0, 0, 24)
ShowName.Size = UDim2.new(1, 1, 1, 1)
ShowName.Font = Enum.Font.DenkOne
ShowName.RichText = true
ShowName.Text = 'N/A'
ShowName.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowName.TextSize = 40
ShowName.TextXAlignment = Enum.TextXAlignment.Center
ShowName.TextYAlignment = Enum.TextYAlignment.Top
ShowName.TextStrokeTransparency = 0.5

local targetBounty = Instance.new("TextLabel")
targetBounty.Name = "TargetBounty"
targetBounty.Parent = Main
targetBounty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
targetBounty.BackgroundTransparency = 1
targetBounty.Position = UDim2.new(0, 0, 0, 0)
targetBounty.Size = UDim2.new(1, 1, 1, 1)
targetBounty.Font = Enum.Font.DenkOne
targetBounty.RichText = true
targetBounty.Text = "-"
targetBounty.TextColor3 = Color3.fromRGB(255, 255, 255)
targetBounty.TextSize = 26
targetBounty.TextXAlignment = Enum.TextXAlignment.Center
targetBounty.TextYAlignment = Enum.TextYAlignment.Top
targetBounty.TextStrokeTransparency = 0.5

local myBounty = Instance.new("TextLabel")
myBounty.Name = "MyBounty"
myBounty.Parent = Main
myBounty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
myBounty.BackgroundTransparency = 1
myBounty.Position = UDim2.new(0, 0, 0, 0)
myBounty.Size = UDim2.new(1, 1, 1, 1)
myBounty.Font = Enum.Font.DenkOne
myBounty.RichText = true
myBounty.Text = numFormat(game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value)
myBounty.TextColor3 = Color3.fromRGB(255, 255, 255)
myBounty.TextSize = 40
myBounty.TextXAlignment = Enum.TextXAlignment.Center
myBounty.TextYAlignment = Enum.TextYAlignment.Bottom
myBounty.TextStrokeTransparency = 0.5

local fnDodge, inxDodge
function infDodge()
	for i, v in pairs(getgc()) do
		if game.Players.LocalPlayer.Character.Dodge then
			if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Dodge then
				for i2,v2 in pairs(debug.getupvalues(v)) do
					if tostring(v2) == "0.4" then
						fnDodge = v
						inxDodge = i2
						setupvalue(v, i2, 0)
						-- repeat wait(.1)
						-- 	setupvalue(v,i2,0)
						-- until not nododgecool
					end
				end
			end
		end
	end
end

local fnGeppo, inxGeppo
function infGeppo()
	for i, v in pairs(getgc()) do
		if game.Players.LocalPlayer.Character.Skyjump then
			if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Skyjump then
				for i2,v2 in pairs(debug.getupvalues(v)) do
					if tostring(v2) == "0" then
						fnGeppo = v
						inxGeppo = i2
						setupvalue(v,i2,0)
					end
				end
			end
		end
	end
end

local fnSoru, inxSoru
function infSoru()
	for i, v in pairs(getgc()) do
		if type(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Soru") then
			for i2,v2 in pairs(debug.getupvalues(v)) do
				if type(v2) == 'table' then
					if v2.LastUse then
						fnSoru = v
						inxSoru = i2
						setupvalue(v, i2, {LastAfter = 0,LastUse = 0})
						-- repeat wait()
						-- 	setupvalue(v, i2, {LastAfter = 0,LastUse = 0})
						-- until not Sorunocool
					end
				end
			end
		end
	end
end

-- local PlayerService = game:GetService("Players")

-- PlayerService.PlayerAdded:Connect(function(player)
--    player.CharacterAdded:Connect(function(character)
-- 		fnSoru = nil 
-- 		inxSoru = nil
-- 		infSoru()
--    end)
-- end)

-- game:GetService("RunService").Heartbeat:Connect(function()	
-- 	if fnSoru and inxSoru then
-- 		setupvalue(fnSoru, inxSoru, {LastAfter = 0,LastUse = 0})
-- 	else
-- 		infSoru()
-- 	end
-- end)
-- infDodge()
infSoru()
-- infGeppo()

resume(create(function()
	RenderStepped:Connect(function()
		-- fov_circle.Position = getMousePosition()
		-- fov_circle.Radius = 390
		-- fov_circle.Visible = true
		if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
		end
		
		if fnDodge and inxDodge then
			setupvalue(fnDodge, inxDodge, 0)
		-- else
		-- 	infDodge()
		end
		
		if fnSoru and inxSoru then
			setupvalue(fnSoru, inxSoru, {LastAfter = 0,LastUse = 0})
		end
		
		if fnGeppo and inxGeppo then
			setupvalue(fnGeppo, inxGeppo, 0)
		end
		
		ShowName.Text = "N/A"
		targetBounty.Text = "-"
		myBounty.Text = numFormat(game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value)
		
		for i, v in pairs(game:GetService("Players"):GetChildren()) do
			if v.Name == game:GetService("Players").LocalPlayer.Name then
				continue
			end
			if not (v.Character == nil) and not (v.Character.Head == nil) and not v.Character.Head:FindFirstChild('NameEsp') then				
				local bill = Instance.new('BillboardGui', v.Character.Head)
				bill.Name = 'NameEsp'
				bill.ExtentsOffset = Vector3.new(0, 1, 0)
				bill.Size = UDim2.new(0, 200, 0, 60)
				bill.Adornee = v.Character.Head
				bill.AlwaysOnTop = true
				local health = Instance.new('TextLabel', bill)
				health.Font = "Roboto"
				-- health.TextScaled = true
				health.FontSize = "Size14"
				health.TextWrapped = true
				health.Text = v.Name
				health.Size = UDim2.new(1, 1, 1, 1)
				health.TextYAlignment = Enum.TextYAlignment.Bottom
				health.BackgroundTransparency = 1
				health.TextStrokeTransparency = 0.5
				health.TextColor3 = Color3.new(255, 255, 255)		

				local bill2 = Instance.new('BillboardGui', v.Character.Head)
				bill2.Name = 'InfoEsp'
				bill2.ExtentsOffset = Vector3.new(0, 1, 0)
				bill2.Size = UDim2.new(0, 400, 0, 80)
				bill2.Adornee = v.Character.Head
				bill2.AlwaysOnTop = true
				local info = Instance.new('TextLabel', bill2)
				info.Font = "Roboto"
				info.FontSize = Enum.FontSize.Size14
				info.Text = v.Name
				info.Size = UDim2.new(1, 1, 1, 1)
				info.TextYAlignment = Enum.TextYAlignment.Bottom
				info.BackgroundTransparency = 1
				info.TextStrokeTransparency = 0.5
				info.TextColor3 = Color3.new(255, 255, 255)
			else
				local distance, range = getPlayerDistance(v)
				v.Character.Head['NameEsp'].TextLabel.TextColor3 = Color3.new(255, 255, 255)
				v.Character.Head['InfoEsp'].TextLabel.TextColor3 = Color3.new(255, 255, 255)
				v.Character.Head['NameEsp'].TextLabel.TextSize = range
				-- v.Character.Head['NameEsp'].Size = UDim2.new(0, 200, 0, range)
				-- v.Character.Head['InfoEsp'].Size = UDim2.new(0, 200, 0, (range + 20))
				-- v.Character.Head['NameEsp'].TextLabel.ZIndex = 1
				-- v.Character.Head['InfoEsp'].TextLabel.ZIndex = 1
				v.Character.Head['NameEsp'].TextLabel.Text = tostring(math.floor(v.Character.Humanoid.Health * 100 / v.Character.Humanoid.MaxHealth)) .. '%'
				v.Character.Head['InfoEsp'].TextLabel.Text = v.Name .. " || " .. tostring(distance) .. "M" .. " || " .. v.Data.LastSpawnPoint.Value
				if targetLock then
					if targetLock.Name == v.Name and distance > 400 then
						targetLock = nil
					end
				end
			end
		end
		
		local target = getClosestPlayer()
		if not (target == nil) then
			target.Character.Head['NameEsp'].TextLabel.TextColor3 = Color3.new(255, 0, 0)
			target.Character.Head['InfoEsp'].TextLabel.TextColor3 = Color3.new(255, 0, 0)
			target.Character.Head['NameEsp'].TextLabel.Text = tostring(math.floor(target.Character.Humanoid.Health * 100 / target.Character.Humanoid.MaxHealth)) .. '-' .. target.DisplayName
			-- target.Character.Head['NameEsp'].TextLabel.ZIndex = 999
			-- target.Character.Head['InfoEsp'].TextLabel.ZIndex = 999
			local distance, range = getPlayerDistance(target)
			ShowName.Text = tostring(target.Name) .. " || " .. tostring(distance) .. "M" --v.Data.LastSpawnPoint.Value
			targetBounty.Text = numFormat(target.leaderstats["Bounty/Honor"].Value)
		end

		getPlayerInfo()

		fruitEsp()
	end)
end))


game:GetService("UserInputService").InputBegan:Connect(function(io, p)
	if io.KeyCode == Enum.KeyCode.B then
		if targetPlayer then
			targetLock = targetPlayer
		elseif targetLock then
			targetLock = nil
		end
	end
end)

local spectate = false
game:GetService("UserInputService").InputBegan:Connect(function(io, p)
	if io.KeyCode == Enum.KeyCode.P then
		-- if targetLock and not spectate then
		-- 	game.Workspace.Camera.CameraSubject = targetLock.Character.Humanoid
		-- else
		-- 	game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		-- end
		-- spectate = not spectate
		infGeppo()
		infSoru()
	end
end)

local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if self == Mouse and not checkcaller() and getClosestPlayer() then
        local target = getClosestPlayer()
        local HitPart = target.Character.HumanoidRootPart
         
        if Index == "Target" or Index == "target" then 
            return HitPart
        elseif Index == "Hit" or Index == "hit" then 
            return HitPart.CFrame + (HitPart.Velocity * 0.2)
        elseif Index == "X" or Index == "x" then 
            return self.X 
        elseif Index == "Y" or Index == "y" then 
            return self.Y 
        elseif Index == "UnitRay" then 
            return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
        end
    end

    return oldIndex(self, Index)
end))
