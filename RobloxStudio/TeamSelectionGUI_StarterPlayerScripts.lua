-- Team Selection GUI (Client-side)
-- Place this in StarterPlayer > StarterPlayerScripts
-- This creates a GUI that allows players to select their team

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("Team Selection GUI: Script started for " .. player.Name)

-- Wait for RemoteEvent (with timeout handling)
local SelectTeamEvent = ReplicatedStorage:WaitForChild("SelectTeam", 10)
if not SelectTeamEvent then
	warn("Team Selection GUI: SelectTeam RemoteEvent not found! Make sure TeamSelectionHandler.lua is running.")
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeamSelection"
screenGui.ResetOnSpawn = false -- Keep GUI after respawn
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Center of screen
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Select Your Team"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 32
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Red Team Button
local redButton = Instance.new("TextButton")
redButton.Name = "RedButton"
redButton.Size = UDim2.new(0, 150, 0, 80)
redButton.Position = UDim2.new(0.5, -170, 0.5, -40)
redButton.BackgroundColor3 = Color3.fromRGB(196, 40, 28)
redButton.Text = "Red Team\n[I]"
redButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redButton.TextSize = 24
redButton.Font = Enum.Font.GothamBold
redButton.Parent = mainFrame

local redCorner = Instance.new("UICorner")
redCorner.CornerRadius = UDim.new(0, 8)
redCorner.Parent = redButton

-- Blue Team Button
local blueButton = Instance.new("TextButton")
blueButton.Name = "BlueButton"
blueButton.Size = UDim2.new(0, 150, 0, 80)
blueButton.Position = UDim2.new(0.5, 20, 0.5, -40)
blueButton.BackgroundColor3 = Color3.fromRGB(13, 105, 172)
blueButton.Text = "Blue Team\n[O]"
blueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
blueButton.TextSize = 24
blueButton.Font = Enum.Font.GothamBold
blueButton.Parent = mainFrame

local blueCorner = Instance.new("UICorner")
blueCorner.CornerRadius = UDim.new(0, 8)
blueCorner.Parent = blueButton

-- Track if team has been selected (to prevent premature hiding)
local teamSelected = false

-- Helper function to check if player needs to choose a team
local function shouldShowGUI()
	if not player.Team then
		return true
	end
	-- If player is on "Choosing" team, show GUI
	if player.Team.Name == "Choosing" then
		return true
	end
	-- Only show if on Red Team or Blue Team and not selected yet
	return false
end

-- Function to select a team (used by both buttons and keyboard)
local function selectTeam(teamName)
	if not SelectTeamEvent then
		warn("Team Selection GUI: Cannot select team - RemoteEvent not found!")
		return
	end

	-- Only allow selection if GUI is visible and player needs to choose
	if not screenGui.Enabled or not shouldShowGUI() then
		return
	end

	teamSelected = true -- Mark as selected
	SelectTeamEvent:FireServer(teamName)
	screenGui.Enabled = false -- Hide GUI after selection
	print("Team Selection GUI: " .. teamName .. " selected via keyboard/button")
end

-- Button click handlers
redButton.MouseButton1Click:Connect(function()
	selectTeam("Red Team")
end)

blueButton.MouseButton1Click:Connect(function()
	selectTeam("Blue Team")
end)

-- Keyboard shortcuts: I for Red Team, O for Blue Team
print("Team Selection GUI: Setting up keyboard input handler...")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- Process I, O, and P keys
	if input.KeyCode ~= Enum.KeyCode.I and input.KeyCode ~= Enum.KeyCode.O and input.KeyCode ~= Enum.KeyCode.P then
		return
	end

	-- Check if player is typing in chat (TextBox focused) - this takes priority
	if UserInputService:GetFocusedTextBox() then
		return
	end

	-- P key: Hide menu (works even when GUI is disabled)
	if input.KeyCode == Enum.KeyCode.P then
		if screenGui and screenGui.Enabled then
			screenGui.Enabled = false
			print("Team Selection GUI hidden (P key pressed)")
		end
		return
	end

	-- Debug: Print key detection
	print("Team Selection GUI: Key detected - KeyCode:", input.KeyCode, "GameProcessed:", gameProcessed, "TextBoxFocused:", UserInputService:GetFocusedTextBox() ~= nil, "GUIEnabled:", screenGui.Enabled)


	-- Check if GUI should be shown
	local shouldShow = shouldShowGUI()
	if not screenGui.Enabled then
		print("Team Selection GUI: GUI is disabled, ignoring key press")
		return 
	end

	if not shouldShow then
		print("Team Selection GUI: shouldShowGUI() returned false, ignoring key press")
		return
	end

	-- Process I and O keys even if gameProcessed is true (we want to override default behavior)
	-- I key for Red Team
	if input.KeyCode == Enum.KeyCode.I then
		print("Team Selection GUI: I key pressed - selecting Red Team")
		selectTeam("Red Team")
		return
	end

	-- O key for Blue Team
	if input.KeyCode == Enum.KeyCode.O then
		print("Team Selection GUI: O key pressed - selecting Blue Team")
		selectTeam("Blue Team")
		return
	end
end)

-- Initialize GUI - show if on "Choosing" team or no team
print("Team Selection GUI: Initializing... Player has team:", player.Team ~= nil, player.Team and player.Team.Name or "none")
screenGui.Enabled = shouldShowGUI()
print("Team Selection GUI: ScreenGui enabled:", screenGui.Enabled)

-- Show GUI when player spawns (if on "Choosing" team or no team)
player.CharacterAdded:Connect(function()
	print("Team Selection GUI: Character spawned")
	-- Keep GUI visible if on "Choosing" team or no team
	if not teamSelected and shouldShowGUI() then
		task.wait(0.1) -- Small delay for character to fully load
		screenGui.Enabled = true
		print("Team Selection GUI: Enabled after character spawn")
	end
end)

-- Also show GUI immediately if on "Choosing" team or no team (in case character already exists)
task.spawn(function()
	task.wait(1) -- Wait a moment for everything to load
	if not teamSelected and shouldShowGUI() then
		screenGui.Enabled = true
		print("Team Selection GUI: Force enabled after delay")
	end
end)

-- Hide GUI when team is actually assigned (from button click or other source)
player:GetPropertyChangedSignal("Team"):Connect(function()
	-- Check if we should show the GUI
	if shouldShowGUI() then
		-- On "Choosing" team or no team - show GUI
		teamSelected = false
		screenGui.Enabled = true
		print("Team Selection GUI: Team changed to choosing/no team, showing GUI")
	else
		-- On Red Team or Blue Team
		if teamSelected then
			-- Team was selected via button click - hide GUI
			screenGui.Enabled = false
		else
			-- Team was auto-assigned (shouldn't happen, but show GUI just in case)
			teamSelected = false
			screenGui.Enabled = true
		end
	end
end)

print("Team Selection GUI loaded!")
print("Team Selection GUI: Keyboard shortcuts ready - Press [I] for Red Team, [O] for Blue Team, [P] to hide menu")

