-- STEP 3: Create Models
-- Run this script third to create all models (trees, etc.)
-- Paste this script into Roblox Studio Command Bar (View > Command Bar)

local workspace = game:GetService("Workspace")

print("=== Step 3: Creating Models ===")

-- Creating Tree (Model #1)
do
  -- Model: Tree
  local model = Instance.new("Model")
  model.Name = "Tree"
  model.Parent = workspace

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(5.712798595428467, 7.770983695983887, 7.457089424133301)
  	part.Position = Vector3.new(-76.34310913085938, 23.593204498291016, -6.016876220703125)
  	part.Rotation = Vector3.new(-150.39999389648438, -62.90399932861328, -30.27400016784668)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.89279842376709, 6.180984020233154, 11.087089538574219)
  	part.Position = Vector3.new(-78.0690689086914, 28.311687469482422, -14.069488525390625)
  	part.Rotation = Vector3.new(-90, 68, 90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(12.472799301147461, 7.210984706878662, 12.067089080810547)
  	part.Position = Vector3.new(-64.86129760742188, 32.90257263183594, -27.00096893310547)
  	part.Rotation = Vector3.new(-33.11899948120117, -18.1299991607666, 173.7779998779297)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(8.202798843383789, 8.390983581542969, 8.907089233398438)
  	part.Position = Vector3.new(-60.20934295654297, 28.529354095458984, -24.424530029296875)
  	part.Rotation = Vector3.new(7.064000129699707, 32.319000244140625, -13.048999786376953)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Bark"
  	part.Size = Vector3.new(27.301532745361328, 32.5402717590332, 25.60323715209961)
  	part.Position = Vector3.new(-65.72599792480469, 24.27013397216797, -16.355819702148438)
  	part.Rotation = Vector3.new(0, 0, 0)
  	part.Anchored = true
  	part.CanCollide = true
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Slate
  	part.Color = Color3.new(0.42352941632270813, 0.3450980484485626, 0.29411765933036804)
  	part.MeshId = "rbxassetid://580199124"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(13.662797927856445, 8.31098461151123, 11.77708911895752)
  	part.Position = Vector3.new(-63.98379135131836, 36.0144157409668, -7.791831970214844)
  	part.Rotation = Vector3.new(-130.96800231933594, -51.893001556396484, 23.125)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(13.122798919677734, 5.860983848571777, 11.087089538574219)
  	part.Position = Vector3.new(-66.39407348632812, 39.95168685913086, -13.859458923339844)
  	part.Rotation = Vector3.new(0, 0, 0)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(9.592798233032227, 6.180984020233154, 8.257089614868164)
  	part.Position = Vector3.new(-52.0040397644043, 25.15655517578125, -9.729476928710938)
  	part.Rotation = Vector3.new(-90, 43, 90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(9.312797546386719, 6.890984058380127, 6.2770891189575195)
  	part.Position = Vector3.new(-76.27635192871094, 32.86309814453125, -14.749588012695312)
  	part.Rotation = Vector3.new(-130.96800231933594, -51.893001556396484, 23.125)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(8.572798728942871, 7.9309844970703125, 12.587088584899902)
  	part.Position = Vector3.new(-53.06230926513672, 30.002708435058594, -12.900703430175781)
  	part.Rotation = Vector3.new(51.90299987792969, -76.09400177001953, -177.7519989013672)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(8.602798461914062, 7.770983695983887, 10.077089309692383)
  	part.Position = Vector3.new(-73.74146270751953, 25.97796630859375, -7.202476501464844)
  	part.Rotation = Vector3.new(-150.39999389648438, -62.90399932861328, -25.27400016784668)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(10.862799644470215, 6.750984191894531, 11.057088851928711)
  	part.Position = Vector3.new(-60.33953094482422, 30.227096557617188, -3.7068023681640625)
  	part.Rotation = Vector3.new(-101.5739974975586, -37.64099884033203, 44.21500015258789)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(8.342799186706543, 6.750984191894531, 6.607089042663574)
  	part.Position = Vector3.new(-65.08210754394531, 25.89031982421875, -2.2245941162109375)
  	part.Rotation = Vector3.new(-130.96800231933594, -51.893001556396484, -17.875)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(6.022799491882324, 6.750984191894531, 4.807088851928711)
  	part.Position = Vector3.new(-62.38642883300781, 25.586776733398438, -1.4894790649414062)
  	part.Rotation = Vector3.new(49.03200149536133, 51.893001556396484, -162.125)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(12.48279857635498, 6.180984020233154, 11.087089538574219)
  	part.Position = Vector3.new(-77.66790771484375, 24.607406616210938, -9.734626770019531)
  	part.Rotation = Vector3.new(-0.7310000061988831, 0.6819999814033508, 47.00400161743164)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(9.402798652648926, 7.220983505249023, 10.687088966369629)
  	part.Position = Vector3.new(-70.53960418701172, 31.30691909790039, -26.214508056640625)
  	part.Rotation = Vector3.new(90, -37, -90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(7.7227983474731445, 7.290983200073242, 7.7170891761779785)
  	part.Position = Vector3.new(-78.24441528320312, 25.224201202392578, -20.029502868652344)
  	part.Rotation = Vector3.new(90, -23, -90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(9.592798233032227, 6.290984153747559, 8.257089614868164)
  	part.Position = Vector3.new(-53.86561584472656, 25.876060485839844, -19.84947967529297)
  	part.Rotation = Vector3.new(-90, 43, 90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(10.062799453735352, 6.750984191894531, 11.057088851928711)
  	part.Position = Vector3.new(-56.7265510559082, 34.451541900634766, -8.498405456542969)
  	part.Rotation = Vector3.new(-101.5739974975586, -37.64099884033203, 108.21499633789062)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(13.012799263000488, 8.07098388671875, 11.917088508605957)
  	part.Position = Vector3.new(-57.918277740478516, 35.57454299926758, -14.6199951171875)
  	part.Rotation = Vector3.new(-33.11899948120117, -18.1299991607666, 173.7779998779297)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(6.712799549102783, 6.750984191894531, 9.517088890075684)
  	part.Position = Vector3.new(-53.623191833496094, 28.861408233642578, -12.831192016601562)
  	part.Rotation = Vector3.new(-42.49100112915039, -6.0289998054504395, 137.2790069580078)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(10.592799186706543, 6.750984191894531, 11.917088508605957)
  	part.Position = Vector3.new(-52.68266677856445, 31.04172134399414, -8.502578735351562)
  	part.Rotation = Vector3.new(-27.874000549316406, -18.600000381469727, 140.43099975585938)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(8.202798843383789, 8.390983581542969, 8.907089233398438)
  	part.Position = Vector3.new(-66.01934051513672, 28.529354095458984, -27.68450927734375)
  	part.Rotation = Vector3.new(7.064000129699707, 32.319000244140625, -13.048999786376953)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.89279842376709, 9.050983428955078, 12.657089233398438)
  	part.Position = Vector3.new(-70.01797485351562, 36.343692779541016, -22.18951416015625)
  	part.Rotation = Vector3.new(-90, -88, 90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(9.582799911499023, 5.710984230041504, 8.947088241577148)
  	part.Position = Vector3.new(-70.37008666992188, 26.779743194580078, -3.6096725463867188)
  	part.Rotation = Vector3.new(-130.96800231933594, -51.893001556396484, 23.125)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(10.062799453735352, 6.750984191894531, 11.057088851928711)
  	part.Position = Vector3.new(-66.64655303955078, 30.171531677246094, -4.718406677246094)
  	part.Rotation = Vector3.new(-130.96800231933594, -51.893001556396484, 23.125)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.962799072265625, 6.950984477996826, 12.067089080810547)
  	part.Position = Vector3.new(-57.69577407836914, 31.695194244384766, -22.041534423828125)
  	part.Rotation = Vector3.new(-54.35499954223633, -35.51900100708008, 161.19900512695312)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.442798614501953, 6.950984477996826, 8.407089233398438)
  	part.Position = Vector3.new(-54.42254638671875, 30.37874984741211, -18.881240844726562)
  	part.Rotation = Vector3.new(-72.73300170898438, -28.613000869750977, 151.36399841308594)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(7.7227983474731445, 6.380983352661133, 7.7170891761779785)
  	part.Position = Vector3.new(-79.2744140625, 24.204200744628906, -16.879501342773438)
  	part.Rotation = Vector3.new(90, -23, -72)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(13.662797927856445, 7.980984210968018, 9.447089195251465)
  	part.Position = Vector3.new(-55.5528564453125, 28.714046478271484, -4.729103088378906)
  	part.Rotation = Vector3.new(-99.7959976196289, -36.231998443603516, 45.28300094604492)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(8.202798843383789, 8.390983581542969, 11.477088928222656)
  	part.Position = Vector3.new(-74.78453063964844, 27.267963409423828, -21.87450408935547)
  	part.Rotation = Vector3.new(90, -11, -90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(14.882798194885254, 7.770983695983887, 12.657089233398438)
  	part.Position = Vector3.new(-71.35074615478516, 32.26143264770508, -11.443450927734375)
  	part.Rotation = Vector3.new(90, -72, -141)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.962799072265625, 9.430984497070312, 12.067089080810547)
  	part.Position = Vector3.new(-63.787872314453125, 36.75727462768555, -19.393707275390625)
  	part.Rotation = Vector3.new(-33.11899948120117, -18.1299991607666, 173.7779998779297)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.89279842376709, 6.180984020233154, 8.257089614868164)
  	part.Position = Vector3.new(-77.5440444946289, 20.706554412841797, -9.729476928710938)
  	part.Rotation = Vector3.new(-90, 43, 90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(14.882798194885254, 7.770983695983887, 12.657089233398438)
  	part.Position = Vector3.new(-71.2607421875, 38.14142990112305, -14.563461303710938)
  	part.Rotation = Vector3.new(90, -72, -114)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model

  	local part = Instance.new("MeshPart")
  	part.Name = "Leaves"
  	part.Size = Vector3.new(11.89279842376709, 9.050983428955078, 12.657089233398438)
  	part.Position = Vector3.new(-75.0479736328125, 32.46369171142578, -20.029502868652344)
  	part.Rotation = Vector3.new(90, -37, -90)
  	part.Anchored = true
  	part.CanCollide = false
  	part.CanQuery = true
  	part.CanTouch = true
  	part.Transparency = 0
  	part.Material = Enum.Material.Grass
  	part.Color = Color3.new(0.1568627506494522, 0.49803921580314636, 0.27843138575553894)
  	part.MeshId = "rbxassetid://577892994"

  	-- Parent the part
  	part.Parent = workspace
  	part.Parent = model
end
print("  ✓ Tree #1 created")
