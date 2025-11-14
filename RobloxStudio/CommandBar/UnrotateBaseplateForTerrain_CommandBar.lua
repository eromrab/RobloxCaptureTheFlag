-- Command Bar script to un-rotate baseplate for terrain generation
-- Terrain generation needs the baseplate to be world-aligned (0 rotation)
-- This script rotates the baseplate back to 0 while keeping spawns/walls rotated

print("=== Un-rotating Baseplate for Terrain Generation ===")
print("")
print("This will rotate the baseplate back to 0 degrees so terrain")
print("generation works correctly, while keeping spawns/walls rotated.")
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
print("    Current rotation: " .. tostring(baseplate.Orientation))

-- Check if baseplate is already at 0 rotation
if baseplate.Orientation.Y == 0 then
	print("  ✓ Baseplate is already at 0 rotation!")
	return
end

-- Get current rotation
local currentRotation = baseplate.Orientation.Y
local rotationToApply = -currentRotation

print("  Rotating baseplate by " .. string.format("%.2f", rotationToApply) .. " degrees...")

-- Get baseplate center
local centerPoint = baseplate.Position

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

-- Rotate baseplate back to 0
rotatePart(baseplate, centerPoint, math.rad(rotationToApply))

print("  ✓ Baseplate rotated to: " .. tostring(baseplate.Orientation))
print("")
print("✅ Baseplate is now world-aligned (0 rotation)")
print("")
print("💡 You can now run SculptTerrain_CommandBar.lua to regenerate terrain")
print("💡 The terrain will be generated correctly aligned with the baseplate")
print("💡 Spawns and walls remain rotated for North-South orientation")
print("")

