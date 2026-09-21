#!/usr/bin/env python3
"""Verify exact staged proof bytes for one checkpoint and its maintainer review."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

REPO = Path(__file__).resolve().parents[1]
ROOT = REPO / 'proofs/ft1536'
sys.path.insert(0, str(ROOT / 'tools'))
import archive


def verify(stage, validation_name):
    archive.checked_name(stage)
    archive.checked_name(validation_name)
    def git(*args):
        return subprocess.check_output(['git', *args], cwd=REPO)
    prefixes = ('proofs/ft1536/objects/', 'proofs/ft1536/stages/' + stage + '/',
                'proofs/ft1536/validation/' + validation_name + '/')
    names = {'proofs/ft1536/README.md', 'proofs/ft1536/catalog/' + stage + '.json'}
    changed = [p.decode() for p in git('diff', '--cached', '--name-only', '-z', '--', 'proofs/ft1536').split(b'\0') if p]
    archive.require(all(p in names or p.startswith(prefixes) for p in changed), 'Unexpected proof changes')
    algorithm = git('rev-parse', '--show-object-format').decode().strip()
    indexed = set()
    for row in git('ls-files', '--stage', '-z', '--', 'proofs/ft1536').split(b'\0'):
        if not row:
            continue
        meta, name = row.split(b'\t', 1)
        mode, oid, index_stage = meta.decode().split()
        archive.require(mode in ('100644', '100755') and index_stage == '0', 'Unexpected index mode')
        data = archive.read(REPO / name.decode())
        archive.require(hashlib.new(algorithm, f'blob {len(data)}\0'.encode() + data).hexdigest() == oid,
                        'Index bytes: ' + name.decode())
        indexed.add(name.decode())
    expected = set()
    for folder, dirs, files in os.walk(ROOT):
        dirs[:] = [d for d in dirs if d != '__pycache__' and not (Path(folder) == ROOT and d in ('work', 'replay-work'))]
        for name in files:
            if not name.endswith('.pyc'):
                expected.add((Path(folder) / name).relative_to(REPO).as_posix())
    archive.require(indexed == expected, 'Unindexed/extra proof files: ' + str(sorted(indexed ^ expected)))
    validation = ROOT / 'validation' / validation_name
    entries = archive.manifest(archive.read(validation / 'VALIDATION.sha256'))
    archive.require(archive.regular_files(validation) == set(entries) | {'README.md', 'VALIDATION.sha256'},
                    'Validation scope')
    for p, h in entries.items():
        archive.checked_bytes(validation / p, h)
    print(json.dumps(dict(result='PASS', root=str(REPO), proof_index_files_exact=len(indexed),
                          changed_paths=len(changed), validation_files=len(entries)), indent=2))


if __name__ == '__main__':
    verify(*sys.argv[1:])
