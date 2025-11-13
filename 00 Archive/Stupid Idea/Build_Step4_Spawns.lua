-- STEP 4: Create Spawn Locations
-- Run this script fourth to create spawn points
-- Paste this script into Roblox Studio Command Bar (View > Command Bar)

local workspace = game:GetService("Workspace")

print("=== Step 4: Creating Spawn Locations ===")

-- Creating BlueSpawnLocation
do
  local part = Instance.new("SpawnLocation")
  part.Name = "BlueSpawnLocation"
  part.Size = Vector3.new(12, 1, 12)
  part.Position = Vector3.new(922.9545288085938, 5.5, 208)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = true
  part.CanTouch = true
  part.Transparency = 1
  part.Material = Enum.Material.Plastic
  part.Color = Color3.new(0, 0, 1)

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ BlueSpawnLocation")

-- Creating DefaultSpawnLocation
do
  local part = Instance.new("SpawnLocation")
  part.Name = "DefaultSpawnLocation"
  part.Size = Vector3.new(6, 1, 6)
  part.Position = Vector3.new(-601.4244384765625, 45.79393768310547, -20.650909423828125)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = true
  part.CanQuery = true
  part.CanTouch = true
  part.Transparency = 0
  part.Material = Enum.Material.Plastic
  part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ DefaultSpawnLocation")

-- Creating RedSpawnLocation
do
  local part = Instance.new("SpawnLocation")
  part.Name = "RedSpawnLocation"
  part.Size = Vector3.new(12, 1, 12)
  part.Position = Vector3.new(-160.00003051757812, 5.5, -40)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = true
  part.CanTouch = true
  part.Transparency = 1
  part.Material = Enum.Material.Plastic
  part.Color = Color3.new(0.7686274647712708, 0.1568627506494522, 0.10980392247438431)

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ RedSpawnLocation")
