-- Command Bar script to hide Chat and cover Menu button and Roblox icon
-- Paste this into Roblox Studio Command Bar

print("=== Hiding Chat and Covering Top Bar Buttons ===")
print("")

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- Hide Chat
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

-- Function to cover top bar buttons for a player
local function coverTopBarButtons(player)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end
	
	-- Remove existing cover if it exists
	local existingCover = playerGui:FindFirstChild("TopBarCover")
	if existingCover then
		existingCover:Destroy()
	end
	
	-- Create a ScreenGui to cover the top bar buttons
	local coverGui = Instance.new("ScreenGui")
	coverGui.Name = "TopBarCover"
	coverGui.ResetOnSpawn = false
	coverGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	coverGui.DisplayOrder = 100 -- High display order to be on top
	
	-- Create a frame to cover the top-left area (where the buttons are)
	local coverFrame = Instance.new("Frame")
	coverFrame.Name = "CoverFrame"
	coverFrame.Size = UDim2.new(0, 150, 0, 50) -- Covers approximately 150x50 pixels in top-left
	coverFrame.Position = UDim2.new(0, 0, 0, 0) -- Top-left corner
	coverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background (match your game's background)
	coverFrame.BackgroundTransparency = 0 -- Fully opaque
	coverFrame.BorderSizePixel = 0
	coverFrame.Parent = coverGui
	
	coverGui.Parent = playerGui
	print("  ✓ Created cover for top bar buttons for " .. player.Name)
end

-- Cover for all current players
for _, player in ipairs(Players:GetPlayers()) do
	coverTopBarButtons(player)
end

-- Cover for future players
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()
	task.wait(1) -- Wait for GUI to load
	coverTopBarButtons(player)
end)

print("✓ Hidden Chat")
print("✓ Created cover frame for Roblox icon and menu button")
print("")
print("💡 The cover frame is black. You can adjust its color/transparency in the script.")
print("   Or position your minimap to overlap and hide these buttons naturally.")

