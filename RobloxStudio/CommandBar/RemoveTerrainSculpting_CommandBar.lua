-- REMOVE TERRAIN SCULPTING - Command Bar Script
-- This script removes all terrain sculpting and restores flat terrain
-- Paste this into Roblox Studio Command Bar

print("=== Remove Terrain Sculpting ===")

local Terrain = workspace.Terrain

if not Terrain then
	warn("⚠ No Terrain found in workspace!")
	warn("💡 Make sure you have terrain enabled in your game")
	return
end

print("  ✓ Found Terrain")

-- Find Baseplate to determine the area to clear
local baseplate = workspace:FindFirstChild("Baseplate")
if not baseplate then
	baseplate = workspace:FindFirstChild("baseplate")
end
if not baseplate then
	baseplate = workspace:FindFirstChild("BasePlate")
end
if not baseplate then
	-- Search recursively
	local function findBaseplateRecursive(parent)
		for _, obj in ipairs(parent:GetChildren()) do
			if obj:IsA("Part") and (obj.Name:lower():find("baseplate") or obj.Name:lower():find("base plate")) then
				return obj
			end
			if obj:IsA("Model") or obj:IsA("Folder") then
				local found = findBaseplateRecursive(obj)
				if found then return found end
			end
		end
		return nil
	end
	baseplate = findBaseplateRecursive(workspace)
end

if not baseplate then
	warn("⚠ No Baseplate found to determine clear area!")
	warn("💡 Will clear entire terrain region")
	
	-- Clear entire terrain (use a large region)
	local regionSize = Vector3.new(2000, 200, 2000)
	local regionPosition = Vector3.new(0, 0, 0)
	
	print("\n🗑️ Clearing entire terrain region...")
	
	local success, errorMsg = pcall(function()
		Terrain:FillBlock(CFrame.new(regionPosition), regionSize, Enum.Material.Air)
	end)
	
	if success then
		print("  ✓ Terrain sculpting removed!")
	else
		warn("  ⚠ Error removing terrain: " .. tostring(errorMsg))
	end
	return
end

print("  ✓ Found baseplate: " .. baseplate.Name)

local baseplateSize = baseplate.Size
local baseplatePos = baseplate.Position
local baseplateY = baseplatePos.Y

-- Clear terrain sculpting
print("\n🗑️ Removing terrain sculpting...")
print("    Baseplate size: " .. tostring(baseplateSize))
print("    Baseplate position: " .. tostring(baseplatePos))

local success, errorMsg = pcall(function()
	-- Clear the area with Air (removes all sculpting)
	local clearPosition = baseplatePos
	local clearSize = Vector3.new(baseplateSize.X + 100, baseplateSize.Y + 200, baseplateSize.Z + 100) -- Extra margin to catch edge terrain
	Terrain:FillBlock(CFrame.new(clearPosition), clearSize, Enum.Material.Air)
	
	-- Then fill with flat grass at baseplate level
	local grassThickness = 4 -- Standard voxel height
	local grassPosition = Vector3.new(baseplatePos.X, baseplateY, baseplatePos.Z)
	local grassSize = Vector3.new(baseplateSize.X, grassThickness, baseplateSize.Z)
	Terrain:FillBlock(CFrame.new(grassPosition), grassSize, Enum.Material.Grass)
end)

if success then
	print("  ✓ Terrain sculpting removed!")
	print("  ✓ Flat grass terrain restored")
else
	warn("  ⚠ Error removing terrain sculpting: " .. tostring(errorMsg))
end

print("\n✅ Done!")

