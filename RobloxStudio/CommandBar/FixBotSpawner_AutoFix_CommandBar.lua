-- AUTO-FIX BOT SPAWNER ERROR - Command Bar Script
-- This script automatically fixes the BotSpawner error by adding nil checks
-- Paste this into Roblox Studio Command Bar and press Enter

local serverScriptService = game:GetService("ServerScriptService")
local botSpawner = serverScriptService:FindFirstChild("BotSpawner")

if not botSpawner then
	print("⚠ BotSpawner script not found in ServerScriptService")
	return
end

print("=== Auto-Fixing BotSpawner ===")

local source = botSpawner.Source
local lines = {}
for line in string.gmatch(source, "([^\n]*\n?)") do
	table.insert(lines, line)
end

-- Find spawnBotsForPlayer function
local functionStart = nil
for i, line in ipairs(lines) do
	if string.find(line, "function%s+spawnBotsForPlayer") then
		functionStart = i
		break
	end
end

if not functionStart then
	print("⚠ Could not find spawnBotsForPlayer function")
	return
end

print("Found spawnBotsForPlayer function at line " .. functionStart)

-- Check if fix is already applied
local alreadyFixed = false
for i = functionStart + 1, math.min(functionStart + 5, #lines) do
	if string.find(lines[i], "if%s+not%s+player") then
		alreadyFixed = true
		break
	end
end

if alreadyFixed then
	print("✓ Fix already applied! Nil check exists.")
	return
end

-- Fix 1: Add nil check after function declaration
print("Adding nil check to spawnBotsForPlayer function...")
local nilCheck = "\tif not player then\n\t\treturn\n\tend\n"
table.insert(lines, functionStart + 1, nilCheck)

-- Fix 2: Fix line 130 (now shifted due to insertion)
-- Find the line with spawnBotsForPlayer call
local callLineIndex = nil
for i, line in ipairs(lines) do
	if string.find(line, "spawnBotsForPlayer%(%s*Players") then
		callLineIndex = i
		break
	end
end

if callLineIndex then
	print("Fixing spawnBotsForPlayer call at line " .. callLineIndex)
	local oldLine = lines[callLineIndex]
	
	-- Replace the problematic line
	local newLines = {
		"\tlocal firstPlayer = Players:GetPlayers()[1]\n",
		"\tif firstPlayer then\n",
		"\t\tspawnBotsForPlayer(firstPlayer)\n",
		"\tend\n"
	}
	
	-- Remove old line and insert new ones
	table.remove(lines, callLineIndex)
	for i = #newLines, 1, -1 do
		table.insert(lines, callLineIndex, newLines[i])
	end
	
	print("✓ Fixed spawnBotsForPlayer call")
else
	print("⚠ Could not find spawnBotsForPlayer call line")
end

-- Reconstruct the source
local newSource = table.concat(lines, "")

-- Update the script
botSpawner.Source = newSource

print("")
print("✅ BotSpawner has been automatically fixed!")
print("The script now includes:")
print("  1. Nil check in spawnBotsForPlayer function")
print("  2. Safe player check before calling spawnBotsForPlayer")
print("")
print("The error should be resolved. Test the game to confirm!")

