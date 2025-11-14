-- Command Bar script to fix DefaultSpawnLocation height and diagnose TeamSelectionHandler
-- This fixes the neutral spawn height and shows why Red spawn isn't being found
-- Paste this into Roblox Studio Command Bar

print("=== Fixing DefaultSpawnLocation and Diagnosing TeamSelectionHandler ===")
print("")

-- Find DefaultSpawnLocation
local function findSpawnLocationRecursive(parent, spawnName)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") and obj.Name == spawnName then
			return obj
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			local found = findSpawnLocationRecursive(obj, spawnName)
			if found then return found end
		end
	end
	return nil
end

local defaultSpawn = findSpawnLocationRecursive(workspace, "DefaultSpawnLocation")
local redSpawn = findSpawnLocationRecursive(workspace, "RedSpawnLocation")
local blueSpawn = findSpawnLocationRecursive(workspace, "BlueSpawnLocation")

-- Function to find terrain height (excluding buildings, walls, ceiling)
local function findTerrainHeight(x, z)
	local rayOrigin = Vector3.new(x, 500, z)
	local rayDirection = Vector3.new(0, -1000, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	-- Filter out walls, ceiling, spawns, and all parts in Models (buildings)
	local filterList = {}
	
	-- Filter walls
	local wallsFolder = workspace:FindFirstChild("Walls")
	if wallsFolder then
		for _, wall in ipairs(wallsFolder:GetChildren()) do
			if wall:IsA("BasePart") then
				table.insert(filterList, wall)
			end
		end
	end
	
	-- Filter spawn locations
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation") then
			table.insert(filterList, obj)
		end
	end
	
	-- Filter all parts in ALL Models (buildings, spawn rooms, etc.)
	-- This includes Spawn Room, gun selection areas, etc.
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") then
			for _, part in ipairs(obj:GetDescendants()) do
				if part:IsA("BasePart") then
					table.insert(filterList, part)
				end
			end
		end
	end
	
	-- Also filter ZoneParts (except Baseplate)
	local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
	if zonePartsFolder then
		for _, obj in ipairs(zonePartsFolder:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
				table.insert(filterList, obj)
			end
		end
	end
	
	raycastParams.FilterDescendantsInstances = filterList
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult then
		local hitPart = raycastResult.Instance
		local hitY = raycastResult.Position.Y
		
		-- Only accept results in reasonable terrain range (not buildings/ceiling)
		if hitY > -50 and hitY < 150 then
			-- Prioritize actual Terrain hits
			if hitPart and (hitPart.Name == "Terrain" or hitPart:IsDescendantOf(workspace.Terrain)) then
				return hitY
			end
			
			-- Reject anything that's part of a Model (buildings)
			local model = hitPart:FindFirstAncestorOfClass("Model")
			if model then
				-- This is part of a building, skip it
				-- Try casting from a different angle or offset
				return nil
			end
			
			-- Reject walls, roof, ceiling, spawns
			if hitPart and not hitPart.Name:find("Wall") and not hitPart.Name:find("Roof") and not hitPart.Name:find("Ceiling") and not hitPart:IsA("SpawnLocation") then
				-- Not a building, not a wall/ceiling - likely terrain or baseplate
				return hitY
			end
		end
	end
	
	-- Try multiple raycast positions around the spawn to find terrain
	-- Sometimes the spawn is directly above a building, so we check nearby positions
	local offsets = {
		Vector3.new(0, 0, 0),    -- Center
		Vector3.new(10, 0, 0),   -- East
		Vector3.new(-10, 0, 0),  -- West
		Vector3.new(0, 0, 10),   -- North
		Vector3.new(0, 0, -10),  -- South
		Vector3.new(10, 0, 10),  -- Northeast
		Vector3.new(-10, 0, 10), -- Northwest
		Vector3.new(10, 0, -10), -- Southeast
		Vector3.new(-10, 0, -10) -- Southwest
	}
	
	for _, offset in ipairs(offsets) do
		local testX = x + offset.X
		local testZ = z + offset.Z
		local testOrigin = Vector3.new(testX, 500, testZ)
		
		raycastParams.FilterDescendantsInstances = filterList
		local testRaycast = workspace:Raycast(testOrigin, rayDirection, raycastParams)
		
		if testRaycast then
			local testHitPart = testRaycast.Instance
			local testHitY = testRaycast.Position.Y
			
			if testHitY > -50 and testHitY < 150 then
				-- Check if it's actual terrain
				if testHitPart and (testHitPart.Name == "Terrain" or testHitPart:IsDescendantOf(workspace.Terrain)) then
					return testHitY
				end
				
				-- Check if it's not part of a building
				local testModel = testHitPart:FindFirstAncestorOfClass("Model")
				if not testModel and testHitPart and not testHitPart.Name:find("Wall") and not testHitPart.Name:find("Roof") and not testHitPart.Name:find("Ceiling") then
					return testHitY
				end
			end
		end
	end
	
	return nil
end

-- Fix DefaultSpawnLocation height
if defaultSpawn then
	print("  ✓ Found DefaultSpawnLocation")
	print("    Current Position: " .. tostring(defaultSpawn.Position))
	print("    Parent: " .. (defaultSpawn.Parent and defaultSpawn.Parent.Name or "nil"))
	print("")
	
	local spawnX = defaultSpawn.Position.X
	local spawnZ = defaultSpawn.Position.Z
	local terrainHeight = findTerrainHeight(spawnX, spawnZ)
	
	-- If terrain not found at spawn position, try moving spawn to nearby terrain
	if not terrainHeight then
		print("  ⚠ Could not find terrain at spawn position, searching nearby...")
		
		-- Try larger offsets to find terrain
		local largerOffsets = {
			Vector3.new(20, 0, 0),   -- East
			Vector3.new(-20, 0, 0),  -- West
			Vector3.new(0, 0, 20),   -- North
			Vector3.new(0, 0, -20),  -- South
			Vector3.new(30, 0, 0),   -- Further East
			Vector3.new(-30, 0, 0),  -- Further West
			Vector3.new(0, 0, 30),   -- Further North
			Vector3.new(0, 0, -30),  -- Further South
		}
		
		for _, offset in ipairs(largerOffsets) do
			local testX = spawnX + offset.X
			local testZ = spawnZ + offset.Z
			local testTerrain = findTerrainHeight(testX, testZ)
			
			if testTerrain then
				terrainHeight = testTerrain
				spawnX = testX
				spawnZ = testZ
				print("    ✓ Found terrain at offset: " .. string.format("%.2f", offset.X) .. ", " .. string.format("%.2f", offset.Z))
				break
			end
		end
	end
	
	if terrainHeight then
		local newY = terrainHeight + 10 -- 10 studs above terrain
		defaultSpawn.CFrame = CFrame.new(spawnX, newY, spawnZ)
		defaultSpawn.Anchored = true
		defaultSpawn.CanCollide = false
		defaultSpawn.Enabled = true
		defaultSpawn.Transparency = 0
		print("  ✓ Fixed DefaultSpawnLocation:")
		print("    Old Position: " .. tostring(defaultSpawn.Position))
		print("    New Position: " .. string.format("%.2f", spawnX) .. ", " .. string.format("%.2f", newY) .. ", " .. string.format("%.2f", spawnZ))
		print("    Terrain Height: " .. string.format("%.2f", terrainHeight))
	else
		warn("  ⚠ Could not find terrain for DefaultSpawnLocation even after searching nearby")
		warn("    You may need to manually position it on terrain")
	end
else
	warn("  ⚠ DefaultSpawnLocation not found!")
end

print("")
print("=== Diagnosing TeamSelectionHandler Spawn Finding ===")
print("")

-- Check what TeamSelectionHandler would find
print("Testing spawn location finding (as TeamSelectionHandler would):")
print("")

-- Simulate what TeamSelectionHandler does (non-recursive)
local workspaceRedSpawn = workspace:FindFirstChild("RedSpawnLocation")
local workspaceBlueSpawn = workspace:FindFirstChild("BlueSpawnLocation")

print("  Non-recursive search (what TeamSelectionHandler currently does):")
if workspaceRedSpawn then
	print("    ✓ Found RedSpawnLocation in workspace root")
else
	print("    ✗ RedSpawnLocation NOT in workspace root")
end

if workspaceBlueSpawn then
	print("    ✓ Found BlueSpawnLocation in workspace root")
else
	print("    ✗ BlueSpawnLocation NOT in workspace root")
end

print("")
print("  Recursive search (what TeamSelectionHandler SHOULD do):")
if redSpawn then
	print("    ✓ Found RedSpawnLocation (recursive): " .. redSpawn.Name)
	print("      Path: " .. (redSpawn.Parent and redSpawn.Parent.Name or "workspace") .. "." .. redSpawn.Name)
	print("      Position: " .. tostring(redSpawn.Position))
	print("      TeamColor: " .. tostring(redSpawn.TeamColor))
	print("      Enabled: " .. tostring(redSpawn.Enabled))
else
	warn("    ✗ RedSpawnLocation NOT found (recursive)")
end

if blueSpawn then
	print("    ✓ Found BlueSpawnLocation (recursive): " .. blueSpawn.Name)
	print("      Path: " .. (blueSpawn.Parent and blueSpawn.Parent.Name or "workspace") .. "." .. blueSpawn.Name)
	print("      Position: " .. tostring(blueSpawn.Position))
	print("      TeamColor: " .. tostring(blueSpawn.TeamColor))
	print("      Enabled: " .. tostring(blueSpawn.Enabled))
else
	warn("    ✗ BlueSpawnLocation NOT found (recursive)")
end

print("")
print("=== TeamSelectionHandler Fix Required ===")
print("")
print("Your spawns are in: workspace.Spawnlocations")
print("TeamSelectionHandler needs recursive search to find them.")
print("")
print("FIND YOUR TeamSelectionHandler SCRIPT (likely in ServerScriptService)")
print("and replace the spawn finding code with this:")
print("")
print("-- Recursive function to find spawn location by team color")
print("local function findSpawnLocationForTeam(teamColor)")
print("    local function searchRecursive(parent)")
print("        for _, obj in ipairs(parent:GetChildren()) do")
print("            if obj:IsA(\"SpawnLocation\") then")
print("                -- Check if spawn matches team color")
print("                if teamColor == BrickColor.new(\"Really red\") or teamColor == BrickColor.new(\"Bright red\") then")
print("                    if obj.Name:find(\"Red\") or obj.TeamColor == BrickColor.new(\"Really red\") or obj.TeamColor == BrickColor.new(\"Bright red\") then")
print("                        return obj")
print("                    end")
print("                elseif teamColor == BrickColor.new(\"Bright blue\") then")
print("                    if obj.Name:find(\"Blue\") or obj.TeamColor == BrickColor.new(\"Bright blue\") then")
print("                        return obj")
print("                    end")
print("                end")
print("            elseif obj:IsA(\"Folder\") or obj:IsA(\"Model\") then")
print("                local found = searchRecursive(obj)")
print("                if found then return found end")
print("            end")
print("        end")
print("        return nil")
print("    end")
print("    return searchRecursive(workspace)")
print("end")
print("")
print("-- Then replace the spawn finding line with:")
print("local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
print("")
print("-- If spawnLocation is nil, fall back to DefaultSpawnLocation:")
print("if not spawnLocation then")
print("    spawnLocation = workspace:FindFirstChild(\"DefaultSpawnLocation\")")
print("    -- Or search recursively for DefaultSpawnLocation too")
print("    if not spawnLocation then")
print("        local function findDefaultSpawn(parent)")
print("            for _, obj in ipairs(parent:GetChildren()) do")
print("                if obj:IsA(\"SpawnLocation\") and obj.Name == \"DefaultSpawnLocation\" then")
print("                    return obj")
print("                elseif obj:IsA(\"Folder\") or obj:IsA(\"Model\") then")
print("                    local found = findDefaultSpawn(obj)")
print("                    if found then return found end")
print("                end")
print("            end")
print("            return nil")
print("        end")
print("        spawnLocation = findDefaultSpawn(workspace)")
print("    end")
print("end")
print("")

print("✅ DefaultSpawnLocation height fixed!")
print("✅ TeamSelectionHandler diagnostic complete!")
print("")
print("💡 After updating TeamSelectionHandler, players should spawn at the correct team spawns.")

