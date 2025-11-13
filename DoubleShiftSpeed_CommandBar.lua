-- COPY AND PASTE THIS INTO COMMAND BAR
-- Makes shift button run twice as fast

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
	warn("Must run in Command Bar or as LocalScript")
	return
end

local function setupDoubleShift(character)
	local humanoid = character:WaitForChild("Humanoid")
	local originalWalkSpeed = humanoid.WalkSpeed
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			humanoid.WalkSpeed = originalWalkSpeed * 2
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			humanoid.WalkSpeed = originalWalkSpeed
		end
	end)
	
	print("✓ Shift speed doubled!")
end

if player.Character then
	setupDoubleShift(player.Character)
end
player.CharacterAdded:Connect(setupDoubleShift)

