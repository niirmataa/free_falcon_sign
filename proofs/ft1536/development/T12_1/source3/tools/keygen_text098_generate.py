#!/usr/bin/env python3
"""Serialize public source lines as Lean data; kernel equality is separate."""
from pathlib import Path
import hashlib
import json
import sys

root = Path(__file__).resolve().parents[1]
source = Path(sys.argv[1]).resolve()
value = json.loads(source.read_text())
assert isinstance(value, list) and len(value) == 185 and all(isinstance(line, str) and line.isascii() for line in value)
literal = ',\n  '.join(json.dumps(line, ensure_ascii=True) for line in value)
text = '''import Source3.KeygenZintExtractArity098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBezoutText098

def lines : List String := [
  ''' + literal + '''
]
def chars : List Char := lines.flatMap String.toList ++ ['}']

theorem source_lines : (Pinned.keygenLines.drop 4014).take 185 = lines := by decide +kernel

theorem source_chars :
    ((Pinned.keygenLines.drop 4014).take 185).flatMap String.toList ++ ['}'] = chars := by
  rw [source_lines]
  rfl

end FT1536.Source3.KeygenBezoutText098
'''
target = root / 'formal/Source3/KeygenBezoutText098.lean'
if target.exists():
    if target.read_text() != text:
        preserved = root / '.build/key_law088/attempts098/KeygenBezoutText098_chars.lean'
        assert preserved.exists() and target.read_bytes() == preserved.read_bytes(), 'Refusing to replace an unpreserved different source'
        target.write_text(text)
else:
    target.write_text(text)
print(json.dumps({'input': str(source), 'input_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                  'output': str(target), 'output_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                  'role': 'source data serialization; source_chars needs kernel acceptance'}))
