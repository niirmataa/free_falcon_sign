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
# Replay may hide historical source directories outside the repository. Paths come
# from the environment so the archive itself stays machine-portable; defaults keep
# the historical behavior on the original maintainer machine.
DOC = Path(os.environ.get('FT1536_HIDE_DOC', '/home/footfalcon/Dokumenty'))
H = Path(os.environ.get('FT1536_HIDE_H',
                        '/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon'))
# Default wall timeout for a fresh replay; the catalog value of the stage wins.
DEFAULT_REPLAY_TIMEOUT = int(os.environ.get('FT1536_REPLAY_TIMEOUT', '600'))
DIGEST = re.compile(r'[0-9a-f]{64}')
COMMIT_ID = re.compile(r'(?:[0-9a-f]{40}|[0-9a-f]{64})')
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
    # Owner decision 2026-09-25: the exact literal REPLAY_SEED.sha256 is the
    # public replay-input hash manifest of frozen T12.1 packages (MTISIS_RUN_001,
    # GAME_BINDING_RUN_001), not secret material. Only this literal file name is
    # exempt; every other seed-like name stays rejected. The content scan for
    # private-key markers in checked_bytes is unaffected.
    if path.name != 'REPLAY_SEED.sha256':
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


def stage_record_view(root, stage):
    record = load_record(root, stage)
    return dict(stage=stage, status=record['claimed_status'], replay=record['replay'],
                manifest_sha256=record['manifest_sha256'], report_sha256=record['report_sha256'])


def list_stages(root, stage=None):
    if stage is not None:
        checked_name(stage)
        return [stage_record_view(root, stage)]
    return [stage_record_view(root, s)
            for s in sorted(p.stem for p in (root / 'catalog').glob('*.json'))]


def markdown_table(root, stage=None):
    """Render the checkpoint catalog as the status table used by README/STATE."""
    lines = ['| Etap | Status | Replay | OUTPUTS.sha256 |',
             '|---|---|---|---|']
    for row in list_stages(root, stage):
        pin = row['manifest_sha256'][:12]
        lines.append("| {} | {} | {} | `{}` |".format(
            row['stage'], row['status'], row['replay'], pin + '…'))
    return '\n'.join(lines) + '\n'


def verify_stage(root, stage):
    record = load_record(root, stage)
    base = root / 'stages' / stage
    manifest_name = record.get('manifest', 'OUTPUTS.sha256')
    checked_path(manifest_name)
    raw = checked_bytes(base / manifest_name, record['manifest_sha256'])
    entries = manifest(raw)
    for name, sha in entries.items():
        checked_bytes(base / name, sha)
    require(regular_files(base) == set(entries) | {manifest_name},
            f'Unexpected or missing snapshot files: {stage}')
    require(record['output_entries'] == len(entries), 'Output count mismatch')
    require(record['report'] in entries and record['result_file'] in entries,
            'Report/result must be members of OUTPUTS')
    require(entries[record['report']] == record['report_sha256'], 'Report pin mismatch')
    result = json.loads(read(base / record['result_file']))
    require(result.get('result', result.get('status', result.get('verdict'))) == record['claimed_status'], 'Status mismatch')
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
                 result_file='RESULT.json', replay='none', stage=None, replay_receipt=None,
                 replay_timeout=None, manifest_name='OUTPUTS.sha256'):
    source = no_symlinks(Path(source).absolute())
    stage = checked_name(stage or source.name)
    checked_path(report); checked_path(result_file); checked_path(manifest_name)
    require(manifest_name in ('OUTPUTS.sha256', 'REVIEW_OUTPUTS.sha256'), 'Unknown output manifest')
    require(manifest_name == 'OUTPUTS.sha256' or replay == 'none', 'Review archive has no author replay protocol')
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
                    and old['replay'] == replay and old['replay_receipt'] == replay_receipt
                    and old.get('manifest', 'OUTPUTS.sha256') == manifest_name,
                    'Checkpoint already exists with different pins/protocol/receipt')
            return dict(**verify_stage(root, stage), already_imported=True)
        require(not target.exists(), f'Unregistered destination already exists: {target}')
        raw = checked_bytes(source / manifest_name, manifest_sha)
        entries = manifest(raw)
        require(entries.get(report) == report_sha, 'Report does not match external pin')
        require('INPUTS.sha256' in entries and result_file in entries, 'Missing declared inputs/result')
        require(manifest_name not in entries, 'Self-including manifest')
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
        status = result.get('result', result.get('status', result.get('verdict')))
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
        if replay_timeout is not None:
            require(isinstance(replay_timeout, int) and replay_timeout > 0,
                    'Replay timeout must be a positive number of seconds')
            record['replay_timeout_seconds'] = replay_timeout
        if manifest_name != 'OUTPUTS.sha256':
            record['manifest'] = manifest_name
        mkdir(root / 'stages'); mkdir(root / 'catalog')
        with tempfile.TemporaryDirectory(prefix='import-', dir=root / 'work') as temp:
            staged = Path(temp) / stage
            mkdir(staged)
            for name, sha in entries.items():
                put_once(staged / name, checked_bytes(source / name, sha))
            put_once(staged / manifest_name, raw)
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
    if timeout is None:
        timeout = record.get('replay_timeout_seconds') or DEFAULT_REPLAY_TIMEOUT
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
    env['TMPDIR'] = str(seed / 'tmp')
    env['TMP'] = str(seed / 'tmp')
    env['TEMP'] = str(seed / 'tmp')
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


def verify_bundle(source, manifest_name, manifest_sha, report, report_sha, result_file):
    """Check a frozen W without importing it or changing its declared status."""
    source = no_symlinks(Path(source).absolute())
    for name in (manifest_name, report, result_file):
        checked_path(name)
    require(DIGEST.fullmatch(manifest_sha) and DIGEST.fullmatch(report_sha), 'Expected external pins')
    rows = manifest(checked_bytes(source / manifest_name, manifest_sha))
    require(manifest_name not in rows, 'Self-including manifest')
    require(rows.get(report) == report_sha and result_file in rows, 'Unsealed report/result')
    for name, sha in rows.items():
        checked_bytes(source / name, sha)
    result = json.loads(read(source / result_file))
    require(isinstance(result, dict), 'Expected JSON result object')
    return result


def checkpoint(root, stage, message=None, repo=None, with_stages=(), include=()):
    """Commit verified stages and their input closure; leave unrelated staging alone."""
    repo = Path(repo).absolute() if repo is not None else root.parents[1]
    root = no_symlinks(Path(root).absolute())
    require(root.is_relative_to(repo), 'Archive must be inside the checkout')
    rel = root.relative_to(repo).as_posix()

    def git(*args):
        return subprocess.check_output(['git', *args], cwd=repo, text=True)
    require(git('rev-parse', '--show-toplevel').strip() == str(repo), 'Wrong Git checkout')
    require(git('branch', '--show-current').strip() == 'main', 'Checkpoint requires main')
    # An initial --only commit includes all staged files: require an existing HEAD.
    git('rev-parse', '--verify', 'HEAD')
    stages = list(dict.fromkeys((stage, *with_stages)))
    allowed_meta = {f'{rel}/README.md', f'{rel}/batches/B20_001/STATUS.json',
                    'docs/onboarding/STATE.md', 'docs/onboarding/ROADMAP.md',
                    'docs/onboarding/COORDINATOR_LOG.md'}
    require(set(include) <= allowed_meta, 'Unexpected checkpoint metadata path')
    with writer_lock(root):
        records = {s: load_record(root, s) for s in stages}
        paths = set(include)
        is_b20 = any(s.startswith('B20_001_') for s in stages)
        if is_b20:
            # Shared verifier rechecks the paired review, exact stage pins and task IDs.
            import importlib.util
            spec = importlib.util.spec_from_file_location('b20_status_set', repo / 'tools/b20_status_set.py')
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            batch = root / 'batches/B20_001'
            status = json.loads(read(batch / 'STATUS.json'))
            index = json.loads(read(batch / 'INDEX.json'))
            for s in stages:
                if not s.startswith('B20_001_'):
                    continue
                match = re.fullmatch(r'B20_001_([PV]\d{2})_FINAL_\d+', s)
                require(match is not None, 'Expected a B20 final stage ID')
                ident = match[1]
                pid = 'P' + ident[1:]
                try:
                    pair = module.verify_accepted_row(root, index, status, pid)
                except module.archive.ArchiveError as error:
                    raise ArchiveError(str(error)) from error
                require(s in pair and set(pair) <= set(stages), 'Checkpoint must contain the accepted P/V pair')
            paths.update((f'{rel}/batches/B20_001/STATUS.json', 'docs/onboarding/COORDINATOR_LOG.md'))
        for s, record in records.items():
            verify_stage(root, s)
            paths.add(f'{rel}/catalog/{s}.json')
            paths.update(f'{rel}/stages/{s}/{name}' for name in regular_files(root / 'stages' / s))
            paths.update(f'{rel}/{item["object"]}' for item in record['inputs'])
        paths = sorted(paths)
        if not git('status', '--porcelain', '--', *paths).strip():
            return dict(stage=stage, action='nothing-to-commit')
        journal = 'docs/onboarding/COORDINATOR_LOG.md'
        if journal in paths:
            previous = git('show', 'HEAD:' + journal).encode()
            current = read(repo / journal)
            require(current.startswith(previous) and len(current) > len(previous),
                    'Append a coordinator log entry before checkpointing')
        # Refuse changes to bytes already archived by HEAD, including shared objects.
        tracked = set(git('ls-tree', '-r', '--name-only', 'HEAD', '--',
                          f'{rel}/stages', f'{rel}/catalog', f'{rel}/objects').splitlines())
        snapshot = {p: read(repo / p) for p in paths}
        for p in set(paths) & tracked:
            old = subprocess.check_output(['git', 'show', 'HEAD:' + p], cwd=repo)
            require(old == snapshot[p], f'Immutable archive changed: {p}')
        # Exact path list includes ignored sealed logs and only referenced objects.
        git('add', '-f', '--', *paths)
        for p, data in snapshot.items():
            indexed = subprocess.check_output(['git', 'show', ':' + p], cwd=repo)
            require(indexed == data == read(repo / p), f'Staged bytes changed: {p}')
        env = dict(os.environ, GIT_AUTHOR_NAME='niirmataa',
                   GIT_AUTHOR_EMAIL='245027293+niirmataa@users.noreply.github.com',
                   GIT_COMMITTER_NAME='niirmataa',
                   GIT_COMMITTER_EMAIL='245027293+niirmataa@users.noreply.github.com')
        subprocess.run(['git', 'commit', '--only', '-m', message or f'proof: record {stage} checkpoint',
                        '--', *paths], cwd=repo, env=env, check=True)
        head = git('rev-parse', 'HEAD').strip()
        return dict(stage=stage, action='committed', commit=head, paths=paths,
                    manifest_sha256=records[stage]['manifest_sha256'])


def handoff(root, stage):
    """Emit the reviewer pin blob for a verified checkpoint."""
    record = load_record(root, stage)
    verify_stage(root, stage)
    lines = [f'STAGE={stage}',
             f"MANIFEST={record.get('manifest', 'OUTPUTS.sha256')}",
             f"REPORT={record['report']}",
             f"REPORT_SHA256={record['report_sha256']}",
             f"OUTPUTS_SHA256={record['manifest_sha256']}",
             f"STATUS={record['claimed_status']}",
             f"REPLAY={record['replay']}"]
    if record.get('frozen_commands'):
        lines.append(f"FROZEN_COMMANDS_SHA256={record['frozen_commands']['sha256']}")
    return '\n'.join(lines) + '\n'


def task_init(root, task_id, base=None, task_doc=None):
    """Create a fresh workspace with an AGENTS.md bound to the pinned task document."""
    checked_name(task_id)
    workspace = root / 'work' / task_id
    require(not workspace.exists(), f'Workspace already exists: {workspace}')
    lines = [f'# {task_id}', '',
             'Jeden wykonawca wybrany i uruchomiony przez właściciela. Osobny W,',
             'bez subagentów/relay i bez systemowego tmp/tmpfs. Wszystkie zapisy',
             'wyłącznie pod W w repo.',
             f'REPO={root.parents[1]}',
             f'W={workspace}']
    if task_doc is not None:
        name = Path(task_doc).name
        sidecar = root / 'documents' / (name + '.sha256')
        require(sidecar.exists(), f'Missing document sidecar: {sidecar.name}')
        pins = manifest(read(sidecar))
        require(set(pins) == {name}, 'Task sidecar must pin exactly that document')
        sha = pins[name]
        checked_bytes(root / 'documents' / name, sha)
        lines += [f'TASK={root / "documents" / name}', f'TASK SHA={sha}']
    if base is not None:
        require(COMMIT_ID.fullmatch(base) is not None, 'Expected full BASE commit ID (40 or 64 hex digits)')
        lines.append(f'BASE={base}')
    mkdir(workspace)
    put_once(workspace / 'AGENTS.md', ('\n'.join(lines) + '\n').encode())
    return dict(workspace=str(workspace), task_id=task_id, task_sha=sha if task_doc else None)


def bootstrap(root, dest, plan):
    """Materialize inputs/bootstrap from a JSON plan and seal MANIFEST/ORIGINS.

    The plan is a JSON list of {copy, path, original?}: bytes are read from
    path, written to dest/copy, and recorded with their SHA-256 and origin.
    """
    dest = no_symlinks(Path(dest).absolute())
    rows = []
    for item in json.loads(read(plan)):
        copy = checked_path(item['copy'])
        source = Path(item['path'])
        source = source if source.is_absolute() else Path.cwd() / source
        data = checked_bytes(source)
        rows.append(dict(copy=copy.as_posix(), original=item.get('original', str(source)),
                         sha256=digest(data), bytes=len(data)))
        put_once(dest / copy, data)
    rows.sort(key=lambda row: row['copy'])
    raw = ''.join(f"{row['sha256']}  {row['copy']}\n" for row in rows).encode()
    put_once(dest / 'MANIFEST.sha256', raw)
    put_once(dest / 'ORIGINS.json', json_bytes(dict(files=rows)))
    for name, sha in manifest(raw).items():
        checked_bytes(dest / name, sha)
    return dict(dest=str(dest), files=len(rows), manifest_sha256=digest(raw))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    imp = sub.add_parser('import')
    imp.add_argument('source', type=Path)
    imp.add_argument('--manifest-sha', required=True)
    imp.add_argument('--report-sha', required=True)
    imp.add_argument('--report', default='REPORT.md')
    imp.add_argument('--result', default='RESULT.json')
    imp.add_argument('--manifest', default='OUTPUTS.sha256',
                     choices=['OUTPUTS.sha256', 'REVIEW_OUTPUTS.sha256'])
    imp.add_argument('--replay', choices=['none', 'standard', 'lv-static', 'global-crt'], default='none')
    imp.add_argument('--replay-receipt', help='Relative receipt path sealed by OUTPUTS; protocol default if omitted')
    imp.add_argument('--replay-timeout', type=int,
                     help='Positive wall timeout seconds recorded for future replays of this stage')
    imp.add_argument('--id')
    doc = sub.add_parser('document'); doc.add_argument('source', type=Path); doc.add_argument('--sha', required=True)
    verify = sub.add_parser('verify'); verify.add_argument('stage', nargs='?')
    run = sub.add_parser('replay'); run.add_argument('stage'); run.add_argument('--run', required=True)
    run.add_argument('--timeout', type=int, default=None,
                     help='Wall timeout seconds; default: catalog replay_timeout_seconds, else 600')
    run.add_argument('--hide-originals', action='store_true')
    lst = sub.add_parser('list'); lst.add_argument('stage', nargs='?')
    lst.add_argument('--markdown', action='store_true',
                     help='Render the status table used by README/STATE from catalog/*.json')
    ck = sub.add_parser('checkpoint'); ck.add_argument('stage'); ck.add_argument('-m', '--message')
    ck.add_argument('--with-stage', action='append', default=[], help='Commit a paired review stage too')
    ck.add_argument('--include', action='append', default=[], help='Exact coordinator metadata path')
    ho = sub.add_parser('handoff'); ho.add_argument('stage')
    ti = sub.add_parser('task-init'); ti.add_argument('task_id')
    ti.add_argument('--base'); ti.add_argument('--task-doc')
    bs = sub.add_parser('bootstrap'); bs.add_argument('dest', type=Path)
    bs.add_argument('--plan', required=True, type=Path)
    args = parser.parse_args()
    if args.command == 'import':
        result = import_stage(ROOT, args.source, args.manifest_sha, args.report_sha,
                              args.report, args.result, args.replay, args.id, args.replay_receipt,
                              args.replay_timeout, args.manifest)
    elif args.command == 'document':
        result = add_document(ROOT, args.source, args.sha)
    elif args.command == 'replay':
        replay_stage(ROOT, args.stage, args.run, args.timeout, args.hide_originals)
        return
    elif args.command == 'list' and args.markdown:
        print(markdown_table(ROOT, args.stage), end='')
        return
    elif args.command == 'checkpoint':
        result = checkpoint(ROOT, args.stage, args.message, with_stages=args.with_stage, include=args.include)
    elif args.command == 'handoff':
        print(handoff(ROOT, args.stage), end='')
        return
    elif args.command == 'task-init':
        result = task_init(ROOT, args.task_id, args.base, args.task_doc)
    elif args.command == 'bootstrap':
        result = bootstrap(ROOT, args.dest, args.plan)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return
    else:
        if args.command == 'list':
            result = list_stages(ROOT, args.stage)
        else:
            stages = [args.stage] if getattr(args, 'stage', None) else sorted(
                p.stem for p in (ROOT / 'catalog').glob('*.json'))
            result = dict(checkpoints=[verify_stage(ROOT, s) for s in stages],
                          documents=verify_documents(ROOT), originals_required=False)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ArchiveError, OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(f'archive: {error}', file=sys.stderr)
        raise SystemExit(1)
