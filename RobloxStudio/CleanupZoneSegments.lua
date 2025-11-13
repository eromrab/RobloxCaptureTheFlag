-- CLEANUP SCRIPT: Remove all segmented zone parts and old zone floors/walls
-- Run this BEFORE creating the new consolidated zones
-- Paste this into Roblox Studio Command Bar or run as a script

print("=== Cleaning up old zone segments and parts ===")

local deletedCount = 0

-- Function to safely delete an object
local function safeDelete(obj, name)
	if obj then
		obj:Destroy()
		deletedCount = deletedCount + 1
		print("  ✓ Deleted: " .. name)
		return true
	end
	return false
end

-- 1. Delete all segment folders and their contents
print("\n--- Deleting zone segment folders ---")
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
			print("  ✓ Deleted folder: " .. obj.Name .. " (contained " .. segmentCount .. " segments)")
		end
	end
end

-- Search in ZoneParts folder first (where segments are likely located)
local zonePartsFolder = workspace:FindFirstChild("ZoneParts")
if zonePartsFolder then
	print("  Searching in ZoneParts folder...")
	for _, folderName in ipairs(segmentFolderNames) do
		local folder = zonePartsFolder:FindFirstChild(folderName)
		if folder then
			local segmentCount = #folder:GetChildren()
			folder:Destroy()
			deletedCount = deletedCount + 1
			print("  ✓ Deleted folder: " .. folderName .. " (contained " .. segmentCount .. " segments)")
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
		print("  ✓ Deleted folder: " .. folderName .. " (contained " .. segmentCount .. " segments)")
	end
end

-- Search for any other segment folders that might exist in workspace
deleteSegmentFolders(workspace)

-- 2. Delete all old zone floor parts
print("\n--- Deleting old zone floor parts ---")
local zoneFloorNames = {
	"TeamABaseFloor",
	"TeamAZoneFloor",
	"NeutralZoneFloor",
	"TeamBZoneFloor",
	"TeamBBaseFloor"
}

for _, floorName in ipairs(zoneFloorNames) do
	local floor = workspace:FindFirstChild(floorName)
	safeDelete(floor, floorName)
end

-- 3. Delete all old zone wall parts
print("\n--- Deleting old zone wall parts ---")
local zoneWallNames = {
	"TeamABaseZoneWall",
	"TeamAMidpointZoneWall",
	"TeamBMidpointZoneWall",
	"TeamBBaseZoneWall"
}

for _, wallName in ipairs(zoneWallNames) do
	local wall = workspace:FindFirstChild(wallName)
	safeDelete(wall, wallName)
end

-- 4. Delete any individual segment parts that might be loose
print("\n--- Deleting any loose segment parts ---")
-- Search in workspace
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("BasePart") and string.find(obj.Name, "_Segment_") then
		safeDelete(obj, obj.Name)
	end
end
-- Search in ZoneParts folder
if zonePartsFolder then
	for _, obj in ipairs(zonePartsFolder:GetChildren()) do
		if obj:IsA("BasePart") and string.find(obj.Name, "_Segment_") then
			safeDelete(obj, obj.Name)
		end
	end
end

-- 5. Delete any old consolidated zones if they exist (in case re-running)
print("\n--- Cleaning up old consolidated zones (if any) ---")
local oldZoneNames = {
	"Zone1_Base",
	"Zone2_Defend",
	"Zone3_Neutral",
	"Zone4_Defend",
	"Zone5_Base"
}

for _, zoneName in ipairs(oldZoneNames) do
	local zone = workspace:FindFirstChild(zoneName)
	safeDelete(zone, zoneName)
end

print("\n=== Cleanup complete ===")
print("Total objects deleted: " .. deletedCount)
print("\nYou can now run CreateZones_Consolidated.lua to create the 5 new zones")

