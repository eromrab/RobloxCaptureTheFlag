-- STOP BOT SPAWNING - Command Bar Version
-- Paste this to stop all bot spawning loops
-- This cleans up any running spawn loops

-- Clear visual separator (can't actually clear output, but this helps)
print("\n\n\n\n\n\n\n\n\n\n")
print("═══════════════════════════════════════════════════════════════")
print("                    STOPPING BOT SPAWNING")
print("═══════════════════════════════════════════════════════════════")
print("")

-- Stop the continuous spawning loop by destroying and recreating the flag
-- This ensures ALL spawn loops see the change, even if they cached the old flag
local spawnFlag = workspace:FindFirstChild("BotSpawningEnabled")
if spawnFlag then
	-- Destroy the old flag completely - this forces all loops to see the change
	spawnFlag:Destroy()
	print("✓ Old flag destroyed")
end

-- Create a new flag set to false
spawnFlag = Instance.new("BoolValue")
spawnFlag.Name = "BotSpawningEnabled"
spawnFlag.Value = false
spawnFlag.Parent = workspace
print("✓ New flag created and set to FALSE")
print("  All spawn loops should stop within 0.5 seconds")

-- Wait a moment and verify
task.wait(0.2)
if spawnFlag.Value == false then
	print("✓ Flag confirmed as false - spawning should be stopped")
else
	warn("⚠ CRITICAL: Flag is somehow true! This shouldn't happen.")
	spawnFlag.Value = false
end

-- Alternative: Delete all bots to stop the visual effect
local deletedCount = 0
for _, obj in ipairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (obj.Name:find("_Bot_") or obj.Name:find("Red_Bot") or obj.Name:find("Blue_Bot")) then
		obj:Destroy()
		deletedCount = deletedCount + 1
	end
end

if deletedCount > 0 then
	print("🗑️ Deleted " .. deletedCount .. " bot(s) from workspace")
else
	print("No bots found to delete")
end

print("")
print("═══════════════════════════════════════════════════════════════")
print("                          DONE")
print("═══════════════════════════════════════════════════════════════")
print("")
print("💡 Tips:")
print("   • To restart spawning, run SmartBotSpawner_CommandBar.lua again")
print("   • To clear Output: right-click Output panel → 'Clear' or Ctrl+L")
print("")

