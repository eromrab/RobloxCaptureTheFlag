-- Makes shift button (sprint) run twice as fast
-- Run this as a LocalScript in StarterPlayer > StarterPlayerScripts
-- OR paste into Command Bar

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
	warn("This must run as a LocalScript or in Command Bar")
	return
end

local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	
	-- Store original WalkSpeed
	local originalWalkSpeed = humanoid.WalkSpeed
	local originalRunSpeed = humanoid.WalkSpeed * 2 -- Default run speed is usually 2x walk speed
	
	-- Function to handle shift key
	local shiftHeld = false
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			shiftHeld = true
			-- Set speed to 2x the original walk speed (which is already 2x faster than normal)
			humanoid.WalkSpeed = originalWalkSpeed * 2
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			shiftHeld = false
			humanoid.WalkSpeed = originalWalkSpeed
		end
	end)
	
	print("✓ Shift speed doubled! (2x faster)")
end

-- Connect to character
if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)

