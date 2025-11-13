-- Fix for gun tool missing Handle
-- The error occurs because the tool is waiting for a Handle that doesn't exist
-- 
-- SOLUTION: Add a Handle part to your gun tool manually in Roblox Studio:
-- 1. Select your gun tool (YourGunTool) in StarterPack or wherever it is
-- 2. Insert a Part, rename it to "Handle"
-- 3. Set its properties:
--    - Size: Vector3.new(0.2, 0.2, 1) or whatever size you want
--    - Transparency: 1 (invisible)
--    - CanCollide: false
--    - Anchored: false
--
-- OR modify your GunClient script (line 13) to handle missing Handle:
-- Change: tool:WaitForChild("Handle")
-- To: tool:FindFirstChild("Handle") or warn("Gun tool missing Handle!")

-- This script can be run in Command Bar or as a LocalScript in StarterPlayer > StarterPlayerScripts
-- But the easiest solution is to just add the Handle part manually in Roblox Studio

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player then
	warn("This script must be run as a LocalScript or in Command Bar")
	return
end

-- Try to find the tool in Backpack or StarterPack
local toolName = "YourGunTool" -- Change this to your actual gun tool name
local tool = player.Backpack:FindFirstChild(toolName) or game.StarterPack:FindFirstChild(toolName)

if tool then
	local handle = tool:FindFirstChild("Handle")
	if not handle then
		handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(0.2, 0.2, 1)
		handle.Transparency = 1
		handle.CanCollide = false
		handle.Parent = tool
		print("Created Handle for " .. tool.Name)
	else
		print("Handle already exists for " .. tool.Name)
	end
else
	warn("Could not find " .. toolName .. " in Backpack or StarterPack")
	warn("Please add a Handle part manually to your gun tool in Roblox Studio")
end

