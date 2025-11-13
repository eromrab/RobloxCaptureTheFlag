-- STEP 5b: Create Gun Kit
-- Run this script last to create THE_COMPREHENSIVE_GUN_KIT (large file)
-- Paste this script into Roblox Studio Command Bar (View > Command Bar)

local workspace = game:GetService("Workspace")

print("=== Step 5b: Creating Gun Kit ===")

-- Creating THE_COMPREHENSIVE_GUN_KIT__BIG_UPDATE_1
do
  -- Model: THE COMPREHENSIVE GUN KIT, BIG UPDATE 1
  local model = Instance.new("Model")
  model.Name = "THE COMPREHENSIVE GUN KIT, BIG UPDATE 1"
  model.Parent = workspace

  	-- Model: ATTACHMENTS
  	local model = Instance.new("Model")
  	model.Name = "ATTACHMENTS"
  	model.Parent = workspace

  		-- Model: OPTICS / SIGHTS
  		local model = Instance.new("Model")
  		model.Name = "OPTICS / SIGHTS"
  		model.Parent = workspace

  			local part = Instance.new("UnionOperation")
  			part.Name = "STAND"
  			part.Size = Vector3.new(6.275001525878906, 1.0049999952316284, 4.600002288818359)
  			part.Position = Vector3.new(18.550048828125, 1.50250244140625, -633.8999633789062)
  			part.Rotation = Vector3.new(0, 0, 0)
  			part.Anchored = true
  			part.CanCollide = true
  			part.CanQuery = true
  			part.CanTouch = true
  			part.Transparency = 0
  			part.Material = Enum.Material.Concrete
  			part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)
  			-- UnionOperation: Note that the actual union shape cannot be recreated via code
  			-- You'll need to use the original union model or recreate it manually

  			-- Parent the part
  			part.Parent = workspace
  			part.Parent = model

  			-- Model: NIGHT VISION SCOPES
  			local model = Instance.new("Model")
  			model.Name = "NIGHT VISION SCOPES"
  			model.Parent = workspace

  				-- Model: AN/PVS-4
  				local model = Instance.new("Model")
  				model.Name = "AN/PVS-4"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.05000000074505806, 0.2750000059604645, 0.2750000059604645)
  					part.Position = Vector3.new(19.43994140625, 2.2024993896484375, -634.9024658203125)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0.25
  					part.Material = Enum.Material.Neon
  					part.Color = Color3.new(0.32156863808631897, 0.48627451062202454, 0.6823529601097107)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.38499999046325684, 0.37499988079071045, 1.1050004959106445)
  					part.Position = Vector3.new(19.4375, 2.1974945068359375, -635.375)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.2078431397676468, 0.2078431397676468, 0.2078431397676468)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.05000000074505806, 0.125, 0.125)
  					part.Position = Vector3.new(19.43994140625, 2.2024993896484375, -635.8524780273438)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0.10000000149011612
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.32156863808631897, 0.48627451062202454, 0.6823529601097107)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: HIGH-POWERED SCOPES
  			local model = Instance.new("Model")
  			model.Name = "HIGH-POWERED SCOPES"
  			model.Parent = workspace

  				-- Model: NIGHTFORCE ATACR F1
  				local model = Instance.new("Model")
  				model.Name = "NIGHTFORCE ATACR F1"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32500001788139343, 0.4000000059604645, 1.25)
  					part.Position = Vector3.new(18.288818359375, 2.14251708984375, -635.3652954101562)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: LEUPOLD MARK 8
  				local model = Instance.new("Model")
  				model.Name = "LEUPOLD MARK 8"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07500000298023224, 0.20000004768371582, 0.20000001788139343)
  					part.Position = Vector3.new(18.263916015625, 2.175018310546875, -634.4778442382812)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.45490196347236633, 0.5254902243614197, 0.615686297416687)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2750000059604645, 0.75, 0.3499999940395355)
  					part.Position = Vector3.new(18.3388671875, 2.14251708984375, -633.7903442382812)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("UnionOperation")
  					part.Name = "Part"
  					part.Size = Vector3.new(1.3304632902145386, 0.22099943459033966, 0.19099882245063782)
  					part.Position = Vector3.new(18.266357421875, 2.1705169677734375, -633.8673095703125)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.SmoothPlastic
  					part.Color = Color3.new(0.7215686440467834, 0.6039215922355652, 0.1411764770746231)
  					-- UnionOperation: Note that the actual union shape cannot be recreated via code
  					-- You'll need to use the original union model or recreate it manually

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07500000298023224, 0.27500003576278687, 0.30000001192092896)
  					part.Position = Vector3.new(18.269775390625, 2.167510986328125, -632.6028442382812)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.45490196347236633, 0.5254902243614197, 0.615686297416687)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.4750000238418579, 0.4000000059604645, 1.9500000476837158)
  					part.Position = Vector3.new(18.2138671875, 2.14251708984375, -633.5403442382812)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: NIGHTFORCE ATACR 7-35x56 
  				local model = Instance.new("Model")
  				model.Name = "NIGHTFORCE ATACR 7-35x56 "
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07500000298023224, 0.22499999403953552, 0.22499999403953552)
  					part.Position = Vector3.new(19.42724609375, 2.14752197265625, -632.77783203125)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.45490196347236633, 0.5254902243614197, 0.615686297416687)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07500000298023224, 0.18000000715255737, 0.18000000715255737)
  					part.Position = Vector3.new(19.42724609375, 2.14752197265625, -634.3528442382812)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.45490196347236633, 0.5254902243614197, 0.615686297416687)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3500000536441803, 1.850000023841858, 0.30000001192092896)
  					part.Position = Vector3.new(19.41259765625, 2.17999267578125, -633.5499877929688)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.22500000894069672, 0.6499999761581421, 0.3499999940395355)
  					part.Position = Vector3.new(19.48876953125, 2.14251708984375, -633.6903076171875)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: EOTECH VUDU 1-6
  				local model = Instance.new("Model")
  				model.Name = "EOTECH VUDU 1-6"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2750000059604645, 0.75, 0.3499999940395355)
  					part.Position = Vector3.new(18.93896484375, 2.14251708984375, -633.34033203125)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32500001788139343, 1.75, 0.3500000238418579)
  					part.Position = Vector3.new(18.848876953125, 2.1575164794921875, -633.4703369140625)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: VOMZ PILAD 4x32
  				local model = Instance.new("Model")
  				model.Name = "VOMZ PILAD 4x32"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07500000298023224, 0.25, 0.25)
  					part.Position = Vector3.new(18.869873046875, 2.14752197265625, -634.6778564453125)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.45490196347236633, 0.5254902243614197, 0.615686297416687)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07500000298023224, 0.20000000298023224, 0.20000000298023224)
  					part.Position = Vector3.new(18.869873046875, 2.14752197265625, -635.9528198242188)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.45490196347236633, 0.5254902243614197, 0.615686297416687)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3500000536441803, 1.4000000953674316, 0.48500001430511475)
  					part.Position = Vector3.new(18.768798828125, 2.1600189208984375, -635.3153076171875)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.22500000894069672, 0.6499999761581421, 0.3499999940395355)
  					part.Position = Vector3.new(18.93896484375, 2.14251708984375, -635.46533203125)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: BUIS 
  			local model = Instance.new("Model")
  			model.Name = "BUIS "
  			model.Parent = workspace

  				-- Model: MAGPUL MBUS
  				local model = Instance.new("Model")
  				model.Name = "MAGPUL MBUS"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.09999999403953552, 0.25)
  					part.Position = Vector3.new(16.058837890625, 2.0975189208984375, -631.9053955078125)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.25, 0.10000000149011612)
  					part.Position = Vector3.new(16.1337890625, 2.0975189208984375, -631.8304443359375)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.25, 0.10000000149011612)
  					part.Position = Vector3.new(16.1337890625, 2.0975189208984375, -632.1954345703125)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.09999999403953552, 0.25)
  					part.Position = Vector3.new(16.058837890625, 2.107513427734375, -632.2703857421875)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: MAGPUL MBUS PRO
  				local model = Instance.new("Model")
  				model.Name = "MAGPUL MBUS PRO"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07499999552965164, 0.05000000074505806, 0.25)
  					part.Position = Vector3.new(16.436279296875, 2.1200103759765625, -631.8504028320312)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.25, 0.10000000149011612)
  					part.Position = Vector3.new(16.541259765625, 2.1200103759765625, -632.1954345703125)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.07499999552965164, 0.05000000074505806, 0.25)
  					part.Position = Vector3.new(16.436279296875, 2.1200103759765625, -632.2304077148438)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.17499999701976776, 0.10000000149011612)
  					part.Position = Vector3.new(16.541259765625, 2.115020751953125, -631.867919921875)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: DANIEL DEFENSE ROCK & LOCK
  				local model = Instance.new("Model")
  				model.Name = "DANIEL DEFENSE ROCK & LOCK"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.25, 0.30000001192092896)
  					part.Position = Vector3.new(16.853759765625, 2.1275177001953125, -632.2203979492188)
  					part.Rotation = Vector3.new(90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.15000000596046448, 0.30000001192092896)
  					part.Position = Vector3.new(16.853759765625, 2.1275177001953125, -631.8554077148438)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: TROY DEFENSE IRON SIGHTS
  				local model = Instance.new("Model")
  				model.Name = "TROY DEFENSE IRON SIGHTS"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.25499963760375977, 0.1549999713897705, 0.23999996483325958)
  					part.Position = Vector3.new(15.75634765625, 2.1100311279296875, -632.2454223632812)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.10499963164329529, 0.2799999713897705, 0.11499997973442078)
  					part.Position = Vector3.new(15.6689453125, 2.1125335693359375, -631.92041015625)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.25499963760375977, 0.1549999713897705, 0.20499996840953827)
  					part.Position = Vector3.new(15.78125, 2.1075439453125, -631.8704223632812)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.10499963164329529, 0.2799999713897705, 0.1499999761581421)
  					part.Position = Vector3.new(15.643798828125, 2.115020751953125, -632.29541015625)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: DOVETAIL
  			local model = Instance.new("Model")
  			model.Name = "DOVETAIL"
  			model.Parent = workspace

  				-- Model: AXION KOBRA 1S-03M
  				local model = Instance.new("Model")
  				model.Name = "AXION KOBRA 1S-03M"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3250000476837158, 0.8000000715255737, 0.8500000834465027)
  					part.Position = Vector3.new(20.283935546875, 2.2225189208984375, -635.6304321289062)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: OKP-7
  				local model = Instance.new("Model")
  				model.Name = "OKP-7"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.27500003576278687, 0.6000000834465027, 0.7000000476837158)
  					part.Position = Vector3.new(20.283935546875, 2.1975250244140625, -634.7803955078125)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: PSO-1
  				local model = Instance.new("Model")
  				model.Name = "PSO-1"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3750000298023224, 0.7500000596046448, 0.7000000476837158)
  					part.Position = Vector3.new(20.283935546875, 2.1975250244140625, -633.6304321289062)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.1899999976158142, 0.375, 0.2850000262260437)
  					part.Position = Vector3.new(20.116455078125, 2.20501708984375, -634.117919921875)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.21176470816135406, 0.21176470816135406, 0.21176470816135406)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32500001788139343, 0.7500000596046448, 0.6500000953674316)
  					part.Position = Vector3.new(20.283935546875, 2.182525634765625, -632.9553833007812)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: NSPU (1PN34)
  				local model = Instance.new("Model")
  				model.Name = "NSPU (1PN34)"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.27500006556510925, 1.0999999046325684, 0.2750000059604645)
  					part.Position = Vector3.new(20.89697265625, 2.2015228271484375, -634.5303955078125)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.2666666805744171, 0.26274511218070984, 0.2666666805744171)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32499998807907104, 0.32499998807907104, 0.07500000298023224)
  					part.Position = Vector3.new(20.88427734375, 2.164031982421875, -633.2929077148438)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.28000009059906006, 0.3299998342990875, 0.3349999785423279)
  					part.Position = Vector3.new(20.888916015625, 2.1600189208984375, -635.2183837890625)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.40000009536743164, 1.5999997854232788, 0.375)
  					part.Position = Vector3.new(20.8837890625, 2.1950225830078125, -634.058349609375)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.2666666805744171, 0.26274511218070984, 0.2666666805744171)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.40000006556510925, 0.6999999284744263, 0.625)
  					part.Position = Vector3.new(21.23681640625, 2.3040313720703125, -634.6653442382812)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.2666666805744171, 0.26274511218070984, 0.2666666805744171)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.14499999582767487, 0.14499999582767487, 0.0650000050663948)
  					part.Position = Vector3.new(20.886962890625, 2.1665191650390625, -635.087890625)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: RED DOTS / HOLOGRAPHIC SIGHTS
  			local model = Instance.new("Model")
  			model.Name = "RED DOTS / HOLOGRAPHIC SIGHTS"
  			model.Parent = workspace

  				-- Model: AIMPOINT COMPM2
  				local model = Instance.new("Model")
  				model.Name = "AIMPOINT COMPM2"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.375, 0.550000011920929, 0.8999999761581421)
  					part.Position = Vector3.new(16.183837890625, 2.0975189208984375, -634.7803344726562)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: PILADE 1x42
  				local model = Instance.new("Model")
  				model.Name = "PILADE 1x42"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.25, 0.45000001788139343)
  					part.Position = Vector3.new(15.65380859375, 2.1275177001953125, -633.245361328125)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: HOLOSUN HS401G5 
  				local model = Instance.new("Model")
  				model.Name = "HOLOSUN HS401G5 "
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.22500008344650269, 0.7000001072883606, 0.375)
  					part.Position = Vector3.new(17.22509765625, 2.11749267578125, -635.6124877929688)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: TRIJICON SRO
  				local model = Instance.new("Model")
  				model.Name = "TRIJICON SRO"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32500001788139343, 0.30000001192092896, 0.5)
  					part.Position = Vector3.new(15.641357421875, 2.1399993896484375, -635.8203735351562)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3750000298023224, 0.15000000596046448, 0.15000000596046448)
  					part.Position = Vector3.new(15.701416015625, 2.1399993896484375, -635.7603149414062)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.3019607961177826, 0.3019607961177826, 0.3019607961177826)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: TRIJICON MRO
  				local model = Instance.new("Model")
  				model.Name = "TRIJICON MRO"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.22500000894069672, 0.4000000059604645, 0.4000000059604645)
  					part.Position = Vector3.new(16.208740234375, 2.0975189208984375, -634.00537109375)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: AIMPOINT T-1
  				local model = Instance.new("Model")
  				model.Name = "AIMPOINT T-1"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2750000059604645, 0.25, 0.3499999940395355)
  					part.Position = Vector3.new(16.10888671875, 2.0975189208984375, -632.8053588867188)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.125, 0.20000001788139343, 0.25)
  					part.Position = Vector3.new(16.298828125, 2.127532958984375, -632.8053588867188)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: AXION KOBRA
  				local model = Instance.new("Model")
  				model.Name = "AXION KOBRA"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2500000596046448, 0.7750000953674316, 0.32499998807907104)
  					part.Position = Vector3.new(17.175048828125, 2.17999267578125, -633)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: VORTEX UH-1
  				local model = Instance.new("Model")
  				model.Name = "VORTEX UH-1"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32500001788139343, 0.3499999940395355, 0.44999998807907104)
  					part.Position = Vector3.new(15.65380859375, 2.1275177001953125, -634.3953857421875)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: WALTHER MRS
  				local model = Instance.new("Model")
  				model.Name = "WALTHER MRS"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17500010132789612, 0.450000137090683, 0.2750000059604645)
  					part.Position = Vector3.new(17.60009765625, 2.142486572265625, -632.9874877929688)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: EOTECH 552
  				local model = Instance.new("Model")
  				model.Name = "EOTECH 552"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.30000007152557373, 0.6500000953674316, 0.375)
  					part.Position = Vector3.new(17.14990234375, 2.17999267578125, -634.6624755859375)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: SIG SAUER ROMEO5 XDR
  				local model = Instance.new("Model")
  				model.Name = "SIG SAUER ROMEO5 XDR"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.22500000894069672, 0.4000000059604645, 0.5)
  					part.Position = Vector3.new(16.208984375, 2.1225128173828125, -633.4553833007812)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: PK-06 BELOMO
  				local model = Instance.new("Model")
  				model.Name = "PK-06 BELOMO"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.25, 0.3500000238418579)
  					part.Position = Vector3.new(15.65380859375, 2.1275177001953125, -632.7454223632812)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: P-OKP-7
  				local model = Instance.new("Model")
  				model.Name = "P-OKP-7"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.30000007152557373, 0.6750001311302185, 0.32499998807907104)
  					part.Position = Vector3.new(17.175048828125, 2.17999267578125, -633.7999877929688)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: EOTECH XPS7
  				local model = Instance.new("Model")
  				model.Name = "EOTECH XPS7"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2750000059604645, 0.3499999940395355, 0.45000001788139343)
  					part.Position = Vector3.new(15.65380859375, 2.1275177001953125, -633.79541015625)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: AIMPOINT COMPM4
  				local model = Instance.new("Model")
  				model.Name = "AIMPOINT COMPM4"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.375, 0.5, 0.75)
  					part.Position = Vector3.new(16.183837890625, 2.14752197265625, -635.7053833007812)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: VALDAY 1P87
  				local model = Instance.new("Model")
  				model.Name = "VALDAY 1P87"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32500001788139343, 0.3499999940395355, 0.75)
  					part.Position = Vector3.new(15.65380859375, 2.1275177001953125, -635.0953369140625)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: MAGNIFIERS
  			local model = Instance.new("Model")
  			model.Name = "MAGNIFIERS"
  			model.Parent = workspace

  				-- Model: AIMPOINT 3x MAGNIFIER
  				local model = Instance.new("Model")
  				model.Name = "AIMPOINT 3x MAGNIFIER"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32499998807907104, 0.15000000596046448, 0.2999999523162842)
  					part.Position = Vector3.new(18.333984375, 2.14752197265625, -632.2303466796875)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.22499999403953552, 0.30000001192092896, 0.5499999523162842)
  					part.Position = Vector3.new(18.208740234375, 2.167510986328125, -632.0503540039062)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: EOTECH G33
  				local model = Instance.new("Model")
  				model.Name = "EOTECH G33"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32499998807907104, 0.3500000238418579, 0.5499999523162842)
  					part.Position = Vector3.new(17.708740234375, 2.1575164794921875, -632.0603637695312)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.32499998807907104, 0.15000000596046448, 0.2999999523162842)
  					part.Position = Vector3.new(17.8837890625, 2.14752197265625, -632.1802978515625)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: LOW-POWERED SCOPES
  			local model = Instance.new("Model")
  			model.Name = "LOW-POWERED SCOPES"
  			model.Parent = workspace

  				-- Model: ELCAN SPECTER OS
  				local model = Instance.new("Model")
  				model.Name = "ELCAN SPECTER OS"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3500000536441803, 0.7999999523162842, 0.375)
  					part.Position = Vector3.new(17.612548828125, 2.1500091552734375, -635.5950317382812)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.17499999701976776, 0.07500000298023224)
  					part.Position = Vector3.new(17.56005859375, 2.1150054931640625, -635.2725219726562)
  					part.Rotation = Vector3.new(0, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17499999701976776, 0.17499999701976776, 0.07500000298023224)
  					part.Position = Vector3.new(17.56005859375, 2.1150054931640625, -635.9225463867188)
  					part.Rotation = Vector3.new(0, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: ELCAN SPECTERDR
  				local model = Instance.new("Model")
  				model.Name = "ELCAN SPECTERDR"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.375, 0.4000000059604645, 0.75)
  					part.Position = Vector3.new(16.7138671875, 2.1925201416015625, -634.7653198242188)
  					part.Rotation = Vector3.new(180, 0, 180)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: VALDAY PS320
  				local model = Instance.new("Model")
  				model.Name = "VALDAY PS320"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.375, 0.4000000059604645, 0.75)
  					part.Position = Vector3.new(16.73876953125, 2.14251708984375, -633.8653564453125)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: MONSTRUM COMPACT
  				local model = Instance.new("Model")
  				model.Name = "MONSTRUM COMPACT"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.30000007152557373, 0.5499999523162842, 0.32500001788139343)
  					part.Position = Vector3.new(17.58740234375, 2.1500091552734375, -634.695068359375)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.15000003576278687, 0.15000000596046448, 0.07500000298023224)
  					part.Position = Vector3.new(17.56005859375, 2.1500091552734375, -634.9075317382812)
  					part.Rotation = Vector3.new(0, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.15000003576278687, 0.15000000596046448, 0.07500000298023224)
  					part.Position = Vector3.new(17.56005859375, 2.1500091552734375, -634.4825439453125)
  					part.Rotation = Vector3.new(0, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: SIG SAUER BRAVO4
  				local model = Instance.new("Model")
  				model.Name = "SIG SAUER BRAVO4"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.20000003278255463, 0.20000000298023224, 0.07500000298023224)
  					part.Position = Vector3.new(17.56005859375, 2.1500091552734375, -633.5574951171875)
  					part.Rotation = Vector3.new(0, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.30000007152557373, 0.7499999403953552, 0.3750000298023224)
  					part.Position = Vector3.new(17.58740234375, 2.1500091552734375, -633.7449951171875)
  					part.Rotation = Vector3.new(-90, 90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Plastic
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.20000003278255463, 0.20000000298023224, 0.07500000298023224)
  					part.Position = Vector3.new(17.56005859375, 2.1500091552734375, -634.08251953125)
  					part.Rotation = Vector3.new(0, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Glass
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: LEUPOLD HAMR (w/ DELTA SIGHT)
  				local model = Instance.new("Model")
  				model.Name = "LEUPOLD HAMR (w/ DELTA SIGHT)"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2750000059604645, 0.30000001192092896, 0.75)
  					part.Position = Vector3.new(16.7587890625, 2.1225128173828125, -635.6803588867188)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17500001192092896, 0.15000002086162567, 0.19999998807907104)
  					part.Position = Vector3.new(16.558837890625, 2.1225128173828125, -635.4803466796875)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17500001192092896, 0.20000001788139343, 0.19999998807907104)
  					part.Position = Vector3.new(16.558837890625, 2.1225128173828125, -635.4803466796875)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: TRIJICON ACOG 4x
  				local model = Instance.new("Model")
  				model.Name = "TRIJICON ACOG 4x"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.30000001192092896, 0.3499999940395355, 0.8999999761581421)
  					part.Position = Vector3.new(16.72509765625, 2.1425018310546875, -632.9749755859375)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.30000001192092896, 0.10000000894069672, 0.5249999761581421)
  					part.Position = Vector3.new(16.875, 2.1425018310546875, -632.8125)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: CANTED SIGHTS
  			local model = Instance.new("Model")
  			model.Name = "CANTED SIGHTS"
  			model.Parent = workspace

  				-- Model: PK-06 BELOMO, CANTED
  				local model = Instance.new("Model")
  				model.Name = "PK-06 BELOMO, CANTED"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.42499998211860657, 0.25, 0.2999999523162842)
  					part.Position = Vector3.new(17.333984375, 2.1975250244140625, -631.8803100585938)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: TRIJICON RMR, CANTED
  				local model = Instance.new("Model")
  				model.Name = "TRIJICON RMR, CANTED"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2749999761581421, 0.4000000059604645, 0.19999995827674866)
  					part.Position = Vector3.new(17.333984375, 2.1975250244140625, -632.2553100585938)
  					part.Rotation = Vector3.new(0, 0, 48)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model




  		-- Model: GRIPS / DESIGNATORS / RAILS
  		local model = Instance.new("Model")
  		model.Name = "GRIPS / DESIGNATORS / RAILS"
  		model.Parent = workspace

  			local part = Instance.new("UnionOperation")
  			part.Name = "STAND"
  			part.Size = Vector3.new(4.074999809265137, 1.0049999952316284, 3.3499984741210938)
  			part.Position = Vector3.new(17.449951171875, 1.50250244140625, -638.875)
  			part.Rotation = Vector3.new(0, 0, 0)
  			part.Anchored = true
  			part.CanCollide = true
  			part.CanQuery = true
  			part.CanTouch = true
  			part.Transparency = 0
  			part.Material = Enum.Material.Concrete
  			part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)
  			-- UnionOperation: Note that the actual union shape cannot be recreated via code
  			-- You'll need to use the original union model or recreate it manually

  			-- Parent the part
  			part.Parent = workspace
  			part.Parent = model

  			-- Model: DESIGNATORS
  			local model = Instance.new("Model")
  			model.Name = "DESIGNATORS"
  			model.Parent = workspace

  				-- Model: DBAL A2
  				local model = Instance.new("Model")
  				model.Name = "DBAL A2"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.42500004172325134, 0.5500000715255737, 0.2500000596046448)
  					part.Position = Vector3.new(16.35888671875, 2.14752197265625, -637.6054077148438)
  					part.Rotation = Vector3.new(90, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: AN/PEQ-2
  				local model = Instance.new("Model")
  				model.Name = "AN/PEQ-2"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17500001192092896, 0.37499985098838806, 0.949999988079071)
  					part.Position = Vector3.new(16.362548828125, 2.1674957275390625, -639.9749755859375)
  					part.Rotation = Vector3.new(180, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: ZENIT PERST-3
  				local model = Instance.new("Model")
  				model.Name = "ZENIT PERST-3"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.42500004172325134, 0.2000000774860382, 0.7000000476837158)
  					part.Position = Vector3.new(16.35888671875, 2.172515869140625, -638.305419921875)
  					part.Rotation = Vector3.new(180, 0, 180)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: AN/PEQ-15
  				local model = Instance.new("Model")
  				model.Name = "AN/PEQ-15"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.42500004172325134, 0.2500000596046448, 0.7000000476837158)
  					part.Position = Vector3.new(16.35888671875, 2.172515869140625, -639.0803833007812)
  					part.Rotation = Vector3.new(180, 0, 180)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: LIGHTS
  			local model = Instance.new("Model")
  			model.Name = "LIGHTS"
  			model.Parent = workspace

  				-- Model: INFORCE WML
  				local model = Instance.new("Model")
  				model.Name = "INFORCE WML"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.1850000023841858, 0.14000000059604645, 0.14000006020069122)
  					part.Position = Vector3.new(16.96142578125, 2.21624755859375, -639.662841796875)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Neon
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2250000387430191, 0.2000000774860382, 0.7500000596046448)
  					part.Position = Vector3.new(16.98388671875, 2.1975250244140625, -639.9303588867188)
  					part.Rotation = Vector3.new(0, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: SUREFIRE SCOUT
  				local model = Instance.new("Model")
  				model.Name = "SUREFIRE SCOUT"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.05000000074505806, 0.125, 0.12500005960464478)
  					part.Position = Vector3.new(16.95751953125, 2.1725921630859375, -637.4804077148438)
  					part.Rotation = Vector3.new(90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Neon
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.2250000387430191, 0.2000000774860382, 0.7500000596046448)
  					part.Position = Vector3.new(16.98388671875, 2.1975250244140625, -637.8303833007812)
  					part.Rotation = Vector3.new(180, 0, -90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: TAC-LIGHT
  				local model = Instance.new("Model")
  				model.Name = "TAC-LIGHT"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.05000000074505806, 0.125, 0.12500005960464478)
  					part.Position = Vector3.new(16.956298828125, 2.1787567138671875, -638.4553833007812)
  					part.Rotation = Vector3.new(0, -90, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Neon
  					part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17500004172325134, 0.30000007152557373, 0.9500000476837158)
  					part.Position = Vector3.new(16.98876953125, 2.1875152587890625, -638.9303588867188)
  					part.Rotation = Vector3.new(180, 0, 0)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: RAIL ATTACHMENTS
  			local model = Instance.new("Model")
  			model.Name = "RAIL ATTACHMENTS"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.12000004947185516, 0.10000008344650269, 0.8000000715255737)
  				part.Position = Vector3.new(15.888916015625, 2.0600128173828125, -640.0553588867188)
  				part.Rotation = Vector3.new(180, 0, 180)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model

  				-- Model: 10.5" RAIL COVER
  				local model = Instance.new("Model")
  				model.Name = "10.5\" RAIL COVER"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.925000011920929, 0.22499984502792358, 0.1250000149011612)
  					part.Position = Vector3.new(15.637451171875, 2.0675048828125, -639.9874877929688)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: MAGPUL XTM RAIL PANEL
  				local model = Instance.new("Model")
  				model.Name = "MAGPUL XTM RAIL PANEL"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.17000004649162292, 0.25000008940696716, 0.05000007152557373)
  					part.Position = Vector3.new(15.638916015625, 2.0600128173828125, -638.3053588867188)
  					part.Rotation = Vector3.new(90, 0, 180)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: 7.5" RAIL COVER
  				local model = Instance.new("Model")
  				model.Name = "7.5\" RAIL COVER"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.6499999761581421, 0.22499984502792358, 0.1250000149011612)
  					part.Position = Vector3.new(15.637451171875, 2.0675048828125, -639.1749877929688)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.6499999761581421, 0.22499984502792358, 0.1250000149011612)
  					part.Position = Vector3.new(15.637451171875, 2.0675048828125, -639.8250122070312)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: 2.5" MLOK RAIL
  				local model = Instance.new("Model")
  				model.Name = "2.5\" MLOK RAIL"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.12000004947185516, 0.3500000834465027, 0.05000007152557373)
  					part.Position = Vector3.new(15.638916015625, 2.0600128173828125, -637.4303588867188)
  					part.Rotation = Vector3.new(90, 0, 180)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: 5" MLOK RAIL
  				local model = Instance.new("Model")
  				model.Name = "5\" MLOK RAIL"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.12000004947185516, 0.6000000834465027, 0.05000007152557373)
  					part.Position = Vector3.new(15.638916015625, 2.0600128173828125, -637.88037109375)
  					part.Rotation = Vector3.new(90, 0, 180)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model


  				-- Model: 3" RAIL COVER
  				local model = Instance.new("Model")
  				model.Name = "3\" RAIL COVER"
  				model.Parent = workspace

  					local part = Instance.new("Part")
  					part.Name = "Part"
  					part.Size = Vector3.new(0.3999999761581421, 0.22499984502792358, 0.1250000149011612)
  					part.Position = Vector3.new(15.637451171875, 2.0675048828125, -638.6499633789062)
  					part.Rotation = Vector3.new(-90, 0, 90)
  					part.Anchored = true
  					part.CanCollide = true
  					part.CanQuery = true
  					part.CanTouch = true
  					part.Transparency = 0
  					part.Material = Enum.Material.Metal
  					part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.1882352977991104)

  					-- Parent the part
  					part.Parent = workspace
  					part.Parent = model



  			-- Model: GRIPS
  			local model = Instance.new("Model")
  			model.Name = "GRIPS"
  			model.Parent = workspace

  				-- Model: ANGLED GRIPS / HANDSTOPS
  				local model = Instance.new("Model")
  				model.Name = "ANGLED GRIPS / HANDSTOPS"
  				model.Parent = workspace

  					-- Model: MAGPUL AFG2
  					local model = Instance.new("Model")
  					model.Name = "MAGPUL AFG2"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.12500004470348358, 0.30000007152557373, 0.6000000834465027)
  						part.Position = Vector3.new(18.21240234375, 2.0675048828125, -639.6499633789062)
  						part.Rotation = Vector3.new(0, 0, 90)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Metal
  						part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: MAGPUL AFG MLOK
  					local model = Instance.new("Model")
  					model.Name = "MAGPUL AFG MLOK"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.15000006556510925, 0.5500000715255737, 0.2749999761581421)
  						part.Position = Vector3.new(17.5625, 2.0800018310546875, -639.6499633789062)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: BCM GUNFIGHTER KAG 
  					local model = Instance.new("Model")
  					model.Name = "BCM GUNFIGHTER KAG "
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.12500004470348358, 0.6000000834465027, 0.30000007152557373)
  						part.Position = Vector3.new(17.887451171875, 2.0675048828125, -639.6499633789062)
  						part.Rotation = Vector3.new(90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Metal
  						part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: MAGPUL AFG
  					local model = Instance.new("Model")
  					model.Name = "MAGPUL AFG"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.2500000596046448, 0.699999988079071, 0.29999998211860657)
  						part.Position = Vector3.new(18.53759765625, 2.1300048828125, -639.6749877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: SI COBRA TACTICAL
  					local model = Instance.new("Model")
  					model.Name = "SI COBRA TACTICAL"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.2500000596046448, 0.5500000715255737, 0.22499999403953552)
  						part.Position = Vector3.new(18.862548828125, 2.1300048828125, -639.6749877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model



  				-- Model: VERTICAL FOREGRIPS
  				local model = Instance.new("Model")
  				model.Name = "VERTICAL FOREGRIPS"
  				model.Parent = workspace

  					-- Model: ASh-12 GRIP
  					local model = Instance.new("Model")
  					model.Name = "ASh-12 GRIP"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.20000001788139343, 0.550000011920929)
  						part.Position = Vector3.new(18.637451171875, 2.1049957275390625, -637.6749877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: VIKING TACTICAL UVG
  					local model = Instance.new("Model")
  					model.Name = "VIKING TACTICAL UVG"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.2500000596046448, 0.20000006258487701, 0.42500001192092896)
  						part.Position = Vector3.new(18.5625, 2.1300048828125, -638.4500122070312)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: TANGODOWN STUBBY GRIP
  					local model = Instance.new("Model")
  					model.Name = "TANGODOWN STUBBY GRIP"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.2500000596046448, 0.4749999940395355)
  						part.Position = Vector3.new(19.16259765625, 2.1049957275390625, -637.6749877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: BCM GUNFIGHTER VERTICAL GRIP
  					local model = Instance.new("Model")
  					model.Name = "BCM GUNFIGHTER VERTICAL GRIP"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.12500004470348358, 0.5000001192092896, 0.30000004172325134)
  						part.Position = Vector3.new(18.58740234375, 2.0675048828125, -638.1749877929688)
  						part.Rotation = Vector3.new(0, 0, 90)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Metal
  						part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: KAC VERTICAL GRIP
  					local model = Instance.new("Model")
  					model.Name = "KAC VERTICAL GRIP"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.2500000596046448, 0.5999999642372131)
  						part.Position = Vector3.new(18.66259765625, 2.1049957275390625, -637.4249877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: MAGPUL MOE
  					local model = Instance.new("Model")
  					model.Name = "MAGPUL MOE"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.12500004470348358, 0.2000001072883606, 0.40000003576278687)
  						part.Position = Vector3.new(19.112548828125, 2.0675048828125, -638.2000122070312)
  						part.Rotation = Vector3.new(90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Metal
  						part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: DANIEL DEFENSE VERTICAL GRIP
  					local model = Instance.new("Model")
  					model.Name = "DANIEL DEFENSE VERTICAL GRIP"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.17500004172325134, 0.4500000774860382, 0.20000006258487701)
  						part.Position = Vector3.new(18.58740234375, 2.092498779296875, -637.8999633789062)
  						part.Rotation = Vector3.new(180, 0, 90)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Metal
  						part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: BCM MOD.3
  					local model = Instance.new("Model")
  					model.Name = "BCM MOD.3"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.15000005066394806, 0.25, 0.34999996423721313)
  						part.Position = Vector3.new(19.112548828125, 2.0800018310546875, -638.4500122070312)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: MAGPUL RVG
  					local model = Instance.new("Model")
  					model.Name = "MAGPUL RVG"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.15000005066394806, 0.2500000596046448, 0.4749999940395355)
  						part.Position = Vector3.new(19.16259765625, 2.0800018310546875, -637.9500122070312)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: FORTIS SHIFT
  					local model = Instance.new("Model")
  					model.Name = "FORTIS SHIFT"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.40000003576278687, 0.44999995827674866)
  						part.Position = Vector3.new(18.862548828125, 2.1049957275390625, -638.7999877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model



  				-- Model: ZENITCO FOREGRIPS
  				local model = Instance.new("Model")
  				model.Name = "ZENITCO FOREGRIPS"
  				model.Parent = workspace

  					-- Model: ZENITCO PK-4
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO PK-4"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.30000007152557373, 0.3999999463558197)
  						part.Position = Vector3.new(17.5673828125, 2.1049957275390625, -638.324951171875)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: ZENITCO PK-2
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO PK-2"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.17500004172325134, 0.8000000715255737, 0.2500000596046448)
  						part.Position = Vector3.new(17.73388671875, 2.0975189208984375, -637.430419921875)
  						part.Rotation = Vector3.new(0, 0, 90)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Metal
  						part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: ZENITCO RK-6
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO RK-6"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.1000000536441803, 0.30000007152557373, 0.34999996423721313)
  						part.Position = Vector3.new(17.54248046875, 2.1049957275390625, -638.625)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: ZENITCO PK-1
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO PK-1"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.30000007152557373, 0.625)
  						part.Position = Vector3.new(17.655029296875, 2.1049957275390625, -637.7249755859375)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: ZENITCO PK-1, B-25U MOUNT
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO PK-1, B-25U MOUNT"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.5750001072883606, 0.2500000596046448, 0.4749999940395355)
  						part.Position = Vector3.new(17.6875, 2.3024749755859375, -638.9249877929688)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: ZENITCO PK-5
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO PK-5"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.20000004768371582, 0.30000007152557373, 0.4749999940395355)
  						part.Position = Vector3.new(17.60498046875, 2.1049957275390625, -638.0249633789062)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model


  					-- Model: ZENITCO RK-5
  					local model = Instance.new("Model")
  					model.Name = "ZENITCO RK-5"
  					model.Parent = workspace

  						local part = Instance.new("Part")
  						part.Name = "Part"
  						part.Size = Vector3.new(0.1000000536441803, 0.20000006258487701, 0.4999999701976776)
  						part.Position = Vector3.new(17.992431640625, 2.1049957275390625, -638.625)
  						part.Rotation = Vector3.new(-90, -90, 0)
  						part.Anchored = true
  						part.CanCollide = true
  						part.CanQuery = true
  						part.CanTouch = true
  						part.Transparency = 0
  						part.Material = Enum.Material.Plastic
  						part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

  						-- Parent the part
  						part.Parent = workspace
  						part.Parent = model





  		-- Model: SUPPRESSORS
  		local model = Instance.new("Model")
  		model.Name = "SUPPRESSORS"
  		model.Parent = workspace

  			local part = Instance.new("UnionOperation")
  			part.Name = "STAND"
  			part.Size = Vector3.new(1.6500024795532227, 1.0049999952316284, 4.199993133544922)
  			part.Position = Vector3.new(16.237548828125, 1.50250244140625, -643.6499633789062)
  			part.Rotation = Vector3.new(0, 0, 0)
  			part.Anchored = true
  			part.CanCollide = true
  			part.CanQuery = true
  			part.CanTouch = true
  			part.Transparency = 0
  			part.Material = Enum.Material.Concrete
  			part.Color = Color3.new(0.1882352977991104, 0.18039216101169586, 0.18431372940540314)
  			-- UnionOperation: Note that the actual union shape cannot be recreated via code
  			-- You'll need to use the original union model or recreate it manually

  			-- Parent the part
  			part.Parent = workspace
  			part.Parent = model

  			-- Model: SIG SRD
  			local model = Instance.new("Model")
  			model.Name = "SIG SRD"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.22499997913837433, 0.15000002086162567, 0.9499999284744263)
  				part.Position = Vector3.new(16.46240234375, 2.11749267578125, -645.5499877929688)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: B&T ROTEX 2 4.6x30
  			local model = Instance.new("Model")
  			model.Name = "B&T ROTEX 2 4.6x30"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.22499997913837433, 0.25, 1.1499998569488525)
  				part.Position = Vector3.new(16.362548828125, 2.11749267578125, -645.0499877929688)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: HEXAGON SKS 7.62x39
  			local model = Instance.new("Model")
  			model.Name = "HEXAGON SKS 7.62x39"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.3500000834465027, 0.3500000238418579, 1.450000286102295)
  				part.Position = Vector3.new(16.21240234375, 2.17999267578125, -641.7999877929688)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Plastic
  				part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: TGP 5.45x39
  			local model = Instance.new("Model")
  			model.Name = "TGP 5.45x39"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.20000000298023224, 0.20000003278255463, 1.0500001907348633)
  				part.Position = Vector3.new(16.297607421875, 2.100006103515625, -642.7451171875)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.20000000298023224, 0.20000000298023224, 0.20392157137393951)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: VITYAZ 9x19
  			local model = Instance.new("Model")
  			model.Name = "VITYAZ 9x19"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.2499999850988388, 0.2500000298023224, 1.0499999523162842)
  				part.Position = Vector3.new(16.41259765625, 2.1300048828125, -645.2999877929688)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: PBS-4 5.45x39
  			local model = Instance.new("Model")
  			model.Name = "PBS-4 5.45x39"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.2750000059604645, 0.30000004172325134, 1.3000001907348633)
  				part.Position = Vector3.new(16.16259765625, 2.144805908203125, -642.1499633789062)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.20000000298023224, 0.20000000298023224, 0.20392157137393951)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: ROTOR 43 7.62x39
  			local model = Instance.new("Model")
  			model.Name = "ROTOR 43 7.62x39"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.2750000059604645, 0.30000004172325134, 1.1500002145767212)
  				part.Position = Vector3.new(16.237548828125, 2.144805908203125, -642.4749755859375)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.20000000298023224, 0.20000000298023224, 0.20392157137393951)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: PBS-1 7.62x39
  			local model = Instance.new("Model")
  			model.Name = "PBS-1 7.62x39"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.22499999403953552, 0.2500000298023224, 1.000000238418579)
  				part.Position = Vector3.new(16.33740234375, 2.144805908203125, -643)
  				part.Rotation = Vector3.new(-90, 90, 0)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Metal
  				part.Color = Color3.new(0.20000000298023224, 0.20000000298023224, 0.20392157137393951)

  				-- Parent the part
  				part.Parent = workspace
  				part.Parent = model


  			-- Model: KAC QDSS NTS 5.56x45
  			local model = Instance.new("Model")
  			model.Name = "KAC QDSS NTS 5.56x45"
  			model.Parent = workspace

  				local part = Instance.new("Part")
  				part.Name = "Part"
  				part.Size = Vector3.new(0.1950000375509262, 0.8499999642372131, 0.19999995827674866)
  				part.Position = Vector3.new(16.512451171875, 2.1024932861328125, -644.199951171875)
  				part.Rotation = Vector3.new(0, 0, -90)
  				part.Anchored = true
  				part.CanCollide = true
  				part.CanQuery = true
  				part.CanTouch = true
  				part.Transparency = 0
  				part.Material = Enum.Material.Plastic
  				part.Color = Color3.new(0.18431372940540314, 0.18431372940540314, 0.18431372940540314)
  				part.TopSurface = Enum.SurfaceType.SmoothNoOutlines
  				part.Bottom [trimmed]
end
print("  ✓ THE_COMPREHENSIVE_GUN_KIT__BIG_UPDATE_1")

print("\n=== All Steps Complete ===")
print("All workspace objects have been created!")