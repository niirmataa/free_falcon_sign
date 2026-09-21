"""Rebuild the deferred campaign on the verified NVMe volume and retain evidence."""
import json
import os
from pathlib import Path
import subprocess
import sys
import time

repo = Path('/home/footfalcon/free_falcon_sign'); here = Path(__file__).resolve().parent
alias = repo/'proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002'
work = alias.resolve(strict=True)
target = repo/'provenance/checks/2026-09-22-dudect-nvme-storage'
sys.path.insert(0, str(repo/'proofs/ft1536/tools'))
import archive
sys.path.insert(0, str(repo/'tests/ft1536/dudect'))
from campaign import required_disk_bytes, sha, snapshot, utc
from profiles import PROFILES, floor_assembly_ok
assert alias.is_symlink() and work == Path('/media/footfalcon/FT1536_DATA/ft1536-dudect')/alias.name
assert not any((work/p).exists() for p in ('RUN.json', 'LAUNCH.json', 'STOP', 'PREFLIGHT_FAILURE.json'))
mounted = json.loads(subprocess.check_output(['findmnt', '--json', '--source', '/dev/nvme0n1p3',
    '--output', 'SOURCE,TARGET,FSTYPE,UUID,OPTIONS']))
fs, = mounted['filesystems']
assert fs['uuid'] == 'da38b9e9-0e22-4c55-b3e0-c46b9f293eca' and fs['fstype'] == 'ext4'
old = {p.name: sha(p/'PREPARATION.json') for p in (work/'attempts').iterdir()}
assert set(old) == {'000', '001', '002', '003'}
argv = [sys.executable, '-B', 'tests/ft1536/dudect/prepare.py', '--repo', str(repo), '--work', str(alias),
        '--resume', '--profile', 'floor-ct', '--defer-timing', '--seconds', '36000']
start = time.monotonic()
p = subprocess.run(argv, cwd=repo, env=dict(os.environ, HOME=str(here), TMPDIR=str(here), PYTHONDONTWRITEBYTECODE='1'),
                   capture_output=True, timeout=120)
archive.put_once(here/'nvme-prepare.stdout', p.stdout); archive.put_once(here/'nvme-prepare.stderr', p.stderr)
assert p.returncode == 0, p.stderr.decode()
prep = json.loads(archive.read(work/'PREPARATION.json')); attempt = work/'attempts/004'
assert prep['global_seconds'] == 36000 and prep['status'] == 'STATIC_READY_TIMING_DEFERRED'
assert prep['harness'] == 'attempts/004/harness' and prep['cpu'] is None and prep['checks'] == []
assert prep['source_profile'] == PROFILES['floor-ct'] and '-I'+str(work/'source') in prep['cflags']
for rel, pin in prep['sealed_files'].items(): assert sha(work/rel) == pin, rel
for name, pin in old.items(): assert sha(work/'attempts'/name/'PREPARATION.json') == pin
for previous in (work/'attempts').iterdir():
    for rel, pin in json.loads((previous/'PREPARATION.json').read_text())['sealed_files'].items():
        assert sha(work/rel) == pin, rel
for source in (repo/'tests/ft1536/dudect').iterdir():
    if source.is_file(): assert sha(source) == sha(work/prep['harness']/source.name)
fixtures = json.loads(archive.read(attempt/'fixture_oracles.json'))
assert len(fixtures) == 14 and all(r['per_class'] == [1024, 1024] and r['status'] == 'SCOPED_FIXTURE_ORACLE_MATCH' for r in fixtures)
assert floor_assembly_ok((attempt/'logs/target-floor.stdout').read_text(), PROFILES['floor-ct'])
assert json.loads((attempt/'truncated_replay_checks.json').read_text())['rejected'] == 3
for receipt in (attempt/'logs').glob('*.json'):
    row = json.loads(receipt.read_text()); assert row['exit_code'] == 0
    for stream in ('stdout', 'stderr'): assert sha(receipt.with_suffix('.'+stream)) == row[stream+'_sha256']
service = subprocess.check_output(['systemctl', '--user', 'show', 'ft1536-dudect-run-002.service',
    '-p', 'LoadState', '-p', 'ActiveState', '-p', 'MainPID']).decode()
assert 'MainPID=0' in service and 'ActiveState=inactive' in service
space = os.statvfs(alias); available = space.f_bavail*space.f_frsize
assert available >= required_disk_bytes(36000) and alias.stat().st_dev != repo.stat().st_dev
assert not any((work/p).exists() for p in ('RUN.json', 'LAUNCH.json', 'STOP', 'PREFLIGHT_FAILURE.json'))
result = dict(status='PASS_NVME_STORAGE_AND_TEN_HOUR_STATIC_PREPARATION', utc=utc(),
    canonical_alias=str(alias), physical_work=str(work), mount=fs,
    global_seconds=36000, required_free_bytes=required_disk_bytes(36000), available_free_bytes=available,
    disk_ready=True, preparation_sha256=sha(work/'PREPARATION.json'), latest_attempt='004',
    prior_preparations_unchanged=old, fixture_checks=28672, truncated_raw_checks=3,
    sealed_files=len(prep['sealed_files']), physical_timing_trials=0, long_campaign_started=False,
    service=service, argv=argv, exit_code=p.returncode, elapsed_seconds=time.monotonic()-start,
    canonical_git_root=str(repo), source_manifest_sha256=prep['source_manifest_sha256'],
    pending='Owner start signal, mains and fresh physical preflight', machine=snapshot())
archive.put_once(here/'NVME_READINESS.json', archive.json_bytes(result))
files = {}
def keep(path, rel):
    data = archive.checked_bytes(path); archive.put_once(target/rel, data); files[rel] = archive.digest(data)
for name in ('FORMAT_RESULT.json', 'RELOCATION_RESULT.json', 'RUN_002_FILES.json', 'NVME_READINESS.json',
             'nvme-prepare.stdout', 'nvme-prepare.stderr', 'finish.py'):
    keep(here/name, name)
for name in ('PREPARATION.json', 'NIGHT_START.md'): keep(work/name, name)
for rel in sorted(archive.regular_files(attempt)):
    if rel.startswith('build/') and not rel.endswith('.s'): continue
    keep(attempt/rel, 'attempts/004/'+rel)
archive.put_once(target/'CHECKS.sha256', ''.join(pin+'  '+rel+'\n' for rel, pin in sorted(files.items())).encode())
print(json.dumps(dict(status=result['status'], files=len(files), bytes=sum((target/rel).stat().st_size for rel in files),
    checks_sha256=sha(target/'CHECKS.sha256'), preparation_sha256=result['preparation_sha256'],
    available_free_bytes=available, required_free_bytes=required_disk_bytes(36000), long_campaign_started=False), indent=2))
