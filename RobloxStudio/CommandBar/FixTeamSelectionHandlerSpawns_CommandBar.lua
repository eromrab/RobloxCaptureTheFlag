-- Command Bar script to provide recursive spawn location finding code
-- This shows the code that TeamSelectionHandler needs to use
-- Paste this into Roblox Studio Command Bar

print("=== TeamSelectionHandler Spawn Location Fix ===")
print("")
print("Your spawns are in: workspace.Spawnlocations")
print("  - RedSpawnLocation: workspace.Spawnlocations.RedSpawnLocation")
print("  - BlueSpawnLocation: workspace.Spawnlocations.BlueSpawnLocation")
print("")
print("=== CODE TO ADD TO TeamSelectionHandler ===")
print("")
print("Replace the spawn location finding code with this recursive function:")
print("")
print("-- Recursive function to find spawn location by team")
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
print("-- Then use it like this:")
print("local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
print("")
print("=== ALTERNATIVE: Quick Fix ===")
print("")
print("If you can't modify TeamSelectionHandler, you can move spawns to workspace root:")
print("")

-- Offer to move spawns to workspace root as a quick fix
local spawnlocationsFolder = workspace:FindFirstChild("Spawnlocations")
if spawnlocationsFolder then
	local redSpawn = spawnlocationsFolder:FindFirstChild("RedSpawnLocation")
	local blueSpawn = spawnlocationsFolder:FindFirstChild("BlueSpawnLocation")
	
	if redSpawn or blueSpawn then
		print("  Found Spawnlocations folder with spawns")
		print("  💡 Option: Move spawns to workspace root for TeamSelectionHandler compatibility")
		print("")
		print("  To move them, run:")
		if redSpawn then
			print("    workspace.Spawnlocations.RedSpawnLocation.Parent = workspace")
		end
		if blueSpawn then
			print("    workspace.Spawnlocations.BlueSpawnLocation.Parent = workspace")
		end
		print("")
		print("  Or keep them in folder and update TeamSelectionHandler to search recursively")
	else
		print("  Spawnlocations folder exists but no Red/Blue spawns found")
	end
else
	print("  Spawnlocations folder not found")
end

print("")
print("✅ Fix instructions provided!")

