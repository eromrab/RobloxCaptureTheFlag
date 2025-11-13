-- SMART BOT SPAWNER FOR CTF GAME
-- Creates intelligent bots with pathfinding, combat AI, and CTF objectives
-- Place this in ServerScriptService
-- 
-- Features:
-- - Pathfinding to navigate the map
-- - Combat AI (find and attack enemies)
-- - CTF objectives (capture flags, defend base)
-- - Team-based behavior
-- - Respawn handling

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

-- Configuration
local BOT_COUNT = 5  -- Number of bots per team
local BOT_SPAWN_DELAY = 2  -- Delay between bot spawns
local UPDATE_RATE = 0.5  -- How often bots update their behavior (seconds)

-- Bot storage
local bots = {}  -- {[bot] = {humanoid, rootPart, target, state, team}}

-- Helper function to create a bot
local function createBot(spawnPosition, teamColor)
	local bot = Instance.new("Model")
	bot.Name = "Bot_" .. math.random(1000, 9999)
	
	-- Create HumanoidRootPart
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Position = spawnPosition
	rootPart.Anchored = false
	rootPart.CanCollide = true
	rootPart.Material = Enum.Material.SmoothPlastic
	rootPart.Color = teamColor
	rootPart.Parent = bot
	
	-- Create Humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.Parent = bot
	
	-- Create body parts (simplified)
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1)
	head.Material = Enum.Material.SmoothPlastic
	head.Color = teamColor
	head.Parent = bot
	
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Material = Enum.Material.SmoothPlastic
	torso.Color = teamColor
	torso.Parent = bot
	
	-- Weld parts together
	local headWeld = Instance.new("WeldConstraint")
	headWeld.Part0 = rootPart
	headWeld.Part1 = head
	headWeld.Parent = rootPart
	
	local torsoWeld = Instance.new("WeldConstraint")
	torsoWeld.Part0 = rootPart
	torsoWeld.Part1 = torso
	torsoWeld.Parent = rootPart
	
	-- Add to workspace
	bot.Parent = workspace
	
	-- Store bot data
	bots[bot] = {
		humanoid = humanoid,
		rootPart = rootPart,
		target = nil,
		state = "idle",  -- idle, attacking, capturing, defending
		team = teamColor,
		path = nil,
		lastUpdate = 0
	}
	
	return bot
end

-- Find nearest enemy
local function findNearestEnemy(bot, botData)
	local botPosition = botData.rootPart.Position
	local nearestEnemy = nil
	local nearestDistance = math.huge
	
	-- Check all players and bots
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				-- Check if different team (you'll need to implement team checking)
				local distance = (player.Character.HumanoidRootPart.Position - botPosition).Magnitude
				if distance < nearestDistance and distance < 100 then  -- 100 stud range
					nearestDistance = distance
					nearestEnemy = player.Character.HumanoidRootPart
				end
			end
		end
	end
	
	-- Check other bots
	for otherBot, otherData in pairs(bots) do
		if otherBot ~= bot and otherBot.Parent then
			local otherHumanoid = otherData.humanoid
			if otherHumanoid and otherHumanoid.Health > 0 and otherData.team ~= botData.team then
				local distance = (otherData.rootPart.Position - botPosition).Magnitude
				if distance < nearestDistance and distance < 100 then
					nearestDistance = distance
					nearestEnemy = otherData.rootPart
				end
			end
		end
	end
	
	return nearestEnemy
end

-- Find flag to capture (simplified - you'll need to implement flag detection)
local function findFlagToCapture(botData)
	-- This is a placeholder - implement based on your flag system
	-- Look for flags in zones that are not the bot's team
	local flags = workspace:FindFirstChild("Flags")
	if flags then
		for _, flag in ipairs(flags:GetChildren()) do
			if flag:IsA("BasePart") or flag:IsA("Model") then
				-- Check if flag belongs to enemy team
				-- Return flag position
				local flagPart = flag:IsA("Model") and flag:FindFirstChild("Handle") or flag
				if flagPart then
					return flagPart
				end
			end
		end
	end
	return nil
end

-- Move bot to target using pathfinding
local function moveBotToTarget(bot, botData, target)
	if not target or not target.Parent then
		return false
	end
	
	local currentTime = tick()
	if botData.path and (currentTime - botData.lastUpdate) < UPDATE_RATE then
		return true  -- Still following current path
	end
	
	botData.lastUpdate = currentTime
	
	-- Create path
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true
	})
	
	local success, errorMessage = pcall(function()
		path:ComputeAsync(botData.rootPart.Position, target.Position)
	end)
	
	if not success or path.Status ~= Enum.PathStatus.Success then
		-- Fallback: move directly toward target
		local direction = (target.Position - botData.rootPart.Position).Unit
		botData.humanoid:MoveTo(botData.rootPart.Position + direction * 5)
		return false
	end
	
	-- Get waypoints
	local waypoints = path:GetWaypoints()
	if #waypoints > 1 then
		-- Move to first waypoint
		botData.humanoid:MoveTo(waypoints[2].Position)
		botData.path = path
		return true
	end
	
	return false
end

-- Bot AI update function
local function updateBotAI(bot, botData)
	if not bot.Parent or not botData.humanoid or botData.humanoid.Health <= 0 then
		return
	end
	
	-- Find nearest enemy
	local enemy = findNearestEnemy(bot, botData)
	
	if enemy then
		-- Attack enemy
		botData.state = "attacking"
		botData.target = enemy
		
		-- Move toward enemy
		moveBotToTarget(bot, botData, enemy)
		
		-- Face enemy
		local direction = (enemy.Position - botData.rootPart.Position).Unit
		botData.rootPart.CFrame = CFrame.lookAt(botData.rootPart.Position, botData.rootPart.Position + direction)
		
		-- Attack if close enough (you'll need to implement actual attack logic)
		local distance = (enemy.Position - botData.rootPart.Position).Magnitude
		if distance < 10 then
			-- Attack logic here (fire weapon, melee, etc.)
		end
	else
		-- No enemy nearby - look for objectives
		local flag = findFlagToCapture(botData)
		if flag then
			botData.state = "capturing"
			botData.target = flag
			moveBotToTarget(bot, botData, flag)
		else
			-- Patrol or defend
			botData.state = "patrolling"
			botData.target = nil
			-- Random movement or return to base
		end
	end
end

-- Main bot update loop
local function updateBots()
	for bot, botData in pairs(bots) do
		if bot.Parent and botData.humanoid and botData.humanoid.Health > 0 then
			updateBotAI(bot, botData)
		elseif not bot.Parent then
			-- Clean up destroyed bots
			bots[bot] = nil
		end
	end
end

-- Spawn bots for a team
local function spawnBotsForTeam(teamColor, spawnLocation)
	if not spawnLocation then
		warn("No spawn location found for team")
		return
	end
	
	local spawnPosition = spawnLocation.Position + Vector3.new(0, 5, 0)
	
	for i = 1, BOT_COUNT do
		wait(BOT_SPAWN_DELAY)
		local bot = createBot(spawnPosition + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)), teamColor)
		print("Spawned bot: " .. bot.Name)
	end
end

-- Find spawn location by team color
local function findSpawnLocation(teamColor)
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			if obj.TeamColor == teamColor or 
			   (teamColor == Color3.new(1, 0, 0) and obj.Name:find("Red")) or
			   (teamColor == Color3.new(0, 0, 1) and obj.Name:find("Blue")) then
				return obj
			end
		end
	end
	return nil
end

-- Initialize bot spawning
local function initializeBots()
	wait(5)  -- Wait for game to load
	
	-- Spawn red team bots
	local redSpawn = findSpawnLocation(Color3.new(1, 0, 0)) or workspace:FindFirstChild("RedSpawnLocation")
	if redSpawn then
		spawnBotsForTeam(Color3.new(1, 0, 0), redSpawn)
	end
	
	-- Spawn blue team bots
	local blueSpawn = findSpawnLocation(Color3.new(0, 0, 1)) or workspace:FindFirstChild("BlueSpawnLocation")
	if blueSpawn then
		spawnBotsForTeam(Color3.new(0, 0, 1), blueSpawn)
	end
	
	-- Start update loop
	RunService.Heartbeat:Connect(updateBots)
	
	print("Smart Bot Spawner initialized! " .. BOT_COUNT * 2 .. " bots spawned.")
end

-- Handle bot respawns
local function handleBotRespawn(bot, botData)
	wait(5)  -- Respawn delay
	
	if not bot.Parent then
		-- Find spawn location for bot's team
		local spawnLocation = findSpawnLocation(botData.team)
		if spawnLocation then
			botData.rootPart.Position = spawnLocation.Position + Vector3.new(0, 5, 0)
			botData.humanoid.Health = botData.humanoid.MaxHealth
			bot.Parent = workspace
		end
	end
end

-- Monitor bot deaths
for bot, botData in pairs(bots) do
	botData.humanoid.Died:Connect(function()
		handleBotRespawn(bot, botData)
	end)
end

-- Start the bot system
initializeBots()

