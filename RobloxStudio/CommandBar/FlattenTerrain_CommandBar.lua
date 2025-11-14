-- FLATTEN TERRAIN - Command Bar Script
-- This script flattens terrain that was sculpted using the Terrain Editor
-- Paste this into Roblox Studio Command Bar

print("=== Flatten Terrain ===")

local Terrain = workspace.Terrain

if not Terrain then
	warn("⚠ No Terrain found in workspace!")
	warn("💡 Make sure you have terrain enabled in your game")
	return
end

print("  ✓ Found Terrain")

-- Find Baseplate to determine the area to flatten
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
	warn("⚠ No Baseplate found to determine flatten area!")
	warn("💡 Will flatten entire terrain region")
	
	-- Flatten entire terrain (use a large region)
	local regionSize = Vector3.new(2000, 100, 2000)
	local regionPosition = Vector3.new(0, -50, 0)
	
	print("\n🗻 Flattening entire terrain region...")
	print("    Region: " .. tostring(regionSize))
	print("    Position: " .. tostring(regionPosition))
	
	-- Use FillBlock to create a flat terrain block
	local success, errorMsg = pcall(function()
		Terrain:FillBlock(CFrame.new(regionPosition + regionSize/2), regionSize, Enum.Material.Grass)
	end)
	
	if success then
		print("  ✓ Terrain flattened!")
	else
		warn("  ⚠ Error flattening terrain: " .. tostring(errorMsg))
		warn("  💡 Try using Terrain Editor manually: View > Terrain Editor > Edit > Flatten")
	end
	return
end

print("  ✓ Found baseplate: " .. baseplate.Name)
print("    Size: " .. tostring(baseplate.Size))
print("    Position: " .. tostring(baseplate.Position))

local baseplateSize = baseplate.Size
local baseplatePos = baseplate.Position
local baseplateY = baseplatePos.Y

-- Calculate region to flatten (baseplate area, extended vertically)
local regionSize = Vector3.new(baseplateSize.X, baseplateSize.Y + 100, baseplateSize.Z)
local regionPosition = Vector3.new(
	baseplatePos.X - (baseplateSize.X / 2),
	baseplateY - 50, -- Start below baseplate
	baseplatePos.Z - (baseplateSize.Z / 2)
)

print("\n🗻 Flattening terrain in baseplate region...")
print("    Region size: " .. tostring(regionSize))
print("    Region position: " .. tostring(regionPosition))

-- Use FillBlock to flatten terrain
-- FillBlock signature: FillBlock(CFrame.new(position), size, material)
print("  🔄 Using FillBlock to flatten terrain...")
local success, errorMsg = pcall(function()
	-- First, clear the area with Air
	local clearPosition = baseplatePos
	local clearSize = Vector3.new(baseplateSize.X, baseplateSize.Y + 100, baseplateSize.Z)
	Terrain:FillBlock(CFrame.new(clearPosition), clearSize, Enum.Material.Air)
	
	-- Then fill with flat grass at baseplate level
	local grassThickness = 4 -- Standard voxel height
	local grassPosition = Vector3.new(baseplatePos.X, baseplateY, baseplatePos.Z)
	local grassSize = Vector3.new(baseplateSize.X, grassThickness, baseplateSize.Z)
	Terrain:FillBlock(CFrame.new(grassPosition), grassSize, Enum.Material.Grass)
end)

if success then
	print("  ✓ Terrain flattened using FillBlock!")
else
	warn("  ⚠ FillBlock method failed: " .. tostring(errorMsg))
	
	-- Method 2: Try using WriteVoxels to flatten (resolution must be 4)
	print("  🔄 Trying alternative method with WriteVoxels...")
	local success2, errorMsg2 = pcall(function()
		-- Create Region3 for the area
		local minPoint = Vector3.new(
			baseplatePos.X - (baseplateSize.X / 2),
			baseplateY - 2,
			baseplatePos.Z - (baseplateSize.Z / 2)
		)
		local maxPoint = Vector3.new(
			baseplatePos.X + (baseplateSize.X / 2),
			baseplateY + 2,
			baseplatePos.Z + (baseplateSize.Z / 2)
		)
		local region = Region3.new(minPoint, maxPoint)
		
		-- Resolution must be exactly 4 for WriteVoxels
		local resolution = 4
		
		-- Calculate number of cells (each cell is 4x4 studs at resolution 4)
		local cellSize = 4
		local cellsX = math.ceil(baseplateSize.X / cellSize)
		local cellsZ = math.ceil(baseplateSize.Z / cellSize)
		local totalCells = cellsX * cellsZ
		
		-- Create flat voxel data - all grass, full occupancy
		local materials = {}
		local occupancies = {}
		
		for i = 1, totalCells do
			table.insert(materials, Enum.Material.Grass)
			table.insert(occupancies, 1) -- Full occupancy (solid)
		end
		
		-- Write flat terrain
		Terrain:WriteVoxels(region, resolution, materials, occupancies)
	end)
	
	if success2 then
		print("  ✓ Terrain flattened using WriteVoxels!")
	else
		warn("  ⚠ WriteVoxels method also failed: " .. tostring(errorMsg2))
		warn("  💡 You may need to use Terrain Editor manually:")
		warn("     1. View > Terrain Editor")
		warn("     2. Select 'Edit' tab")
		warn("     3. Use 'Flatten' tool to manually flatten the terrain")
	end
end

-- Reset spawn locations to flat baseplate height
print("\n📍 Resetting spawn locations to flat baseplate...")
local baseplateTop = baseplateY + (baseplateSize.Y / 2)
local spawnLocations = {}
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("SpawnLocation") then
		table.insert(spawnLocations, obj)
	end
end

if #spawnLocations > 0 then
	print("  Found " .. #spawnLocations .. " spawn location(s)")
	
	for _, spawnLoc in ipairs(spawnLocations) do
		local spawnPos = spawnLoc.Position
		local spawnX = spawnPos.X
		local spawnZ = spawnPos.Z
		
		-- Check if spawn is within baseplate bounds
		local baseplateMinX = baseplatePos.X - (baseplateSize.X / 2)
		local baseplateMaxX = baseplatePos.X + (baseplateSize.X / 2)
		local baseplateMinZ = baseplatePos.Z - (baseplateSize.Z / 2)
		local baseplateMaxZ = baseplatePos.Z + (baseplateSize.Z / 2)
		
		if spawnX >= baseplateMinX and spawnX <= baseplateMaxX and
		   spawnZ >= baseplateMinZ and spawnZ <= baseplateMaxZ then
			
			-- Reset to flat baseplate top + half of spawn height
			local newY = baseplateTop + (spawnLoc.Size.Y / 2)
			spawnLoc.Position = Vector3.new(spawnX, newY, spawnZ)
			print("  ✓ Reset " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", newY))
		else
			print("  ⚠ " .. spawnLoc.Name .. " is outside baseplate bounds, keeping current position")
		end
	end
else
	print("  No spawn locations found")
end

print("\n✅ Terrain flattening complete!")
print("💡 If terrain is not fully flat, use Terrain Editor manually:")
print("   View > Terrain Editor > Edit > Flatten tool")

