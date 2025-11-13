-- BOT SPAWNER V3 - Script Version
-- Place this in: ServerScriptService
-- This automatically spawns bots when the game runs
-- Automatically stops when exiting test mode (Scripts stop naturally)

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

-- print("=== Smart Bot Spawner (Script Version) ===")
-- print("Bot spawning will start automatically...")

-- Function to find ground position (top of Baseplate)
local function findGroundPosition(startPosition)
	-- Find Baseplate in workspace
	local baseplate = workspace:FindFirstChild("Baseplate")
	
	if baseplate and baseplate:IsA("Part") then
		-- Use top of Baseplate (Position.Y + Size.Y/2)
		local groundY = baseplate.Position.Y + (baseplate.Size.Y / 2)
		return Vector3.new(startPosition.X, groundY + 2, startPosition.Z) -- Spawn 2 studs above baseplate
	else
		-- Fallback: use Y = 0.5 (typical baseplate top)
		return Vector3.new(startPosition.X, 0.5, startPosition.Z)
	end
end

-- Simple bot creation (matching existing bot structure)
local function createSimpleBot(position, teamColor, teamName, enemySpawnPos)
	-- Find ground position
	local groundPos = findGroundPosition(position)
	
	-- Convert Color3 to BrickColor
	local brickColor
	if teamName == "Red" then
		brickColor = BrickColor.new("Bright red")
	else
		brickColor = BrickColor.new("Bright blue")
	end
	
	local bot = Instance.new("Model")
	bot.Name = teamName .. "_Bot_" .. math.random(1000, 9999)
	
	-- HumanoidRootPart (player-sized, matching existing bots)
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1) -- Standard player size
	rootPart.Position = groundPos
	rootPart.Anchored = false
	rootPart.CanCollide = true
	rootPart.BrickColor = brickColor
	rootPart.Material = Enum.Material.SmoothPlastic
	rootPart.Parent = bot
	
	-- Humanoid (must be created after parts)
	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = 16
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer -- Show health bar
	humanoid.Parent = bot
	
	-- Store team info in a StringValue (bots can't be assigned to Teams like players)
	local teamValue = Instance.new("StringValue")
	teamValue.Name = "Team"
	teamValue.Value = teamName
	teamValue.Parent = bot
	
	-- Head (player-sized, matching existing bots)
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1) -- Standard head size
	head.BrickColor = BrickColor.new("Bright yellow") -- Yellow head like existing bots
	head.Material = Enum.Material.SmoothPlastic
	head.CanCollide = true -- Matching existing bots
	head.Parent = bot
	
	-- Create Weld to attach head to body
	local headWeld = Instance.new("WeldConstraint")
	headWeld.Part0 = rootPart
	headWeld.Part1 = head
	headWeld.Parent = rootPart
	
	-- Position head on top of body using CFrame (matching existing bots)
	head.CFrame = rootPart.CFrame * CFrame.new(0, 1.5, 0)
	
	-- Torso (for visual, matching existing bots)
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.BrickColor = brickColor
	torso.Material = Enum.Material.SmoothPlastic
	torso.CanCollide = false
	torso.Transparency = 0.3 -- Matching existing bots
	torso.Parent = bot
	torso.CFrame = rootPart.CFrame
	
	local torsoWeld = Instance.new("WeldConstraint")
	torsoWeld.Part0 = rootPart
	torsoWeld.Part1 = torso
	torsoWeld.Parent = rootPart
	
	-- Set PrimaryPart (important for raycasting and model detection)
	bot.PrimaryPart = rootPart
	
	-- Parent bot to workspace (Humanoid needs to be in workspace to detect root part)
	bot.Parent = workspace
	
	-- AI variables
	local humanoidReady = false
	
	-- Get baseplate Y position for constraining bots
	local baseplate = workspace:FindFirstChild("Baseplate")
	local baseplateY = 0.5
	if baseplate and baseplate:IsA("Part") then
		baseplateY = baseplate.Position.Y + (baseplate.Size.Y / 2)
	end
	
	-- Wait for Humanoid to detect HumanoidRootPart, then start AI
	spawn(function()
		-- Wait multiple frames to ensure Humanoid detects RootPart
		for i = 1, 3 do
			RunService.Heartbeat:Wait()
		end
		
		-- Force Humanoid to detect RootPart
		if not humanoid.RootPart then
			warn("⚠ " .. bot.Name .. ": Humanoid.RootPart is nil! Trying to fix...")
			-- Try changing state to force detection
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			RunService.Heartbeat:Wait()
			humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			RunService.Heartbeat:Wait()
		end
		
		if humanoid.RootPart then
			-- print("✓ " .. bot.Name .. ": Humanoid.RootPart detected")
			humanoidReady = true
		else
			warn("❌ " .. bot.Name .. ": Humanoid.RootPart still nil after fixes!")
			humanoidReady = false
		end
	end)
	
	-- Simple AI: Move directly towards enemy spawn with stuck detection
	local lastMoveTime = 0
	local lastPosition = nil
	local lastPositionTime = 0
	local currentTargetOffset = 0 -- Angle offset for stuck avoidance (in degrees)
	local lastStuckTime = 0 -- Time when bot last got stuck
	local STUCK_IMMUNITY_DURATION = 5 -- Seconds to keep offset direction after getting stuck
	
	RunService.Heartbeat:Connect(function()
		if not bot.Parent or humanoid.Health <= 0 or not rootPart.Parent then
			return
		end
		
		-- Wait for Humanoid to be ready
		if not humanoidReady then
			return
		end
		
		-- Check if Humanoid has root part
		if not humanoid.RootPart then
			return
		end
		
		local currentTime = tick()
		if currentTime - lastMoveTime < 0.5 then
			return -- Don't update path every frame
		end
		lastMoveTime = currentTime
		
		-- Keep bot on baseplate (constrain Y position)
		local botPos = rootPart.Position
		if math.abs(botPos.Y - baseplateY) > 5 then
			-- Bot is too far from baseplate, teleport back
			local correctedPos = Vector3.new(botPos.X, baseplateY + 2, botPos.Z)
			rootPart.Position = correctedPos
			botPos = correctedPos
		end
		
		-- Stuck detection: Check if bot has moved significantly in last 2 seconds
		if lastPosition then
			local timeSinceLastCheck = currentTime - lastPositionTime
			local distanceMoved = (botPos - lastPosition).Magnitude
			
			-- If bot hasn't moved much (< 5 studs) in 2+ seconds, it's stuck
			if timeSinceLastCheck >= 2 and distanceMoved < 5 then
				-- Bot is stuck - change direction 30 degrees left or right (50/50 chance)
				local directionChange = math.random() < 0.5 and -30 or 30
				currentTargetOffset = currentTargetOffset + directionChange
				lastStuckTime = currentTime -- Start immunity period
				-- print("🔄 " .. bot.Name .. " stuck - changing direction by " .. directionChange .. " degrees (new offset: " .. currentTargetOffset .. "°, immunity for " .. STUCK_IMMUNITY_DURATION .. "s)")
				lastPosition = botPos -- Reset stuck detection
				lastPositionTime = currentTime
			elseif timeSinceLastCheck >= 2 then
				-- Bot moved enough (> 5 studs in 2 seconds)
				-- Only reset offset if immunity period has passed (5 seconds since last stuck)
				local timeSinceStuck = currentTime - lastStuckTime
				if currentTargetOffset ~= 0 and timeSinceStuck >= STUCK_IMMUNITY_DURATION then
					-- Immunity period over - gradually reset offset back to 0
					-- Reduce offset by 10 degrees per successful movement check
					if math.abs(currentTargetOffset) <= 10 then
						currentTargetOffset = 0
						-- print("✓ " .. bot.Name .. " - offset reset, heading back towards spawn")
					else
						currentTargetOffset = currentTargetOffset - (currentTargetOffset > 0 and 10 or -10)
					end
				end
				lastPosition = botPos
				lastPositionTime = currentTime
			end
		else
			-- Initialize position tracking
			lastPosition = botPos
			lastPositionTime = currentTime
		end
		
		-- Target: enemy spawn position (on baseplate)
		if enemySpawnPos then
			local baseTargetPos = Vector3.new(enemySpawnPos.X, baseplateY + 2, enemySpawnPos.Z)
			
			-- Apply direction offset if bot is stuck
			local targetPos = baseTargetPos
			if currentTargetOffset ~= 0 then
				-- Calculate direction from bot to enemy spawn
				local directionToEnemy = (baseTargetPos - botPos)
				directionToEnemy = Vector3.new(directionToEnemy.X, 0, directionToEnemy.Z) -- Flatten to XZ plane
				directionToEnemy = directionToEnemy.Unit
				
				-- Rotate direction by the offset angle
				local angleRad = math.rad(currentTargetOffset)
				local cosAngle = math.cos(angleRad)
				local sinAngle = math.sin(angleRad)
				local rotatedDirection = Vector3.new(
					directionToEnemy.X * cosAngle - directionToEnemy.Z * sinAngle,
					0,
					directionToEnemy.X * sinAngle + directionToEnemy.Z * cosAngle
				)
				
				-- Create new target position at same distance but rotated direction
				local distanceToEnemy = (baseTargetPos - botPos).Magnitude
				targetPos = botPos + (rotatedDirection * math.min(distanceToEnemy, 50)) -- Cap at 50 studs ahead
				targetPos = Vector3.new(targetPos.X, baseplateY + 2, targetPos.Z)
			end
			
			-- Check if bot has reached enemy spawn (within 10 studs)
			local distanceToTarget = (botPos - targetPos).Magnitude
			if distanceToTarget < 10 and currentTargetOffset == 0 then
				-- Only kill if we're at the actual enemy spawn (not a rotated target)
				local distanceToBaseTarget = (botPos - baseTargetPos).Magnitude
				if distanceToBaseTarget < 10 then
					-- Bot reached enemy spawn - kill it
					-- print("💀 " .. bot.Name .. " reached enemy spawn - eliminated!")
					humanoid.Health = 0
					return
				end
			end
			
			-- Use pathfinding to move towards target
			local path = PathfindingService:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = true
			})
			
			local success, errorMessage = pcall(function()
				path:ComputeAsync(botPos, targetPos)
			end)
			
			if success and path.Status == Enum.PathStatus.Success then
				local waypoints = path:GetWaypoints()
				if #waypoints > 1 then
					-- Move to next waypoint (ensure it's on baseplate)
					local waypointPos = waypoints[2].Position
					waypointPos = Vector3.new(waypointPos.X, baseplateY + 2, waypointPos.Z)
					humanoid:MoveTo(waypointPos)
				else
					-- If only one waypoint, move directly to target
					humanoid:MoveTo(targetPos)
				end
			else
				-- Fallback: direct movement towards target
				humanoid:MoveTo(targetPos)
			end
		end
	end)
	
	-- Remove bot when health reaches 0 (matching existing bots)
	humanoid.Died:Connect(function()
		task.wait(5) -- Wait 5 seconds before removing
		if bot.Parent then
			bot:Destroy()
		end
	end)
	
	-- print("Created bot: " .. bot.Name .. " at " .. tostring(groundPos))
	return bot
end

-- Function to find or create a team
local function getOrCreateTeam(teamName, teamColor)
	-- Try to find existing team
	for _, team in ipairs(Teams:GetTeams()) do
		if team.Name == teamName or team.TeamColor == teamColor then
			return team
		end
	end
	
	-- Create new team if it doesn't exist
	local team = Instance.new("Team")
	team.Name = teamName
	team.TeamColor = teamColor
	team.AutoAssignable = false -- Don't auto-assign players
	team.Parent = Teams
	return team
end

-- Ensure Red and Blue teams exist
local redTeam = getOrCreateTeam("Red", BrickColor.new("Bright red"))
local blueTeam = getOrCreateTeam("Blue", BrickColor.new("Bright blue"))

-- Find spawn locations
-- print("\nSearching for spawn locations...")

local redSpawn = workspace:FindFirstChild("RedSpawnLocation")
if not redSpawn then
	-- Try searching all SpawnLocation objects
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and (obj.Name:find("Red") or obj.TeamColor == BrickColor.new("Bright red")) then
			redSpawn = obj
			-- print("Found Red spawn: " .. obj.Name)
			break
		end
	end
end

local blueSpawn = workspace:FindFirstChild("BlueSpawnLocation")
if not blueSpawn then
	-- Try searching all SpawnLocation objects
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and (obj.Name:find("Blue") or obj.TeamColor == BrickColor.new("Bright blue")) then
			blueSpawn = obj
			-- print("Found Blue spawn: " .. obj.Name)
			break
		end
	end
end

-- Use default positions if spawn locations not found
local redSpawnPos = redSpawn and redSpawn.Position or Vector3.new(-160, 10, -40)
local blueSpawnPos = blueSpawn and blueSpawn.Position or Vector3.new(923, 10, 208)

-- print("Red spawn position: " .. tostring(redSpawnPos))
-- print("Blue spawn position: " .. tostring(blueSpawnPos))

-- Function to count active bots for a team
local function countActiveBots(teamName)
	local count = 0
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") and obj.Name:find(teamName .. "_Bot_") then
			local humanoid = obj:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				count = count + 1
			end
		end
	end
	return count
end

-- Maximum bots per team
local MAX_BOTS_PER_TEAM = 5

-- print("\n📊 Bot limit: Maximum " .. MAX_BOTS_PER_TEAM .. " active bots per team")

-- Function to spawn one red bot (only if under limit)
local function spawnRedBot()
	-- Check if we're at the limit
	local activeCount = countActiveBots("Red")
	if activeCount >= MAX_BOTS_PER_TEAM then
		-- print("  ⏸ Red team at limit (" .. activeCount .. "/" .. MAX_BOTS_PER_TEAM .. ") - skipping spawn")
		return nil
	end
	
	local spawnOffset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
	local bot = createSimpleBot(redSpawnPos + spawnOffset, Color3.new(1, 0, 0), "Red", blueSpawnPos)
	if bot then
		-- print("  ✓ Spawned: " .. bot.Name .. " (Red team: " .. (activeCount + 1) .. "/" .. MAX_BOTS_PER_TEAM .. ", moving towards BLUE)")
		return bot
	else
		-- print("  ⚠ Failed to spawn Red bot")
		return nil
	end
end

-- Function to spawn one blue bot (only if under limit)
local function spawnBlueBot()
	-- Check if we're at the limit
	local activeCount = countActiveBots("Blue")
	if activeCount >= MAX_BOTS_PER_TEAM then
		-- print("  ⏸ Blue team at limit (" .. activeCount .. "/" .. MAX_BOTS_PER_TEAM .. ") - skipping spawn")
		return nil
	end
	
	local spawnOffset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
	local bot = createSimpleBot(blueSpawnPos + spawnOffset, Color3.new(0, 0, 1), "Blue", redSpawnPos)
	if bot then
		-- print("  ✓ Spawned: " .. bot.Name .. " (Blue team: " .. (activeCount + 1) .. "/" .. MAX_BOTS_PER_TEAM .. ", moving towards RED)")
		return bot
	else
		-- print("  ⚠ Failed to spawn Blue bot")
		return nil
	end
end

-- CLEANUP: Remove all existing bots at the start
-- print("\n🧹 Cleaning up existing bots...")
local cleanupCount = 0
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (obj.Name:find("_Bot_") or obj.Name:find("Red_Bot") or obj.Name:find("Blue_Bot")) then
		obj:Destroy()
		cleanupCount = cleanupCount + 1
	end
end
-- print("  ✓ Removed " .. cleanupCount .. " existing bot(s)")

-- Create a flag in workspace to control spawning
local spawnFlag = workspace:FindFirstChild("BotSpawningEnabled")
if not spawnFlag then
	spawnFlag = Instance.new("BoolValue")
	spawnFlag.Name = "BotSpawningEnabled"
	spawnFlag.Value = true
	spawnFlag.Parent = workspace
end
spawnFlag.Value = true -- Enable spawning

-- Initial spawn: 3 red and 3 blue bots
-- print("\nSpawning initial bots...")
-- print("Red team bots:")
for i = 1, 3 do
	task.wait(0.3)
	spawnRedBot()
end

-- print("\nBlue team bots:")
for i = 1, 3 do
	task.wait(0.3)
	spawnBlueBot()
end

-- print("\n=== Initial bots spawned! ===")
-- print("New bots will spawn every 10 seconds...")

-- Continuous spawning: one bot per team every 10 seconds
-- Scripts automatically stop when exiting test mode, so no need to check RunService:IsRunning()
spawn(function()
	local loopId = math.random(10000, 99999) -- Unique ID for this loop
	-- print("🔄 Spawn loop #" .. loopId .. " started")
	
	while true do
		-- Check if spawning is disabled (flag missing or false = stop)
		local flag = workspace:FindFirstChild("BotSpawningEnabled")
		if not flag then
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag not found (was destroyed)")
			break
		end
		if not flag.Value then
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false")
			break
		end
		
		-- Check if game is still running (workspace exists)
		if not workspace or not workspace.Parent then
			-- print("🛑 Game stopped - bot spawning halted")
			break
		end
		
		-- Wait 10 seconds, but check flag every 0.5 seconds
		local waitTime = 0
		while waitTime < 10 do
			task.wait(0.5) -- Check every 0.5 seconds
			waitTime = waitTime + 0.5
			
			-- Check flag during wait
			local flagCheck = workspace:FindFirstChild("BotSpawningEnabled")
			if not flagCheck then
				-- print("🛑 Spawn loop #" .. loopId .. " stopped during wait - flag destroyed")
				return -- Exit the function
			end
			if not flagCheck.Value then
				-- print("🛑 Spawn loop #" .. loopId .. " stopped during wait - flag is false")
				return -- Exit the function
			end
			
			-- Check if game is still running
			if not workspace or not workspace.Parent then
				return
			end
		end
		
		-- Final check before spawning
		local finalFlagCheck = workspace:FindFirstChild("BotSpawningEnabled")
		if not finalFlagCheck then
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag destroyed before spawn")
			break
		end
		if not finalFlagCheck.Value then
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false before spawn")
			break
		end
		
		if not workspace or not workspace.Parent then
			break
		end
		
		-- print("\n⏰ Spawning new bots (every 10 seconds)...")
		
		-- Check flag before spawning red bot
		local redFlagCheck = workspace:FindFirstChild("BotSpawningEnabled")
		if not redFlagCheck then
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag destroyed before Red bot")
			break
		end
		if redFlagCheck.Value then
			spawnRedBot()
		else
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false before Red bot")
			break
		end
		
		task.wait(0.5) -- Small delay between teams
		
		-- Check flag before spawning blue bot
		local blueFlagCheck = workspace:FindFirstChild("BotSpawningEnabled")
		if not blueFlagCheck then
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag destroyed before Blue bot")
			break
		end
		if blueFlagCheck.Value then
			spawnBlueBot()
		else
			-- print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false before Blue bot")
			break
		end
	end
end)

-- print("\n✅ Bot spawner is running!")
-- print("💡 To stop spawning, set workspace.BotSpawningEnabled.Value = false")
-- print("   Or run StopBotSpawning_CommandBar.lua")

