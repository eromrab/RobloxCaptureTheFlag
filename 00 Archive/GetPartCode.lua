-- OPTION 1 (RECOMMENDED): Put this script as a child of the part you want to export
-- Then uncomment the line below and comment out OPTION 2:
local part = script.Parent

-- OPTION 2: List all parts and get a specific one by name
-- First, let's see what parts exist:
print("=== ALL PARTS IN WORKSPACE ===")
local allParts = {}
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        table.insert(allParts, obj)
        print(string.format("  - %s (Position: %s)", obj.Name, tostring(obj.Position)))
    end
end
print("=== END LIST ===\n")

-- Change this to the name of the part you want (from the list above):
-- local part = workspace:FindFirstChild("YourPartName", true)

if part and part:IsA("BasePart") then
    -- Show identifying information
    print("=== PART INFO ===")
    print("Full Path: " .. part:GetFullName())
    print("Name: " .. part.Name)
    print("Position: " .. tostring(part.Position))
    print("Size: " .. tostring(part.Size))
    print("===============\n")
    
    -- Check if there are other parts with the same name
    local sameNameParts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == part.Name and obj ~= part then
            table.insert(sameNameParts, obj)
        end
    end
    if #sameNameParts > 0 then
        warn(string.format("WARNING: Found %d other part(s) with the same name '%s':", #sameNameParts, part.Name))
        for i, p in ipairs(sameNameParts) do
            print(string.format("  %d. %s (Position: %s)", i, p:GetFullName(), tostring(p.Position)))
        end
        print("")
    end
    
    local code = string.format([[
local part = Instance.new("%s")
part.Name = "%s"
part.Size = Vector3.new(%s, %s, %s)
part.Position = Vector3.new(%s, %s, %s)
part.Anchored = %s
part.CanCollide = %s
part.Transparency = %s
part.Material = Enum.Material.%s
part.Color = Color3.new(%s, %s, %s)
]], 
        part.ClassName,
        part.Name,
        part.Size.X, part.Size.Y, part.Size.Z,
        part.Position.X, part.Position.Y, part.Position.Z,
        tostring(part.Anchored),
        tostring(part.CanCollide),
        tostring(part.Transparency),
        tostring(part.Material),
        part.Color.R, part.Color.G, part.Color.B
    )
    
    print("=== PART CODE ===")
    print(code)
    print("=== END ===")
    
    -- Also copy to clipboard if possible
    print("\nCopy the code above and paste it here!")
else
    warn("Please select a Part first!")
end

