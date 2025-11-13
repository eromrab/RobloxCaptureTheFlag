#!/usr/bin/env python3
"""
Script to parse Roblox export JSON and create all Lua files.
Usage: Copy the JSON output from Roblox Studio and paste it here, or save to export.json
"""

import json
import sys
import re
import os

def extract_json_from_text(text):
    """Extract JSON object from text that may contain other content."""
    # Try to find JSON object that starts with {"count":
    pattern = r'\{[^{]*"count"\s*:\s*\d+.*?\}'
    matches = re.findall(pattern, text, re.DOTALL)
    
    if not matches:
        # Try a more general approach - find the largest JSON-like structure
        # Look for balanced braces
        start_idx = text.find('{"count"')
        if start_idx == -1:
            return None
        
        # Find matching closing brace
        brace_count = 0
        for i in range(start_idx, len(text)):
            if text[i] == '{':
                brace_count += 1
            elif text[i] == '}':
                brace_count -= 1
                if brace_count == 0:
                    return text[start_idx:i+1]
    
    # If we found matches, try to parse the longest one
    if matches:
        for match in sorted(matches, key=len, reverse=True):
            try:
                json.loads(match)
                return match
            except:
                continue
    
    return None

def main():
    # Try to read from file first
    if os.path.exists('export.json'):
        with open('export.json', 'r', encoding='utf-8') as f:
            json_str = f.read()
    else:
        # Read from stdin
        print("Paste the JSON output from Roblox Studio (or press Ctrl+Z then Enter to finish):")
        json_str = sys.stdin.read()
    
    # Extract JSON if it's embedded in other text
    if not json_str.strip().startswith('{'):
        extracted = extract_json_from_text(json_str)
        if extracted:
            json_str = extracted
        else:
            print("Error: Could not find valid JSON in input")
            print("Please ensure the JSON starts with {\"count\":")
            sys.exit(1)
    
    try:
        data = json.loads(json_str)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        print("\nTrying to fix common JSON issues...")
        # Try to fix escaped newlines
        json_str = json_str.replace('\\n', '\n')
        try:
            data = json.loads(json_str)
        except:
            print("Could not parse JSON. Please check the format.")
            sys.exit(1)
    
    if 'files' not in data or 'count' not in data:
        print("Error: JSON does not have expected structure (missing 'files' or 'count')")
        sys.exit(1)
    
    print(f"Found {data['count']} files to create\n")
    
    created_count = 0
    for file_info in data['files']:
        filename = file_info['filename']
        code = file_info['code']
        
        # Unescape newlines if needed
        if '\\n' in code:
            code = code.replace('\\n', '\n')
        
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(code)
            print(f"✓ Created: {filename}")
            created_count += 1
        except Exception as e:
            print(f"✗ Error creating {filename}: {e}")
    
    print(f"\n✓ Successfully created {created_count} out of {data['count']} files!")

if __name__ == '__main__':
    main()

