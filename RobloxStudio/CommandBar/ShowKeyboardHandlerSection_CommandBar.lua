-- Command Bar script to show keyboard handler section where P key was added
-- Paste this into Roblox Studio Command Bar

print("=== Showing Keyboard Handler Section ===")
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

-- Read the source
local source = teamSelectionScript.Source
local lines = {}
for line in source:gmatch("[^\r\n]+") do
	table.insert(lines, line)
end

-- Find keyboard handler section (usually has InputBegan or UserInputService)
print("🔍 Finding keyboard input handler section:")
local handlerStart = nil
local handlerEnd = nil

for i = 1, #lines do
	if lines[i]:find("InputBegan") or lines[i]:find("UserInputService") or (lines[i]:find("KeyCode") and lines[i]:find("Enum%.KeyCode%.I")) then
		if not handlerStart then
			handlerStart = math.max(1, i - 5)
		end
		handlerEnd = math.min(#lines, i + 50)
	end
end

if handlerStart and handlerEnd then
	print("  Found keyboard handler section (lines " .. handlerStart .. "-" .. handlerEnd .. ")")
	print("")
	print("📋 Full keyboard handler code:")
	for i = handlerStart, handlerEnd do
		local marker = ""
		if lines[i]:find("Enum%.KeyCode%.P") or lines[i]:find("KeyCode.*P") then
			marker = " ← P key handler"
		elseif lines[i]:find("Enum%.KeyCode%.I") then
			marker = " ← I key (Red Team)"
		elseif lines[i]:find("Enum%.KeyCode%.O") then
			marker = " ← O key (Blue Team)"
		end
		print(string.format("  %3d: %s%s", i, lines[i], marker))
	end
else
	print("  ⚠ Could not find keyboard handler section")
	print("  Showing lines 100-199 instead:")
	for i = 100, math.min(199, #lines) do
		print(string.format("  %3d: %s", i, lines[i]))
	end
end

print("")
print("💡 Check that the P key handler has this structure:")
print("")
print("   if input.KeyCode == Enum.KeyCode.P then")
print("       local screenGui = playerGui:FindFirstChild(\"TeamSelectionGUI\")")
print("       if screenGui then")
print("           screenGui.Enabled = false")
print("           print(\"Team Selection GUI hidden (P key pressed)\")")
print("       end")
print("       return")
print("   end  ← This 'end' is required!")
print("")
print("   Make sure it's placed BEFORE the closing 'end' of the InputBegan handler.")

