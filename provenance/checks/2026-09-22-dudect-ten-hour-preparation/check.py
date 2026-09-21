"""Prepare ten hours without timings; retain checks and the live disk blocker."""
import json
import os
from pathlib import Path
import subprocess
import sys
import time

repo = Path('/home/footfalcon/free_falcon_sign')
here = Path(__file__).resolve().parent
work = repo/'proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002'
target = repo/'provenance/checks/2026-09-22-dudect-ten-hour-preparation'
sys.path.insert(0, str(repo/'tests/ft1536/dudect'))
from campaign import (DEFAULT_CAMPAIGN_SECONDS, MAX_CAMPAIGN_SECONDS, LOG_BYTES_PER_SECOND,
                      required_disk_bytes, sha, snapshot, utc)
from profiles import PROFILES, floor_assembly_ok
sys.path.insert(0, str(repo/'proofs/ft1536/tools'))
import archive

parent = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo).decode().strip()
assert parent == 'b2c7dadd527da50cb286755c9461da366f9ccf49'
assert (DEFAULT_CAMPAIGN_SECONDS, MAX_CAMPAIGN_SECONDS, LOG_BYTES_PER_SECOND) == (28800, 36000, 2097152)
assert not any((work/p).exists() for p in ('RUN.json', 'LAUNCH.json', 'STOP', 'PREFLIGHT_FAILURE.json'))
old = {}
for attempt in sorted((work/'attempts').iterdir()):
    data = json.loads((attempt/'PREPARATION.json').read_text())
    for rel, pin in data['sealed_files'].items(): assert sha(work/rel) == pin, rel
    old[attempt.name] = sha(attempt/'PREPARATION.json')
assert set(old) == {'000', '001', '002'}
records = []; files = {}
def retain(path, rel):
    data = archive.checked_bytes(path); archive.put_once(target/rel, data); files[rel] = archive.digest(data)
def job(tag, argv, expected=0, limit=120):
    start = time.monotonic()
    env = dict(os.environ, HOME=str(here), TMPDIR=str(here), LANG='C', LC_ALL='C', PYTHONDONTWRITEBYTECODE='1')
    p = subprocess.run(argv, cwd=repo, env=env, capture_output=True, timeout=limit)
    row = dict(argv=list(map(str, argv)), exit_code=p.returncode, expected_exit_code=expected,
               elapsed_seconds=time.monotonic()-start)
    for name, data in (('stdout', p.stdout), ('stderr', p.stderr)):
        path = here/(tag+'.'+name); archive.put_once(path, data); retain(path, 'commands/'+path.name)
        row[name+'_sha256'] = archive.digest(data)
    records.append(dict(tag=tag, **row))
    assert p.returncode == expected, (tag, p.stderr.decode())
    return p

tests = job('unit-tests', [sys.executable, '-B', '-m', 'unittest', 'discover',
    '-s', 'tests/ft1536/dudect', '-p', 'test_*.py', '-v'])
assert b'Ran 11 tests' in tests.stderr and b'\nOK\n' in tests.stderr
job('static-prepare', [sys.executable, '-B', 'tests/ft1536/dudect/prepare.py', '--repo', str(repo),
    '--work', str(work), '--resume', '--profile', 'floor-ct', '--defer-timing', '--seconds', '36000'])
prep = json.loads((work/'PREPARATION.json').read_text()); attempt = work/'attempts/003'
assert prep['global_seconds'] == 36000 and prep['status'] == 'STATIC_READY_TIMING_DEFERRED'
assert prep['harness'] == 'attempts/003/harness' and prep['cpu'] is None and prep['checks'] == []
assert prep['source_profile'] == PROFILES['floor-ct'] and prep['log_rate_limit_bytes_per_second'] == LOG_BYTES_PER_SECOND
assert sha(work/'PREPARATION.json') == sha(attempt/'PREPARATION.json')
for rel, pin in prep['sealed_files'].items(): assert sha(work/rel) == pin, rel
for p in (repo/'tests/ft1536/dudect').iterdir():
    if p.is_file(): assert sha(p) == sha(work/prep['harness']/p.name)
for name, pin in old.items(): assert sha(work/'attempts'/name/'PREPARATION.json') == pin
fixtures = json.loads((attempt/'fixture_oracles.json').read_text())
assert len(fixtures) == 14 and all(r['status'] == 'SCOPED_FIXTURE_ORACLE_MATCH' and r['per_class'] == [1024, 1024] for r in fixtures)
assert floor_assembly_ok((attempt/'logs/target-floor.stdout').read_text(), PROFILES['floor-ct'])
assert json.loads((attempt/'truncated_replay_checks.json').read_text())['rejected'] == 3
for p in (attempt/'logs').glob('*.json'):
    r = json.loads(p.read_text()); assert r['exit_code'] == 0
    for stream in ('stdout', 'stderr'): assert sha(p.with_suffix('.'+stream)) == r[stream+'_sha256']
for p in (attempt/'logs').glob('compile-*.stderr'): assert not p.read_bytes()

# Invalid fdopen(-1) stops BEFORE clocks, warmups or dudect_main. The error
# distinguishes an accepted C duration from the preceding budget rejection.
binary = work/prep['binary']; native_budgets = []
for seconds in (28800, 36000, 36001):
    p = job('native-budget-'+str(seconds), [str(binary), '--run', '0', '0', str(seconds), '-1', '1'], expected=2, limit=10)
    accepted = seconds <= 36000
    assert not p.stdout and (p.stderr.startswith(b'fdopen:') if accepted else not p.stderr)
    native_budgets.append(dict(seconds=seconds, budget_accepted=accepted, physical_timings=False,
        stop='invalid_fd_before_timing' if accepted else 'budget_rejected'))

service = job('service-state', ['systemctl', '--user', 'show', 'ft1536-dudect-run-002.service',
    '-p', 'LoadState', '-p', 'ActiveState', '-p', 'MainPID'], limit=10).stdout.decode()
assert 'MainPID=0' in service and 'ActiveState=inactive' in service
assert not any((work/p).exists() for p in ('RUN.json', 'LAUNCH.json', 'STOP', 'PREFLIGHT_FAILURE.json'))
fs = os.statvfs(work); free = fs.f_bavail*fs.f_frsize; required = required_disk_bytes(36000)
assert required == 93751083008
readiness = dict(status='PASS_TEN_HOUR_STATIC_PREPARATION', checked_utc=utc(), parent_commit=parent,
    preparation_sha256=sha(work/'PREPARATION.json'), latest_attempt='003', old_preparations=old,
    source_manifest_sha256=prep['source_manifest_sha256'], profile='floor-ct',
    global_seconds=36000, default_seconds=28800, maximum_seconds=36000,
    log_rate_limit_bytes_per_second=LOG_BYTES_PER_SECOND, required_free_bytes=required,
    available_free_bytes=free, missing_free_bytes=max(0, required-free), disk_ready=free>=required,
    launch_readiness='AWAIT_OWNER_AND_FRESH_PREFLIGHT' if free>=required else 'BLOCKED_INSUFFICIENT_DISK',
    planned_start_local='2026-09-22 around03:00 CEST, after owner signal', automatic_timer=False,
    physical_timing_trials=0, long_campaign_started=False, cpu=None,
    fixture_checks=28672, unit_checks=11, native_budget_checks=native_budgets,
    truncated_raw_checks=3, sealed_files=len(prep['sealed_files']),
    compiler_binary_sha256=sha(binary), source_changed=False, targets_changed=False,
    official_engine_changed=False, statistical_thresholds_changed=False, raw_samples_dropped=False,
    floor_target_branch_check='PASS_NO_JUMP_CALL_LOOP_INTEGER_DIVISION', machine=snapshot())
archive.put_once(here/'READINESS.json', archive.json_bytes(readiness))
archive.put_once(here/'COMMANDS.json', archive.json_bytes(records))
for name in ('READINESS.json', 'COMMANDS.json', 'check.py'): retain(here/name, name)
for name in ('PREPARATION.json', 'NIGHT_START.md'): retain(work/name, name)
for p in sorted(archive.regular_files(attempt)):
    if p.startswith('build/') and not p.endswith('.s'): continue
    retain(attempt/p, 'attempts/003/'+p)
archive.put_once(target/'CHECKS.sha256', ''.join(pin+'  '+p+'\n' for p, pin in sorted(files.items())).encode())
print(json.dumps(dict(status=readiness['status'], launch_readiness=readiness['launch_readiness'],
    preparation_sha256=readiness['preparation_sha256'], files=len(files), bytes=sum((target/p).stat().st_size for p in files),
    checks_sha256=sha(target/'CHECKS.sha256'), required_free_bytes=required, available_free_bytes=free,
    missing_free_bytes=max(0, required-free), physical_timing_trials=0, long_campaign_started=False), indent=2))
