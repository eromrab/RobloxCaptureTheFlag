-- Command Bar script to completely fix TeamSelectionGUI syntax errors
-- Paste this into Roblox Studio Command Bar

print("=== Complete Fix for TeamSelectionGUI ===")
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

-- Fix all issues
local fixed = false

-- Fix 1: Update key filter to include P
for i = 1, #lines do
	if lines[i]:find("Only process I and O keys") then
		lines[i] = "\t-- Process I, O, and P keys"
		fixed = true
		print("✓ Fixed: Updated key filter comment")
	elseif lines[i]:find("input%.KeyCode ~= Enum%.KeyCode%.I and input%.KeyCode ~= Enum%.KeyCode%.O") and not lines[i]:find("Enum%.KeyCode%.P") then
		lines[i] = lines[i]:gsub("input%.KeyCode ~= Enum%.KeyCode%.O", "input.KeyCode ~= Enum.KeyCode.O and input.KeyCode ~= Enum.KeyCode.P")
		fixed = true
		print("✓ Fixed: Added P key to filter")
	end
end

-- Fix 2: Remove broken 'en' and 'd' lines
for i = #lines, 1, -1 do
	local stripped = lines[i]:match("^%s*(.-)%s*$")
	if stripped == "en" or stripped == "d" then
		table.remove(lines, i)
		fixed = true
		print("✓ Fixed: Removed broken line " .. i .. " ('" .. stripped .. "')")
	end
end

-- Fix 3: Remove duplicate P key handler (the one after O key handler)
local foundOKeyEnd = false
for i = 1, #lines do
	if lines[i]:find("Enum%.KeyCode%.O") and lines[i]:find("then") then
		-- Found O key handler, look for its end
		for j = i + 1, math.min(i + 10, #lines) do
			if lines[j]:find("^%s*return%s*$") and j + 1 <= #lines then
				local nextLine = lines[j + 1]:match("^%s*(.-)%s*$")
				if nextLine == "en" or nextLine:find("P key") then
					-- Found broken code or duplicate P handler
					-- Remove everything from 'en' to the duplicate P handler's 'end'
					local startRemove = j + 1
					local endRemove = j + 1
					for k = j + 1, math.min(j + 15, #lines) do
						if lines[k]:find("^%s*end%s*$") or lines[k]:find("^%s*end%)%s*$") then
							-- Check if this is the duplicate P handler's end
							local foundP = false
							for l = startRemove, k do
								if lines[l]:find("Enum%.KeyCode%.P") then
									foundP = true
									break
								end
							end
							if foundP then
								endRemove = k
								break
							end
						end
					end
					-- Remove the broken lines
					for k = endRemove, startRemove, -1 do
						table.remove(lines, k)
					end
					fixed = true
					print("✓ Fixed: Removed duplicate P key handler and broken code")
					break
				end
			end
		end
		break
	end
end

-- Fix 4: Ensure P key handler is in the right place (after TextBox check, before I/O handlers)
local hasPKeyHandler = false
local pKeyHandlerLine = nil
for i = 1, #lines do
	if lines[i]:find("Enum%.KeyCode%.P") and lines[i]:find("then") then
		hasPKeyHandler = true
		pKeyHandlerLine = i
		break
	end
end

-- Fix 5: Remove extra 'end' before task.spawn
for i = 1, #lines do
	if lines[i]:find("task%.spawn%(") then
		local prevLine = i > 1 and lines[i - 1]:match("^%s*(.-)%s*$") or ""
		if prevLine == "end" and not lines[i - 2]:find("function") and not lines[i - 2]:find("Connect") then
			table.remove(lines, i - 1)
			fixed = true
			print("✓ Fixed: Removed extra 'end' before task.spawn")
		end
		break
	end
end

-- Fix 6: Ensure InputBegan handler closes properly
local inputBeganLine = nil
for i = 1, #lines do
	if lines[i]:find("InputBegan") then
		inputBeganLine = i
		break
	end
end

if inputBeganLine then
	-- Find the closing end) for InputBegan
	local depth = 0
	local foundClose = false
	for i = inputBeganLine, #lines do
		local stripped = lines[i]:match("^%s*(.-)%s*$")
		if stripped:find("function%(") or stripped:find(":Connect%(") then
			depth = depth + 1
		end
		if stripped:find("if%s") and stripped:find("then%s*$") then
			depth = depth + 1
		end
		if stripped == "end" or stripped == "end)" then
			depth = depth - 1
			if depth == 0 and stripped == "end)" then
				foundClose = true
				break
			end
		end
	end
	
	if not foundClose then
		-- Find where it should close (after O key handler)
		for i = #lines, 1, -1 do
			if lines[i]:find("Enum%.KeyCode%.O") and lines[i]:find("then") then
				-- Found O key handler, find its end
				for j = i + 1, math.min(i + 10, #lines) do
					if lines[j]:find("^%s*return%s*$") and j + 1 <= #lines then
						local nextStripped = lines[j + 1]:match("^%s*(.-)%s*$")
						if nextStripped ~= "end)" and nextStripped ~= "end" then
							-- Insert end) after return
							table.insert(lines, j + 1, "\tend)")
							fixed = true
							print("✓ Fixed: Added missing 'end)' to close InputBegan handler")
						end
						break
					end
				end
				break
			end
		end
	end
end

if fixed then
	-- Reconstruct source
	local newSource = table.concat(lines, "\n")
	teamSelectionScript.Source = newSource
	print("")
	print("✓ Script fixed! All syntax errors should be resolved.")
	print("  The script should now work correctly.")
else
	print("✓ No issues found - script structure looks correct.")
	print("  If errors persist, the issue may be elsewhere.")
end

print("")
print("✓ Fix complete!")

