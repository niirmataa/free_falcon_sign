#!/usr/bin/env python3
"""Manifest-bound proof checkpoints. Only Python's standard library is needed."""

import argparse
import contextlib
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import signal
import stat
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).absolute().parents[1]
DOC = Path('/home/footfalcon/Dokumenty')
H = Path('/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon')
DIGEST = re.compile(r'[0-9a-f]{64}')
NAME = re.compile(r'[A-Za-z0-9][A-Za-z0-9_.-]*')
PRIVATE_PARTS = {'.private', 'private_extraction', '.gnupg', '.ssh', '.git', '.config'}
PRIVATE_MARKERS = (
    b'-----BEGIN PRIVATE KEY-----', b'-----BEGIN ENCRYPTED PRIVATE KEY-----',
    b'-----BEGIN RSA PRIVATE KEY-----', b'-----BEGIN EC PRIVATE KEY-----',
    b'-----BEGIN OPENSSH PRIVATE KEY-----', b'-----BEGIN PGP PRIVATE KEY BLOCK-----',
)


class ArchiveError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise ArchiveError(message)


def checked_name(value):
    require(NAME.fullmatch(value) is not None and value not in ('.', '..'),
            f'Invalid checkpoint/run name: {value!r}')
    return value


def checked_path(value, absolute=False):
    require(isinstance(value, str) and value, 'Empty path')
    require(not any(c in value for c in ('\\', '\n', '\r', '\0')), 'Invalid path characters')
    path = PurePosixPath(value)
    require(absolute or not path.is_absolute(), f'Absolute manifest path: {value}')
    parts = value.split('/')[1:] if path.is_absolute() else value.split('/')
    require(all(p not in ('', '.', '..') for p in parts), f'Unsafe path: {value}')
    require(not (set(p.lower() for p in parts) & PRIVATE_PARTS), f'Private path: {value}')
    require(path.suffix.lower() not in ('.sk', '.priv', '.key', '.pem'), f'Key file: {value}')
    require(path.name != '.env' and not path.name.startswith('.env.'), f'Environment file: {value}')
    require(not re.search(r'(^|[-_.])(secret|seed)([-_.]|$)', path.name, re.I),
            f'Sensitive input name: {value}')
    return path


def no_symlinks(path):
    path = Path(path).absolute()
    for part in [*reversed(path.parents), path]:
        if part.exists() or part.is_symlink():
            require(not stat.S_ISLNK(part.lstat().st_mode), f'Symlink: {part}')
    return path


def read(path):
    path = no_symlinks(path)
    require(stat.S_ISREG(path.lstat().st_mode), f'Not a regular file: {path}')
    return path.read_bytes()


def digest(data):
    return hashlib.sha256(data).hexdigest()


def checked_bytes(path, expected=None):
    checked_path(str(Path(path).absolute()), absolute=True)
    data = read(path)
    require(not any(marker in data for marker in PRIVATE_MARKERS), f'Private-key marker: {path}')
    if expected is not None:
        require(digest(data) == expected, f'SHA-256 mismatch: {path}')
    return data


def manifest(raw, absolute=False):
    entries = {}
    for line in raw.decode('utf-8').splitlines():
        match = re.fullmatch(r'([0-9a-f]{64})  (.+)', line)
        require(match is not None, f'Invalid manifest line: {line!r}')
        sha, name = match.groups()
        checked_path(name, absolute=absolute)
        require(name not in entries, f'Duplicate manifest entry: {name}')
        entries[name] = sha
    require(entries, 'Empty manifest')
    return entries


def mkdir(path):
    no_symlinks(path)
    path.mkdir(parents=True, exist_ok=True)
    no_symlinks(path)


def put_once(path, data):
    mkdir(path.parent)
    no_symlinks(path)
    if path.exists():
        require(read(path) == data, f'Refusing to replace: {path}')
        return
    with path.open('xb') as stream:
        stream.write(data)


def json_bytes(value):
    return (json.dumps(value, ensure_ascii=False, indent=2) + '\n').encode()


@contextlib.contextmanager
def writer_lock(root):
    mkdir(root / 'work')
    lock = no_symlinks(root / 'work/archive.lock')
    with lock.open('a') as stream:
        try:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise ArchiveError('Another archive writer is active') from error
        yield


def regular_files(root):
    result = set()
    no_symlinks(root)
    for base, dirs, files in os.walk(root, followlinks=False):
        for name in dirs:
            no_symlinks(Path(base) / name)
        for name in files:
            path = no_symlinks(Path(base) / name)
            require(stat.S_ISREG(path.lstat().st_mode), f'Non-regular archive member: {path}')
            result.add(path.relative_to(root).as_posix())
    return result


def load_record(root, stage):
    checked_name(stage)
    record = json.loads(read(root / 'catalog' / (stage + '.json')))
    require(record['stage'] == stage, 'Catalog identity mismatch')
    return record


def semantic_rows(receipt):
    rows = next((receipt[k] for k in ('matches', 'compared', 'files') if k in receipt), None)
    require(isinstance(rows, list) and rows, 'Missing semantic replay manifest')
    result = {}
    for row in rows:
        name = row['path']
        if any(k in row for k in ('expected', 'actual', 'match')):
            sha = row.get('expected')
            require(row.get('actual') == sha and row.get('match') is True,
                    'Failed semantic comparison record')
            require('sha256' not in row or row['sha256'] == sha,
                    'Conflicting semantic digests')
        else:
            sha = row.get('sha256')
        checked_path(name)
        require(name not in result and isinstance(sha, str) and DIGEST.fullmatch(sha),
                'Invalid/duplicate semantic record')
        result[name] = sha
    return result


def check_replay_result(base, child, historical, reproduced):
    expected = semantic_rows(historical)
    require(semantic_rows(reproduced) == expected, 'Replay semantic manifest changed')
    for name, sha in expected.items():
        checked_bytes(base / name, sha)
        checked_bytes(child / name, sha)
    return len(expected)


def verify_stage(root, stage):
    record = load_record(root, stage)
    base = root / 'stages' / stage
    raw = checked_bytes(base / 'OUTPUTS.sha256', record['manifest_sha256'])
    entries = manifest(raw)
    for name, sha in entries.items():
        checked_bytes(base / name, sha)
    require(regular_files(base) == set(entries) | {'OUTPUTS.sha256'},
            f'Unexpected or missing snapshot files: {stage}')
    require(record['output_entries'] == len(entries), 'Output count mismatch')
    require(record['report'] in entries and record['result_file'] in entries,
            'Report/result must be members of OUTPUTS')
    require(entries[record['report']] == record['report_sha256'], 'Report pin mismatch')
    result = json.loads(read(base / record['result_file']))
    require(result.get('result', result.get('status')) == record['claimed_status'], 'Status mismatch')
    inputs = manifest(read(base / 'INPUTS.sha256'), absolute=True)
    mappings = record['inputs']
    require(len(mappings) == len(inputs), 'Input count mismatch')
    require({m['original']: m['sha256'] for m in mappings} == inputs, 'Input mapping mismatch')
    for item in mappings:
        expected = item['sha256']
        require(item['object'] == 'objects/' + expected, 'Invalid content-addressed path')
        checked_bytes(root / item['object'], expected)
    frozen = record.get('frozen_commands')
    if frozen:
        require(frozen['path'] in entries, 'Frozen log not in OUTPUTS')
        log = checked_bytes(base / frozen['path'], frozen['sha256'])
        require(len(log) == frozen['bytes'], 'Frozen log length mismatch')
    if record['replay'] != 'none':
        replay_receipt = record['replay_receipt']
        require(replay_receipt in entries, 'Replay receipt must be in OUTPUTS')
        semantic = semantic_rows(json.loads(read(base / replay_receipt)))
        require(all(entries.get(name) == sha for name, sha in semantic.items()),
                'Semantic replay files are not all sealed by OUTPUTS')
    return dict(stage=stage, claimed_status=record['claimed_status'],
                output_entries=len(entries), input_entries=len(inputs),
                manifest_sha256=record['manifest_sha256'], integrity='PASS')


def import_stage(root, source, manifest_sha, report_sha, report='REPORT.md',
                 result_file='RESULT.json', replay='none', stage=None, replay_receipt=None):
    source = no_symlinks(Path(source).absolute())
    stage = checked_name(stage or source.name)
    checked_path(report); checked_path(result_file)
    require(DIGEST.fullmatch(manifest_sha) and DIGEST.fullmatch(report_sha), 'Expected external SHA-256 pins')
    require(replay in ('none', 'standard', 'lv-static', 'global-crt'), 'Unknown replay protocol')
    if replay_receipt is not None:
        checked_path(replay_receipt)
        require(replay != 'none', 'A replay receipt requires a replay protocol')
    elif replay != 'none':
        replay_receipt = 'artifacts/replay_result.json' if replay == 'global-crt' else 'artifacts/fresh_replay.json'
    with writer_lock(root):
        catalog = root / 'catalog' / (stage + '.json')
        target = root / 'stages' / stage
        if catalog.exists():
            old = load_record(root, stage)
            require(old['manifest_sha256'] == manifest_sha and old['report_sha256'] == report_sha
                    and old['report'] == report and old['result_file'] == result_file
                    and old['replay'] == replay and old['replay_receipt'] == replay_receipt,
                    'Checkpoint already exists with different pins/protocol/receipt')
            return dict(**verify_stage(root, stage), already_imported=True)
        require(not target.exists(), f'Unregistered destination already exists: {target}')
        raw = checked_bytes(source / 'OUTPUTS.sha256', manifest_sha)
        entries = manifest(raw)
        require(entries.get(report) == report_sha, 'Report does not match external pin')
        require('INPUTS.sha256' in entries and result_file in entries, 'Missing declared inputs/result')
        require('OUTPUTS.sha256' not in entries, 'Self-including manifest')
        by_hash = {}
        total_bytes = 0
        for name, sha in entries.items():
            data = checked_bytes(source / name, sha)
            by_hash.setdefault(sha, source / name)
            total_bytes += len(data)
        input_rows = manifest(read(source / 'INPUTS.sha256'), absolute=True)
        input_sources = []
        for original, sha in input_rows.items():
            origin = Path(original) if Path(original).is_absolute() else source / original
            # Prefer the public copy already sealed by OUTPUTS; an old disk need not be mounted.
            path = by_hash.get(sha, origin)
            checked_bytes(path, sha)
            input_sources.append((original, sha, path))
        result = json.loads(read(source / result_file))
        status = result.get('result', result.get('status'))
        require(isinstance(status, str) and status, 'Missing explicit mathematical status')
        frozen_paths = [p for p in ('artifacts/COMMANDS.frozen.log', 'COMMANDS.frozen.log') if p in entries]
        require(len(frozen_paths) <= 1, 'Ambiguous frozen journal')
        frozen = None
        if frozen_paths:
            name = frozen_paths[0]; log = read(source / name)
            live = source / 'COMMANDS.log'
            if live.exists():
                require(read(live).startswith(log), 'Live journal lost the pinned prefix')
            frozen = dict(path=name, sha256=entries[name], bytes=len(log), live_prefix_checked=live.exists())
        entry = {'standard': 'scripts/replay.py', 'global-crt': 'scripts/replay.py',
                 'lv-static': 'resume_001/replay_fresh.py'}.get(replay)
        if entry:
            require(entry in entries, 'Replay entry is not sealed by OUTPUTS')
            require(replay_receipt in entries, 'Replay receipt is not sealed by OUTPUTS')
            semantic = semantic_rows(json.loads(read(source / replay_receipt)))
            require(all(entries.get(name) == sha for name, sha in semantic.items()),
                    'Semantic replay files are not all sealed by OUTPUTS')
        record = dict(schema='FT1536_GIT_CHECKPOINT_V1', stage=stage, origin=str(source),
                      imported_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                      manifest_sha256=manifest_sha, report=report, report_sha256=report_sha,
                      result_file=result_file, claimed_status=status, output_entries=len(entries),
                      output_bytes=total_bytes, frozen_commands=frozen, replay=replay,
                      replay_receipt=replay_receipt,
                      inputs=[dict(original=n, sha256=h, object='objects/' + h) for n, h, _ in input_sources])
        mkdir(root / 'stages'); mkdir(root / 'catalog')
        with tempfile.TemporaryDirectory(prefix='import-', dir=root / 'work') as temp:
            staged = Path(temp) / stage
            mkdir(staged)
            for name, sha in entries.items():
                put_once(staged / name, checked_bytes(source / name, sha))
            put_once(staged / 'OUTPUTS.sha256', raw)
            for _, sha, path in input_sources:
                put_once(root / 'objects' / sha, checked_bytes(path, sha))
            # All destination bytes are checked before making the checkpoint visible.
            for name, sha in entries.items():
                checked_bytes(staged / name, sha)
            require(not target.exists(), 'Destination appeared during import')
            staged.rename(target)
            put_once(catalog, json_bytes(record))
        return dict(**verify_stage(root, stage), output_bytes=total_bytes, already_imported=False)


def add_document(root, source, expected):
    source = Path(source).absolute()
    require(DIGEST.fullmatch(expected) is not None, 'Expected document SHA-256')
    require(source.suffix == '.md' and source.name != 'AGENTS.md', 'Use a named Markdown task/note')
    data = checked_bytes(source, expected)
    with writer_lock(root):
        target = root / 'documents' / source.name
        put_once(target, data)
        meta = root / 'documents' / (source.name + '.sha256')
        put_once(meta, (expected + '  ' + source.name + '\n').encode())
    return dict(document=str(target.relative_to(root)), sha256=expected)


def verify_documents(root):
    count = 0
    folder = root / 'documents'
    if not folder.exists():
        return count
    for name in sorted(folder.iterdir()):
        if name.suffix == '.sha256':
            entries = manifest(read(name))
            require(len(entries) == 1, 'Document sidecar must contain one entry')
            rel, sha = next(iter(entries.items()))
            require(name.name == rel + '.sha256', 'Document sidecar mismatch')
            checked_bytes(folder / rel, sha); count += 1
    require(regular_files(folder) == {p.name for p in folder.iterdir() if p.suffix == '.sha256'} |
            {p.name[:-7] for p in folder.iterdir() if p.suffix == '.sha256'}, 'Unregistered document')
    return count


def replay_stage(root, stage, run, timeout, hide_originals=False):
    checked_name(run)
    verify_stage(root, stage)
    record = load_record(root, stage)
    protocol = record['replay']
    require(protocol != 'none', 'This checkpoint archives a review; no single full replay is declared')
    require(timeout > 0, 'Positive wall timeout required')
    base = root / 'stages' / stage
    parent = root / 'replay-work' / stage
    mkdir(parent)
    destination = no_symlinks(parent / run)
    require(not destination.exists(), 'Replay destination must be new')
    destination.mkdir()
    seed = destination / 'seed'
    mkdir(seed)
    omitted = []
    for name in sorted(regular_files(base)):
        # GLOBAL's pre-freeze replay regenerates these receipts and creates replay/.
        # Only the disposable seed is adapted; the sealed snapshot is never changed.
        if protocol == 'global-crt' and (name.startswith('replay/') or name in {
                'OUTPUTS.sha256', 'artifacts/replay_baseline.sha256',
                'artifacts/replay_prefix.json', 'artifacts/replay_result.json'}):
            omitted.append(name)
            continue
        put_once(seed / name, read(base / name))
    mkdir(seed / 'tmp')
    journal = record.get('frozen_commands')
    put_once(seed / 'COMMANDS.log', read(seed / journal['path']) if journal else b'')
    child = seed / ('replay' if protocol == 'global-crt' else 'tmp/replay')
    entry = 'resume_001/replay_fresh.py' if protocol == 'lv-static' else 'scripts/replay.py'
    argv = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid',
            '--ro-bind', '/', '/', '--bind', str(seed), str(seed), '--proc', '/proc', '--dev', '/dev']
    hidden = []
    if hide_originals:
        for original in (DOC, H):
            if original.exists():
                require(not destination.is_relative_to(original) and not root.is_relative_to(original),
                        f'Archive/replay lies inside root requested to hide: {original}')
                no_symlinks(original)
                argv += ['--tmpfs', str(original)]
                hidden.append(str(original))
    argv += ['--chdir', str(seed), '--', sys.executable, '-B', entry]
    if protocol != 'global-crt':
        argv += [str(child), record['manifest_sha256']]
    started = datetime.datetime.now(datetime.timezone.utc).isoformat()
    tick = time.monotonic()
    timed_out = False
    env = dict(os.environ)
    env['PYTHONOPTIMIZE'] = '0'  # The historical checkers deliberately use assertions.
    env['PYTHONDONTWRITEBYTECODE'] = '1'
    env.pop('LEAN_PATH', None)   # GLOBAL sets its own local import path in its runner.
    with (destination / 'stdout.txt').open('xb') as out, (destination / 'stderr.txt').open('xb') as err:
        process = subprocess.Popen(argv, cwd=seed, env=env, stdout=out, stderr=err, start_new_session=True)
        try:
            process.wait(timeout=timeout)
        except (subprocess.TimeoutExpired, KeyboardInterrupt) as error:
            os.killpg(process.pid, signal.SIGKILL); process.wait()
            timed_out = isinstance(error, subprocess.TimeoutExpired)
    receipt = dict(schema='FT1536_REPOSITORY_REPLAY_V1', stage=stage,
                   claimed_status=record['claimed_status'], manifest_sha256=record['manifest_sha256'],
                   started_utc=started, elapsed_seconds=round(time.monotonic() - tick, 3),
                   argv=argv, exit_code=process.returncode, timed_out=timed_out,
                   hidden_original_roots=hidden, disposable_seed_omissions=omitted,
                   stdout_sha256=digest(read(destination / 'stdout.txt')),
                   stderr_sha256=digest(read(destination / 'stderr.txt')))
    child_receipt = seed / 'artifacts/replay_result.json' if protocol == 'global-crt' else child / 'REPLAY_RESULT.json'
    validation_error = None
    if child_receipt.exists():
        try:
            reproduced = json.loads(read(child_receipt))
            receipt['replay_status'] = reproduced.get('status')
            receipt['replay_result_sha256'] = digest(read(child_receipt))
            historical = json.loads(read(base / record['replay_receipt']))
            receipt['semantic_files'] = check_replay_result(base, child, historical, reproduced)
        except (ArchiveError, OSError, ValueError, KeyError) as error:
            validation_error = str(error)
    allowed = ('PASS',) if protocol == 'global-crt' else ('FRESH_REPLAY_PASS', 'FRESH_REPLAY_MATCH', 'PASS_FRESH_REPLAY')
    passed = (process.returncode == 0 and receipt.get('replay_status') in allowed
              and receipt.get('semantic_files', 0) > 0 and validation_error is None)
    receipt['validation_error'] = validation_error
    receipt['execution_result'] = 'PASS' if passed else 'FAIL'
    put_once(destination / 'execution.json', json_bytes(receipt))
    verify_stage(root, stage)
    print(json.dumps(dict(receipt=str(destination / 'execution.json'), **receipt), ensure_ascii=False, indent=2))
    require(passed, f'Replay did not pass; inspect {destination}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    imp = sub.add_parser('import')
    imp.add_argument('source', type=Path)
    imp.add_argument('--manifest-sha', required=True)
    imp.add_argument('--report-sha', required=True)
    imp.add_argument('--report', default='REPORT.md')
    imp.add_argument('--result', default='RESULT.json')
    imp.add_argument('--replay', choices=['none', 'standard', 'lv-static', 'global-crt'], default='none')
    imp.add_argument('--replay-receipt', help='Relative receipt path sealed by OUTPUTS; protocol default if omitted')
    imp.add_argument('--id')
    doc = sub.add_parser('document'); doc.add_argument('source', type=Path); doc.add_argument('--sha', required=True)
    verify = sub.add_parser('verify'); verify.add_argument('stage', nargs='?')
    sub.add_parser('list')
    run = sub.add_parser('replay'); run.add_argument('stage'); run.add_argument('--run', required=True)
    run.add_argument('--timeout', type=int, default=600); run.add_argument('--hide-originals', action='store_true')
    args = parser.parse_args()
    if args.command == 'import':
        result = import_stage(ROOT, args.source, args.manifest_sha, args.report_sha,
                              args.report, args.result, args.replay, args.id, args.replay_receipt)
    elif args.command == 'document':
        result = add_document(ROOT, args.source, args.sha)
    elif args.command == 'replay':
        replay_stage(ROOT, args.stage, args.run, args.timeout, args.hide_originals)
        return
    else:
        stages = [args.stage] if getattr(args, 'stage', None) else sorted(
            p.stem for p in (ROOT / 'catalog').glob('*.json'))
        if args.command == 'list':
            result = [dict(stage=s, status=load_record(ROOT, s)['claimed_status'],
                           replay=load_record(ROOT, s)['replay']) for s in stages]
        else:
            result = dict(checkpoints=[verify_stage(ROOT, s) for s in stages],
                          documents=verify_documents(ROOT), originals_required=False)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ArchiveError, OSError, ValueError, KeyError) as error:
        print(f'archive: {error}', file=sys.stderr)
        raise SystemExit(1)
