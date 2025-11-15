-- RESTORE BASEPLATE - Command Bar Script
-- This script restores the baseplate to its original position and size
-- Paste this into Roblox Studio Command Bar
-- EDIT THE VALUES BELOW to match your original baseplate settings

print("=== Restore Baseplate ===")

-- EDIT THESE VALUES to match your original baseplate:
local ORIGINAL_POSITION = Vector3.new(381.5, -8, 84) -- Edit these numbers to match your original position
local ORIGINAL_SIZE = Vector3.new(1095, 16, 460) -- Edit these numbers to match your original size

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
print("    Current Position: " .. tostring(baseplate.Position))
print("    Current Size: " .. tostring(baseplate.Size))
print("")
print("    Restoring to:")
print("    Original Position: " .. tostring(ORIGINAL_POSITION))
print("    Original Size: " .. tostring(ORIGINAL_SIZE))

-- Restore position and size
baseplate.Position = ORIGINAL_POSITION
baseplate.Size = ORIGINAL_SIZE

-- Also restore other properties
baseplate.Transparency = 0
baseplate.CanCollide = true
baseplate.CanQuery = true
baseplate.CanTouch = true

print("\n✅ Baseplate restored!")
print("💡 If the values above are wrong, edit the ORIGINAL_POSITION and ORIGINAL_SIZE")
print("   variables at the top of this script and run it again.")

