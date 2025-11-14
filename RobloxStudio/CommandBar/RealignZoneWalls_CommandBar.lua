-- Realign ZoneWalls to Walls, Ceiling, and Baseplate
-- Run this in Command Bar to align ZoneWalls edges to perimeter walls and ceiling, and extend down to baseplate + 5

print("=== Realigning ZoneWalls ===")

-- Find ZoneParts folder
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if not zonePartsFolder then
	warn("⚠ ZoneParts folder not found!")
	return
end

print("✓ Found ZoneParts folder")

-- Find Walls folder and get perimeter walls
local wallsFolder = workspace:FindFirstChild("Walls")
if not wallsFolder then
	warn("⚠ Walls folder not found!")
	return
end

local northWall = wallsFolder:FindFirstChild("NorthWall")
local southWall = wallsFolder:FindFirstChild("SouthWall")
local eastWall = wallsFolder:FindFirstChild("EastWall")
local westWall = wallsFolder:FindFirstChild("WestWall")
local ceiling = wallsFolder:FindFirstChild("Ceiling") or wallsFolder:FindFirstChild("Roof")

if not (northWall or southWall or eastWall or westWall) then
	warn("⚠ No perimeter walls found in Walls folder!")
	print("  Available objects in Walls folder:")
	for _, obj in ipairs(wallsFolder:GetChildren()) do
		print("    - " .. obj.Name .. " (" .. obj.ClassName .. ")")
	end
	return
end

-- Find Baseplate
local baseplate = workspace:FindFirstChild("Baseplate")
if not baseplate then
	-- Try recursive search
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
	warn("⚠ Baseplate not found!")
	return
end

print("✓ Found Baseplate: " .. baseplate.Name)
local baseplateTop = baseplate.Position.Y + (baseplate.Size.Y / 2)
local baseplateBottom = baseplateTop - 5  -- 5 studs into baseplate

-- Get wall boundaries
local wallMinX, wallMaxX, wallMinZ, wallMaxZ
local ceilingY

if northWall then
	wallMaxZ = northWall.Position.Z - (northWall.Size.Z / 2)
	print("✓ Found NorthWall at Z = " .. northWall.Position.Z)
end
if southWall then
	wallMinZ = southWall.Position.Z + (southWall.Size.Z / 2)
	print("✓ Found SouthWall at Z = " .. southWall.Position.Z)
end
if eastWall then
	wallMaxX = eastWall.Position.X - (eastWall.Size.X / 2)
	print("✓ Found EastWall at X = " .. eastWall.Position.X)
end
if westWall then
	wallMinX = westWall.Position.X + (westWall.Size.X / 2)
	print("✓ Found WestWall at X = " .. westWall.Position.X)
end

if ceiling then
	ceilingY = ceiling.Position.Y - (ceiling.Size.Y / 2)
	print("✓ Found Ceiling/Roof at Y = " .. ceiling.Position.Y)
else
	warn("⚠ Ceiling/Roof not found! Will use wall height instead")
	-- Use wall height to estimate ceiling
	if northWall then
		ceilingY = northWall.Position.Y + (northWall.Size.Y / 2)
		print("  Using wall top as ceiling: Y = " .. ceilingY)
	end
end

if not ceilingY then
	warn("⚠ Could not determine ceiling height!")
	return
end

print("\n📐 Boundaries:")
print("  X: " .. (wallMinX or "?") .. " to " .. (wallMaxX or "?"))
print("  Z: " .. (wallMinZ or "?") .. " to " .. (wallMaxZ or "?"))
print("  Y: " .. baseplateBottom .. " to " .. ceilingY .. " (height: " .. (ceilingY - baseplateBottom) .. ")")

-- Find all ZoneWalls in ZoneParts folder
local zoneWalls = {}
local function findZoneWalls(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name:find("ZoneWall") then
			table.insert(zoneWalls, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findZoneWalls(obj)
		end
	end
end

findZoneWalls(zonePartsFolder)

if #zoneWalls == 0 then
	warn("⚠ No ZoneWalls found in ZoneParts folder!")
	print("  Objects in ZoneParts folder:")
	for _, obj in ipairs(zonePartsFolder:GetChildren()) do
		print("    - " .. obj.Name .. " (" .. obj.ClassName .. ")")
	end
	return
end

print("\n✓ Found " .. #zoneWalls .. " ZoneWall(s)")

-- Realign each ZoneWall
local alignedCount = 0
for _, zoneWall in ipairs(zoneWalls) do
	print("\n📏 Aligning " .. zoneWall.Name .. "...")
	print("  Current Position: " .. tostring(zoneWall.Position))
	print("  Current Size: " .. tostring(zoneWall.Size))
	
	local currentPos = zoneWall.Position
	local currentSize = zoneWall.Size
	
	-- Determine wall orientation based on size
	-- If X is very small, it's a vertical divider (extends in Z)
	-- If Z is very small, it's a horizontal divider (extends in X)
	local isVerticalDivider = currentSize.X < currentSize.Z
	local isHorizontalDivider = currentSize.Z < currentSize.X
	
	local newPos = currentPos
	local newSize = currentSize
	
	-- For vertical dividers (thin in X, long in Z): extend Z from South to North, keep X position
	-- For horizontal dividers (thin in Z, long in X): extend X from West to East, keep Z position
	if isVerticalDivider then
		-- Vertical divider: extend Z dimension to span from South to North walls
		if wallMinZ and wallMaxZ then
			local zSpan = wallMaxZ - wallMinZ
			newSize = Vector3.new(currentSize.X, currentSize.Y, zSpan)
			newPos = Vector3.new(currentPos.X, currentPos.Y, wallMinZ + (zSpan / 2))
			print("  → Vertical divider: Extending Z from " .. wallMinZ .. " to " .. wallMaxZ .. " (span: " .. zSpan .. ")")
		end
	elseif isHorizontalDivider then
		-- Horizontal divider: extend X dimension to span from West to East walls
		if wallMinX and wallMaxX then
			local xSpan = wallMaxX - wallMinX
			newSize = Vector3.new(xSpan, currentSize.Y, currentSize.Z)
			newPos = Vector3.new(wallMinX + (xSpan / 2), currentPos.Y, currentPos.Z)
			print("  → Horizontal divider: Extending X from " .. wallMinX .. " to " .. wallMaxX .. " (span: " .. xSpan .. ")")
		end
	else
		-- Square or unknown orientation - check which dimension is closer to a wall
		local distToWest = wallMinX and math.abs(currentPos.X - wallMinX) or math.huge
		local distToEast = wallMaxX and math.abs(currentPos.X - wallMaxX) or math.huge
		local distToSouth = wallMinZ and math.abs(currentPos.Z - wallMinZ) or math.huge
		local distToNorth = wallMaxZ and math.abs(currentPos.Z - wallMaxZ) or math.huge
		
		-- Extend to nearest walls
		if distToWest < 50 and wallMinX then
			newPos = Vector3.new(wallMinX + (newSize.X / 2), newPos.Y, newPos.Z)
			print("  → Aligning left edge to West wall")
		elseif distToEast < 50 and wallMaxX then
			newPos = Vector3.new(wallMaxX - (newSize.X / 2), newPos.Y, newPos.Z)
			print("  → Aligning right edge to East wall")
		end
		
		if distToSouth < 50 and wallMinZ then
			newPos = Vector3.new(newPos.X, newPos.Y, wallMinZ + (newSize.Z / 2))
			print("  → Aligning front edge to South wall")
		elseif distToNorth < 50 and wallMaxZ then
			newPos = Vector3.new(newPos.X, newPos.Y, wallMaxZ - (newSize.Z / 2))
			print("  → Aligning back edge to North wall")
		end
	end
	
	-- Align top to ceiling and bottom to baseplate + 5
	local wallHeight = ceilingY - baseplateBottom
	newSize = Vector3.new(newSize.X, wallHeight, newSize.Z)
	newPos = Vector3.new(newPos.X, baseplateBottom + (wallHeight / 2), newPos.Z)
	
	print("  → Aligning top to ceiling (Y = " .. ceilingY .. ")")
	print("  → Aligning bottom to baseplate + 5 (Y = " .. baseplateBottom .. ")")
	print("  → New height: " .. wallHeight)
	
	-- Apply changes
	zoneWall.Size = newSize
	zoneWall.Position = newPos
	
	print("  ✓ New Position: " .. tostring(newPos))
	print("  ✓ New Size: " .. tostring(newSize))
	
	alignedCount = alignedCount + 1
end

print("\n✅ Realignment complete!")
print("  ✓ Aligned " .. alignedCount .. " ZoneWall(s)")
print("  💡 ZoneWalls now align with perimeter walls, ceiling, and extend 5 studs into baseplate")

