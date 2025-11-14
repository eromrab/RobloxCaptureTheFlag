-- Command Bar script to find TeamSelectionGUI and add P key handler
-- Paste this into Roblox Studio Command Bar

print("=== Finding TeamSelectionGUI Script ===")
print("")

local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")
local StarterCharacterScripts = StarterPlayer:FindFirstChild("StarterCharacterScripts")

local function searchForScript(parent, name)
	if not parent then return nil end
	for _, obj in ipairs(parent:GetDescendants()) do
		if (obj:IsA("LocalScript") or obj:IsA("Script")) and obj.Name:find(name) then
			return obj
		end
	end
	return nil
end

local teamSelectionScript = nil

if StarterPlayerScripts then
	teamSelectionScript = searchForScript(StarterPlayerScripts, "TeamSelection")
end

if not teamSelectionScript and StarterCharacterScripts then
	teamSelectionScript = searchForScript(StarterCharacterScripts, "TeamSelection")
end

if not teamSelectionScript then
	warn("⚠ TeamSelectionGUI script not found!")
	print("")
	print("Please manually find your TeamSelectionGUI LocalScript.")
	print("It's likely in StarterPlayer > StarterPlayerScripts")
	print("")
	print("Once you find it, add this code to the keyboard input handler:")
	print("")
	print("-- Add P key handler to remove menu")
	print("if input.KeyCode == Enum.KeyCode.P then")
	print("    local screenGui = playerGui:FindFirstChild(\"TeamSelectionGUI\")")
	print("    if screenGui then")
	print("        screenGui.Enabled = false")
	print("        print(\"Team Selection GUI hidden (P key pressed)\")")
	print("    end")
	print("end")
	return
end

print("✓ Found TeamSelectionGUI script: " .. teamSelectionScript:GetFullName())
print("")
print("💡 To add P key handler, find the keyboard input handler section")
print("   (where I and O keys are handled) and add:")
print("")
print("   -- P key: Hide menu")
print("   if input.KeyCode == Enum.KeyCode.P then")
print("       local screenGui = playerGui:FindFirstChild(\"TeamSelectionGUI\")")
print("       if screenGui then")
print("           screenGui.Enabled = false")
print("           print(\"Team Selection GUI hidden (P key pressed)\")")
print("       end")
print("       return")
print("   end")
print("")
print("✓ Instructions complete!")

