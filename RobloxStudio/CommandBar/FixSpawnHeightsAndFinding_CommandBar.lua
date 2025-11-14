-- Command Bar script to fix spawn heights and ensure they're findable
-- This adjusts spawn Y positions to terrain and ensures TeamSelectionHandler can find them
-- Paste this into Roblox Studio Command Bar

print("=== Fixing Spawn Heights and Finding ===")

local Workspace = game:GetService("Workspace")
local Terrain = workspace.Terrain

-- Recursive function to find spawn locations
local function findSpawnLocationRecursive(parent, teamName)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			if teamName == "Red Team" or teamName:find("Red") then
				if obj.Name:find("Red") or obj.TeamColor == BrickColor.new("Really red") or obj.TeamColor == BrickColor.new("Bright red") then
					return obj
				end
			else
				if obj.Name:find("Blue") or obj.TeamColor == BrickColor.new("Bright blue") then
					return obj
				end
			end
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			local found = findSpawnLocationRecursive(obj, teamName)
			if found then return found end
		end
	end
	return nil
end

-- Find spawns
local redSpawn = findSpawnLocationRecursive(workspace, "Red Team")
local blueSpawn = findSpawnLocationRecursive(workspace, "Blue Team")

if not redSpawn then
	warn("⚠ RedSpawnLocation not found!")
	return
end

if not blueSpawn then
	warn("⚠ BlueSpawnLocation not found!")
	return
end

print("  ✓ Found RedSpawnLocation: " .. redSpawn.Name .. " at " .. tostring(redSpawn.Position))
print("  ✓ Found BlueSpawnLocation: " .. blueSpawn.Name .. " at " .. tostring(blueSpawn.Position))
print("")

-- Function to find terrain height at a position
local function findTerrainHeight(x, z)
	local rayOrigin = Vector3.new(x, 500, z)
	local rayDirection = Vector3.new(0, -1000, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	-- Filter out walls, ceiling, spawns, and bots
	local filterList = {}
	local wallsFolder = workspace:FindFirstChild("Walls")
	if wallsFolder then
		for _, wall in ipairs(wallsFolder:GetChildren()) do
			if wall:IsA("BasePart") then
				table.insert(filterList, wall)
			end
		end
	end
	
	-- Filter out spawn locations
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation") then
			table.insert(filterList, obj)
		end
	end
	
	raycastParams.FilterDescendantsInstances = filterList
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult and raycastResult.Position.Y > -50 and raycastResult.Position.Y < 200 then
		local hitPart = raycastResult.Instance
		if hitPart and (hitPart.Name == "Terrain" or hitPart:IsDescendantOf(workspace.Terrain)) then
			return raycastResult.Position.Y
		elseif hitPart and not hitPart.Name:find("Wall") and not hitPart.Name:find("Roof") and not hitPart.Name:find("Ceiling") then
			return raycastResult.Position.Y
		end
	end
	
	-- Fallback: simple raycast
	local simpleRaycast = workspace:Raycast(rayOrigin, rayDirection)
	if simpleRaycast and simpleRaycast.Position.Y > -50 and simpleRaycast.Position.Y < 200 then
		return simpleRaycast.Position.Y
	end
	
	return nil
end

-- Adjust Red spawn
print("Adjusting RedSpawnLocation...")
local redX = redSpawn.Position.X
local redZ = redSpawn.Position.Z
local redTerrainHeight = findTerrainHeight(redX, redZ)

if redTerrainHeight then
	local newRedY = redTerrainHeight + 10 -- 10 studs above terrain
	redSpawn.CFrame = CFrame.new(redX, newRedY, redZ)
	redSpawn.Anchored = true
	redSpawn.CanCollide = false
	redSpawn.Enabled = true
	redSpawn.Transparency = 0
	print("  ✓ Adjusted RedSpawnLocation to Y = " .. string.format("%.2f", newRedY) .. " (terrain: " .. string.format("%.2f", redTerrainHeight) .. ")")
else
	warn("  ⚠ Could not find terrain height for Red spawn, keeping current Y")
end

-- Adjust Blue spawn
print("Adjusting BlueSpawnLocation...")
local blueX = blueSpawn.Position.X
local blueZ = blueSpawn.Position.Z
local blueTerrainHeight = findTerrainHeight(blueX, blueZ)

if blueTerrainHeight then
	local newBlueY = blueTerrainHeight + 10 -- 10 studs above terrain
	blueSpawn.CFrame = CFrame.new(blueX, newBlueY, blueZ)
	blueSpawn.Anchored = true
	blueSpawn.CanCollide = false
	blueSpawn.Enabled = true
	blueSpawn.Transparency = 0
	print("  ✓ Adjusted BlueSpawnLocation to Y = " .. string.format("%.2f", newBlueY) .. " (terrain: " .. string.format("%.2f", blueTerrainHeight) .. ")")
else
	warn("  ⚠ Could not find terrain height for Blue spawn, keeping current Y")
end

print("")
print("=== TeamSelectionHandler Fix ===")
print("")
print("Your spawns are in: workspace.Spawnlocations")
print("TeamSelectionHandler needs to search recursively to find them.")
print("")
print("Add this function to TeamSelectionHandler:")
print("")
print("local function findSpawnLocationForTeam(teamColor)")
print("    local function searchRecursive(parent)")
print("        for _, obj in ipairs(parent:GetChildren()) do")
print("            if obj:IsA(\"SpawnLocation\") then")
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
print("Then replace the spawn finding code with:")
print("local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
print("")

print("✅ Spawn heights adjusted and fix instructions provided!")

