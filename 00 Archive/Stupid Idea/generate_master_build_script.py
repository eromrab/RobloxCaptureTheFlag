#!/usr/bin/env python3
"""
Generates multiple smaller Lua scripts that build all workspace objects
from the exported files in RobloxStudio/
Split into chunks to avoid Roblox Studio's 100,000 character limit
"""
from pathlib import Path

roblox_studio = Path("RobloxStudio")

if not roblox_studio.exists():
    print("Error: RobloxStudio folder not found!")
    exit(1)

print("Generating build scripts (split into chunks to avoid size limits)...")

# Helper function to create a script chunk
def create_script_chunk(title, description):
    return [
        f"-- {title}",
        f"-- {description}",
        "-- Paste this script into Roblox Studio Command Bar (View > Command Bar)",
        "",
        "local workspace = game:GetService(\"Workspace\")",
        "",
    ]

# Step 1: Baseplate
step1_lines = create_script_chunk(
    "STEP 1: Create Baseplate",
    "Run this script first to create the baseplate"
)
step1_lines.append("print(\"=== Step 1: Creating Baseplate ===\")")
step1_lines.append("")

baseplate_file = roblox_studio / "ZoneParts" / "Baseplate.lua"
if baseplate_file.exists():
    step1_lines.append("do")
    with open(baseplate_file, 'r', encoding='utf-8') as f:
        code = f.read()
        indented_code = '\n'.join(['  ' + line if line.strip() else line for line in code.split('\n')])
        step1_lines.append(indented_code)
    step1_lines.append("end")
    step1_lines.append("print(\"  ✓ Baseplate created\")")

# Step 2: Zone Parts (excluding baseplate)
step2_lines = create_script_chunk(
    "STEP 2: Create Zone Parts",
    "Run this script second to create all zone floors and walls"
)
step2_lines.append("print(\"=== Step 2: Creating Zone Parts ===\")")
step2_lines.append("")

zone_parts_folder = roblox_studio / "ZoneParts"
if zone_parts_folder.exists():
    zone_files = sorted([f for f in zone_parts_folder.glob("*.lua") if f.name != "Baseplate.lua"])
    for zone_file in zone_files:
        step2_lines.append(f"-- Creating {zone_file.stem}")
        step2_lines.append("do")
        with open(zone_file, 'r', encoding='utf-8') as f:
            code = f.read()
            indented_code = '\n'.join(['  ' + line if line.strip() else line for line in code.split('\n')])
            step2_lines.append(indented_code)
        step2_lines.append("end")
        step2_lines.append(f"print(\"  ✓ {zone_file.stem}\")")
        step2_lines.append("")

# Step 3: Models
step3_lines = create_script_chunk(
    "STEP 3: Create Models",
    "Run this script third to create all models (trees, etc.)"
)
step3_lines.append("print(\"=== Step 3: Creating Models ===\")")
step3_lines.append("")

models_folder = roblox_studio / "Models"
if models_folder.exists():
    model_files = sorted(models_folder.glob("*.lua"))
    for i, model_file in enumerate(model_files, 1):
        step3_lines.append(f"-- Creating {model_file.stem} (Model #{i})")
        step3_lines.append("do")
        with open(model_file, 'r', encoding='utf-8') as f:
            code = f.read()
            indented_code = '\n'.join(['  ' + line if line.strip() else line for line in code.split('\n')])
            step3_lines.append(indented_code)
        step3_lines.append("end")
        step3_lines.append(f"print(\"  ✓ {model_file.stem} #{i} created\")")
        step3_lines.append("")

# Step 4: Spawn Locations
step4_lines = create_script_chunk(
    "STEP 4: Create Spawn Locations",
    "Run this script fourth to create spawn points"
)
step4_lines.append("print(\"=== Step 4: Creating Spawn Locations ===\")")
step4_lines.append("")

spawns_folder = roblox_studio / "Spawnlocations"
if spawns_folder.exists():
    spawn_files = sorted(spawns_folder.glob("*.lua"))
    for spawn_file in spawn_files:
        step4_lines.append(f"-- Creating {spawn_file.stem}")
        step4_lines.append("do")
        with open(spawn_file, 'r', encoding='utf-8') as f:
            code = f.read()
            indented_code = '\n'.join(['  ' + line if line.strip() else line for line in code.split('\n')])
            step4_lines.append(indented_code)
        step4_lines.append("end")
        step4_lines.append(f"print(\"  ✓ {spawn_file.stem}\")")
        step4_lines.append("")

# Step 5: Other Objects (split into 5a and 5b due to size)
step5a_lines = create_script_chunk(
    "STEP 5a: Create Other Objects (Part 1)",
    "Run this script to create AR, Part, Spawn_Room, and ThumbnailMaterial"
)
step5a_lines.append("print(\"=== Step 5a: Creating Other Objects (Part 1) ===\")")
step5a_lines.append("")

step5b_lines = create_script_chunk(
    "STEP 5b: Create Gun Kit",
    "Run this script last to create THE_COMPREHENSIVE_GUN_KIT (large file)"
)
step5b_lines.append("print(\"=== Step 5b: Creating Gun Kit ===\")")
step5b_lines.append("")

other_files = sorted([f for f in roblox_studio.glob("*.lua")])
for other_file in other_files:
    # Check file size to decide which script it goes in
    file_size = other_file.stat().st_size
    is_gun_kit = "GUN_KIT" in other_file.name.upper()
    
    target_lines = step5b_lines if is_gun_kit else step5a_lines
    
    target_lines.append(f"-- Creating {other_file.stem}")
    target_lines.append("do")
    with open(other_file, 'r', encoding='utf-8') as f:
        code = f.read()
        indented_code = '\n'.join(['  ' + line if line.strip() else line for line in code.split('\n')])
        target_lines.append(indented_code)
    target_lines.append("end")
    target_lines.append(f"print(\"  ✓ {other_file.stem}\")")
    target_lines.append("")

step5b_lines.append("print(\"\\n=== All Steps Complete ===\")")
step5b_lines.append("print(\"All workspace objects have been created!\")")

# Write all scripts
scripts = [
    ("Build_Step1_Baseplate.lua", step1_lines),
    ("Build_Step2_ZoneParts.lua", step2_lines),
    ("Build_Step3_Models.lua", step3_lines),
    ("Build_Step4_Spawns.lua", step4_lines),
    ("Build_Step5a_Other.lua", step5a_lines),
    ("Build_Step5b_GunKit.lua", step5b_lines),
]

for filename, lines in scripts:
    with open(filename, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    char_count = len('\n'.join(lines))
    print(f"✓ Generated {filename} ({len(lines)} lines, {char_count:,} chars)")

# Create a README for the build process
readme_lines = [
    "# Build Scripts - Run in Order",
    "",
    "These scripts are split into smaller chunks to avoid Roblox Studio's 100,000 character limit.",
    "",
    "## Instructions:",
    "",
    "1. Open Roblox Studio",
    "2. Open Command Bar (View > Command Bar)",
    "3. Run each script in order:",
    "",
]

for i, (filename, _) in enumerate(scripts, 1):
    readme_lines.append(f"   **Step {i}**: Open `{filename}`, copy ALL code, paste into Command Bar, press Enter")
    readme_lines.append("")

readme_lines.append("## Note:")
readme_lines.append("Each script must be run completely before moving to the next one.")
readme_lines.append("Wait for the success message before running the next script.")

with open("BUILD_INSTRUCTIONS.md", 'w', encoding='utf-8') as f:
    f.write('\n'.join(readme_lines))

print(f"\n✓ Generated BUILD_INSTRUCTIONS.md")
print(f"\nTo use:")
print(f"  1. Run each script in order (Step 1, then Step 2, etc.)")
print(f"  2. Each script is small enough to paste into Command Bar")
print(f"  3. Wait for each script to finish before running the next")

