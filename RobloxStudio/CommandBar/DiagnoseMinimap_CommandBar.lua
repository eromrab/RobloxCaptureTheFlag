-- Command Bar script to diagnose minimap issues
-- Paste this into Roblox Studio Command Bar

print("=== Minimap Diagnostic ===")
print("")

-- Get first player for testing
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players:GetPlayers()[1]

if not player then
	warn("⚠ No player found! Run this in play mode.")
	return
end

print("Checking player: " .. player.Name)
print("")

-- Check PlayerGui
local playerGui = player:FindFirstChild("PlayerGui")
if not playerGui then
	warn("⚠ PlayerGui not found!")
	return
end

print("✓ PlayerGui found")
print("")

-- Check Minimap GUI
local minimapGui = playerGui:FindFirstChild("Minimap")
if not minimapGui then
	warn("⚠ Minimap GUI not found in PlayerGui!")
	print("Available ScreenGuis:")
	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			print("  - " .. gui.Name)
		end
	end
	return
end

print("✓ Minimap GUI found")
print("  Enabled: " .. tostring(minimapGui.Enabled))
print("  DisplayOrder: " .. tostring(minimapGui.DisplayOrder))
print("")

-- Check MinimapFrame
local minimapFrame = minimapGui:FindFirstChild("MinimapFrame")
if not minimapFrame then
	warn("⚠ MinimapFrame not found!")
	return
end

print("✓ MinimapFrame found")
print("  Size: " .. tostring(minimapFrame.Size))
print("  Position: " .. tostring(minimapFrame.Position))
print("  Visible: " .. tostring(minimapFrame.Visible))
print("")

-- Check ViewportFrame
local viewportFrame = minimapFrame:FindFirstChild("ViewportFrame")
if not viewportFrame then
	warn("⚠ ViewportFrame not found!")
	return
end

print("✓ ViewportFrame found")
print("  Size: " .. tostring(viewportFrame.Size))
print("  Position: " .. tostring(viewportFrame.Position))
print("  BackgroundColor3: " .. tostring(viewportFrame.BackgroundColor3))
print("  BackgroundTransparency: " .. tostring(viewportFrame.BackgroundTransparency))
print("")

-- Check Camera
local minimapCamera = viewportFrame.CurrentCamera
if not minimapCamera then
	warn("⚠ MinimapCamera not found!")
	print("  ViewportFrame.CurrentCamera is nil")
	return
end

print("✓ MinimapCamera found")
print("  Name: " .. minimapCamera.Name)
print("  Parent: " .. (minimapCamera.Parent and minimapCamera.Parent.Name or "nil"))
print("  CFrame: " .. tostring(minimapCamera.CFrame))
print("  FieldOfView: " .. tostring(minimapCamera.FieldOfView))
print("")

-- Check if camera is in workspace
if minimapCamera.Parent ~= workspace then
	warn("⚠ Camera is not parented to workspace!")
	print("  Camera should be parented to workspace for ViewportFrame to work")
end

-- Check baseplate
local function findBaseplateRecursive(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("Part") and (obj.Name:lower():find("baseplate") or obj.Name:lower():find("base plate")) then
			return obj
		end
		if obj:IsA("Model") or obj:IsA("Folder") then
			local found = findBaseplateRecursive(obj)
			if found then return found end
		end
	end
	return nil
end

local baseplate = workspace:FindFirstChild("Baseplate")
if not baseplate then
	baseplate = workspace:FindFirstChild("baseplate")
end
if not baseplate then
	baseplate = workspace:FindFirstChild("BasePlate")
end
if not baseplate then
	baseplate = findBaseplateRecursive(workspace)
end

if baseplate then
	print("✓ Baseplate found")
	print("  Name: " .. baseplate.Name)
	print("  Parent: " .. (baseplate.Parent and baseplate.Parent.Name or "nil"))
	print("  Position: " .. tostring(baseplate.Position))
	print("  Size: " .. tostring(baseplate.Size))
	print("")
	
	-- Check camera position relative to baseplate
	local baseplatePos = baseplate.Position
	local cameraPos = minimapCamera.CFrame.Position
	local distance = (cameraPos - Vector3.new(baseplatePos.X, baseplatePos.Y + 600, baseplatePos.Z)).Magnitude
	print("  Camera distance from expected position: " .. string.format("%.2f", distance) .. " studs")
else
	warn("⚠ Baseplate not found!")
end

print("")
print("=== ViewportFrame Rendering Check ===")
print("")
print("ViewportFrame in Roblox requires objects to be explicitly parented to it.")
print("The camera should be in workspace, but the ViewportFrame needs models/parts")
print("cloned and parented to it to render them.")
print("")
print("💡 Solution: We need to clone terrain/workspace objects into the ViewportFrame")
print("   OR use a different approach (like SurfaceGui with BillboardGui)")

