-- Command code to get/set block size and realign walls and floors
-- Run this in Command Bar or as a script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Try to get BlockConfig
local blockConfig = ReplicatedStorage:FindFirstChild("BlockConfig")
local currentBlockSize = nil

if blockConfig then
	local success, config = pcall(function()
		return require(blockConfig)
	end)
	
	if success and config and config.BlockSize then
		currentBlockSize = config.BlockSize
		print("=== CURRENT BLOCK SIZE ===")
		print("BlockSize: " .. tostring(currentBlockSize))
		print("")
	else
		warn("Could not read BlockConfig.BlockSize")
	end
else
	warn("BlockConfig not found in ReplicatedStorage")
end

-- Option to set block size to 1
print("=== OPTIONS ===")
print("1. Keep current size: " .. tostring(currentBlockSize or "unknown"))
print("2. Set to 1 and realign everything")
print("")

-- Function to align position to grid boundary
local function alignToGridBoundary(position, blockSize)
	return Vector3.new(
		math.floor(position.X / blockSize) * blockSize,
		position.Y,  -- Keep Y the same
		math.floor(position.Z / blockSize) * blockSize
	end)
end

-- Function to realign a part
local function realignPart(partName, blockSize)
	local part = workspace:FindFirstChild(partName)
	if not part then
		warn("Could not find " .. partName)
		return nil
	end
	
	local oldPos = part.Position
	local newPos = alignToGridBoundary(oldPos, blockSize)
	part.Position = newPos
	
	print(string.format("%s: %s -> %s (offset: %s)", 
		partName, 
		oldPos.X, 
		newPos.X, 
		math.abs(oldPos.X - newPos.X)
	))
	
	return newPos
end

-- Option to set BlockSize to 1
local targetBlockSize = currentBlockSize or 1
if not currentBlockSize then
	print("BlockSize not found - will use 1 for alignment")
	print("To set BlockSize to 1, edit BlockConfig module in ReplicatedStorage")
	print("")
end

-- Realign all zone parts
if targetBlockSize then
	print("=== REALIGNING WITH BLOCK SIZE: " .. targetBlockSize .. " ===")
	print("")
	
	-- Realign walls
	realignPart("TeamABaseZoneWall", targetBlockSize)
	realignPart("TeamAMidpointZoneWall", targetBlockSize)
	realignPart("TeamBMidpointZoneWall", targetBlockSize)
	realignPart("TeamBBaseZoneWall", targetBlockSize)
	print("")
	
	-- Realign floors (they're centered, so we need to recalculate)
	local function realignFloor(floorName, xMin, xMax, blockSize)
		local floor = workspace:FindFirstChild(floorName)
		if not floor then return end
		
		local alignedMin = math.floor(xMin / blockSize) * blockSize
		local alignedMax = math.floor(xMax / blockSize) * blockSize
		local newCenterX = (alignedMin + alignedMax) / 2
		local newSizeX = alignedMax - alignedMin
		
		floor.Size = Vector3.new(newSizeX, floor.Size.Y, floor.Size.Z)
		floor.Position = Vector3.new(newCenterX, floor.Position.Y, floor.Position.Z)
		
		print(string.format("%s: X range %s-%s -> %s-%s", 
			floorName, xMin, xMax, alignedMin, alignedMax
		))
	end
	
	realignFloor("TeamABaseFloor", -166, 34, targetBlockSize)
	realignFloor("TeamAZoneFloor", 34, 200, targetBlockSize)
	realignFloor("NeutralZoneFloor", 200, 558, targetBlockSize)
	realignFloor("TeamBZoneFloor", 558, 729, targetBlockSize)
	realignFloor("TeamBBaseFloor", 729, 947, targetBlockSize)
	
	print("")
	print("=== REALIGNMENT COMPLETE ===")
	print("Save your place to make changes permanent!")
	print("")
	print("NOTE: If BlockSize is not 1, you may need to:")
	print("1. Open ReplicatedStorage > BlockConfig module")
	print("2. Change BlockSize to 1")
	print("3. Run this script again to realign with BlockSize = 1")
end

