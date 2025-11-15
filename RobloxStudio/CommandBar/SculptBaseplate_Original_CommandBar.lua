-- SCULPT BASEPLATE - Command Bar Script
-- Paste this into Roblox Studio Command Bar
-- This script automatically sculpts the Baseplate
-- Creates a mirror-image sculpted terrain from the center

print("=== Baseplate Sculpting Script ===")

-- Configuration
local MIN_HEIGHT = -5 -- Minimum height variation (studs below baseplate)
local MAX_HEIGHT = 20 -- Maximum height variation (studs above baseplate)
local SMOOTHNESS = 0.7 -- 0.0 = very random, 1.0 = very smooth (0.7 = mostly smooth with some variation)
local CLIFF_CHANCE = 0.1 -- 10% chance for a cliff (steep change)
local CLIFF_INTENSITY = 2.0 -- How dramatic cliffs are (multiplier)
local GRID_SIZE = 8 -- Size of each grid cell in studs (smaller = more detail, but slower and more parts)

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

-- Reset to flat: Delete any existing sculpted baseplate and restore original
print("\n🔄 Resetting baseplate to flat...")
local existingSculpted = workspace:FindFirstChild("SculptedBaseplate")
if existingSculpted then
	existingSculpted:Destroy()
	print("  ✓ Deleted existing sculpted baseplate")
end

-- Restore original baseplate visibility and properties
baseplate.Transparency = 0
baseplate.CanCollide = true
baseplate.CanQuery = true
baseplate.CanTouch = true
print("  ✓ Restored original baseplate to flat/visible")

-- Store original properties
local originalMaterial = baseplate.Material
local originalColor = baseplate.Color
local originalBrickColor = baseplate.BrickColor
local originalAnchored = baseplate.Anchored
local originalCanCollide = baseplate.CanCollide

local baseplateSize = baseplate.Size
local baseplatePos = baseplate.Position
local baseplateY = baseplatePos.Y
local baseplateTop = baseplateY + (baseplateSize.Y / 2)

-- Calculate grid dimensions
local gridX = math.ceil(baseplateSize.X / GRID_SIZE)
local gridZ = math.ceil(baseplateSize.Z / GRID_SIZE)
local midX = math.floor(gridX / 2) -- Midpoint for mirroring

print("\n📐 Creating sculpting grid...")
print("    Grid size: " .. gridX .. " x " .. gridZ .. " cells")
print("    Cell size: " .. GRID_SIZE .. " studs")
print("    Mirror point: X = " .. midX .. " (center column)")

-- Create height map (only for left half, will mirror to right)
local heightMap = {}

-- Generate left half of the map
print("  🎲 Generating height map (left half)...")
for z = 1, gridZ do
	heightMap[z] = {}
	for x = 1, midX do
		local height
		
		-- Determine if this is a cliff
		local isCliff = math.random() < CLIFF_CHANCE
		
		if x == 1 and z == 1 then
			-- Starting point - random height
			height = math.random() * (MAX_HEIGHT - MIN_HEIGHT) + MIN_HEIGHT
		elseif x == 1 then
			-- First column - smooth from previous row
			local prevHeight = heightMap[z - 1][x]
			local variation = (math.random() - 0.5) * (MAX_HEIGHT - MIN_HEIGHT) * (1 - SMOOTHNESS)
			if isCliff then
				variation = variation * CLIFF_INTENSITY
			end
			height = prevHeight + variation
		else
			-- Smooth from previous column (and optionally from previous row for smoother transitions)
			local prevHeightX = heightMap[z][x - 1]
			local prevHeightZ = (z > 1) and heightMap[z - 1][x] or prevHeightX
			local avgPrevHeight = (prevHeightX + prevHeightZ) / 2
			
			local variation = (math.random() - 0.5) * (MAX_HEIGHT - MIN_HEIGHT) * (1 - SMOOTHNESS)
			if isCliff then
				variation = variation * CLIFF_INTENSITY
			end
			height = avgPrevHeight + variation
		end
		
		-- Clamp to min/max
		height = math.clamp(height, MIN_HEIGHT, MAX_HEIGHT)
		heightMap[z][x] = height
	end
end

-- Mirror to right half
print("  🔄 Mirroring left half to right half...")
for z = 1, gridZ do
	for x = midX + 1, gridX do
		-- Mirror position: map right half to left half
		-- Distance from center: dist = x - midX
		-- Mirror position = midX - dist + 1
		local dist = x - midX
		local mirrorX = midX - dist + 1
		-- Clamp to valid range
		mirrorX = math.max(1, math.min(mirrorX, midX))
		if heightMap[z] and heightMap[z][mirrorX] then
			heightMap[z][x] = heightMap[z][mirrorX]
		else
			-- Fallback: use center column or 0
			if heightMap[z] and heightMap[z][midX] then
				heightMap[z][x] = heightMap[z][midX]
			else
				heightMap[z][x] = 0
			end
		end
	end
end

print("  ✓ Height map generated!")

-- Create sculpted baseplate model
print("\n🗻 Creating sculpted baseplate...")

-- Create a model to hold all the sculpted parts
local sculptedModel = Instance.new("Model")
sculptedModel.Name = "SculptedBaseplate"
sculptedModel.Parent = workspace

-- Create sculpted parts
local partCount = 0
for z = 1, gridZ do
	for x = 1, gridX do
		-- Calculate world position
		local worldX = baseplatePos.X - (baseplateSize.X / 2) + (x - 0.5) * GRID_SIZE
		local worldZ = baseplatePos.Z - (baseplateSize.Z / 2) + (z - 0.5) * GRID_SIZE
		
		-- Get height for this cell and surrounding cells for smooth blending
		local centerHeight = heightMap[z] and heightMap[z][x]
		if not centerHeight then
			warn("⚠ Missing height data at [" .. z .. "][" .. x .. "], using 0")
			centerHeight = 0
		end
		local height = centerHeight
		
		-- Average with neighbors for smoother transitions (optional - can remove for sharper edges)
		if x > 1 and x < gridX and z > 1 and z < gridZ then
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
				local avgHeight = sum / #neighborHeights
				height = (centerHeight * 0.7) + (avgHeight * 0.3) -- Blend 70% center, 30% average
			end
		end
		
		-- Calculate part position and size
		local partY = baseplateTop + height
		local partHeight = baseplateSize.Y + math.abs(height) * 2 -- Extend part to cover height variation
		
		-- Create the part
		local part = Instance.new("Part")
		part.Name = "Sculpt_" .. x .. "_" .. z
		part.Size = Vector3.new(GRID_SIZE, partHeight, GRID_SIZE)
		part.Position = Vector3.new(worldX, partY, worldZ)
		part.Anchored = originalAnchored
		part.CanCollide = originalCanCollide
		part.Material = originalMaterial
		part.Color = originalColor
		part.BrickColor = originalBrickColor
		part.Parent = sculptedModel
		
		partCount = partCount + 1
	end
end

print("  ✓ Created " .. partCount .. " sculpted parts")

-- Adjust spawn locations to sit on top of sculpted surface
print("\n📍 Adjusting spawn locations to sculpted surface...")
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
			
			-- Calculate grid indices for this spawn location
			local gridXIndex = math.floor((spawnX - baseplateMinX) / GRID_SIZE) + 1
			local gridZIndex = math.floor((spawnZ - baseplateMinZ) / GRID_SIZE) + 1
			
			-- Clamp to valid range
			gridXIndex = math.max(1, math.min(gridXIndex, gridX))
			gridZIndex = math.max(1, math.min(gridZIndex, gridZ))
			
			-- Get height from height map (with interpolation from neighbors for smoother result)
			local height = 0
			if heightMap[gridZIndex] and heightMap[gridZIndex][gridXIndex] then
				height = heightMap[gridZIndex][gridXIndex]
				
				-- Interpolate with neighbors for smoother positioning
				local neighborHeights = {}
				if heightMap[gridZIndex] and heightMap[gridZIndex][gridXIndex] then
					table.insert(neighborHeights, heightMap[gridZIndex][gridXIndex])
				end
				if heightMap[gridZIndex] and heightMap[gridZIndex][gridXIndex - 1] then
					table.insert(neighborHeights, heightMap[gridZIndex][gridXIndex - 1])
				end
				if heightMap[gridZIndex] and heightMap[gridZIndex][gridXIndex + 1] then
					table.insert(neighborHeights, heightMap[gridZIndex][gridXIndex + 1])
				end
				if heightMap[gridZIndex - 1] and heightMap[gridZIndex - 1][gridXIndex] then
					table.insert(neighborHeights, heightMap[gridZIndex - 1][gridXIndex])
				end
				if heightMap[gridZIndex + 1] and heightMap[gridZIndex + 1][gridXIndex] then
					table.insert(neighborHeights, heightMap[gridZIndex + 1][gridXIndex])
				end
				
				if #neighborHeights > 0 then
					local sum = 0
					for _, h in ipairs(neighborHeights) do
						sum = sum + h
					end
					height = sum / #neighborHeights
				end
			end
			
			-- Calculate new Y position (baseplate top + height + half of spawn location height)
			local newY = baseplateTop + height + (spawnLoc.Size.Y / 2)
			
			-- Update spawn location position
			spawnLoc.Position = Vector3.new(spawnX, newY, spawnZ)
			print("  ✓ Adjusted " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", newY))
		else
			print("  ⚠ " .. spawnLoc.Name .. " is outside baseplate bounds, skipping")
		end
	end
else
	print("  No spawn locations found")
end

-- Hide or remove the original baseplate
print("  🗑️ Hiding original baseplate...")
baseplate.Transparency = 1
baseplate.CanCollide = false
baseplate.CanQuery = false
baseplate.CanTouch = false

print("\n✅ Sculpting complete!")
print("💡 Height range: " .. MIN_HEIGHT .. " to " .. MAX_HEIGHT .. " studs")
print("💡 Smoothness: " .. (SMOOTHNESS * 100) .. "%")
print("💡 Mirror point: X = " .. midX .. " (center column)")
print("💡 Original baseplate is hidden (transparency = 1)")
print("💡 Sculpted baseplate is in workspace > SculptedBaseplate")

