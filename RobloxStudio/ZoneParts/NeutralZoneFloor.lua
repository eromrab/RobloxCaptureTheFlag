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