# Roblox Capture The Flag - Setup Guide

This repository contains a Roblox Capture The Flag game project with organized workspace exports and utility scripts.

## Project Structure

```
Roblox/
├── RobloxStudio/              # Exported workspace objects from Roblox Studio
│   ├── ZoneParts/             # Zone floors and walls
│   ├── Models/                # 3D models (trees, etc.)
│   ├── Spawnlocations/        # Spawn point definitions
│   └── [other workspace objects]
├── [Scripts and utilities]    # Command bar scripts, setup scripts, etc.
└── StarterPack/               # StarterPack configuration
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/eromrab/RobloxCaptureTheFlag.git
cd RobloxCaptureTheFlag
```

### 2. Prerequisites

- **Roblox Studio** - Download from [roblox.com/create](https://www.roblox.com/create)
- **Python 3** (optional, for export scripts) - Download from [python.org](https://www.python.org/downloads/)
- **Git** - Download from [git-scm.com](https://git-scm.com/downloads)

### 3. Setting Up the Workspace in Roblox Studio

#### Option A: Use Build Scripts (Easiest - Recommended)

1. Open Roblox Studio
2. Create a new place or open an existing one
3. Open Command Bar (View → Command Bar)
4. Run each build script in order:
   - `Build_Step1_Baseplate.lua` - Creates the baseplate
   - `Build_Step2_ZoneParts.lua` - Creates zone floors and walls
   - `Build_Step3_Models.lua` - Creates models (trees, etc.)
   - `Build_Step4_Spawns.lua` - Creates spawn points
   - `Build_Step5a_Other.lua` - Creates other objects
   - `Build_Step5b_GunKit.lua` - Creates gun kit (optional, large file)
5. For each script: Copy ALL code, paste into Command Bar, press Enter
6. Wait for each script to finish before running the next!

#### Option B: Import from Exported Files (Individual)

1. Open Roblox Studio
2. Create a new place or open an existing one
3. For each file in `RobloxStudio/`:
   - Open the `.lua` file in a text editor
   - Copy the code
   - Paste it into Roblox Studio's **Command Bar** (View → Command Bar)
   - Press Enter to execute

#### Option C: Manual Recreation

1. Open Roblox Studio
2. Recreate the objects based on the exported `.lua` files in `RobloxStudio/`
3. Use the code as a reference for properties (size, position, color, etc.)

### 4. Using Utility Scripts

The project includes several utility scripts in the root directory:

- **`AlignZoneFloorsToGround_CommandBar.lua`** - Aligns zone floors to terrain
- **`ExportAllWorkspaceObjects_CommandBar.lua`** - Exports all workspace objects to files
- **`SetupZones_OneTime.lua`** - One-time zone setup script
- **`MakeZonesInvisibleToBlocks.lua`** - Makes zones invisible to blocks

**To use a script:**
1. Open the `.lua` file
2. Copy all the code
3. Paste into Roblox Studio Command Bar
4. Press Enter

## Exporting Your Own Workspace Objects

If you want to export your workspace objects to files:

1. Open Roblox Studio
2. Open the Command Bar (View → Command Bar)
3. Copy and paste the contents of `ExportAllWorkspaceObjects_CommandBar.lua`
4. Press Enter
5. Copy all the output (from `FILE_COUNT:` to the end)
6. Save it to a file named `export.txt` in the project root
7. Run the Python script:
   ```bash
   python create_all_files.py
   ```
8. Organize the files:
   ```bash
   python organize_files.py
   ```

## Folder Organization

### RobloxStudio/
Contains all exported workspace objects, organized by type:
- **ZoneParts/** - Zone floors and walls
- **Models/** - 3D models (trees, props, etc.)
- **Spawnlocations/** - Player spawn points
- Root level - Other workspace objects (guns, rooms, etc.)

### Project Root
Contains utility scripts and configuration:
- Command bar scripts (`*_CommandBar.lua`)
- Setup scripts
- Python utilities
- Configuration files

## Contributing

1. Make your changes
2. Test in Roblox Studio
3. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of changes"
   git push
   ```

## Troubleshooting

### Git Authentication Issues

If you get permission errors when pushing:

1. Install GitHub CLI: [cli.github.com](https://cli.github.com/)
2. Authenticate:
   ```bash
   gh auth login
   ```
3. Configure git to use GitHub CLI:
   ```bash
   git config --global credential.helper "!gh auth git-credential"
   ```

### Python Script Issues

If Python scripts don't work:

1. Ensure Python 3 is installed: `python --version`
2. Make sure you're in the project root directory
3. Check that `export.txt` exists and contains the export output

## Map Layout

The game map follows this structure:
```
[Team A Base] → [Team A Defend] → [Neutral Zone] → [Team B Defend] → [Team B Base]
```

See `GameMap.txt` for a visual representation.

## License

[Add your license here]

## Contact

For questions or issues, open an issue on GitHub or contact the repository owner.

