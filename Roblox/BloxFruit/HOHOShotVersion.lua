loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HohoV2/Free/BloxFruitFree.lua'))()
local path = "loadstring(game:HttpGet('https://raw.githubusercontent.com/son3cent/Lua-Knowleage/main/Roblox/BloxFruit/HOHOShotVersion.lua'))()"
if getgenv().Pirate then
	path = "getgenv().Pirate = "..tostring(getgenv().Pirate).."\n"..path
end

local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
queueteleport(path)
