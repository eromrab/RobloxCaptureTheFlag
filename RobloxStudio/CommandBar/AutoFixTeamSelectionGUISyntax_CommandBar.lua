-- Command Bar script to automatically fix syntax error in TeamSelectionGUI
-- Paste this into Roblox Studio Command Bar

print("=== Auto-Fixing TeamSelectionGUI Syntax Error ===")
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

-- Check lines 160-180 for structure issues
print("🔍 Analyzing structure around error area...")

-- Count block depth
local depth = 0
local issues = {}

for i = 150, math.min(180, #lines) do
	local line = lines[i]
	local stripped = line:match("^%s*(.-)%s*$")
	
	-- Count block opens
	if stripped:find("function%(") or stripped:find("function%s") or stripped:find(":Connect%(") or stripped:find("task%.spawn%(") then
		depth = depth + 1
	end
	if stripped:find("if%s") and stripped:find("then%s*$") then
		depth = depth + 1
	end
	
	-- Count block closes
	if stripped == "end" or stripped == "end)" then
		depth = depth - 1
	end
	
	-- Check for issues
	if i == 165 and depth < 0 then
		table.insert(issues, {line = i, issue = "Negative depth - missing 'end' before this line"})
	end
	if i == 171 and depth > 0 then
		table.insert(issues, {line = i, issue = "Unclosed block - missing 'end' before this line"})
	end
end

if #issues > 0 then
	print("⚠ Found structure issues:")
	for _, issue in ipairs(issues) do
		print("  Line " .. issue.line .. ": " .. issue.issue)
	end
	print("")
	
	-- Try to fix: add missing 'end' before line 171
	print("🔧 Attempting to fix by adding missing 'end' before line 171...")
	
	-- Check if line 170 is a comment or empty
	local line170 = lines[170] or ""
	local stripped170 = line170:match("^%s*(.-)%s*$")
	
	if stripped170:find("^%-%-") or stripped170 == "" then
		-- Insert 'end' after line 170
		table.insert(lines, 171, "\tend")
		print("  ✓ Added 'end' at line 171")
	else
		-- Insert 'end' before line 171
		table.insert(lines, 171, "\tend")
		print("  ✓ Added 'end' before line 171")
	end
	
	-- Reconstruct source
	local newSource = table.concat(lines, "\n")
	
	-- Update script
	teamSelectionScript.Source = newSource
	print("")
	print("✓ Script updated! Please test to see if the error is fixed.")
	print("  If the error persists, you may need to manually check the structure.")
else
	print("✓ No obvious structure issues found.")
	print("  The error might be elsewhere. Check the full script for:")
	print("  - Missing 'end' statements")
	print("  - Unclosed 'if' blocks")
	print("  - Incorrectly placed P key handler code")
end

