import json
import sys
import re

# Read the full input
input_text = sys.stdin.read()

# Extract JSON from the input (look for the JSON object)
# The JSON starts with {"count": and ends with }
json_match = re.search(r'\{.*"count":\d+.*\}', input_text, re.DOTALL)
if not json_match:
    print("Could not find JSON in input")
    sys.exit(1)

json_str = json_match.group(0)
try:
    data = json.loads(json_str)
except json.JSONDecodeError as e:
    print(f"Error parsing JSON: {e}")
    sys.exit(1)

print(f"Found {data['count']} files to create")

# Create all files
for file_info in data['files']:
    filename = file_info['filename']
    code = file_info['code']
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(code)
    
    print(f"Created: {filename}")

print(f"\nSuccessfully created {len(data['files'])} files!")

