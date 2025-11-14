-- Command Bar script to remove and regenerate terrain, walls, and ceiling to match baseplate
-- This will completely rebuild the map to match the current baseplate orientation

print("=== Regenerating Map to Match Baseplate ===")
print("")
print("This will:")
print("  1. Remove all existing terrain")
print("  2. Remove existing walls and ceiling")
print("  3. Regenerate terrain to match baseplate")
print("  4. Regenerate walls and ceiling to match baseplate")
print("")

local Terrain = workspace.Terrain
local RunService = game:GetService("RunService")

-- Find baseplate
local function findBaseplateRecursive(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("Part") and child.Name:find("Baseplate") then
			return child
		elseif child:IsA("Model") or child:IsA("Folder") then
			local found = findBaseplateRecursive(child)
			if found then
				return found
			end
		end
	end
	return nil
end

local baseplate = findBaseplateRecursive(workspace)
if not baseplate then
	warn("⚠ Baseplate not found!")
	return
end

print("  ✓ Found baseplate: " .. baseplate.Name)
print("    Position: " .. tostring(baseplate.Position))
print("    Size: " .. tostring(baseplate.Size))
print("    Rotation: " .. tostring(baseplate.Orientation))
print("")

-- STEP 0: Store spawn location relative positions BEFORE any terrain operations
print("STEP 0: Storing spawn location relative positions...")
local baseplatePos = baseplate.Position
local spawnRelativePositions = {} -- Store relative positions before any changes
local spawnCount = 0

local function findSpawnLocationsForStorage(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			local relativeX = obj.Position.X - baseplatePos.X
			local relativeZ = obj.Position.Z - baseplatePos.Z
			spawnRelativePositions[obj] = {
				relativeX = relativeX,
				relativeZ = relativeZ,
				name = obj.Name,
				originalPosition = obj.Position -- Store original for reference
			}
			spawnCount = spawnCount + 1
			print("  ✓ Stored relative position for " .. obj.Name .. " (relative X: " .. string.format("%.2f", relativeX) .. ", Z: " .. string.format("%.2f", relativeZ) .. ")")
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findSpawnLocationsForStorage(obj)
		end
	end
end
findSpawnLocationsForStorage(workspace)
print("  ✓ Stored " .. spawnCount .. " spawn location relative position(s)")
print("")

-- STEP 1: Remove all existing terrain
print("STEP 1: Removing existing terrain...")
local baseplateY = baseplate.Position.Y
local baseplateTop = baseplateY + (baseplate.Size.Y / 2)

-- Clear a large region to remove all terrain
local clearMin = baseplate.Position - baseplate.Size / 2 - Vector3.new(100, 200, 100)
local clearMax = baseplate.Position + baseplate.Size / 2 + Vector3.new(100, 200, 100)
local clearRegion = Region3.new(clearMin, clearMax)

local success = pcall(function()
	Terrain:FillBlock(CFrame.new(clearMin:lerp(clearMax, 0.5)), (clearMax - clearMin), Enum.Material.Air)
end)

if success then
	print("  ✓ Cleared terrain region")
else
	print("  ⚠ FillBlock failed, trying alternative method...")
	-- Alternative: Use WriteVoxels in a grid
	local voxelSize = 4
	for x = clearMin.X, clearMax.X, voxelSize * 4 do
		for y = clearMin.Y, clearMax.Y, voxelSize * 4 do
			for z = clearMin.Z, clearMax.Z, voxelSize * 4 do
				pcall(function()
					local region = Region3.new(
						Vector3.new(x, y, z),
						Vector3.new(x + voxelSize * 4, y + voxelSize * 4, z + voxelSize * 4)
					)
					Terrain:FillBlock(CFrame.new(region.CFrame.Position), region.Size, Enum.Material.Air)
				end)
			end
		end
	end
	print("  ✓ Cleared terrain (alternative method)")
end

print("")

-- STEP 2: Remove existing walls and ceiling
print("STEP 2: Removing existing walls and ceiling...")
local wallsFolder = workspace:FindFirstChild("Walls")
if wallsFolder then
	local deletedCount = 0
	for _, child in ipairs(wallsFolder:GetChildren()) do
		child:Destroy()
		deletedCount = deletedCount + 1
	end
	print("  ✓ Deleted " .. deletedCount .. " wall/ceiling object(s)")
else
	print("  ✓ No existing Walls folder found")
end
print("")

-- STEP 3: Regenerate terrain (using baseplate's current position and size)
print("STEP 3: Regenerating terrain to match baseplate...")
print("")

local baseplateSize = baseplate.Size
-- baseplatePos already defined in STEP 0
local baseplateY = baseplatePos.Y
local baseplateTop = baseplateY + (baseplateSize.Y / 2)

-- Configuration (from SculptTerrain_CommandBar.lua)
local BASE_MIN_HEIGHT = 10
local BASE_MAX_HEIGHT = 40
local DEFEND_MIN_HEIGHT = 30
local DEFEND_MAX_HEIGHT = 80
local NEUTRAL_MIN_HEIGHT = 10
local NEUTRAL_MAX_HEIGHT = 40

local SMOOTHNESS = 0.85
local CLIFF_CHANCE = 0.1
local CLIFF_INTENSITY = 3.0
local VOXEL_RESOLUTION = 4
local VOXEL_SIZE = 4
local WALL_MARGIN = 8

-- Calculate grid dimensions
local effectiveSizeX = baseplateSize.X - (WALL_MARGIN * 2)
local effectiveSizeZ = baseplateSize.Z - (WALL_MARGIN * 2)
local cellsX = math.ceil(effectiveSizeX / VOXEL_SIZE)
local cellsZ = math.ceil(effectiveSizeZ / VOXEL_SIZE)
local midX = math.floor(cellsX / 2)

-- Divide into 5 zones
local zoneWidth = cellsX / 5
local zone1End = math.floor(zoneWidth)
local zone2End = math.floor(zoneWidth * 2)
local zone3End = math.floor(zoneWidth * 3)
local zone4End = math.floor(zoneWidth * 4)

-- Function to get zone-based height range
local function getZoneHeightRange(cellX)
	if cellX <= zone1End then
		return BASE_MIN_HEIGHT, BASE_MAX_HEIGHT
	elseif cellX <= zone2End then
		return DEFEND_MIN_HEIGHT, DEFEND_MAX_HEIGHT
	elseif cellX <= zone3End then
		return NEUTRAL_MIN_HEIGHT, NEUTRAL_MAX_HEIGHT
	elseif cellX <= zone4End then
		return DEFEND_MIN_HEIGHT, DEFEND_MAX_HEIGHT
	else
		return BASE_MIN_HEIGHT, BASE_MAX_HEIGHT
	end
end

print("  Grid size: " .. cellsX .. " x " .. cellsZ .. " voxel cells")
print("  Mirror point: X = " .. midX)
print("")

-- Flatten terrain first
print("  Flattening terrain before generating new...")
local CLEAR_TOP_Y = 100
local CLEAR_BOTTOM_Y = -100
local clearHeight = CLEAR_TOP_Y - CLEAR_BOTTOM_Y
local clearPosition = Vector3.new(baseplatePos.X, (CLEAR_TOP_Y + CLEAR_BOTTOM_Y) / 2, baseplatePos.Z)
local clearSize = Vector3.new(baseplateSize.X + 100, clearHeight, baseplateSize.Z + 100)

local clearSuccess = pcall(function()
	Terrain:FillBlock(CFrame.new(clearPosition), clearSize, Enum.Material.Air)
	local grassThickness = 4
	local grassPosition = Vector3.new(baseplatePos.X, baseplateY, baseplatePos.Z)
	local grassSize = Vector3.new(baseplateSize.X, grassThickness, baseplateSize.Z)
	Terrain:FillBlock(CFrame.new(grassPosition), grassSize, Enum.Material.Grass)
end)

if clearSuccess then
	print("  ✓ Terrain flattened")
else
	warn("  ⚠ Failed to flatten terrain")
end

-- Generate height map
print("  Generating height map...")
local heightMap = {}

-- Generate Base left (Zone 1), Defend left (Zone 2), and Neutral (Zone 3)
for z = 1, cellsZ do
	heightMap[z] = {}
	for x = 1, zone3End do
		local height
		local zoneMin, zoneMax = getZoneHeightRange(x)
		local isCliff = math.random() < CLIFF_CHANCE
		
		if x == 1 and z == 1 then
			height = math.random() * (zoneMax - zoneMin) + zoneMin
		elseif x == 1 then
			local prevHeight = heightMap[z - 1][x]
			local prevZoneMin, prevZoneMax = getZoneHeightRange(x)
			prevHeight = math.max(prevZoneMin, math.min(prevHeight, prevZoneMax))
			local variation = (math.random() - 0.5) * (zoneMax - zoneMin) * (1 - SMOOTHNESS)
			if isCliff then
				variation = variation * CLIFF_INTENSITY
			end
			height = prevHeight + variation
		else
			local prevHeightX = heightMap[z][x - 1]
			local prevHeightZ = (z > 1) and heightMap[z - 1][x] or prevHeightX
			local prevXZoneMin, prevXZoneMax = getZoneHeightRange(x - 1)
			local prevZZoneMin, prevZZoneMax = getZoneHeightRange(x)
			prevHeightX = math.max(prevXZoneMin, math.min(prevHeightX, prevXZoneMax))
			prevHeightZ = math.max(prevZZoneMin, math.min(prevHeightZ, prevZZoneMax))
			local avgPrevHeight = (prevHeightX + prevHeightZ) / 2
			local variation = (math.random() - 0.5) * (zoneMax - zoneMin) * (1 - SMOOTHNESS)
			if isCliff then
				variation = variation * CLIFF_INTENSITY
			end
			height = avgPrevHeight + variation
		end
		
		height = math.max(zoneMin, math.min(height, zoneMax))
		heightMap[z][x] = height
	end
end

-- Mirror zones (chess-style)
print("  Mirroring zones...")
for z = 1, cellsZ do
	-- Mirror Zone 4 (Defend right) from Zone 2 (Defend left)
	for x = zone3End + 1, zone4End do
		local zone4Pos = x - zone3End
		local zone2Width = zone2End - zone1End
		local zone4Width = zone4End - zone3End
		local mirrorX = zone1End + zone2Width - zone4Pos + 1
		mirrorX = math.max(zone1End + 1, math.min(mirrorX, zone2End))
		
		if heightMap[z] and heightMap[z][mirrorX] then
			heightMap[z][x] = heightMap[z][mirrorX]
		else
			local zoneMin, zoneMax = getZoneHeightRange(x)
			heightMap[z][x] = zoneMin
		end
	end
	
	-- Mirror Zone 5 (Base right) from Zone 1 (Base left)
	for x = zone4End + 1, cellsX do
		local zone5Pos = x - zone4End
		local zone1Width = zone1End
		local zone5Width = cellsX - zone4End
		local mirrorX = zone1Width - zone5Pos + 1
		mirrorX = math.max(1, math.min(mirrorX, zone1End))
		
		if heightMap[z] and heightMap[z][mirrorX] then
			heightMap[z][x] = heightMap[z][mirrorX]
		else
			local zoneMin, zoneMax = getZoneHeightRange(x)
			heightMap[z][x] = zoneMin
		end
	end
end

-- Helper function to blend heights at zone boundaries
local function getBlendedHeight(x, z, baseHeight)
	local zoneMin, zoneMax = getZoneHeightRange(x)
	local height = baseHeight
	local isAtBoundary = false
	local neighborZoneMin, neighborZoneMax = nil, nil
	
	if x > 1 then
		local leftZoneMin, leftZoneMax = getZoneHeightRange(x - 1)
		if leftZoneMin ~= zoneMin or leftZoneMax ~= zoneMax then
			isAtBoundary = true
			neighborZoneMin = leftZoneMin
			neighborZoneMax = leftZoneMax
		end
	end
	
	if not isAtBoundary and x < cellsX then
		local rightZoneMin, rightZoneMax = getZoneHeightRange(x + 1)
		if rightZoneMin ~= zoneMin or rightZoneMax ~= zoneMax then
			isAtBoundary = true
			neighborZoneMin = rightZoneMin
			neighborZoneMax = rightZoneMax
		end
	end
	
	if isAtBoundary and neighborZoneMin and neighborZoneMax then
		local maxAllowedHeight = math.max(zoneMax, neighborZoneMax)
		local minAllowedHeight = math.min(zoneMin, neighborZoneMin)
		height = math.max(minAllowedHeight, math.min(height, maxAllowedHeight))
	end
	
	return height
end

-- Generate terrain blocks
print("  Creating terrain blocks...")
local blockCount = 0

for z = 1, cellsZ do
	for x = 1, cellsX do
		local zoneMin, zoneMax = getZoneHeightRange(x)
		local height = heightMap[z] and heightMap[z][x] or zoneMin
		
		-- Smooth blending with neighbors
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
				height = (height * 0.3) + ((sum / #neighborHeights) * 0.7)
			end
		end
		
		height = getBlendedHeight(x, z, height)
		height = math.max(zoneMin, height)
		
		-- Calculate world position (with wall margin offset)
		local worldX = baseplatePos.X - (baseplateSize.X / 2) + WALL_MARGIN + (x - 0.5) * VOXEL_SIZE
		local worldZ = baseplatePos.Z - (baseplateSize.Z / 2) + WALL_MARGIN + (z - 0.5) * VOXEL_SIZE
		
		-- Create solid terrain column
		local columnBottomY = baseplateTop
		local columnTopY = baseplateTop + height
		local columnHeight = columnTopY - columnBottomY
		local columnCenterY = columnBottomY + (columnHeight / 2)
		
		local blockPosition = Vector3.new(worldX, columnCenterY, worldZ)
		local blockSize = Vector3.new(VOXEL_SIZE, columnHeight, VOXEL_SIZE)
		
		local blockSuccess = pcall(function()
			Terrain:FillBlock(CFrame.new(blockPosition), blockSize, Enum.Material.Grass)
		end)
		
		if blockSuccess then
			blockCount = blockCount + 1
		end
	end
end

print("  ✓ Created " .. blockCount .. " terrain blocks")

-- Fill margin areas with flat terrain (aligned to voxel grid)
print("  Filling edge margins (aligned to grid)...")
local marginFillCount = 0
local marginHeight = 4 -- Height of margin fill terrain

-- Calculate margin boundaries aligned to voxel grid
local baseplateMinX = baseplatePos.X - (baseplateSize.X / 2)
local baseplateMaxX = baseplatePos.X + (baseplateSize.X / 2)
local baseplateMinZ = baseplatePos.Z - (baseplateSize.Z / 2)
local baseplateMaxZ = baseplatePos.Z + (baseplateSize.Z / 2)

-- Terrain boundaries (where terrain ends - aligned to voxel grid)
-- Snap terrain boundaries to voxel grid to ensure perfect alignment
local terrainStartX = baseplateMinX + WALL_MARGIN
local terrainEndX = baseplateMaxX - WALL_MARGIN
local terrainStartZ = baseplateMinZ + WALL_MARGIN
local terrainEndZ = baseplateMaxZ - WALL_MARGIN

-- Snap to nearest voxel grid boundary
local terrainMinX = math.floor(terrainStartX / VOXEL_SIZE) * VOXEL_SIZE
local terrainMaxX = math.ceil(terrainEndX / VOXEL_SIZE) * VOXEL_SIZE
local terrainMinZ = math.floor(terrainStartZ / VOXEL_SIZE) * VOXEL_SIZE
local terrainMaxZ = math.ceil(terrainEndZ / VOXEL_SIZE) * VOXEL_SIZE

-- Fill margins in voxel-sized blocks, aligned to grid boundaries
-- North margin (positive Z) - from terrain edge to baseplate edge
local northMarginStartZ = terrainMaxZ
local northMarginEndZ = baseplateMaxZ
-- Snap start to grid
northMarginStartZ = math.floor(northMarginStartZ / VOXEL_SIZE) * VOXEL_SIZE
-- Fill in complete voxel blocks
local northMarginBlocks = math.ceil((northMarginEndZ - northMarginStartZ) / VOXEL_SIZE)
for i = 0, northMarginBlocks - 1 do
	local blockZStart = northMarginStartZ + (i * VOXEL_SIZE)
	local blockZEnd = math.min(blockZStart + VOXEL_SIZE, northMarginEndZ)
	local blockZCenter = (blockZStart + blockZEnd) / 2
	local blockX = baseplatePos.X
	local blockPosition = Vector3.new(blockX, baseplateTop + (marginHeight / 2), blockZCenter)
	local blockSize = Vector3.new(baseplateSize.X, marginHeight, blockZEnd - blockZStart)
	if pcall(function() Terrain:FillBlock(CFrame.new(blockPosition), blockSize, Enum.Material.Grass) end) then
		marginFillCount = marginFillCount + 1
	end
end

-- South margin (negative Z) - from baseplate edge to terrain edge
local southMarginStartZ = baseplateMinZ
local southMarginEndZ = terrainMinZ
-- Snap end to grid
southMarginEndZ = math.ceil(southMarginEndZ / VOXEL_SIZE) * VOXEL_SIZE
local southMarginBlocks = math.ceil((southMarginEndZ - southMarginStartZ) / VOXEL_SIZE)
for i = 0, southMarginBlocks - 1 do
	local blockZStart = southMarginStartZ + (i * VOXEL_SIZE)
	local blockZEnd = math.min(blockZStart + VOXEL_SIZE, southMarginEndZ)
	local blockZCenter = (blockZStart + blockZEnd) / 2
	local blockX = baseplatePos.X
	local blockPosition = Vector3.new(blockX, baseplateTop + (marginHeight / 2), blockZCenter)
	local blockSize = Vector3.new(baseplateSize.X, marginHeight, blockZEnd - blockZStart)
	if pcall(function() Terrain:FillBlock(CFrame.new(blockPosition), blockSize, Enum.Material.Grass) end) then
		marginFillCount = marginFillCount + 1
	end
end

-- East margin (positive X) - from terrain edge to baseplate edge
local eastMarginStartX = terrainMaxX
local eastMarginEndX = baseplateMaxX
-- Snap start to grid
eastMarginStartX = math.floor(eastMarginStartX / VOXEL_SIZE) * VOXEL_SIZE
local eastMarginBlocks = math.ceil((eastMarginEndX - eastMarginStartX) / VOXEL_SIZE)
for i = 0, eastMarginBlocks - 1 do
	local blockXStart = eastMarginStartX + (i * VOXEL_SIZE)
	local blockXEnd = math.min(blockXStart + VOXEL_SIZE, eastMarginEndX)
	local blockXCenter = (blockXStart + blockXEnd) / 2
	local blockZ = baseplatePos.Z
	local blockPosition = Vector3.new(blockXCenter, baseplateTop + (marginHeight / 2), blockZ)
	local blockSize = Vector3.new(blockXEnd - blockXStart, marginHeight, baseplateSize.Z)
	if pcall(function() Terrain:FillBlock(CFrame.new(blockPosition), blockSize, Enum.Material.Grass) end) then
		marginFillCount = marginFillCount + 1
	end
end

-- West margin (negative X) - from baseplate edge to terrain edge
local westMarginStartX = baseplateMinX
local westMarginEndX = terrainMinX
-- Snap end to grid
westMarginEndX = math.ceil(westMarginEndX / VOXEL_SIZE) * VOXEL_SIZE
local westMarginBlocks = math.ceil((westMarginEndX - westMarginStartX) / VOXEL_SIZE)
for i = 0, westMarginBlocks - 1 do
	local blockXStart = westMarginStartX + (i * VOXEL_SIZE)
	local blockXEnd = math.min(blockXStart + VOXEL_SIZE, westMarginEndX)
	local blockXCenter = (blockXStart + blockXEnd) / 2
	local blockZ = baseplatePos.Z
	local blockPosition = Vector3.new(blockXCenter, baseplateTop + (marginHeight / 2), blockZ)
	local blockSize = Vector3.new(blockXEnd - blockXStart, marginHeight, baseplateSize.Z)
	if pcall(function() Terrain:FillBlock(CFrame.new(blockPosition), blockSize, Enum.Material.Grass) end) then
		marginFillCount = marginFillCount + 1
	end
end

print("  ✓ Filled " .. marginFillCount .. " margin blocks (aligned to grid)")
print("")

-- STEP 3.5: Restore spawn locations with relative positions
print("STEP 3.5: Adjusting spawn locations to terrain (preserving relative positions)...")

local spawnLocations = {}

-- Search recursively for spawn locations
local function findSpawnLocations(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			table.insert(spawnLocations, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findSpawnLocations(obj)
		end
	end
end

findSpawnLocations(workspace)

if #spawnLocations > 0 then
	print("  Found " .. #spawnLocations .. " spawn location(s)")
	
	-- Restore relative positions (stored at start of script) and adjust Y to terrain height
	for _, spawnLoc in ipairs(spawnLocations) do
		local relativePos = spawnRelativePositions[spawnLoc]
		if not relativePos then
			-- Fallback to current position if not stored
			relativePos = {
				relativeX = spawnLoc.Position.X - baseplatePos.X,
				relativeZ = spawnLoc.Position.Z - baseplatePos.Z,
				name = spawnLoc.Name
			}
		end
		
		-- Restore relative X/Z position
		local spawnX = baseplatePos.X + relativePos.relativeX
		local spawnZ = baseplatePos.Z + relativePos.relativeZ
		
		-- Check if spawn is within baseplate bounds
		local baseplateMinX = baseplatePos.X - (baseplateSize.X / 2)
		local baseplateMaxX = baseplatePos.X + (baseplateSize.X / 2)
		local baseplateMinZ = baseplatePos.Z - (baseplateSize.Z / 2)
		local baseplateMaxZ = baseplatePos.Z + (baseplateSize.Z / 2)
		
		if spawnX >= baseplateMinX and spawnX <= baseplateMaxX and
		   spawnZ >= baseplateMinZ and spawnZ <= baseplateMaxZ then
			
			-- Determine which zone the spawn is in and get exact terrain height at this cell
			-- Account for WALL_MARGIN offset
			local adjustedSpawnX = spawnX - baseplateMinX - WALL_MARGIN
			local adjustedSpawnZ = spawnZ - baseplateMinZ - WALL_MARGIN
			local gridXIndex = math.floor(adjustedSpawnX / VOXEL_SIZE) + 1
			local gridZIndex = math.floor(adjustedSpawnZ / VOXEL_SIZE) + 1
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
			
			-- Position spawn 10 studs above the terrain top
			local terrainTopY = baseplateTop + height
			local targetY = terrainTopY + 10 -- 10 studs above terrain top
			
			-- Set spawn properties (anchored, no collision as per user preference)
			spawnLoc.Anchored = true
			spawnLoc.CanCollide = false
			spawnLoc.Transparency = 0 -- Ensure spawn is visible
			spawnLoc.Enabled = true -- Ensure spawn is enabled
			
			-- Place spawn at relative position with adjusted Y
			spawnLoc.CFrame = CFrame.new(spawnX, targetY, spawnZ)
			
			local finalY = spawnLoc.Position.Y
			
			-- Debug output
			if isBaseZone then
				print("  ✓ Adjusted " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", finalY) .. " (relative X: " .. string.format("%.2f", relativePos.relativeX) .. ", Z: " .. string.format("%.2f", relativePos.relativeZ) .. ", cell [" .. gridXIndex .. "," .. gridZIndex .. "], height: " .. BASE_MAX_HEIGHT .. ")")
			else
				print("  ✓ Adjusted " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", finalY) .. " (relative X: " .. string.format("%.2f", relativePos.relativeX) .. ", Z: " .. string.format("%.2f", relativePos.relativeZ) .. ", cell [" .. gridXIndex .. "," .. gridZIndex .. "], height: " .. string.format("%.2f", height) .. ")")
			end
		else
			-- Spawn is outside baseplate bounds - still restore relative position but don't adjust Y
			local relativePos = spawnRelativePositions[spawnLoc]
			if relativePos then
				local spawnX = baseplatePos.X + relativePos.relativeX
				local spawnZ = baseplatePos.Z + relativePos.relativeZ
				spawnLoc.CFrame = CFrame.new(spawnX, spawnLoc.Position.Y, spawnZ)
				spawnLoc.Transparency = 0 -- Ensure spawn is visible
				spawnLoc.Enabled = true -- Ensure spawn is enabled
				print("  ✓ Restored " .. spawnLoc.Name .. " to relative position (outside baseplate, Y unchanged)")
			else
				print("  ⚠ " .. spawnLoc.Name .. " is outside baseplate bounds and no relative position stored, skipping")
			end
		end
		
		-- Ensure spawn is visible and enabled (for all spawns, inside or outside baseplate)
		spawnLoc.Transparency = 0
		spawnLoc.Enabled = true
		
		-- If DefaultSpawnLocation exists and Spawn Room model exists, parent it to the model
		if spawnLoc.Name == "DefaultSpawnLocation" then
			local spawnRoom = workspace:FindFirstChild("Spawn Room")
			if spawnRoom and spawnRoom:IsA("Model") then
				spawnLoc.Parent = spawnRoom
				print("  ✓ Parented DefaultSpawnLocation to Spawn Room model")
			end
		end
	end
else
	print("  No spawn locations found")
end

print("")

-- STEP 4: Regenerate walls and ceiling
print("STEP 4: Regenerating walls and ceiling...")

-- Create or get Walls folder
local wallsFolder = workspace:FindFirstChild("Walls")
if not wallsFolder then
	wallsFolder = Instance.new("Folder")
	wallsFolder.Name = "Walls"
	wallsFolder.Parent = workspace
end

-- Wall configuration
local wallHeight = 150
local wallThickness = 2
local wallMaterial = Enum.Material.Brick
local wallColor = BrickColor.new("Dark stone grey")

-- Use baseplate's CFrame to properly handle rotation
local baseplateCF = baseplate.CFrame
local baseplateSizeX = baseplate.Size.X
local baseplateSizeZ = baseplate.Size.Z
local halfSizeX = baseplateSizeX / 2
local halfSizeZ = baseplateSizeZ / 2

-- Calculate terrain boundaries (where terrain ends - 8 studs in from baseplate edge)
local terrainMinX = baseplatePos.X - halfSizeX + WALL_MARGIN
local terrainMaxX = baseplatePos.X + halfSizeX - WALL_MARGIN
local terrainMinZ = baseplatePos.Z - halfSizeZ + WALL_MARGIN
local terrainMaxZ = baseplatePos.Z + halfSizeZ - WALL_MARGIN

-- Calculate wall positions in world space (terrain is world-aligned)
-- North Wall (positive Z) - positioned at terrain edge, extends to baseplate edge
local northWallX = baseplatePos.X
local northWallZ = terrainMaxZ + (wallThickness / 2) -- At terrain edge, slightly outward
local northWallWidth = baseplateSizeX + (wallThickness * 2) -- Spans full baseplate width
local northWall = Instance.new("Part")
northWall.Name = "NorthWall"
northWall.Size = Vector3.new(northWallWidth, wallHeight, wallThickness)
northWall.Position = Vector3.new(northWallX, baseplateTop + (wallHeight / 2), northWallZ)
northWall.Anchored = true
northWall.CanCollide = true
northWall.Material = wallMaterial
northWall.BrickColor = wallColor
northWall.CastShadow = true
northWall.Parent = wallsFolder

-- South Wall (negative Z) - positioned at terrain edge, extends to baseplate edge
local southWallX = baseplatePos.X
local southWallZ = terrainMinZ - (wallThickness / 2) -- At terrain edge, slightly outward
local southWallWidth = baseplateSizeX + (wallThickness * 2) -- Spans full baseplate width
local southWall = Instance.new("Part")
southWall.Name = "SouthWall"
southWall.Size = Vector3.new(southWallWidth, wallHeight, wallThickness)
southWall.Position = Vector3.new(southWallX, baseplateTop + (wallHeight / 2), southWallZ)
southWall.Anchored = true
southWall.CanCollide = true
southWall.Material = wallMaterial
southWall.BrickColor = wallColor
southWall.CastShadow = true
southWall.Parent = wallsFolder

-- East Wall (positive X) - positioned at terrain edge, extends to baseplate edge
local eastWallX = terrainMaxX + (wallThickness / 2) -- At terrain edge, slightly outward
local eastWallZ = baseplatePos.Z
local eastWallDepth = baseplateSizeZ -- Spans full baseplate depth
local eastWall = Instance.new("Part")
eastWall.Name = "EastWall"
eastWall.Size = Vector3.new(wallThickness, wallHeight, eastWallDepth)
eastWall.Position = Vector3.new(eastWallX, baseplateTop + (wallHeight / 2), eastWallZ)
eastWall.Anchored = true
eastWall.CanCollide = true
eastWall.Material = wallMaterial
eastWall.BrickColor = wallColor
eastWall.CastShadow = true
eastWall.Parent = wallsFolder

-- West Wall (negative X) - positioned at terrain edge, extends to baseplate edge
local westWallX = terrainMinX - (wallThickness / 2) -- At terrain edge, slightly outward
local westWallZ = baseplatePos.Z
local westWallDepth = baseplateSizeZ -- Spans full baseplate depth
local westWall = Instance.new("Part")
westWall.Name = "WestWall"
westWall.Size = Vector3.new(wallThickness, wallHeight, westWallDepth)
westWall.Position = Vector3.new(westWallX, baseplateTop + (wallHeight / 2), westWallZ)
westWall.Anchored = true
westWall.CanCollide = true
westWall.Material = wallMaterial
westWall.BrickColor = wallColor
westWall.CastShadow = true
westWall.Parent = wallsFolder

-- Roof/Ceiling (Glass)
local roof = Instance.new("Part")
roof.Name = "Roof"
roof.Size = Vector3.new(baseplateSizeX, 1, baseplateSizeZ)
roof.CFrame = baseplateCF * CFrame.new(0, wallHeight, 0) * CFrame.Angles(0, 0, 0)
roof.Anchored = true
roof.CanCollide = true
roof.Material = Enum.Material.Glass -- Glass material for light
roof.BrickColor = BrickColor.new("Light blue") -- Light blue tint for glass
roof.Transparency = 0.3 -- Slightly transparent
roof.CastShadow = false -- Roof doesn't cast shadows
roof.Parent = wallsFolder

print("  ✓ Created 4 walls and 1 glass ceiling/roof")
print("  ✓ Walls positioned at terrain edges, aligned with baseplate rotation")
print("")

print("=" .. string.rep("=", 60))
print("✅ Map regeneration complete!")
print("=" .. string.rep("=", 60))
print("")
print("  ✓ Terrain regenerated to match baseplate")
print("  ✓ Walls regenerated to match baseplate")
print("  ✓ Ceiling/roof regenerated to match baseplate")
print("")
print("💡 All map elements are now aligned with the baseplate orientation")
print("")

