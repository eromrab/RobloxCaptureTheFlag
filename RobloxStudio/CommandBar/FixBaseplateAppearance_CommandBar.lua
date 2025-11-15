-- FIX BASEPLATE APPEARANCE - Command Bar Script
-- This script fixes the baseplate to look green (not like legos)
-- Paste this into Roblox Studio Command Bar

print("=== Fix Baseplate Appearance ===")

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

-- Fix the appearance to be green (not legos)
print("\n🎨 Fixing baseplate appearance...")

-- Set to green material
baseplate.Material = Enum.Material.Grass
baseplate.Color = Color3.fromRGB(34, 139, 34) -- Forest green
baseplate.BrickColor = BrickColor.new("Bright green")

-- Remove any texture/decals that might make it look like legos
for _, child in ipairs(baseplate:GetChildren()) do
	if child:IsA("Texture") or child:IsA("Decal") then
		child:Destroy()
		print("  ✓ Removed " .. child.ClassName .. ": " .. child.Name)
	end
end

-- Make sure it's visible and functional
baseplate.Transparency = 0
baseplate.CanCollide = true
baseplate.CanQuery = true
baseplate.CanTouch = true

print("  ✓ Set Material: Grass")
print("  ✓ Set Color: Green")
print("  ✓ Removed textures/decals")
print("  ✓ Made visible and functional")

print("\n✅ Baseplate appearance fixed!")
print("💡 The baseplate should now appear green instead of looking like legos")

