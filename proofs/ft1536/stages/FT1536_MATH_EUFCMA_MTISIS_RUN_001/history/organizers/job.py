#!/usr/bin/env python3
"""Execution, snapshots and hashes only. Mathematical computations live in Lean/Sage."""
import hashlib
import json
import os
from pathlib import Path
import resource
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone

W = Path(__file__).resolve().parent.parent
LIB = W.parents[0] / 'B20_001/P01/bootstrap/mathlib4'
LEAN = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean')
SAGE = '/home/footfalcon/.local/bin/sage'

def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()

def now():
    return datetime.now(timezone.utc).isoformat()

def paths(lib):
    return [str(lib / '.lake/build/lib/lean')] + [str(p) for p in sorted(
        (lib.parents[1] / 'run/.lake/packages').glob('*/.lake/build/lib/lean'))]

def env_for(dest, lib=LIB):
    env = os.environ.copy()
    for key, sub in [('HOME', 'home'), ('TMPDIR', 'tmp'), ('TMP', 'tmp'),
                     ('TEMP', 'tmp'), ('DOT_SAGE', 'home/.sage'),
                     ('XDG_CACHE_HOME', 'cache'), ('MPLCONFIGDIR', 'cache/mpl')]:
        p = dest / sub
        p.mkdir(parents=True, exist_ok=True)
        env[key] = str(p)
    env.update(PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1',
               OMP_NUM_THREADS='1', LEAN_PATH=':'.join([str(dest / 'lib')] + paths(lib)))
    return env

def step(dest, name, argv, cwd, env):
    logs = dest / 'logs'
    logs.mkdir(exist_ok=True)
    out, err = logs / (name + '.stdout'), logs / (name + '.stderr')
    sandbox = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net',
               '--ro-bind', '/', '/', '--dev-bind', '/dev', '/dev',
               '--bind', str(dest), str(dest), '--bind', str(dest / 'tmp'), '/tmp',
               '--chdir', str(cwd), '/usr/bin/prlimit', '--as=12884901888', '--']
    start, t0 = now(), time.monotonic()
    timed_out = False
    with out.open('wb') as fo, err.open('wb') as fe:
        try:
            p = subprocess.run(sandbox + argv, env=env, stdout=fo, stderr=fe, timeout=1800)
            code = p.returncode
        except subprocess.TimeoutExpired:
            code, timed_out = 124, True
    rec = dict(name=name, argv=argv, sandbox_argv=sandbox, cwd=str(cwd), start=start,
               stop=now(), elapsed_s=round(time.monotonic()-t0, 3), exit_code=code,
               timeout=timed_out, wall_limit_s=1800, address_space_bytes=12884901888,
               normal_rss_budget_bytes=8589934592,
               network='bwrap --unshare-net', stdout=str(out.relative_to(dest)),
               stderr=str(err.relative_to(dest)), stdout_sha256=sha(out), stderr_sha256=sha(err),
               cumulative_child_maxrss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
    (logs / (name + '.receipt.json')).write_text(json.dumps(rec, indent=2)+'\n')
    print(f'{name}: exit={code}, {rec["elapsed_s"]}s', flush=True)
    if code or err.stat().st_size or 'warning:' in out.read_text(errors='replace'):
        print(out.read_text(errors='replace'))
        print(err.read_text(errors='replace'))
    return rec

def main():
    label, mode, *args = sys.argv[1:]
    dest = W / 'run' / label
    dest.mkdir(exist_ok=False)
    shutil.copytree(W / 'output/formal', dest / 'formal')
    if (W / 'output/sage').exists():
        shutil.copytree(W / 'output/sage', dest / 'sage')
    (dest / 'lib/FT1536').mkdir(parents=True)
    env = env_for(dest)
    recs = []
    if mode == 'lean':
        for module in args:
            src = dest / 'formal' / (module.replace('.', '/') + '.lean')
            artifact = dest / 'lib' / (module.replace('.', '/') + '.olean')
            artifact.parent.mkdir(parents=True, exist_ok=True)
            rec = step(dest, module.replace('.', '_'), [str(LEAN), '-j1', '-M6144',
                       '-o', str(artifact), str(src)], dest / 'formal', env)
            rec['source_sha256'] = sha(src)
            recs.append(rec)
            if rec['exit_code']:
                break
    elif mode == 'sage':
        recs.append(step(dest, 'sage', [SAGE, str(dest / 'sage' / args[0])], dest, env))
    else:
        recs.append(step(dest, 'command', args, dest, env))
    (dest / 'RECEIPTS.json').write_text(json.dumps(recs, indent=2)+'\n')
    return int(any(r['exit_code'] for r in recs))

if __name__ == '__main__':
    sys.exit(main())
