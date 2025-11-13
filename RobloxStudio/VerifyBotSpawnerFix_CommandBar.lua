-- VERIFY BOT SPAWNER FIX - Command Bar Script
-- Run this AFTER you've applied the fix to verify it's correct

local serverScriptService = game:GetService("ServerScriptService")
local botSpawner = serverScriptService:FindFirstChild("BotSpawner")

if botSpawner then
	print("=== Verifying BotSpawner Fix ===")
	
	local source = botSpawner.Source
	local lines = {}
	for line in string.gmatch(source, "[^\n]+") do
		table.insert(lines, line)
	end
	
	-- Check if spawnBotsForPlayer has nil check
	local functionStart = nil
	for i, line in ipairs(lines) do
		if string.find(line, "function%s+spawnBotsForPlayer") then
			functionStart = i
			break
		end
	end
	
	if functionStart then
		print("\n✓ Found spawnBotsForPlayer function at line " .. functionStart)
		
		-- Check next few lines for nil check
		local hasNilCheck = false
		for i = functionStart + 1, math.min(functionStart + 5, #lines) do
			if string.find(lines[i], "if%s+not%s+player") or string.find(lines[i], "if%s+player%s*==%s*nil") then
				hasNilCheck = true
				print("✓ Found nil check at line " .. i)
				break
			end
		end
		
		if not hasNilCheck then
			print("⚠ WARNING: No nil check found in spawnBotsForPlayer function!")
			print("   Add 'if not player then return end' after line " .. functionStart)
		end
		
		-- Check line 130 (or around there) for proper player check
		local hasPlayerCheck = false
		for i = 128, math.min(132, #lines) do
			if string.find(lines[i], "spawnBotsForPlayer") then
				-- Check if there's a nil check before this
				for j = math.max(1, i - 3), i - 1 do
					if string.find(lines[j], "if%s+.*[Pp]layer") or string.find(lines[j], "firstPlayer") then
						hasPlayerCheck = true
						print("✓ Found player check before spawnBotsForPlayer call")
						break
					end
				end
				if not hasPlayerCheck then
					print("⚠ WARNING: Line " .. i .. " calls spawnBotsForPlayer without checking if player exists")
					print("   Line: " .. string.match(lines[i], "^%s*(.-)%s*$"))
				end
				break
			end
		end
		
		-- Check line 127 for safe player.Name access
		if #lines >= 127 then
			local line127 = lines[127]
			if string.find(line127, "player%.Name") then
				print("\nLine 127: " .. string.match(line127, "^%s*(.-)%s*$"))
				if hasNilCheck then
					print("✓ This should be safe now (nil check exists)")
				else
					print("⚠ This will error if player is nil!")
				end
			end
		end
		
		if hasNilCheck and hasPlayerCheck then
			print("\n✅ Fix appears to be applied correctly!")
		else
			print("\n⚠ Please review the fix instructions and apply the changes.")
		end
	else
		print("⚠ Could not find spawnBotsForPlayer function")
	end
else
	print("⚠ BotSpawner script not found")
end

