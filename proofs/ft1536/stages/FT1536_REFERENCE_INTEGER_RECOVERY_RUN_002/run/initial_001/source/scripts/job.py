#!/usr/bin/env python3
"""One sequential bounded job; absent DEST, immutable source snapshot, W-only writes."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import shutil
import signal
import subprocess
import sys
import time

W = Path(__file__).resolve().parents[1]
REPO = W.parents[3]
LEAN_ROOT = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0')
P01 = REPO / 'proofs/ft1536/work/B20_001/P01'
SAGE = Path('/home/footfalcon/miniforge3/envs/sage/bin/sage')


def sha(p):
    with p.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def files(root):
    return {p.relative_to(root).as_posix(): sha(p) for p in sorted(root.rglob('*')) if p.is_file()}


def stamp():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def run(dest, mode):
    dest = Path(dest).resolve()
    assert dest.is_relative_to(W) and not dest.exists(), dest
    dest.mkdir(parents=True)
    for part in ['source', 'build', 'home', 'tmp', 'cache', 'sage', 'config', 'data', 'logs']:
        (dest / part).mkdir()
    for part in ['formal', 'scripts', 'checks']:
        shutil.copytree(W / part, dest / 'source' / part)
    before = files(dest / 'source')
    for p in (dest / 'source').rglob('*'):
        if p.is_file():
            p.chmod(0o444)
    env = {'PATH': str(SAGE.parent) + ':' + str(LEAN_ROOT / 'bin') + ':/usr/bin:/bin',
           'LANG': 'C.UTF-8', 'HOME': str(dest / 'home'), 'TMPDIR': str(dest / 'tmp'),
           'TMP': str(dest / 'tmp'), 'TEMP': str(dest / 'tmp'), 'DOT_SAGE': str(dest / 'sage'),
           'XDG_CACHE_HOME': str(dest / 'cache'), 'XDG_CONFIG_HOME': str(dest / 'config'),
           'XDG_DATA_HOME': str(dest / 'data'), 'PYTHONDONTWRITEBYTECODE': '1',
           'OMP_NUM_THREADS': '1', 'OPENBLAS_NUM_THREADS': '1', 'MKL_NUM_THREADS': '1',
           'RUN002_W': str(W), 'RUN002_DEST': str(dest)}
    libs = [P01 / 'bootstrap/mathlib4/.lake/build/lib/lean'] + [
        p / '.lake/build/lib/lean' for p in sorted((P01 / 'run/.lake/packages').iterdir())]
    env['LEAN_PATH'] = ':'.join(map(str, [dest / 'build'] + libs))
    sandbox = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net', '--ro-bind', '/', '/',
               '--dev-bind', '/dev', '/dev', '--bind', str(dest), str(dest),
               '--ro-bind', str(dest / 'source'), str(dest / 'source'),
               '--bind', str(dest / 'tmp'), '/tmp', '--chdir', str(dest / 'source')]
    commands = []
    if mode in ['full', 'gate']:
        commands.append(['/usr/bin/python3', '-B', 'scripts/toolchain_gate.py'])
    if mode in ['full', 'sage']:
        # Sage preparses a private writable copy; the source snapshot stays RO.
        sagecopy = dest / 'build/check_bounds.sage'
        shutil.copyfile(dest / 'source/checks/check_bounds.sage', sagecopy)
        commands.append([str(SAGE), str(sagecopy)])
    if mode in ['full', 'lean']:
        for name in ['Ledger', 'Audit']:
            commands.append([str(LEAN_ROOT / 'bin/lean'), '-j1', '-M2048',
                             '--root=' + str(dest / 'source/formal'),
                             '-o', str(dest / 'build' / (name + '.olean')),
                             str(dest / 'source/formal' / (name + '.lean'))])
    assert commands
    receipt = {'start': stamp(), 'mode': mode, 'source_before': before,
               'wall_seconds_per_step': 1800, 'memory_bytes': 8589934592,
               'single_compute_worker': True, 'environment': env, 'steps': [],
               'network': 'off: bwrap --unshare-net', 'writable_project_root': str(dest)}
    rc = 0
    for n, command in enumerate(commands):
        out, err = dest / f'logs/{n:03d}.stdout', dest / f'logs/{n:03d}.stderr'
        argv = sandbox + ['/usr/bin/prlimit', '--as=8589934592', '--'] + command
        start, t = stamp(), time.monotonic()
        with out.open('wb') as so, err.open('wb') as se:
            p = subprocess.Popen(argv, stdout=so, stderr=se, env=env, start_new_session=True)
            try:
                rc = p.wait(timeout=1800)
            except BaseException:
                os.killpg(p.pid, signal.SIGKILL)
                p.wait()
                rc = 124
        clean = not err.read_bytes() and 'warning:' not in out.read_text(errors='replace')
        step = {'argv': argv, 'start': start, 'stop': stamp(), 'elapsed_seconds': time.monotonic() - t,
                'exit_code': rc, 'stdout': str(out.relative_to(dest)), 'stdout_sha256': sha(out),
                'stderr': str(err.relative_to(dest)), 'stderr_sha256': sha(err), 'clean_log': clean}
        receipt['steps'].append(step)
        print(dest.name, n, 'exit', rc, 'clean', clean, flush=True)
        if rc:
            print(out.read_text(errors='replace')[:9000], err.read_text(errors='replace')[:9000])
        if rc or not clean:
            rc = rc or 1
            break
    receipt.update({'stop': stamp(), 'exit_code': rc, 'source_after': files(dest / 'source'),
                    'products': files(dest / 'build')})
    receipt['sources_unchanged'] = before == receipt['source_after']
    assert receipt['sources_unchanged']
    (dest / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
    return rc


if __name__ == '__main__':
    sys.exit(run(W / 'run' / sys.argv[1], sys.argv[2]))
