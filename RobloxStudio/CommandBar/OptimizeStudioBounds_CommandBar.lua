-- Command Bar script to optimize Roblox Studio bounds and performance
-- This helps reduce load time by adjusting workspace settings
-- Paste this into Roblox Studio Command Bar

print("=== Optimizing Roblox Studio Bounds ===")

local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

-- Find all important areas to determine bounds
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

-- Find all important areas/models
local importantAreas = {}
local allPositions = {}
local allSizes = {}

-- Add baseplate if found
if baseplate then
	table.insert(importantAreas, {name = "Baseplate", obj = baseplate, type = "Part"})
	local baseplatePos = baseplate.Position
	local baseplateSize = baseplate.Size
	table.insert(allPositions, baseplatePos - baseplateSize / 2)
	table.insert(allPositions, baseplatePos + baseplateSize / 2)
	print("  ✓ Found baseplate")
end

-- Find spawn rooms/models
local function findImportantModels(parent, results)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("Model") then
			local nameLower = obj.Name:lower()
			if nameLower:find("spawn") or 
			   nameLower:find("gun") or 
			   nameLower:find("selection") or
			   nameLower:find("room") or
			   nameLower:find("area") then
				table.insert(results, {name = obj.Name, obj = obj, type = "Model"})
				
				-- Calculate model bounds
				local cf, size = obj:GetBoundingBox()
				if cf and size then
					table.insert(allPositions, cf.Position - size / 2)
					table.insert(allPositions, cf.Position + size / 2)
				end
			end
		end
		if obj:IsA("Folder") or obj:IsA("Model") then
			findImportantModels(obj, results)
		end
	end
end

findImportantModels(workspace, importantAreas)

-- Also check for SpawnLocation objects (they might be in folders)
local function findSpawnLocationsForBounds(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("SpawnLocation") then
			table.insert(allPositions, obj.Position)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			findSpawnLocationsForBounds(obj)
		end
	end
end
findSpawnLocationsForBounds(workspace)

-- Calculate overall bounds from all positions
if #allPositions > 0 then
	local minX, minY, minZ = math.huge, math.huge, math.huge
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
	
	for _, pos in ipairs(allPositions) do
		minX = math.min(minX, pos.X)
		minY = math.min(minY, pos.Y)
		minZ = math.min(minZ, pos.Z)
		maxX = math.max(maxX, pos.X)
		maxY = math.max(maxY, pos.Y)
		maxZ = math.max(maxZ, pos.Z)
	end
	
	-- Add margin
	local marginX = (maxX - minX) * 0.2
	local marginZ = (maxZ - minZ) * 0.2
	local marginY = 100
	
	local minBounds = Vector3.new(minX - marginX, minY - marginY, minZ - marginZ)
	local maxBounds = Vector3.new(maxX + marginX, maxY + marginY, maxZ + marginZ)
	local center = (minBounds + maxBounds) / 2
	local size = maxBounds - minBounds
	
	print("")
	print("  ✓ Found " .. #importantAreas .. " important area(s):")
	for _, area in ipairs(importantAreas) do
		print("    - " .. area.name .. " (" .. area.type .. ")")
	end
	
	print("")
	print("  Calculated overall bounds:")
	print("    Center: " .. string.format("%.2f, %.2f, %.2f", center.X, center.Y, center.Z))
	print("    Size: " .. string.format("%.2f x %.2f x %.2f", size.X, size.Y, size.Z))
	print("    Min: " .. string.format("%.2f, %.2f, %.2f", minBounds.X, minBounds.Y, minBounds.Z))
	print("    Max: " .. string.format("%.2f, %.2f, %.2f", maxBounds.X, maxBounds.Y, maxBounds.Z))
	print("")
	
	-- Store for later use
	_G.workspaceBounds = {
		min = minBounds,
		max = maxBounds,
		center = center,
		size = size
	}
else
	warn("  ⚠ No important areas found, using default bounds")
end

-- Optimize Camera settings
if Camera then
	-- Set camera to focus on all important areas
	if _G.workspaceBounds then
		local center = _G.workspaceBounds.center
		local size = _G.workspaceBounds.size
		
		-- Position camera to view all areas
		local maxDim = math.max(size.X, size.Z)
		local cameraDistance = maxDim * 0.8
		local cameraHeight = size.Y * 0.5 + 50
		
		Camera.CFrame = CFrame.new(
			center + Vector3.new(cameraDistance, cameraHeight, cameraDistance),
			center
		)
		print("  ✓ Set camera to focus on all important areas")
		print("    Camera position: " .. tostring(Camera.CFrame.Position))
		print("    Looking at: " .. tostring(center))
	elseif baseplate then
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		Camera.CFrame = CFrame.new(
			baseplatePos + Vector3.new(baseplateSize.X * 0.75, baseplateSize.Y * 2, baseplateSize.Z * 0.75),
			baseplatePos
		)
		print("  ✓ Set camera to focus on baseplate")
	end
	
	-- Adjust camera clipping planes (reduces rendering distance)
	Camera.NearPlaneZ = 0.1
	if _G.workspaceBounds then
		local maxDim = math.max(_G.workspaceBounds.size.X, _G.workspaceBounds.size.Z, _G.workspaceBounds.size.Y)
		Camera.FarPlaneZ = maxDim * 2.5 -- 2.5x the largest dimension
	else
		Camera.FarPlaneZ = 10000
	end
	print("  ✓ Camera NearPlaneZ: " .. Camera.NearPlaneZ)
	print("  ✓ Camera FarPlaneZ: " .. Camera.FarPlaneZ)
end

-- Optimize Workspace settings
print("")
print("  Workspace settings:")
print("    StreamingEnabled: " .. tostring(Workspace.StreamingEnabled))
print("    StreamingTargetRadius: " .. tostring(Workspace.StreamingTargetRadius))

-- If streaming is enabled, optimize it
if Workspace.StreamingEnabled then
	-- Set a reasonable streaming radius around all important areas
	if _G.workspaceBounds then
		local maxDim = math.max(_G.workspaceBounds.size.X, _G.workspaceBounds.size.Z, _G.workspaceBounds.size.Y)
		Workspace.StreamingTargetRadius = maxDim * 1.2 -- 1.2x the largest dimension
		print("  ✓ Set StreamingTargetRadius to: " .. Workspace.StreamingTargetRadius .. " (based on all areas)")
	elseif baseplate then
		local baseplateSize = baseplate.Size
		local maxDimension = math.max(baseplateSize.X, baseplateSize.Z)
		Workspace.StreamingTargetRadius = maxDimension * 1.5 -- 1.5x the largest dimension
		print("  ✓ Set StreamingTargetRadius to: " .. Workspace.StreamingTargetRadius .. " (based on baseplate)")
	else
		Workspace.StreamingTargetRadius = 500 -- Default reasonable radius
		print("  ✓ Set StreamingTargetRadius to default: " .. Workspace.StreamingTargetRadius)
	end
end

-- Additional performance tips
print("")
print("=== Performance Tips ===")
print("  1. Reduce render distance by adjusting Camera.FarPlaneZ")
print("  2. Enable StreamingEnabled to only load nearby objects")
print("  3. Use 'View > Hide' to hide unnecessary objects")
print("  4. Disable 'View > Show Deactivated' to hide disabled parts")
print("  5. Use 'View > Show Collisions' only when needed")
print("  6. Close unused windows/panels")
print("")

print("✅ Studio optimization complete!")
print("💡 For best performance, restart Studio after making major changes")

