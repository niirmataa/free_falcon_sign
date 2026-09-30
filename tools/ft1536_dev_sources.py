#!/usr/bin/env python3
"""Seed a NEW development directory from small sources, without touching a worker.

This copies bytes and records provenance; it does not run or review proofs.
Identical committed stages are referenced, never copied into the source tree.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess


REPO = Path(__file__).resolve().parents[1]
DEVELOPMENT = Path('proofs/ft1536/development/T12_1')
PARENT = Path('proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002')
ORIGINS = {
    'run2': PARENT,
    'source3': PARENT / 'continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003',
    't5': Path('proofs/ft1536/work/FT1536_T5_FLAT_REJECT_RUN_001'),
}
LIMIT = 8 * 1024 * 1024


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def candidates(root):
    result = {}
    for p in sorted((root / 'run/formal').rglob('*.lean')):
        if p.is_symlink():
            raise ValueError('source symlink: ' + str(p))
        result[p] = 'formal/' + p.relative_to(root / 'run/formal').as_posix()
    for p in sorted((root / 'run/sage').glob('*.sage')):
        result[p] = 'sage/' + p.name
    for pattern in ('*.py', '*.pyx'):
        for p in sorted((root / 'run').glob(pattern)):
            result[p] = 'tools/original/' + p.name
    for p in sorted((root / 'run/tools').glob('*.py')):
        result[p] = 'tools/original/aux/' + p.name
    for p in sorted(root.glob('*.md')):
        name = 'ORIGINAL_AGENT_RULES.md' if p.name == 'AGENTS.md' else p.name
        result[p] = 'notes/' + name
    for p in sorted((root / 'run').glob('*.md')):
        result[p] = 'notes/run/' + p.name
    for p in sorted((root / 'run').glob('STABLE_BINARY_*_CLOSURE.json')):
        result[p] = 'notes/run/' + p.name
    for p in result:
        if p.is_symlink() or not p.is_file():
            raise ValueError('not a regular source: ' + str(p))
        if not p.resolve().is_relative_to(root.resolve()):
            raise ValueError('source escapes workspace: ' + str(p))
    return result


def stage_index():
    result = {}
    raw = subprocess.check_output(
        ['git', 'ls-tree', '-r', '-z', 'HEAD', '--', 'proofs/ft1536/stages'], cwd=REPO)
    for entry in raw.split(b'\0'):
        if not entry:
            continue
        metadata, path = entry.split(b'\t', 1)
        _mode, kind, oid = metadata.decode().split()
        if kind == 'blob':
            result.setdefault(oid, []).append(path.decode())
    return result


def capture(component):
    root = REPO / ORIGINS[component]
    dest = REPO / DEVELOPMENT / component
    if dest.exists():
        raise ValueError('destination already exists; no overwrite: ' + str(dest))
    selected = candidates(root)
    archive = stage_index()
    algorithm = subprocess.check_output(
        ['git', 'rev-parse', '--show-object-format'], cwd=REPO).decode().strip()
    rows, contents, archived, large = [], {}, [], []
    for path, target in selected.items():
        size = path.stat().st_size
        row = {'source': path.relative_to(REPO).as_posix(), 'target': target,
               'bytes': size, 'sha256': digest(path)}
        if size > LIMIT:
            large.append(row)
            continue
        data = path.read_bytes()
        if hashlib.sha256(data).hexdigest() != row['sha256']:
            raise ValueError('source changed during capture: ' + str(path))
        oid = hashlib.new(algorithm, b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()
        if oid in archive:
            # Prefer the same basename, then the shortest canonical stage path.
            stage = min(archive[oid], key=lambda p: (Path(p).name != path.name, len(p), p))
            if (REPO / stage).read_bytes() != data:
                raise ValueError('stage working-tree bytes differ from HEAD: ' + stage)
            archived.append(dict(row, stage=stage, git_blob=oid))
        else:
            rows.append(row)
            contents[target] = (data, path.stat().st_mode & 0o777)
    # A second complete pass catches worker edits while reading the snapshot.
    if candidates(root) != selected:
        raise ValueError('source file set changed during capture; wait for a step boundary')
    for row in rows + archived + large:
        if digest(REPO / row['source']) != row['sha256']:
            raise ValueError('source changed during capture: ' + row['source'])
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO).decode().strip()
    baseline = {
        'schema': 'FT1536_DEVELOPMENT_SOURCE_BASELINE_V1',
        'utc': datetime.now(timezone.utc).isoformat(), 'repository_head': head,
        'origin': ORIGINS[component].as_posix(), 'component': component,
        'handoff_status': 'PREPARED_COPY_ACTIVE_WORKER_NOT_MOVED',
        'proof_review': 'NOT_PERFORMED',
        'files': rows, 'large_untracked': large,
        'tracking_note': 'Initial byte provenance only; subsequent ordinary Git edits need no reseal.',
    }
    dest.mkdir(parents=True, exist_ok=False)
    for target, (data, mode) in contents.items():
        path = dest / target
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        path.chmod(mode)
    (dest / 'BASELINE.json').write_text(json.dumps(baseline, indent=2) + '\n')
    (dest / 'ARCHIVED_DEPENDENCIES.json').write_text(json.dumps({
        'schema': 'FT1536_ARCHIVED_SOURCE_REFERENCES_V1', 'files': archived,
        'note': 'Byte-identical dependencies already committed in stages; consume only their declared scope.',
    }, indent=2) + '\n')
    for row in rows:
        if digest(dest / row['target']) != row['sha256']:
            raise ValueError('destination hash mismatch: ' + row['target'])
    return {'component': component, 'copied': len(rows), 'bytes': sum(r['bytes'] for r in rows),
            'referenced_from_stages': len(archived), 'large_untracked': len(large),
            'destination': dest.relative_to(REPO).as_posix()}


def pending(component):
    """Report late writes in the ORIGINAL W; never merge or overwrite either side."""
    dest = REPO / DEVELOPMENT / component
    baseline = json.loads((dest / 'BASELINE.json').read_text())
    archived = json.loads((dest / 'ARCHIVED_DEPENDENCIES.json').read_text())['files']
    rows = baseline['files'] + baseline['large_untracked'] + archived
    known = {r['source']: r for r in rows}
    live = {p.relative_to(REPO).as_posix(): target
            for p, target in candidates(REPO / baseline['origin']).items()}
    changes = []
    for name in sorted(known.keys() | live.keys()):
        if name not in known:
            changes.append({'source': name, 'status': 'NEW_IN_ORIGINAL_W', 'target': live[name]})
        elif name not in live:
            changes.append({'source': name, 'status': 'REMOVED_IN_ORIGINAL_W'})
        else:
            actual = digest(REPO / name)
            if actual != known[name]['sha256']:
                changes.append({'source': name, 'status': 'CHANGED_IN_ORIGINAL_W',
                                'baseline_sha256': known[name]['sha256'], 'current_sha256': actual,
                                'target': known[name]['target']})
    return {'component': component, 'changes_after_snapshot': changes,
            'action': 'Review this delta at owner-mediated handoff; no files have been changed.'}


def materialize(component):
    """Assemble small sources for a build; stages and live sources stay untouched."""
    root = REPO / DEVELOPMENT / component
    dest = root / '.build/formal'
    if dest.exists():
        raise ValueError('build source directory exists; choose a fresh build before repeating')
    records = json.loads((root / 'ARCHIVED_DEPENDENCIES.json').read_text())['files']
    files = {}
    for row in records:
        if not row['target'].startswith('formal/'):
            continue
        source = REPO / row['stage']
        if digest(source) != row['sha256']:
            raise ValueError('archived dependency hash mismatch: ' + row['stage'])
        files[row['target'][len('formal/'):]] = source.read_bytes()
    for path in (root / 'formal').rglob('*.lean'):
        files[path.relative_to(root / 'formal').as_posix()] = path.read_bytes()
    dest.mkdir(parents=True, exist_ok=False)
    for name, data in files.items():
        path = dest / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    return {'component': component, 'assembled': len(files), 'destination': str(dest),
            'scope': 'Small source assembly only; large certificates, library closure and toolchain are separate.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('capture', 'pending', 'materialize'))
    parser.add_argument('component', choices=tuple(ORIGINS))
    args = parser.parse_args()
    result = {'capture': capture, 'pending': pending, 'materialize': materialize}[args.action](args.component)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
