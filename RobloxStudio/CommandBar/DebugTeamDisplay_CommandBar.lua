-- Debug Team Display Command
-- Run this in Command Bar to inspect the team display GUI

print("=== Team Display Debug ===")

-- In Command Bar, we need to get a player differently
local Players = game:GetService("Players")

-- Try to get LocalPlayer first (works in play mode)
local player = Players.LocalPlayer

-- If LocalPlayer doesn't exist (Command Bar context), use first player
if not player then
	local players = Players:GetPlayers()
	if #players > 0 then
		player = players[1]
		print("Using first player: " .. player.Name)
	else
		warn("No players found! Make sure you're in play mode or have players in the game.")
		return
	end
end

print("Checking player: " .. player.Name)

-- Wait for PlayerGui (it should exist if player has joined)
local playerGui = player:FindFirstChild("PlayerGui")
if not playerGui then
	-- Try waiting a bit for it to be created
	print("Waiting for PlayerGui...")
	local success, result = pcall(function()
		return player:WaitForChild("PlayerGui", 2)
	end)
	if success and result then
		playerGui = result
	else
		warn("PlayerGui not found for " .. player.Name .. " - player may not have fully joined yet")
		print("Player's children:")
		for _, child in ipairs(player:GetChildren()) do
			print("  - " .. child.ClassName .. ": " .. child.Name)
		end
		return
	end
end

print("PlayerGui found for " .. player.Name .. ": " .. playerGui.Name)

-- Find TeamSelection GUI
local screenGui = playerGui:FindFirstChild("TeamSelection") or playerGui:FindFirstChild("TeamSelectionGUI")
if not screenGui then
	print("⚠ TeamSelection GUI not found!")
	print("Available ScreenGuis:")
	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			print("  - " .. gui.Name)
		end
	end
	return
end

print("✓ Found ScreenGui: " .. screenGui.Name)
print("  Enabled: " .. tostring(screenGui.Enabled))
print("  DisplayOrder: " .. tostring(screenGui.DisplayOrder))

-- Find MainFrame
local mainFrame = screenGui:FindFirstChild("MainFrame")
if not mainFrame then
	print("⚠ MainFrame not found!")
	print("Children of " .. screenGui.Name .. ":")
	for _, child in ipairs(screenGui:GetChildren()) do
		print("  - " .. child.ClassName .. ": " .. child.Name)
	end
	return
end

print("✓ Found MainFrame")
print("  Size: " .. tostring(mainFrame.Size))
print("  Position: " .. tostring(mainFrame.Position))
print("  ClipsDescendants: " .. tostring(mainFrame.ClipsDescendants))
print("  Visible: " .. tostring(mainFrame.Visible))

-- Find buttons
local redButton = mainFrame:FindFirstChild("RedButton")
local blueButton = mainFrame:FindFirstChild("BlueButton")

if redButton then
	print("\n✓ RedButton found:")
	print("  Size: " .. tostring(redButton.Size))
	print("  Position: " .. tostring(redButton.Position))
	print("  Text: " .. (redButton.Text or "nil"))
	print("  Visible: " .. tostring(redButton.Visible))
	print("  ZIndex: " .. tostring(redButton.ZIndex))
else
	print("\n⚠ RedButton not found!")
end

if blueButton then
	print("\n✓ BlueButton found:")
	print("  Size: " .. tostring(blueButton.Size))
	print("  Position: " .. tostring(blueButton.Position))
	print("  Text: " .. (blueButton.Text or "nil"))
	print("  Visible: " .. tostring(blueButton.Visible))
	print("  ZIndex: " .. tostring(blueButton.ZIndex))
else
	print("\n⚠ BlueButton not found!")
end

-- Find bot list labels
local redBotList = mainFrame:FindFirstChild("RedTeamBotList")
local blueBotList = mainFrame:FindFirstChild("BlueTeamBotList")

if redBotList then
	print("\n✓ RedTeamBotList found:")
	print("  Size: " .. tostring(redBotList.Size))
	print("  Position: " .. tostring(redBotList.Position))
	print("  Text: " .. (redBotList.Text or "nil"))
	print("  Visible: " .. tostring(redBotList.Visible))
	print("  ZIndex: " .. tostring(redBotList.ZIndex))
	print("  BackgroundTransparency: " .. tostring(redBotList.BackgroundTransparency))
	print("  TextColor3: " .. tostring(redBotList.TextColor3))
else
	print("\n⚠ RedTeamBotList not found!")
end

if blueBotList then
	print("\n✓ BlueTeamBotList found:")
	print("  Size: " .. tostring(blueBotList.Size))
	print("  Position: " .. tostring(blueBotList.Position))
	print("  Text: " .. (blueBotList.Text or "nil"))
	print("  Visible: " .. tostring(blueBotList.Visible))
	print("  ZIndex: " .. tostring(blueBotList.ZIndex))
	print("  BackgroundTransparency: " .. tostring(blueBotList.BackgroundTransparency))
	print("  TextColor3: " .. tostring(blueBotList.TextColor3))
else
	print("\n⚠ BlueTeamBotList not found!")
end

-- Check teams
print("\n=== Teams ===")
local Teams = game:GetService("Teams")
for _, team in ipairs(Teams:GetTeams()) do
	if team.Name == "Red Team" or team.Name == "Blue Team" then
		print("✓ " .. team.Name)
		local botList = team:FindFirstChild("BotList")
		if botList then
			print("  BotList Value: " .. botList.Value)
		else
			print("  ⚠ BotList not found!")
		end
	end
end

print("\n=== Debug Complete ===")

