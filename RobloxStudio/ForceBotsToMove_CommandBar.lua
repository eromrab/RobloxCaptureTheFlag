-- FORCE BOTS TO MOVE - Command Bar Version
-- This script fixes bots and forces them to move using multiple methods

local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

print("=== Forcing Bots to Move ===")

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

-- Get baseplate Y
local baseplate = workspace:FindFirstChild("Baseplate")
local baseplateY = 0.5
if baseplate and baseplate:IsA("Part") then
	baseplateY = baseplate.Position.Y + (baseplate.Size.Y / 2)
end

local botsFixed = 0

for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (obj.Name:find("_Bot_") or obj.Name:find("Red_Bot") or obj.Name:find("Blue_Bot")) then
		local rootPart = obj:FindFirstChild("HumanoidRootPart")
		local humanoid = obj:FindFirstChildOfClass("Humanoid")
		
		if rootPart and humanoid then
			botsFixed = botsFixed + 1
			local isRed = obj.Name:find("Red")
			local enemySpawnPos = isRed and blueSpawnPos or redSpawnPos
			
			print("\n🔧 Fixing: " .. obj.Name)
			
			-- CRITICAL FIXES
			-- 1. Ensure RootPart is NOT anchored
			rootPart.Anchored = false
			rootPart.CanCollide = true
			
			-- 2. Fix Humanoid properties
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			humanoid.MaxHealth = 100
			if humanoid.Health <= 0 then
				humanoid.Health = 100
			end
			
			-- 3. Remove any BodyVelocity/BodyPosition that might interfere
			for _, child in ipairs(rootPart:GetChildren()) do
				if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyAngularVelocity") then
					child:Destroy()
				end
			end
			
			-- 4. Wait for Humanoid to detect RootPart, then force movement
			spawn(function()
				-- Wait multiple frames to ensure Humanoid detects RootPart
				for i = 1, 3 do
					RunService.Heartbeat:Wait()
				end
				
				-- Force Humanoid to detect RootPart by changing state
				if not humanoid.RootPart then
					print("  ⚠ RootPart not detected, trying to force...")
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					wait(0.1)
					humanoid:ChangeState(Enum.HumanoidStateType.Walking)
				end
				
				-- Wait one more frame
				RunService.Heartbeat:Wait()
				
				if humanoid.RootPart then
					print("  ✓ RootPart detected: " .. tostring(humanoid.RootPart))
					
					-- Force walking state
					humanoid:ChangeState(Enum.HumanoidStateType.Walking)
					
					-- Movement AI with direct MoveTo calls
					local lastMoveTime = 0
					local moveConnection
					moveConnection = RunService.Heartbeat:Connect(function()
						if not obj.Parent or humanoid.Health <= 0 or not rootPart.Parent then
							if moveConnection then
								moveConnection:Disconnect()
							end
							return
						end
						
						if not humanoid.RootPart then
							return
						end
						
						local currentTime = tick()
						if currentTime - lastMoveTime >= 0.3 then -- Update more frequently
							lastMoveTime = currentTime
							
							local botPos = rootPart.Position
							
							-- Keep on baseplate
							if math.abs(botPos.Y - baseplateY) > 5 then
								rootPart.Position = Vector3.new(botPos.X, baseplateY + 2, botPos.Z)
								botPos = rootPart.Position
							end
							
							-- Target position
							local targetPos = Vector3.new(enemySpawnPos.X, baseplateY + 2, enemySpawnPos.Z)
							local distance = (targetPos - botPos).Magnitude
							
							if distance < 5 then
								-- Close enough, stop
								humanoid:MoveTo(botPos)
								return
							end
							
							-- Try pathfinding first
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
									-- CRITICAL: Use MoveTo with the waypoint
									humanoid:MoveTo(waypointPos)
								else
									humanoid:MoveTo(targetPos)
								end
							else
								-- Fallback: Direct movement
								humanoid:MoveTo(targetPos)
							end
							
							-- Force walking state every update
							if humanoid:GetState() ~= Enum.HumanoidStateType.Walking then
								humanoid:ChangeState(Enum.HumanoidStateType.Walking)
							end
						end
					end)
					
					print("  ✓ Movement AI activated")
				else
					warn("  ❌ RootPart still not detected after waiting!")
					-- Last resort: try recreating the Humanoid
					print("  🔄 Attempting to fix Humanoid...")
					local newHumanoid = humanoid:Clone()
					humanoid:Destroy()
					newHumanoid.Parent = obj
					wait(0.2)
					if newHumanoid.RootPart then
						print("  ✓ Fixed! RootPart now detected")
					else
						warn("  ❌ Still not working. Bot may need to be recreated.")
					end
				end
			end)
		end
	end
end

print("\n=== Fixed " .. botsFixed .. " bot(s) ===")
print("Bots should start moving in 1-2 seconds...")

