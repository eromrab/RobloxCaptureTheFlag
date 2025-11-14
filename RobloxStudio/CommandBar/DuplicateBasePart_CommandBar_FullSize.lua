-- Command Bar script to duplicate Baseplate, Walls, and Roof from GameRoom model
-- Paste this into Roblox Studio Command Bar

print("=== Duplicate Baseplate, Walls, and Roof from GameRoom ===")
print("")

-- Find GameRoom model
local gameRoom = workspace:FindFirstChild("GameRoom")
if not gameRoom then
	warn("⚠ GameRoom model not found in workspace!")
	print("Available models in workspace:")
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") then
			print("  - " .. obj.Name)
		end
	end
	return
end

print("✓ GameRoom model found")
print("")

-- List all children of GameRoom for reference
print("📋 GameRoom structure:")
local function listChildren(parent, indent)
	indent = indent or ""
	for _, child in ipairs(parent:GetChildren()) do
		local typeStr = child.ClassName
		if child:IsA("BasePart") then
			typeStr = typeStr .. " (Size: " .. tostring(child.Size) .. ", Position: " .. tostring(child.Position) .. ")"
		end
		print(indent .. "  - " .. child.Name .. " [" .. typeStr .. "]")
		if child:IsA("Model") or child:IsA("Folder") then
			listChildren(child, indent .. "  ")
		end
	end
end
listChildren(gameRoom)
print("")

-- Find Baseplate
local baseplate = gameRoom:FindFirstChild("Baseplate", true) -- true = recursive search
if not baseplate then
	-- Try case-insensitive search for "baseplate"
	for _, obj in ipairs(gameRoom:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:lower() == "baseplate" then
			baseplate = obj
			break
		end
	end
end

if not baseplate then
	warn("⚠ Baseplate not found in GameRoom!")
	print("Available Baseplates in GameRoom:")
	for _, obj in ipairs(gameRoom:GetDescendants()) do
		if obj:IsA("BasePart") then
			print("  - " .. obj.Name .. " (at " .. tostring(obj:GetFullName()) .. ")")
		end
	end
	return
end

print("✓ Baseplate found: " .. baseplate:GetFullName())
print("  Size: " .. tostring(baseplate.Size))
print("  Position: " .. tostring(baseplate.Position))
print("")

-- Calculate appropriate spacing
-- Use a distance that's large enough to avoid physics overlap issues
-- Reduced to about half the original distance since exact distance doesn't affect load times
local partMaxSize = math.max(baseplate.Size.X, baseplate.Size.Y, baseplate.Size.Z)
local spacing = math.max(partMaxSize + 250, 500) -- At least 500 studs, or the largest dimension + 250

print("📏 Calculated spacing: " .. string.format("%.2f", spacing) .. " studs")
print("  (Based on part's largest dimension: " .. string.format("%.2f", partMaxSize) .. " studs)")
print("")

-- Determine placement direction
-- Place it East (along the +Z axis in Roblox's coordinate system)
local originalPos = baseplate.Position
local newPos = originalPos + Vector3.new(0, 0, spacing)  -- East is +Z direction

print("📍 Original position: " .. tostring(originalPos))
print("📍 New position: " .. tostring(newPos))
print("")

-- Find all walls and roof to duplicate (excluding zone walls)
local wallsAndRoof = {}
local wallNames = {"WestWall", "EastWall", "NorthWall", "SouthWall", "Roof"}

-- Search for walls and roof in GameRoom
for _, obj in ipairs(gameRoom:GetDescendants()) do
	if obj:IsA("BasePart") then
		local nameLower = obj.Name:lower()
		-- Check for main walls and roof only
		for _, wallName in ipairs(wallNames) do
			if nameLower == wallName:lower() then
				table.insert(wallsAndRoof, obj)
				break
			end
		end
	end
end

print("📦 Found " .. #wallsAndRoof .. " wall(s) and roof to duplicate")
for _, part in ipairs(wallsAndRoof) do
	print("  - " .. part.Name)
end
print("")

-- Create a new Model for the duplicated parts
local newModel = Instance.new("Model")
newModel.Name = "GameRoom_Copy"
newModel.Parent = workspace

-- Calculate the offset vector
local offset = newPos - originalPos

-- Clone the Baseplate
local baseplateClone = baseplate:Clone()
baseplateClone.Name = baseplate.Name
baseplateClone.CFrame = baseplate.CFrame + offset
baseplateClone.Parent = newModel

print("✓ Baseplate duplicated")

-- Clone all walls and roof
local clonedCount = 0
for _, part in ipairs(wallsAndRoof) do
	local clone = part:Clone()
	clone.Name = part.Name
	clone.CFrame = part.CFrame + offset
	clone.Parent = newModel
	clonedCount = clonedCount + 1
end

print("✓ " .. clonedCount .. " wall(s) and roof duplicated")
print("")
print("✓ All parts duplicated successfully!")
print("  Original Model: " .. gameRoom:GetFullName())
print("  Copy Model: " .. newModel:GetFullName())
print("  Total parts duplicated: " .. (1 + clonedCount))
print("  Distance between: " .. string.format("%.2f", spacing) .. " studs")
print("")

-- Visual confirmation
print("🎯 Layout:")
print("  | |                       | |")
print("  Original                 Copy")
print("  (" .. string.format("%.1f", originalPos.X) .. ", " .. string.format("%.1f", originalPos.Y) .. ", " .. string.format("%.1f", originalPos.Z) .. ")")
print("                              (" .. string.format("%.1f", newPos.X) .. ", " .. string.format("%.1f", newPos.Y) .. ", " .. string.format("%.1f", newPos.Z) .. ")")

