-- Command Bar script to diagnose Target01 structure
-- Paste this into Roblox Studio Command Bar

print("=== Diagnosing Target01 Structure ===")
print("")

local target = workspace:FindFirstChild("Target01", true) -- true = recursive search

if not target then
	warn("⚠ Target01 not found in workspace!")
	print("Available models in workspace:")
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") then
			print("  - " .. obj.Name)
		end
	end
	return
end

print("✓ Target01 found: " .. target:GetFullName())
print("  Class: " .. target.ClassName)
print("")

-- List all children recursively
print("📋 Target01 structure:")
local function listChildren(parent, indent)
	indent = indent or ""
	for _, child in ipairs(parent:GetChildren()) do
		local typeStr = child.ClassName
		if child:IsA("BasePart") then
			typeStr = typeStr .. " (Size: " .. tostring(child.Size) .. ", Position: " .. tostring(child.Position) .. ")"
			if child:IsA("Part") or child:IsA("MeshPart") then
				typeStr = typeStr .. ", Material: " .. tostring(child.Material) .. ", Color: " .. tostring(child.Color)
			end
		end
		print(indent .. "  - " .. child.Name .. " [" .. typeStr .. "]")
		if child:IsA("Model") or child:IsA("Folder") then
			listChildren(child, indent .. "  ")
		end
	end
end
listChildren(target)
print("")

-- Check for existing decals
print("🔍 Checking for existing decals/textures:")
local decalCount = 0
for _, obj in ipairs(target:GetDescendants()) do
	if obj:IsA("Decal") or obj:IsA("Texture") then
		print("  - " .. obj:GetFullName() .. " (Face: " .. tostring(obj.Face) .. ")")
		decalCount = decalCount + 1
	end
end
if decalCount == 0 then
	print("  No decals found")
end
print("")

print("✓ Diagnosis complete!")

