#!/usr/bin/env python3
"""
Extract JSON from Roblox output and create all Lua files.
This script can read from a text file containing the Roblox output.
"""

import json
import re
import os

def extract_json_from_output(text):
    """Extract the JSON object from Roblox Studio output text."""
    # The JSON starts after "=== COPY THE JSON BELOW AND PASTE IT IN CURSOR ==="
    # and ends before "=== Export Complete ==="
    
    # Find the JSON block
    start_marker = "=== COPY THE JSON BELOW AND PASTE IT IN CURSOR ==="
    end_marker = "=== Export Complete ==="
    
    start_idx = text.find(start_marker)
    if start_idx == -1:
        # Try to find JSON that starts with {"count":
        start_idx = text.find('{"count"')
        if start_idx == -1:
            return None
    else:
        # Skip the marker and find the first {
        start_idx = text.find('{', start_idx)
        if start_idx == -1:
            return None
    
    # Find the matching closing brace
    brace_count = 0
    end_idx = start_idx
    
    for i in range(start_idx, len(text)):
        if text[i] == '{':
            brace_count += 1
        elif text[i] == '}':
            brace_count -= 1
            if brace_count == 0:
                end_idx = i + 1
                break
    
    if brace_count != 0:
        print("Warning: JSON might be incomplete (unbalanced braces)")
        return None
    
    json_str = text[start_idx:end_idx]
    return json_str

def main():
    # Check if user saved the output to a file
    input_file = None
    for filename in ['roblox_output.txt', 'export.txt', 'output.txt']:
        if os.path.exists(filename):
            input_file = filename
            break
    
    if input_file:
        print(f"Reading from {input_file}...")
        with open(input_file, 'r', encoding='utf-8') as f:
            text = f.read()
    else:
        print("No input file found. Please:")
        print("1. Copy the entire output from Roblox Studio (including the JSON)")
        print("2. Save it to a file named 'roblox_output.txt'")
        print("3. Run this script again")
        print("\nOr paste the JSON directly here (just the JSON part, from { to })")
        return
    
    # Extract JSON
    json_str = extract_json_from_output(text)
    if not json_str:
        print("Could not extract JSON from the output.")
        print("Please ensure the file contains the full Roblox Studio output.")
        return
    
    # Parse JSON
    try:
        data = json.loads(json_str)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        print(f"JSON length: {len(json_str)} characters")
        print(f"First 200 chars: {json_str[:200]}")
        print(f"Last 200 chars: {json_str[-200:]}")
        return
    
    if 'files' not in data or 'count' not in data:
        print("Error: JSON structure invalid")
        return
    
    print(f"\nFound {data['count']} files to create\n")
    
    # Create all files
    created = 0
    for file_info in data['files']:
        filename = file_info['filename']
        code = file_info['code']
        
        # Unescape newlines
        code = code.replace('\\n', '\n')
        
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(code)
            print(f"✓ Created: {filename}")
            created += 1
        except Exception as e:
            print(f"✗ Error creating {filename}: {e}")
    
    print(f"\n✓ Successfully created {created} out of {data['count']} files!")

if __name__ == '__main__':
    main()

