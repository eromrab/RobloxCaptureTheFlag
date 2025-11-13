-- RESET BASEPLATE TO FLAT - Command Bar Script
-- This script removes sculpting and restores the baseplate to flat
-- Paste this into Roblox Studio Command Bar

print("=== Reset Baseplate to Flat ===")

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

-- Delete sculpted overlay
print("\n🗑️ Removing sculpted overlay...")
local sculptedOverlay = workspace:FindFirstChild("SculptedBaseplateOverlay")
if sculptedOverlay then
	sculptedOverlay:Destroy()
	print("  ✓ Deleted SculptedBaseplateOverlay")
else
	print("  ✓ No sculpted overlay found")
end

-- Also check for old "SculptedBaseplate" (from older versions)
local oldSculpted = workspace:FindFirstChild("SculptedBaseplate")
if oldSculpted then
	oldSculpted:Destroy()
	print("  ✓ Deleted old SculptedBaseplate")
end

-- Restore original baseplate
print("\n🔄 Restoring original baseplate...")
baseplate.Transparency = 0
baseplate.CanCollide = true
baseplate.CanQuery = true
baseplate.CanTouch = true
print("  ✓ Baseplate restored to visible and functional")

-- Reset spawn locations to flat baseplate height
print("\n📍 Resetting spawn locations to flat baseplate...")
local baseplateTop = baseplate.Position.Y + (baseplate.Size.Y / 2)
local spawnLocations = {}
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("SpawnLocation") then
		table.insert(spawnLocations, obj)
	end
end

if #spawnLocations > 0 then
	print("  Found " .. #spawnLocations .. " spawn location(s)")
	
	for _, spawnLoc in ipairs(spawnLocations) do
		local spawnPos = spawnLoc.Position
		local spawnX = spawnPos.X
		local spawnZ = spawnPos.Z
		
		-- Check if spawn is within baseplate bounds
		local baseplateMinX = baseplate.Position.X - (baseplate.Size.X / 2)
		local baseplateMaxX = baseplate.Position.X + (baseplate.Size.X / 2)
		local baseplateMinZ = baseplate.Position.Z - (baseplate.Size.Z / 2)
		local baseplateMaxZ = baseplate.Position.Z + (baseplate.Size.Z / 2)
		
		if spawnX >= baseplateMinX and spawnX <= baseplateMaxX and
		   spawnZ >= baseplateMinZ and spawnZ <= baseplateMaxZ then
			
			-- Reset to flat baseplate top + half of spawn height
			local newY = baseplateTop + (spawnLoc.Size.Y / 2)
			spawnLoc.Position = Vector3.new(spawnX, newY, spawnZ)
			print("  ✓ Reset " .. spawnLoc.Name .. " to Y = " .. string.format("%.2f", newY))
		else
			print("  ⚠ " .. spawnLoc.Name .. " is outside baseplate bounds, keeping current position")
		end
	end
else
	print("  No spawn locations found")
end

print("\n✅ Baseplate reset to flat!")
print("💡 All sculpting removed and baseplate restored")

