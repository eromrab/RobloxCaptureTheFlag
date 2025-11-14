-- ALIGN WALLS TO TERRAIN - Command Bar Script
-- This script adjusts existing walls to align with the terrain boundaries
-- Terrain has an 8-stud margin from the baseplate edges

print("=== Aligning Walls to Terrain Boundaries ===")

-- Find Baseplate (search recursively like terrain script)
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
	warn("⚠ No Baseplate found!")
	warn("  Searching workspace for all parts...")
	local partCount = 0
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Part") then
			partCount = partCount + 1
			print("    Found part: " .. obj.Name .. " | Size: " .. tostring(obj.Size))
		end
	end
	if partCount == 0 then
		print("    (No parts found directly in workspace)")
	end
	return
end

local baseplateSize = baseplate.Size
local baseplatePos = baseplate.Position
local halfSizeX = baseplateSize.X / 2
local halfSizeZ = baseplateSize.Z / 2

-- Terrain margin (matches terrain generation script)
local WALL_MARGIN = 8 -- Studs that terrain is inset from baseplate edges
local wallThickness = 2 -- Standard wall thickness (matches AddWalls script)

-- Find walls folder
local wallsFolder = workspace:FindFirstChild("Walls")
if not wallsFolder then
	warn("⚠ No 'Walls' folder found in workspace!")
	return
end

print("  ✓ Found Walls folder")
print("  ✓ Baseplate size: " .. tostring(baseplateSize))
print("  ✓ Terrain margin: " .. WALL_MARGIN .. " studs")
print("  ✓ Adjusting walls to align with terrain boundaries...")

-- Calculate terrain boundaries (baseplate edges minus margin)
local terrainMinX = baseplatePos.X - halfSizeX + WALL_MARGIN
local terrainMaxX = baseplatePos.X + halfSizeX - WALL_MARGIN
local terrainMinZ = baseplatePos.Z - halfSizeZ + WALL_MARGIN
local terrainMaxZ = baseplatePos.Z + halfSizeZ - WALL_MARGIN

print("  Terrain boundaries:")
print("    X: " .. terrainMinX .. " to " .. terrainMaxX)
print("    Z: " .. terrainMinZ .. " to " .. terrainMaxZ)

-- Find and adjust walls
local adjustedCount = 0

for _, wall in ipairs(wallsFolder:GetChildren()) do
	if wall:IsA("Part") then
		local wallName = wall.Name:lower()
		local currentPos = wall.Position
		local wallSize = wall.Size
		local newPos = currentPos
		local adjusted = false
		
		-- East wall (positive X - blue team side)
		if wallName:find("east") then
			-- Wall should span from terrain edge to baseplate edge (covering the margin gap)
			local baseplateMaxX = baseplatePos.X + halfSizeX
			-- Wall center is halfway between terrain edge and baseplate edge
			local wallCenterX = (terrainMaxX + baseplateMaxX) / 2
			newPos = Vector3.new(wallCenterX, currentPos.Y, currentPos.Z)
			-- Wall width spans the margin gap plus extends slightly beyond baseplate edge
			local wallWidth = (baseplateMaxX - terrainMaxX) + wallThickness
			wall.Size = Vector3.new(wallWidth, wallSize.Y, baseplateSize.Z)
			adjusted = true
			print("  ✓ Adjusted " .. wall.Name .. " (East wall) - Position: " .. wallCenterX .. ", Size: " .. tostring(wall.Size))
		
		-- West wall (negative X - red team side)
		elseif wallName:find("west") then
			-- Wall should span from terrain edge to baseplate edge (covering the margin gap)
			local baseplateMinX = baseplatePos.X - halfSizeX
			-- Wall center is halfway between terrain edge and baseplate edge
			local wallCenterX = (terrainMinX + baseplateMinX) / 2
			newPos = Vector3.new(wallCenterX, currentPos.Y, currentPos.Z)
			-- Wall width spans the margin gap plus extends slightly beyond baseplate edge
			local wallWidth = (terrainMinX - baseplateMinX) + wallThickness
			wall.Size = Vector3.new(wallWidth, wallSize.Y, baseplateSize.Z)
			adjusted = true
			print("  ✓ Adjusted " .. wall.Name .. " (West wall) - Position: " .. wallCenterX .. ", Size: " .. tostring(wall.Size))
		
		-- North wall (positive Z)
		elseif wallName:find("north") then
			-- Wall should span from terrain edge to baseplate edge (covering the margin gap)
			local baseplateMaxZ = baseplatePos.Z + halfSizeZ
			-- Wall center is halfway between terrain edge and baseplate edge
			local wallCenterZ = (terrainMaxZ + baseplateMaxZ) / 2
			newPos = Vector3.new(currentPos.X, currentPos.Y, wallCenterZ)
			-- Wall depth spans the margin gap plus extends slightly beyond baseplate edge
			local wallDepth = (baseplateMaxZ - terrainMaxZ) + wallThickness
			wall.Size = Vector3.new(baseplateSize.X + (wallThickness * 2), wallSize.Y, wallDepth)
			adjusted = true
			print("  ✓ Adjusted " .. wall.Name .. " (North wall) - Position: " .. wallCenterZ .. ", Size: " .. tostring(wall.Size))
		
		-- South wall (negative Z)
		elseif wallName:find("south") then
			-- Wall should span from terrain edge to baseplate edge (covering the margin gap)
			local baseplateMinZ = baseplatePos.Z - halfSizeZ
			-- Wall center is halfway between terrain edge and baseplate edge
			local wallCenterZ = (terrainMinZ + baseplateMinZ) / 2
			newPos = Vector3.new(currentPos.X, currentPos.Y, wallCenterZ)
			-- Wall depth spans the margin gap plus extends slightly beyond baseplate edge
			local wallDepth = (terrainMinZ - baseplateMinZ) + wallThickness
			wall.Size = Vector3.new(baseplateSize.X + (wallThickness * 2), wallSize.Y, wallDepth)
			adjusted = true
			print("  ✓ Adjusted " .. wall.Name .. " (South wall) - Position: " .. wallCenterZ .. ", Size: " .. tostring(wall.Size))
		end
		
		if adjusted then
			wall.Position = newPos
			adjustedCount = adjustedCount + 1
		end
	end
end

if adjustedCount > 0 then
	print("\n✓ Successfully adjusted " .. adjustedCount .. " wall(s) to align with terrain boundaries!")
	print("💡 Walls now align with where terrain ends (8 studs in from baseplate edges)")
else
	print("\n⚠ No walls were adjusted. Make sure walls are named with 'East', 'West', 'North', or 'South'")
end

