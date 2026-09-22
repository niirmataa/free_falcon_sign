#!/usr/bin/env python3
"""Run a snapshot of a reviewer script, with retained streams and version binding."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

W = Path(__file__).resolve().parents[1]
label, script = sys.argv[1:3]
assert label.replace('-', '').isalnum()
source = W/script
assert source.is_file() and not source.is_symlink()
job = W/'check_runs'/label
assert not job.exists()
for name in ('input', 'outputs', 'raw', 'home', 'tmp', 'cache'):
    (job/name).mkdir(parents=True)
snapshot = job/'input'/source.name
snapshot.write_bytes(source.read_bytes())
snapshot.chmod(0o444)
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
before = sha(snapshot)
env = os.environ.copy()
env.update(HOME=str(job/'home'), TMPDIR=str(job/'tmp'), TMP=str(job/'tmp'),
           TEMP=str(job/'tmp'), DOT_SAGE=str(job/'cache/sage'),
           XDG_CACHE_HOME=str(job/'cache/xdg'), PYTHONPYCACHEPREFIX=str(job/'cache/python'),
           PYTHONDONTWRITEBYTECODE='1', PYTHONOPTIMIZE='0', PYTHONHASHSEED='0',
           FT_REVIEW_W=str(W), FT_REVIEW_OUTPUT=str(job/'outputs'),
           MAMBA_ROOT_PREFIX='/home/footfalcon/miniforge3',
           OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1', MKL_NUM_THREADS='1')
entry = '/home/footfalcon/.local/bin/sage' if source.suffix == '.sage' else '/usr/bin/python3'
argv = [entry, str(snapshot)] if source.suffix == '.sage' else [entry, '-B', str(snapshot)]
sandbox = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid',
           '--ro-bind', '/', '/', '--bind', str(W), str(W),
           '--ro-bind', str(W/'inputs'), str(W/'inputs'),
           '--ro-bind', str(job/'input'), str(job/'input'),
           '--proc', '/proc', '--dev', '/dev', '--chdir', str(W), '--', *argv]
def bounded():
    resource.setrlimit(resource.RLIMIT_AS, (8*1024**3,8*1024**3))
started = datetime.datetime.now(datetime.timezone.utc).isoformat()
t0 = time.monotonic()
with (job/'raw/stdout').open('xb') as out, (job/'raw/stderr').open('xb') as err:
    proc = subprocess.Popen(sandbox, cwd=W, env=env, stdin=subprocess.DEVNULL,
                            stdout=out, stderr=err, preexec_fn=bounded)
    timed_out = False
    try:
        rc = proc.wait(timeout=900)
    except subprocess.TimeoutExpired:
        proc.kill(); rc = proc.wait(); timed_out = True
receipt = {'schema':'S06_REVIEWER_SCRIPT_EXECUTION_V1','label':label,
           'argv':argv,'sandbox_argv':sandbox,'cwd':str(W),
           'source_path':str(source.relative_to(W)),
           'snapshot_path':str(snapshot.relative_to(W)),
           'source_sha256_before':before,'source_sha256_after':sha(snapshot),
           'live_source_matches_snapshot':sha(source)==before,
           'started_utc':started,'elapsed_seconds':time.monotonic()-t0,
           'exit_code':rc,'timed_out':timed_out,
           'stdout_sha256':sha(job/'raw/stdout'),'stderr_sha256':sha(job/'raw/stderr'),
           'outputs':{str(p.relative_to(job/'outputs')):sha(p) for p in (job/'outputs').rglob('*') if p.is_file()}}
(job/'EXECUTION.json').write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
print(json.dumps({k:receipt[k] for k in ('label','argv','source_sha256_before','source_sha256_after','exit_code','elapsed_seconds','outputs')},indent=2))
raise SystemExit(rc)
