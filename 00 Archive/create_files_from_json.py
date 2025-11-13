import json
import os

# The JSON data from the export
json_data = '''{"count":29,"files":[{"filename":"ZoneParts_NeutralZoneFloor.lua","code":"local part = Instance.new(\\"Part\\")\\npart.Name = \\"NeutralZoneFloor\\"\\npart.Size = Vector3.new(356, 1, 260)\\npart.Position = Vector3.new(378, 0.5, 84)\\npart.Rotation = Vector3.new(0, 0, 0)\\npart.Anchored = true\\npart.CanCollide = false\\npart.CanQuery = false\\npart.CanTouch = false\\npart.Transparency = 1\\npart.Material = Enum.Material.Neon\\npart.Color = Color3.new(1, 0.20000000298023224, 0.20000000298023224)\\npart.TopSurface = Enum.SurfaceType.Studs\\npart.BottomSurface = Enum.SurfaceType.Inlet\\n\\n-- Parent the part\\npart.Parent = workspace"}'''

# This approach won't work well because the JSON is too large and escaped
# Instead, let's create a script that reads from a file

print("Please save the JSON output to a file named 'export.json' and run this script again")
print("Or paste the JSON here and I'll create a file for you")

