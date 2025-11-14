-- Command Bar script to disable the old minimap system
-- Paste this into Roblox Studio Command Bar

print("=== Disabling Old Minimap System ===")
print("")

local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")

local disabledCount = 0
local removedCount = 0

-- Function to search and disable scripts recursively
local function disableScripts(parent, scriptNames)
	for _, obj in ipairs(parent:GetChildren()) do
		-- Check if this is one of the minimap scripts
		for _, scriptName in ipairs(scriptNames) do
			if obj.Name:find(scriptName) or scriptName:find(obj.Name) then
				if obj:IsA("LocalScript") or obj:IsA("Script") then
					obj.Enabled = false
					disabledCount = disabledCount + 1
					print("  ✓ Disabled: " .. obj:GetFullName())
				end
			end
		end
		-- Recursively search in folders/models
		if obj:IsA("Folder") or obj:IsA("Model") then
			disableScripts(obj, scriptNames)
		end
	end
end

-- Script names to disable
local minimapScriptNames = {
	"CreateMinimap",
	"UpdateMinimap",
	"NotifyMinimapTerrainUpdate"
}

print("🔍 Searching for minimap scripts...")

-- Search in StarterGui
if StarterGui then
	disableScripts(StarterGui, minimapScriptNames)
end

-- Search in StarterPlayerScripts
if StarterPlayerScripts then
	disableScripts(StarterPlayerScripts, minimapScriptNames)
end

-- Also search in ServerScriptService (for server-side minimap scripts)
local ServerScriptService = game:GetService("ServerScriptService")
if ServerScriptService then
	disableScripts(ServerScriptService, minimapScriptNames)
end

print("")
print("🔍 Removing minimap GUI from all players...")

-- Remove minimap GUI from all players
for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	local playerGui = player:FindFirstChild("PlayerGui")
	if playerGui then
		local minimapGui = playerGui:FindFirstChild("Minimap")
		if minimapGui then
			minimapGui:Destroy()
			removedCount = removedCount + 1
			print("  ✓ Removed minimap GUI from " .. player.Name)
		end
	end
end

print("")
print("✓ Disabled " .. disabledCount .. " minimap script(s)")
print("✓ Removed " .. removedCount .. " minimap GUI(s) from players")
print("")
print("💡 The old minimap system has been disabled.")
print("   You can now test the new minimap system.")
print("")
print("💡 To re-enable later, find the scripts and set Enabled = true")

