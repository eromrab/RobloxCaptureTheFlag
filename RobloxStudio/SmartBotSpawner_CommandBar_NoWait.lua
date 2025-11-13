-- SMART BOT SPAWNER - Command Bar Version (No Wait - Instant Spawn)
-- Paste this into Roblox Studio Command Bar to test
-- This creates basic smart bots with pathfinding - spawns immediately

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

print("=== Smart Bot Spawner (Command Bar - No Wait) ===")

-- Store bots for cleanup
local spawnedBots = {}

-- Simple bot creation
local function createSimpleBot(position, teamColor, teamName)
	local bot = Instance.new("Model")
	bot.Name = teamName .. "_Bot_" .. math.random(1000, 9999)
	
	-- HumanoidRootPart
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Position = position
	rootPart.Anchored = false
	rootPart.CanCollide = true
	rootPart.Material = Enum.Material.SmoothPlastic
	rootPart.Color = teamColor
	rootPart.Parent = bot
	
	-- Humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.Parent = bot
	
	-- Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1)
	head.Material = Enum.Material.SmoothPlastic
	head.Color = teamColor
	head.Parent = bot
	
	-- Weld head to root
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = rootPart
	weld.Part1 = head
	weld.Parent = rootPart
	
	bot.Parent = workspace
	table.insert(spawnedBots, bot)
	
	-- Simple AI: find nearest player and move toward them
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if not bot.Parent or humanoid.Health <= 0 then
			connection:Disconnect()
			return
		end
		
		-- Find nearest player
		local nearestPlayer = nil
		local nearestDistance = math.huge
		local botPos = rootPart.Position
		
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local distance = (player.Character.HumanoidRootPart.Position - botPos).Magnitude
				if distance < nearestDistance and distance < 200 then
					nearestDistance = distance
					nearestPlayer = player.Character.HumanoidRootPart
				end
			end
		end
		
		if nearestPlayer then
			-- Move toward player using pathfinding
			local path = PathfindingService:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = true
			})
			
			local success, errorMessage = pcall(function()
				path:ComputeAsync(botPos, nearestPlayer.Position)
			end)
			
			if success and path.Status == Enum.PathStatus.Success then
				local waypoints = path:GetWaypoints()
				if #waypoints > 1 then
					humanoid:MoveTo(waypoints[2].Position)
				end
			else
				-- Fallback: direct movement
				humanoid:MoveTo(nearestPlayer.Position)
			end
		end
	end)
	
	print("Created bot: " .. bot.Name)
	return bot
end

-- Find spawn locations (search more thoroughly)
print("\nSearching for spawn locations...")

local redSpawn = workspace:FindFirstChild("RedSpawnLocation")
if not redSpawn then
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and obj.Name:find("Red") then
			redSpawn = obj
			print("Found Red spawn: " .. obj.Name)
			break
		end
	end
end

local blueSpawn = workspace:FindFirstChild("BlueSpawnLocation")
if not blueSpawn then
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and obj.Name:find("Blue") then
			blueSpawn = obj
			print("Found Blue spawn: " .. obj.Name)
			break
		end
	end
end

-- Use default positions if spawn locations not found (from your spawn location files)
local redSpawnPos = redSpawn and redSpawn.Position or Vector3.new(-160, 10, -40)
local blueSpawnPos = blueSpawn and blueSpawn.Position or Vector3.new(923, 10, 208)

print("Red spawn position: " .. tostring(redSpawnPos))
print("Blue spawn position: " .. tostring(blueSpawnPos))

-- Spawn all bots immediately (no wait)
print("\nSpawning Red team bots...")
for i = 1, 3 do
	local offset = Vector3.new((i - 2) * 5, 0, math.random(-3, 3))
	local bot = createSimpleBot(redSpawnPos + offset, Color3.new(1, 0, 0), "Red")
end

print("Spawning Blue team bots...")
for i = 1, 3 do
	local offset = Vector3.new((i - 2) * 5, 0, math.random(-3, 3))
	local bot = createSimpleBot(blueSpawnPos + offset, Color3.new(0, 0, 1), "Blue")
end

print("\n=== Smart bots spawned! ===")
print("Total bots created: " .. #spawnedBots)
print("Bots will automatically find and chase players using pathfinding.")
print("Check the workspace - you should see " .. #spawnedBots .. " bots!")

