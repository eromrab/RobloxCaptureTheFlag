-- LocalScript to add P key handler for hiding TeamSelectionGUI
-- Place this in StarterPlayer > StarterPlayerScripts
-- Named: pKeyForMenu

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
	player = Players.PlayerAdded:Wait()
end

local playerGui = player:WaitForChild("PlayerGui")

-- Wait for TeamSelection GUI to exist (with longer timeout and retry)
-- Note: GUI is named "TeamSelection" not "TeamSelectionGUI"
local screenGui = nil
for i = 1, 20 do
	screenGui = playerGui:FindFirstChild("TeamSelection") or playerGui:FindFirstChild("TeamSelectionGUI")
	if screenGui then
		break
	end
	task.wait(0.5)
end

if not screenGui then
	warn("pKeyForMenu: TeamSelection GUI not found after waiting!")
	warn("  This usually means TeamSelectionGUI script has an error.")
	return
end

print("pKeyForMenu: P key handler ready")

-- Listen for P key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.P then
		if screenGui and screenGui.Enabled then
			screenGui.Enabled = false
			print("Team Selection GUI hidden (P key pressed)")
		end
	end
end)

