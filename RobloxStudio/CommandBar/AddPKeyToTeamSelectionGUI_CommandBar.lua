-- Command Bar script to add P key handler to TeamSelectionGUI
-- Paste this into Roblox Studio Command Bar

print("=== Adding P Key Handler to TeamSelectionGUI ===")
print("")

local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")

if not StarterPlayerScripts then
	warn("⚠ StarterPlayerScripts not found!")
	return
end

local teamSelectionScript = StarterPlayerScripts:FindFirstChild("TeamSelectionGUI")

if not teamSelectionScript then
	warn("⚠ TeamSelectionGUI script not found in StarterPlayerScripts!")
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

-- Check if P key handler already exists
if source:find("Enum%.KeyCode%.P") or source:find("KeyCode == Enum.KeyCode.P") then
	print("⚠ P key handler already exists in the script!")
	return
end

-- Find where I and O keys are handled
local iKeyPattern = "Enum%.KeyCode%.I"
local oKeyPattern = "Enum%.KeyCode%.O"

if not source:find(iKeyPattern) and not source:find(oKeyPattern) then
	warn("⚠ Could not find I/O key handlers in the script!")
	print("Please manually add the P key handler to your TeamSelectionGUI script.")
	print("")
	print("Add this code where the keyboard input is handled:")
	print("")
	print("-- P key: Hide menu")
	print("if input.KeyCode == Enum.KeyCode.P then")
	print("    local screenGui = playerGui:FindFirstChild(\"TeamSelectionGUI\")")
	print("    if screenGui then")
	print("        screenGui.Enabled = false")
	print("        print(\"Team Selection GUI hidden (P key pressed)\")")
	print("    end")
	print("    return")
	print("end")
	return
end

-- Try to find a good insertion point (after I/O key handlers)
local insertPattern = "elseif input%.KeyCode == Enum%.KeyCode%.O"
local insertPattern2 = "if input%.KeyCode == Enum%.KeyCode%.O"

local newCode = [[
	-- P key: Hide menu
	if input.KeyCode == Enum.KeyCode.P then
		local screenGui = playerGui:FindFirstChild("TeamSelectionGUI")
		if screenGui then
			screenGui.Enabled = false
			print("Team Selection GUI hidden (P key pressed)")
		end
		return
	end
]]

-- Try to insert after O key handler
local insertPos = source:find(insertPattern)
if not insertPos then
	insertPos = source:find(insertPattern2)
end

if insertPos then
	-- Find the end of the O key handler block
	local afterO = source:sub(insertPos)
	local endPattern = "end"
	local endPos = afterO:find("\n%s*" .. endPattern)
	
	if endPos then
		-- Insert after the O key handler's end
		local beforeInsert = source:sub(1, insertPos + endPos + #endPattern - 1)
		local afterInsert = source:sub(insertPos + endPos + #endPattern)
		local newSource = beforeInsert .. "\n" .. newCode .. afterInsert
		
		-- Update the script
		teamSelectionScript.Source = newSource
		print("✓ Successfully added P key handler to TeamSelectionGUI!")
		print("  The script will now hide the menu when P is pressed.")
	else
		warn("⚠ Could not find insertion point. Please add manually.")
		print("")
		print("Add this code after the O key handler:")
		print(newCode)
	end
else
	warn("⚠ Could not find O key handler. Please add manually.")
	print("")
	print("Add this code to your keyboard input handler:")
	print(newCode)
end

print("")
print("✓ Complete!")

