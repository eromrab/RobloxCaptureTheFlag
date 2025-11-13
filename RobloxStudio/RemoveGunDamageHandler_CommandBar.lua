-- REMOVE GUN DAMAGE HANDLER - Command Bar Script
-- This removes or disables the GunDamageHandler script

local ServerScriptService = game:GetService("ServerScriptService")
local gunDamageHandler = ServerScriptService:FindFirstChild("GunDamageHandler")

if not gunDamageHandler then
	print("GunDamageHandler script not found - it may already be removed")
	return
end

print("=== Removing GunDamageHandler ===")
print("Script found: " .. gunDamageHandler.Name)
print("Script type: " .. gunDamageHandler.ClassName)

-- Option 1: Delete it completely
print("\n🗑️ Deleting GunDamageHandler script...")
gunDamageHandler:Destroy()
print("✓ GunDamageHandler script deleted")

print("\n✅ Done! The error should no longer appear.")
print("💡 If you need it back later, you can recreate it or restore from backup")

