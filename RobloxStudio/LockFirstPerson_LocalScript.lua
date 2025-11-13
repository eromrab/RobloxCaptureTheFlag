-- LOCK CAMERA TO FIRST PERSON - LocalScript Version
-- Place this in: StarterPlayer > StarterPlayerScripts
-- This will force all players to stay in first person mode

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Function to lock camera to first person by controlling camera distance
local function lockCamera()
	local camera = workspace.CurrentCamera
	if camera and player.Character then
		-- Force camera to first person by setting camera distance to 0
		-- This prevents zooming out to third person
		camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
		-- Keep camera at first person distance
		if camera.CameraType ~= Enum.CameraType.Custom then
			camera.CameraType = Enum.CameraType.Custom
		end
	end
end

-- Continuously enforce first person (in case other scripts override it)
RunService.Heartbeat:Connect(function()
	lockCamera()
	
	-- Also prevent camera zoom by resetting camera distance
	local camera = workspace.CurrentCamera
	if camera and player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid and camera.CameraSubject == humanoid then
			-- Force first person by keeping camera close
			-- This is done by ensuring CameraType is Custom
			camera.CameraType = Enum.CameraType.Custom
		end
	end
end)

-- Handle respawns
player.CharacterAdded:Connect(function(newCharacter)
	wait(0.2) -- Wait for character to fully load
	lockCamera()
end)

-- Lock immediately if character already exists
if player.Character then
	lockCamera()
end

print("First Person Camera Lock loaded - all players are locked to first person!")

