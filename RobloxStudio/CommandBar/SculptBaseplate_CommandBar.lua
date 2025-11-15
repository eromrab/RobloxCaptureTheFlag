-- SCULPT BASEPLATE - Command Bar Script
-- Paste this into Roblox Studio Command Bar
-- This script automatically sculpts the Baseplate
-- Creates a mirror-image sculpted terrain from the center

print("=== Baseplate Sculpting Script ===")

-- Configuration
local BLOCK_SIZE = 4 -- Size of each block in studs (Minecraft-style: all blocks are the same size)
local MIN_BLOCKS = 1 -- Minimum blocks (floor)
local MAX_BLOCKS = 25 -- Maximum blocks (cap)
local START_BLOCKS_MIN = 10 -- Starting height range (blocks)
local START_BLOCKS_MAX = 15 -- Starting height range (blocks)

-- Gorge configuration
local GORGE_START_MIN = 0.25 -- Gorge can start after 25% of map
local GORGE_START_MAX = 0.75 -- Gorge can start before 75% of map
local GORGE_WIDTH_MIN = 6 -- Minimum gorge width (blocks)
local GORGE_WIDTH_MAX = 16 -- Maximum gorge width (blocks)
local GORGE_DEPTH = 3 -- How many blocks deep the gorge is (below surrounding terrain)

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

-- Also check for old "SculptedBaseplateOverlay" (from older versions)
local existingOverlay = workspace:FindFirstChild("SculptedBaseplateOverlay")
if existingOverlay then
	existingOverlay:Destroy()
	print("  ✓ Deleted existing sculpted overlay")
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

-- Remove any terrain sculpting before creating new sculpting
local Terrain = workspace.Terrain
if Terrain then
	print("  🗑️ Removing terrain sculpting...")
	
	local success, errorMsg = pcall(function()
		-- Clear the area with Air (removes all terrain sculpting - no grass added)
		local clearPosition = baseplatePos
		local clearSize = Vector3.new(baseplateSize.X + 100, baseplateSize.Y + 200, baseplateSize.Z + 100) -- Extra margin to catch edge terrain
		Terrain:FillBlock(CFrame.new(clearPosition), clearSize, Enum.Material.Air)
	end)
	
	if success then
		print("  ✓ Terrain sculpting removed")
	else
		warn("  ⚠ Could not remove terrain sculpting: " .. tostring(errorMsg))
	end
end

-- Calculate grid dimensions
local gridX = math.ceil(baseplateSize.X / BLOCK_SIZE)
local gridZ = math.ceil(baseplateSize.Z / BLOCK_SIZE)
local midX = math.floor(gridX / 2) -- Midpoint for mirroring

print("\n📐 Creating Minecraft-style block grid...")
print("    Grid size: " .. gridX .. " x " .. gridZ .. " blocks")
print("    Block size: " .. BLOCK_SIZE .. " x " .. BLOCK_SIZE .. " x " .. BLOCK_SIZE .. " studs")
print("    Mirror point: X = " .. midX .. " (center column)")

-- Helper function to calculate next height based on probabilities
local function calculateNextHeight(prevHeight, isInGorge, isNearGorge)
	local rand = math.random()
	
	-- In gorge or near gorge: no cliffs, 10% cliff chance goes to staying same
	if isInGorge or isNearGorge then
		if rand < 0.15 then
			-- 15% chance: small variation
			local variation = math.random(1, 4)
			if variation == 1 then return prevHeight + 1
			elseif variation == 2 then return prevHeight - 1
			elseif variation == 3 then return prevHeight + 2
			else return prevHeight - 2 end
		else
			-- 85% chance: stay same (60% normal + 10% from cliff chance + 15% from small variation)
			return prevHeight
		end
	else
		-- Normal terrain generation
		if rand < 0.10 then
			-- 10% chance: cliff (3-7 blocks up or down)
			local cliffAmount = math.random(3, 7)
			local direction = math.random() < 0.5 and 1 or -1
			return math.max(MIN_BLOCKS, math.min(MAX_BLOCKS, prevHeight + (direction * cliffAmount)))
		elseif rand < 0.25 then
			-- 15% chance: small variation (up 1, down 1, up 2, down 2)
			local variation = math.random(1, 4)
			if variation == 1 then return math.max(MIN_BLOCKS, math.min(MAX_BLOCKS, prevHeight + 1))
			elseif variation == 2 then return math.max(MIN_BLOCKS, math.min(MAX_BLOCKS, prevHeight - 1))
			elseif variation == 3 then return math.max(MIN_BLOCKS, math.min(MAX_BLOCKS, prevHeight + 2))
			else return math.max(MIN_BLOCKS, math.min(MAX_BLOCKS, prevHeight - 2)) end
		else
			-- 60% chance: stay the same
			return prevHeight
		end
	end
end

-- Create height map (stored in blocks, not studs)
local heightMap = {}
local gorgeMap = {} -- Track which cells are in the gorge

-- Generate gorge path first (in middle 50% of map)
print("  🏞️ Generating gorge path...")
local gorgeStartZ = math.floor(gridZ * GORGE_START_MIN + math.random() * gridZ * (GORGE_START_MAX - GORGE_START_MIN))
local gorgeWidth = math.random(GORGE_WIDTH_MIN, GORGE_WIDTH_MAX)
local gorgeIsRiver = math.random() < 0.5 -- 50% chance river (blue), 50% canyon (brown)

-- Create gorge path that winds through the middle and meets at center
-- Gorge is generated on left side only, then mirrored to right side
-- The gorge should extend through the center column to connect both sides
for z = gorgeStartZ, gridZ do
	-- Only generate gorge on left side (will be mirrored later)
	if z <= math.floor(gridZ / 2) then
		-- Left side: wind the gorge slightly toward center
		local progress = (z - gorgeStartZ) / (math.floor(gridZ / 2) - gorgeStartZ)
		local windAmount = math.random(-2, 2) * (1 - progress) -- Less winding near center
		local gorgeCenterX = math.max(1, math.min(midX, midX + windAmount))
		
		-- Mark gorge cells on left side, extending through center
		-- This ensures the gorge connects both sides at the center
		local halfWidth = math.floor(gorgeWidth / 2)
		-- Extend to center column (midX) so gorge connects both sides
		for gx = math.max(1, gorgeCenterX - halfWidth), midX do
			if not gorgeMap[z] then gorgeMap[z] = {} end
			gorgeMap[z][gx] = true
		end
	end
	-- Right side gorge will be created by mirroring in the mirroring section below
end

print("  ✓ Gorge path created (width: " .. gorgeWidth .. " blocks, type: " .. (gorgeIsRiver and "River" or "Canyon") .. ")")

-- Generate height map (only for left half, will mirror to right)
print("  🎲 Generating height map (left half)...")
for z = 1, gridZ do
	heightMap[z] = {}
	for x = 1, midX do
		local heightBlocks -- Height in blocks
		local isInGorge = gorgeMap[z] and gorgeMap[z][x] or false
		local isNearGorge = false
		
		-- Check if neighboring cells are in gorge
		if not isInGorge then
			if (gorgeMap[z] and gorgeMap[z][x - 1]) or (gorgeMap[z] and gorgeMap[z][x + 1]) or
			   (gorgeMap[z - 1] and gorgeMap[z - 1][x]) or (gorgeMap[z + 1] and gorgeMap[z + 1][x]) then
				isNearGorge = true
			end
		end
		
		if x == 1 and z == 1 then
			-- Starting point - random height between 10-15 blocks
			heightBlocks = math.random(START_BLOCKS_MIN, START_BLOCKS_MAX)
		elseif x == 1 then
			-- First column - calculate from previous row
			local prevHeight = heightMap[z - 1][x]
			heightBlocks = calculateNextHeight(prevHeight, isInGorge, isNearGorge)
		else
			-- Use previous column as base (smoother transitions)
			local prevHeight = heightMap[z][x - 1]
			heightBlocks = calculateNextHeight(prevHeight, isInGorge, isNearGorge)
		end
		
		-- Apply gorge depth if in gorge
		if isInGorge then
			-- Gorge should be lower - reduce height by GORGE_DEPTH blocks
			heightBlocks = math.max(MIN_BLOCKS, heightBlocks - GORGE_DEPTH)
		end
		
		-- Clamp to min/max
		heightBlocks = math.max(MIN_BLOCKS, math.min(MAX_BLOCKS, heightBlocks))
		heightMap[z][x] = heightBlocks
	end
end

-- Mirror to right half (height map and gorge map)
-- Mirroring: left position 'leftX' mirrors to right position 'midX + (midX - leftX) + 1'
-- This ensures features on left side appear mirrored on right side
print("  🔄 Mirroring left half to right half...")
for z = 1, gridZ do
	for x = midX + 1, gridX do
		-- Calculate which left position this right position mirrors
		-- For right position x, find the left position it mirrors
		-- Distance from center on right: x - midX
		-- Mirrored left position: midX - (x - midX) + 1 = midX - x + midX + 1 = 2*midX - x + 1
		local mirrorX = 2 * midX - x + 1
		-- Clamp to valid left range
		mirrorX = math.max(1, math.min(mirrorX, midX))
		
		-- Mirror height map
		if heightMap[z] and heightMap[z][mirrorX] then
			heightMap[z][x] = heightMap[z][mirrorX]
		else
			-- Fallback: use center column or 1
			if heightMap[z] and heightMap[z][midX] then
				heightMap[z][x] = heightMap[z][midX]
			else
				heightMap[z][x] = 1
			end
		end
		
		-- Mirror gorge map
		if gorgeMap[z] and gorgeMap[z][mirrorX] then
			if not gorgeMap[z] then gorgeMap[z] = {} end
			gorgeMap[z][x] = true
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

-- Create sculpted blocks (Minecraft-style: stack blocks vertically)
-- Performance optimization: batch part creation
local partCount = 0
local partsToCreate = {} -- Batch parts for faster creation

for z = 1, gridZ do
	for x = 1, gridX do
		-- Calculate world position (center of block)
		local worldX = baseplatePos.X - (baseplateSize.X / 2) + (x - 0.5) * BLOCK_SIZE
		local worldZ = baseplatePos.Z - (baseplateSize.Z / 2) + (z - 0.5) * BLOCK_SIZE

		-- Get height for this cell (stored in blocks)
		local heightBlocks = heightMap[z] and heightMap[z][x] or 1
		local isInGorge = gorgeMap[z] and gorgeMap[z][x] or false
		
		-- Convert blocks to studs
		local height = heightBlocks * BLOCK_SIZE
		
		-- Calculate the top of the stack (baseplate top + height offset)
		local stackTop = baseplateTop + height
		
		-- We need to create a solid column from baseplate bottom up to stackTop
		-- This ensures we always have a solid base and can build hills on top
		local baseY = baseplateY - (baseplateSize.Y / 2) -- Bottom of baseplate
		local topY = math.max(baseY, stackTop) -- Top of stack (at least at baseplate bottom)
		
		-- Calculate how many blocks we need (from baseY to topY)
		local blocksNeeded = math.ceil((topY - baseY) / BLOCK_SIZE)
		blocksNeeded = math.max(1, blocksNeeded) -- At least 1 block
		
		-- Stack blocks vertically (Minecraft-style) from bottom to top
		for blockIndex = 1, blocksNeeded do
			-- Position each block so they stack from baseY upward
			-- Block 1's bottom is at baseY, block 2's bottom is at baseY + BLOCK_SIZE, etc.
			local blockY = baseY + ((blockIndex - 1) * BLOCK_SIZE) + (BLOCK_SIZE / 2)
			
			-- Create a block (all blocks are the same size)
			local part = Instance.new("Part")
			part.Name = "Block_" .. x .. "_" .. z .. "_" .. blockIndex
			part.Size = Vector3.new(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE) -- All blocks are the same size
			part.Position = Vector3.new(worldX, blockY, worldZ)
			part.Anchored = originalAnchored
			part.CanCollide = originalCanCollide
			
			-- Apply gorge material/color if in gorge
			if isInGorge then
				if gorgeIsRiver then
					part.Material = Enum.Material.Water
					part.Color = Color3.fromRGB(64, 164, 223) -- Blue water
				else
					part.Material = Enum.Material.Sand
					part.Color = Color3.fromRGB(194, 154, 108) -- Desert brown
				end
			else
				part.Material = originalMaterial
				part.Color = originalColor
				part.BrickColor = originalBrickColor
			end
			
			-- Batch parent assignment for performance (every 100 parts)
			table.insert(partsToCreate, part)
			if #partsToCreate >= 100 then
				for _, p in ipairs(partsToCreate) do
					p.Parent = sculptedModel
				end
				partsToCreate = {}
			end
			
			partCount = partCount + 1
		end
	end
end

-- Parent remaining parts
for _, p in ipairs(partsToCreate) do
	p.Parent = sculptedModel
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
			local gridXIndex = math.floor((spawnX - baseplateMinX) / BLOCK_SIZE) + 1
			local gridZIndex = math.floor((spawnZ - baseplateMinZ) / BLOCK_SIZE) + 1

			-- Clamp to valid range
			gridXIndex = math.max(1, math.min(gridXIndex, gridX))
			gridZIndex = math.max(1, math.min(gridZIndex, gridZ))

			-- Get height from height map (stored in blocks)
			local heightBlocks = 1
			if heightMap[gridZIndex] and heightMap[gridZIndex][gridXIndex] then
				heightBlocks = heightMap[gridZIndex][gridXIndex]
			end
			
			-- Convert blocks to studs
			local height = heightBlocks * BLOCK_SIZE

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
print("💡 Height range: " .. MIN_BLOCKS .. " to " .. MAX_BLOCKS .. " blocks (" .. (MIN_BLOCKS * BLOCK_SIZE) .. " to " .. (MAX_BLOCKS * BLOCK_SIZE) .. " studs)")
print("💡 Block size: " .. BLOCK_SIZE .. " x " .. BLOCK_SIZE .. " x " .. BLOCK_SIZE .. " studs (all blocks are the same size)")
print("💡 Mirror point: X = " .. midX .. " (center column)")
print("💡 Gorge: " .. (gorgeIsRiver and "River (Blue)" or "Canyon (Brown)") .. ", width: " .. gorgeWidth .. " blocks")
print("💡 Original baseplate is hidden (transparency = 1)")
print("💡 Sculpted baseplate is in workspace > SculptedBaseplate")
print("💡 Minecraft-style: Blocks are stacked vertically to create height variations")
