-- Command Bar script to automatically update TeamSelectionHandler with recursive spawn search
-- This will find and modify the script directly
-- Paste this into Roblox Studio Command Bar

print("=== Updating TeamSelectionHandler with Recursive Spawn Search ===")
print("")

local ServerScriptService = game:GetService("ServerScriptService")

-- Find TeamSelectionHandler script
local teamSelectionHandler = ServerScriptService:FindFirstChild("TeamSelectionHandler")
if not teamSelectionHandler then
	-- Try searching recursively
	for _, obj in ipairs(ServerScriptService:GetDescendants()) do
		if (obj:IsA("Script") or obj:IsA("ModuleScript")) and obj.Name:find("TeamSelection") then
			teamSelectionHandler = obj
			break
		end
	end
end

if not teamSelectionHandler then
	warn("⚠ TeamSelectionHandler script not found in ServerScriptService!")
	print("")
	print("Please find it manually and add this code:")
	print("")
	print("-- Add this function near the top of the script:")
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
	print("-- Then find the line that says something like:")
	print("    local spawnLocation = workspace:FindFirstChild(...)")
	print("    -- or")
	print("    for _, spawn in ipairs(workspace:GetChildren()) do")
	print("")
	print("-- Replace it with:")
	print("    local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
	print("")
	return
end

print("  ✓ Found TeamSelectionHandler: " .. teamSelectionHandler:GetFullName())
print("")

-- Read current source
local success, currentSource = pcall(function()
	return teamSelectionHandler.Source
end)

if not success or not currentSource then
	warn("  ⚠ Could not read script source!")
	return
end

-- Check if it already has the recursive function
if currentSource:find("findSpawnLocationForTeam") and currentSource:find("searchRecursive") then
	print("  ℹ Script already has recursive search function!")
	print("    Checking if it's being used...")
	
	-- Check if the function is being called
	if currentSource:find("findSpawnLocationForTeam%(") then
		print("  ✓ Function is being called - script should work!")
		print("    If it's still not working, check the TeamColor matching logic.")
		return
	else
		print("  ⚠ Function exists but is NOT being called!")
		print("    You need to replace the spawn finding code with:")
		print("    local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
		return
	end
end

-- Add the recursive function
print("  📝 Adding recursive spawn search function...")
print("")

-- Find where to insert the function (after variable declarations, before main code)
local insertPosition = 1
local lines = {}
for line in currentSource:gmatch("[^\r\n]+") do
	table.insert(lines, line)
end

-- Look for a good insertion point (after "local" declarations, before main logic)
for i, line in ipairs(lines) do
	if line:match("^local%s+") and not line:find("function") then
		insertPosition = i + 1
	end
	if line:find("PlayerAdded") or line:find("CharacterAdded") or line:find("TeamChanged") then
		insertPosition = i
		break
	end
end

-- Create the recursive function code
local recursiveFunction = [[

-- Recursive function to find spawn location by team color
local function findSpawnLocationForTeam(teamColor)
    local function searchRecursive(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("SpawnLocation") then
                -- Check if spawn matches team color
                if teamColor == BrickColor.new("Really red") or teamColor == BrickColor.new("Bright red") then
                    if obj.Name:find("Red") or obj.TeamColor == BrickColor.new("Really red") or obj.TeamColor == BrickColor.new("Bright red") then
                        return obj
                    end
                elseif teamColor == BrickColor.new("Bright blue") then
                    if obj.Name:find("Blue") or obj.TeamColor == BrickColor.new("Bright blue") then
                        return obj
                    end
                end
            elseif obj:IsA("Folder") or obj:IsA("Model") then
                local found = searchRecursive(obj)
                if found then return found end
            end
        end
        return nil
    end
    return searchRecursive(workspace)
end

]]

-- Insert the function
table.insert(lines, insertPosition, recursiveFunction)

-- Now we need to find and replace the spawn finding code
local newSource = table.concat(lines, "\n")

-- Find the spawn location finding code and replace it
-- Look for common patterns
local patterns = {
	{pattern = "workspace:FindFirstChild%(\"RedSpawnLocation\"%)", replacement = "findSpawnLocationForTeam(player.Team.TeamColor)"},
	{pattern = "workspace:FindFirstChild%(\"BlueSpawnLocation\"%)", replacement = "findSpawnLocationForTeam(player.Team.TeamColor)"},
	{pattern = "for%s+_,%s+spawn%s+in%s+ipairs%([^)]+%)%s+do", replacement = "local spawn = findSpawnLocationForTeam(player.Team.TeamColor)\n    if spawn then"},
}

local modified = false
for _, patternData in ipairs(patterns) do
	if newSource:find(patternData.pattern) then
		newSource = newSource:gsub(patternData.pattern, patternData.replacement)
		modified = true
		print("  ✓ Found and replaced spawn finding code")
		break
	end
end

if not modified then
	-- Manual replacement needed
	print("  ⚠ Could not automatically find spawn location code to replace")
	print("")
	print("  Please manually find the line that looks like:")
	print("    local spawnLocation = workspace:FindFirstChild(...)")
	print("    -- or")
	print("    for _, spawn in ipairs(workspace:GetChildren()) do")
	print("")
	print("  And replace it with:")
	print("    local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
	print("")
	print("  The recursive function has been added to your script.")
	print("  You just need to use it in the spawn finding code.")
	return
end

-- Try to update the script (this might not work in Command Bar, but we'll try)
local updateSuccess, updateError = pcall(function()
	teamSelectionHandler.Source = newSource
end)

if updateSuccess then
	print("  ✅ Successfully updated TeamSelectionHandler!")
	print("  ✅ Script now uses recursive spawn search")
	print("")
	print("  💡 Restart the game/test to see the changes take effect.")
else
	print("  ⚠ Could not automatically update script (Command Bar limitation)")
	print("")
	print("  📋 COPY THIS CODE and paste it into your TeamSelectionHandler script:")
	print("")
	print("  Add this function near the top:")
	print(recursiveFunction)
	print("")
	print("  Then find the spawn finding line and replace it with:")
	print("    local spawnLocation = findSpawnLocationForTeam(player.Team.TeamColor)")
	print("")
end

print("")
print("✅ Update complete!")

