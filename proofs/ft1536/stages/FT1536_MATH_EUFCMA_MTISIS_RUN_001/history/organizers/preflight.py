#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path
from datetime import datetime, timezone

W = Path(__file__).resolve().parent.parent
P01 = W.parent / 'B20_001/P01'
B = W / 'inputs/bootstrap'
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
def revision(p):
    g = p / '.git'
    s = (g / 'HEAD').read_text().strip()
    if s.startswith('ref: '):
        ref = s[5:]
        if (g / ref).exists():
            return (g / ref).read_text().strip()
        for line in (g / 'packed-refs').read_text().splitlines():
            if line.endswith(' '+ref):
                return line.split()[0]
        raise ValueError(ref)
    return s

assert sha(B/'MANIFEST.sha256') == 'a1fe3416478599c3f19200cdfeedc80e98a1291678dd1c871b3f6e6511d28b15'
checks = []
for line in (B/'MANIFEST.sha256').read_text().splitlines():
    h, name = line.split(maxsplit=1)
    name = name.lstrip('*')
    assert sha(B/name) == h, name
    checks.append(name)
pins = json.loads((B/'TOOLCHAIN_PINS.json').read_text())
roots = {'mathlib': P01/'bootstrap/mathlib4'}
expected = {'mathlib': pins['mathlib']['commit']}
for pkg in pins['mathlib']['packages']:
    roots[pkg['name']] = P01/'run/.lake/packages'/pkg['name']
    expected[pkg['name']] = pkg['rev']
result = {}
for name, root in roots.items():
    rev = revision(root)
    assert rev == expected[name], (name, rev)
    result[name] = {'path': str(root), 'revision': rev}
out = W/'output'
items = []
for name, root in roots.items():
    for p in sorted(root.rglob('*')):
        if p.is_file() and '.git' not in p.parts and p.suffix in {'.lean', '.toml', '.json'}:
            if '.lake' not in p.relative_to(root).parts:
                items.append(f'{sha(p)}  {name}/{p.relative_to(root)}')
(out/'LIBRARY_SOURCES.sha256').write_text('\n'.join(items)+'\n')
(out/'PREFLIGHT.json').write_text(json.dumps(dict(time=datetime.now(timezone.utc).isoformat(),
    bootstrap_verified=checks, libraries=result, library_sources=len(items),
    source_manifest_sha256=sha(out/'LIBRARY_SOURCES.sha256'),
    lean_executable_sha256=sha(Path(pins['lean']['observed_path'])),
    sage_launcher_sha256=sha(Path(pins['sage']['launcher'])),
    reuse_provenance='P01 output_v2 TOOLCHAIN.txt and final reviewed build; exact revisions checked read-only'), indent=2)+'\n')
print(f'PASS: {len(checks)} bootstrap files; {len(roots)} revisions; {len(items)} library source/config pins')
