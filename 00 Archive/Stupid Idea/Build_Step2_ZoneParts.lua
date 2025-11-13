-- STEP 2: Create Zone Parts
-- Run this script second to create all zone floors and walls
-- Paste this script into Roblox Studio Command Bar (View > Command Bar)

local workspace = game:GetService("Workspace")

print("=== Step 2: Creating Zone Parts ===")

-- Creating NeutralZoneFloor
do
  local part = Instance.new("Part")
  part.Name = "NeutralZoneFloor"
  part.Size = Vector3.new(356, 1, 260)
  part.Position = Vector3.new(378, 0.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 1
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(1, 0.20000000298023224, 0.20000000298023224)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ NeutralZoneFloor")

-- Creating TeamABaseFloor
do
  local part = Instance.new("Part")
  part.Name = "TeamABaseFloor"
  part.Size = Vector3.new(200, 1, 260)
  part.Position = Vector3.new(-68, 18.443359375, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 1
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.20000000298023224, 0.4000000059604645, 0.800000011920929)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamABaseFloor")

-- Creating TeamABaseZoneWall
do
  local part = Instance.new("Part")
  part.Name = "TeamABaseZoneWall"
  part.Size = Vector3.new(0.0010000000474974513, 261, 260)
  part.Position = Vector3.new(32, 70.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 0.75
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.05098039284348488, 0.4117647111415863, 0.6745098233222961)

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamABaseZoneWall")

-- Creating TeamAMidpointZoneWall
do
  local part = Instance.new("Part")
  part.Name = "TeamAMidpointZoneWall"
  part.Size = Vector3.new(0.0010000000474974513, 261, 260)
  part.Position = Vector3.new(200, 70.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 0.75
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.05098039284348488, 0.4117647111415863, 0.6745098233222961)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamAMidpointZoneWall")

-- Creating TeamAZoneFloor
do
  local part = Instance.new("Part")
  part.Name = "TeamAZoneFloor"
  part.Size = Vector3.new(168, 1, 260)
  part.Position = Vector3.new(116, 0.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 1
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.2980392277240753, 0.49803921580314636, 0.8980392217636108)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamAZoneFloor")

-- Creating TeamBBaseFloor
do
  local part = Instance.new("Part")
  part.Name = "TeamBBaseFloor"
  part.Size = Vector3.new(216, 1, 260)
  part.Position = Vector3.new(836, 0.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 1
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.20000000298023224, 0.4000000059604645, 0.800000011920929)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamBBaseFloor")

-- Creating TeamBBaseZoneWall
do
  local part = Instance.new("Part")
  part.Name = "TeamBBaseZoneWall"
  part.Size = Vector3.new(0.0010000000474974513, 261, 260)
  part.Position = Vector3.new(728, 70.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 0.75
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.05098039284348488, 0.4117647111415863, 0.6745098233222961)

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamBBaseZoneWall")

-- Creating TeamBMidpointZoneWall
do
  local part = Instance.new("Part")
  part.Name = "TeamBMidpointZoneWall"
  part.Size = Vector3.new(0.0010000000474974513, 261, 260)
  part.Position = Vector3.new(556, 70.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 0.75
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.05098039284348488, 0.4117647111415863, 0.6745098233222961)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamBMidpointZoneWall")

-- Creating TeamBZoneFloor
do
  local part = Instance.new("Part")
  part.Name = "TeamBZoneFloor"
  part.Size = Vector3.new(172, 1, 260)
  part.Position = Vector3.new(642, 0.5, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false
  part.Transparency = 1
  part.Material = Enum.Material.Neon
  part.Color = Color3.new(0.2980392277240753, 0.49803921580314636, 0.8980392217636108)
  part.TopSurface = Enum.SurfaceType.Studs
  part.BottomSurface = Enum.SurfaceType.Inlet

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ TeamBZoneFloor")
