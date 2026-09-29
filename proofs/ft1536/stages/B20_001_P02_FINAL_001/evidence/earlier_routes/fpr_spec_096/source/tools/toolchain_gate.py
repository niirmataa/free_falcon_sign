#!/usr/bin/env python3
"""Verify source revisions and record hashes of the immutable reused libraries."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import subprocess
import time

IN = Path(os.environ['P02_INPUTS'])
DEST = Path(os.environ['P02_DEST']) / 'build/toolchain'
DEST.mkdir()
REPO = IN.parents[5]
P01 = REPO / 'proofs/ft1536/work/B20_001/P01'
LEAN_ROOT = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0')
pins = json.loads((IN / 'task/TOOLCHAIN_PINS.json').read_text())
records = []


def digest(path):
    with path.open('rb') as handle:
        return hashlib.file_digest(handle, 'sha256').hexdigest()


def git(root, *args):
    argv = ['/usr/bin/git', '-C', str(root), *args]
    p = subprocess.run(argv, capture_output=True, check=True)
    records.append({'argv': argv, 'exit': p.returncode,
                    'stdout_sha256': hashlib.sha256(p.stdout).hexdigest(),
                    'stderr_sha256': hashlib.sha256(p.stderr).hexdigest()})
    return p.stdout


roots = [('mathlib', P01 / 'bootstrap/mathlib4', pins['mathlib']['commit'])]
roots += [(p['name'], P01 / 'run/.lake/packages' / p['name'], p['rev']) for p in pins['mathlib']['packages']]
summary = []
start = datetime.datetime.now(datetime.timezone.utc).isoformat()
t = time.monotonic()
for name, root, rev in roots:
    assert git(root, 'rev-parse', 'HEAD').decode().strip() == rev, name
    tree = git(root, 'ls-tree', '-r', '-z', 'HEAD')
    (DEST / (name + '.git-tree')).write_bytes(tree)
    source_rows = []
    for row in tree.split(b'\0'):
        if not row:
            continue
        metadata, filename = row.split(b'\t', 1)
        mode, kind, expected = metadata.split()
        assert kind == b'blob', (name, row)
        rel = filename.decode()
        path = root / rel
        if mode == b'120000':
            assert path.is_symlink()
            raw = os.readlink(path).encode()
        else:
            assert path.is_file() and not path.is_symlink(), path
            raw = path.read_bytes()
        actual = hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest()
        assert actual == expected.decode(), path
        source_rows.append(hashlib.sha256(raw).hexdigest() + '  ' + rel + '\n')
    sm = DEST / (name + '.source.sha256')
    sm.write_text(''.join(source_rows))
    binary_rows = []
    binary_bytes = 0
    for path in sorted((root / '.lake/build/lib/lean').rglob('*')):
        if not path.is_file() or not path.name.endswith(('.olean', '.olean.private', '.olean.server', '.ir', '.ir.sig')):
            continue
        assert not path.is_symlink(), path
        binary_rows.append(digest(path) + '  ' + str(path.relative_to(root)) + '\n')
        binary_bytes += path.stat().st_size
    bm = DEST / (name + '.build.sha256')
    bm.write_text(''.join(binary_rows))
    summary.append({'name': name, 'root': str(root), 'revision': rev,
                    'source_files': len(source_rows), 'source_manifest_sha256': digest(sm),
                    'build_files': len(binary_rows), 'build_bytes': binary_bytes,
                    'build_manifest_sha256': digest(bm)})
    print(name, len(source_rows), 'sources verified;', len(binary_rows), 'cached artifacts pinned', flush=True)

lean = LEAN_ROOT / 'bin/lean'
version = subprocess.run([str(lean), '--version'], check=True, capture_output=True)
assert b'4.34.0' in version.stdout
(DEST / 'lean_version.stdout').write_bytes(version.stdout)
(DEST / 'lean_version.stderr').write_bytes(version.stderr)
result = {'schema': 'P02_TOOLCHAIN_GATE_V1', 'start': start,
          'stop': datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'elapsed_s': time.monotonic() - t, 'pass': True, 'roots': summary,
          'lean_path': str(lean), 'lean_binary_sha256': digest(lean),
          'lean_version_argv': [str(lean), '--version'], 'lean_version_exit': version.returncode,
          'git_commands': records,
          'p01_build_receipt_sha256': digest(IN / 'stages/P01/outputs/replay/REPLAY_RESULT.json'),
          'reuse_scope': 'Pinned library build reused from reviewed P01; task proofs are freshly rebuilt. These hashes record library provenance, not new mathematical claims.'}
(DEST / 'TOOLCHAIN_GATE.json').write_text(json.dumps(result, indent=2) + '\n')
print('TOOLCHAIN_GATE_PASS')
