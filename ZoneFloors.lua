-- Creates 5 floor layers for the zone system
-- Baseplate spans from X = -166 to X = 947 (center at 381.5, size 1095)
-- Zone walls:
--   TeamABaseZoneWall: X = 34
--   TeamAMidpointZoneWall: X = 200
--   TeamBMidpointZoneWall: X = 558
--   TeamBBaseZoneWall: X = 729

local function createFloor(name, xMin, xMax, color, material)
	-- Check if floor already exists
	local existingFloor = workspace:FindFirstChild(name)
	if existingFloor then
		print(name .. " already exists, skipping creation")
		return existingFloor
	end
	
	local floor = Instance.new("Part")
	floor.Name = name
	floor.Size = Vector3.new(xMax - xMin, 1, 260) -- 1 stud thick, same Z as baseplate
	floor.Position = Vector3.new((xMin + xMax) / 2, 0.5, 84) -- Slightly above baseplate
	floor.Anchored = true
	floor.CanCollide = false -- Invisible to block placement
	floor.CanQuery = false -- Invisible to queries
	floor.CanTouch = false -- Invisible to touch events
	floor.Transparency = 0.3 -- Slightly transparent so you can see the baseplate
	floor.Material = material or Enum.Material.Plastic
	floor.Color = color
	floor.Parent = workspace
	
	-- Add tag so block placement system can identify and ignore it
	local tag = Instance.new("StringValue")
	tag.Name = "ZonePart"
	tag.Value = "true"
	tag.Parent = floor
	
	print("Created " .. name)
	return floor
end

-- Zone 1: Team A Base (from map edge to TeamABaseZoneWall)
createFloor("TeamABaseFloor", -166, 34, Color3.new(0.2, 0.4, 0.8), Enum.Material.Neon)

-- Zone 2: Team A Zone (from TeamABaseZoneWall to TeamAMidpointZoneWall)
createFloor("TeamAZoneFloor", 34, 200, Color3.new(0.3, 0.5, 0.9), Enum.Material.Neon)

-- Zone 3: Neutral Zone (from TeamAMidpointZoneWall to TeamBMidpointZoneWall)
createFloor("NeutralZoneFloor", 200, 558, Color3.new(1, 0.2, 0.2), Enum.Material.Neon)

-- Zone 4: Team B Zone (from TeamBMidpointZoneWall to TeamBBaseZoneWall)
createFloor("TeamBZoneFloor", 558, 729, Color3.new(0.3, 0.5, 0.9), Enum.Material.Neon)

-- Zone 5: Team B Base (from TeamBBaseZoneWall to map edge)
createFloor("TeamBBaseFloor", 729, 947, Color3.new(0.2, 0.4, 0.8), Enum.Material.Neon)

print("Zone floors check complete!")

