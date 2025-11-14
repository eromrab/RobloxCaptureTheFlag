-- Command Bar script to align ZoneWalls to terrain sculpting boundaries
-- Based on GameMap.txt: Base | Defend | Neutral | Defend | Base
-- Positions walls at zone boundaries: Base-Defend, Defend-Neutral, Neutral-Defend, Defend-Base
-- Paste this into Roblox Studio Command Bar

print("=== Aligning ZoneWalls to Terrain Zone Boundaries ===")
print("")

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

print("  ✓ Found Baseplate: " .. baseplate.Name)
local baseplatePos = baseplate.Position
local baseplateSize = baseplate.Size
local baseplateTop = baseplatePos.Y + (baseplateSize.Y / 2)

-- Calculate baseplate boundaries
local baseplateMinX = baseplatePos.X - (baseplateSize.X / 2)
local baseplateMaxX = baseplatePos.X + (baseplateSize.X / 2)
local baseplateMinZ = baseplatePos.Z - (baseplateSize.Z / 2)
local baseplateMaxZ = baseplatePos.Z + (baseplateSize.Z / 2)

print("    Position: " .. tostring(baseplatePos))
print("    Size: " .. tostring(baseplateSize))
print("    X range: " .. string.format("%.2f", baseplateMinX) .. " to " .. string.format("%.2f", baseplateMaxX))
print("    Z range: " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ))
print("")

-- Find Walls folder for ceiling reference
local wallsFolder = workspace:FindFirstChild("Walls")
local ceiling = nil
if wallsFolder then
	ceiling = wallsFolder:FindFirstChild("Roof") or wallsFolder:FindFirstChild("Ceiling") or wallsFolder:FindFirstChild("Top")
	-- Also search for any part with "roof" or "ceiling" in the name
	if not ceiling then
		for _, child in ipairs(wallsFolder:GetChildren()) do
			if child:IsA("BasePart") and (child.Name:lower():find("roof") or child.Name:lower():find("ceiling") or child.Name:lower():find("top")) then
				ceiling = child
				break
			end
		end
	end
end

local ceilingY = nil
if ceiling then
	ceilingY = ceiling.Position.Y - (ceiling.Size.Y / 2)
	print("  ✓ Found ceiling: " .. ceiling.Name .. " at Y = " .. string.format("%.2f", ceilingY))
else
	-- Fallback: estimate ceiling height (typically 150 studs above baseplate top)
	ceilingY = baseplateTop + 150
	print("  ⚠ Ceiling not found, using estimated height: Y = " .. string.format("%.2f", ceilingY))
	print("  💡 If you have a ceiling, make sure it's named 'Roof' or 'Ceiling' in the Walls folder")
end
print("")

-- Calculate zone boundaries (same as terrain generation)
-- Terrain uses WALL_MARGIN = 8 studs, so terrain starts 8 studs in from baseplate edges
local WALL_MARGIN = 8
local terrainStartX = baseplateMinX + WALL_MARGIN
local terrainEndX = baseplateMaxX - WALL_MARGIN
local terrainWidth = terrainEndX - terrainStartX

-- Divide into 5 zones (Base | Defend | Neutral | Defend | Base)
-- Each zone is 1/5 of the terrain width
local zoneWidth = terrainWidth / 5

-- Calculate zone boundary X positions (world coordinates)
local zone1EndX = terrainStartX + zoneWidth      -- Base (left) ends here
local zone2EndX = terrainStartX + (zoneWidth * 2) -- Defend (left) ends here
local zone3EndX = terrainStartX + (zoneWidth * 3) -- Neutral ends here
local zone4EndX = terrainStartX + (zoneWidth * 4) -- Defend (right) ends here
-- Zone 5 (Base right) is from zone4EndX to terrainEndX

print("  📐 Terrain Zone Boundaries (from terrain generation):")
print("    Terrain X range: " .. string.format("%.2f", terrainStartX) .. " to " .. string.format("%.2f", terrainEndX))
print("    Zone 1 (Base left) ends at: " .. string.format("%.2f", zone1EndX))
print("    Zone 2 (Defend left) ends at: " .. string.format("%.2f", zone2EndX))
print("    Zone 3 (Neutral) ends at: " .. string.format("%.2f", zone3EndX))
print("    Zone 4 (Defend right) ends at: " .. string.format("%.2f", zone4EndX))
print("    Zone 5 (Base right) ends at: " .. string.format("%.2f", terrainEndX))
print("")

-- Zone wall positions (at boundaries between zones)
-- TeamABaseZoneWall: between Base and Defend (left) - at zone1EndX
-- TeamAMidpointZoneWall: between Defend and Neutral (left) - at zone2EndX
-- TeamBMidpointZoneWall: between Neutral and Defend (right) - at zone3EndX
-- TeamBBaseZoneWall: between Defend and Base (right) - at zone4EndX

local zoneWallPositions = {
	["TeamABaseZoneWall"] = zone1EndX,        -- Base | Defend boundary
	["TeamAMidpointZoneWall"] = zone2EndX,    -- Defend | Neutral boundary
	["TeamBMidpointZoneWall"] = zone3EndX,    -- Neutral | Defend boundary
	["TeamBBaseZoneWall"] = zone4EndX         -- Defend | Base boundary
}

-- Find ZoneParts folder
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if not zonePartsFolder then
	warn("⚠ ZoneParts folder not found!")
	return
end

-- Find all zonewalls
local zoneWalls = {}
local function findZoneWalls(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and obj.Name:lower():find("wall") then
			table.insert(zoneWalls, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findZoneWalls(obj)
		end
	end
end

findZoneWalls(zonePartsFolder)

if #zoneWalls == 0 then
	warn("⚠ No ZoneWalls found!")
	return
end

print("  ✓ Found " .. #zoneWalls .. " ZoneWall(s)")
print("")

-- Calculate Z span (from baseplate edge to edge)
local zSpan = baseplateMaxZ - baseplateMinZ

-- Calculate wall height (from baseplate top to ceiling bottom)
local wallHeight = ceilingY - baseplateTop

print("  ZoneWall specifications:")
print("    Z span: " .. string.format("%.2f", zSpan) .. " (from " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ) .. ")")
print("    Height: " .. string.format("%.2f", wallHeight) .. " (from baseplate top to ceiling)")
print("")

-- Align each zonewall to its terrain boundary
print("=== Aligning ZoneWalls to Terrain Boundaries ===")
print("")

for _, zoneWall in ipairs(zoneWalls) do
	local wallName = zoneWall.Name
	local targetX = zoneWallPositions[wallName]
	
	if not targetX then
		warn("  ⚠ No terrain boundary defined for " .. wallName)
		print("    Keeping current X position: " .. string.format("%.2f", zoneWall.Position.X))
	else
		print("  📏 Aligning " .. wallName .. "...")
		print("    Current X: " .. string.format("%.2f", zoneWall.Position.X))
		print("    Target X (terrain boundary): " .. string.format("%.2f", targetX))
		
		-- Determine which boundary this is
		local boundaryType = ""
		if wallName == "TeamABaseZoneWall" then
			boundaryType = "Base | Defend (left)"
		elseif wallName == "TeamAMidpointZoneWall" then
			boundaryType = "Defend | Neutral (left)"
		elseif wallName == "TeamBMidpointZoneWall" then
			boundaryType = "Neutral | Defend (right)"
		elseif wallName == "TeamBBaseZoneWall" then
			boundaryType = "Defend | Base (right)"
		end
		
		-- Set wall thickness (thin in X direction, the dividing dimension)
		-- Use a reasonable thickness (0.1 to 2 studs)
		local currentSize = zoneWall.Size
		local wallThickness = math.max(0.1, math.min(currentSize.X, 2)) -- Between 0.1 and 2 studs
		if wallThickness < 0.1 or wallThickness > 5 then
			wallThickness = 0.1 -- Default thin thickness
		end
		
		-- New size: thin in X, full height (Y), spans Z (north-south, which is east-west on the map)
		local newSize = Vector3.new(wallThickness, wallHeight, zSpan)
		
		-- New position: at terrain boundary X, center Y between baseplate and ceiling, center Z on baseplate
		local newX = targetX
		local newY = baseplateTop + (wallHeight / 2)
		local newZ = baseplatePos.Z
		
		-- Reset orientation to world-aligned (0, 0, 0) to prevent diagonal appearance
		-- Use CFrame to set both position and orientation
		local newCFrame = CFrame.new(newX, newY, newZ)
		
		-- Apply changes
		zoneWall.Size = newSize
		zoneWall.CFrame = newCFrame
		zoneWall.Orientation = Vector3.new(0, 0, 0) -- Ensure no rotation
		
		print("    → Boundary: " .. boundaryType)
		print("    → New Position: " .. string.format("%.2f", newX) .. ", " .. string.format("%.2f", newY) .. ", " .. string.format("%.2f", newZ))
		print("    → New Size: " .. string.format("%.2f", newSize.X) .. " x " .. string.format("%.2f", newSize.Y) .. " x " .. string.format("%.2f", newSize.Z))
		print("    → Spans Z from " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ))
		print("    → Height from baseplate top (" .. string.format("%.2f", baseplateTop) .. ") to ceiling (" .. string.format("%.2f", ceilingY) .. ")")
	end
	print("")
end

print("✅ ZoneWalls aligned to terrain boundaries!")
print("  ✓ All ZoneWalls now positioned at terrain zone boundaries")
print("  ✓ Spans from East wall to West wall (full Z span)")
print("  ✓ Spans from baseplate top to ceiling (full height)")

