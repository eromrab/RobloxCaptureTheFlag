-- Command Bar script to align ZoneWalls to touch East/West walls and baseplate/roof
-- This grabs coordinates of all 4 zonewalls and aligns them properly
-- Paste this into Roblox Studio Command Bar

print("=== Aligning ZoneWalls to Perimeter Walls ===")

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
print("    Top Y: " .. string.format("%.2f", baseplateTop))
print("")

-- Find Walls folder
local wallsFolder = workspace:FindFirstChild("Walls")
if not wallsFolder then
	warn("⚠ Walls folder not found!")
	return
end

-- Find East and West walls
local eastWall = wallsFolder:FindFirstChild("EastWall")
local westWall = wallsFolder:FindFirstChild("WestWall")
local roof = wallsFolder:FindFirstChild("Roof") or wallsFolder:FindFirstChild("Ceiling")

if not eastWall then
	warn("⚠ EastWall not found!")
	return
end

if not westWall then
	warn("⚠ WestWall not found!")
	return
end

if not roof then
	warn("⚠ Roof/Ceiling not found!")
	return
end

-- Calculate East and West wall inner edges (the edges facing the map interior)
local eastWallPos = eastWall.Position
local eastWallSize = eastWall.Size
local eastWallInnerX = eastWallPos.X - (eastWallSize.X / 2) -- Inner edge (facing map)

local westWallPos = westWall.Position
local westWallSize = westWall.Size
local westWallInnerX = westWallPos.X + (westWallSize.X / 2) -- Inner edge (facing map)

-- Calculate roof bottom
local roofPos = roof.Position
local roofSize = roof.Size
local roofBottomY = roofPos.Y - (roofSize.Y / 2)

print("  ✓ Found perimeter walls:")
print("    East Wall inner edge (X): " .. string.format("%.2f", eastWallInnerX))
print("    West Wall inner edge (X): " .. string.format("%.2f", westWallInnerX))
print("    Roof bottom (Y): " .. string.format("%.2f", roofBottomY))
print("")

-- Find ZoneParts folder
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if not zonePartsFolder then
	warn("⚠ ZoneParts folder not found!")
	return
end

-- Find all zonewalls (parts with "wall" in name, excluding Baseplate)
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

-- Calculate baseplate Z boundaries (for Z span)
local baseplateMinZ = baseplatePos.Z - (baseplateSize.Z / 2)
local baseplateMaxZ = baseplatePos.Z + (baseplateSize.Z / 2)
local zSpan = baseplateMaxZ - baseplateMinZ

-- Calculate wall height (from baseplate top to roof bottom)
local wallHeight = roofBottomY - baseplateTop

print("  ZoneWall specifications:")
print("    Z span: " .. string.format("%.2f", zSpan) .. " (from " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ) .. ")")
print("    Height: " .. string.format("%.2f", wallHeight) .. " (from baseplate top to roof bottom)")
print("    X span: " .. string.format("%.2f", eastWallInnerX - westWallInnerX) .. " (from West to East)")
print("")

-- Record current positions and align each zonewall
print("=== Recording and Aligning ZoneWalls ===")
print("")

local wallData = {}

for i, zoneWall in ipairs(zoneWalls) do
	local currentPos = zoneWall.Position
	local currentSize = zoneWall.Size
	
	-- Record current data
	table.insert(wallData, {
		name = zoneWall.Name,
		currentX = currentPos.X,
		currentY = currentPos.Y,
		currentZ = currentPos.Z,
		currentSizeX = currentSize.X,
		currentSizeY = currentSize.Y,
		currentSizeZ = currentSize.Z
	})
	
	print("  📏 ZoneWall " .. i .. ": " .. zoneWall.Name)
	print("    Current Position: " .. string.format("%.2f", currentPos.X) .. ", " .. string.format("%.2f", currentPos.Y) .. ", " .. string.format("%.2f", currentPos.Z))
	print("    Current Size: " .. string.format("%.2f", currentSize.X) .. " x " .. string.format("%.2f", currentSize.Y) .. " x " .. string.format("%.2f", currentSize.Z))
	
	-- Keep X position (this is the dividing line between zones)
	local newX = currentPos.X
	
	-- Make it thin in X (keep current thickness if reasonable, otherwise 1-2 studs)
	local wallThickness = currentSize.X
	if wallThickness > 5 then
		wallThickness = 2
	end
	
	-- New size: thin in X, full height, spans Z
	local newSize = Vector3.new(wallThickness, wallHeight, zSpan)
	
	-- New position: same X (dividing line), center Y between baseplate top and roof, center Z on baseplate
	local newY = baseplateTop + (wallHeight / 2)
	local newZ = baseplatePos.Z
	local newPos = Vector3.new(newX, newY, newZ)
	
	-- Apply changes
	zoneWall.Size = newSize
	zoneWall.Position = newPos
	
	print("    → New Position: " .. string.format("%.2f", newX) .. ", " .. string.format("%.2f", newY) .. ", " .. string.format("%.2f", newZ))
	print("    → New Size: " .. string.format("%.2f", newSize.X) .. " x " .. string.format("%.2f", newSize.Y) .. " x " .. string.format("%.2f", newSize.Z))
	print("    → Spans Z from " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ))
	print("    → Height from baseplate top (" .. string.format("%.2f", baseplateTop) .. ") to roof bottom (" .. string.format("%.2f", roofBottomY) .. ")")
	print("")
end

print("=== RECORDED ZONEWALL DATA ===")
print("")
print("local zoneWallData = {")
for i, data in ipairs(wallData) do
	local comma = (i < #wallData) and "," or ""
	print("  {")
	print("    name = \"" .. data.name .. "\"" .. comma)
	print("    currentX = " .. string.format("%.6f", data.currentX) .. comma)
	print("    currentY = " .. string.format("%.6f", data.currentY) .. comma)
	print("    currentZ = " .. string.format("%.6f", data.currentZ) .. comma)
	print("    currentSizeX = " .. string.format("%.6f", data.currentSizeX) .. comma)
	print("    currentSizeY = " .. string.format("%.6f", data.currentSizeY) .. comma)
	print("    currentSizeZ = " .. string.format("%.6f", data.currentSizeZ) .. comma)
	print("  }" .. comma)
end
print("}")
print("")

print("✅ ZoneWalls aligned!")
print("  ✓ All " .. #zoneWalls .. " ZoneWall(s) now:")
print("    - Span Z from baseplate edge to edge (side to side)")
print("    - Touch baseplate at the top")
print("    - Touch roof at the bottom")
print("    - Maintain their X positions (zone dividing lines)")

