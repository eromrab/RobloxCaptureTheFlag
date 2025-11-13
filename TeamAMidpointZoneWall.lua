-- Creates TeamAMidpointZoneWall if it doesn't already exist
local wallName = "TeamAMidpointZoneWall"
local existingWall = workspace:FindFirstChild(wallName)

if not existingWall then
	local part = Instance.new("Part")
	part.Name = wallName
	part.Size = Vector3.new(0.001, 261, 260)
	-- Aligned to grid boundary (assuming BlockSize = 1)
	-- Position: Adjust this X value to where you want Team A's zone to end
	-- Currently set to X=200, creating a neutral zone from here to TeamBMidpointZoneWall
	part.Position = Vector3.new(200, 70.5, 84)
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false -- Invisible to queries
	part.CanTouch = false -- Invisible to touch events
	part.Transparency = 0.8
	part.Material = Enum.Material.Neon
	part.Color = Color3.new(0.051, 0.412, 0.675) -- Team A blue
	part.Parent = workspace
	
	-- Add tag so block placement system can identify and ignore it
	local tag = Instance.new("StringValue")
	tag.Name = "ZonePart"
	tag.Value = "true"
	tag.Parent = part
	print("Created " .. wallName)
else
	print(wallName .. " already exists, skipping creation")
end

