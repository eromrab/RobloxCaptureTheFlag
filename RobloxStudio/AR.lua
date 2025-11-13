-- Model: AR
local model = Instance.new("Model")
model.Name = "AR"
model.Parent = workspace

	local part = Instance.new("MeshPart")
	part.Name = "HumanoidRootPart"
	part.Size = Vector3.new(1, 1, 1)
	part.Position = Vector3.new(47.99867248535156, 4.240767002105713, -610.0000610351562)
	part.Rotation = Vector3.new(0, 90, 0)
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 1
	part.Material = Enum.Material.Plastic
	part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("MeshPart")
	part.Name = "LeftArm"
	part.Size = Vector3.new(0.7984756827354431, 4.190553188323975, 0.8284757137298584)
	part.Position = Vector3.new(45.884193420410156, 2.895190715789795, -610.7051391601562)
	part.Rotation = Vector3.new(-8.567999839782715, -25.29599952697754, 78.03700256347656)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.SmoothPlastic
	part.Color = Color3.new(1, 0.800000011920929, 0.6000000238418579)
	part.MeshId = "rbxasset://fonts/leftarm.mesh"

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("MeshPart")
	part.Name = "RightArm"
	part.Size = Vector3.new(0.7984756827354431, 4.210551738739014, 0.8284757137298584)
	part.Position = Vector3.new(47.937625885009766, 3.0183935165405273, -611.6468505859375)
	part.Rotation = Vector3.new(0, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.SmoothPlastic
	part.Color = Color3.new(1, 0.800000011920929, 0.6000000238418579)
	part.MeshId = "rbxasset://fonts/leftarm.mesh"

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("MeshPart")
	part.Name = "FakeCamera"
	part.Size = Vector3.new(1, 1, 1)
	part.Position = Vector3.new(47.99867248535156, 4.225992202758789, -610.0000610351562)
	part.Rotation = Vector3.new(0, 90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 1
	part.Material = Enum.Material.Plastic
	part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Connector"
	part.Size = Vector3.new(0.22577036917209625, 0.10034240037202835, 0.25085586309432983)
	part.Position = Vector3.new(45.7036018371582, 3.5371499061584473, -611.6270751953125)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "DustCover"
	part.Size = Vector3.new(0.17559917271137238, 0.10034243762493134, 0.5017117261886597)
	part.Position = Vector3.new(45.59379959106445, 3.644941806793213, -611.7389526367188)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "ChargingHandle"
	part.Size = Vector3.new(0.37628382444381714, 0.10034234821796417, 1.0034235715866089)
	part.Position = Vector3.new(45.80400466918945, 3.826223850250244, -611.6165161132812)
	part.Rotation = Vector3.new(0, 90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1921568661928177, 0.1921568661928177, 0.1921568661928177)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Trigger"
	part.Size = Vector3.new(0.22577036917209625, 0.7525678277015686, 0.4013693928718567)
	part.Position = Vector3.new(45.96953201293945, 3.4849724769592285, -611.6390991210938)
	part.Rotation = Vector3.new(90, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Stick"
	part.Size = Vector3.new(0.27594155073165894, 0.05017121881246567, 0.050171177834272385)
	part.Position = Vector3.new(46.1953010559082, 3.6103997230529785, -611.6190185546875)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Dot"
	part.Size = Vector3.new(0.22577036917209625, 0.20068475604057312, 0.10034231841564178)
	part.Position = Vector3.new(45.7537727355957, 3.6155457496643066, -611.6090087890625)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Handle"
	part.Size = Vector3.new(0.17559920251369476, 0.40136948227882385, 0.3010270297527313)
	part.Position = Vector3.new(46.2604866027832, 3.143721342086792, -611.6390991210938)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "StockParts"
	part.Size = Vector3.new(0.12542793154716492, 0.7525678277015686, 1.0535948276519775)
	part.Position = Vector3.new(47.24895095825195, 3.459982395172119, -611.6365966796875)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1725490242242813, 0.16862745583057404, 0.1725490242242813)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Bolt"
	part.Size = Vector3.new(0.8779956102371216, 0.10034237802028656, 0.10034234821796417)
	part.Position = Vector3.new(45.8140754699707, 3.7409729957580566, -611.6416015625)
	part.Rotation = Vector3.new(0, 0, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.4313725531101227, 0.4313725531101227, 0.43921568989753723)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "ModeSelect"
	part.Size = Vector3.new(0.050171248614788055, 0.10034249722957611, 0.20068468153476715)
	part.Position = Vector3.new(46.11455154418945, 3.5501351356506348, -611.623046875)
	part.Rotation = Vector3.new(0, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "CheekRest"
	part.Size = Vector3.new(0.22577029466629028, 0.20068475604057312, 0.8027388453483582)
	part.Position = Vector3.new(47.21879959106445, 3.6856064796447754, -611.6365966796875)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1725490242242813, 0.16862745583057404, 0.1725490242242813)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "MuzzleBreak"
	part.Size = Vector3.new(0.22577030956745148, 0.15051355957984924, 0.15051352977752686)
	part.Position = Vector3.new(42.68052673339844, 3.725782871246338, -611.6583251953125)
	part.Rotation = Vector3.new(-90, 0, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "StockFrame"
	part.Size = Vector3.new(0.17559920251369476, 1.0034236907958984, 0.20068463683128357)
	part.Position = Vector3.new(46.75786209106445, 3.7108407020568848, -611.6382446289062)
	part.Rotation = Vector3.new(90, 0, 90.4000015258789)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Mag"
	part.Size = Vector3.new(0.12542802095413208, 1.0034235715866089, 0.4515405297279358)
	part.Position = Vector3.new(45.51298904418945, 3.143721342086792, -611.6390991210938)
	part.Rotation = Vector3.new(180, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "JamClear"
	part.Size = Vector3.new(0.22577030956745148, 0.10034237802028656, 0.10034234821796417)
	part.Position = Vector3.new(46.23796463012695, 3.7208847999572754, -611.7770385742188)
	part.Rotation = Vector3.new(0, 0, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.19607843458652496, 0.19607843458652496, 0.20000000298023224)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Rail"
	part.Size = Vector3.new(0.2508558928966522, 0.3511984050273895, 2.2577030658721924)
	part.Position = Vector3.new(44.21861267089844, 3.695650577545166, -611.6425170898438)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "RailJoint"
	part.Size = Vector3.new(0.20068471133708954, 0.2508559823036194, 0.15051351487636566)
	part.Position = Vector3.new(45.2773323059082, 3.7208847999572754, -611.6396484375)
	part.Rotation = Vector3.new(-0.4000000059604645, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "TriggerGuard"
	part.Size = Vector3.new(0.12542802095413208, 0.5518830418586731, 0.5518829226493835)
	part.Position = Vector3.new(45.9996223449707, 3.3044228553771973, -611.6390991210938)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.4000000059604645, 0.33725491166114807, 0.2980392277240753)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "FrontSight"
	part.Size = Vector3.new(0.15051354467868805, 0.30102720856666565, 0.45154064893722534)
	part.Position = Vector3.new(43.79228210449219, 3.8311219215393066, -611.6425170898438)
	part.Rotation = Vector3.new(90, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.20000000298023224, 0.20000000298023224, 0.20392157137393951)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Stock"
	part.Size = Vector3.new(0.1755991280078888, 0.852910041809082, 1.0034235715866089)
	part.Position = Vector3.new(47.1887092590332, 3.414663791656494, -611.6365966796875)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.34117648005485535, 0.29019609093666077, 0.2549019753932953)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "RearSight"
	part.Size = Vector3.new(0.12542793154716492, 0.05017118528485298, 0.20068469643592834)
	part.Position = Vector3.new(45.9645881652832, 3.9616951942443848, -611.6466064453125)
	part.Rotation = Vector3.new(90, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.24313725531101227, 0.24313725531101227, 0.24705882370471954)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Barrel"
	part.Size = Vector3.new(0.15051354467868805, 2.6590726375579834, 0.15051351487636566)
	part.Position = Vector3.new(44.02299499511719, 3.725782871246338, -611.6475219726562)
	part.Rotation = Vector3.new(90, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Connector"
	part.Size = Vector3.new(0.20068471133708954, 0.10034242272377014, 0.20068471133708954)
	part.Position = Vector3.new(45.2271614074707, 3.725782871246338, -611.6396484375)
	part.Rotation = Vector3.new(-90, 0, -90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "LowerReceiver"
	part.Size = Vector3.new(0.17559920251369476, 0.5518830418586731, 1.053594708442688)
	part.Position = Vector3.new(45.8390998840332, 3.5601792335510254, -611.6390991210938)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "UpperReceiver"
	part.Size = Vector3.new(0.25587308406829834, 0.3010271489620209, 1.0034235715866089)
	part.Position = Vector3.new(45.77385330200195, 3.730928897857666, -611.6842651367188)
	part.Rotation = Vector3.new(0, -90, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.21568627655506134, 0.21568627655506134, 0.21960784494876862)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "Main"
	part.Size = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
	part.Position = Vector3.new(46.669857025146484, 3.0766854286193848, -611.6993408203125)
	part.Rotation = Vector3.new(0, 0, 0)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 1
	part.Material = Enum.Material.Plastic
	part.Color = Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model

	local part = Instance.new("Part")
	part.Name = "RearSightAdjust"
	part.Size = Vector3.new(0.12542793154716492, 0.2508558928966522, 0.050171177834272385)
	part.Position = Vector3.new(45.8992805480957, 3.886488437652588, -611.6466064453125)
	part.Rotation = Vector3.new(90, 0, 90)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = true
	part.Transparency = 0
	part.Material = Enum.Material.Metal
	part.Color = Color3.new(0.24313725531101227, 0.24313725531101227, 0.24705882370471954)

	-- Parent the part
	part.Parent = workspace
	part.Parent = model