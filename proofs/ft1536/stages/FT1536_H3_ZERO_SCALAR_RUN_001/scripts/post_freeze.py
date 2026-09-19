"""Bounded standard replay: frozen W read-only, only tmp writable, original archives hidden."""
import datetime, fcntl, json, os, resource, signal, subprocess, sys, time
from pathlib import Path
from replaylib import sha, verify_manifest

W = Path(__file__).absolute().parents[1]
if (W/'executor.lock').exists():
    executor_lock = (W/'executor.lock').open('r')
    fcntl.flock(executor_lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
if len(sys.argv) != 3:
    raise ValueError('post_freeze.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA256')
dest, pin = sys.argv[1:]
before = verify_manifest(W, 'OUTPUTS.sha256', pin)
D = Path(dest).absolute()
if ('..' in D.parts or D == W/'tmp' or not D.is_relative_to(W/'tmp')
        or D.exists() or D.is_symlink() or any(p.is_symlink() for p in D.parents)):
    raise ValueError('DEST must be new under tmp/')
env = dict(os.environ)
env.update(PYTHONDONTWRITEBYTECODE='1', PYTHONOPTIMIZE='0', GIT_OPTIONAL_LOCKS='0',
           HOME=str(D/'cache/home'), TMPDIR=str(D/'tmp'), TMP=str(D/'tmp'), TEMP=str(D/'tmp'),
           DOT_SAGE=str(D/'cache/sage'), XDG_CACHE_HOME=str(D/'cache'),
           MPLCONFIGDIR=str(D/'cache/mpl'), IPYTHONDIR=str(D/'cache/ipython'),
           LEAN_PATH=str(D/'formal'), FT1536_ASAN='1', OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1')
box = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid',
       '--ro-bind', '/', '/', '--bind', str(W/'tmp'), str(W/'tmp'),
       '--proc', '/proc', '--dev', '/dev', '--chdir', str(W)]
hidden = []
for original in ['/home/footfalcon/Dokumenty', '/home/footfalcon/free_falcon_sign/proofs/ft1536/stages']:
    if Path(original).is_dir():
        box += ['--tmpfs', original, '--remount-ro', original]
        hidden.append(original)
argv = box+['--', '/usr/bin/python3', '-B', 'scripts/replay.py', str(D), pin]
limit = 240
def bounds():
    resource.setrlimit(resource.RLIMIT_CPU, (limit, limit+1))
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    resource.setrlimit(resource.RLIMIT_NOFILE, (256, 256))

start = datetime.datetime.now(datetime.timezone.utc).isoformat()
tick = time.monotonic()
p = subprocess.Popen(argv, cwd=W, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                     start_new_session=True, preexec_fn=bounds)
timed = False
try:
    stdout, stderr = p.communicate(timeout=limit)
except subprocess.TimeoutExpired:
    timed = True
    os.killpg(p.pid, signal.SIGKILL)
    stdout, stderr = p.communicate()
# The external manifest has already been verified before any destination write.
D.mkdir(parents=True, exist_ok=True)
for name, data in [('POST_FREEZE.stdout', stdout), ('POST_FREEZE.stderr', stderr)]:
    with (D/name).open('xb') as f:
        f.write(data)
after = verify_manifest(W, 'OUTPUTS.sha256', pin)
assert after == before
out = dict(start_utc=start, argv=argv, cwd=str(W), exit_code=p.returncode, timeout=timed,
           wall_limit_seconds=limit, cpu_limit_seconds=limit,
           controller_address_space_limit=resource.getrlimit(resource.RLIMIT_AS),
           asan_shadow_reservation=True, child_normal_address_space_bytes=8*1024**3,
           elapsed_seconds=time.monotonic()-tick, only_tmp_writable=True,
           hidden_originals=hidden, expected_outputs_sha256=pin,
           manifest_members_unchanged=len(after), report_sha256=after['REPORT.md'],
           stdout_sha256=sha(D/'POST_FREEZE.stdout'), stderr_sha256=sha(D/'POST_FREEZE.stderr'))
if p.returncode == 0 and not timed:
    result = json.loads((D/'REPLAY_RESULT.json').read_text())
    expected = json.loads((W/'artifacts/fresh_replay.json').read_text())
    assert result['status'] == 'FRESH_REPLAY_PASS' and result['mode'] == 'standard'
    assert result['expected_outputs_sha256'] == pin and result['matches'] == expected['matches']
    out.update(status='POST_FREEZE_STANDARD_REPLAY_PASS', semantic_matches=len(result['matches']))
else:
    out['status'] = 'POST_FREEZE_STANDARD_REPLAY_FAILED'
with (D/'POST_FREEZE.json').open('x') as f:
    json.dump(out, f, indent=2)
    f.write('\n')
sys.stdout.buffer.write(stdout)
sys.stderr.buffer.write(stderr)
print(json.dumps(out, indent=2))
sys.exit(124 if timed else p.returncode)
