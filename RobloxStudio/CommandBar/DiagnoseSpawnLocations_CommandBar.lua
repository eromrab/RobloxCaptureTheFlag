-- Command Bar script to diagnose spawn location finding issues
-- This will help identify why TeamSelectionHandler can't find Red/Blue spawns
-- Paste this into Roblox Studio Command Bar

print("=== Diagnosing Spawn Location Finding ===")

-- Recursive function to find all spawn locations
local function findAllSpawnLocations(parent, results, path)
	path = path or "workspace"
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			table.insert(results, {
				obj = obj,
				name = obj.Name,
				path = path .. "." .. obj.Name,
				teamColor = obj.TeamColor,
				position = obj.Position,
				enabled = obj.Enabled,
				parent = obj.Parent
			})
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findAllSpawnLocations(obj, results, path .. "." .. obj.Name)
		end
	end
end

local allSpawns = {}
findAllSpawnLocations(workspace, allSpawns)

print("  ✓ Found " .. #allSpawns .. " spawn location(s) total")
print("")

-- Categorize spawns
local redSpawns = {}
local blueSpawns = {}
local neutralSpawns = {}

for _, spawn in ipairs(allSpawns) do
	local nameLower = spawn.name:lower()
	local teamColor = spawn.teamColor
	
	if nameLower:find("red") or teamColor == BrickColor.new("Bright red") or teamColor == BrickColor.new("Really red") then
		table.insert(redSpawns, spawn)
	elseif nameLower:find("blue") or teamColor == BrickColor.new("Bright blue") then
		table.insert(blueSpawns, spawn)
	else
		table.insert(neutralSpawns, spawn)
	end
end

print("=== SPAWN LOCATION BREAKDOWN ===")
print("")

print("🔴 RED TEAM SPAWNS (" .. #redSpawns .. "):")
if #redSpawns > 0 then
	for _, spawn in ipairs(redSpawns) do
		print("  ✓ " .. spawn.name)
		print("    Path: " .. spawn.path)
		print("    TeamColor: " .. tostring(spawn.teamColor))
		print("    Position: " .. tostring(spawn.position))
		print("    Enabled: " .. tostring(spawn.enabled))
		print("    Parent: " .. (spawn.parent and spawn.parent.Name or "nil"))
		print("")
	end
else
	print("  ⚠ NO RED TEAM SPAWNS FOUND!")
	print("  💡 RedSpawnLocation should be in workspace or a folder")
	print("")
end

print("🔵 BLUE TEAM SPAWNS (" .. #blueSpawns .. "):")
if #blueSpawns > 0 then
	for _, spawn in ipairs(blueSpawns) do
		print("  ✓ " .. spawn.name)
		print("    Path: " .. spawn.path)
		print("    TeamColor: " .. tostring(spawn.teamColor))
		print("    Position: " .. tostring(spawn.position))
		print("    Enabled: " .. tostring(spawn.enabled))
		print("    Parent: " .. (spawn.parent and spawn.parent.Name or "nil"))
		print("")
	end
else
	print("  ⚠ NO BLUE TEAM SPAWNS FOUND!")
	print("  💡 BlueSpawnLocation should be in workspace or a folder")
	print("")
end

print("⚪ NEUTRAL/DEFAULT SPAWNS (" .. #neutralSpawns .. "):")
for _, spawn in ipairs(neutralSpawns) do
	print("  - " .. spawn.name)
	print("    Path: " .. spawn.path)
	print("    TeamColor: " .. tostring(spawn.teamColor))
	print("    Position: " .. tostring(spawn.position))
	print("")
end

print("=== RECOMMENDATIONS ===")
print("")

if #redSpawns == 0 then
	print("  ⚠ CRITICAL: No Red Team spawn found!")
	print("  💡 Make sure RedSpawnLocation exists and:")
	print("     - Name contains 'Red' OR")
	print("     - TeamColor is 'Bright red' or 'Really red'")
	print("")
end

if #blueSpawns == 0 then
	print("  ⚠ CRITICAL: No Blue Team spawn found!")
	print("  💡 Make sure BlueSpawnLocation exists and:")
	print("     - Name contains 'Blue' OR")
	print("     - TeamColor is 'Bright blue'")
	print("")
end

if #redSpawns > 0 and #blueSpawns > 0 then
	print("  ✓ Both team spawns found!")
	print("  💡 If TeamSelectionHandler still can't find them,")
	print("     it needs to search recursively (check folders)")
	print("")
end

print("✅ Diagnosis complete!")

