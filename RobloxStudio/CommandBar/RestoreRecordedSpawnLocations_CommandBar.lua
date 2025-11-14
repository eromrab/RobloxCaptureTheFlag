-- Command Bar script to restore spawn locations to the exact recorded positions
-- Uses the positions you recorded earlier
-- Paste this into Roblox Studio Command Bar

print("=== Restoring Spawn Locations to Recorded Positions ===")

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

local baseplatePos = baseplate.Position
print("  ✓ Found baseplate at: " .. tostring(baseplatePos))
print("")

-- EXACT RECORDED POSITIONS (from your earlier recording)
local recordedSpawns = {
	["DefaultSpawnLocation"] = {
		absoluteX = -619.7276611328125,
		absoluteY = 45.79393005371094,
		absoluteZ = 17.47015380859375,
		anchored = true,
		canCollide = true,
		enabled = true,
		transparency = 0.00,
		teamColor = BrickColor.new("Medium stone grey"),
		parentName = "Spawn Room"
	},
	["RedSpawnLocation"] = {
		absoluteX = -132.00006103515625,
		absoluteY = 111.000000,
		absoluteZ = -112.000000,
		anchored = true,
		canCollide = false,
		enabled = true,
		transparency = 0.00,
		teamColor = BrickColor.new("Really red"),
		parentName = "Spawnlocations"
	},
	["BlueSpawnLocation"] = {
		absoluteX = 894.9999389648438,
		absoluteY = 108.45932006835938,
		absoluteZ = 280.000000,
		anchored = true,
		canCollide = false,
		enabled = true,
		transparency = 0.00,
		teamColor = BrickColor.new("Bright blue"),
		parentName = "Spawnlocations"
	}
}

-- Find all spawn locations recursively
local function findSpawnLocationsRecursive(parent)
	local spawns = {}
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			table.insert(spawns, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			local found = findSpawnLocationsRecursive(obj)
			for _, spawn in ipairs(found) do
				table.insert(spawns, spawn)
			end
		end
	end
	return spawns
end

local allSpawns = findSpawnLocationsRecursive(workspace)

if #allSpawns == 0 then
	warn("⚠ No spawn locations found!")
	return
end

print("  ✓ Found " .. #allSpawns .. " spawn location(s)")
print("")

-- Restore each spawn to its exact recorded position
local restoredCount = 0

for _, spawnLoc in ipairs(allSpawns) do
	local recordedData = recordedSpawns[spawnLoc.Name]
	
	if recordedData then
		-- Use EXACT absolute positions you recorded
		local spawnX = recordedData.absoluteX
		local spawnY = recordedData.absoluteY
		local spawnZ = recordedData.absoluteZ
		
		-- Set position to exact recorded coordinates
		spawnLoc.CFrame = CFrame.new(spawnX, spawnY, spawnZ)
		
		-- Set all properties exactly as recorded
		spawnLoc.Anchored = recordedData.anchored
		spawnLoc.CanCollide = recordedData.canCollide
		spawnLoc.Enabled = recordedData.enabled
		spawnLoc.Transparency = recordedData.transparency
		
		if recordedData.teamColor then
			spawnLoc.TeamColor = recordedData.teamColor
		end
		
		-- Set parent
		if recordedData.parentName then
			if recordedData.parentName == "workspace" then
				spawnLoc.Parent = workspace
			else
				local parentObj = workspace:FindFirstChild(recordedData.parentName)
				if parentObj then
					spawnLoc.Parent = parentObj
				else
					warn("  ⚠ Parent '" .. recordedData.parentName .. "' not found for " .. spawnLoc.Name .. ", keeping current parent")
				end
			end
		end
		
		restoredCount = restoredCount + 1
		print("  ✓ Restored " .. spawnLoc.Name .. " to EXACT recorded position:")
		print("    Position: " .. string.format("%.6f", spawnX) .. ", " .. string.format("%.6f", spawnY) .. ", " .. string.format("%.6f", spawnZ))
		print("    Parent: " .. (spawnLoc.Parent and spawnLoc.Parent.Name or "nil"))
		print("    Anchored: " .. tostring(spawnLoc.Anchored))
		print("    CanCollide: " .. tostring(spawnLoc.CanCollide))
		print("    Enabled: " .. tostring(spawnLoc.Enabled))
	else
		warn("  ⚠ No recorded position found for " .. spawnLoc.Name)
	end
end

print("")
print("✅ Restored " .. restoredCount .. " spawn location(s) to EXACT recorded positions!")
print("💡 These are the positions you manually set and recorded earlier.")

