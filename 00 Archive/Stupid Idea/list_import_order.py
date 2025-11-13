#!/usr/bin/env python3
"""
Lists the recommended import order for Roblox Studio files
"""
from pathlib import Path

roblox_studio = Path("RobloxStudio")

if not roblox_studio.exists():
    print("RobloxStudio folder not found!")
    print("Make sure you're in the project root directory.")
    exit(1)

print("=" * 60)
print("RECOMMENDED IMPORT ORDER FOR ROBLOX STUDIO")
print("=" * 60)
print("\nCopy each file's code into Roblox Studio Command Bar and run it.\n")

# Step 1: Baseplate (foundation)
print("STEP 1: Create Baseplate (Foundation)")
print("-" * 60)
baseplate = roblox_studio / "ZoneParts" / "Baseplate.lua"
if baseplate.exists():
    print(f"  ✓ {baseplate}")

# Step 2: Zone Parts
print("\nSTEP 2: Create Zone Parts")
print("-" * 60)
zone_parts = roblox_studio / "ZoneParts"
if zone_parts.exists():
    files = sorted(zone_parts.glob("*.lua"))
    for f in files:
        if f.name != "Baseplate.lua":  # Already listed
            print(f"  ✓ {f}")

# Step 3: Models
print("\nSTEP 3: Create Models")
print("-" * 60)
models = roblox_studio / "Models"
if models.exists():
    files = sorted(models.glob("*.lua"))
    for f in files:
        print(f"  ✓ {f}")
        if f.name == "Tree.lua":
            print("    (Run this multiple times to create multiple trees)")

# Step 4: Spawn Locations
print("\nSTEP 4: Create Spawn Locations")
print("-" * 60)
spawns = roblox_studio / "Spawnlocations"
if spawns.exists():
    files = sorted(spawns.glob("*.lua"))
    for f in files:
        print(f"  ✓ {f}")

# Step 5: Other objects
print("\nSTEP 5: Create Other Objects")
print("-" * 60)
other_files = []
for f in roblox_studio.glob("*.lua"):
    other_files.append(f)
if other_files:
    for f in sorted(other_files):
        print(f"  ✓ {f}")
else:
    print("  (No other objects)")

# Step 6: Setup scripts
print("\nSTEP 6: Run Setup Scripts (from project root or 00 Archive folder)")
print("-" * 60)
setup_scripts = [
    "SetupZones_OneTime.lua",
    "AlignZoneFloorsToGround_CommandBar.lua",
    "MakeZonesInvisibleToBlocks.lua"
]
archive_folder = Path("00 Archive")
for script in setup_scripts:
    script_path = Path(script)
    archive_path = archive_folder / script if archive_folder.exists() else None
    
    if script_path.exists():
        print(f"  ✓ {script}")
    elif archive_path and archive_path.exists():
        print(f"  ✓ {archive_path} (in archive folder)")
    else:
        print(f"  - {script} (not found)")

print("\n" + "=" * 60)
print("IMPORT TIPS:")
print("=" * 60)
print("1. Open Roblox Studio Command Bar (View → Command Bar)")
print("2. Copy code from each .lua file")
print("3. Paste into Command Bar and press Enter")
print("4. Objects will be created in your workspace")
print("5. Run setup scripts after all objects are created")
print("\nFor detailed instructions, see SETUP.md")

