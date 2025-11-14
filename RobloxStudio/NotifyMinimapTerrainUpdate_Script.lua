-- NOTIFY MINIMAP TERRAIN UPDATE - Server Script
-- Place this in ServerScriptService
-- This script fires a RemoteEvent when terrain generation completes
-- The minimap will listen for this event and update automatically

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create or find RemoteEvent
local terrainUpdateEvent = ReplicatedStorage:FindFirstChild("TerrainUpdateEvent")
if not terrainUpdateEvent then
	terrainUpdateEvent = Instance.new("RemoteEvent")
	terrainUpdateEvent.Name = "TerrainUpdateEvent"
	terrainUpdateEvent.Parent = ReplicatedStorage
	print("  ✓ Created TerrainUpdateEvent RemoteEvent")
end

-- Function to notify minimap that terrain has been updated
-- Call this function from your terrain generation script after terrain is created
local function notifyMinimapTerrainUpdate()
	print("  📢 Notifying clients that terrain has been updated...")
	terrainUpdateEvent:FireAllClients()
end

-- Export the function so it can be called from other scripts
-- Usage: require(script).notifyMinimapTerrainUpdate()
return {
	notifyMinimapTerrainUpdate = notifyMinimapTerrainUpdate
}

