#!/usr/bin/env python3
"""
Organize files into RobloxStudio folder structure matching Roblox workspace
"""
import os
import shutil
from pathlib import Path

# Create RobloxStudio folder structure
roblox_studio = Path("RobloxStudio")
roblox_studio.mkdir(exist_ok=True)

# Folder mappings based on filename prefixes
folder_mappings = {
    "ZoneParts_": "ZoneParts",
    "Models_": "Models",
    "Spawnlocations_": "Spawnlocations",
}

# Files that should go in RobloxStudio root
roblox_files = [
    "AR.lua",
    "Part.lua",
    "Spawn_Room.lua",
    "ThumbnailMaterial.lua",
    "THE_COMPREHENSIVE_GUN_KIT__BIG_UPDATE_1.lua",
    "Models_Tree.lua",  # Will be handled separately
]

# Files that should stay in project root (scripts, configs, etc.)
project_files = [
    "AlignWallsToGrid.lua",
    "AlignZoneFloorsToGround_CommandBar.lua",
    "Baseplate.lua",
    "DoubleShiftSpeed_CommandBar.lua",
    "DoubleShiftSpeed.lua",
    "ExportAllWorkspaceObjects_CommandBar.lua",
    "FixGunTool_CommandBar.lua",
    "FixGunTool.lua",
    "GetAndSetBlockSize_CommandBar.lua",
    "GetAndSetBlockSize.lua",
    "GetPartCode.lua",
    "MakeZonesInvisibleToBlocks.lua",
    "MidpointZoneWall.lua",
    "SetupZones_OneTime.lua",
    "TeamABaseZoneWall.lua",
    "TeamAMidpointZoneWall.lua",
    "TeamBBaseZoneWall.lua",
    "TeamBMidpointZoneWall.lua",
    "ZoneFloors.lua",
    "GameMap.txt",
    "Roblox.code-workspace",
    # Python scripts
    "create_all_files.py",
    "create_exported_files.py",
    "create_files_from_json.py",
    "create_files.py",
    "extract_and_create.py",
    "parse_export.py",
    "organize_files.py",
    # Export files
    "export.json",
    "export.txt",
    # StarterPack folder
    "StarterPack",
]

# Get all .lua files in current directory
current_dir = Path(".")
all_lua_files = list(current_dir.glob("*.lua"))

moved_count = 0
tree_count = 0

# Process each Lua file
for file_path in all_lua_files:
    filename = file_path.name
    
    # Skip if it's a project file (script)
    if filename in project_files:
        continue
    
    # Check if it matches a folder pattern
    moved = False
    for prefix, folder_name in folder_mappings.items():
        if filename.startswith(prefix):
            target_folder = roblox_studio / folder_name
            target_folder.mkdir(exist_ok=True)
            
            # Special handling for Models_Tree - add number suffix if multiple
            if prefix == "Models_" and filename == "Models_Tree.lua":
                tree_count += 1
                if tree_count > 1:
                    # Check if file already exists, if so, rename
                    target_path = target_folder / f"Tree_{tree_count}.lua"
                    if target_path.exists():
                        # Find next available number
                        counter = tree_count
                        while target_path.exists():
                            counter += 1
                            target_path = target_folder / f"Tree_{counter}.lua"
                else:
                    target_path = target_folder / "Tree.lua"
            else:
                # Remove prefix from filename
                new_filename = filename[len(prefix):]
                target_path = target_folder / new_filename
            
            shutil.move(str(file_path), str(target_path))
            print(f"✓ Moved {filename} → RobloxStudio/{folder_name}/{target_path.name}")
            moved = True
            moved_count += 1
            break
    
    # If not moved yet and it's a Roblox file, move to RobloxStudio root
    if not moved and filename in roblox_files:
        target_path = roblox_studio / filename
        shutil.move(str(file_path), str(target_path))
        print(f"✓ Moved {filename} → RobloxStudio/")
        moved_count += 1

print(f"\n✓ Organized {moved_count} files into RobloxStudio folder")
print(f"\nFolder structure:")
print("RobloxStudio/")
for folder in sorted(roblox_studio.iterdir()):
    if folder.is_dir():
        file_count = len(list(folder.glob("*.lua")))
        print(f"  {folder.name}/ ({file_count} files)")
    else:
        print(f"  {folder.name}")

