-- Command Bar script to orient map North-South so sun crosses perpendicular to team line
-- This ensures shadows are equal for both teams (sun moves East-West, teams are North-South)

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Function to recursively find all SpawnLocation objects
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

-- Function to find baseplate recursively
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

print("=== Orienting Map North-South for Equal Sun Shadows ===")

-- Find baseplate
local baseplate = findBaseplateRecursive(workspace)
if not baseplate then
	warn("⚠ Baseplate not found!")
	return
end

print("  ✓ Found baseplate: " .. baseplate.Name)

-- Find spawn locations
local spawnLocations = findSpawnLocationsRecursive(workspace)
if #spawnLocations < 2 then
	warn("⚠ Need at least 2 spawn locations to determine orientation!")
	return
end

print("  ✓ Found " .. #spawnLocations .. " spawn location(s)")

-- Find Red and Blue team spawns
local redSpawn = nil
local blueSpawn = nil

for _, spawn in ipairs(spawnLocations) do
	if spawn.TeamColor == BrickColor.new("Really red") or spawn.Name:find("Red") then
		redSpawn = spawn
	elseif spawn.TeamColor == BrickColor.new("Bright blue") or spawn.Name:find("Blue") then
		blueSpawn = spawn
	end
end

if not redSpawn or not blueSpawn then
	warn("⚠ Could not find both Red and Blue team spawns!")
	print("  Found spawns:")
	for _, spawn in ipairs(spawnLocations) do
		print("    - " .. spawn.Name .. " (TeamColor: " .. tostring(spawn.TeamColor) .. ")")
	end
	return
end

print("  ✓ Found Red Team spawn: " .. redSpawn.Name .. " at " .. tostring(redSpawn.Position))
print("  ✓ Found Blue Team spawn: " .. blueSpawn.Name .. " at " .. tostring(blueSpawn.Position))

-- Calculate direction from Red to Blue spawn (this should become North-South)
local redPos = redSpawn.Position
local bluePos = blueSpawn.Position
local teamDirection = (bluePos - redPos)
teamDirection = Vector3.new(teamDirection.X, 0, teamDirection.Z) -- Flatten to XZ plane
local teamDistance = teamDirection.Magnitude
teamDirection = teamDirection.Unit

print("  Team direction vector: " .. tostring(teamDirection))
print("  Team distance: " .. string.format("%.2f", teamDistance) .. " studs")

-- Calculate current angle of team line
-- North is (0, 0, -1) in Roblox world coordinates
local northDirection = Vector3.new(0, 0, -1)
local currentAngle = math.deg(math.acos(teamDirection:Dot(northDirection)))

-- Determine if we need to rotate clockwise or counterclockwise
local crossProduct = teamDirection:Cross(northDirection)
if crossProduct.Y < 0 then
	currentAngle = -currentAngle
end

print("  Current angle from North: " .. string.format("%.2f", currentAngle) .. " degrees")

-- Calculate rotation needed to align team line with North-South
local rotationNeeded = -currentAngle
print("  Rotation needed: " .. string.format("%.2f", rotationNeeded) .. " degrees")

-- If rotation is very small, skip it
if math.abs(rotationNeeded) < 1 then
	print("  ✓ Map is already oriented North-South!")
	return
end

-- Calculate center point (midpoint between spawns, or baseplate center)
local centerPoint = (redPos + bluePos) / 2
-- Use baseplate center if it's more central
local baseplateCenter = baseplate.Position
if (baseplateCenter - centerPoint).Magnitude < teamDistance / 2 then
	centerPoint = baseplateCenter
end

print("  Rotation center: " .. tostring(centerPoint))
print("  Rotating map by " .. string.format("%.2f", rotationNeeded) .. " degrees around Y-axis...")

-- Rotate all important objects around the center point
local rotationAngle = math.rad(rotationNeeded)
local centerCFrame = CFrame.new(centerPoint)
local rotationCFrame = CFrame.Angles(0, rotationAngle, 0)

-- Function to rotate a part around center point
local function rotatePart(part, centerPos, angleRad)
	local partPos = part.Position
	local offsetFromCenter = partPos - centerPos
	
	-- Rotate the offset vector around Y-axis
	local cosAngle = math.cos(angleRad)
	local sinAngle = math.sin(angleRad)
	local rotatedX = offsetFromCenter.X * cosAngle - offsetFromCenter.Z * sinAngle
	local rotatedZ = offsetFromCenter.X * sinAngle + offsetFromCenter.Z * cosAngle
	local rotatedOffset = Vector3.new(rotatedX, offsetFromCenter.Y, rotatedZ)
	
	-- Calculate new position
	local newPosition = centerPos + rotatedOffset
	
	-- Rotate the part's orientation as well
	local partCF = part.CFrame
	local partRotation = partCF - partCF.Position
	local rotatedCF = partRotation * CFrame.Angles(0, angleRad, 0)
	
	-- Set new position and rotation
	part.CFrame = CFrame.new(newPosition) * rotatedCF
end

-- Rotate baseplate
rotatePart(baseplate, centerPoint, rotationAngle)
print("  ✓ Rotated baseplate")

-- Rotate spawn locations
for _, spawn in ipairs(spawnLocations) do
	rotatePart(spawn, centerPoint, rotationAngle)
end
print("  ✓ Rotated " .. #spawnLocations .. " spawn location(s)")

-- Rotate walls if they exist
local wallsFolder = workspace:FindFirstChild("Walls")
if wallsFolder then
	local wallCount = 0
	for _, wall in ipairs(wallsFolder:GetChildren()) do
		if wall:IsA("BasePart") then
			rotatePart(wall, centerPoint, rotationAngle)
			wallCount = wallCount + 1
		end
	end
	if wallCount > 0 then
		print("  ✓ Rotated " .. wallCount .. " wall(s)")
	end
end

-- Rotate ZoneWalls if they exist
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if zonePartsFolder then
	local zoneWallCount = 0
	for _, part in ipairs(zonePartsFolder:GetChildren()) do
		if part:IsA("BasePart") and part.Name:find("Wall") then
			rotatePart(part, centerPoint, rotationAngle)
			zoneWallCount = zoneWallCount + 1
		end
	end
	if zoneWallCount > 0 then
		print("  ✓ Rotated " .. zoneWallCount .. " zone wall(s)")
	end
end

-- Verify final orientation
local newRedPos = redSpawn.Position
local newBluePos = blueSpawn.Position
local newTeamDirection = (newBluePos - newRedPos)
newTeamDirection = Vector3.new(newTeamDirection.X, 0, newTeamDirection.Z).Unit
local newAngle = math.deg(math.acos(newTeamDirection:Dot(northDirection)))
local newCross = newTeamDirection:Cross(northDirection)
if newCross.Y < 0 then
	newAngle = -newAngle
end

print("")
print("✅ Map rotation complete!")
print("  Final angle from North: " .. string.format("%.2f", newAngle) .. " degrees")
print("")
print("💡 Sun will now cross East-West, perpendicular to the North-South team line")
print("💡 Both teams will have equal shadows throughout the day")
print("")
print("📝 Optional: Adjust Lighting.TimeOfDay to control sun position:")
print("   - 6:00 = Sunrise (East)")
print("   - 12:00 = Noon (directly overhead)")
print("   - 18:00 = Sunset (West)")

