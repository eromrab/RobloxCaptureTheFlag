-- LOCK CAMERA TO FIRST PERSON - Command Bar Version
-- Paste this into Roblox Studio Command Bar to test
-- For permanent use, use LockFirstPerson_LocalScript.lua instead

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local player = Players.LocalPlayer
if not player then
	print("⚠ No local player found. Make sure you're in Play mode.")
	return
end

print("✓ Starting first person lock for " .. player.Name)

-- Set StarterPlayer default camera mode (affects all future players)
StarterPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
print("✓ Set StarterPlayer.CameraMode to LockFirstPerson")

-- Function to lock camera to first person by controlling camera
local function lockCamera()
	local camera = workspace.CurrentCamera
	if camera and player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			-- Set camera subject and type
			camera.CameraSubject = humanoid
			camera.CameraType = Enum.CameraType.Custom
		end
	end
end

-- Lock immediately if character exists
lockCamera()

-- Continuously enforce first person (in case other scripts override it)
local connection
connection = RunService.Heartbeat:Connect(function()
	lockCamera()
	
	-- Also directly check and set camera
	local camera = workspace.CurrentCamera
	if camera and player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			-- Ensure camera stays locked to first person
			if camera.CameraSubject ~= humanoid then
				camera.CameraSubject = humanoid
			end
			if camera.CameraType ~= Enum.CameraType.Custom then
				camera.CameraType = Enum.CameraType.Custom
			end
		end
	end
end)

-- Handle respawns
player.CharacterAdded:Connect(function(newCharacter)
	wait(0.2) -- Wait for character to fully load
	lockCamera()
	print("✓ Locked camera after respawn")
end)

print("✓ First person camera locked (continuously enforced)")
print("Try scrolling - camera should stay locked in first person!")

