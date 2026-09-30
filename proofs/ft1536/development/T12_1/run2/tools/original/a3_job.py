#!/usr/bin/env python3
"""Single-job wrapper: process preflight and existing RUN_002 acceptance gate.

No mathematical computation; all proof work is delegated to the local job.py
process, never to a model or another session.
"""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

W = Path(__file__).resolve().parent.parent


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1048576), b''):
            h.update(chunk)
    return h.hexdigest()


def main():
    mode, label, *args = sys.argv[1:]
    records = []
    active = []
    for proc in Path('/proc').iterdir():
        if not proc.name.isdigit() or int(proc.name) == os.getpid():
            continue
        try:
            argv = (proc / 'cmdline').read_bytes().split(b'\0')
            argv = [a.decode(errors='replace') for a in argv if a]
            cwd = str((proc / 'cwd').resolve())
            if not argv:
                continue
            executable = Path(argv[0]).name
            compute = executable in {'lean', 'lake', 'sage', 'sage-python'}
            runner = any(Path(a).name in {'job.py', 'replay.py', 'a3_job.py'} for a in argv[1:])
            if compute or runner:
                record = {'pid': int(proc.name), 'cwd': cwd, 'argv': argv}
                records.append(record)
                active.append(record)
        except (OSError, PermissionError):
            continue
    preflight = W / 'run/RESUME_A3_20260929' / (label + '_PREFLIGHT.json')
    if preflight.exists():
        raise SystemExit('refusing to overwrite preflight: ' + str(preflight))
    preflight.write_text(json.dumps({
        'utc': datetime.now(timezone.utc).isoformat(),
        'model': 'openai/gpt-6-astra-fast',
        'session': 'ses_f13464e70ffeuAM6Xf31ztFHAS',
        'command': [mode, label, *args],
        'processes': records,
        'active_compute_or_runner': active,
        'runner_sha256': sha(W / 'run/job.py'),
        'preflight_wrapper_sha256': sha(Path(__file__)),
    }, indent=2) + '\n')
    if active:
        print(json.dumps(active, indent=2))
        raise SystemExit('background compute/runner present; no job started')
    env = os.environ.copy()
    for key, sub in [('HOME', 'home'), ('TMPDIR', 'tmp'), ('TMP', 'tmp'),
                     ('TEMP', 'tmp'), ('XDG_CACHE_HOME', 'cache')]:
        directory = W / 'run/RESUME_A3_20260929' / sub
        directory.mkdir(exist_ok=True)
        env[key] = str(directory)
    env['PYTHONDONTWRITEBYTECODE'] = '1'
    result = subprocess.run([sys.executable, '-B', str(W / 'run/job.py'), mode, label, *args],
                            cwd=W, env=env)
    return result.returncode


if __name__ == '__main__':
    sys.exit(main())
