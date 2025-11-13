#!/usr/bin/env python3
import os
import re

# Read the export file
input_file = 'export.txt'
if not os.path.exists(input_file):
    print(f"Error: {input_file} not found!")
    print("Please save the Roblox Studio output to export.txt")
    exit(1)

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Parse the file format
# Look for FILE_COUNT (may have timestamp prefix)
count_match = re.search(r'FILE_COUNT:(\d+)', content)
if count_match:
    expected_count = int(count_match.group(1))
    print(f"Found {expected_count} files to create\n")
else:
    print("Warning: Could not find FILE_COUNT")
    expected_count = 0

# Extract each file
# Split by FILE_START markers
file_sections = re.split(r'===FILE_START===', content)

created = 0
for section in file_sections[1:]:  # Skip first section (before first FILE_START)
    # Extract filename - handle format: "timestamp  FILENAME:filename.lua  -  Edit"
    filename_match = re.search(r'FILENAME:([^\s]+(?:\.lua)?)', section)
    if not filename_match:
        continue
    
    filename = filename_match.group(1).strip()
    
    # Extract code between CODE_START and CODE_END
    code_match = re.search(r'CODE_START(?:\s+-\s+Edit)?\s+(.+?)(?:^\s*\d+:\d+:\d+\.\d+\s+)?CODE_END', section, re.DOTALL | re.MULTILINE)
    if not code_match:
        continue
    
    code = code_match.group(1)
    
    # Clean up timestamps from code lines
    # Remove lines that are just timestamps: "  timestamp  -  Edit"
    lines = code.split('\n')
    cleaned_lines = []
    for line in lines:
        # Skip lines that are just timestamps with " -  Edit"
        if re.match(r'^\s*\d+:\d+:\d+\.\d+\s+-\s+Edit\s*$', line):
            continue
        # Remove timestamp prefix from code lines: "  timestamp  code"
        line = re.sub(r'^\s*\d+:\d+:\d+\.\d+\s+(.+)$', r'\1', line)
        # Remove " -  Edit" suffix if present
        line = re.sub(r'\s+-\s+Edit\s*$', '', line)
        cleaned_lines.append(line)
    
    code = '\n'.join(cleaned_lines).strip()
    
    try:
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(code)
        print(f"✓ {filename}")
        created += 1
    except Exception as e:
        print(f"✗ Error creating {filename}: {e}")

print(f"\n✓ Created {created} out of {expected_count} files!")

