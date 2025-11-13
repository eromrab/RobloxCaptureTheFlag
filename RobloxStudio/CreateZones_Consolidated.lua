-- CONSOLIDATED ZONE CREATION SCRIPT
-- Creates 5 single zones (one per area) instead of multiple zone parts
-- Based on GameMap.txt: Base, Defend, Neutral, Defend, Base
-- Run this in Roblox Studio Command Bar or as a script
-- 
-- IMPORTANT: Run CleanupZoneSegments.lua FIRST to remove old segmented zones

print("=== Creating 5 Consolidated Zones ===")

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
	-- Check if zone already exists
	local existingZone = workspace:FindFirstChild(zoneData.name)
	if existingZone then
		print("  ⚠ " .. zoneData.name .. " already exists, skipping...")
		return existingZone
	end
	
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
	
	print("  ✓ Created " .. zoneData.name .. " (" .. zoneData.zoneType .. ")")
	return zone
end

-- Create all 5 zones
for _, zoneData in ipairs(ZONE_BOUNDARIES) do
	createZone(zoneData)
end

print("=== All 5 zones created successfully ===")
print("Zones: Zone1_Base, Zone2_Defend, Zone3_Neutral, Zone4_Defend, Zone5_Base")

