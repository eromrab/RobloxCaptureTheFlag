-- MINIMAP UPDATE LOCALSCRIPT
-- Place this in StarterGui (as a LocalScript)
-- Updates player and teammate indicators on the minimap

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for minimap to be created
local minimapGui = playerGui:WaitForChild("Minimap", 10)
if not minimapGui then
	warn("⚠ Minimap GUI not found!")
	return
end

-- Function to find minimap elements (can be called again if minimap is recreated)
local function findMinimapElements()
	local minimapFrame = minimapGui and minimapGui:FindFirstChild("MinimapFrame")
	local viewportFrame = minimapFrame and minimapFrame:FindFirstChild("ViewportFrame")
	local indicatorsContainer = minimapFrame and minimapFrame:FindFirstChild("IndicatorsContainer")
	return minimapFrame, viewportFrame, indicatorsContainer
end

local minimapFrame, viewportFrame, indicatorsContainer = findMinimapElements()

-- Wait for minimap elements if not found immediately
if not minimapFrame then
	minimapFrame = minimapGui:WaitForChild("MinimapFrame", 5)
end
if not viewportFrame then
	viewportFrame = minimapFrame and minimapFrame:WaitForChild("ViewportFrame", 5)
end
if not indicatorsContainer then
	indicatorsContainer = minimapFrame and minimapFrame:WaitForChild("IndicatorsContainer", 5)
end

if not indicatorsContainer then
	warn("⚠ Minimap indicators container not found!")
	print("  Available children of MinimapFrame:")
	if minimapFrame then
		for _, child in ipairs(minimapFrame:GetChildren()) do
			print("    - " .. child.Name .. " (" .. child.ClassName .. ")")
		end
	end
	return
end

print("  ✓ Minimap LocalScript loaded")

-- Find baseplate for reference (recursive search)
local function findBaseplate()
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
	return baseplate
end

local baseplate = findBaseplate()

if not baseplate then
	warn("  ⚠ Baseplate not found for minimap reference")
	print("  Searching for baseplate in workspace...")
	-- Try again after a delay
	task.wait(1)
	baseplate = findBaseplate()
	if baseplate then
		print("  ✓ Found baseplate on retry: " .. baseplate.Name .. " at " .. tostring(baseplate.Position))
	else
		warn("  ⚠ Baseplate still not found after retry")
	end
end

-- Store teammate indicators
local teammateIndicators = {}
local debugCounter = 0 -- For occasional debug output

-- Function to create a teammate indicator
local function createTeammateIndicator(otherPlayer)
	if teammateIndicators[otherPlayer] then
		return teammateIndicators[otherPlayer]
	end
	
	local indicator = Instance.new("Frame")
	indicator.Name = "Teammate_" .. otherPlayer.Name
	indicator.Size = UDim2.new(0, 6, 0, 6)
	indicator.BackgroundColor3 = Color3.new(0, 1, 0) -- Green dot for teammates
	indicator.BorderSizePixel = 1
	indicator.BorderColor3 = Color3.new(1, 1, 1) -- White border
	indicator.ZIndex = 11
	indicator.Parent = indicatorsContainer
	
	-- Make it circular
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = indicator
	
	teammateIndicators[otherPlayer] = indicator
	return indicator
end

-- Function to remove teammate indicator
local function removeTeammateIndicator(otherPlayer)
	local indicator = teammateIndicators[otherPlayer]
	if indicator then
		indicator:Destroy()
		teammateIndicators[otherPlayer] = nil
	end
end

-- Function to find walls and calculate map boundaries (with recursive search)
local function findWallsAndCalculateBounds()
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
	
	if not wallsFolder then
		return nil, nil, nil, nil
	end
	
	-- Try to find walls (with recursive search)
	local function findWallRecursive(parent, wallName)
		for _, obj in ipairs(parent:GetChildren()) do
			if obj:IsA("Part") and obj.Name == wallName then
				return obj
			end
			if obj:IsA("Model") or obj:IsA("Folder") then
				local found = findWallRecursive(obj, wallName)
				if found then return found end
			end
		end
		return nil
	end
	
	local eastWall = wallsFolder:FindFirstChild("EastWall")
	if not eastWall then
		eastWall = findWallRecursive(wallsFolder, "EastWall")
	end
	
	local westWall = wallsFolder:FindFirstChild("WestWall")
	if not westWall then
		westWall = findWallRecursive(wallsFolder, "WestWall")
	end
	
	local northWall = wallsFolder:FindFirstChild("NorthWall")
	if not northWall then
		northWall = findWallRecursive(wallsFolder, "NorthWall")
	end
	
	local southWall = wallsFolder:FindFirstChild("SouthWall")
	if not southWall then
		southWall = findWallRecursive(wallsFolder, "SouthWall")
	end
	
	if not eastWall or not westWall or not northWall or not southWall then
		return nil, nil, nil, nil
	end
	
	-- Calculate inner boundaries (edges facing the map interior)
	local mapMinX = westWall.Position.X + (westWall.Size.X / 2)
	local mapMaxX = eastWall.Position.X - (eastWall.Size.X / 2)
	local mapMinZ = southWall.Position.Z + (southWall.Size.Z / 2)
	local mapMaxZ = northWall.Position.Z - (northWall.Size.Z / 2)
	
	return mapMinX, mapMaxX, mapMinZ, mapMaxZ
end

-- Function to convert world position to minimap coordinates
-- Uses wall boundaries for accurate positioning
local function worldToMinimap(worldPos)
	-- Try to use wall boundaries first
	local mapMinX, mapMaxX, mapMinZ, mapMaxZ = findWallsAndCalculateBounds()
	
	local terrainMinX, terrainMaxX, terrainMinZ, terrainMaxZ
	
	if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
		-- Use wall boundaries (the area inside the walls)
		terrainMinX = mapMinX
		terrainMaxX = mapMaxX
		terrainMinZ = mapMinZ
		terrainMaxZ = mapMaxZ
	elseif baseplate then
		-- Fallback to baseplate with margin
		local baseplatePos = baseplate.Position
		local baseplateSize = baseplate.Size
		local WALL_MARGIN = 8
		terrainMinX = baseplatePos.X - (baseplateSize.X / 2) + WALL_MARGIN
		terrainMaxX = baseplatePos.X + (baseplateSize.X / 2) - WALL_MARGIN
		terrainMinZ = baseplatePos.Z - (baseplateSize.Z / 2) + WALL_MARGIN
		terrainMaxZ = baseplatePos.Z + (baseplateSize.Z / 2) - WALL_MARGIN
	else
		return nil
	end
	
	local terrainWidth = terrainMaxX - terrainMinX
	local terrainDepth = terrainMaxZ - terrainMinZ
	
	if terrainWidth <= 0 or terrainDepth <= 0 then
		return nil
	end
	
	-- Normalize position relative to terrain bounds
	local relativeX = (worldPos.X - terrainMinX) / terrainWidth
	local relativeZ = (worldPos.Z - terrainMinZ) / terrainDepth
	
	-- Clamp to 0-1 range
	relativeX = math.clamp(relativeX, 0, 1)
	relativeZ = math.clamp(relativeZ, 0, 1)
	
	return relativeX, relativeZ
end

-- Update minimap indicators
local function updateMinimap()
	-- Re-find minimap elements if they were destroyed/recreated
	if not indicatorsContainer or not indicatorsContainer.Parent then
		minimapFrame, viewportFrame, indicatorsContainer = findMinimapElements()
		if not indicatorsContainer then
			return -- Can't update if minimap doesn't exist
		end
	end
	
	if not player.Character then
		-- Hide all indicators if player has no character
		local playerIndicator = indicatorsContainer:FindFirstChild("PlayerIndicator")
		if playerIndicator then
			playerIndicator.Visible = false
		end
		for _, indicator in pairs(teammateIndicators) do
			indicator.Visible = false
		end
		return
	end
	
	local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	
	local playerPos = humanoidRootPart.Position
	local playerTeam = player.Team
	
	-- Update player indicator
	local playerIndicator = indicatorsContainer:FindFirstChild("PlayerIndicator")
	if playerIndicator then
		local relativeX, relativeZ = worldToMinimap(playerPos)
		if relativeX and relativeZ then
			-- UDim2: X = horizontal (left-right), Y = vertical (top-bottom)
			-- World: X = East/West, Z = North/South
			-- For top-down view: world X maps to screen X, world Z maps to screen Y
			local newPosition = UDim2.new(relativeX, -4, relativeZ, -4)
			playerIndicator.Position = newPosition
			playerIndicator.Visible = true
			
			-- Debug output (print first few times, then occasionally)
			debugCounter = debugCounter + 1
			if debugCounter <= 10 or (debugCounter % 60 == 0) then -- First 10 frames, then every 60 frames
				print("  Minimap Debug: Player at world (" .. string.format("%.1f", playerPos.X) .. ", " .. string.format("%.1f", playerPos.Z) .. ") -> minimap (" .. string.format("%.3f", relativeX) .. ", " .. string.format("%.3f", relativeZ) .. ")")
				print("    Indicator Position: " .. tostring(newPosition))
				print("    Indicator Visible: " .. tostring(playerIndicator.Visible))
				print("    Indicator Size: " .. tostring(playerIndicator.Size))
				print("    Indicator Parent: " .. (playerIndicator.Parent and playerIndicator.Parent.Name or "nil"))
				print("    IndicatorsContainer Size: " .. tostring(indicatorsContainer.Size))
				print("    IndicatorsContainer Position: " .. tostring(indicatorsContainer.Position))
				if viewportFrame then
					print("    ViewportFrame Size: " .. tostring(viewportFrame.Size))
					print("    ViewportFrame Position: " .. tostring(viewportFrame.Position))
					print("    ViewportFrame AbsoluteSize: " .. tostring(viewportFrame.AbsoluteSize))
					print("    ViewportFrame AbsolutePosition: " .. tostring(viewportFrame.AbsolutePosition))
				end
				if indicatorsContainer then
					print("    IndicatorsContainer AbsoluteSize: " .. tostring(indicatorsContainer.AbsoluteSize))
					print("    IndicatorsContainer AbsolutePosition: " .. tostring(indicatorsContainer.AbsolutePosition))
				end
				-- Show terrain bounds (using wall boundaries if available)
				local mapMinX, mapMaxX, mapMinZ, mapMaxZ = findWallsAndCalculateBounds()
				if mapMinX and mapMaxX and mapMinZ and mapMaxZ then
					print("    Terrain bounds (walls): X[" .. string.format("%.1f", mapMinX) .. " to " .. string.format("%.1f", mapMaxX) .. "], Z[" .. string.format("%.1f", mapMinZ) .. " to " .. string.format("%.1f", mapMaxZ) .. "]")
				elseif baseplate then
					local baseplatePos = baseplate.Position
					local baseplateSize = baseplate.Size
					local WALL_MARGIN = 8
					local terrainMinX = baseplatePos.X - (baseplateSize.X / 2) + WALL_MARGIN
					local terrainMaxX = baseplatePos.X + (baseplateSize.X / 2) - WALL_MARGIN
					local terrainMinZ = baseplatePos.Z - (baseplateSize.Z / 2) + WALL_MARGIN
					local terrainMaxZ = baseplatePos.Z + (baseplateSize.Z / 2) - WALL_MARGIN
					print("    Terrain bounds (baseplate): X[" .. string.format("%.1f", terrainMinX) .. " to " .. string.format("%.1f", terrainMaxX) .. "], Z[" .. string.format("%.1f", terrainMinZ) .. " to " .. string.format("%.1f", terrainMaxZ) .. "]")
				end
			end
		else
			playerIndicator.Visible = false
			if math.random() < 0.01 then
				warn("  Minimap: Could not calculate player position")
			end
		end
	end
	
	-- Update teammate indicators
	local allPlayers = Players:GetPlayers()
	for _, otherPlayer in ipairs(allPlayers) do
		if otherPlayer ~= player and otherPlayer.Character then
			local otherHumanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			if otherHumanoidRootPart then
				local otherPlayerTeam = otherPlayer.Team
				
				-- Only show teammates (same team)
				if playerTeam and otherPlayerTeam and playerTeam == otherPlayerTeam then
					local indicator = createTeammateIndicator(otherPlayer)
					local relativeX, relativeZ = worldToMinimap(otherHumanoidRootPart.Position)
					if relativeX and relativeZ then
						indicator.Position = UDim2.new(relativeX, -3, relativeZ, -3)
						indicator.Visible = true
					else
						indicator.Visible = false
					end
				else
					-- Hide indicator if not teammate
					removeTeammateIndicator(otherPlayer)
				end
			end
		else
			-- Hide indicator if player has no character
			removeTeammateIndicator(otherPlayer)
		end
	end
	
	-- Clean up indicators for players who left
	for otherPlayer, indicator in pairs(teammateIndicators) do
		if not Players:FindFirstChild(otherPlayer.Name) then
			removeTeammateIndicator(otherPlayer)
		end
	end
end

-- Update minimap every frame
RunService.RenderStepped:Connect(function()
	updateMinimap()
end)

-- Also listen for player removals
Players.PlayerRemoving:Connect(function(leavingPlayer)
	removeTeammateIndicator(leavingPlayer)
end)

print("  ✓ Minimap update loop started")
print("  ✓ Teammate tracking enabled")

