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