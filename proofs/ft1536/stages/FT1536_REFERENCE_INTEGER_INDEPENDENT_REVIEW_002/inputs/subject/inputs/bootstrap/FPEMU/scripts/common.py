"""Local receipts. All callers execute inside scripts/run.py's bwrap."""
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import time

W = Path(__file__).resolve().parents[1]
B = W/'inputs/bootstrap'
S = B/'source'

def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def dump(rel, value):
    p = W/rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(value, indent=2, sort_keys=True)+'\n')

def job(tag, argv, data=None, timeout=180, check=True):
    d = W/'logs/jobs'
    d.mkdir(parents=True, exist_ok=True)
    n = len(list(d.glob('*.json')))
    stem = d/(str(n).zfill(4)+'-'+tag)
    tick = time.monotonic()
    p = subprocess.run(argv, input=data, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                       cwd=W, timeout=timeout)
    Path(str(stem)+'.stdout').write_bytes(p.stdout)
    Path(str(stem)+'.stderr').write_bytes(p.stderr)
    row = dict(argv=[str(x) for x in argv], cwd=str(W), exit_code=p.returncode,
               elapsed_seconds=time.monotonic()-tick, timeout_seconds=timeout,
               limits={k: resource.getrlimit(getattr(resource, k)) for k in
                       ('RLIMIT_CPU', 'RLIMIT_AS', 'RLIMIT_CORE', 'RLIMIT_NOFILE')},
               stdin_sha256=None if data is None else hashlib.sha256(data).hexdigest(),
               stdout_sha256=hashlib.sha256(p.stdout).hexdigest(),
               stderr_sha256=hashlib.sha256(p.stderr).hexdigest(),
               environment={k: os.environ.get(k) for k in ('HOME','TMPDIR','DOT_SAGE','LEAN_PATH',
                   'ASAN_OPTIONS','UBSAN_OPTIONS','OMP_NUM_THREADS','OPENBLAS_NUM_THREADS')})
    Path(str(stem)+'.json').write_text(json.dumps(row, indent=2, sort_keys=True)+'\n')
    if check and p.returncode:
        raise RuntimeError(f'{tag}: exit {p.returncode}; see {stem.relative_to(W)}')
    return p

def flags():
    import shlex
    line = next(ln for ln in (S/'Makefile').read_text().splitlines() if ln.startswith('CFLAGS = '))
    return shlex.split(line.split(' = ', 1)[1])+['-std=c99','-Iinputs/bootstrap/source']
