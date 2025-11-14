-- Command Bar script to adjust spawn location heights to match terrain
-- This will find all SpawnLocation objects and adjust their Y position to match terrain height

local Terrain = workspace.Terrain
local RunService = game:GetService("RunService")

-- Function to find terrain height at a position
-- Filters out ceiling, walls, and other non-terrain objects
local function getTerrainHeight(x, z)
	local rayOrigin = Vector3.new(x, 500, z)
	local rayDirection = Vector3.new(0, -1000, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	-- Filter out ceiling, walls, spawn locations, and other non-terrain parts
	local filterList = {}
	
	-- Filter out ceiling/roof
	local wallsFolder = workspace:FindFirstChild("Walls")
	if wallsFolder then
		for _, wall in ipairs(wallsFolder:GetChildren()) do
			if wall:IsA("BasePart") then
				if wall.Name:find("Roof") or wall.Name:find("Ceiling") or wall.Name:find("Top") then
					table.insert(filterList, wall)
				elseif wall.Name:find("Wall") then
					table.insert(filterList, wall)
				end
			end
		end
	end
	
	-- Filter out spawn locations
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation") then
			table.insert(filterList, obj)
		end
	end
	
	-- Filter out ZoneWalls
	local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
	if zonePartsFolder then
		for _, part in ipairs(zonePartsFolder:GetChildren()) do
			if part:IsA("BasePart") and part.Name:find("Wall") then
				table.insert(filterList, part)
			end
		end
	end
	
	raycastParams.FilterDescendantsInstances = filterList
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult then
		local hitPart = raycastResult.Instance
		local hitY = raycastResult.Position.Y
		
		-- Prioritize terrain hits (this is what we want)
		if hitPart and (hitPart.Name == "Terrain" or hitPart:IsDescendantOf(workspace.Terrain)) then
			if hitY > 10 and hitY < 150 then -- Terrain should be below 150 (ceiling is at 150+)
				return hitY
			end
		-- Accept parts that are in terrain range (10-150) and not walls/ceiling
		elseif hitY > 10 and hitY < 150 then
			-- Make sure it's not a wall or ceiling
			if hitPart and not hitPart.Name:find("Wall") and not hitPart.Name:find("Roof") and 
			   not hitPart.Name:find("Ceiling") and not hitPart:IsA("SpawnLocation") then
				return hitY
			end
		end
	end
	
	-- Fallback: Try without filters but only accept terrain
	local simpleRaycast = workspace:Raycast(rayOrigin, rayDirection)
	if simpleRaycast then
		local hitPart = simpleRaycast.Instance
		local hitY = simpleRaycast.Position.Y
		-- Only accept if it's terrain and in reasonable range
		if hitPart and (hitPart.Name == "Terrain" or hitPart:IsDescendantOf(workspace.Terrain)) then
			if hitY > 10 and hitY < 150 then
				return hitY
			end
		end
	end
	
	-- Final fallback - use a reasonable terrain height estimate
	-- Terrain is typically around 30-50 studs above baseplate (baseplate top is at 0)
	return 40
end

-- Function to recursively find all SpawnLocation objects
local function findSpawnLocationsRecursive(parent)
	local spawnLocations = {}
	
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("SpawnLocation") then
			table.insert(spawnLocations, child)
		elseif child:IsA("Folder") or child:IsA("Model") then
			-- Recursively search folders/models
			local nestedSpawns = findSpawnLocationsRecursive(child)
			for _, spawn in ipairs(nestedSpawns) do
				table.insert(spawnLocations, spawn)
			end
		end
	end
	
	return spawnLocations
end

print("=== Adjusting Spawn Location Heights to Match Terrain ===")

-- Find all spawn locations
local spawnLocations = findSpawnLocationsRecursive(workspace)

if #spawnLocations == 0 then
	warn("⚠ No SpawnLocation objects found in workspace!")
	return
end

print("  Found " .. #spawnLocations .. " spawn location(s)")

-- Adjust each spawn location
local adjustedCount = 0
for _, spawnLoc in ipairs(spawnLocations) do
	local currentPos = spawnLoc.Position
	local terrainHeight = getTerrainHeight(currentPos.X, currentPos.Z)
	
	-- Set spawn location to terrain height + 10 studs (spawn offset)
	local newY = terrainHeight + 10
	local newPos = Vector3.new(currentPos.X, newY, currentPos.Z)
	
	spawnLoc.Position = newPos
	
	print("  ✓ Adjusted " .. spawnLoc.Name .. ":")
	print("    Old Y: " .. string.format("%.2f", currentPos.Y))
	print("    Terrain Height: " .. string.format("%.2f", terrainHeight))
	print("    New Y: " .. string.format("%.2f", newY))
	print("    Position: " .. tostring(newPos))
	
	adjustedCount = adjustedCount + 1
end

print("")
print("✅ Adjusted " .. adjustedCount .. " spawn location(s) to terrain height + 10 studs")
print("💡 Spawn locations are now positioned above terrain")

