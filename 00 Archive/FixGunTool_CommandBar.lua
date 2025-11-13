-- COPY AND PASTE THIS INTO ROBLOX STUDIO'S COMMAND BAR (View > Command Bar, or press Ctrl+`)
-- This will create a Handle part for your gun tool

local toolName = "YourGunTool" -- Change this to your actual gun tool name if different
local tool = game.StarterPack:FindFirstChild(toolName) or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolName)

if tool then
	local handle = tool:FindFirstChild("Handle")
	if not handle then
		handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(0.2, 0.2, 1)
		handle.Transparency = 1
		handle.CanCollide = false
		handle.Parent = tool
		print("✓ Created Handle for " .. tool.Name)
	else
		print("✓ Handle already exists for " .. tool.Name)
	end
else
	warn("✗ Could not find " .. toolName)
	warn("Make sure the tool name is correct, or add Handle manually:")
	warn("1. Select your gun tool in StarterPack")
	warn("2. Insert a Part, rename to 'Handle'")
	warn("3. Set Transparency = 1, CanCollide = false")
end

