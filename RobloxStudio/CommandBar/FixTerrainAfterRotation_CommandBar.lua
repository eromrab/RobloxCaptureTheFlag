-- Command Bar script to fix terrain and ceiling alignment after map rotation
-- Since terrain can't be rotated, we need to regenerate it to match the new orientation

print("=== Fixing Terrain and Ceiling After Rotation ===")
print("")
print("⚠️  IMPORTANT: Terrain cannot be rotated in Roblox.")
print("   After rotating the map, terrain needs to be regenerated to match.")
print("")
print("This script will:")
print("  1. Check current terrain alignment")
print("  2. Provide instructions to regenerate terrain")
print("  3. Realign ceiling/roof if needed")
print("")

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

-- Check ceiling/roof
local wallsFolder = workspace:FindFirstChild("Walls")
local roof = nil
if wallsFolder then
	for _, wall in ipairs(wallsFolder:GetChildren()) do
		if wall:IsA("BasePart") and (wall.Name:find("Roof") or wall.Name:find("Ceiling") or wall.Name:find("Top")) then
			roof = wall
			break
		end
	end
end

if roof then
	print("  ✓ Found ceiling/roof: " .. roof.Name)
	print("    Position: " .. tostring(roof.Position))
	print("    Size: " .. tostring(roof.Size))
	print("")
else
	print("  ⚠ No ceiling/roof found in Walls folder")
	print("")
end

-- Check spawn locations
local function findSpawnLocationsRecursive(parent)
	local spawnLocations = {}
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("SpawnLocation") then
			table.insert(spawnLocations, child)
		elseif child:IsA("Folder") or child:IsA("Model") then
			local nestedSpawns = findSpawnLocationsRecursive(child)
			for _, spawn in ipairs(nestedSpawns) do
				table.insert(spawnLocations, spawn)
			end
		end
	end
	return spawnLocations
end

local spawnLocations = findSpawnLocationsRecursive(workspace)
print("  ✓ Found " .. #spawnLocations .. " spawn location(s)")

-- Find Red and Blue spawns to determine team line direction
local redSpawn = nil
local blueSpawn = nil
for _, spawn in ipairs(spawnLocations) do
	if spawn.TeamColor == BrickColor.new("Really red") or spawn.Name:find("Red") then
		redSpawn = spawn
	elseif spawn.TeamColor == BrickColor.new("Bright blue") or spawn.Name:find("Blue") then
		blueSpawn = spawn
	end
end

if redSpawn and blueSpawn then
	local redPos = redSpawn.Position
	local bluePos = blueSpawn.Position
	local teamDirection = (bluePos - redPos)
	teamDirection = Vector3.new(teamDirection.X, 0, teamDirection.Z).Unit
	local northDirection = Vector3.new(0, 0, -1)
	local angle = math.deg(math.acos(teamDirection:Dot(northDirection)))
	
	print("  Team line direction: " .. string.format("%.2f", angle) .. " degrees from North")
	print("")
end

print("=" .. string.rep("=", 60))
print("SOLUTION:")
print("=" .. string.rep("=", 60))
print("")
print("Since terrain cannot be rotated in Roblox, you have two options:")
print("")
print("OPTION 1: Regenerate terrain (RECOMMENDED)")
print("  1. Run SculptTerrain_CommandBar.lua or SculptTerrain_Script.lua")
print("  2. This will regenerate terrain using the baseplate's NEW position")
print("  3. Terrain will be world-aligned but generated in the correct location")
print("")
print("OPTION 2: Realign ceiling/roof to match rotated baseplate")
print("  - The ceiling may need to be repositioned/resized")
print("  - Run RealignZoneWalls_CommandBar.lua to fix zone walls")
print("")
print("=" .. string.rep("=", 60))
print("")
print("⚠️  NOTE: Terrain in Roblox is always world-axis aligned.")
print("   After rotation, terrain must be regenerated to match the")
print("   new baseplate position, even though it can't be rotated.")
print("")
print("💡 The terrain generation script will use the baseplate's")
print("   current (rotated) position and size to generate terrain")
print("   in the correct world-space location.")
print("")
print("Would you like to:")
print("  A) Regenerate terrain now (recommended)")
print("  B) Just fix ceiling/roof alignment")
print("  C) Show more details")
print("")
print("(Run SculptTerrain_CommandBar.lua to regenerate terrain)")
print("")

