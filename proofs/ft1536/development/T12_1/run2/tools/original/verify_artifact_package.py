#!/usr/bin/env python3
"""Check the compact artifact package without running mathematical jobs."""
import gzip
import hashlib
import json
from pathlib import Path
import sys
import tarfile


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def relative_path(name):
    p = Path(name)
    if p.is_absolute() or '..' in p.parts or not p.parts:
        raise ValueError('unsafe member: ' + name)
    return p


def verify(root):
    root = Path(root).resolve()
    expected = {}
    for line in (root / 'FILES.sha256').read_text().splitlines():
        h, name = line.split(maxsplit=1)
        relative_path(name)
        if name in expected:
            raise ValueError('duplicate manifest entry: ' + name)
        expected[name] = h
    actual = set()
    for p in root.rglob('*'):
        if p.is_symlink():
            raise ValueError('symlink in package: ' + str(p))
        if not p.is_file() or p.name == 'FILES.sha256' and p.parent == root:
            continue
        name = p.relative_to(root).as_posix()
        actual.add(name)
        if digest(p) != expected.get(name):
            raise ValueError('file hash mismatch: ' + name)
        if p.suffix in {'.olean', '.ilean', '.so', '.o', '.pyc'}:
            raise ValueError('compiled cache in package: ' + name)
    if actual != set(expected):
        raise ValueError('manifest member set differs from files')
    snapshots = json.loads(gzip.decompress((root / 'history/SOURCE_SNAPSHOTS.json.gz').read_bytes()))
    references = 0
    for entries in snapshots.values():
        for entry in entries:
            name = entry['stored_as']
            relative_path(name)
            if expected.get(name) != entry['sha256']:
                raise ValueError('unbound historical source: ' + name)
            references += 1
    closure = json.loads((root / 'dependencies/LIBRARY_SOURCES.json').read_text())
    members = {x['member']: x['sha256'] for x in closure['files']}
    seen = set()
    with tarfile.open(root / 'dependencies/library-sources.tar.xz', 'r:xz') as archive:
        for member in archive:
            relative_path(member.name)
            if not member.isfile() or member.name in seen:
                raise ValueError('invalid library archive member: ' + member.name)
            seen.add(member.name)
            stream = archive.extractfile(member)
            if stream is None or hashlib.sha256(stream.read()).hexdigest() != members.get(member.name):
                raise ValueError('library source hash mismatch: ' + member.name)
    if seen != set(members):
        raise ValueError('library closure member set mismatch')
    # Original frozen input manifests retain their original bytes and bases.
    for name in ['inputs/bootstrap/MANIFEST.sha256', 'inputs/legal_key_context/MANIFEST.sha256',
                 'inputs/t5-a2/output_hashes.sha256']:
        manifest = root / name
        if not manifest.exists():
            continue
        for line in manifest.read_text().splitlines():
            h, member = line.split(maxsplit=1)
            relative_path(member)
            if digest(manifest.parent / member) != h:
                raise ValueError('original input manifest mismatch: ' + name + ':' + member)
    return {'status': 'ARTIFACT_INTEGRITY_PASS', 'files': len(expected),
            'historical_source_references': references, 'library_source_files': len(members),
            'mathematical_replay_performed': False}


if __name__ == '__main__':
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent
    print(json.dumps(verify(root), indent=2))
