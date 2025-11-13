-- FIND AND REMOVE GUN DAMAGE HANDLER - Command Bar Script
-- This searches for GunDamageHandler everywhere and removes it

print("=== Searching for GunDamageHandler ===")

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")
local StarterCharacterScripts = StarterPlayer:FindFirstChild("StarterCharacterScripts")

local foundScripts = {}

-- Search ServerScriptService
local script1 = ServerScriptService:FindFirstChild("GunDamageHandler")
if script1 then
	table.insert(foundScripts, {script = script1, location = "ServerScriptService"})
end

-- Search recursively in ServerScriptService
local function searchRecursive(parent, location)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj.Name == "GunDamageHandler" and (obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript")) then
			table.insert(foundScripts, {script = obj, location = location})
		end
		if obj:IsA("Folder") or obj:IsA("Model") then
			searchRecursive(obj, location .. " > " .. obj.Name)
		end
	end
end

searchRecursive(ServerScriptService, "ServerScriptService")
if ReplicatedStorage then searchRecursive(ReplicatedStorage, "ReplicatedStorage") end
if StarterPlayerScripts then searchRecursive(StarterPlayerScripts, "StarterPlayer > StarterPlayerScripts") end
if StarterCharacterScripts then searchRecursive(StarterCharacterScripts, "StarterPlayer > StarterCharacterScripts") end

-- Report findings
if #foundScripts == 0 then
	print("✓ No GunDamageHandler scripts found")
	print("💡 The error might be cached - try restarting Roblox Studio")
else
	print("Found " .. #foundScripts .. " GunDamageHandler script(s):")
	for i, data in ipairs(foundScripts) do
		print("  " .. i .. ". " .. data.location .. " > " .. data.script.Name .. " (" .. data.script.ClassName .. ")")
	end
	
	print("\n🗑️ Deleting all found scripts...")
	for i, data in ipairs(foundScripts) do
		data.script:Destroy()
		print("  ✓ Deleted: " .. data.location .. " > " .. data.script.Name)
	end
	
	print("\n✅ All GunDamageHandler scripts removed!")
	print("💡 Restart Roblox Studio or reload the game to clear the error")
end

