-- Command Bar script to find and fix TeamSelectionHandler to use recursive spawn search
-- This will locate the script and show you exactly what to change
-- Paste this into Roblox Studio Command Bar

print("=== Finding and Fixing TeamSelectionHandler ===")
print("")

-- Search for TeamSelectionHandler script
local function findScriptRecursive(parent, scriptName)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
			if obj.Name:find(scriptName) or obj.Name:lower():find(scriptName:lower()) then
				return obj
			end
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			local found = findScriptRecursive(obj, scriptName)
			if found then return found end
		end
	end
	return nil
end

-- Search in common locations
local teamSelectionHandler = nil
local searchLocations = {
	game:GetService("ServerScriptService"),
	game:GetService("StarterPlayer"),
	game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"),
	game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts"),
	workspace
}

for _, location in ipairs(searchLocations) do
	if location then
		teamSelectionHandler = findScriptRecursive(location, "TeamSelection")
		if teamSelectionHandler then
			break
		end
	end
end

if not teamSelectionHandler then
	warn("⚠ TeamSelectionHandler script not found!")
	print("")
	print("Please manually find your TeamSelectionHandler script.")
	print("It's likely in ServerScriptService.")
	print("")
	print("Once you find it, add this recursive function at the top:")
	print("")
else
	print("  ✓ Found TeamSelectionHandler: " .. teamSelectionHandler.Name)
	print("    Location: " .. teamSelectionHandler:GetFullName())
	print("")
	
	-- Read the script content
	local success, source = pcall(function()
		return teamSelectionHandler.Source
	end)
	
	if success and source then
		-- Check if it already has recursive search
		if source:find("searchRecursive") or source:find("findSpawnLocationRecursive") then
			print("  ℹ Script already appears to have recursive search!")
			print("    But it's still not working. Checking spawn finding code...")
			print("")
		else
			print("  ⚠ Script does NOT have recursive search!")
			print("    This is why Red spawn isn't being found.")
			print("")
		end
		
		-- Look for spawn location finding code
		if source:find("SpawnLocation") then
			print("  ✓ Found spawn location code in script")
			print("")
			print("  📝 CURRENT CODE (what needs to be replaced):")
			print("")
			-- Try to find the relevant lines
			local lines = {}
			for line in source:gmatch("[^\r\n]+") do
				table.insert(lines, line)
			end
			
			local foundSpawnCode = false
			for i, line in ipairs(lines) do
				if line:find("SpawnLocation") or line:find("spawnLocation") or line:find("spawn") then
					if not foundSpawnCode then
						print("    Around line " .. i .. ":")
						foundSpawnCode = true
					end
					-- Show context (3 lines before and after)
					local start = math.max(1, i - 3)
					local finish = math.min(#lines, i + 3)
					for j = start, finish do
						local marker = (j == i) and ">>> " or "    "
						print(marker .. lines[j])
					end
					print("")
					break
				end
			end
		end
	else
		warn("  ⚠ Could not read script source")
	end
end

print("")
print("=== EXACT FIX TO ADD ===")
print("")
print("Add this function to your TeamSelectionHandler script (at the top, after variable declarations):")
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
print("=== REPLACE THE SPAWN FINDING LINE ===")
print("")
print("Find the line that looks like:")
print("    local spawnLocation = workspace:FindFirstChild(\"RedSpawnLocation\")")
print("    -- or")
print("    local spawnLocation = player:FindFirstChildOfClass(\"SpawnLocation\")")
print("    -- or similar")
print("")
print("Replace it with:")
print("    local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
print("")
print("=== VERIFY SPAWN LOCATIONS ===")
print("")

-- Verify spawns exist
local function findSpawnRecursive(parent, spawnName)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") and obj.Name == spawnName then
			return obj
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			local found = findSpawnRecursive(obj, spawnName)
			if found then return found end
		end
	end
	return nil
end

local redSpawn = findSpawnRecursive(workspace, "RedSpawnLocation")
local blueSpawn = findSpawnRecursive(workspace, "BlueSpawnLocation")
local defaultSpawn = findSpawnRecursive(workspace, "DefaultSpawnLocation")

if redSpawn then
	print("  ✓ RedSpawnLocation found at: " .. redSpawn:GetFullName())
	print("    Position: " .. tostring(redSpawn.Position))
	print("    TeamColor: " .. tostring(redSpawn.TeamColor))
	print("    Enabled: " .. tostring(redSpawn.Enabled))
else
	warn("  ✗ RedSpawnLocation NOT FOUND!")
end

if blueSpawn then
	print("  ✓ BlueSpawnLocation found at: " .. blueSpawn:GetFullName())
	print("    Position: " .. tostring(blueSpawn.Position))
	print("    TeamColor: " .. tostring(blueSpawn.TeamColor))
	print("    Enabled: " .. tostring(blueSpawn.Enabled))
else
	warn("  ✗ BlueSpawnLocation NOT FOUND!")
end

if defaultSpawn then
	print("  ✓ DefaultSpawnLocation found at: " .. defaultSpawn:GetFullName())
	print("    Position: " .. tostring(defaultSpawn.Position))
else
	warn("  ✗ DefaultSpawnLocation NOT FOUND!")
end

print("")
print("✅ Diagnostic complete!")
print("")
print("💡 After adding the recursive function to TeamSelectionHandler,")
print("   players should spawn at the correct team spawns instead of DefaultSpawnLocation.")

