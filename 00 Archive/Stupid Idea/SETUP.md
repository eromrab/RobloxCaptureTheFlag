# Quick Setup Guide

## For Your Friend - Step by Step

### Step 1: Get the Code
```bash
git clone https://github.com/eromrab/RobloxCaptureTheFlag.git
cd RobloxCaptureTheFlag
```

### Step 2: Open in Roblox Studio

1. Open **Roblox Studio**
2. Create a new **Baseplate** place (or use an existing one)

### Step 3: Import the Workspace Objects

**EASIEST METHOD - Use the Build Scripts (Run in Order):**

The build scripts are split into smaller chunks to avoid Roblox Studio's size limits.

1. Open **Command Bar** in Roblox Studio (View → Command Bar)
2. Run each script in order:
   - **Step 1**: Open `Build_Step1_Baseplate.lua`, copy ALL code, paste into Command Bar, press Enter
   - **Step 2**: Open `Build_Step2_ZoneParts.lua`, copy ALL code, paste into Command Bar, press Enter
   - **Step 3**: Open `Build_Step3_Models.lua`, copy ALL code, paste into Command Bar, press Enter
   - **Step 4**: Open `Build_Step4_Spawns.lua`, copy ALL code, paste into Command Bar, press Enter
   - **Step 5a**: Open `Build_Step5a_Other.lua`, copy ALL code, paste into Command Bar, press Enter
   - **Step 5b**: Open `Build_Step5b_GunKit.lua`, copy ALL code, paste into Command Bar, press Enter
3. Wait for each script to finish before running the next one!

**Note**: If Step 5b gives a size error, you can skip it - the gun kit is optional.

**ALTERNATIVE METHOD - Import Files Individually:**

If you prefer to import files one at a time:

1. Open **Command Bar** in Roblox Studio (View → Command Bar)
2. For each folder in `RobloxStudio/`:
   - Open the `.lua` files
   - Copy the code
   - Paste into Command Bar
   - Press Enter

**Start with these in order:**
1. `RobloxStudio/ZoneParts/Baseplate.lua` - Creates the baseplate
2. `RobloxStudio/ZoneParts/*.lua` - Creates all zone floors and walls
3. `RobloxStudio/Models/Tree.lua` - Creates trees (run multiple times for multiple trees)
4. `RobloxStudio/Spawnlocations/*.lua` - Creates spawn points
5. Other files in `RobloxStudio/` root

### Step 4: Run Setup Scripts

**Note:** These scripts are in the `00 Archive` folder.

1. Open `00 Archive/SetupZones_OneTime.lua`
2. Copy the code
3. Paste into Command Bar and run

### Step 5: Align Zone Floors to Terrain

1. Open `00 Archive/AlignZoneFloorsToGround_CommandBar.lua`
2. Copy the code
3. Paste into Command Bar and run
4. This will make zone floors follow the terrain

### Step 6: Make Zones Invisible (Optional)

1. Open `00 Archive/MakeZonesInvisibleToBlocks.lua`
2. Copy the code
3. Paste into Command Bar and run

## Alternative: Manual Setup

If you prefer to create objects manually:

1. Look at the `.lua` files in `RobloxStudio/` for reference
2. Each file shows the properties (Size, Position, Color, Material, etc.)
3. Create parts in Roblox Studio with matching properties

## Tips

- **Zone Floors** are translucent (Transparency = 1) - they're invisible but mark zones
- **Zone Walls** are semi-transparent (Transparency = 0.75) - visible boundaries
- **Baseplate** is the main ground (Material = LeafyGrass)
- Run scripts in the **Command Bar** for quick execution

## Need Help?

- Check `README.md` for detailed documentation
- All scripts have comments explaining what they do
- Export scripts are in the root directory if you want to export your own objects

