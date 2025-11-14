-- MINIMAP CREATION SCRIPT
-- Place this in StarterGui (as a LocalScript)
-- Creates a minimap in the upper left corner and hides default Roblox UI elements

print("=== Creating Minimap ===")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hide default Roblox UI elements in the upper left
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) -- Hide chat (typically upper left)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) -- Hide player list (can overlap)

print("  ✓ Hidden default Roblox UI elements (Chat, PlayerList)")

-- Function to find walls and calculate map boundaries (with recursive search and wait)
local function findWallsAndCalculateBounds(waitTime)
	waitTime = waitTime or 0
	
	-- Wait a bit for walls to be created
	if waitTime > 0 then
		task.wait(waitTime)
	end
	
	-- Try to find Walls folder (recursive search)
	local function findWallsFolder(parent)
		for _, obj in ipairs(parent:GetChildren()) do
			if obj.Name == "Walls" and (obj:IsA("Folder") or obj:IsA("Model")) then
				return obj
			end
			if obj:IsA("Model") or obj:IsA("Folder") then
				local found = findWallsFolder(obj)
				if found then return found end
			end
		end
		return nil
	end
	
	local wallsFolder = workspace:FindFirstChild("Walls")
	if not wallsFolder then
		wallsFolder = findWallsFolder(workspace)
	end
	
	print("  🔧 Wall search diagnostics:")
	print("    Walls folder found: " .. tostring(wallsFolder))
	if wallsFolder then
		print("    Walls folder type: " .. wallsFolder.ClassName)
		print("    Walls folder children count: " .. tostring(#wallsFolder:GetChildren()))
		for _, child in ipairs(wallsFolder:GetChildren()) do
			print("      - " .. child.Name .. " (" .. child.ClassName .. ")")
			-- If it's a Model, list all its children too
			if child:IsA("Model") then
				print("        Model children:")
				for _, subChild in ipairs(child:GetChildren()) do
					if subChild:IsA("Part") then
						print("          - " .. subChild.Name .. " (Part) at Position: " .. tostring(subChild.Position))
					else
						print("          - " .. subChild.Name .. " (" .. subChild.ClassName .. ")")
					end
				end
			end
		end
	end
	
	-- Also search workspace directly for any part with "east" in the name (case-insensitive)
	print("  🔍 Searching workspace directly for parts with 'east' in name...")
	local function searchWorkspaceForEast(parent, depth)
		depth = depth or 0
		if depth > 5 then return end -- Limit depth to avoid infinite recursion
		for _, obj in ipairs(parent:GetChildren()) do
			if obj:IsA("Part") and obj.Name:lower():find("east") then
				print("    ✓ Found part with 'east' in name: " .. obj.Name .. " at " .. obj:GetFullName() .. " (Position: " .. tostring(obj.Position) .. ")")
			end
			if obj:IsA("Model") or obj:IsA("Folder") then
				searchWorkspaceForEast(obj, depth + 1)
			end
		end
	end
	searchWorkspaceForEast(workspace)
	
	if not wallsFolder then
		warn("  ⚠ Walls folder not found in workspace")
		return nil, nil, nil, nil
	end
	
	-- Try to find walls (with recursive search)
	local function findWallRecursive(parent, wallName, depth)
		depth = depth or 0
		local indent = string.rep("  ", depth)
		print(indent .. "🔍 Searching for " .. wallName .. " in " .. parent.Name .. " (" .. parent.ClassName .. ")")
		
		-- Also check if the parent itself matches (in case we're searching in the wrong place)
		if parent:IsA("Part") and parent.Name == wallName then
			print(indent .. "  ✓ Found " .. wallName .. " (parent itself) at " .. parent:GetFullName())
			return parent
		end
		
		for _, obj in ipairs(parent:GetChildren()) do
			print(indent .. "  Checking: " .. obj.Name .. " (" .. obj.ClassName .. ")")
			-- Check for exact match
			if obj:IsA("Part") and obj.Name == wallName then
				print(indent .. "  ✓ Found " .. wallName .. " at " .. obj:GetFullName())
				return obj
			end
			-- Check for case-insensitive match (in case of naming issues)
			if obj:IsA("Part") and obj.Name:lower() == wallName:lower() then
				print(indent .. "  ✓ Found " .. wallName .. " (case-insensitive match) at " .. obj:GetFullName())
				return obj
			end
			-- Check if name contains the wall name (e.g., "EastWallPart" contains "EastWall")
			if obj:IsA("Part") and obj.Name:find(wallName, 1, true) then
				print(indent .. "  ✓ Found " .. wallName .. " (partial match: " .. obj.Name .. ") at " .. obj:GetFullName())
				return obj
			end
			if obj:IsA("Model") or obj:IsA("Folder") then
				local found = findWallRecursive(obj, wallName, depth + 1)
				if found then return found end
			end
		end
		return nil
	end
	
	print("  🔍 Looking for EastWall...")
	local eastWall = wallsFolder:FindFirstChild("EastWall")
	if not eastWall then
		eastWall = findWallRecursive(wallsFolder, "EastWall")
	end
	print("    EastWall found: " .. tostring(eastWall))
	if eastWall then print("      Path: " .. eastWall:GetFullName()) end
	
	print("  🔍 Looking for WestWall...")
	local westWall = wallsFolder:FindFirstChild("WestWall")
	if not westWall then
		westWall = findWallRecursive(wallsFolder, "WestWall")
	end
	print("    WestWall found: " .. tostring(westWall))
	if westWall then print("      Path: " .. westWall:GetFullName()) end
	
	print("  🔍 Looking for NorthWall...")
	local northWall = wallsFolder:FindFirstChild("NorthWall")
	if not northWall then
		northWall = findWallRecursive(wallsFolder, "NorthWall")
	end
	print("    NorthWall found: " .. tostring(northWall))
	if northWall then print("      Path: " .. northWall:GetFullName()) end
	
	print("  🔍 Looking for SouthWall...")
	local southWall = wallsFolder:FindFirstChild("SouthWall")
	if not southWall then
		southWall = findWallRecursive(wallsFolder, "SouthWall")
	end
	print("    SouthWall found: " .. tostring(southWall))
	if southWall then print("      Path: " .. southWall:GetFullName()) end
	
	if not eastWall or not westWall or not northWall or not southWall then
		warn("  ⚠ Not all walls found! East: " .. tostring(eastWall) .. ", West: " .. tostring(westWall) .. ", North: " .. tostring(northWall) .. ", South: " .. tostring(southWall))
		return nil, nil, nil, nil
	end
	
	-- Calculate inner boundaries (edges facing the map interior)
	-- East wall: inner edge is at Position.X - (Size.X / 2)
	-- West wall: inner edge is at Position.X + (Size.X / 2)
	-- North wall: inner edge is at Position.Z - (Size.Z / 2)
	-- South wall: inner edge is at Position.Z + (Size.Z / 2)
	
	local mapMinX = westWall.Position.X + (westWall.Size.X / 2)
	local mapMaxX = eastWall.Position.X - (eastWall.Size.X / 2)
	local mapMinZ = southWall.Position.Z + (southWall.Size.Z / 2)
	local mapMaxZ = northWall.Position.Z - (northWall.Size.Z / 2)
	
	return mapMinX, mapMaxX, mapMinZ, mapMaxZ
end

-- Function to find baseplate recursively
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

-- Function to create/update minimap terrain representation
-- This creates a mini version of the actual terrain
local function createMinimapTerrain(viewportFrame, terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ, baseplateTop)
	print("  🔧 createMinimapTerrain called with:")
	print("    viewportFrame: " .. tostring(viewportFrame))
	print("    terrainMinX: " .. tostring(terrainMinX))
	print("    terrainMaxX: " .. tostring(terrainMaxX))
	print("    terrainMinZ: " .. tostring(terrainMinZ))
	print("    terrainMaxZ: " .. tostring(terrainMaxZ))
	print("    baseplateTop: " .. tostring(baseplateTop))
	
	if not viewportFrame then
		warn("  ⚠ createMinimapTerrain: viewportFrame is nil!")
		return nil
	end
	
	-- Remove existing terrain model if it exists
	local existingModel = viewportFrame:FindFirstChild("MinimapModel")
	if existingModel then
		print("  🔧 Removing existing MinimapModel")
		existingModel:Destroy()
	end
	
	-- Create a model container for minimap objects
	local minimapModel = Instance.new("Model")
	minimapModel.Name = "MinimapModel"
	minimapModel.Parent = viewportFrame
	print("  🔧 Created MinimapModel and parented to viewportFrame")
	
	-- Terrain sampling parameters (lower resolution for minimap performance)
	local SAMPLE_RESOLUTION = 20 -- Sample every 20 studs (lower = more detailed but slower)
	
	-- Sample terrain heights
	local terrainHeights = {}
	local sampleCount = 0
	
	print("  📊 Sampling terrain for minimap...")
	
	for z = terrainMinZ, terrainMaxZ, SAMPLE_RESOLUTION do
		terrainHeights[z] = {}
		for x = terrainMinX, terrainMaxX, SAMPLE_RESOLUTION do
			-- Raycast down from high above to find terrain surface
			local rayOrigin = Vector3.new(x, baseplateTop + 200, z)
			local rayDirection = Vector3.new(0, -500, 0)
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			raycastParams.FilterDescendantsInstances = {} -- Don't filter anything, we want terrain
			
			local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
			
			if raycastResult then
				local hitY = raycastResult.Position.Y
				-- Only accept terrain hits (not too high, not too low)
				if hitY > baseplateTop - 10 and hitY < baseplateTop + 100 then
					terrainHeights[z][x] = hitY
				else
					terrainHeights[z][x] = baseplateTop + 10 -- Default height
				end
			else
				terrainHeights[z][x] = baseplateTop + 10 -- Default height if no hit
			end
			sampleCount = sampleCount + 1
		end
	end
	
	print("    ✓ Sampled " .. sampleCount .. " terrain points")
	
	-- Create terrain mesh using parts (simplified but visible)
	-- Create a grid of parts representing the terrain
	local terrainParts = {}
	local partCount = 0
	
	for z = terrainMinZ, terrainMaxZ - SAMPLE_RESOLUTION, SAMPLE_RESOLUTION do
		for x = terrainMinX, terrainMaxX - SAMPLE_RESOLUTION, SAMPLE_RESOLUTION do
			-- Get heights for this quad
			local h1 = terrainHeights[z] and terrainHeights[z][x] or (baseplateTop + 10)
			local h2 = terrainHeights[z] and terrainHeights[z][x + SAMPLE_RESOLUTION] or (baseplateTop + 10)
			local h3 = terrainHeights[z + SAMPLE_RESOLUTION] and terrainHeights[z + SAMPLE_RESOLUTION][x] or (baseplateTop + 10)
			local h4 = terrainHeights[z + SAMPLE_RESOLUTION] and terrainHeights[z + SAMPLE_RESOLUTION][x + SAMPLE_RESOLUTION] or (baseplateTop + 10)
			
			-- Average height for this quad
			local avgHeight = (h1 + h2 + h3 + h4) / 4
			
			-- Create a part for this terrain cell
			local terrainPart = Instance.new("Part")
			terrainPart.Name = "MinimapTerrain_" .. partCount
			terrainPart.Size = Vector3.new(SAMPLE_RESOLUTION, 2, SAMPLE_RESOLUTION)
			terrainPart.Position = Vector3.new(x + (SAMPLE_RESOLUTION / 2), avgHeight, z + (SAMPLE_RESOLUTION / 2))
			terrainPart.Material = Enum.Material.Grass
			terrainPart.BrickColor = BrickColor.new("Bright green")
			terrainPart.Anchored = true
			terrainPart.CanCollide = false
			terrainPart.Transparency = 0
			terrainPart.Parent = minimapModel
			
			table.insert(terrainParts, terrainPart)
			partCount = partCount + 1
		end
	end
	
	print("  ✓ Created " .. partCount .. " terrain parts for minimap")
	return minimapModel
end

-- Create the minimap GUI
local function createMinimap()
	print("  🔧 createMinimap() called")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Minimap"
	screenGui.ResetOnSpawn = false -- Keep minimap when player respawns
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- Wait a bit for walls to be created, then find walls to calculate aspect ratio
	task.wait(1) -- Give time for walls to be created
	local mapMinX, mapMaxX, mapMinZ, mapMaxZ = findWallsAndCalculateBounds(0)
	
	-- Calculate map dimensions and aspect ratio
	local mapWidth = 0
	local mapDepth = 0
	local aspectRatio = 1 -- Default to square
	
	if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
		mapWidth = mapMaxX - mapMinX
		mapDepth = mapMaxZ - mapMinZ
		if mapDepth > 0 then
			aspectRatio = mapWidth / mapDepth
		end
		print("  ✓ Found walls - Map bounds: X[" .. string.format("%.1f", mapMinX) .. " to " .. string.format("%.1f", mapMaxX) .. "], Z[" .. string.format("%.1f", mapMinZ) .. " to " .. string.format("%.1f", mapMaxZ) .. "]")
		print("    Map dimensions: " .. string.format("%.1f", mapWidth) .. " x " .. string.format("%.1f", mapDepth) .. " (aspect ratio: " .. string.format("%.2f", aspectRatio) .. ")")
	else
		warn("  ⚠ Walls not found, using default square minimap")
	end
	
	-- Calculate minimap size based on aspect ratio
	-- Base size: 200 pixels (for the smaller dimension)
	-- Larger dimension scales based on aspect ratio
	local baseSize = 200
	local minimapWidth = baseSize
	local minimapHeight = baseSize
	
	if aspectRatio > 1 then
		-- Map is wider than tall
		minimapWidth = baseSize * aspectRatio
	else
		-- Map is taller than wide
		minimapHeight = baseSize / aspectRatio
	end
	
	-- Main minimap container (upper left corner)
	local minimapFrame = Instance.new("Frame")
	minimapFrame.Name = "MinimapFrame"
	minimapFrame.Size = UDim2.new(0, minimapWidth, 0, minimapHeight + 25) -- Height includes title
	minimapFrame.Position = UDim2.new(0, 10, 0, 10) -- 10 pixels from top-left
	minimapFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- Dark background
	minimapFrame.BorderSizePixel = 2
	minimapFrame.BorderColor3 = Color3.new(1, 1, 1) -- White border
	minimapFrame.BackgroundTransparency = 0.2 -- Slightly transparent
	minimapFrame.Parent = screenGui
	
	-- Corner radius (rounded corners)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = minimapFrame
	
	-- Minimap title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, 0, 0, 25)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = "MINIMAP"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = minimapFrame
	
	-- Title corner radius
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 8)
	titleCorner.Parent = titleLabel
	
	-- Minimap viewport (where the map will be displayed)
	local viewportFrame = Instance.new("ViewportFrame")
	viewportFrame.Name = "ViewportFrame"
	viewportFrame.Size = UDim2.new(1, 0, 1, -25) -- Full width, height minus title
	viewportFrame.Position = UDim2.new(0, 0, 0, 25) -- Below title
	viewportFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	viewportFrame.BorderSizePixel = 0
	viewportFrame.Parent = minimapFrame
	
	-- Create a camera for the minimap (top-down view)
	local minimapCamera = Instance.new("Camera")
	minimapCamera.Name = "MinimapCamera"
	print("  🔧 Created MinimapCamera")
	
	-- Find the baseplate to position the camera above it (using the function defined above)
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
	
	-- Calculate camera position and FOV based on wall boundaries
	local cameraCenterX = 0
	local cameraCenterZ = 0
	local cameraHeight = 600
	local cameraFOV = 100
	
	if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
		-- Center camera on the map area (within walls)
		cameraCenterX = (mapMinX + mapMaxX) / 2
		cameraCenterZ = (mapMinZ + mapMaxZ) / 2
		
		-- Calculate camera height and FOV to exactly fit the map area
		-- For top-down view, we need both width and depth to fit
		-- The viewport aspect ratio determines which dimension is limiting
		local viewportAspectRatio = aspectRatio
		if viewportAspectRatio <= 0 then
			viewportAspectRatio = 1
		end
		
		-- Calculate the effective dimension based on viewport aspect ratio
		-- If viewport is wider, width is the limiting factor
		-- If viewport is taller, depth is the limiting factor
		local effectiveDimension
		if viewportAspectRatio > 1 then
			-- Viewport is wider - width must fit exactly
			effectiveDimension = mapWidth
		else
			-- Viewport is taller - depth must fit exactly
			effectiveDimension = mapDepth
		end
		
		-- Calculate camera height to zoom in and fill viewport
		-- Use a higher target FOV to zoom in more aggressively
		-- Higher FOV = lower camera height = more zoomed in
		local targetFOV = 100 -- Target FOV in degrees (zoomed in)
		cameraHeight = (effectiveDimension / 2) / math.tan(math.rad(targetFOV / 2))
		
		-- Ensure minimum height for visibility (lowered for more zoom)
		cameraHeight = math.max(cameraHeight, 100)
		
		-- Calculate FOV needed for both dimensions at this height
		local fovForWidth = math.deg(2 * math.atan(mapWidth / (2 * cameraHeight)))
		local fovForDepth = math.deg(2 * math.atan(mapDepth / (2 * cameraHeight)))
		
		-- Use the larger FOV to ensure both dimensions are visible
		-- This ensures the map fills the viewport
		cameraFOV = math.max(fovForWidth, fovForDepth)
		
		-- Add a small margin (5%) to ensure edges are visible, but keep it tight
		cameraFOV = cameraFOV * 1.05
		
		-- Clamp FOV to reasonable range (allow up to 120 for zoom)
		cameraFOV = math.clamp(cameraFOV, 50, 120)
		
		minimapCamera.CFrame = CFrame.new(
			cameraCenterX,
			cameraHeight,
			cameraCenterZ
		) * CFrame.Angles(math.rad(-90), 0, 0) -- Look straight down
		
		minimapCamera.FieldOfView = cameraFOV
		
		print("  ✓ Positioned minimap camera above map center")
		print("    Camera center: (" .. string.format("%.1f", cameraCenterX) .. ", " .. string.format("%.1f", cameraCenterZ) .. ")")
		print("    Camera height: " .. string.format("%.1f", cameraHeight) .. " studs")
		print("    Camera FOV: " .. string.format("%.1f", cameraFOV) .. " degrees (width FOV: " .. string.format("%.1f", fovForWidth) .. ", depth FOV: " .. string.format("%.1f", fovForDepth) .. ")")
	elseif baseplate then
		-- Fallback to baseplate if walls not found
		local baseplatePos = baseplate.Position
		cameraCenterX = baseplatePos.X
		cameraCenterZ = baseplatePos.Z
		minimapCamera.CFrame = CFrame.new(
			cameraCenterX,
			cameraHeight,
			cameraCenterZ
		) * CFrame.Angles(math.rad(-90), 0, 0)
		minimapCamera.FieldOfView = cameraFOV
		print("  ✓ Positioned minimap camera above baseplate center (walls not found)")
	else
		-- Default camera position if nothing found
		minimapCamera.CFrame = CFrame.new(0, cameraHeight, 0) * CFrame.Angles(math.rad(-90), 0, 0)
		minimapCamera.FieldOfView = cameraFOV
		warn("  ⚠ Baseplate and walls not found, using default camera position")
	end
	
	-- Wait for terrain to be generated
	task.wait(2)
	
	-- Re-find walls after wait (they might be created after minimap starts)
	if not mapMinX or not mapMaxX or not mapMinZ or not mapMaxZ then
		mapMinX, mapMaxX, mapMinZ, mapMaxZ = findWallsAndCalculateBounds(0)
		if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
			mapWidth = mapMaxX - mapMinX
			mapDepth = mapMaxZ - mapMinZ
			if mapDepth > 0 then
				aspectRatio = mapWidth / mapDepth
			end
			print("  ✓ Found walls after wait - Map bounds: X[" .. string.format("%.1f", mapMinX) .. " to " .. string.format("%.1f", mapMaxX) .. "], Z[" .. string.format("%.1f", mapMinZ) .. " to " .. string.format("%.1f", mapMaxZ) .. "]")
			
			-- Update camera position and FOV now that we have walls
			local cameraCenterX = (mapMinX + mapMaxX) / 2
			local cameraCenterZ = (mapMinZ + mapMaxZ) / 2
			
			local viewportAspectRatio = aspectRatio
			if viewportAspectRatio <= 0 then
				viewportAspectRatio = 1
			end
			
			local effectiveDimension
			if viewportAspectRatio > 1 then
				effectiveDimension = mapWidth
			else
				effectiveDimension = mapDepth
			end
			
			local targetFOV = 100
			local newCameraHeight = (effectiveDimension / 2) / math.tan(math.rad(targetFOV / 2))
			newCameraHeight = math.max(newCameraHeight, 100)
			
			local fovForWidth = math.deg(2 * math.atan(mapWidth / (2 * newCameraHeight)))
			local fovForDepth = math.deg(2 * math.atan(mapDepth / (2 * newCameraHeight)))
			local newCameraFOV = math.max(fovForWidth, fovForDepth) * 1.05
			newCameraFOV = math.clamp(newCameraFOV, 50, 120)
			
			minimapCamera.CFrame = CFrame.new(
				cameraCenterX,
				newCameraHeight,
				cameraCenterZ
			) * CFrame.Angles(math.rad(-90), 0, 0)
			minimapCamera.FieldOfView = newCameraFOV
			
			print("  ✓ Updated camera position and FOV based on walls")
			print("    Camera height: " .. string.format("%.1f", newCameraHeight) .. " studs")
			print("    Camera FOV: " .. string.format("%.1f", newCameraFOV) .. " degrees")
		end
	end
	
	-- Re-find baseplate after wait (terrain generation might have happened)
	if not baseplate then
		baseplate = workspace:FindFirstChild("Baseplate")
		if not baseplate then
			baseplate = workspace:FindFirstChild("baseplate")
		end
		if not baseplate then
			baseplate = workspace:FindFirstChild("BasePlate")
		end
		if not baseplate then
			baseplate = findBaseplateRecursive(workspace)
		end
	end
	
	-- Sample actual terrain and create detailed representation
	-- Use wall boundaries if available, otherwise fall back to baseplate
	local terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ
	
	if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
		-- Use wall boundaries (the area inside the walls)
		terrainMinX = mapMinX
		terrainMaxX = mapMaxX
		terrainMinZ = mapMinZ
		terrainMaxZ = mapMaxZ
		print("  ✓ Using wall boundaries for terrain sampling")
	elseif baseplate then
		-- Fallback to baseplate with margin
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		local WALL_MARGIN = 8
		terrainMinX = baseplatePos.X - (baseplateSize.X / 2) + WALL_MARGIN
		terrainMaxX = baseplatePos.X + (baseplateSize.X / 2) - WALL_MARGIN
		terrainMinZ = baseplatePos.Z - (baseplateSize.Z / 2) + WALL_MARGIN
		terrainMaxZ = baseplatePos.Z + (baseplateSize.Z / 2) - WALL_MARGIN
		print("  ⚠ Using baseplate boundaries (walls not found)")
	else
		warn("  ⚠ Cannot create terrain - no baseplate or walls found")
		return screenGui, minimapCamera
	end
	
	if terrainMinX and terrainMaxX and terrainMinZ and terrainMaxZ then
		-- Get baseplate for height reference
		local baseplateTop = 10 -- Default height
		if baseplate then
			local baseplatePos = baseplate.Position
			local baseplateSize = baseplate.Size
			baseplateTop = baseplatePos.Y + (baseplateSize.Y / 2)
		end
		
		-- Create minimap terrain using the reusable function
		createMinimapTerrain(viewportFrame, terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ, baseplateTop)
	end
	
	-- Assign camera to viewport
	viewportFrame.CurrentCamera = minimapCamera
	minimapCamera.Parent = workspace
	
	-- Set ViewportFrame properties for better rendering
	viewportFrame.LightDirection = Vector3.new(0, -1, 0) -- Light from above
	viewportFrame.Ambient = Color3.new(0.7, 0.7, 0.7) -- Bright ambient light for visibility
	viewportFrame.LightColor = Color3.new(1, 1, 1) -- White light
	
	-- Wait a moment for setup
	task.wait(0.1)
	
	-- Verify camera is set correctly
	if viewportFrame.CurrentCamera == minimapCamera then
		print("  ✓ ViewportFrame camera configured")
	else
		warn("  ⚠ ViewportFrame camera not set correctly!")
	end
	
	-- Container for all player indicators (overlay on top of viewport)
	-- IMPORTANT: This must be a sibling of viewportFrame, not a child, so it overlays correctly
	local indicatorsContainer = Instance.new("Frame")
	indicatorsContainer.Name = "IndicatorsContainer"
	indicatorsContainer.Size = UDim2.new(1, 0, 1, -25) -- Full width, height minus title (matches viewportFrame)
	indicatorsContainer.Position = UDim2.new(0, 0, 0, 25) -- Below title (matches viewportFrame)
	indicatorsContainer.BackgroundTransparency = 1
	indicatorsContainer.ZIndex = 10 -- Higher than viewportFrame to appear on top
	indicatorsContainer.Parent = minimapFrame -- Parent to minimapFrame, not viewportFrame!
	print("  🔧 Created IndicatorsContainer and parented to minimapFrame")
	print("    IndicatorsContainer Parent: " .. tostring(indicatorsContainer.Parent))
	print("    IndicatorsContainer Name: " .. indicatorsContainer.Name)
	
	-- Player indicator (will be updated by LocalScript)
	local playerIndicator = Instance.new("Frame")
	playerIndicator.Name = "PlayerIndicator"
	playerIndicator.Size = UDim2.new(0, 8, 0, 8)
	playerIndicator.Position = UDim2.new(0.5, -4, 0.5, -4) -- Center
	playerIndicator.BackgroundColor3 = Color3.new(1, 0, 0) -- Red dot for player
	playerIndicator.BorderSizePixel = 1
	playerIndicator.BorderColor3 = Color3.new(1, 1, 1) -- White border
	playerIndicator.ZIndex = 11
	playerIndicator.Parent = indicatorsContainer
	
	-- Player indicator corner (make it circular)
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0, 4)
	indicatorCorner.Parent = playerIndicator
	
	-- Zoom buttons container (top right of minimap)
	local zoomContainer = Instance.new("Frame")
	zoomContainer.Name = "ZoomContainer"
	zoomContainer.Size = UDim2.new(0, 50, 0, 60)
	zoomContainer.Position = UDim2.new(1, -55, 0, 0) -- Top right, below title
	zoomContainer.BackgroundTransparency = 1
	zoomContainer.Parent = minimapFrame
	print("  🔧 Created ZoomContainer and parented to minimapFrame")
	print("    ZoomContainer Parent: " .. tostring(zoomContainer.Parent))
	print("    ZoomContainer Name: " .. zoomContainer.Name)
	
	-- Zoom in button (+)
	local zoomInButton = Instance.new("TextButton")
	zoomInButton.Name = "ZoomInButton"
	zoomInButton.Size = UDim2.new(0, 25, 0, 25)
	zoomInButton.Position = UDim2.new(0, 0, 0, 0)
	zoomInButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	zoomInButton.BorderSizePixel = 1
	zoomInButton.BorderColor3 = Color3.new(1, 1, 1)
	zoomInButton.Text = "+"
	zoomInButton.TextColor3 = Color3.new(1, 1, 1)
	zoomInButton.TextSize = 18
	zoomInButton.Font = Enum.Font.GothamBold
	zoomInButton.Parent = zoomContainer
	print("  🔧 Created ZoomInButton")
	
	local zoomInCorner = Instance.new("UICorner")
	zoomInCorner.CornerRadius = UDim.new(0, 4)
	zoomInCorner.Parent = zoomInButton
	
	-- Zoom out button (-)
	local zoomOutButton = Instance.new("TextButton")
	zoomOutButton.Name = "ZoomOutButton"
	zoomOutButton.Size = UDim2.new(0, 25, 0, 25)
	zoomOutButton.Position = UDim2.new(0, 0, 0, 30)
	zoomOutButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	zoomOutButton.BorderSizePixel = 1
	zoomOutButton.BorderColor3 = Color3.new(1, 1, 1)
	zoomOutButton.Text = "-"
	zoomOutButton.TextColor3 = Color3.new(1, 1, 1)
	zoomOutButton.TextSize = 18
	zoomOutButton.Font = Enum.Font.GothamBold
	zoomOutButton.Parent = zoomContainer
	print("  🔧 Created ZoomOutButton")
	
	local zoomOutCorner = Instance.new("UICorner")
	zoomOutCorner.CornerRadius = UDim.new(0, 4)
	zoomOutCorner.Parent = zoomOutButton
	
	-- Store zoom level and camera info (accessible to zoom functions)
	local zoomData = {
		currentZoom = 1.0,
		baseHeight = cameraHeight,
		baseFOV = cameraFOV,
		centerX = cameraCenterX,
		centerZ = cameraCenterZ,
		camera = minimapCamera
	}
	
	-- Zoom in function
	local function zoomIn()
		print("  🔧 zoomIn() called")
		print("    Current zoom: " .. string.format("%.2f", zoomData.currentZoom))
		print("    Base height: " .. string.format("%.2f", zoomData.baseHeight))
		print("    Base FOV: " .. string.format("%.2f", zoomData.baseFOV))
		print("    Camera: " .. tostring(zoomData.camera))
		
		zoomData.currentZoom = zoomData.currentZoom * 1.2 -- Zoom in by 20%
		if zoomData.currentZoom > 5.0 then
			zoomData.currentZoom = 5.0 -- Max zoom
			print("    ⚠ Max zoom reached (5.0x)")
		end
		
		-- Adjust camera height (lower = more zoom)
		local newHeight = zoomData.baseHeight / zoomData.currentZoom
		local newFOV = zoomData.baseFOV * zoomData.currentZoom
		newFOV = math.clamp(newFOV, 50, 120)
		
		print("    New zoom level: " .. string.format("%.2f", zoomData.currentZoom) .. "x")
		print("    New camera height: " .. string.format("%.2f", newHeight))
		print("    New camera FOV: " .. string.format("%.2f", newFOV))
		
		if zoomData.camera then
			zoomData.camera.CFrame = CFrame.new(
				zoomData.centerX,
				newHeight,
				zoomData.centerZ
			) * CFrame.Angles(math.rad(-90), 0, 0)
			zoomData.camera.FieldOfView = newFOV
			print("    ✓ Camera updated successfully")
		else
			warn("    ⚠ Camera is nil! Cannot update zoom")
		end
		
		print("  🔍 Zoomed in to " .. string.format("%.1f", zoomData.currentZoom) .. "x")
	end
	
	-- Zoom out function
	local function zoomOut()
		print("  🔧 zoomOut() called")
		print("    Current zoom: " .. string.format("%.2f", zoomData.currentZoom))
		print("    Base height: " .. string.format("%.2f", zoomData.baseHeight))
		print("    Base FOV: " .. string.format("%.2f", zoomData.baseFOV))
		print("    Camera: " .. tostring(zoomData.camera))
		
		zoomData.currentZoom = zoomData.currentZoom / 1.2 -- Zoom out by 20%
		if zoomData.currentZoom < 0.3 then
			zoomData.currentZoom = 0.3 -- Min zoom
			print("    ⚠ Min zoom reached (0.3x)")
		end
		
		-- Adjust camera height (higher = less zoom)
		local newHeight = zoomData.baseHeight / zoomData.currentZoom
		local newFOV = zoomData.baseFOV * zoomData.currentZoom
		newFOV = math.clamp(newFOV, 50, 120)
		
		print("    New zoom level: " .. string.format("%.2f", zoomData.currentZoom) .. "x")
		print("    New camera height: " .. string.format("%.2f", newHeight))
		print("    New camera FOV: " .. string.format("%.2f", newFOV))
		
		if zoomData.camera then
			zoomData.camera.CFrame = CFrame.new(
				zoomData.centerX,
				newHeight,
				zoomData.centerZ
			) * CFrame.Angles(math.rad(-90), 0, 0)
			zoomData.camera.FieldOfView = newFOV
			print("    ✓ Camera updated successfully")
		else
			warn("    ⚠ Camera is nil! Cannot update zoom")
		end
		
		print("  🔍 Zoomed out to " .. string.format("%.1f", zoomData.currentZoom) .. "x")
	end
	
	-- Connect zoom buttons
	zoomInButton.MouseButton1Click:Connect(zoomIn)
	zoomOutButton.MouseButton1Click:Connect(zoomOut)
	
	-- Store zoom functions and data in screenGui for keyboard access
	-- Can't store dictionaries in attributes, so store individual values
	screenGui:SetAttribute("ZoomInFunc", true) -- Flag to indicate function exists
	screenGui:SetAttribute("ZoomOutFunc", true) -- Flag to indicate function exists
	screenGui:SetAttribute("CurrentZoom", zoomData.currentZoom)
	screenGui:SetAttribute("BaseHeight", zoomData.baseHeight)
	screenGui:SetAttribute("BaseFOV", zoomData.baseFOV)
	screenGui:SetAttribute("CenterX", zoomData.centerX)
	screenGui:SetAttribute("CenterZ", zoomData.centerZ)
	
	-- Store zoom functions in a way that can be accessed by keyboard handler
	-- Use a BindableEvent or store in a module, or use UserInputService directly here
	local UserInputService = game:GetService("UserInputService")
	
	print("  🔧 Setting up keyboard input handler for zoom...")
	print("    UserInputService: " .. tostring(UserInputService))
	
	-- Keyboard input handler for zoom
	local zoomConnection
	local function handleZoomKey(input, gameProcessed, eventType)
		local success, err = pcall(function()
			eventType = eventType or "InputBegan"
			local keyName = tostring(input.KeyCode)
			local inputType = tostring(input.UserInputType)
			local focusedTextBox = UserInputService:GetFocusedTextBox()
			
			print("  ⌨️ [" .. eventType .. "] Key: " .. keyName .. " | gameProcessed: " .. tostring(gameProcessed) .. " | InputType: " .. inputType)
			if focusedTextBox then
				print("    ⚠ TextBox is focused: " .. tostring(focusedTextBox) .. " - keys may not work")
			end
			
			-- Check if it's a keyboard input
			if input.UserInputType == Enum.UserInputType.Keyboard then
				print("    ✓ Confirmed keyboard input")
				
				-- Log specific key codes we're looking for (including alternatives)
				if input.KeyCode == Enum.KeyCode.Equals then
					print("    🎯 EQUALS KEY DETECTED! (Enum.KeyCode.Equals)")
				elseif input.KeyCode == Enum.KeyCode.Minus then
					print("    🎯 MINUS KEY DETECTED! (Enum.KeyCode.Minus)")
				elseif keyName:find("Equals") or keyName:find("Plus") then
					print("    🎯 POTENTIAL = KEY DETECTED! (Key name contains 'Equals' or 'Plus')")
				elseif keyName:find("Minus") or keyName:find("Hyphen") then
					print("    🎯 POTENTIAL - KEY DETECTED! (Key name contains 'Minus' or 'Hyphen')")
				end
				
				-- Check for zoom keys - process even if gameProcessed is true (for our specific keys)
				-- Note: Enum.KeyCode.Hyphen doesn't exist - use Enum.KeyCode.Minus instead
				local isZoomKey = (input.KeyCode == Enum.KeyCode.Equals or 
				                   input.KeyCode == Enum.KeyCode.Minus)
				
				if isZoomKey then
					-- Check if a text box is focused (would prevent key detection)
					if focusedTextBox then
						print("    ⚠ TextBox is focused - zoom keys disabled to prevent typing conflicts")
						return
					end
					
					if gameProcessed then 
						print("    ⚠ Keypress was processed by game, but forcing zoom action for =/- keys")
					else
						print("    ✓ Keypress not processed by game - processing zoom...")
					end
					
					-- Process zoom keys even if gameProcessed is true
					if input.KeyCode == Enum.KeyCode.Equals then
						print("    ✅ = key matched (Enum.KeyCode.Equals) - calling zoomIn()...")
						zoomIn()
					elseif input.KeyCode == Enum.KeyCode.Minus then
						print("    ✅ - key matched (Enum.KeyCode.Minus) - calling zoomOut()...")
						zoomOut()
					end
				else
					if gameProcessed then 
						print("    ⚠ Keypress ignored - game is processing it (gameProcessed = true)")
						return 
					end
					print("    ℹ Key not bound to zoom (looking for Equals or Minus)")
				end
			else
				print("    ℹ Not a keyboard input (skipping)")
				return
			end
		end)
		
		if not success then
			warn("  ⚠ Error in handleZoomKey: " .. tostring(err))
		end
	end
	
	-- Listen to both InputBegan and InputEnded to catch keys that might be missed
	-- Also log ALL keyboard input to see what's actually being pressed
	-- Wrap in pcall to prevent errors from breaking the input handler
	zoomConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		local success, err = pcall(function()
			-- Log ALL keyboard input for debugging
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local keyName = tostring(input.KeyCode)
				print("  🔍 [ALL KEYS] Detected: " .. keyName .. " | gameProcessed: " .. tostring(gameProcessed))
				
				-- Check for = key variations (might require Shift)
				if keyName:find("Equals") or keyName:find("Plus") or keyName:find("=") then
					print("    ⚠ POTENTIAL = KEY FOUND! KeyName: " .. keyName)
				end
				
				-- Check for - key variations
				if keyName:find("Minus") or keyName:find("Hyphen") or keyName:find("-") then
					print("    ⚠ POTENTIAL - KEY FOUND! KeyName: " .. keyName)
				end
			end
			
			handleZoomKey(input, gameProcessed, "InputBegan")
		end)
		
		if not success then
			warn("  ⚠ Error in InputBegan handler: " .. tostring(err))
		end
	end)
	
	-- Also listen to InputEnded as a fallback
	local zoomConnectionEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
		-- Only process zoom keys on InputEnded if they weren't processed on InputBegan
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local keyName = tostring(input.KeyCode)
			local isZoomKey = (input.KeyCode == Enum.KeyCode.Equals or 
			                   input.KeyCode == Enum.KeyCode.Minus or
			                   keyName:find("Equals") or keyName:find("Plus") or keyName:find("=") or
			                   keyName:find("Minus") or keyName:find("Hyphen") or keyName:find("-"))
			if isZoomKey then
				print("  ⌨️ [InputEnded] Zoom key detected - processing as fallback...")
				handleZoomKey(input, gameProcessed, "InputEnded")
			end
		end
	end)
	
	-- Also try using GetKeysPressed() as a polling method
	task.spawn(function()
		while screenGui and screenGui.Parent do
			local success, err = pcall(function()
				task.wait(0.1) -- Check every 0.1 seconds
				local keysPressed = UserInputService:GetKeysPressed()
				for _, keyCode in ipairs(keysPressed) do
					local keyName = tostring(keyCode)
					if keyName:find("Equals") or keyName:find("Plus") or keyName:find("=") then
						print("  🔍 [POLLING] = key is currently pressed: " .. keyName)
						-- Only trigger once per press (debounce)
						if not screenGui:GetAttribute("LastZoomIn") or (tick() - screenGui:GetAttribute("LastZoomIn")) > 0.3 then
							screenGui:SetAttribute("LastZoomIn", tick())
							print("    ✅ Triggering zoom in via polling...")
							zoomIn()
						end
					elseif keyName:find("Minus") or keyName:find("Hyphen") or keyName:find("-") then
						print("  🔍 [POLLING] - key is currently pressed: " .. keyName)
						-- Only trigger once per press (debounce)
						if not screenGui:GetAttribute("LastZoomOut") or (tick() - screenGui:GetAttribute("LastZoomOut")) > 0.3 then
							screenGui:SetAttribute("LastZoomOut", tick())
							print("    ✅ Triggering zoom out via polling...")
							zoomOut()
						end
					end
				end
			end)
			
			if not success then
				warn("  ⚠ Error in polling loop: " .. tostring(err))
				task.wait(0.1) -- Wait before retrying
			end
		end
	end)
	
	print("  🔧 Keyboard connection created: " .. tostring(zoomConnection))
	
	-- Clean up connection when minimap is destroyed
	screenGui.AncestryChanged:Connect(function()
		if not screenGui.Parent then
			print("  🔧 Minimap destroyed - cleaning up keyboard connections")
			if zoomConnection then
				zoomConnection:Disconnect()
				print("    ✓ InputBegan connection disconnected")
			end
			if zoomConnectionEnded then
				zoomConnectionEnded:Disconnect()
				print("    ✓ InputEnded connection disconnected")
			end
		end
	end)
	
	print("  ✓ Zoom keyboard bindings: [=] for zoom in, [-] for zoom out")
	print("  🔧 Diagnostic: Keyboard handler ready and listening for keypresses")
	
	-- Test zoom functions after a delay to verify they work
	task.spawn(function()
		task.wait(2) -- Wait 2 seconds after minimap creation
		print("  🧪 Testing zoom functions...")
		print("    Camera before test: " .. tostring(zoomData.camera))
		if zoomData.camera then
			print("    Camera CFrame before: " .. tostring(zoomData.camera.CFrame))
			print("    Camera FOV before: " .. tostring(zoomData.camera.FieldOfView))
			
			-- Test zoom in
			print("    Testing zoomIn()...")
			zoomIn()
			task.wait(0.5)
			
			-- Test zoom out
			print("    Testing zoomOut()...")
			zoomOut()
			task.wait(0.5)
			
			-- Reset to original
			print("    Resetting zoom...")
			zoomData.currentZoom = 1.0
			local newHeight = zoomData.baseHeight / zoomData.currentZoom
			zoomData.camera.CFrame = CFrame.new(
				zoomData.centerX,
				newHeight,
				zoomData.centerZ
			) * CFrame.Angles(math.rad(-90), 0, 0)
			zoomData.camera.FieldOfView = zoomData.baseFOV
			print("    ✓ Zoom test complete - functions are working!")
		else
			warn("    ⚠ Camera is nil - zoom functions cannot work!")
		end
	end)
	
	print("  ✓ Created minimap GUI in upper left corner")
	print("  ✓ Minimap size: " .. minimapWidth .. "x" .. (minimapHeight + 25) .. " pixels (aspect ratio: " .. string.format("%.2f", aspectRatio) .. ")")
	print("  ✓ Position: 10 pixels from top-left")
	print("  ✓ Zoom buttons added (+ and -)")
	
	-- Diagnostic: Verify all elements exist
	print("  🔧 Diagnostic: Verifying minimap structure...")
	print("    screenGui exists: " .. tostring(screenGui ~= nil))
	print("    minimapFrame exists: " .. tostring(minimapFrame ~= nil))
	print("    viewportFrame exists: " .. tostring(viewportFrame ~= nil))
	print("    indicatorsContainer exists: " .. tostring(indicatorsContainer ~= nil))
	print("    zoomContainer exists: " .. tostring(zoomContainer ~= nil))
	print("    zoomInButton exists: " .. tostring(zoomInButton ~= nil))
	print("    zoomOutButton exists: " .. tostring(zoomOutButton ~= nil))
	print("    playerIndicator exists: " .. tostring(playerIndicator ~= nil))
	
	if minimapFrame then
		print("    minimapFrame children count: " .. #minimapFrame:GetChildren())
		for _, child in ipairs(minimapFrame:GetChildren()) do
			print("      - " .. child.Name .. " (" .. child.ClassName .. ")")
		end
	end
	
	if viewportFrame then
		print("    viewportFrame children count: " .. #viewportFrame:GetChildren())
		local terrainModel = viewportFrame:FindFirstChild("MinimapModel")
		if terrainModel then
			print("    MinimapModel found with " .. #terrainModel:GetChildren() .. " children")
		else
			print("    MinimapModel not found in viewportFrame")
		end
	end
	
	print("  🔧 Returning from createMinimap:")
	print("    screenGui: " .. tostring(screenGui))
	print("    minimapCamera: " .. tostring(minimapCamera))
	print("    viewportFrame: " .. tostring(viewportFrame))
	return screenGui, minimapCamera, viewportFrame
end

-- Function to create terrain in existing minimap (legacy function, now uses createMinimapTerrain)
local function createTerrainForMinimap(viewportFrame)
	-- Check if terrain already exists (must have children to be valid)
	local existingModel = viewportFrame:FindFirstChild("MinimapModel")
	if existingModel and existingModel:GetChildren() and #existingModel:GetChildren() > 0 then
		print("  ✓ Terrain model already exists with " .. #existingModel:GetChildren() .. " parts")
		return
	end
	
	-- Find baseplate and walls to get boundaries
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
	
	local mapMinX, mapMaxX, mapMinZ, mapMaxZ = findWallsAndCalculateBounds(0)
	local terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ
	
	if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
		terrainMinX = mapMinX
		terrainMaxX = mapMaxX
		terrainMinZ = mapMinZ
		terrainMaxZ = mapMaxZ
	elseif baseplate then
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		local WALL_MARGIN = 8
		terrainMinX = baseplatePos.X - (baseplateSize.X / 2) + WALL_MARGIN
		terrainMaxX = baseplatePos.X + (baseplateSize.X / 2) - WALL_MARGIN
		terrainMinZ = baseplatePos.Z - (baseplateSize.Z / 2) + WALL_MARGIN
		terrainMaxZ = baseplatePos.Z + (baseplateSize.Z / 2) - WALL_MARGIN
	else
		warn("  ⚠ Cannot create terrain - no baseplate or walls found")
		return
	end
	
	local baseplateTop = 10
	if baseplate then
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		baseplateTop = baseplatePos.Y + (baseplateSize.Y / 2)
	end
	
	-- Use the reusable function
	createMinimapTerrain(viewportFrame, terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ, baseplateTop)
end

-- Function to set up keyboard handler for existing minimap
local function setupKeyboardHandlerForExistingMinimap(screenGui)
	print("  🔧 Setting up keyboard handler for existing minimap...")
	
	-- Find the minimap elements
	local minimapFrame = screenGui:FindFirstChild("MinimapFrame")
	if not minimapFrame then
		warn("  ⚠ MinimapFrame not found - cannot set up keyboard handler")
		return
	end
	
	local viewportFrame = minimapFrame:FindFirstChild("ViewportFrame")
	if not viewportFrame then
		warn("  ⚠ ViewportFrame not found - cannot set up keyboard handler")
		return
	end
	
	-- Find the camera in workspace
	local minimapCamera = workspace:FindFirstChild("MinimapCamera")
	if not minimapCamera then
		warn("  ⚠ MinimapCamera not found in workspace - cannot set up zoom")
		return
	end
	
	-- Get zoom data from attributes or calculate from camera
	local baseHeight = screenGui:GetAttribute("BaseHeight") or 600
	local baseFOV = screenGui:GetAttribute("BaseFOV") or 100
	local centerX = screenGui:GetAttribute("CenterX") or 0
	local centerZ = screenGui:GetAttribute("CenterZ") or 0
	local currentZoom = screenGui:GetAttribute("CurrentZoom") or 1.0
	
	-- Get camera position to determine center if not stored
	if centerX == 0 and centerZ == 0 then
		local cameraPos = minimapCamera.CFrame.Position
		centerX = cameraPos.X
		centerZ = cameraPos.Z
		baseHeight = cameraPos.Y
		baseFOV = minimapCamera.FieldOfView
		screenGui:SetAttribute("BaseHeight", baseHeight)
		screenGui:SetAttribute("BaseFOV", baseFOV)
		screenGui:SetAttribute("CenterX", centerX)
		screenGui:SetAttribute("CenterZ", centerZ)
		screenGui:SetAttribute("CurrentZoom", currentZoom)
	end
	
	local zoomData = {
		currentZoom = currentZoom,
		baseHeight = baseHeight,
		baseFOV = baseFOV,
		centerX = centerX,
		centerZ = centerZ,
		camera = minimapCamera
	}
	
	-- Zoom functions
	local function zoomIn()
		print("  🔧 zoomIn() called (existing minimap)")
		zoomData.currentZoom = zoomData.currentZoom * 1.2
		if zoomData.currentZoom > 5.0 then
			zoomData.currentZoom = 5.0
		end
		local newHeight = zoomData.baseHeight / zoomData.currentZoom
		local newFOV = zoomData.baseFOV * zoomData.currentZoom
		newFOV = math.clamp(newFOV, 50, 120)
		if zoomData.camera then
			zoomData.camera.CFrame = CFrame.new(zoomData.centerX, newHeight, zoomData.centerZ) * CFrame.Angles(math.rad(-90), 0, 0)
			zoomData.camera.FieldOfView = newFOV
			screenGui:SetAttribute("CurrentZoom", zoomData.currentZoom)
		end
	end
	
	local function zoomOut()
		print("  🔧 zoomOut() called (existing minimap)")
		zoomData.currentZoom = zoomData.currentZoom / 1.2
		if zoomData.currentZoom < 0.3 then
			zoomData.currentZoom = 0.3
		end
		local newHeight = zoomData.baseHeight / zoomData.currentZoom
		local newFOV = zoomData.baseFOV * zoomData.currentZoom
		newFOV = math.clamp(newFOV, 50, 120)
		if zoomData.camera then
			zoomData.camera.CFrame = CFrame.new(zoomData.centerX, newHeight, zoomData.centerZ) * CFrame.Angles(math.rad(-90), 0, 0)
			zoomData.camera.FieldOfView = newFOV
			screenGui:SetAttribute("CurrentZoom", zoomData.currentZoom)
		end
	end
	
	-- Set up keyboard handler (same code as in createMinimap)
	local UserInputService = game:GetService("UserInputService")
	
	local function handleZoomKey(input, gameProcessed, eventType)
		local success, err = pcall(function()
			eventType = eventType or "InputBegan"
			local keyName = tostring(input.KeyCode)
			local inputType = tostring(input.UserInputType)
			local focusedTextBox = UserInputService:GetFocusedTextBox()
			
			print("  ⌨️ [" .. eventType .. "] Key: " .. keyName .. " | gameProcessed: " .. tostring(gameProcessed) .. " | InputType: " .. inputType)
			if focusedTextBox then
				print("    ⚠ TextBox is focused: " .. tostring(focusedTextBox) .. " - keys may not work")
			end
			
			if input.UserInputType == Enum.UserInputType.Keyboard then
				print("    ✓ Confirmed keyboard input")
				
				if input.KeyCode == Enum.KeyCode.Equals then
					print("    🎯 EQUALS KEY DETECTED! (Enum.KeyCode.Equals)")
				elseif input.KeyCode == Enum.KeyCode.Minus then
					print("    🎯 MINUS KEY DETECTED! (Enum.KeyCode.Minus)")
				end
				
				local isZoomKey = (input.KeyCode == Enum.KeyCode.Equals or input.KeyCode == Enum.KeyCode.Minus)
				
				if isZoomKey then
					if focusedTextBox then
						print("    ⚠ TextBox is focused - zoom keys disabled")
						return
					end
					
					if input.KeyCode == Enum.KeyCode.Equals then
						print("    ✅ = key matched - calling zoomIn()...")
						zoomIn()
					elseif input.KeyCode == Enum.KeyCode.Minus then
						print("    ✅ - key matched - calling zoomOut()...")
						zoomOut()
					end
				end
			end
		end)
		
		if not success then
			warn("  ⚠ Error in handleZoomKey: " .. tostring(err))
		end
	end
	
	local zoomConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		local success, err = pcall(function()
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local keyName = tostring(input.KeyCode)
				print("  🔍 [ALL KEYS] Detected: " .. keyName .. " | gameProcessed: " .. tostring(gameProcessed))
				
				if keyName:find("Equals") or keyName:find("Plus") or keyName:find("=") then
					print("    ⚠ POTENTIAL = KEY FOUND! KeyName: " .. keyName)
				end
				
				if keyName:find("Minus") or keyName:find("Hyphen") or keyName:find("-") then
					print("    ⚠ POTENTIAL - KEY FOUND! KeyName: " .. keyName)
				end
			end
			
			handleZoomKey(input, gameProcessed, "InputBegan")
		end)
		
		if not success then
			warn("  ⚠ Error in InputBegan handler: " .. tostring(err))
		end
	end)
	
	-- Polling fallback
	task.spawn(function()
		while screenGui and screenGui.Parent do
			local success, err = pcall(function()
				task.wait(0.1)
				local keysPressed = UserInputService:GetKeysPressed()
				for _, keyCode in ipairs(keysPressed) do
					local keyName = tostring(keyCode)
					if keyName:find("Equals") or keyName:find("Plus") or keyName:find("=") then
						print("  🔍 [POLLING] = key is currently pressed: " .. keyName)
						if not screenGui:GetAttribute("LastZoomIn") or (tick() - screenGui:GetAttribute("LastZoomIn")) > 0.3 then
							screenGui:SetAttribute("LastZoomIn", tick())
							print("    ✅ Triggering zoom in via polling...")
							zoomIn()
						end
					elseif keyName:find("Minus") or keyName:find("Hyphen") or keyName:find("-") then
						print("  🔍 [POLLING] - key is currently pressed: " .. keyName)
						if not screenGui:GetAttribute("LastZoomOut") or (tick() - screenGui:GetAttribute("LastZoomOut")) > 0.3 then
							screenGui:SetAttribute("LastZoomOut", tick())
							print("    ✅ Triggering zoom out via polling...")
							zoomOut()
						end
					end
				end
			end)
			
			if not success then
				warn("  ⚠ Error in polling loop: " .. tostring(err))
				task.wait(0.1)
			end
		end
	end)
	
	print("  ✓ Keyboard handler set up for existing minimap")
end

-- Check if minimap already exists to prevent duplicates
local playerGui = player:WaitForChild("PlayerGui")
local existingMinimap = playerGui:FindFirstChild("Minimap")

if existingMinimap then
	-- Minimap already exists, check if terrain exists
	print("  ⚠ Minimap already exists, checking for terrain...")
	local minimapFrame = existingMinimap:FindFirstChild("MinimapFrame")
	if minimapFrame then
		local viewportFrame = minimapFrame:FindFirstChild("ViewportFrame")
		if viewportFrame then
			local terrainModel = viewportFrame:FindFirstChild("MinimapModel")
			-- Check if terrain model exists AND has children (actual terrain parts)
			if not terrainModel or not terrainModel:GetChildren() or #terrainModel:GetChildren() == 0 then
				print("  ⚠ Terrain model missing or empty, creating terrain...")
				print("  🔧 Calling createTerrainForMinimap with viewportFrame: " .. tostring(viewportFrame))
				createTerrainForMinimap(viewportFrame)
			else
				print("  ✓ Terrain model already exists with " .. #terrainModel:GetChildren() .. " parts")
			end
		else
			warn("  ⚠ ViewportFrame not found in existing minimap")
		end
	else
		warn("  ⚠ MinimapFrame not found in existing minimap")
	end
	
	-- IMPORTANT: Set up keyboard handler even when minimap already exists
	setupKeyboardHandlerForExistingMinimap(existingMinimap)
else
	-- Create the minimap
	local minimapGui, minimapCam, viewportFrame = createMinimap()
	
	print("")
	print("✅ Minimap created successfully!")
	print("  💡 The minimap is now in the upper left corner")
	print("  💡 Default Roblox UI elements (Chat, PlayerList) have been hidden")
	print("  💡 To show chat again, use: StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)")
end

-- Listen for terrain generation events to update minimap
-- Create or find RemoteEvent for terrain updates
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local terrainUpdateEvent = ReplicatedStorage:FindFirstChild("TerrainUpdateEvent")

if not terrainUpdateEvent then
	-- Create the RemoteEvent if it doesn't exist
	terrainUpdateEvent = Instance.new("RemoteEvent")
	terrainUpdateEvent.Name = "TerrainUpdateEvent"
	terrainUpdateEvent.Parent = ReplicatedStorage
	print("  ✓ Created TerrainUpdateEvent RemoteEvent")
end

-- Listen for terrain updates
terrainUpdateEvent.OnClientEvent:Connect(function()
	print("  🔄 Terrain update received - updating minimap...")
	
	-- Find the minimap GUI
	local playerGui = player:WaitForChild("PlayerGui")
	local minimapGui = playerGui:FindFirstChild("Minimap")
	if not minimapGui then
		warn("  ⚠ Minimap GUI not found")
		return
	end
	
	local minimapFrame = minimapGui:FindFirstChild("MinimapFrame")
	if not minimapFrame then
		warn("  ⚠ MinimapFrame not found")
		return
	end
	
	local viewportFrame = minimapFrame:FindFirstChild("ViewportFrame")
	if not viewportFrame then
		warn("  ⚠ ViewportFrame not found")
		return
	end
	
	-- Wait a moment for terrain to finish generating
	task.wait(0.5)
	
	-- Find baseplate and walls to get boundaries
	local baseplate = workspace:FindFirstChild("Baseplate")
	if not baseplate then
		baseplate = workspace:FindFirstChild("baseplate")
	end
	if not baseplate then
		baseplate = workspace:FindFirstChild("BasePlate")
	end
	
	local mapMinX, mapMaxX, mapMinZ, mapMaxZ = findWallsAndCalculateBounds(0)
	local terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ
	
	if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
		terrainMinX = mapMinX
		terrainMaxX = mapMaxX
		terrainMinZ = mapMinZ
		terrainMaxZ = mapMaxZ
	elseif baseplate then
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		local WALL_MARGIN = 8
		terrainMinX = baseplatePos.X - (baseplateSize.X / 2) + WALL_MARGIN
		terrainMaxX = baseplatePos.X + (baseplateSize.X / 2) - WALL_MARGIN
		terrainMinZ = baseplatePos.Z - (baseplateSize.Z / 2) + WALL_MARGIN
		terrainMaxZ = baseplatePos.Z + (baseplateSize.Z / 2) - WALL_MARGIN
	else
		warn("  ⚠ Cannot update terrain - no baseplate or walls found")
		return
	end
	
	local baseplateTop = 10
	if baseplate then
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		baseplateTop = baseplatePos.Y + (baseplateSize.Y / 2)
	end
	
	-- Update minimap terrain
	createMinimapTerrain(viewportFrame, terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ, baseplateTop)
	print("  ✓ Minimap terrain updated!")
end)

print("  ✓ Minimap terrain update listener ready")

