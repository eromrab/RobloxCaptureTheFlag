-- Command Bar script to find where P key handler was added and check structure
-- Paste this into Roblox Studio Command Bar

print("=== Finding P Key Handler in TeamSelectionGUI ===")
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

-- Search for P key handler
print("🔍 Searching for P key handler code:")
local foundPKey = false
for i = 1, #lines do
	if lines[i]:find("Enum%.KeyCode%.P") or lines[i]:find("KeyCode.*P") then
		foundPKey = true
		print("  Found P key reference at line " .. i .. ":")
		print("    " .. lines[i])
		
		-- Show context around it
		print("  Context (lines " .. math.max(1, i-3) .. "-" .. math.min(#lines, i+5) .. "):")
		for j = math.max(1, i-3), math.min(#lines, i+5) do
			local marker = ""
			if j == i then
				marker = " ← P key handler"
			end
			print(string.format("    %3d: %s%s", j, lines[j], marker))
		end
		print("")
	end
end

if not foundPKey then
	print("  No P key handler found in script")
	print("")
end

-- Check structure around the error area more carefully
print("🔍 Detailed structure check (lines 120-199):")
local indentLevel = 0
for i = 120, math.min(199, #lines) do
	local line = lines[i]
	local stripped = line:match("^%s*(.-)%s*$")
	
	-- Count opens and closes
	local opens = 0
	local closes = 0
	
	-- Check for function/if/then opens
	if stripped:find("function%(") or stripped:find("function%s") or stripped:find(":Connect%(") or stripped:find("task%.spawn%(") then
		opens = opens + 1
	end
	if stripped:find("if%s") and stripped:find("then%s*$") then
		opens = opens + 1
	end
	
	-- Check for closes
	if stripped == "end" or stripped == "end)" then
		closes = closes + 1
	end
	
	-- Show line with structure info
	local marker = ""
	if i == 165 then
		marker = " ← ERROR: 'then' at line 165"
	elseif i == 171 then
		marker = " ← ERROR: Expected 'end', got 'if'"
	end
	
	print(string.format("  %3d: %s%s", i, line, marker))
end

print("")
print("💡 Check if there's a missing 'end' before line 171.")
print("   The task.spawn(function() at line 171 might need an 'end)' to close a previous block.")

