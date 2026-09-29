#!/usr/bin/env python3
"""Lossless source transport, with all syntax claims checked again by Lean."""
from pathlib import Path
import hashlib
import json
import os
import re

source = Path(os.environ['P02_INPUTS']) / 'source17/shake.c'
raw = source.read_bytes()
expected = 'c3e7864bf4139264f8c287053214bf869e242757bf555235da81454e40ea316a'
assert hashlib.sha256(raw).hexdigest() == expected
lines = raw.decode().splitlines(keepends=True)
literals = [json.dumps(line) for line in lines]
assert ''.join(json.loads(line) for line in literals).encode() == raw
dest = Path(os.environ['P02_DEST']) / 'build'
text = '-- SHA256 of the full pinned shake.c: ' + expected + '\n'
text += 'namespace B20.Pinned\n'
chunks = [literals[i:i + 32] for i in range(0, len(literals), 32)]
for i, chunk in enumerate(chunks):
    text += f'def shakeChunk{i} : List String := [\n  ' + ',\n  '.join(chunk) + '\n]\n'
text += 'def shakeLines : List String := ' + ' ++ '.join(f'shakeChunk{i}' for i in range(len(chunks))) + '\nend B20.Pinned\n'
(dest / 'PinnedShake.lean').write_text(text)
text = 'namespace B20.Pinned\n'
token_re = re.compile(r'[A-Za-z_][A-Za-z_0-9]*|[0-9]+|>>|<<|[(){}\[\];,*|=]')
for name, start, count in [('dec64le', 56, 15), ('enc64le', 75, 15)]:
    fragment = ''.join(lines[start:start + count])
    matches = list(token_re.finditer(fragment))
    cursor = 0
    for m in matches:
        assert not fragment[cursor:m.start()].strip()
        cursor = m.end()
    assert not fragment[cursor:].strip()
    tokens = [m.group() for m in matches]
    text += f'def {name}Lines : List String := [' + ', '.join(json.dumps(s) for s in lines[start:start + count]) + ']\n'
    text += f'def {name}Chars : List Char := {name}Lines.flatMap String.toList\n'
    text += f'def {name}Tokens : List (List Char) := [' + ', '.join(json.dumps(t) for t in tokens) + '].map String.toList\n'
text += 'end B20.Pinned\n'
(dest / 'PinnedLittleEndian.lean').write_text(text)
print('LE source transport', len(raw), 'bytes;', len(lines), 'lines')
