-- Command Bar script to find GunServer and show how to integrate bullet marks
-- Paste this into Roblox Studio Command Bar

print("=== Finding GunServer Script ===")
print("")

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Search for GunServer
local gunServer = ServerScriptService:FindFirstChild("GunServer")
if not gunServer then
	-- Try searching recursively
	for _, obj in ipairs(ServerScriptService:GetDescendants()) do
		if obj.Name:find("Gun") and (obj:IsA("Script") or obj:IsA("ModuleScript")) then
			print("Found potential gun script: " .. obj:GetFullName())
		end
	end
	warn("⚠ GunServer not found in ServerScriptService")
	print("")
	print("💡 To add bullet marks, find where your gun does raycasts and add this code:")
	print("")
	print("   -- When you detect a hit on Target01:")
	print("   local hitPart = raycastResult.Instance")
	print("   if hitPart and hitPart:IsDescendantOf(workspace:FindFirstChild('Target01')) then")
	print("       local ReplicatedStorage = game:GetService('ReplicatedStorage')")
	print("       local targetHit = ReplicatedStorage:FindFirstChild('TargetHitEvent')")
	print("       if targetHit then")
	print("           targetHit:FireServer(hitPart, raycastResult.Position, raycastResult.Normal)")
	print("       end")
	print("   end")
	return
end

print("✓ Found GunServer: " .. gunServer:GetFullName())
print("  Type: " .. gunServer.ClassName)
print("")

-- Show line 225 where the debug message is
if gunServer:IsA("Script") then
	local source = gunServer.Source
	local lines = {}
	for line in source:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	
	if lines[225] then
		print("Line 225 (where 'Raycast hit' debug is):")
		print("  " .. lines[225])
		print("")
		print("💡 Add this code after line 225 to create bullet marks:")
		print("")
		print("   -- Check if hit is on Target01")
		print("   local target = workspace:FindFirstChild('Target01')")
		print("   if target and hitPart:IsDescendantOf(target) then")
		print("       local ReplicatedStorage = game:GetService('ReplicatedStorage')")
		print("       local targetHit = ReplicatedStorage:FindFirstChild('TargetHitEvent')")
		print("       if targetHit then")
		print("           targetHit:FireServer(hitPart, raycastResult.Position, raycastResult.Normal)")
		print("       end")
		print("   end")
	end
end

print("")
print("✓ Integration guide complete!")

