-- COMPLETE ZONE REPLACEMENT SCRIPT
-- This script does BOTH cleanup and creation in one go
-- 1. Deletes all segmented zone parts and old zone floors/walls
-- 2. Creates 5 new consolidated zones (one per area)
-- Run this in Roblox Studio Command Bar or as a script

print("=== REPLACING ZONES WITH CONSOLIDATED VERSION ===")
print("")

-- ============================================
-- PART 1: CLEANUP
-- ============================================
print("--- STEP 1: Cleaning up old zones ---")

local deletedCount = 0

-- Function to safely delete an object
local function safeDelete(obj, name)
	if obj then
		obj:Destroy()
		deletedCount = deletedCount + 1
		return true
	end
	return false
end

-- Delete all segment folders and their contents
local segmentFolderNames = {
	"TeamABaseFloor_Segments",
	"TeamAZoneFloor_Segments",
	"NeutralZoneFloor_Segments",
	"TeamBZoneFloor_Segments",
	"TeamBBaseFloor_Segments"
}

-- Function to recursively search and delete segment folders
local function deleteSegmentFolders(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("Folder") and string.find(obj.Name, "_Segments") then
			local segmentCount = #obj:GetChildren()
			obj:Destroy()
			deletedCount = deletedCount + 1
			print("  ✓ Deleted: " .. obj.Name .. " (" .. segmentCount .. " segments)")
		end
	end
end

-- Search in ZoneParts folder first (where segments are likely located)
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if zonePartsFolder then
	for _, folderName in ipairs(segmentFolderNames) do
		local folder = zonePartsFolder:FindFirstChild(folderName)
		if folder then
			local segmentCount = #folder:GetChildren()
			folder:Destroy()
			deletedCount = deletedCount + 1
			print("  ✓ Deleted: " .. folderName .. " (" .. segmentCount .. " segments)")
		end
	end
	-- Also search for any other segment folders in ZoneParts
	deleteSegmentFolders(zonePartsFolder)
end

-- Also search directly in workspace (for backwards compatibility)
for _, folderName in ipairs(segmentFolderNames) do
	local folder = workspace:FindFirstChild(folderName)
	if folder then
		local segmentCount = #folder:GetChildren()
		folder:Destroy()
		deletedCount = deletedCount + 1
		print("  ✓ Deleted: " .. folderName .. " (" .. segmentCount .. " segments)")
	end
end

-- Search for any other segment folders in workspace
deleteSegmentFolders(workspace)

-- Delete all old zone floor parts
local zoneFloorNames = {
	"TeamABaseFloor",
	"TeamAZoneFloor",
	"NeutralZoneFloor",
	"TeamBZoneFloor",
	"TeamBBaseFloor"
}

for _, floorName in ipairs(zoneFloorNames) do
	local floor = workspace:FindFirstChild(floorName)
	if safeDelete(floor, floorName) then
		print("  ✓ Deleted: " .. floorName)
	end
end

-- Delete all old zone wall parts
local zoneWallNames = {
	"TeamABaseZoneWall",
	"TeamAMidpointZoneWall",
	"TeamBMidpointZoneWall",
	"TeamBBaseZoneWall"
}

for _, wallName in ipairs(zoneWallNames) do
	local wall = workspace:FindFirstChild(wallName)
	if safeDelete(wall, wallName) then
		print("  ✓ Deleted: " .. wallName)
	end
end

-- Delete any loose segment parts
-- Search in workspace
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("BasePart") and string.find(obj.Name, "_Segment_") then
		if safeDelete(obj, obj.Name) then
			print("  ✓ Deleted: " .. obj.Name)
		end
	end
end
-- Search in ZoneParts folder
if zonePartsFolder then
	for _, obj in ipairs(zonePartsFolder:GetChildren()) do
		if obj:IsA("BasePart") and string.find(obj.Name, "_Segment_") then
			if safeDelete(obj, obj.Name) then
				print("  ✓ Deleted: " .. obj.Name)
			end
		end
	end
end

-- Delete any old consolidated zones (in case re-running)
local oldZoneNames = {
	"Zone1_Base",
	"Zone2_Defend",
	"Zone3_Neutral",
	"Zone4_Defend",
	"Zone5_Base"
}

for _, zoneName in ipairs(oldZoneNames) do
	local zone = workspace:FindFirstChild(zoneName)
	if safeDelete(zone, zoneName) then
		print("  ✓ Deleted: " .. zoneName)
	end
end

print("  Cleanup complete: " .. deletedCount .. " objects deleted")
print("")

-- ============================================
-- PART 2: CREATE NEW CONSOLIDATED ZONES
-- ============================================
print("--- STEP 2: Creating 5 consolidated zones ---")

-- Zone boundaries (based on existing wall positions)
-- Map spans from X = -166 to X = 947 (from Baseplate)
local ZONE_BOUNDARIES = {
	-- Zone 1: Base (Team A Base)
	{
		name = "Zone1_Base",
		xMin = -166,
		xMax = 32,  -- TeamABaseZoneWall position
		color = Color3.new(0.2, 0.4, 0.8),  -- Blue
		zoneType = "Base"
	},
	-- Zone 2: Defend (Team A Zone)
	{
		name = "Zone2_Defend",
		xMin = 32,  -- TeamABaseZoneWall position
		xMax = 200,  -- TeamAMidpointZoneWall position
		color = Color3.new(0.3, 0.5, 0.9),  -- Light Blue
		zoneType = "Defend"
	},
	-- Zone 3: Neutral
	{
		name = "Zone3_Neutral",
		xMin = 200,  -- TeamAMidpointZoneWall position
		xMax = 556,  -- TeamBMidpointZoneWall position
		color = Color3.new(1, 0.2, 0.2),  -- Red
		zoneType = "Neutral"
	},
	-- Zone 4: Defend (Team B Zone)
	{
		name = "Zone4_Defend",
		xMin = 556,  -- TeamBMidpointZoneWall position
		xMax = 728,  -- TeamBBaseZoneWall position
		color = Color3.new(0.3, 0.5, 0.9),  -- Light Blue
		zoneType = "Defend"
	},
	-- Zone 5: Base (Team B Base)
	{
		name = "Zone5_Base",
		xMin = 728,  -- TeamBBaseZoneWall position
		xMax = 947,  -- Map edge
		color = Color3.new(0.2, 0.4, 0.8),  -- Blue
		zoneType = "Base"
	}
}

-- Common zone properties
local ZONE_HEIGHT = 261  -- Full height (same as walls)
local ZONE_DEPTH = 260   -- Full depth (same as baseplate)
local ZONE_CENTER_Z = 84  -- Center Z position (same as baseplate)

-- Function to create a single zone
local function createZone(zoneData)
	-- Calculate zone dimensions
	local zoneWidth = zoneData.xMax - zoneData.xMin
	local zoneCenterX = (zoneData.xMin + zoneData.xMax) / 2
	
	-- Create the zone part
	local zone = Instance.new("Part")
	zone.Name = zoneData.name
	zone.Size = Vector3.new(zoneWidth, ZONE_HEIGHT, ZONE_DEPTH)
	zone.Position = Vector3.new(zoneCenterX, ZONE_HEIGHT / 2, ZONE_CENTER_Z)
	zone.Rotation = Vector3.new(0, 0, 0)
	zone.Anchored = true
	zone.CanCollide = false  -- Non-collidable
	zone.CanQuery = false    -- Invisible to queries
	zone.CanTouch = false    -- Invisible to touch events
	zone.Transparency = 1.0  -- Completely invisible
	zone.CastShadow = false  -- No shadow casting
	zone.Material = Enum.Material.Neon
	zone.Color = zoneData.color
	
	-- Add zone metadata
	local zoneTypeValue = Instance.new("StringValue")
	zoneTypeValue.Name = "ZoneType"
	zoneTypeValue.Value = zoneData.zoneType
	zoneTypeValue.Parent = zone
	
	-- Add tag for identification
	local zoneTag = Instance.new("StringValue")
	zoneTag.Name = "ZonePart"
	zoneTag.Value = "true"
	zoneTag.Parent = zone
	
	-- Parent to workspace
	zone.Parent = workspace
	
	print("  ✓ Created: " .. zoneData.name .. " (" .. zoneData.zoneType .. ")")
	return zone
end

-- Create all 5 zones
for _, zoneData in ipairs(ZONE_BOUNDARIES) do
	createZone(zoneData)
end

print("")
print("=== COMPLETE ===")
print("Old segmented zones removed: " .. deletedCount .. " objects")
print("New consolidated zones created: 5 zones")
print("Zones: Zone1_Base, Zone2_Defend, Zone3_Neutral, Zone4_Defend, Zone5_Base")

