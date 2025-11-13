-- SCULPT TERRAIN - Command Bar Script
-- This script adds random terrain sculpting to the Baseplate using Terrain API
-- Creates smooth, rounded terrain with mirroring (like the part-based version)
-- Paste this into Roblox Studio Command Bar

print("=== Terrain Sculpting Script ===")

local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain

if not Terrain then
	warn("⚠ No Terrain found in workspace!")
	warn("💡 Make sure you have terrain enabled in your game")
	return
end

print("  ✓ Found Terrain")

-- Configuration
-- Zone-based height ranges (based on GameMap.txt layout: Base | Defend | Neutral | Defend | Base)
local BASE_MIN_HEIGHT = 10 -- Base areas: minimum height (studs above baseplate top)
local BASE_MAX_HEIGHT = 40 -- Base areas: maximum height
local DEFEND_MIN_HEIGHT = 10 -- Defend areas: minimum height
local DEFEND_MAX_HEIGHT = 80 -- Defend areas: maximum height
local NEUTRAL_MIN_HEIGHT = 10 -- Neutral area: minimum height
local NEUTRAL_MAX_HEIGHT = 40 -- Neutral area: maximum height

local SMOOTHNESS = 0.85 -- 0.0 = very random, 1.0 = very smooth (0.85 = very smooth with minimal variation)
local CLIFF_CHANCE = 0.1 -- 10% chance for a cliff (steep change)
local CLIFF_INTENSITY = 3.0 -- How dramatic cliffs are (multiplier)
local VOXEL_RESOLUTION = 4 -- Must be 4 for WriteVoxels
local VOXEL_SIZE = 4 -- Each voxel cell is 4x4 studs at resolution 4

-- Find Baseplate to determine bounds
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
	warn("⚠ No Baseplate found! Cannot sculpt.")
	return
end

print("  ✓ Found baseplate: " .. baseplate.Name)
print("    Size: " .. tostring(baseplate.Size))
print("    Position: " .. tostring(baseplate.Position))

local baseplateSize = baseplate.Size
local baseplatePos = baseplate.Position
local baseplateY = baseplatePos.Y
local baseplateTop = baseplateY + (baseplateSize.Y / 2)

-- Calculate grid dimensions (using voxel cells)
local cellsX = math.ceil(baseplateSize.X / VOXEL_SIZE)
local cellsZ = math.ceil(baseplateSize.Z / VOXEL_SIZE)
local midX = math.floor(cellsX / 2) -- Midpoint for mirroring

-- Divide baseplate into 5 zones (Base | Defend | Neutral | Defend | Base)
-- Each zone is 1/5 of the width
local zoneWidth = cellsX / 5
local zone1End = math.floor(zoneWidth) -- Base (left)
local zone2End = math.floor(zoneWidth * 2) -- Defend (left-middle)
local zone3End = math.floor(zoneWidth * 3) -- Neutral (center)
local zone4End = math.floor(zoneWidth * 4) -- Defend (right-middle)
-- Zone 5 (Base right) is from zone4End to cellsX

-- Function to get zone-based height range for a cell
local function getZoneHeightRange(cellX)
	-- Determine which zone this cell is in (for left half, before mirroring)
	if cellX <= zone1End then
		-- Zone 1: Base (left)
		return BASE_MIN_HEIGHT, BASE_MAX_HEIGHT
	elseif cellX <= zone2End then
		-- Zone 2: Defend (left-middle)
		return DEFEND_MIN_HEIGHT, DEFEND_MAX_HEIGHT
	elseif cellX <= zone3End then
		-- Zone 3: Neutral (center)
		return NEUTRAL_MIN_HEIGHT, NEUTRAL_MAX_HEIGHT
	elseif cellX <= zone4End then
		-- Zone 4: Defend (right-middle) - will be mirrored from zone 2
		return DEFEND_MIN_HEIGHT, DEFEND_MAX_HEIGHT
	else
		-- Zone 5: Base (right) - will be mirrored from zone 1
		return BASE_MIN_HEIGHT, BASE_MAX_HEIGHT
	end
end

print("\n📐 Creating terrain sculpting grid...")
print("    Grid size: " .. cellsX .. " x " .. cellsZ .. " voxel cells")
print("    Voxel size: " .. VOXEL_SIZE .. " studs per cell")
print("    Mirror point: X = " .. midX .. " (center column)")
print("    Zones: Base(5-40) | Defend(5-80) | Neutral(5-40) | Defend(5-80) | Base(5-40)")

-- Create height map (generate Base left, Defend left, and Neutral; mirror to right)
local heightMap = {}

-- Generate Base left (Zone 1), Defend left (Zone 2), and Neutral (Zone 3)
print("  🎲 Generating height map (Base left, Defend left, and Neutral zones)...")
for z = 1, cellsZ do
	heightMap[z] = {}
	for x = 1, zone3End do
		local height
		
		-- Get zone-based height range for this cell
		local zoneMin, zoneMax = getZoneHeightRange(x)
		
		-- Determine if this is a cliff
		local isCliff = math.random() < CLIFF_CHANCE
		
		if x == 1 and z == 1 then
			-- Starting point - random height within zone range
			height = math.random() * (zoneMax - zoneMin) + zoneMin
		elseif x == 1 then
			-- First column - smooth from previous row
			local prevHeight = heightMap[z - 1][x]
			-- Get previous cell's zone range for proper clamping
			local prevZoneMin, prevZoneMax = getZoneHeightRange(x)
			prevHeight = math.max(prevZoneMin, math.min(prevHeight, prevZoneMax))
			
			-- Use current zone's range for variation
			local variation = (math.random() - 0.5) * (zoneMax - zoneMin) * (1 - SMOOTHNESS)
			if isCliff then
				variation = variation * CLIFF_INTENSITY
			end
			height = prevHeight + variation
		else
			-- Smooth from previous column (and optionally from previous row for smoother transitions)
			local prevHeightX = heightMap[z][x - 1]
			local prevHeightZ = (z > 1) and heightMap[z - 1][x] or prevHeightX
			
			-- Get previous cells' zone ranges
			local prevXZoneMin, prevXZoneMax = getZoneHeightRange(x - 1)
			local prevZZoneMin, prevZZoneMax = getZoneHeightRange(x)
			
			prevHeightX = math.max(prevXZoneMin, math.min(prevHeightX, prevXZoneMax))
			prevHeightZ = math.max(prevZZoneMin, math.min(prevHeightZ, prevZZoneMax))
			local avgPrevHeight = (prevHeightX + prevHeightZ) / 2
			
			-- Use current zone's range for variation
			local variation = (math.random() - 0.5) * (zoneMax - zoneMin) * (1 - SMOOTHNESS)
			if isCliff then
				variation = variation * CLIFF_INTENSITY
			end
			height = avgPrevHeight + variation
		end
		
		-- Clamp to zone's min/max range
		height = math.max(zoneMin, math.min(height, zoneMax))
		heightMap[z][x] = height
	end
end

-- Mirror Base left (Zone 1) to Base right (Zone 5) and Defend left (Zone 2) to Defend right (Zone 4)
print("  🔄 Mirroring Base and Defend zones (chess-style mirror)...")
for z = 1, cellsZ do
	-- Mirror Zone 4 (Defend right) from Zone 2 (Defend left)
	for x = zone3End + 1, zone4End do
		-- Calculate mirror position: Zone 4 mirrors from Zone 2
		-- Zone 2 is from zone1End+1 to zone2End
		-- Zone 4 is from zone3End+1 to zone4End
		-- Position in Zone 4 maps to corresponding position in Zone 2
		local zone4Pos = x - zone3End  -- Position within Zone 4 (1 to zone4End-zone3End)
		local zone2Width = zone2End - zone1End
		local zone4Width = zone4End - zone3End
		local mirrorX = zone1End + zone2Width - zone4Pos + 1  -- Mirror from right side of Zone 2
		mirrorX = math.max(zone1End + 1, math.min(mirrorX, zone2End))
		
		-- Get zone ranges (both are Defend zones, so same range)
		local mirrorZoneMin, mirrorZoneMax = getZoneHeightRange(mirrorX)
		local zoneMin, zoneMax = getZoneHeightRange(x)
		
		if heightMap[z] and heightMap[z][mirrorX] then
			-- Copy the height directly (same zone type)
			heightMap[z][x] = heightMap[z][mirrorX]
		else
			-- Fallback to zone minimum
			heightMap[z][x] = zoneMin
		end
	end
	
	-- Mirror Zone 5 (Base right) from Zone 1 (Base left)
	for x = zone4End + 1, cellsX do
		-- Calculate mirror position: Zone 5 mirrors from Zone 1
		-- Zone 1 is from 1 to zone1End
		-- Zone 5 is from zone4End+1 to cellsX
		-- Position in Zone 5 maps to corresponding position in Zone 1
		local zone5Pos = x - zone4End  -- Position within Zone 5 (1 to cellsX-zone4End)
		local zone1Width = zone1End
		local zone5Width = cellsX - zone4End
		local mirrorX = zone1Width - zone5Pos + 1  -- Mirror from right side of Zone 1
		mirrorX = math.max(1, math.min(mirrorX, zone1End))
		
		-- Get zone ranges (both are Base zones, so same range)
		local mirrorZoneMin, mirrorZoneMax = getZoneHeightRange(mirrorX)
		local zoneMin, zoneMax = getZoneHeightRange(x)
		
		if heightMap[z] and heightMap[z][mirrorX] then
			-- Copy the height directly (same zone type)
			heightMap[z][x] = heightMap[z][mirrorX]
		else
			-- Fallback to zone minimum
			heightMap[z][x] = zoneMin
		end
	end
end

print("  ✓ Height map generated!")

-- Flatten terrain first before generating new
print("\n🔄 Flattening terrain before generating new...")
-- Clear a much taller region to remove any old high terrain (use highest max height)
local clearHeight = math.max(BASE_MAX_HEIGHT, DEFEND_MAX_HEIGHT, NEUTRAL_MAX_HEIGHT) + 50 -- Clear well above max height to remove old terrain
local clearPosition = Vector3.new(baseplatePos.X, baseplateY + (clearHeight / 2), baseplatePos.Z)
local clearSize = Vector3.new(baseplateSize.X, clearHeight, baseplateSize.Z)
local clearSuccess, clearError = pcall(function()
	-- Clear with Air first (tall region to catch any old high terrain)
	Terrain:FillBlock(CFrame.new(clearPosition), clearSize, Enum.Material.Air)
	
	-- Then fill with flat grass at baseplate level
	local grassThickness = 4
	local grassPosition = Vector3.new(baseplatePos.X, baseplateY, baseplatePos.Z)
	local grassSize = Vector3.new(baseplateSize.X, grassThickness, baseplateSize.Z)
	Terrain:FillBlock(CFrame.new(grassPosition), grassSize, Enum.Material.Grass)
end)

if clearSuccess then
	print("  ✓ Terrain flattened")
else
	warn("  ⚠ Failed to flatten terrain: " .. tostring(clearError))
end

-- Apply terrain sculpting using FillBlock in a grid pattern
print("\n🗻 Applying terrain sculpting...")

-- Now create sculpted terrain using FillBlock in a grid
print("  🎨 Creating sculpted terrain (this may take a moment)...")
local blockCount = 0
-- Terrain columns fill from minimum height (5) up to calculated height

-- Helper function to blend heights at zone boundaries to prevent gaps
local function getBlendedHeight(x, z, baseHeight)
	local zoneMin, zoneMax = getZoneHeightRange(x)
	local height = baseHeight
	
	-- Check if we're at or near a zone boundary (within 1 cell on either side)
	local isAtBoundary = false
	local neighborZoneMin, neighborZoneMax = nil, nil
	
	-- Check left neighbor
	if x > 1 then
		local leftZoneMin, leftZoneMax = getZoneHeightRange(x - 1)
		if leftZoneMin ~= zoneMin or leftZoneMax ~= zoneMax then
			isAtBoundary = true
			neighborZoneMin = leftZoneMin
			neighborZoneMax = leftZoneMax
		end
	end
	
	-- Check right neighbor
	if not isAtBoundary and x < cellsX then
		local rightZoneMin, rightZoneMax = getZoneHeightRange(x + 1)
		if rightZoneMin ~= zoneMin or rightZoneMax ~= zoneMax then
			isAtBoundary = true
			neighborZoneMin = rightZoneMin
			neighborZoneMax = rightZoneMax
		end
	end
	
	-- If at boundary, allow height to extend into neighbor zone range to fill gaps
	-- This keeps the hard edge but ensures no gaps
	if isAtBoundary and neighborZoneMin and neighborZoneMax then
		-- Use the maximum range of both zones to ensure connection
		local maxAllowedHeight = math.max(zoneMax, neighborZoneMax)
		local minAllowedHeight = math.min(zoneMin, neighborZoneMin)
		-- Allow height to extend up to the max of both zones, but not below the min
		height = math.max(minAllowedHeight, math.min(height, maxAllowedHeight))
	end
	
	return height
end

for z = 1, cellsZ do
	for x = 1, cellsX do
		-- Get height from map, fallback to zone minimum
		local zoneMin, zoneMax = getZoneHeightRange(x)
		local height = heightMap[z] and heightMap[z][x] or zoneMin
		
		-- Smooth blending with neighbors for rounded appearance
		if x > 1 and x < cellsX and z > 1 and z < cellsZ then
			local neighborHeights = {}
			if heightMap[z] and heightMap[z][x] then table.insert(neighborHeights, heightMap[z][x]) end
			if heightMap[z] and heightMap[z][x - 1] then table.insert(neighborHeights, heightMap[z][x - 1]) end
			if heightMap[z] and heightMap[z][x + 1] then table.insert(neighborHeights, heightMap[z][x + 1]) end
			if heightMap[z - 1] and heightMap[z - 1][x] then table.insert(neighborHeights, heightMap[z - 1][x]) end
			if heightMap[z + 1] and heightMap[z + 1][x] then table.insert(neighborHeights, heightMap[z + 1][x]) end
			
			if #neighborHeights > 0 then
				local sum = 0
				for _, h in ipairs(neighborHeights) do
					sum = sum + h
				end
				-- More aggressive blending for smoother transitions (70% neighbors, 30% center)
				height = (height * 0.3) + ((sum / #neighborHeights) * 0.7)
			end
		end
		
		-- Apply boundary blending to prevent gaps
		height = getBlendedHeight(x, z, height)
		
		-- Ensure height is at least the minimum of current zone (but can extend into neighbor zone)
		height = math.max(zoneMin, height)
		
		-- Calculate world position for this cell
		local worldX = baseplatePos.X - (baseplateSize.X / 2) + (x - 0.5) * VOXEL_SIZE
		local worldZ = baseplatePos.Z - (baseplateSize.Z / 2) + (z - 0.5) * VOXEL_SIZE
		
		-- Create solid terrain column from minimum height up to calculated height
		-- This fills the entire column from the base to the top
		-- Use the zone's minimum height for this cell
		local zoneMin, zoneMax = getZoneHeightRange(x)
		local columnHeight = height - zoneMin
		local columnCenterY = baseplateY + zoneMin + (columnHeight / 2)
		
		-- Create terrain block that fills the entire column
		local blockPosition = Vector3.new(worldX, columnCenterY, worldZ)
		local blockSize = Vector3.new(VOXEL_SIZE, columnHeight, VOXEL_SIZE)
		
		local blockSuccess, blockError = pcall(function()
			Terrain:FillBlock(CFrame.new(blockPosition), blockSize, Enum.Material.Grass)
		end)
		
		if blockSuccess then
			blockCount = blockCount + 1
		end
	end
end

print("  ✓ Created " .. blockCount .. " terrain blocks")
print("  ✓ Terrain sculpting applied!")

-- Wait a moment for terrain to fully render before adjusting spawns
task.wait(0.2)

-- Adjust spawn locations to sit on top of sculpted terrain using raycasting
print("\n📍 Adjusting spawn locations to sculpted terrain...")
local spawnLocations = {}

-- Search recursively for spawn locations (they might be in folders)
local function findSpawnLocations(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			table.insert(spawnLocations, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			-- Recursively search folders/models
			findSpawnLocations(obj)
		end
	end
end

findSpawnLocations(workspace)

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
			
			-- Determine which zone the spawn is in and get exact terrain height at this cell
			local gridXIndex = math.floor((spawnX - baseplateMinX) / VOXEL_SIZE) + 1
			local gridZIndex = math.floor((spawnZ - baseplateMinZ) / VOXEL_SIZE) + 1
			gridXIndex = math.max(1, math.min(gridXIndex, cellsX))
			gridZIndex = math.max(1, math.min(gridZIndex, cellsZ))
			
			local spawnZoneMin, spawnZoneMax = getZoneHeightRange(gridXIndex)
			local height = spawnZoneMin
			
			-- Check if spawn is in a base zone (zone 1 or zone 5)
			local zoneWidth = cellsX / 5
			local zone1End = math.floor(zoneWidth)
			local zone4End = math.floor(zoneWidth * 4)
			local isBaseZone = (gridXIndex <= zone1End) or (gridXIndex > zone4End)
			
			if isBaseZone then
				-- Spawn is in base zone - use maximum height for base zone
				height = BASE_MAX_HEIGHT
			else
				-- Spawn is in defend or neutral zone - use height map from this specific cell
				if heightMap[gridZIndex] and heightMap[gridZIndex][gridXIndex] then
					height = heightMap[gridZIndex][gridXIndex]
				end
			end
			
			-- Position spawn 10 studs above the terrain top in this specific cell
			-- Terrain columns are created with center at baseplateY + zoneMin + (height-zoneMin)/2
			-- Top of column = center + (height-zoneMin)/2 = baseplateY + zoneMin + (height-zoneMin)/2 + (height-zoneMin)/2 = baseplateY + height
			-- So terrain surface top is at baseplateY + height
			local terrainTopY = baseplateY + height
			local targetY = terrainTopY + 10 -- 10 studs above terrain top in this cell
			
			-- Ensure spawn can fall (unanchor and enable collision)
			spawnLoc.Anchored = false
			spawnLoc.CanCollide = true -- Enable collision so it can land on terrain
			
			-- Wait for a physics frame to ensure unanchor is processed
			RunService.Heartbeat:Wait()
			
			-- Place spawn high above target position so it has room to fall
			local dropY = targetY + 100 -- Start 100 studs above target
			spawnLoc.CFrame = CFrame.new(spawnX, dropY, spawnZ)
			
			-- Wait another frame to ensure position is set
			RunService.Heartbeat:Wait()
			
			-- Get initial position for debug output
			local finalY = spawnLoc.Position.Y
			
			-- Debug output
			if isBaseZone then
				print("  ✓ Adjusted " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", finalY) .. " (cell [" .. gridXIndex .. "," .. gridZIndex .. "], baseplateY: " .. string.format("%.2f", baseplateY) .. ", height: " .. BASE_MAX_HEIGHT .. ", terrainTop: " .. string.format("%.2f", terrainTopY) .. ", target: " .. string.format("%.2f", targetY) .. ")")
			else
				print("  ✓ Adjusted " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", finalY) .. " (cell [" .. gridXIndex .. "," .. gridZIndex .. "], baseplateY: " .. string.format("%.2f", baseplateY) .. ", height: " .. string.format("%.2f", height) .. ", terrainTop: " .. string.format("%.2f", terrainTopY) .. ", target: " .. string.format("%.2f", targetY) .. ")")
			end
		else
			print("  ⚠ " .. spawnLoc.Name .. " is outside baseplate bounds, skipping")
		end
	end
else
	print("  No spawn locations found")
end

print("\n✅ Terrain sculpting complete!")
print("💡 Zone-based height ranges:")
print("   - Base areas: " .. BASE_MIN_HEIGHT .. " to " .. BASE_MAX_HEIGHT .. " studs")
print("   - Defend areas: " .. DEFEND_MIN_HEIGHT .. " to " .. DEFEND_MAX_HEIGHT .. " studs")
print("   - Neutral area: " .. NEUTRAL_MIN_HEIGHT .. " to " .. NEUTRAL_MAX_HEIGHT .. " studs")
print("💡 Smoothness: " .. (SMOOTHNESS * 100) .. "%")
print("💡 Mirror point: X = " .. midX .. " (center column)")
print("💡 Using Terrain API for smooth, rounded terrain")
print("💡 To adjust: Change zone height ranges at top of script")

