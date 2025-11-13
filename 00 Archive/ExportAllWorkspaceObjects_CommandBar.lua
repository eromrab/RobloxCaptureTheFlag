-- COMMAND BAR SCRIPT: Exports all workspace objects to Lua files
-- Paste this into Roblox Studio Command Bar (View > Command Bar)
-- This will generate Lua files for all parts, models, and other objects in workspace

local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")

-- Function to generate Lua code for a BasePart
local function generatePartCode(part, indent)
	indent = indent or ""
	local code = {}
	
	table.insert(code, indent .. "local part = Instance.new(\"" .. part.ClassName .. "\")")
	table.insert(code, indent .. "part.Name = \"" .. part.Name:gsub("\"", "\\\"") .. "\"")
	table.insert(code, indent .. "part.Size = Vector3.new(" .. part.Size.X .. ", " .. part.Size.Y .. ", " .. part.Size.Z .. ")")
	table.insert(code, indent .. "part.Position = Vector3.new(" .. part.Position.X .. ", " .. part.Position.Y .. ", " .. part.Position.Z .. ")")
	table.insert(code, indent .. "part.Rotation = Vector3.new(" .. part.Rotation.X .. ", " .. part.Rotation.Y .. ", " .. part.Rotation.Z .. ")")
	table.insert(code, indent .. "part.Anchored = " .. tostring(part.Anchored))
	table.insert(code, indent .. "part.CanCollide = " .. tostring(part.CanCollide))
	table.insert(code, indent .. "part.CanQuery = " .. tostring(part.CanQuery))
	table.insert(code, indent .. "part.CanTouch = " .. tostring(part.CanTouch))
	table.insert(code, indent .. "part.Transparency = " .. tostring(part.Transparency))
	table.insert(code, indent .. "part.Material = Enum.Material." .. tostring(part.Material):match("%.([^%.]+)$"))
	table.insert(code, indent .. "part.Color = Color3.new(" .. part.Color.R .. ", " .. part.Color.G .. ", " .. part.Color.B .. ")")
	
	-- Only Parts have Shape, TopSurface, BottomSurface properties
	-- Use pcall to safely check properties in case of edge cases
	if part:IsA("Part") then
		local success, shape = pcall(function() return part.Shape end)
		if success and shape and shape ~= Enum.PartType.Block then
			table.insert(code, indent .. "part.Shape = Enum.PartType." .. tostring(shape):match("%.([^%.]+)$"))
		end
		
		local success2, topSurface = pcall(function() return part.TopSurface end)
		if success2 and topSurface and topSurface ~= Enum.SurfaceType.Smooth then
			table.insert(code, indent .. "part.TopSurface = Enum.SurfaceType." .. tostring(topSurface):match("%.([^%.]+)$"))
		end
		
		local success3, bottomSurface = pcall(function() return part.BottomSurface end)
		if success3 and bottomSurface and bottomSurface ~= Enum.SurfaceType.Smooth then
			table.insert(code, indent .. "part.BottomSurface = Enum.SurfaceType." .. tostring(bottomSurface):match("%.([^%.]+)$"))
		end
	end
	
	-- Handle MeshPart specific properties
	if part:IsA("MeshPart") then
		if part.MeshId ~= "" then
			table.insert(code, indent .. "part.MeshId = \"" .. tostring(part.MeshId) .. "\"")
		end
		if part.TextureID ~= "" then
			table.insert(code, indent .. "part.TextureID = \"" .. tostring(part.TextureID) .. "\"")
		end
	end
	
	-- Handle UnionOperation
	if part:IsA("UnionOperation") then
		table.insert(code, indent .. "-- UnionOperation: Note that the actual union shape cannot be recreated via code")
		table.insert(code, indent .. "-- You'll need to use the original union model or recreate it manually")
	end
	
	table.insert(code, "")
	table.insert(code, indent .. "-- Parent the part")
	table.insert(code, indent .. "part.Parent = workspace")
	
	return table.concat(code, "\n")
end

-- Function to generate code for a Model and its children
local function generateModelCode(model, indent)
	indent = indent or ""
	local code = {}
	
	table.insert(code, indent .. "-- Model: " .. model.Name)
	table.insert(code, indent .. "local model = Instance.new(\"Model\")")
	table.insert(code, indent .. "model.Name = \"" .. model.Name:gsub("\"", "\\\"") .. "\"")
	table.insert(code, indent .. "model.Parent = workspace")
	table.insert(code, "")
	
	-- Process all children
	local parts = {}
	local models = {}
	local other = {}
	
	for _, child in ipairs(model:GetChildren()) do
		if child:IsA("BasePart") then
			table.insert(parts, child)
		elseif child:IsA("Model") then
			table.insert(models, child)
		elseif child.ClassName ~= "Model" and child.ClassName ~= "BasePart" then
			table.insert(other, child)
		end
	end
	
	-- Generate code for parts
	for _, part in ipairs(parts) do
		table.insert(code, generatePartCode(part, indent .. "\t"))
		table.insert(code, indent .. "\tpart.Parent = model")
		table.insert(code, "")
	end
	
	-- Generate code for nested models
	for _, nestedModel in ipairs(models) do
		local nestedCode = generateModelCode(nestedModel, indent .. "\t")
		table.insert(code, nestedCode)
		table.insert(code, "")
	end
	
	-- Generate code for other objects (StringValues, etc.)
	for _, obj in ipairs(other) do
		table.insert(code, indent .. "local " .. obj.Name:gsub("[^%w]", "_") .. " = Instance.new(\"" .. obj.ClassName .. "\")")
		table.insert(code, indent .. obj.Name:gsub("[^%w]", "_") .. ".Name = \"" .. obj.Name:gsub("\"", "\\\"") .. "\"")
		if obj:IsA("StringValue") or obj:IsA("IntValue") or obj:IsA("BoolValue") or obj:IsA("NumberValue") then
			table.insert(code, indent .. obj.Name:gsub("[^%w]", "_") .. ".Value = " .. (type(obj.Value) == "string" and "\"" .. obj.Value:gsub("\"", "\\\"") .. "\"" or tostring(obj.Value)))
		end
		table.insert(code, indent .. obj.Name:gsub("[^%w]", "_") .. ".Parent = model")
		table.insert(code, "")
	end
	
	return table.concat(code, "\n")
end

-- Function to sanitize filename
local function sanitizeFilename(name)
	return name:gsub("[^%w_%-%.]", "_"):gsub("^%d", "_%1")
end

-- Main export function
local function exportAllObjects()
	print("=== Exporting All Workspace Objects ===")
	
	local exportedCount = 0
	local files = {}
	
	-- Export direct children of workspace
	for _, child in ipairs(workspace:GetChildren()) do
		if child:IsA("BasePart") and child.Name ~= "Terrain" then
			local filename = sanitizeFilename(child.Name) .. ".lua"
			local code = generatePartCode(child)
			table.insert(files, {
				filename = filename,
				code = code
			})
			exportedCount = exportedCount + 1
		elseif child:IsA("Model") then
			local filename = sanitizeFilename(child.Name) .. ".lua"
			local code = generateModelCode(child)
			table.insert(files, {
				filename = filename,
				code = code
			})
			exportedCount = exportedCount + 1
		elseif child:IsA("Folder") then
			-- Export contents of folders
			for _, folderChild in ipairs(child:GetChildren()) do
				if folderChild:IsA("BasePart") then
					local filename = sanitizeFilename(child.Name .. "_" .. folderChild.Name) .. ".lua"
					local code = generatePartCode(folderChild)
					table.insert(files, {
						filename = filename,
						code = code
					})
					exportedCount = exportedCount + 1
				elseif folderChild:IsA("Model") then
					local filename = sanitizeFilename(child.Name .. "_" .. folderChild.Name) .. ".lua"
					local code = generateModelCode(folderChild)
					table.insert(files, {
						filename = filename,
						code = code
					})
					exportedCount = exportedCount + 1
				end
			end
		end
	end
	
	-- Output each file separately to avoid truncation
	print("")
	print("=== COPY ALL OUTPUT BELOW AND SAVE TO export.txt ===")
	print("")
	print("FILE_COUNT:" .. exportedCount)
	print("")
	
	-- Output each file with clear delimiters
	for i, fileInfo in ipairs(files) do
		print("===FILE_START===")
		print("FILENAME:" .. fileInfo.filename)
		print("CODE_START")
		print(fileInfo.code)
		print("CODE_END")
		print("===FILE_END===")
		print("")
	end
	
	print("=== Export Complete ===")
	print("Exported " .. exportedCount .. " objects")
	print("")
	print("NOTE: Copy ALL output above (from FILE_COUNT to the end) and save to export.txt")
	print("Then run: python create_all_files.py")
end

-- Run the export
exportAllObjects()

