-- Command Bar script to set spawn locations to recorded positions
-- This uses the positions recorded by RecordSpawnLocations_CommandBar.lua
-- Paste this into Roblox Studio Command Bar

print("=== Setting Spawn Locations to Recorded Positions ===")

-- Find baseplate
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

local baseplate = workspace:FindFirstChild("Baseplate")
if not baseplate then
	baseplate = workspace:FindFirstChild("baseplate")
end
if not baseplate then
	baseplate = workspace:FindFirstChild("BasePlate")
end
if not baseplate then
	baseplate = findBaseplateRecursive(workspace)
end

if not baseplate then
	warn("⚠ Baseplate not found!")
	return
end

local baseplatePos = baseplate.Position
print("  ✓ Found baseplate at: " .. tostring(baseplatePos))
print("")

-- Recorded spawn positions (from RecordSpawnLocations_CommandBar.lua output)
local spawnRecordedPositions = {
	["DefaultSpawnLocation"] = {
		relativeX = -1001.227631,
		relativeZ = -66.529846,
		absoluteY = 45.793930,
		anchored = true,
		canCollide = true,
		enabled = true,
		transparency = 0.00,
		teamColor = BrickColor.new("Medium stone grey"),
		parentName = "Spawn Room",
	},
	["RedSpawnLocation"] = {
		relativeX = -513.500031,
		relativeZ = -196.000000,
		absoluteY = 111.000000,
		anchored = true,
		canCollide = false,
		enabled = true,
		transparency = 0.00,
		teamColor = BrickColor.new("Really red"),
		parentName = "Spawnlocations",
	},
	["BlueSpawnLocation"] = {
		relativeX = 513.499969,
		relativeZ = 196.000000,
		absoluteY = 108.459320,
		anchored = true,
		canCollide = false,
		enabled = true,
		transparency = 0.00,
		teamColor = BrickColor.new("Bright blue"),
		parentName = "Spawnlocations",
	}
}

-- Find baseplate for relative positioning
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

local baseplate = workspace:FindFirstChild("Baseplate")
if not baseplate then
	baseplate = workspace:FindFirstChild("baseplate")
end
if not baseplate then
	baseplate = workspace:FindFirstChild("BasePlate")
end
if not baseplate then
	baseplate = findBaseplateRecursive(workspace)
end

if not baseplate then
	warn("⚠ Baseplate not found!")
	return
end

local baseplatePos = baseplate.Position
print("  ✓ Found baseplate at: " .. tostring(baseplatePos))
print("")

-- Function to find terrain height at a position
local function findTerrainHeight(x, z)
	local rayOrigin = Vector3.new(x, 500, z)
	local rayDirection = Vector3.new(0, -1000, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	-- Filter out walls, ceiling, spawns, and bots
	local filterList = {}
	local wallsFolder = workspace:FindFirstChild("Walls")
	if wallsFolder then
		for _, wall in ipairs(wallsFolder:GetChildren()) do
			if wall:IsA("BasePart") then
				table.insert(filterList, wall)
			end
		end
	end
	
	-- Filter out spawn locations
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation") then
			table.insert(filterList, obj)
		end
	end
	
	raycastParams.FilterDescendantsInstances = filterList
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult and raycastResult.Position.Y > -50 and raycastResult.Position.Y < 200 then
		local hitPart = raycastResult.Instance
		-- Prioritize terrain hits
		if hitPart and (hitPart.Name == "Terrain" or hitPart:IsDescendantOf(workspace.Terrain)) then
			return raycastResult.Position.Y
		-- Reject walls, roof, ceiling, spawns
		elseif hitPart and not hitPart.Name:find("Wall") and not hitPart.Name:find("Roof") and not hitPart.Name:find("Ceiling") and not hitPart:IsA("SpawnLocation") then
			-- Only accept if it's not too high (likely a ceiling)
			if raycastResult.Position.Y < 150 then
				return raycastResult.Position.Y
			end
		end
	end
	
	-- Fallback: simple raycast (but filter out high results)
	local simpleRaycast = workspace:Raycast(rayOrigin, rayDirection)
	if simpleRaycast and simpleRaycast.Position.Y > -50 and simpleRaycast.Position.Y < 150 then
		local hitPart = simpleRaycast.Instance
		-- Reject ceiling/roof
		if hitPart and not hitPart.Name:find("Roof") and not hitPart.Name:find("Ceiling") then
			return simpleRaycast.Position.Y
		end
	end
	
	return nil
end

-- Find all spawn locations
local spawnLocations = {}

local function findSpawnLocationsRecursive(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			table.insert(spawnLocations, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findSpawnLocationsRecursive(obj)
		end
	end
end

findSpawnLocationsRecursive(workspace)

if #spawnLocations == 0 then
	warn("⚠ No spawn locations found!")
	return
end

print("  ✓ Found " .. #spawnLocations .. " spawn location(s)")
print("")

-- Set spawn locations to recorded positions
local setCount = 0

for _, spawnLoc in ipairs(spawnLocations) do
	local recordedData = spawnRecordedPositions[spawnLoc.Name]
	
	if recordedData then
		-- Calculate absolute position from relative position (restore X/Z to recorded positions)
		local spawnX = baseplatePos.X + recordedData.relativeX
		local spawnZ = baseplatePos.Z + recordedData.relativeZ
		
		-- Find terrain height at this position and use it instead of recorded Y
		local terrainHeight = findTerrainHeight(spawnX, spawnZ)
		local spawnY
		
		if terrainHeight then
			-- Use terrain height + 10 studs
			spawnY = terrainHeight + 10
			print("    ✓ Found terrain for " .. spawnLoc.Name .. " at Y = " .. string.format("%.2f", terrainHeight))
		else
			-- Fallback to recorded Y if terrain not found
			spawnY = recordedData.absoluteY
			warn("    ⚠ Could not find terrain for " .. spawnLoc.Name .. ", using recorded Y = " .. string.format("%.2f", spawnY))
		end
		
		-- Set position
		spawnLoc.CFrame = CFrame.new(spawnX, spawnY, spawnZ)
		
		-- Set properties
		spawnLoc.Anchored = recordedData.anchored
		spawnLoc.CanCollide = recordedData.canCollide
		spawnLoc.Enabled = recordedData.enabled
		spawnLoc.Transparency = recordedData.transparency
		
		if recordedData.teamColor then
			spawnLoc.TeamColor = recordedData.teamColor
		end
		
		-- Set parent
		if recordedData.parentName then
			if recordedData.parentName == "workspace" then
				spawnLoc.Parent = workspace
			else
				local parentObj = workspace:FindFirstChild(recordedData.parentName)
				if parentObj then
					spawnLoc.Parent = parentObj
				else
					warn("  ⚠ Parent '" .. recordedData.parentName .. "' not found for " .. spawnLoc.Name .. ", keeping current parent")
				end
			end
		end
		
		setCount = setCount + 1
		print("  ✓ Set " .. spawnLoc.Name .. " to:")
		print("    Position: " .. string.format("%.2f", spawnX) .. ", " .. string.format("%.2f", spawnY) .. ", " .. string.format("%.2f", spawnZ))
		print("    Relative: X=" .. string.format("%.2f", recordedData.relativeX) .. ", Z=" .. string.format("%.2f", recordedData.relativeZ))
		print("    Terrain: " .. string.format("%.2f", terrainHeight or recordedData.absoluteY))
		print("    Parent: " .. (spawnLoc.Parent and spawnLoc.Parent.Name or "nil"))
	else
		warn("  ⚠ No recorded position found for " .. spawnLoc.Name)
	end
end

print("")
print("✅ Set " .. setCount .. " spawn location(s) to recorded positions!")

