-- DIAGNOSE BOTS - Command Bar Version
-- Paste this to check why bots aren't moving

print("=== Diagnosing Bots ===")

local botCount = 0
local issuesFound = 0

for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (obj.Name:find("_Bot_") or obj.Name:find("Red_Bot") or obj.Name:find("Blue_Bot")) then
		botCount = botCount + 1
		local rootPart = obj:FindFirstChild("HumanoidRootPart")
		local humanoid = obj:FindFirstChildOfClass("Humanoid")
		
		print("\n--- Bot: " .. obj.Name .. " ---")
		
		if not rootPart then
			print("  ❌ Missing HumanoidRootPart")
			issuesFound = issuesFound + 1
		else
			print("  ✓ HumanoidRootPart found")
			print("    - Anchored: " .. tostring(rootPart.Anchored))
			print("    - CanCollide: " .. tostring(rootPart.CanCollide))
			print("    - Position: " .. tostring(rootPart.Position))
			if rootPart.Anchored then
				print("    ⚠ PROBLEM: RootPart is anchored! Bots can't move if anchored.")
				issuesFound = issuesFound + 1
			end
		end
		
		if not humanoid then
			print("  ❌ Missing Humanoid")
			issuesFound = issuesFound + 1
		else
			print("  ✓ Humanoid found")
			print("    - WalkSpeed: " .. tostring(humanoid.WalkSpeed))
			print("    - Health: " .. tostring(humanoid.Health) .. "/" .. tostring(humanoid.MaxHealth))
			print("    - State: " .. tostring(humanoid:GetState()))
			print("    - RootPart: " .. tostring(humanoid.RootPart))
			
			if not humanoid.RootPart then
				print("    ⚠ PROBLEM: Humanoid.RootPart is nil! Humanoid can't move without RootPart.")
				issuesFound = issuesFound + 1
			end
			
			if humanoid.WalkSpeed == 0 then
				print("    ⚠ PROBLEM: WalkSpeed is 0! Bot can't move.")
				issuesFound = issuesFound + 1
			end
			
			if humanoid.Health <= 0 then
				print("    ⚠ PROBLEM: Bot is dead (Health <= 0)! Bot can't move when dead.")
				issuesFound = issuesFound + 1
			end
		end
		
		-- Check for BodyVelocity or other constraints that might interfere
		for _, child in ipairs(rootPart:GetChildren()) do
			if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyAngularVelocity") then
				print("  ⚠ Found " .. child.ClassName .. " on RootPart - this might interfere with movement")
			end
		end
	end
end

print("\n=== Summary ===")
print("Total bots found: " .. botCount)
print("Issues found: " .. issuesFound)

if issuesFound == 0 then
	print("✓ No obvious issues found. Bots should be able to move.")
	print("  If they're still not moving, the issue might be with the movement AI code.")
else
	print("⚠ Found " .. issuesFound .. " issue(s) that need to be fixed.")
end

