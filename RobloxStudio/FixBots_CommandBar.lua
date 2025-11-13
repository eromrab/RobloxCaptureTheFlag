-- FIX BOTS - Command Bar Version
-- Paste this into Roblox Studio Command Bar to fix all existing bots
-- This sets all necessary properties and makes bots move towards enemy spawn

local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

print("=== Fixing All Bots ===")

-- Find spawn locations
local redSpawn = workspace:FindFirstChild("RedSpawnLocation")
local blueSpawn = workspace:FindFirstChild("BlueSpawnLocation")

if not redSpawn then
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and obj.Name:find("Red") then
			redSpawn = obj
			break
		end
	end
end

if not blueSpawn then
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("SpawnLocation") and obj.Name:find("Blue") then
			blueSpawn = obj
			break
		end
	end
end

local redSpawnPos = redSpawn and redSpawn.Position or Vector3.new(-160, 10, -40)
local blueSpawnPos = blueSpawn and blueSpawn.Position or Vector3.new(923, 10, 208)

print("Red spawn: " .. tostring(redSpawnPos))
print("Blue spawn: " .. tostring(blueSpawnPos))

-- Get baseplate Y
local baseplate = workspace:FindFirstChild("Baseplate")
local baseplateY = 0.5
if baseplate and baseplate:IsA("Part") then
	baseplateY = baseplate.Position.Y + (baseplate.Size.Y / 2)
end

-- Find all bots
local botsFixed = 0
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (obj.Name:find("_Bot_") or obj.Name:find("Red_Bot") or obj.Name:find("Blue_Bot")) then
		local rootPart = obj:FindFirstChild("HumanoidRootPart")
		local humanoid = obj:FindFirstChildOfClass("Humanoid")
		
		if rootPart and humanoid then
			-- Determine team and enemy spawn
			local isRed = obj.Name:find("Red")
			local teamName = isRed and "Red" or "Blue"
			local enemySpawnPos = isRed and blueSpawnPos or redSpawnPos
			
			-- Fix all properties
			print("\n🔧 Fixing bot: " .. obj.Name)
			
			-- Fix root part
			rootPart.Anchored = false
			rootPart.CanCollide = true
			rootPart.Size = Vector3.new(2, 2, 1)
			if math.abs(rootPart.Position.Y - baseplateY) > 5 then
				rootPart.Position = Vector3.new(rootPart.Position.X, baseplateY + 2, rootPart.Position.Z)
			end
			
			-- Fix humanoid
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			humanoid.MaxHealth = 100
			if humanoid.Health <= 0 then
				humanoid.Health = 100
			end
			
			-- Wait a frame for Humanoid to detect root part, then activate movement
			spawn(function()
				RunService.Heartbeat:Wait()
				
				if humanoid.RootPart then
					print("  ✓ Humanoid.RootPart detected")
					
					-- Force humanoid to be in walking state
					humanoid:ChangeState(Enum.HumanoidStateType.Walking)
					
					-- Simple movement: directly move towards enemy spawn
					local lastMoveTime = 0
					local moveConnection
					moveConnection = RunService.Heartbeat:Connect(function()
						if not obj.Parent or humanoid.Health <= 0 or not rootPart.Parent then
							moveConnection:Disconnect()
							return
						end
						
						if not humanoid.RootPart then
							return
						end
						
						local currentTime = tick()
						if currentTime - lastMoveTime >= 0.5 then
							lastMoveTime = currentTime
							
							local botPos = rootPart.Position
							-- Keep on baseplate
							if math.abs(botPos.Y - baseplateY) > 5 then
								rootPart.Position = Vector3.new(botPos.X, baseplateY + 2, botPos.Z)
								botPos = rootPart.Position
							end
							
							-- Target position (enemy spawn, on baseplate)
							local targetPos = Vector3.new(enemySpawnPos.X, baseplateY + 2, enemySpawnPos.Z)
							
							-- Calculate distance to target
							local distanceToTarget = (targetPos - botPos).Magnitude
							
							-- If very close, stop moving
							if distanceToTarget < 5 then
								humanoid:MoveTo(botPos) -- Stop
								return
							end
							
							-- Use pathfinding
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
									local waypointPos = waypoints[2].Position
									waypointPos = Vector3.new(waypointPos.X, baseplateY + 2, waypointPos.Z)
									humanoid:MoveTo(waypointPos)
								else
									humanoid:MoveTo(targetPos)
								end
							else
								-- Direct movement if pathfinding fails
								humanoid:MoveTo(targetPos)
							end
						end
					end)
					
					-- Store connection in bot for cleanup
					obj:SetAttribute("MoveConnection", true)
					
					print("  ✓ Movement AI activated - moving towards " .. (isRed and "BLUE" or "RED") .. " spawn")
				else
					warn("  ⚠ Humanoid.RootPart still nil for " .. obj.Name)
					-- Try to force it
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end)
			
			botsFixed = botsFixed + 1
		else
			warn("  ⚠ Bot " .. obj.Name .. " missing HumanoidRootPart or Humanoid")
		end
	end
end

print("\n=== Fixed " .. botsFixed .. " bot(s) ===")
print("Bots should now move towards enemy spawn!")

