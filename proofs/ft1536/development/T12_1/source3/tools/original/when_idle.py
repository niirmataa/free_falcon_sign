#!/usr/bin/env python3
"""Finite resource-slot wait in this executor, followed by one pinned job.

This is not a worker/model/session launcher. It only delays our existing
single-job runner until the other local compute job has released the slot.
"""
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import sys
import time

W = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('continuation_job', W / 'run/job.py')
job = importlib.util.module_from_spec(spec)
spec.loader.exec_module(job)


def now():
    return datetime.now(timezone.utc).isoformat()


def main():
    label, *modules = sys.argv[1:]
    if not modules or not re.fullmatch(r'[A-Za-z0-9_]+', label):
        raise ValueError('label and Lean modules required')
    paths = [W / 'run/job.py']
    for name in modules:
        if not re.fullmatch(r'[A-Za-z_][\w]*(?:\.[A-Za-z_][\w]*)*', name):
            raise ValueError('invalid module')
        paths.append(W / 'run/formal' / (name.replace('.', '/') + '.lean'))
    pins = {str(p.relative_to(W)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    dest = W / 'run' / (label + '_slot')
    dest.mkdir()
    request = {'utc': now(), 'label': label, 'modules': modules, 'source_pins': pins,
                'model': 'openai/gpt-6-astra', 'wait_limit_seconds': 1800,
               'sequential_job_only': True}
    (dest / 'REQUEST.json').write_text(json.dumps(request, indent=2) + '\n')
    start = time.monotonic()
    last = None
    with (dest / 'WAIT.jsonl').open('x') as log:
        while True:
            active = job.active()
            if active != last:
                log.write(json.dumps({'utc': now(), 'active': active}) + '\n')
                log.flush()
                last = active
            if not active:
                break
            if time.monotonic() - start >= 1800:
                (dest / 'RESULT.json').write_text(json.dumps({'utc': now(),
                    'status': 'BLOCKED_RESOURCE_SLOT', 'job_started': False}, indent=2) + '\n')
                return 2
            time.sleep(10)
    for rel, expected in pins.items():
        if hashlib.sha256((W / rel).read_bytes()).hexdigest() != expected:
            raise ValueError('queued source changed; refusing stale request: ' + rel)
    completed = subprocess.run([sys.executable, '-B', str(W / 'run/job.py'), 'lean', label] + modules,
                               cwd=W, check=False)
    result = {'utc': now(), 'exit_code': completed.returncode,
              'status': 'PASS' if completed.returncode == 0 else 'JOB_NOT_ACCEPTED',
              'source_pins': pins}
    (dest / 'RESULT.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
    return completed.returncode


if __name__ == '__main__':
    sys.exit(main())
