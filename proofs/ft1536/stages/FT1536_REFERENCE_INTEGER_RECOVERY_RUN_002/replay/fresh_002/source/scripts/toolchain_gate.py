#!/usr/bin/env python3
"""Verify pinned offline library provenance without invoking Git or a network."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

W = Path(os.environ['RUN002_W'])
DEST = Path(os.environ['RUN002_DEST']) / 'build'
REPO = W.parents[3]
P01 = REPO / 'proofs/ft1536/work/B20_001/P01'
PROV = W / 'inputs/supplemental/library_provenance'


def sha(p):
    with p.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def head(root):
    gitdir = root / '.git'
    raw = (gitdir / 'HEAD').read_text().strip()
    if not raw.startswith('ref: '):
        return raw
    ref = raw[5:]
    p = gitdir / ref
    if p.exists():
        return p.read_text().strip()
    for row in (gitdir / 'packed-refs').read_text().splitlines():
        if row.endswith(' ' + ref):
            return row.split()[0]
    raise ValueError(ref)


old = json.loads((PROV / 'TOOLCHAIN_GATE.json').read_text())
pins = json.loads((W / 'inputs/bootstrap/planning/TOOLCHAIN_PINS.json').read_text())
expected = {'mathlib': pins['mathlib']['commit']}
expected.update({p['name']: p['rev'] for p in pins['mathlib']['packages']})
roots = []
for rec in old['roots']:
    name = rec['name']
    root = P01 / ('bootstrap/mathlib4' if name == 'mathlib' else 'run/.lake/packages/' + name)
    assert head(root) == rec['revision'] == expected[name]
    for suffix, key in [('source.sha256', 'source_manifest_sha256'), ('build.sha256', 'build_manifest_sha256')]:
        m = PROV / (name + '.' + suffix)
        assert sha(m) == rec[key]
        for row in m.read_text().splitlines():
            h, rel = row.split('  ', 1)
            p = root / rel
            assert not Path(rel).is_absolute() and '..' not in Path(rel).parts
            raw = os.readlink(p).encode() if p.is_symlink() else p.read_bytes()
            assert hashlib.sha256(raw).hexdigest() == h, p
    tree = PROV / (name + '.git-tree')
    for row in tree.read_bytes().split(b'\0'):
        if not row:
            continue
        meta, rel = row.split(b'\t', 1)
        mode, kind, h = meta.split()
        assert kind == b'blob'
        p = root / rel.decode()
        raw = os.readlink(p).encode() if mode == b'120000' else p.read_bytes()
        assert hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest() == h.decode()
    roots.append({'name': name, 'revision': rec['revision'],
                  'source_manifest_sha256': rec['source_manifest_sha256'],
                  'build_manifest_sha256': rec['build_manifest_sha256'],
                  'source_files': rec['source_files'], 'build_files': rec['build_files']})
    print(name + ': source and cached library hashes match pinned provenance', flush=True)
leanroot = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0')
cmd = [str(leanroot / 'bin/lean'), '--version']
p = subprocess.run(cmd, capture_output=True, check=True)
assert b'4.34.0' in p.stdout and not p.stderr
# Record the entire Lean runtime/core library, not merely its launcher.
runtime = {}
for part in ['bin', 'lib/lean']:
    for f in sorted((leanroot / part).rglob('*')):
        if f.is_file():
            runtime[str(f.relative_to(leanroot))] = sha(f)
(DEST / 'LEAN_RUNTIME.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in runtime.items()))
result = {'pass': True, 'lean_version': p.stdout.decode().strip(),
          'lean_binary_sha256': sha(leanroot / 'bin/lean'), 'roots': roots,
          'lean_runtime_manifest_sha256': sha(DEST / 'LEAN_RUNTIME.sha256'),
          'provenance_gate_sha256': sha(PROV / 'TOOLCHAIN_GATE.json'),
          'git_invoked': False, 'network': 'off',
          'boundary': 'Cached library reuse, verified against pinned prior manifests and blob tree. Not a fresh Mathlib rebuild or independent validation of that build.'}
(DEST / 'TOOLCHAIN_GATE.json').write_text(json.dumps(result, indent=2, sort_keys=True) + '\n')
print(result['lean_version'])
print('TOOLCHAIN_GATE_PASS')
