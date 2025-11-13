-- SMART BOT SPAWNER - Command Bar Version (Fixed)
-- Paste this into Roblox Studio Command Bar to test
-- This creates basic smart bots with pathfinding that spawn on ground and move properly

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

print("=== Smart Bot Spawner (Command Bar - Fixed) ===")

-- Check if we're in test mode (play mode)
if not RunService:IsRunning() then
	warn("⚠ Not in test mode! Script will only run in Play mode (F5).")
	warn("   Exiting...")
	return
end

-- Check if spawning is already active - stop it first
local existingFlag = workspace:FindFirstChild("BotSpawningEnabled")
if existingFlag and existingFlag.Value == true then
	print("⚠ Spawning is already active!")
	print("  Stopping existing spawn loop first...")
	existingFlag:Destroy()
	-- Wait a moment for loops to stop
	task.wait(0.5)
	print("  ✓ Existing spawn loop stopped")
end

-- CLEANUP: Remove all existing bots at the start
print("\n🧹 Cleaning up existing bots...")
local cleanupCount = 0
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (obj.Name:find("_Bot_") or obj.Name:find("Red_Bot") or obj.Name:find("Blue_Bot")) then
		obj:Destroy()
		cleanupCount = cleanupCount + 1
	end
end
print("  ✓ Removed " .. cleanupCount .. " existing bot(s)")

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

-- Simple bot creation
local function createSimpleBot(position, teamColor, teamName, enemySpawnPos)
	-- Find ground position
	local groundPos = findGroundPosition(position)
	
	local bot = Instance.new("Model")
	bot.Name = teamName .. "_Bot_" .. math.random(1000, 9999)
	
	-- HumanoidRootPart (must be created first)
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Position = groundPos
	rootPart.Anchored = false
	rootPart.CanCollide = true
	rootPart.Material = Enum.Material.SmoothPlastic
	rootPart.Color = teamColor
	rootPart.Shape = Enum.PartType.Block
	rootPart.Parent = bot
	
	-- Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1)
	head.Material = Enum.Material.SmoothPlastic
	head.Color = teamColor
	head.CanCollide = false
	head.Anchored = false
	head.Parent = bot
	
	-- Position head above root
	head.Position = groundPos + Vector3.new(0, 1.5, 0)
	
	-- Weld head to root
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = rootPart
	weld.Part1 = head
	weld.Parent = rootPart
	
	-- Humanoid (must be created after parts)
	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.Parent = bot
	
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
			humanoid:ChangeState(Enum.HumanoidStateType.Walking)
			RunService.Heartbeat:Wait()
		end
		
		if humanoid.RootPart then
			print("✓ " .. bot.Name .. ": Humanoid.RootPart detected")
			humanoidReady = true
			-- Force walking state
			humanoid:ChangeState(Enum.HumanoidStateType.Walking)
		else
			warn("❌ " .. bot.Name .. ": Humanoid.RootPart still nil after fixes!")
			humanoidReady = false
		end
	end)
	
	-- Simple AI: Move directly towards enemy spawn (simplified for reliability)
	local lastMoveTime = 0
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
		
		-- Target: enemy spawn position (on baseplate)
		if enemySpawnPos then
			local targetPos = Vector3.new(enemySpawnPos.X, baseplateY + 2, enemySpawnPos.Z)
			
			-- Use pathfinding to move towards enemy spawn
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
				-- Fallback: direct movement towards enemy spawn
				humanoid:MoveTo(targetPos)
			end
			
			-- Force walking state to ensure movement
			if humanoid:GetState() ~= Enum.HumanoidStateType.Walking then
				humanoid:ChangeState(Enum.HumanoidStateType.Walking)
			end
		end
	end)
	
	print("Created bot: " .. bot.Name .. " at " .. tostring(groundPos))
	return bot
end

-- Find spawn locations (search more thoroughly)
print("\nSearching for spawn locations...")

local redSpawn = workspace:FindFirstChild("RedSpawnLocation")
if not redSpawn then
	-- Try searching all SpawnLocation objects
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and (obj.Name:find("Red") or obj.TeamColor == BrickColor.new("Bright red")) then
			redSpawn = obj
			print("Found Red spawn: " .. obj.Name)
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
			print("Found Blue spawn: " .. obj.Name)
			break
		end
	end
end

-- Use default positions if spawn locations not found
local redSpawnPos = redSpawn and redSpawn.Position or Vector3.new(-160, 10, -40)
local blueSpawnPos = blueSpawn and blueSpawn.Position or Vector3.new(923, 10, 208)

print("Red spawn position: " .. tostring(redSpawnPos))
print("Blue spawn position: " .. tostring(blueSpawnPos))

-- Function to spawn one red bot
local function spawnRedBot()
	local spawnOffset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
	local bot = createSimpleBot(redSpawnPos + spawnOffset, Color3.new(1, 0, 0), "Red", blueSpawnPos)
	if bot then
		print("  ✓ Spawned: " .. bot.Name .. " (Red team, moving towards BLUE)")
		return bot
	else
		print("  ⚠ Failed to spawn Red bot")
		return nil
	end
end

-- Function to spawn one blue bot
local function spawnBlueBot()
	local spawnOffset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
	local bot = createSimpleBot(blueSpawnPos + spawnOffset, Color3.new(0, 0, 1), "Blue", redSpawnPos)
	if bot then
		print("  ✓ Spawned: " .. bot.Name .. " (Blue team, moving towards RED)")
		return bot
	else
		print("  ⚠ Failed to spawn Blue bot")
		return nil
	end
end

-- Initial spawn: 3 red and 3 blue bots
print("\nSpawning initial bots...")
print("Red team bots:")
for i = 1, 3 do
	task.wait(0.3)
	spawnRedBot()
end

print("\nBlue team bots:")
for i = 1, 3 do
	task.wait(0.3)
	spawnBlueBot()
end

print("\n=== Initial bots spawned! ===")
print("New bots will spawn every 10 seconds...")
print("⚠ Note: Run StopBotSpawning_CommandBar.lua to stop spawning")

-- Create a flag in workspace to control spawning
local spawnFlag = workspace:FindFirstChild("BotSpawningEnabled")
if not spawnFlag then
	spawnFlag = Instance.new("BoolValue")
	spawnFlag.Name = "BotSpawningEnabled"
	spawnFlag.Value = true
	spawnFlag.Parent = workspace
end
spawnFlag.Value = true -- Enable spawning

-- Continuous spawning: one bot per team every 10 seconds
spawn(function()
	local loopId = math.random(10000, 99999) -- Unique ID for this loop
	print("🔄 Spawn loop #" .. loopId .. " started")
	
	while true do
		-- Check if we're still in test mode (play mode)
		if not RunService:IsRunning() then
			print("🛑 Spawn loop #" .. loopId .. " stopped - exited test mode")
			break
		end
		
		-- Check if spawning is disabled (flag missing or false = stop)
		local flag = workspace:FindFirstChild("BotSpawningEnabled")
		if not flag then
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag not found (was destroyed)")
			break
		end
		if not flag.Value then
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false")
			break
		end
		
		-- Check if game is still running (workspace exists)
		if not workspace or not workspace.Parent then
			print("🛑 Game stopped - bot spawning halted")
			break
		end
		
		-- Wait 10 seconds, but check flag every 0.5 seconds
		local waitTime = 0
		while waitTime < 10 do
			task.wait(0.5) -- Check every 0.5 seconds
			waitTime = waitTime + 0.5
			
			-- Check if still in test mode
			if not RunService:IsRunning() then
				print("🛑 Spawn loop #" .. loopId .. " stopped during wait - exited test mode")
				return -- Exit the function
			end
			
			-- Check flag during wait
			local flagCheck = workspace:FindFirstChild("BotSpawningEnabled")
			if not flagCheck then
				print("🛑 Spawn loop #" .. loopId .. " stopped during wait - flag destroyed")
				return -- Exit the function
			end
			if not flagCheck.Value then
				print("🛑 Spawn loop #" .. loopId .. " stopped during wait - flag is false")
				return -- Exit the function
			end
			
			-- Check if game is still running
			if not workspace or not workspace.Parent then
				return
			end
		end
		
		-- Final check before spawning
		if not RunService:IsRunning() then
			print("🛑 Spawn loop #" .. loopId .. " stopped - exited test mode before spawn")
			break
		end
		
		local finalFlagCheck = workspace:FindFirstChild("BotSpawningEnabled")
		if not finalFlagCheck then
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag destroyed before spawn")
			break
		end
		if not finalFlagCheck.Value then
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false before spawn")
			break
		end
		
		if not workspace or not workspace.Parent then
			break
		end
		
		print("\n⏰ Spawning new bots (every 10 seconds)...")
		
		-- Check flag and test mode before spawning red bot
		if not RunService:IsRunning() then
			print("🛑 Spawn loop #" .. loopId .. " stopped - exited test mode before Red bot")
			break
		end
		
		local redFlagCheck = workspace:FindFirstChild("BotSpawningEnabled")
		if not redFlagCheck then
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag destroyed before Red bot")
			break
		end
		if redFlagCheck.Value then
			spawnRedBot()
		else
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false before Red bot")
			break
		end
		
		task.wait(0.5) -- Small delay between teams
		
		-- Check flag and test mode before spawning blue bot
		if not RunService:IsRunning() then
			print("🛑 Spawn loop #" .. loopId .. " stopped - exited test mode before Blue bot")
			break
		end
		
		local blueFlagCheck = workspace:FindFirstChild("BotSpawningEnabled")
		if not blueFlagCheck then
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag destroyed before Blue bot")
			break
		end
		if blueFlagCheck.Value then
			spawnBlueBot()
		else
			print("🛑 Spawn loop #" .. loopId .. " stopped - flag is false before Blue bot")
			break
		end
	end
end)

