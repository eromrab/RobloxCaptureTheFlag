local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GunConfig = require(ReplicatedStorage:WaitForChild("GunConfig", 5) or script:WaitForChild("GunConfig", 5))

-- Ensure remotes exist
local fireRemote = ReplicatedStorage:FindFirstChild(GunConfig.FireRemoteName)
if not fireRemote then
	fireRemote = Instance.new("RemoteEvent")
	fireRemote.Name = GunConfig.FireRemoteName
	fireRemote.Parent = ReplicatedStorage
end

local replicateEffectsRemote = ReplicatedStorage:FindFirstChild(GunConfig.ReplicateEffectsRemoteName)
if not replicateEffectsRemote then
	replicateEffectsRemote = Instance.new("RemoteEvent")
	replicateEffectsRemote.Name = GunConfig.ReplicateEffectsRemoteName
	replicateEffectsRemote.Parent = ReplicatedStorage
end

-- Server-side state per player
local playerState = {}

local function getPlayerState(player)
	local state = playerState[player]
	if not state then
		state = {
			lastFireTime = 0,
			currentMag = GunConfig.MagSize,
			reserveAmmo = 90, -- Starting reserve ammo (matches client)
			isReloading = false,
		}
		playerState[player] = state
	end
	return state
end

local function cleanup(player)
	playerState[player] = nil
end

Players.PlayerRemoving:Connect(cleanup)

-- Simple helper
local function now()
	return os.clock()
end

local function canFire(state)
	if state.isReloading then
		return false
	end
	if state.currentMag <= 0 then
		return false
	end
	local secondsPerShot = 60 / GunConfig.FireRate
	return (now() - state.lastFireTime) >= secondsPerShot
end

local function beginReload(state)
	if state.isReloading then return end
	if state.currentMag >= GunConfig.MagSize then return end
	if state.reserveAmmo <= 0 then return end

	state.isReloading = true
	task.delay(GunConfig.ReloadTime, function()
		local needed = GunConfig.MagSize - state.currentMag
		local toLoad = math.min(needed, state.reserveAmmo)
		state.currentMag += toLoad
		state.reserveAmmo -= toLoad
		state.isReloading = false
	end)
end

-- Hit/damage resolution
local function applyDamage(hitInstance, baseDamage, player)
	if not hitInstance then 
		return false
	end

	-- Try to find the character model
	local character = hitInstance:FindFirstAncestorOfClass("Model")
	if not character then 
		print("DEBUG: No character model found for hit part: " .. (hitInstance.Name or "unknown"))
		return false
	end

	-- Check if it's a bot or player character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then 
		print("DEBUG: No humanoid found in character: " .. character.Name)
		return false
	end

	-- Prevent self-damage
	if player and player.Character == character then
		return false
	end

	-- Calculate damage
	local damage = baseDamage
	local isHeadshot = false
	if hitInstance.Name == "Head" then
		damage = baseDamage * GunConfig.HeadshotMultiplier
		isHeadshot = true
	end

	-- Apply damage
	humanoid:TakeDamage(damage)

	-- Debug output
	local attackerName = player and player.Name or "Unknown"
	print(string.format("HIT: %s hit %s (%s) for %d damage. Health: %.1f/%.1f", 
		attackerName, 
		character.Name, 
		isHeadshot and "HEAD" or "BODY",
		damage,
		humanoid.Health,
		humanoid.MaxHealth
		))

	return true
end

-- Validate and raycast server-side
local function validateAndRaycast(player, origin, direction)
	if typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then
		return nil
	end

	local character = player.Character
	if not character then return nil end

	local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
	if not root then return nil end

	-- Anti-cheat: ensure origin not too far from player's weapon
	local originDistance = (origin - root.Position).Magnitude
	if originDistance > 20 then -- Increased from 15 to 20 for viewmodel muzzle positions
		print("DEBUG: Shot rejected - origin too far from player: " .. string.format("%.2f", originDistance) .. " studs")
		return nil
	end

	-- Clamp direction and range
	local dirUnit = direction.Magnitude > 0 and direction.Unit or Vector3.new(0, 0, -1)
	local castDistance = math.min(direction.Magnitude, GunConfig.MaxRange)
	local castVector = dirUnit * castDistance

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { character }
	params.IgnoreWater = true

	-- Perform the main raycast
	local result = workspace:Raycast(origin, castVector, params)

	-- If we got a hit, return it
	if result and result.Instance then
		return result
	end

	-- Fallback: Cast a slightly wider ray to catch edge cases (helps with moving targets)
	-- Use a small spread pattern (3 rays in a small triangle)
	local spreadRays = {
		{offset = Vector3.new(0, 0, 0)}, -- Center
		{offset = dirUnit:Cross(Vector3.new(0, 1, 0)).Unit * 0.3}, -- Right
		{offset = -dirUnit:Cross(Vector3.new(0, 1, 0)).Unit * 0.3}, -- Left
	}

	for _, rayData in ipairs(spreadRays) do
		if rayData.offset.Magnitude > 0 then -- Skip center (already checked)
			local offsetOrigin = origin + rayData.offset
			local offsetResult = workspace:Raycast(offsetOrigin, castVector, params)
			if offsetResult and offsetResult.Instance then
				local hitChar = offsetResult.Instance:FindFirstAncestorOfClass("Model")
				if hitChar and hitChar:FindFirstChildOfClass("Humanoid") then
					return offsetResult
				end
			end
		end
	end

	return result
end

-- Fire request
fireRemote.OnServerEvent:Connect(function(player, payload)
	if typeof(payload) ~= "table" then return end

	local origin = payload.origin
	local direction = payload.direction
	local timestamp = payload.t or 0

	local state = getPlayerState(player)

	-- Auto-trigger reload request if clip empty
	if state.currentMag <= 0 then
		beginReload(state)
		return
	end

	if not canFire(state) then
		return
	end

	-- Mark fired
	state.lastFireTime = now()
	state.currentMag -= 1

	local rayResult = validateAndRaycast(player, origin, direction)

	-- Apply damage if hit a character
	if rayResult and rayResult.Instance then
		-- Try to find the character from the hit part
		local hitPart = rayResult.Instance
		local character = hitPart:FindFirstAncestorOfClass("Model")

		-- If we hit a part that's part of a character, apply damage
		if character and character:FindFirstChildOfClass("Humanoid") then
			local damageApplied = applyDamage(hitPart, GunConfig.Damage, player)
			if not damageApplied then
				print("DEBUG: Raycast hit " .. hitPart.Name .. " in " .. character.Name .. " but damage was not applied")
			end
		else
			-- Hit something that's not a character
			print("DEBUG: Raycast hit " .. hitPart.Name .. " but it's not part of a character")
			
			-- Check if hit is on Target01 for bullet marks
			local target = workspace:FindFirstChild("Target01")
			if target and hitPart:IsDescendantOf(target) then
				local targetHit = ReplicatedStorage:FindFirstChild("TargetHitEvent")
				if targetHit then
					targetHit:FireServer(hitPart, rayResult.Position, rayResult.Normal)
				end
			end
		end
	else
		-- Debug: Uncomment to see when shots miss
		-- print("DEBUG: Raycast missed - no hit detected")
	end

	-- Replicate effects (hit position and normal for impact)
	local dirUnit = direction.Magnitude > 0 and direction.Unit or Vector3.new(0, 0, -1)
	local hitPos = rayResult and rayResult.Position or (origin + dirUnit * math.min(direction.Magnitude, GunConfig.MaxRange))
	local hitNormal = rayResult and rayResult.Normal or Vector3.new(0, 0, 0)

	replicateEffectsRemote:FireAllClients(player, {
		origin = origin,
		hitPosition = hitPos,
		hitNormal = hitNormal,
		weapon = GunConfig.WeaponName,
	})
end)

