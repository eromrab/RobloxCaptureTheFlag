-- SHIFT TO RUN - LocalScript (with diagnostics)
-- Place this in: StarterPlayer > StarterPlayerScripts
-- Holding Shift makes the player run at 6x speed

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local runMultiplier = 6
local isRunning = false
local normalWalkSpeed = 16 -- Default walk speed
local humanoid = nil
local debugMode = false -- Disable diagnostics (only errors will show)

-- Diagnostic function (only shows errors/warnings)
local function debugPrint(message)
	-- Only show errors and warnings, not regular debug info
	if message:find("❌") or message:find("⚠") or message:find("ERROR") then
		warn("[ShiftToRun] " .. message)
	end
end

-- Function to get current humanoid (only for players, not bots)
local function getHumanoid()
	local character = player.Character
	if not character then
		return nil -- No character yet, this is normal
	end
	
	-- Verify this is the player's character (not a bot)
	-- Bots don't have a Player associated with their character
	local foundHumanoid = character:FindFirstChildOfClass("Humanoid")
	if not foundHumanoid then
		return nil
	end
	
	-- Check if this character belongs to a player (not a bot)
	-- Player characters have a Player object, bots don't
	local characterPlayer = Players:GetPlayerFromCharacter(character)
	if characterPlayer ~= player then
		-- This shouldn't happen in a LocalScript, but just in case
		return nil
	end
	
	return foundHumanoid
end

-- Function to update walk speed based on shift key
local function updateWalkSpeed()
	local currentHumanoid = getHumanoid()
	if currentHumanoid then
		local targetSpeed = isRunning and (normalWalkSpeed * runMultiplier) or normalWalkSpeed
		currentHumanoid.WalkSpeed = targetSpeed
		-- No debug output for normal operation
	else
		debugPrint("⚠ Cannot update walk speed - no humanoid")
	end
end

-- Handle shift key press/release
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- Ignore if UI is handling the input
	
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		isRunning = true
		updateWalkSpeed()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		isRunning = false
		updateWalkSpeed()
	end
end)

-- Handle character spawn/respawn
local function onCharacterAdded(character)
	humanoid = character:WaitForChild("Humanoid")
	normalWalkSpeed = humanoid.WalkSpeed
	isRunning = false
	updateWalkSpeed()
	
	-- Also update when humanoid properties change (in case other scripts modify walk speed)
	humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if not isRunning then
			normalWalkSpeed = humanoid.WalkSpeed
		else
			debugPrint("⚠ WalkSpeed changed externally while running (ignoring update)")
		end
	end)
end

-- Connect to character spawn (with safety check)
if player then
	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
else
	debugPrint("❌ ERROR: player is nil! This script must be a LocalScript in StarterPlayer > StarterPlayerScripts")
end

-- Continuously update walk speed (handles respawns and external changes)
local lastWarningTime = 0
RunService.Heartbeat:Connect(function()
	local currentHumanoid = getHumanoid()
	if currentHumanoid then
		updateWalkSpeed()
		lastWarningTime = 0 -- Reset warning timer when humanoid is found
	else
		-- Only warn occasionally if humanoid is missing for a long time (error condition)
		-- This prevents spam before character spawns
		local currentTime = tick()
		if currentTime - lastWarningTime > 10 then -- Only warn every 10 seconds
			-- Only warn if player should have a character by now
			if player.Character then
				debugPrint("⚠ No humanoid found in player character")
			end
			lastWarningTime = currentTime
		end
	end
end)

