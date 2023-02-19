-- game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport','47880a98-c18b-4127-a9c0-aea310bf6177')
-- game.Players.LocalPlayer.VisionRadius.Value = math.huge
-- game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport', game.JobId)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xaxaxaxaxaxaxaxaxa/Libraries/main/UI's/Linoria/Source.lua"))()
-- 
-- game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport','3f612819-e05d-4f60-a0ba-555cf0bd88f2')

local ui = game.CoreGui:FindFirstChild("CustomAimbotGui")
if ui then ui:Destroy() end

if not setDelay then
	setDelay = 5
end

local CustomAimbotGui = Instance.new("ScreenGui")
CustomAimbotGui.Name = "CustomAimbotGui"
CustomAimbotGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = CustomAimbotGui
Main.BackgroundTransparency = 1
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.396, 0, 0, 0)
Main.Size = UDim2.new(0, 400, 1, -72)

local FuitInfo = Instance.new("TextLabel")
FuitInfo.Name = "FuitInfo"
FuitInfo.Parent = Main
FuitInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FuitInfo.BackgroundTransparency = 1
FuitInfo.Position = UDim2.new(0, 0, 0, 0)
FuitInfo.Size = UDim2.new(1, 1, 1, 1)
FuitInfo.Font = Enum.Font.DenkOne
FuitInfo.RichText = true
FuitInfo.Text = "N/A"
FuitInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
FuitInfo.TextSize = 30
FuitInfo.TextXAlignment = Enum.TextXAlignment.Center
FuitInfo.TextYAlignment = Enum.TextYAlignment.Bottom
FuitInfo.TextStrokeTransparency = 0.5

function findServer()
	local Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
	local selectIndex  = math.random(4, 9)
	local skipCount = 0
	for i,v in pairs(Site.data) do
		if v.playing then
			skipCount = skipCount + 1		
		end
		if skipCount == selectIndex then
			-- game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport', v.id)
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
			break
		end
	end
end

local fruitExists = false

game:GetService("UserInputService").InputBegan:Connect(function(io, p)
	if io.KeyCode == Enum.KeyCode.M then
		findServer()
	elseif io.KeyCode == Enum.KeyCode.N then
		fruitExists = true
	end
end)

local connection
function onRenderStepped()
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
				fruitExists = true
				FuitInfo.Text = fruitMesh or "Unknown fruit"
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

-- resume(create(function()
connection = game:GetService("RunService").RenderStepped:Connect(onRenderStepped)

local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/son3cent/Lua-Knowleage/main/Roblox/BloxFruit/ServerHop.lua'))()")

wait(setDelay)
if not fruitExists then
	findServer()
end
