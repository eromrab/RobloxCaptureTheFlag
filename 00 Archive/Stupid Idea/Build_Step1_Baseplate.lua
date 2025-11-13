-- STEP 1: Create Baseplate
-- Run this script first to create the baseplate
-- Paste this script into Roblox Studio Command Bar (View > Command Bar)

local workspace = game:GetService("Workspace")

print("=== Step 1: Creating Baseplate ===")

do
  local part = Instance.new("Part")
  part.Name = "Baseplate"
  part.Size = Vector3.new(1095, 16, 260)
  part.Position = Vector3.new(381.4999694824219, -8, 84)
  part.Rotation = Vector3.new(0, 0, 0)
  part.Anchored = true
  part.CanCollide = true
  part.CanQuery = true
  part.CanTouch = true
  part.Transparency = 0
  part.Material = Enum.Material.LeafyGrass
  part.Color = Color3.new(0, 1, 0)

  -- Parent the part
  part.Parent = workspace
end
print("  ✓ Baseplate created")