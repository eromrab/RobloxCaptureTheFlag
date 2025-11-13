-- FIX GUN DAMAGE HANDLER ERROR - Command Bar Script
-- This checks and fixes the "Incomplete statement" error on line 1

local ServerScriptService = game:GetService("ServerScriptService")
local gunDamageHandler = ServerScriptService:FindFirstChild("GunDamageHandler")

if not gunDamageHandler then
	warn("⚠ GunDamageHandler script not found in ServerScriptService")
	warn("Make sure the script exists and is named 'GunDamageHandler'")
	return
end

print("=== Diagnosing GunDamageHandler ===")
print("Script found: " .. gunDamageHandler.Name)
print("Script type: " .. gunDamageHandler.ClassName)

-- Get the source code
local source = gunDamageHandler.Source
print("Source length: " .. #source .. " characters")

-- Check first line
local firstLine = string.match(source, "^([^\n\r]*)")
print("\nLine 1 content:")
if firstLine then
	print("  '" .. firstLine .. "'")
	print("  Length: " .. #firstLine)
	
	-- Check if it's empty or whitespace
	if string.match(firstLine, "^%s*$") then
		warn("⚠ PROBLEM: Line 1 is empty or whitespace only!")
		print("  → This causes the 'Incomplete statement' error")
		print("\n🔧 FIX: Adding a comment to line 1...")
		
		-- Add a comment at the start if line 1 is empty
		local newSource = "-- Gun Damage Handler\n" .. source
		gunDamageHandler.Source = newSource
		print("  ✓ Added comment to line 1")
		print("  → Error should be fixed now!")
	elseif string.match(firstLine, "^%-%-") then
		print("  ✓ Line 1 is a comment (this is fine)")
		print("  → The error might be a false positive")
	elseif string.match(firstLine, "^%s*local") or string.match(firstLine, "^%s*function") or string.match(firstLine, "^%s*--") then
		print("  ✓ Line 1 appears to be valid Lua code")
		print("  → The error might be a false positive or a minor syntax issue")
	else
		warn("  ⚠ Line 1 might have an issue")
		print("  → Consider ensuring it starts with '--' for a comment or valid Lua code")
	end
else
	warn("⚠ Could not read line 1")
end

-- Show first few lines for context
print("\nFirst 5 lines of script:")
local lines = {}
for line in string.gmatch(source, "[^\n\r]+") do
	table.insert(lines, line)
	if #lines >= 5 then break end
end

for i, line in ipairs(lines) do
	print("  " .. i .. ": " .. line)
end

print("\n✅ Diagnosis complete!")
print("💡 If the error persists, try:")
print("   1. Open ServerScriptService > GunDamageHandler in Roblox Studio")
print("   2. Make sure line 1 starts with '--' (comment) or valid Lua code")
print("   3. Delete any invisible characters on line 1")
print("   4. If the script works fine, you can ignore this error")

