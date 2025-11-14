-- Script to add bullet marks (decals) to Target01 when shot
-- Place this in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Configuration
local TARGET_NAME = "Target01"
local BULLET_MARK_DECAL_ID = "rbxassetid://1316045217" -- Default bullet hole decal (you can change this)
local MAX_MARKS_PER_PART = 50 -- Maximum number of marks on a single part before removing oldest

-- Find the target
local function findTarget()
	return workspace:FindFirstChild(TARGET_NAME, true)
end

-- Helper function to convert NormalId to Vector3
local function normalIdToVector3(normalId)
	if normalId == Enum.NormalId.Front then
		return Vector3.new(0, 0, -1)
	elseif normalId == Enum.NormalId.Back then
		return Vector3.new(0, 0, 1)
	elseif normalId == Enum.NormalId.Top then
		return Vector3.new(0, 1, 0)
	elseif normalId == Enum.NormalId.Bottom then
		return Vector3.new(0, -1, 0)
	elseif normalId == Enum.NormalId.Left then
		return Vector3.new(-1, 0, 0)
	elseif normalId == Enum.NormalId.Right then
		return Vector3.new(1, 0, 0)
	end
	return Vector3.new(0, 0, -1) -- Default to Front
end

-- Create a bullet mark decal on a part at the hit position
local function createBulletMark(hitPart, hitPosition, hitNormal)
	if not hitPart or not hitPart:IsA("BasePart") then
		return
	end
	
	-- Determine which face was hit based on the normal
	local face = Enum.NormalId.Front
	local normal = hitNormal or Vector3.new(0, 0, -1)
	
	-- Find the face closest to the hit normal
	local maxDot = -math.huge
	for _, normalId in ipairs({Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Top, Enum.NormalId.Bottom, Enum.NormalId.Left, Enum.NormalId.Right}) do
		local faceNormal = normalIdToVector3(normalId)
		local dot = normal:Dot(faceNormal)
		if dot > maxDot then
			maxDot = dot
			face = normalId
		end
	end
	
	-- Create the decal
	local decal = Instance.new("Decal")
	decal.Texture = BULLET_MARK_DECAL_ID
	decal.Face = face
	decal.Transparency = 0
	decal.Name = "BulletMark_" .. tick()
	decal.Parent = hitPart
	
	-- Position the decal at the hit location
	-- Note: Decals are positioned relative to the part's center
	local partCFrame = hitPart.CFrame
	local partSize = hitPart.Size
	local hitLocal = partCFrame:PointToObjectSpace(hitPosition)
	
	-- Calculate UV offset based on hit position
	-- This is approximate - decals cover the whole face
	-- For more precise positioning, you'd need to use a SurfaceGui with an ImageLabel
	
	-- Clean up old marks if we have too many
	local marks = {}
	for _, child in ipairs(hitPart:GetChildren()) do
		if child:IsA("Decal") and child.Name:find("BulletMark_") then
			table.insert(marks, child)
		end
	end
	
	if #marks > MAX_MARKS_PER_PART then
		-- Sort by creation time (name contains tick())
		table.sort(marks, function(a, b)
			local timeA = tonumber(a.Name:match("BulletMark_(%d+%.?%d*)")) or 0
			local timeB = tonumber(b.Name:match("BulletMark_(%d+%.?%d*)")) or 0
			return timeA < timeB
		end)
		
		-- Remove oldest marks
		for i = 1, #marks - MAX_MARKS_PER_PART do
			marks[i]:Destroy()
		end
	end
	
	return decal
end

-- Method 1: Listen for Touched events on target parts
local function setupTouchedDetection()
	local target = findTarget()
	if not target then
		return
	end
	
	for _, part in ipairs(target:GetDescendants()) do
		if part:IsA("BasePart") and part.CanTouch then
			part.Touched:Connect(function(hit)
				-- Check if it's a bullet or projectile
				-- This is a simple check - you may need to adjust based on your gun system
				if hit and hit.Parent then
					local isBullet = hit.Name:find("Bullet") or hit.Name:find("Projectile") or hit.Name:find("Ray")
					
					-- Alternative: Check if hit by a fast-moving small part (typical bullet behavior)
					local velocity = hit.AssemblyLinearVelocity
					if velocity and velocity.Magnitude > 50 then -- Bullets move fast
						local contactPoint = part.CFrame:PointToObjectSpace(hit.Position)
						local normal = (hit.Position - part.Position).Unit
						createBulletMark(part, hit.Position, normal)
					end
				end
			end)
		end
	end
end

-- Method 2: Listen for RemoteEvents (if your gun system uses them)
local function setupRemoteEventDetection()
	local target = findTarget()
	if not target then
		return
	end
	
	-- Check for common remote event names
	local remoteNames = {"GunHit", "BulletHit", "OnHit", "ShootHit", "DamageHit"}
	
	for _, remoteName in ipairs(remoteNames) do
		local remote = ReplicatedStorage:FindFirstChild(remoteName)
		if remote and remote:IsA("RemoteEvent") then
			remote.OnServerEvent:Connect(function(player, hitPart, hitPosition, hitNormal)
				if hitPart and hitPart:IsDescendantOf(target) then
					createBulletMark(hitPart, hitPosition, hitNormal)
				end
			end)
			print("✓ Connected to RemoteEvent: " .. remoteName)
		end
	end
end

-- Method 3: Use a BindableEvent that your gun system can fire
local function createBindableEvent()
	local bindable = Instance.new("BindableEvent")
	bindable.Name = "TargetHit"
	bindable.Parent = ReplicatedStorage
	
	bindable.Event:Connect(function(hitPart, hitPosition, hitNormal)
		if hitPart and hitPart:IsDescendantOf(findTarget()) then
			createBulletMark(hitPart, hitPosition, hitNormal)
		end
	end)
	
	print("✓ Created BindableEvent: ReplicatedStorage.TargetHit")
	print("  Your gun system can fire this with: ReplicatedStorage.TargetHit:Fire(hitPart, hitPosition, hitNormal)")
end

-- Method 4: Hook into gun system by monitoring workspace for hits on Target01
-- This works by checking if any part in Target01 gets hit during raycasts
local function setupWorkspaceHitDetection()
	local target = findTarget()
	if not target then
		return
	end
	
	-- Store target parts for quick lookup
	local targetParts = {}
	for _, part in ipairs(target:GetDescendants()) do
		if part:IsA("BasePart") then
			targetParts[part] = true
		end
	end
	
	-- Monitor for new parts added to target
	target.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			targetParts[descendant] = true
		end
	end)
	
	-- Create a RemoteEvent that gun system can use
	local hitEvent = Instance.new("RemoteEvent")
	hitEvent.Name = "TargetHitEvent"
	hitEvent.Parent = ReplicatedStorage
	
	hitEvent.OnServerEvent:Connect(function(player, hitPart, hitPosition, hitNormal)
		if hitPart and targetParts[hitPart] then
			createBulletMark(hitPart, hitPosition, hitNormal)
		end
	end)
	
	print("✓ Created RemoteEvent: ReplicatedStorage.TargetHitEvent")
	print("  Gun system can call: TargetHitEvent:FireServer(hitPart, hitPosition, hitNormal)")
end

-- Initialize
print("=== Target Bullet Marks System Initialized ===")
print("Target: " .. TARGET_NAME)
print("")

-- Try all detection methods
setupTouchedDetection()
setupRemoteEventDetection()
createBindableEvent()
setupWorkspaceHitDetection()

-- Also check periodically if target exists
RunService.Heartbeat:Connect(function()
	local target = findTarget()
	if not target then
		return
	end
	
	-- Ensure all parts have CanTouch enabled for detection
	for _, part in ipairs(target:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanTouch = true
		end
	end
end)

print("✓ Bullet marks system ready!")
print("  The system will add decals to Target01 when it's hit")
print("")

