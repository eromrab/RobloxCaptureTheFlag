-- FIX BOT SPAWNER ERROR - Command Bar Script
-- The error "attempt to index nil with 'Name'" on line 152
-- means something is nil when trying to access .Name
--
-- Run this to check the script and find the issue

local serverScriptService = game:GetService("ServerScriptService")
local botSpawner = serverScriptService:FindFirstChild("BotSpawner")

if botSpawner then
	print("Found BotSpawner script")
	print("Script type: " .. botSpawner.ClassName)
	
	-- Get lines around line 152
	local source = botSpawner.Source
	local lines = {}
	for line in string.gmatch(source, "[^\n]+") do
		table.insert(lines, line)
	end
	
	print("\nTotal lines in script: " .. #lines)
	
	-- Search for all .Name accesses in the script
	print("\nSearching for all .Name accesses in the script:")
	local nameAccesses = {}
	for i, line in ipairs(lines) do
		if string.find(line, "%.Name") then
			table.insert(nameAccesses, {line = i, content = line})
		end
	end
	
	if #nameAccesses > 0 then
		print("Found " .. #nameAccesses .. " line(s) with .Name access:")
		for _, access in ipairs(nameAccesses) do
			print("  Line " .. access.line .. ": " .. string.match(access.content, "^%s*(.-)%s*$"))
		end
		
		-- Check around the spawnBotsForPlayer function
		print("\nSearching for 'spawnBotsForPlayer' function:")
		local functionStart = nil
		for i, line in ipairs(lines) do
			if string.find(line, "function%s+spawnBotsForPlayer") or string.find(line, "spawnBotsForPlayer%s*=") then
				functionStart = i
				print("  Found function starting at line " .. i)
				break
			end
		end
		
		if functionStart then
			print("\nLines in spawnBotsForPlayer function (showing 20 lines):")
			for i = functionStart, math.min(functionStart + 20, #lines) do
				print("  " .. i .. ": " .. string.match(lines[i], "^%s*(.-)%s*$"))
			end
		end
	else
		print("  No .Name accesses found in script")
	end
	
	-- Also check for the specific error pattern
	print("\nChecking for potential nil access patterns:")
	for i, line in ipairs(lines) do
		-- Look for patterns like variable.Name where variable might be nil
		local pattern = "([%w_]+)%.Name"
		for varName in string.gmatch(line, pattern) do
			-- Check if there's a nil check before this line
			local hasCheck = false
			for j = math.max(1, i - 5), i - 1 do
				if string.find(lines[j], varName) and (string.find(lines[j], "if") or string.find(lines[j], "then")) then
					hasCheck = true
					break
				end
			end
			if not hasCheck then
				print("  ⚠ Line " .. i .. ": " .. varName .. ".Name (no nil check found)")
				print("    " .. string.match(line, "^%s*(.-)%s*$"))
			end
		end
	end
	
	print("\nTo fix:")
	print("1. Open ServerScriptService > BotSpawner in Roblox Studio")
	print("2. Go to line 152")
	print("3. Find the variable that's nil (before .Name)")
	print("4. Add a nil check before accessing .Name")
	print("Example fix:")
	print("  -- OLD: something.Name")
	print("  -- NEW: if something then something.Name end")
else
	print("⚠ BotSpawner script not found in ServerScriptService")
	print("Make sure the script exists and is named 'BotSpawner'")
end

