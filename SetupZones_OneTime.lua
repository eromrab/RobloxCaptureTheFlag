-- ONE-TIME SETUP SCRIPT
-- Run this ONCE in Roblox Studio (via Command Bar or as a script)
-- After running, SAVE YOUR PLACE to make the parts permanent
-- Then you can delete this script

print("=== Creating Zone System ===")

-- Create TeamAMidpointZoneWall
local wallA = workspace:FindFirstChild("TeamAMidpointZoneWall")
if not wallA then
	wallA = Instance.new("Part")
	wallA.Name = "TeamAMidpointZoneWall"
	wallA.Size = Vector3.new(0.001, 261, 260)
	wallA.Position = Vector3.new(200, 70.5, 84)
	wallA.Anchored = true
	wallA.CanCollide = false
	wallA.Transparency = 0.8
	wallA.Material = Enum.Material.Neon
	wallA.Color = Color3.new(0.051, 0.412, 0.675)
	wallA.Parent = workspace
	print("✓ Created TeamAMidpointZoneWall")
else
	print("✓ TeamAMidpointZoneWall already exists")
end

-- Create TeamBMidpointZoneWall
local wallB = workspace:FindFirstChild("TeamBMidpointZoneWall")
if not wallB then
	wallB = Instance.new("Part")
	wallB.Name = "TeamBMidpointZoneWall"
	wallB.Size = Vector3.new(0.001, 261, 260)
	wallB.Position = Vector3.new(558, 70.5, 84)
	wallB.Anchored = true
	wallB.CanCollide = false
	wallB.Transparency = 0.8
	wallB.Material = Enum.Material.Neon
	wallB.Color = Color3.new(0.051, 0.412, 0.675)
	wallB.Parent = workspace
	print("✓ Created TeamBMidpointZoneWall")
else
	print("✓ TeamBMidpointZoneWall already exists")
end

-- Create floors
local function createFloor(name, xMin, xMax, color, material)
	local floor = workspace:FindFirstChild(name)
	if floor then
		print("✓ " .. name .. " already exists")
		return floor
	end
	
	floor = Instance.new("Part")
	floor.Name = name
	floor.Size = Vector3.new(xMax - xMin, 1, 260)
	floor.Position = Vector3.new((xMin + xMax) / 2, 0.5, 84)
	floor.Anchored = true
	floor.CanCollide = true
	floor.Transparency = 0.3
	floor.Material = material
	floor.Color = color
	floor.Parent = workspace
	print("✓ Created " .. name)
	return floor
end

createFloor("TeamABaseFloor", -166, 34, Color3.new(0.2, 0.4, 0.8), Enum.Material.Neon)
createFloor("TeamAZoneFloor", 34, 200, Color3.new(0.3, 0.5, 0.9), Enum.Material.Neon)
createFloor("NeutralZoneFloor", 200, 558, Color3.new(1, 0.2, 0.2), Enum.Material.Neon)
createFloor("TeamBZoneFloor", 558, 729, Color3.new(0.3, 0.5, 0.9), Enum.Material.Neon)
createFloor("TeamBBaseFloor", 729, 947, Color3.new(0.2, 0.4, 0.8), Enum.Material.Neon)

print("=== Setup Complete! ===")
print("IMPORTANT: Now SAVE YOUR PLACE (File > Save or Ctrl+S)")
print("After saving, the parts will be permanent and you can delete this script.")

