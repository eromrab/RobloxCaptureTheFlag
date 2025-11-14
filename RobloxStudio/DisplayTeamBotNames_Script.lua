-- DisplayTeamBotNames_Script.lua
-- Place this as a LocalScript in StarterGui
-- This script displays bot names from each team's BotList StringValue in the team selection GUI

local Teams = game:GetService("Teams")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for GUI to load
task.wait(2)

-- Function to print GUI structure for debugging
local function printGUIStructure(parent, indent, maxDepth)
	indent = indent or ""
	maxDepth = maxDepth or 5
	if maxDepth <= 0 then return end
	
	for _, child in ipairs(parent:GetChildren()) do
		local text = ""
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			text = " (Text: '" .. (child.Text or "nil") .. "')"
		end
		print(indent .. child.ClassName .. ": " .. child.Name .. text)
		printGUIStructure(child, indent .. "  ", maxDepth - 1)
	end
end

-- Function to recursively find all TextLabels/TextButtons in the GUI
local function findTeamElements(screenGui)
	local elements = {}
	local allElements = {} -- For debugging
	
	local function search(parent, depth)
		depth = depth or 0
		if depth > 15 then return end -- Prevent infinite recursion
		
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("Frame") or child:IsA("ImageButton") then
				-- Only check Text property on elements that have it
				local text = ""
				if child:IsA("TextLabel") or child:IsA("TextButton") then
					text = (child.Text or ""):lower()
				end
				local name = child.Name:lower()
				
				-- Store all elements for debugging
				table.insert(allElements, {child = child, text = text, name = name})
				
				-- Check if this might be a team element (contains team name or team color)
				if text:find("red") or text:find("blue") or 
				   name:find("red") or name:find("blue") or
				   text == "red team" or text == "blue team" or
				   text == "choosing" then
					table.insert(elements, child)
					local displayText = ""
					if child:IsA("TextLabel") or child:IsA("TextButton") then
						displayText = child.Text or "nil"
					end
					print("  ✓ Found team element: " .. child.ClassName .. ":" .. child.Name .. " (Text: '" .. displayText .. "')")
				end
			end
			search(child, depth + 1)
		end
	end
	
	search(screenGui)
	
	-- Debug: print all elements if we found nothing
	if #elements == 0 and #allElements > 0 then
		print("  Debug: Found " .. #allElements .. " GUI elements total, but none matched team pattern")
		print("  First 10 elements:")
		for i = 1, math.min(10, #allElements) do
			local elem = allElements[i]
			print("    - " .. elem.child.ClassName .. ":" .. elem.child.Name .. " (Text: '" .. (elem.child.Text or "nil") .. "')")
		end
	end
	
	return elements
end

-- Function to update team display with bot names
local function updateTeamDisplay(team)
	-- Try to find TeamSelectionGUI specifically first
	local screenGui = playerGui:FindFirstChild("TeamSelectionGUI")
	
	-- If not found, search all ScreenGuis for one that might be the team selection GUI
	if not screenGui then
		for _, gui in ipairs(playerGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				-- Check if this GUI contains team-related elements
				local hasTeamElements = false
				local function checkForTeamElements(parent)
					for _, child in ipairs(parent:GetChildren()) do
						if child:IsA("TextLabel") or child:IsA("TextButton") then
							local text = (child.Text or ""):lower()
							local name = child.Name:lower()
							if text:find("red team") or text:find("blue team") or 
							   text:find("choosing") or name:find("team") then
								hasTeamElements = true
								return true
							end
						elseif child:IsA("Frame") then
							-- Check frame name for team-related keywords
							local name = child.Name:lower()
							if name:find("team") or name:find("red") or name:find("blue") then
								hasTeamElements = true
								return true
							end
						end
						if child:IsA("GuiObject") then
							if checkForTeamElements(child) then return true end
						end
					end
					return false
				end
				if checkForTeamElements(gui) then
					screenGui = gui
					break
				end
			end
		end
	end
	
	if not screenGui then
		warn("Team Bot Display: Could not find TeamSelectionGUI")
		-- List all ScreenGuis for debugging
		print("  Available ScreenGuis:")
		for _, gui in ipairs(playerGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				print("    - " .. gui.Name)
			end
		end
		return
	end
	
	print("Team Bot Display: Found ScreenGui: " .. screenGui.Name)
	print("Team Bot Display: Searching for " .. team.Name .. " elements in GUI...")
	
	-- Debug: print GUI structure (only if it's not Freecam)
	if screenGui.Name ~= "Freecam" and screenGui:GetChildren()[1] then
		print("  GUI Structure (first level):")
		printGUIStructure(screenGui, "    ", 3)
	end
	
	-- Find team-related GUI elements
	local teamElements = findTeamElements(screenGui)
	
	print("Team Bot Display: Found " .. #teamElements .. " potential team elements")
	
	local botList = team:FindFirstChild("BotList")
	if not botList then
		warn("Team Bot Display: BotList not found for " .. team.Name)
		return
	end
	
	for _, element in ipairs(teamElements) do
		-- Skip BotListLabel elements (they're our own labels, not team buttons)
		if element.Name == "BotListLabel" or element.Name == "RedTeamBotList" or element.Name == "BlueTeamBotList" then
			-- Skip our own labels
		else
			local elementText = ""
			if element:IsA("TextLabel") or element:IsA("TextButton") then
				elementText = (element.Text or ""):lower()
			end
			local elementName = element.Name:lower()
			local isRedTeam = elementText:find("red") or elementName:find("red")
			local isBlueTeam = elementText:find("blue") or elementName:find("blue")
			
			if (team.Name == "Red Team" and isRedTeam) or (team.Name == "Blue Team" and isBlueTeam) then
				print("  Matched " .. team.Name .. " with element: " .. element.Name)
				
				-- Find the MainFrame (parent of buttons) to position labels below buttons
				local buttonFrame = element
				if not element:IsA("TextButton") and not element:IsA("Frame") then
					-- If it's a TextLabel, find its parent button/frame
					buttonFrame = element.Parent
				end
				
				-- Get MainFrame to position labels as siblings below buttons
				local mainFrame = buttonFrame.Parent
				if not mainFrame or not mainFrame:IsA("Frame") then
					warn("  Could not find MainFrame for " .. team.Name)
				else
					-- Use a unique name for each team's label
					local labelName = team.Name == "Red Team" and "RedTeamBotList" or "BlueTeamBotList"
					
					-- Try to find existing bot label
					local botLabel = mainFrame:FindFirstChild(labelName)
					if not botLabel then
						botLabel = Instance.new("TextLabel")
						botLabel.Name = labelName
						
						-- Get button position and size to position label directly below
						local buttonPos = buttonFrame.Position
						local buttonSize = buttonFrame.Size
						
						-- Debug: Print actual positions
						print("  DEBUG: Button " .. buttonFrame.Name .. " - Pos: " .. tostring(buttonPos) .. ", Size: " .. tostring(buttonSize))
						
						-- Position label directly below button using simpler calculation
						-- Use same X position and width as button, but position Y below it
						botLabel.Size = UDim2.new(buttonSize.X.Scale, buttonSize.X.Offset, 0, 40)  -- Same width as button, 40px height
						
						-- Calculate Y position: button Y + button height + small gap
						-- Convert to offset-only positioning to avoid scale issues
						local labelYScale = buttonPos.Y.Scale + buttonSize.Y.Scale
						local labelYOffset = buttonPos.Y.Offset + buttonSize.Y.Offset + 5
						
						-- Clamp scale to reasonable values (0-1)
						if labelYScale > 1 then
							labelYScale = 1
							labelYOffset = buttonPos.Y.Offset + buttonSize.Y.Offset + 5
						end
						
						botLabel.Position = UDim2.new(
							buttonPos.X.Scale,
							buttonPos.X.Offset,
							labelYScale,
							labelYOffset
						)
						
						print("  DEBUG: Label position: " .. tostring(botLabel.Position))
						
						botLabel.BackgroundTransparency = 0.2  -- More visible
						botLabel.BackgroundColor3 = Color3.new(0, 0, 0)
						botLabel.BorderSizePixel = 1
						botLabel.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
						botLabel.TextColor3 = Color3.new(1, 1, 1)
						botLabel.TextSize = 11
						botLabel.TextWrapped = true
						botLabel.Font = Enum.Font.SourceSans
						botLabel.TextXAlignment = Enum.TextXAlignment.Left
						botLabel.TextYAlignment = Enum.TextYAlignment.Center
						botLabel.ZIndex = 10  -- High ZIndex
						botLabel.Parent = mainFrame
						print("  Created " .. labelName .. " for " .. team.Name .. " below button in MainFrame")
					end
					
					-- Update bot list text (inside else block so botLabel is in scope)
					botLabel.Text = "Bots: " .. botList.Value
					print("  Updated " .. team.Name .. " bot list: " .. botList.Value)
					
					-- Listen for changes (only connect once)
					if not botLabel:GetAttribute("ListenerConnected") then
						botList:GetPropertyChangedSignal("Value"):Connect(function()
							botLabel.Text = "Bots: " .. botList.Value
						end)
						botLabel:SetAttribute("ListenerConnected", true)
					end
				end
			end
		end
	end
end

-- Setup for existing teams
for _, team in ipairs(Teams:GetTeams()) do
	if team.Name == "Red Team" or team.Name == "Blue Team" then
		task.wait(0.5) -- Wait for BotList to be created
		updateTeamDisplay(team)
	end
end

-- Listen for new teams
Teams.ChildAdded:Connect(function(team)
	if team:IsA("Team") and (team.Name == "Red Team" or team.Name == "Blue Team") then
		task.wait(1)
		updateTeamDisplay(team)
	end
end)

-- Periodically refresh (in case GUI loads after teams)
spawn(function()
	while true do
		task.wait(3)
		for _, team in ipairs(Teams:GetTeams()) do
			if team.Name == "Red Team" or team.Name == "Blue Team" then
				updateTeamDisplay(team)
			end
		end
	end
end)

print("Team Bot Name Display loaded!")

