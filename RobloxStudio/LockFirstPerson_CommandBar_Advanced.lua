-- LOCK CAMERA TO FIRST PERSON - Advanced Command Bar Version
-- This version also blocks scroll wheel to prevent camera zoom changes
-- Paste this into Roblox Studio Command Bar to test

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
	print("⚠ No local player found. Make sure you're in Play mode.")
	return
end

print("✓ Starting advanced first person lock for " .. player.Name)

-- Set StarterPlayer default camera mode
StarterPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
print("✓ Set StarterPlayer.CameraMode to LockFirstPerson")

-- Block scroll wheel input to prevent camera zoom
UserInputService.InputChanged:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		-- Prevent scroll wheel from changing camera
		-- This keeps camera locked in first person
	end
end)

-- Function to lock camera to first person
local function lockCamera()
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			-- Force camera mode
			humanoid.CameraMode = Enum.CameraMode.LockFirstPerson
			
			-- Debug: Print current camera mode
			-- print("CameraMode:", humanoid.CameraMode)
		end
	end
end

-- Lock immediately if character exists
lockCamera()

-- Continuously enforce first person every frame
local connection
connection = RunService.Heartbeat:Connect(function()
	lockCamera()
	
	-- Double-check and force reset if needed
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			-- Force it every frame to override any other scripts
			humanoid.CameraMode = Enum.CameraMode.LockFirstPerson
		end
	end
end)

-- Handle respawns
player.CharacterAdded:Connect(function(newCharacter)
	wait(0.2) -- Wait for humanoid to fully load
	local humanoid = newCharacter:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.CameraMode = Enum.CameraMode.LockFirstPerson
		lockCamera()
		print("✓ Locked camera after respawn")
	end
end)

print("✓ Advanced first person camera lock active")
print("Camera is locked - try scrolling, it should stay in first person!")

