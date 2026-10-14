#!/usr/bin/env python3
"""Restore ignored119 tool names from exact versioned source aliases.

Does not create or commit any seed/packet data. Existing files must match;
never overwrite a mismatching frozen source.
"""
from pathlib import Path
import hashlib
import json

root = Path(__file__).resolve().parents[1]
record = json.loads((root / 'notes/run/KEYGEN_INPUT119_SOURCE_ALIASES.json').read_text())
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

for row in record['aliases']:
    tracked = root / row['tracked']
    original = root / row['original']
    assert sha(tracked) == row['sha256'], ('INTEGRITY_STOP', str(tracked))
    if original.exists():
        assert sha(original) == row['sha256'], ('INTEGRITY_STOP', str(original))
    else:
        with original.open('xb') as stream:
            stream.write(tracked.read_bytes())
        assert sha(original) == row['sha256'], ('INTEGRITY_STOP', str(original))
print('119 source aliases and frozen original tool names match exactly')
