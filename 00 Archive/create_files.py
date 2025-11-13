#!/usr/bin/env python3
"""
Simple script to create files from Roblox export JSON.
Usage: python create_files.py < export.json
   or: Copy JSON into export.json file and run this script
"""

import json
import sys
import os

def main():
    # Try to read from export.json file
    if os.path.exists('export.json'):
        with open('export.json', 'r', encoding='utf-8') as f:
            json_str = f.read()
    else:
        # Read from stdin
        print("Paste the JSON here (or save to export.json file):")
        json_str = sys.stdin.read()
    
    # Parse JSON
    try:
        data = json.loads(json_str.strip())
    except json.JSONDecodeError as e:
        print(f"Error: Could not parse JSON - {e}")
        print("\nMake sure you copied the complete JSON (from { to })")
        return
    
    if 'files' not in data:
        print("Error: JSON doesn't contain 'files' array")
        return
    
    print(f"Creating {len(data['files'])} files...\n")
    
    created = 0
    for file_info in data['files']:
        filename = file_info['filename']
        code = file_info['code'].replace('\\n', '\n')  # Unescape newlines
        
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(code)
            print(f"✓ {filename}")
            created += 1
        except Exception as e:
            print(f"✗ Error creating {filename}: {e}")
    
    print(f"\n✓ Created {created} files!")

if __name__ == '__main__':
    main()

