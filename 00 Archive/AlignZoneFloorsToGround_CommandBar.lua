-- COMMAND BAR SCRIPT: Aligns all ZoneFloors to the topmost ground layer
-- Paste this into Roblox Studio Command Bar (View > Command Bar)

local zoneFloorNames = {
	"TeamABaseFloor",
	"TeamAZoneFloor",
	"NeutralZoneFloor",
	"TeamBZoneFloor",
	"TeamBBaseFloor",
}

-- Build filter list once (zone parts, walls, and all models like Trees)
-- IMPORTANT: We do NOT filter out the Baseplate part or Roblox Terrain
local function buildFilterList()
	local filterList = {}
	
	-- Add all zone parts to filter (search recursively in case they're in folders)
	for _, name in ipairs(zoneFloorNames) do
		local part = workspace:FindFirstChild(name, true)
		if part then
			table.insert(filterList, part)
		end
	end
	-- Also filter zone walls (search recursively)
	local wallNames = {"TeamABaseZoneWall", "TeamAMidpointZoneWall", "TeamBMidpointZoneWall", "TeamBBaseZoneWall"}
	for _, name in ipairs(wallNames) do
		local part = workspace:FindFirstChild(name, true)
		if part then
			table.insert(filterList, part)
		end
	end
	
	-- Filter out all Models and their descendants (Trees, buildings, etc.)
	-- BUT: Make sure we don't filter out the Baseplate part itself
	-- This ensures we only hit the actual ground/terrain
	-- Search recursively through all descendants to find Models (even in folders)
	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Model") then
			-- Add the model itself
			table.insert(filterList, descendant)
			-- Add all parts within the model
			for _, modelPart in ipairs(descendant:GetDescendants()) do
				if modelPart:IsA("BasePart") then
					table.insert(filterList, modelPart)
				end
			end
		end
	end
	
	-- Also filter out any parts that are clearly not ground (like individual tree parts)
	-- Check for parts with names containing "Tree" or are high up
	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local name = descendant.Name:lower()
			-- Filter out tree-related parts
			if name:find("tree") or name:find("trunk") or name:find("leaf") or name:find("branch") then
				table.insert(filterList, descendant)
			end
		end
	end
	
	return filterList
end

-- Build filter list once at start
local filterList = buildFilterList()

-- Function to get ground height at a specific X, Z position
local function getGroundHeight(x, z)
	-- Cast a ray from high above downward to find the ground
	local rayOrigin = Vector3.new(x, 1000, z) -- Start high above
	local rayDirection = Vector3.new(0, -2000, 0) -- Cast downward
	
	-- Filter to ignore zone floors, walls, and models (like Trees)
	-- Note: Baseplate part and Roblox Terrain will NOT be filtered
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = filterList
	
	-- Also set collision groups to ensure we can hit terrain
	raycastParams.CollisionGroup = "Default"
	
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult then
		-- Check if we hit terrain or a part (like Baseplate)
		-- Roblox Terrain will have Instance = nil or be a TerrainRegion
		-- Parts will have Instance set to the part
		local hitInstance = raycastResult.Instance
		local hitY = raycastResult.Position.Y
		
		-- PRIORITY 1: If we hit terrain (no instance), use it immediately - this is the actual ground!
		if not hitInstance then
			return hitY
		end
		
		-- Reject hits that are clearly too high (like tree tops)
		-- Ground should be roughly between -10 and 100 studs (increased for hills)
		if hitY > 100 then
			-- Too high, likely a tree or object, skip it
		else
			-- Check if it's part of a Model (likely a tree or object)
			local model = hitInstance:FindFirstAncestorOfClass("Model")
			if model then
				-- This is part of a model, skip it
			else
				-- Check if the part name suggests it's a tree/object
				local name = hitInstance.Name:lower()
				if name:find("tree") or name:find("trunk") or name:find("leaf") or name:find("branch") then
					-- Skip tree parts
				else
					-- This could be Baseplate or terrain part
					-- If it's the Baseplate, check if there's terrain above it by casting from above
					if name:find("baseplate") or name:find("base") then
						-- Hit the baseplate part - check if there's terrain above it
						-- Cast another ray from well above the baseplate to find terrain
						local terrainCheckOrigin = Vector3.new(x, hitY + 20, z)
						local terrainCheckParams = RaycastParams.new()
						terrainCheckParams.FilterType = Enum.RaycastFilterType.Blacklist
						-- Create a copy of filter list and add the baseplate to it
						local terrainFilterList = {}
						for _, item in ipairs(filterList) do
							table.insert(terrainFilterList, item)
						end
						table.insert(terrainFilterList, hitInstance)
						terrainCheckParams.FilterDescendantsInstances = terrainFilterList
						local terrainCheckResult = workspace:Raycast(terrainCheckOrigin, Vector3.new(0, -30, 0), terrainCheckParams)
						if terrainCheckResult and not terrainCheckResult.Instance then
							-- Found terrain above baseplate, use that instead!
							return terrainCheckResult.Position.Y
						end
					end
					-- Use the hit (could be baseplate or terrain part)
					return hitY
				end
			end
		end
	end
	
	-- If we didn't get a valid hit, try casting from a lower height to find terrain
	-- This helps when baseplate is blocking terrain detection
	local lowerRayOrigin = Vector3.new(x, 50, z) -- Start from a reasonable height
	local lowerRayResult = workspace:Raycast(lowerRayOrigin, Vector3.new(0, -100, 0), raycastParams)
	if lowerRayResult then
		local lowerHitInstance = lowerRayResult.Instance
		local lowerHitY = lowerRayResult.Position.Y
		-- If we hit terrain (no instance) or a valid ground part, use it
		if not lowerHitInstance or (lowerHitInstance and lowerHitY <= 100) then
			local lowerName = lowerHitInstance and lowerHitInstance.Name:lower() or ""
			if not lowerHitInstance or (not lowerName:find("tree") and not lowerName:find("trunk") and not lowerName:find("leaf") and not lowerName:find("branch")) then
				local lowerModel = lowerHitInstance and lowerHitInstance:FindFirstAncestorOfClass("Model")
				if not lowerModel then
					return lowerHitY
				end
			end
		end
	end
	
	-- Fallback: Try to find Baseplate part directly as last resort (search recursively)
	local baseplate = workspace:FindFirstChild("Baseplate", true) or workspace:FindFirstChild("BasePlate", true)
	if baseplate and baseplate:IsA("BasePart") then
		-- Baseplate is at Y = -8 with height 16, so top is at Y = 0
		-- But if terrain is hilly, we should have hit it with raycast
		-- Return the top of the baseplate as fallback
		return baseplate.Position.Y + baseplate.Size.Y / 2
	end
	
	-- Final fallback: return 0 (assuming flat baseplate top)
	return 0
end

-- Function to find the ground height that the floor should follow
-- Uses MAXIMUM height so the floor covers both flat areas and hills
local function findGroundHeightForFloor(floor)
	local xMin = floor.Position.X - floor.Size.X / 2
	local xMax = floor.Position.X + floor.Size.X / 2
	local zMin = floor.Position.Z - floor.Size.Z / 2
	local zMax = floor.Position.Z + floor.Size.Z / 2
	
	-- Sample points across the floor area (sample every 10 studs for better accuracy)
	local sampleSpacing = 10
	local maxHeight = -math.huge  -- Find MAXIMUM to cover hills
	local hitCount = 0
	
	-- Sample interior points
	for x = xMin, xMax, sampleSpacing do
		for z = zMin, zMax, sampleSpacing do
			local height = getGroundHeight(x, z)
			if height > -1000 then -- Valid hit
				if height > maxHeight then
					maxHeight = height
				end
				hitCount = hitCount + 1
			end
		end
	end
	
	-- Also sample the edges
	for z = zMin, zMax, sampleSpacing do
		local height1 = getGroundHeight(xMin, z)
		if height1 > -1000 then
			if height1 > maxHeight then
				maxHeight = height1
			end
			hitCount = hitCount + 1
		end
		local height2 = getGroundHeight(xMax, z)
		if height2 > -1000 then
			if height2 > maxHeight then
				maxHeight = height2
			end
			hitCount = hitCount + 1
		end
	end
	
	for x = xMin, xMax, sampleSpacing do
		local height1 = getGroundHeight(x, zMin)
		if height1 > -1000 then
			if height1 > maxHeight then
				maxHeight = height1
			end
			hitCount = hitCount + 1
		end
		local height2 = getGroundHeight(x, zMax)
		if height2 > -1000 then
			if height2 > maxHeight then
				maxHeight = height2
			end
			hitCount = hitCount + 1
		end
	end
	
	-- Sample corners
	local corners = {
		{xMin, zMin}, {xMax, zMin},
		{xMin, zMax}, {xMax, zMax}
	}
	for _, corner in ipairs(corners) do
		local height = getGroundHeight(corner[1], corner[2])
		if height > -1000 then
			if height > maxHeight then
				maxHeight = height
			end
			hitCount = hitCount + 1
		end
	end
	
	-- If we didn't find any valid terrain hits, try a more aggressive search
	if maxHeight == -math.huge or hitCount == 0 then
		-- Try sampling at the center and corners more densely
		local centerX = (xMin + xMax) / 2
		local centerZ = (zMin + zMax) / 2
		local testPoints = {
			{centerX, centerZ},
			{xMin, zMin}, {xMax, zMin},
			{xMin, zMax}, {xMax, zMax},
			{centerX, zMin}, {centerX, zMax},
			{xMin, centerZ}, {xMax, centerZ}
		}
		for _, point in ipairs(testPoints) do
			local height = getGroundHeight(point[1], point[2])
			if height > -1000 then
				if height > maxHeight then
					maxHeight = height
				end
			end
		end
	end
	
	-- Return MAXIMUM height so floor covers both flat areas and hills
	return maxHeight
end

-- Function to get the vertical range for zone floors
local function getZoneFloorRange()
	-- Find a zone wall to get its dimensions
	local wallNames = {"TeamABaseZoneWall", "TeamAMidpointZoneWall", "TeamBMidpointZoneWall", "TeamBBaseZoneWall"}
	local sampleWall = nil
	for _, name in ipairs(wallNames) do
		sampleWall = workspace:FindFirstChild(name, true)
		if sampleWall and sampleWall:IsA("BasePart") then
			break
		end
	end
	
	local wallTop = 201  -- Default if wall not found
	local wallBottom = -60  -- Default if wall not found
	
	if sampleWall then
		-- Wall center Y + half height = top
		wallTop = sampleWall.Position.Y + sampleWall.Size.Y / 2
		-- Wall center Y - half height = bottom
		wallBottom = sampleWall.Position.Y - sampleWall.Size.Y / 2
	end
	
	-- Find baseplate to get its bottom
	local baseplate = workspace:FindFirstChild("Baseplate", true) or workspace:FindFirstChild("BasePlate", true)
	local baseplateBottom = -16  -- Default
	if baseplate and baseplate:IsA("BasePart") then
		baseplateBottom = baseplate.Position.Y - baseplate.Size.Y / 2
	end
	
	-- Floor should span from the lower of baseplate bottom or wall bottom, to wall top
	-- This ensures it covers from the bottom of the map (baseplate) to the top (wall top)
	local floorBottom = math.min(baseplateBottom, wallBottom)
	
	return floorBottom, wallTop
end

-- Function to subdivide a floor into vertical segments that follow terrain
local function subdivideFloorToTerrain(floor)
	local segmentSize = 10 -- Size of each floor segment in studs (X and Z)
	local floorSizeX = floor.Size.X
	local floorSizeZ = floor.Size.Z
	local floorCenterX = floor.Position.X
	local floorCenterZ = floor.Position.Z
	local floorColor = floor.Color
	local floorMaterial = floor.Material
	local floorTransparency = floor.Transparency
	
	-- Get the vertical range (bottom to top)
	local floorBottom, floorTop = getZoneFloorRange()
	local totalHeight = floorTop - floorBottom
	
	-- Calculate grid dimensions
	local segmentsX = math.ceil(floorSizeX / segmentSize)
	local segmentsZ = math.ceil(floorSizeZ / segmentSize)
	
	-- Store original floor properties for reference
	local originalName = floor.Name
	local floorParent = floor.Parent
	
	-- Hide or remove the original flat floor
	floor.Transparency = 1
	floor.CanCollide = false
	floor.CanQuery = false
	floor.CanTouch = false
	
	-- Create a folder to hold the segments
	local segmentFolder = floorParent:FindFirstChild(originalName .. "_Segments")
	if segmentFolder then
		segmentFolder:Destroy() -- Remove old segments if re-running
	end
	segmentFolder = Instance.new("Folder")
	segmentFolder.Name = originalName .. "_Segments"
	segmentFolder.Parent = floorParent
	
	print("  Creating " .. (segmentsX * segmentsZ) .. " vertical segments (from Y=" .. floorBottom .. " to Y=" .. floorTop .. ")...")
	
	-- Create segments in a grid
	for i = 0, segmentsX - 1 do
		for j = 0, segmentsZ - 1 do
			-- Calculate segment position
			local segmentX = floorCenterX - floorSizeX/2 + (i + 0.5) * segmentSize
			local segmentZ = floorCenterZ - floorSizeZ/2 + (j + 0.5) * segmentSize
			
			-- Get terrain height at this segment's center (for the top surface)
			local terrainHeight = getGroundHeight(segmentX, segmentZ)
			
			-- Fallback if no terrain found (check for invalid values)
			if terrainHeight <= -1000 then
				local baseplate = workspace:FindFirstChild("Baseplate", true) or workspace:FindFirstChild("BasePlate", true)
				if baseplate and baseplate:IsA("BasePart") then
					terrainHeight = baseplate.Position.Y + baseplate.Size.Y / 2
				else
					terrainHeight = 0
				end
			end
			
			-- Calculate segment height: from baseplate bottom to max of terrain or wall top
			-- Always extend to at least wall top, but go higher if terrain is above that
			local segmentTop = math.max(terrainHeight, floorTop)  -- Top surface follows terrain, but at least reaches wall top
			local segmentBottom = floorBottom
			local segmentHeight = segmentTop - segmentBottom
			local segmentCenterY = (segmentTop + segmentBottom) / 2
			
			-- Create vertical segment part
			local segment = Instance.new("Part")
			segment.Name = originalName .. "_Segment_" .. i .. "_" .. j
			segment.Size = Vector3.new(segmentSize, segmentHeight, segmentSize)
			segment.Position = Vector3.new(segmentX, segmentCenterY, segmentZ)
			segment.Anchored = true
			segment.CanCollide = false
			segment.CanQuery = false
			segment.CanTouch = false
			segment.Transparency = 1  -- Fully translucent
			segment.Material = floorMaterial
			segment.Color = floorColor
			segment.Parent = segmentFolder
			
			-- Add the same tag as the original floor
			local tag = Instance.new("StringValue")
			tag.Name = "ZonePart"
			tag.Value = "true"
			tag.Parent = segment
		end
	end
	
	return segmentFolder
end

-- Process each zone floor
print("=== Aligning ZoneFloors to Terrain ===")
print("Building filter list (excluding Models like Trees)...")
for _, floorName in ipairs(zoneFloorNames) do
	-- Search recursively in case floors are in folders
	local floor = workspace:FindFirstChild(floorName, true)
	if floor and floor:IsA("BasePart") then
		print("Processing " .. floorName .. "...")
		
		-- Subdivide the floor into segments that follow terrain
		local segmentFolder = subdivideFloorToTerrain(floor)
		print("  ✓ " .. floorName .. " subdivided into terrain-following segments")
	else
		warn("Could not find " .. floorName)
	end
end

print("=== Alignment Complete! ===")
print("Note: Original floors are hidden. Segments are in folders named '[FloorName]_Segments'")

