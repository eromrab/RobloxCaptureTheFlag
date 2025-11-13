local part = Instance.new("Part")
part.Name = "TeamABaseZoneWall"
part.Size = Vector3.new(0.001, 261, 260)
-- Aligned to grid boundary (assuming BlockSize = 1)
-- If your BlockSize is different, use AlignWallsToGrid.lua to recalculate
part.Position = Vector3.new(34, 70.5, 84)
part.Anchored = true
part.CanCollide = false
part.CanQuery = false -- Invisible to queries
part.CanTouch = false -- Invisible to touch events
part.Transparency = 0.8
part.Material = Enum.Material.Neon
part.Color = Color3.new(0.051, 0.412, 0.675)

-- Parent the part to workspace (or wherever you need it)
part.Parent = workspace

-- Add tag so block placement system can identify and ignore it
local tag = Instance.new("StringValue")
tag.Name = "ZonePart"
tag.Value = "true"
tag.Parent = part

