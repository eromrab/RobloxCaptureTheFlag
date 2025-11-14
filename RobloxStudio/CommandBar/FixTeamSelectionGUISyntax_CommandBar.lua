-- Command Bar script to find and fix syntax error in TeamSelectionGUI
-- Paste this into Roblox Studio Command Bar

print("=== Finding and Fixing TeamSelectionGUI Syntax Error ===")
print("")

local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")

if not StarterPlayerScripts then
	warn("⚠ StarterPlayerScripts not found!")
	return
end

local teamSelectionScript = StarterPlayerScripts:FindFirstChild("TeamSelectionGUI")

if not teamSelectionScript then
	warn("⚠ TeamSelectionGUI script not found!")
	print("Available scripts:")
	for _, child in ipairs(StarterPlayerScripts:GetChildren()) do
		if child:IsA("LocalScript") or child:IsA("Script") then
			print("  - " .. child.Name)
		end
	end
	return
end

print("✓ Found TeamSelectionGUI script: " .. teamSelectionScript:GetFullName())
print("")

-- Read the source
local source = teamSelectionScript.Source
local lines = {}
for line in source:gmatch("[^\r\n]+") do
	table.insert(lines, line)
end

print("Script has " .. #lines .. " lines")
print("")

-- Check around line 165-171 where the error is
print("🔍 Checking lines 160-175 (error area):")
for i = 160, math.min(175, #lines) do
	local marker = ""
	if i == 165 then
		marker = " ← ERROR: 'then' at line 165 (missing 'end'?)"
	elseif i == 171 then
		marker = " ← ERROR: Expected 'end', got 'if'"
	end
	print(string.format("  %3d: %s%s", i, lines[i] or "(empty)", marker))
end

print("")
print("💡 The error suggests a missing 'end' statement.")
print("   Look for an 'if' statement around line 165 that's missing its closing 'end'.")
print("")
print("   If you added P key handler code, make sure it has proper structure:")
print("")
print("   if input.KeyCode == Enum.KeyCode.P then")
print("       -- code here")
print("       return")
print("   end  ← This 'end' is required!")
print("")
print("   Check the structure around line 165-171 and ensure all 'if' statements have matching 'end' statements.")
