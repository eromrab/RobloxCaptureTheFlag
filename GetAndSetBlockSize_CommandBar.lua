-- COPY AND PASTE THIS INTO COMMAND BAR (one block at a time if needed)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local blockConfig = ReplicatedStorage:FindFirstChild("BlockConfig")
local currentBlockSize = nil
if blockConfig then
	local success, config = pcall(function() return require(blockConfig) end)
	if success and config and config.BlockSize then
		currentBlockSize = config.BlockSize
		print("=== CURRENT BLOCK SIZE ===")
		print("BlockSize: " .. tostring(currentBlockSize))
	end
end
local targetBlockSize = currentBlockSize or 1
if not currentBlockSize then print("BlockSize not found - using 1") end
local function alignToGridBoundary(pos, size)
	return Vector3.new(math.floor(pos.X / size) * size, pos.Y, math.floor(pos.Z / size) * size)
end
local function realignPart(name, size)
	local part = workspace:FindFirstChild(name)
	if not part then warn("Could not find " .. name) return end
	local oldPos = part.Position
	local newPos = alignToGridBoundary(oldPos, size)
	part.Position = newPos
	print(string.format("%s: %s -> %s", name, oldPos.X, newPos.X))
end
local function realignFloor(name, xMin, xMax, size)
	local floor = workspace:FindFirstChild(name)
	if not floor then return end
	local alignedMin = math.floor(xMin / size) * size
	local alignedMax = math.floor(xMax / size) * size
	floor.Size = Vector3.new(alignedMax - alignedMin, floor.Size.Y, floor.Size.Z)
	floor.Position = Vector3.new((alignedMin + alignedMax) / 2, floor.Position.Y, floor.Position.Z)
	print(string.format("%s: %s-%s -> %s-%s", name, xMin, xMax, alignedMin, alignedMax))
end
print("=== REALIGNING WITH BLOCK SIZE: " .. targetBlockSize .. " ===")
realignPart("TeamABaseZoneWall", targetBlockSize)
realignPart("TeamAMidpointZoneWall", targetBlockSize)
realignPart("TeamBMidpointZoneWall", targetBlockSize)
realignPart("TeamBBaseZoneWall", targetBlockSize)
realignFloor("TeamABaseFloor", -166, 34, targetBlockSize)
realignFloor("TeamAZoneFloor", 34, 200, targetBlockSize)
realignFloor("NeutralZoneFloor", 200, 558, targetBlockSize)
realignFloor("TeamBZoneFloor", 558, 729, targetBlockSize)
realignFloor("TeamBBaseFloor", 729, 947, targetBlockSize)
print("=== REALIGNMENT COMPLETE ===")
print("Save your place to make changes permanent!")

