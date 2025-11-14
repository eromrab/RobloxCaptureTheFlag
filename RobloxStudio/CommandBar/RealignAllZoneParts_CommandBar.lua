-- Command Bar script to realign all ZoneParts to match current baseplate layout
-- This will reposition all ZoneParts (except Baseplate) based on the current baseplate position/size/rotation
-- Paste this into Roblox Studio Command Bar

print("=== Realigning All ZoneParts to Current Baseplate ===")

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
print("    Position: " .. tostring(baseplate.Position))
print("    Size: " .. tostring(baseplate.Size))
print("    Rotation: " .. tostring(baseplate.Orientation))
print("")

-- Get baseplate properties
local baseplateCF = baseplate.CFrame
local baseplatePos = baseplate.Position
local baseplateSize = baseplate.Size
local baseplateTop = baseplatePos.Y + (baseplateSize.Y / 2)
local baseplateBottom = baseplatePos.Y - (baseplateSize.Y / 2)
local baseplateCF = baseplate.CFrame

-- Calculate baseplate boundaries
local baseplateMinX = baseplatePos.X - (baseplateSize.X / 2)
local baseplateMaxX = baseplatePos.X + (baseplateSize.X / 2)
local baseplateMinZ = baseplatePos.Z - (baseplateSize.Z / 2)
local baseplateMaxZ = baseplatePos.Z + (baseplateSize.Z / 2)

print("  Baseplate boundaries:")
print("    X: " .. string.format("%.2f", baseplateMinX) .. " to " .. string.format("%.2f", baseplateMaxX))
print("    Z: " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ))
print("    Y: " .. string.format("%.2f", baseplateBottom) .. " to " .. string.format("%.2f", baseplateTop))
print("")

-- Find ZoneParts folder
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if not zonePartsFolder then
	warn("⚠ ZoneParts folder not found!")
	return
end

print("  ✓ Found ZoneParts folder")
print("")

-- Find all ZoneParts (excluding Baseplate)
local zoneParts = {}
local function findZoneParts(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
			table.insert(zoneParts, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findZoneParts(obj)
		end
	end
end

findZoneParts(zonePartsFolder)

if #zoneParts == 0 then
	warn("⚠ No ZoneParts found (excluding Baseplate)!")
	print("  Objects in ZoneParts folder:")
	for _, obj in ipairs(zonePartsFolder:GetChildren()) do
		print("    - " .. obj.Name .. " (" .. obj.ClassName .. ")")
	end
	return
end

print("  ✓ Found " .. #zoneParts .. " ZonePart(s) to realign")
print("")

-- Find Walls folder for ceiling reference
local wallsFolder = workspace:FindFirstChild("Walls")
local ceiling = nil
if wallsFolder then
	ceiling = wallsFolder:FindFirstChild("Roof") or wallsFolder:FindFirstChild("Ceiling")
end

local ceilingY = nil
if ceiling then
	ceilingY = ceiling.Position.Y - (ceiling.Size.Y / 2)
	print("  ✓ Found ceiling at Y = " .. string.format("%.2f", ceilingY))
else
	-- Estimate ceiling height (typically 150+ studs above baseplate)
	ceilingY = baseplateTop + 150
	print("  ⚠ Ceiling not found, using estimated height: Y = " .. string.format("%.2f", ceilingY))
end
print("")

-- Realign each ZonePart
local alignedCount = 0

for _, zonePart in ipairs(zoneParts) do
	print("  📏 Realigning " .. zonePart.Name .. "...")
	
	local currentPos = zonePart.Position
	local currentSize = zonePart.Size
	local nameLower = zonePart.Name:lower()
	
	-- Determine what type of zone part this is
	local isZoneWall = nameLower:find("wall")
	local isZoneFloor = nameLower:find("floor")
	
	local newPos = currentPos
	local newSize = currentSize
	
	-- For zone walls: they should be oriented EAST/WEST (vertical dividers)
	-- They span Z from baseplate min to max (side to side), and Y from baseplate TOP to ceiling
	if isZoneWall then
		-- Zone walls are vertical dividers that run north/south (spanning Z)
		-- They should be thin in X (the dividing dimension) and span Z (north/south/east-west)
		-- They should span from baseplate TOP (not bottom) to ceiling
		
		-- Always make them vertical dividers (thin in X, long in Z)
		-- Keep X position relative to baseplate center (this is the dividing line)
		local relativeX = currentPos.X - baseplatePos.X
		local newX = baseplatePos.X + relativeX
		
		-- Span Z from baseplate min to max (side to side/east-west)
		local zSpan = baseplateMaxZ - baseplateMinZ
		
		-- Height from baseplate TOP to ceiling
		local wallHeight = ceilingY - baseplateTop
		
		-- Make it thin in X (use current X size if reasonable, otherwise 1-2 studs)
		local wallThickness = currentSize.X
		if wallThickness > 5 then
			wallThickness = 2 -- Default thickness for zone walls
		end
		
		newSize = Vector3.new(wallThickness, wallHeight, zSpan)
		
		-- Center Y between baseplate top and ceiling, center Z on baseplate
		newPos = Vector3.new(newX, baseplateTop + (wallHeight / 2), baseplatePos.Z)
		
		-- Set rotation to match baseplate (if baseplate is rotated)
		if baseplate.Orientation ~= Vector3.new(0, 0, 0) then
			zonePart.CFrame = baseplateCF * CFrame.new(relativeX, 0, 0) * CFrame.Angles(0, 0, 0)
		else
			zonePart.Size = newSize
			zonePart.Position = newPos
		end
		
		print("    → Vertical divider (East/West oriented):")
		print("      X position: " .. string.format("%.2f", newX) .. " (relative: " .. string.format("%.2f", relativeX) .. ")")
		print("      Z span: " .. string.format("%.2f", zSpan) .. " (from " .. string.format("%.2f", baseplateMinZ) .. " to " .. string.format("%.2f", baseplateMaxZ) .. ")")
		print("      Height: " .. string.format("%.2f", wallHeight) .. " (from baseplate top " .. string.format("%.2f", baseplateTop) .. " to ceiling " .. string.format("%.2f", ceilingY) .. ")")
		print("      Thickness (X): " .. string.format("%.2f", wallThickness))
		
	-- For zone floors: align to baseplate boundaries and position at baseplate top
	elseif isZoneFloor then
		-- Keep relative X/Z position, but adjust to baseplate boundaries if needed
		local relativeX = currentPos.X - baseplatePos.X
		local relativeZ = currentPos.Z - baseplatePos.Z
		
		-- Ensure floor is within baseplate bounds
		local floorMinX = math.max(baseplateMinX, baseplatePos.X + relativeX - (currentSize.X / 2))
		local floorMaxX = math.min(baseplateMaxX, baseplatePos.X + relativeX + (currentSize.X / 2))
		local floorMinZ = math.max(baseplateMinZ, baseplatePos.Z + relativeZ - (currentSize.Z / 2))
		local floorMaxZ = math.min(baseplateMaxZ, baseplatePos.Z + relativeZ + (currentSize.Z / 2))
		
		local floorX = (floorMinX + floorMaxX) / 2
		local floorZ = (floorMinZ + floorMaxZ) / 2
		local floorSizeX = floorMaxX - floorMinX
		local floorSizeZ = floorMaxZ - floorMinZ
		
		newSize = Vector3.new(floorSizeX, currentSize.Y, floorSizeZ)
		newPos = Vector3.new(floorX, baseplateTop + (currentSize.Y / 2), floorZ)
		
		print("    → Floor aligned to baseplate boundaries")
		print("    → Position: " .. string.format("%.2f", floorX) .. ", " .. string.format("%.2f", newPos.Y) .. ", " .. string.format("%.2f", floorZ))
		
	-- For other zone parts: keep relative position, adjust height if needed
	else
		local relativeX = currentPos.X - baseplatePos.X
		local relativeZ = currentPos.Z - baseplatePos.Z
		
		-- Adjust Y to be relative to baseplate if it seems misaligned
		-- If Y is way off from baseplate, adjust it
		if currentPos.Y < baseplateBottom - 50 or currentPos.Y > ceilingY + 50 then
			-- Part is way off, position it at a reasonable height
			newPos = Vector3.new(baseplatePos.X + relativeX, baseplateTop + 10, baseplatePos.Z + relativeZ)
			print("    → Y was way off, repositioned to baseplate top + 10")
		else
			-- Keep Y position but ensure it's relative to baseplate
			newPos = Vector3.new(baseplatePos.X + relativeX, currentPos.Y, baseplatePos.Z + relativeZ)
			print("    → Keeping relative X/Z, Y unchanged")
		end
	end
	
	-- Apply rotation if baseplate is rotated (for non-wall parts)
	if not isZoneWall and baseplate.Orientation ~= Vector3.new(0, 0, 0) then
		-- Calculate relative position in baseplate's local space
		local relativePos = newPos - baseplatePos
		local rotatedRelativePos = baseplateCF:VectorToObjectSpace(relativePos)
		newPos = baseplatePos + rotatedRelativePos
		
		-- Also rotate the part's orientation to match baseplate
		zonePart.CFrame = baseplateCF * CFrame.new(relativePos) * CFrame.Angles(0, 0, 0)
		print("    → Applied baseplate rotation")
	end
	
	-- Apply changes (if not already applied for walls with rotation)
	if not (isZoneWall and baseplate.Orientation ~= Vector3.new(0, 0, 0)) then
		zonePart.Size = newSize
		zonePart.Position = newPos
	end
	
	print("    ✓ New Position: " .. tostring(newPos))
	print("    ✓ New Size: " .. tostring(newSize))
	print("")
	
	alignedCount = alignedCount + 1
end

print("✅ Realignment complete!")
print("  ✓ Realigned " .. alignedCount .. " ZonePart(s) to match current baseplate layout")
print("  💡 All ZoneParts are now positioned relative to the current baseplate")

