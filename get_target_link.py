#!/usr/bin/python3

import os
import sys
import json

source_file = 'chromium.info'
architecture = 'amd64'
data_structure = None
selected = None

try:
    source_file = str(sys.argv[1])
except IndexError:
    pass

try:
    architecture = str(sys.argv[2])
except IndexError:
    pass

if not os.path.isfile(source_file):
    raise SystemExit(f"You need to pass file to parse")

with open(source_file) as json_data:
    data_structure = json.load(json_data)

if data_structure is None:
    raise SystemExit(f"No data to parse")

for available in data_structure['channel-map']:
    if architecture == available['channel']['architecture']:
        selected = available
        break

if selected is None:
    raise SystemExit(f"This architecture is not available")

print(selected['download']['url'])
