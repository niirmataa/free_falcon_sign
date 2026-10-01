#!/usr/bin/env python3
"""Wait for the shared proof slot, then use the unchanged source3 runner.

The owner explicitly requested waiting rather than ending a continuation at
an occupied slot. Linux pidfds provide exit notifications without polling.
No process is stopped and no proof limit or preflight check is bypassed.
"""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import select
import subprocess
import sys

import job


def parent_job(pid):
    """Include a proof's Python driver so a multi-step replay keeps its slot."""
    result = {pid}
    for _ in range(12):
        process = Path('/proc') / str(pid)
        try:
            status = process.joinpath('status').read_text()
            parent = int(re.search(r'^PPid:\s+(\d+)', status, re.M).group(1))
            if parent <= 1 or parent == os.getpid():
                break
            process = Path('/proc') / str(parent)
            args = [part.decode(errors='replace') for part in process.joinpath('cmdline').read_bytes().split(b'\0') if part]
            cwd = process.joinpath('cwd').resolve()
            if not cwd.is_relative_to(job.REPO / 'proofs/ft1536'):
                break
            if args and Path(args[0]).name.startswith('python'):
                result.add(parent)
            elif args and Path(args[0]).name not in {'bash', 'sh', 'bwrap', 'timeout', 'time'}:
                break
            pid = parent
        except (OSError, ValueError, AttributeError):
            break
    return result


def wait_for_exit(pids):
    handles = []
    try:
        for pid in sorted(pids):
            try:
                handles.append(os.pidfd_open(pid))
            except ProcessLookupError:
                pass
        while handles:
            ready, _, _ = select.select(handles, [], [])
            for handle in ready:
                handles.remove(handle)
                os.close(handle)
    finally:
        for handle in handles:
            os.close(handle)


def main():
    mode, label, *arguments = sys.argv[1:]
    if mode not in {'lean', 'sage'} or not re.fullmatch(r'[A-Za-z0-9_]+', label) or not arguments:
        raise ValueError('usage: job_when_available.py lean|sage UNIQUE_LABEL module...|file.sage')
    if not hasattr(os, 'pidfd_open'):
        raise RuntimeError('Linux pidfd support is required for event-based waiting')
    directory = job.BUILD / 'waits' / label
    directory.mkdir(parents=True, exist_ok=False)
    log = directory / 'WAIT.jsonl'
    attempt = 0
    while True:
        processes = job.active()
        if processes:
            pids = set().union(*(parent_job(item['pid']) for item in processes))
            with log.open('a') as stream:
                stream.write(json.dumps({'utc': datetime.now(timezone.utc).isoformat(),
                    'processes': processes, 'wait_pids': sorted(pids)}) + '\n')
            print('Waiting for proof-process exits:', sorted(pids), flush=True)
            wait_for_exit(pids)
            continue
        selected = label if attempt == 0 else label + '_slot_retry_' + str(attempt).zfill(3)
        print('Starting checked job:', selected, flush=True)
        completed = subprocess.run([sys.executable, '-B', str(job.ROOT / 'tools/job.py'),
                                    mode, selected, *arguments], cwd=job.ROOT)
        preflight = job.BUILD / 'jobs' / selected / 'PREFLIGHT.json'
        if completed.returncode == 2 and preflight.exists() and json.loads(preflight.read_text())['processes']:
            attempt += 1
            continue
        with log.open('a') as stream:
            stream.write(json.dumps({'utc': datetime.now(timezone.utc).isoformat(),
                'job': selected, 'exit_code': completed.returncode}) + '\n')
        return completed.returncode


if __name__ == '__main__':
    sys.exit(main())
