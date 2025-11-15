-- REMOVE ALL SCULPTING - Command Bar Script
-- This script removes both terrain sculpting and Minecraft-style block sculpting
-- Paste this into Roblox Studio Command Bar

print("=== Remove All Sculpting ===")

-- Find Baseplate
local baseplate = workspace:FindFirstChild("Baseplate")
if not baseplate then
	baseplate = workspace:FindFirstChild("baseplate")
end
if not baseplate then
	baseplate = workspace:FindFirstChild("BasePlate")
end
if not baseplate then
	-- Search recursively
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
	warn("⚠ No Baseplate found!")
	return
end

print("  ✓ Found baseplate: " .. baseplate.Name)

-- Remove Minecraft-style block sculpting
print("\n🗑️ Removing block sculpting...")
local existingSculpted = workspace:FindFirstChild("SculptedBaseplate")
if existingSculpted then
	existingSculpted:Destroy()
	print("  ✓ Deleted SculptedBaseplate model")
else
	print("  ✓ No SculptedBaseplate found")
end

-- Also check for old overlay models
local existingOverlay = workspace:FindFirstChild("SculptedBaseplateOverlay")
if existingOverlay then
	existingOverlay:Destroy()
	print("  ✓ Deleted old SculptedBaseplateOverlay")
end

-- Restore original baseplate visibility and properties
baseplate.Transparency = 0
baseplate.CanCollide = true
baseplate.CanQuery = true
baseplate.CanTouch = true
print("  ✓ Restored original baseplate to visible")

-- Remove terrain sculpting
local Terrain = workspace.Terrain
if Terrain then
	print("\n🗑️ Removing terrain sculpting...")
	
	local baseplateSize = baseplate.Size
	local baseplatePos = baseplate.Position
	local baseplateY = baseplatePos.Y
	
	local success, errorMsg = pcall(function()
		-- Clear the area with Air (removes all terrain sculpting)
		local clearPosition = baseplatePos
		local clearSize = Vector3.new(baseplateSize.X + 100, baseplateSize.Y + 200, baseplateSize.Z + 100) -- Extra margin to catch edge terrain
		Terrain:FillBlock(CFrame.new(clearPosition), clearSize, Enum.Material.Air)
		
		-- Then fill with flat grass at baseplate level
		local grassThickness = 4 -- Standard voxel height
		local grassPosition = Vector3.new(baseplatePos.X, baseplateY, baseplatePos.Z)
		local grassSize = Vector3.new(baseplateSize.X, grassThickness, baseplateSize.Z)
		Terrain:FillBlock(CFrame.new(grassPosition), grassSize, Enum.Material.Grass)
	end)
	
	if success then
		print("  ✓ Terrain sculpting removed")
		print("  ✓ Flat grass terrain restored")
	else
		warn("  ⚠ Error removing terrain sculpting: " .. tostring(errorMsg))
	end
else
	print("\n🗑️ No Terrain found - skipping terrain removal")
end

print("\n✅ All sculpting removed!")
print("💡 Terrain sculpting: Removed")
print("💡 Block sculpting: Removed")
print("💡 Baseplate: Restored to visible and flat")

