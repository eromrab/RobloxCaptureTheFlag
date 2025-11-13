-- Utility script to align zone walls to the block placement grid
-- This ensures walls are at grid boundaries, not splitting blocks

-- CONFIGURE THIS: Set your block size here (common values: 1, 2, 4, 8)
local BLOCK_SIZE = 1  -- Change this to match your BlockConfig.BlockSize

-- Function to align a position to the nearest grid boundary
-- Grid boundaries are at: 0, size, 2*size, 3*size, etc.
-- (Block centers are at: size/2, 3*size/2, 5*size/2, etc.)
local function alignToGridBoundary(position)
	return Vector3.new(
		math.floor(position.X / BLOCK_SIZE) * BLOCK_SIZE,
		position.Y,  -- Keep Y the same
		math.floor(position.Z / BLOCK_SIZE) * BLOCK_SIZE
	)
end

-- Current wall positions
local walls = {
	{name = "TeamABaseZoneWall", pos = Vector3.new(34, 70.5, 84)},
	{name = "MidpointZoneWall", pos = Vector3.new(379.00048828125, 70.5, 84)},
	{name = "TeamBBaseZoneWall", pos = Vector3.new(729.00048828125, 70.5, 84)},
}

print("=== WALL ALIGNMENT ===")
print("Block Size: " .. BLOCK_SIZE)
print("")

for _, wall in ipairs(walls) do
	local aligned = alignToGridBoundary(wall.pos)
	print(string.format("%s:", wall.name))
	print(string.format("  Original:  X = %s", wall.pos.X))
	print(string.format("  Aligned:   X = %s", aligned.X))
	print(string.format("  Offset:    %s studs", math.abs(wall.pos.X - aligned.X)))
	print("")
end

print("=== ALIGNED WALL CODE ===")
print("Copy the updated positions to your wall files:")
print("")

for _, wall in ipairs(walls) do
	local aligned = alignToGridBoundary(wall.pos)
	print(string.format("-- %s", wall.name))
	print(string.format("part.Position = Vector3.new(%s, %s, %s)", aligned.X, aligned.Y, aligned.Z))
	print("")
end

