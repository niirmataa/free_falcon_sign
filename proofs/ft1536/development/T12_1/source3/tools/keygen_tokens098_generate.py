#!/usr/bin/env python3
"""Serialize generated public tokens as Lean data; not a correctness checker."""
from pathlib import Path
import hashlib
import json
import sys

root = Path(__file__).resolve().parents[1]
source = Path(sys.argv[1]).resolve()
values = json.loads(source.read_text())
assert isinstance(values, list) and values and all(isinstance(v, str) for v in values)
rows = [', '.join(json.dumps(v, ensure_ascii=True) for v in values[i:i+10]) for i in range(0, len(values), 10)]
literal = ',\n    '.join(rows)
text = '''import Source3.KeygenBezoutText098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBezoutTokens098

/-- Exact original source input of bezoutParsed 7, including its parser
    closing delimiter. The public token data below is kernel-checked. -/
def chars : List Char :=
  ((Pinned.keygenLines.drop 4014).take 185).flatMap String.toList ++ ['}']

def tokens : List B20.C.Token :=
  ([
    ''' + literal + '''
  ] : List String).map String.toList

theorem source : KeygenZintCall.tokens chars = some tokens := by
  have exactText : chars = KeygenBezoutText098.chars := KeygenBezoutText098.source_chars
  rw [exactText]
  decide +kernel

end FT1536.Source3.KeygenBezoutTokens098
'''
target = root / 'formal/Source3/KeygenBezoutTokens098.lean'
if target.exists():
    assert target.read_text() == text, 'Refusing to replace a different generated source'
else:
    target.write_text(text)
print(json.dumps({'input': str(source), 'input_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                  'output': str(target), 'output_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                  'role': 'source data serialization; theorem source must pass kernel'}))
