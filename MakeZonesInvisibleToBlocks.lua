-- Makes all zone walls and floors invisible to block placement system
-- Run this once after creating the zones, or add to your zone creation scripts
-- This sets properties AND adds tags so the block placement system ignores them

local function makePartInvisibleToBlocks(part)
	-- Set all collision/query properties to false
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	
	-- Add a StringValue tag so the block placement system can identify and ignore it
	local tag = part:FindFirstChild("ZonePart")
	if not tag then
		tag = Instance.new("StringValue")
		tag.Name = "ZonePart"
		tag.Value = "true"
		tag.Parent = part
	end
	
	-- Also add to a folder for easy filtering (optional)
	local zoneFolder = workspace:FindFirstChild("ZoneParts")
	if not zoneFolder then
		zoneFolder = Instance.new("Folder")
		zoneFolder.Name = "ZoneParts"
		zoneFolder.Parent = workspace
	end
	
	-- Don't move the part, just reference it (parts can't be in multiple parents)
	-- The tag is sufficient for identification
	
	print("Made " .. part.Name .. " invisible to blocks")
end

-- Find all zone walls and floors
local zoneParts = {
	"TeamABaseZoneWall",
	"TeamAMidpointZoneWall",
	"TeamBMidpointZoneWall",
	"TeamBBaseZoneWall",
	"TeamABaseFloor",
	"TeamAZoneFloor",
	"NeutralZoneFloor",
	"TeamBZoneFloor",
	"TeamBBaseFloor",
}

for _, partName in ipairs(zoneParts) do
	local part = workspace:FindFirstChild(partName)
	if part and part:IsA("BasePart") then
		makePartInvisibleToBlocks(part)
	else
		warn("Could not find " .. partName)
	end
end

print("=== All zone parts are now invisible to block placement ===")

