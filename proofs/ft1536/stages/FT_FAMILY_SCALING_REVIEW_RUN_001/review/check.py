"""Snapshot after the owner's completion signal and isolated scoped review."""
import datetime as dt
import json
import os
from pathlib import Path
import re
import resource
import shutil
import subprocess
import sys
import time

repo = Path('/home/footfalcon/free_falcon_sign'); here = Path(__file__).resolve().parent
relative = Path('proofs/ft1536/work/FT_FAMILY_SCALING_2026-09-21')
original = repo/relative; snapshot = here/'snapshot_repo'/relative; execute = here/'execute_repo'/relative
sys.path.insert(0, str(repo/'proofs/ft1536/tools'))
import archive
assert not snapshot.exists() and not execute.exists()
raw_manifest = archive.read(original/'SHA256SUMS')
claimed = {}
for line in raw_manifest.decode().splitlines():
    pin, path = line.split('  ', 1); path = path.removeprefix('./'); archive.checked_path(path)
    assert re.fullmatch('[0-9a-f]{64}', pin); claimed[path] = pin
files = {}
for rel in sorted(set(claimed)|{'SHA256SUMS'}):
    data = archive.checked_bytes(original/rel); archive.put_once(snapshot/rel, data); files[rel] = archive.digest(data)
changed_during_read = [rel for rel, pin in files.items() if archive.digest(archive.read(original/rel)) != pin]
assert not changed_during_read, changed_during_read
manifest_mismatches = [rel for rel, pin in claimed.items() if files[rel] != pin]
source_manifest = archive.checked_bytes(repo/'provenance/ft1536-candidate.sha256',
    '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985')
for rel, pin in archive.manifest(source_manifest).items():
    archive.put_once(here/'snapshot_repo/Extra/c'/rel, archive.checked_bytes(repo/'Extra/c'/rel, pin))
shutil.copytree(here/'snapshot_repo', here/'execute_repo')
metadata = dict(status='REVIEW_SNAPSHOT_AFTER_OWNER_COMPLETION_SIGNAL', captured_utc=dt.datetime.now(dt.timezone.utc).isoformat(),
    reported_completed_work=str(original), snapshot=str(snapshot), files=files,
    supplied_manifest_mismatches=manifest_mismatches, changed_during_read=[],
    current_git_head=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo).decode().strip(),
    active_package_imported=False)
archive.put_once(here/'SNAPSHOT.json', archive.json_bytes(metadata))
for name in ('home', 'tmp', 'logs'): (here/name).mkdir()
receipts = []
def limits(): resource.setrlimit(resource.RLIMIT_AS, (8*2**30, 8*2**30))
def job(name, command, limit=120):
    argv = ['bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid', '--ro-bind', '/', '/',
            '--bind', str(here), str(here), '--proc', '/proc', '--dev', '/dev', '--chdir', str(execute), '--', *command]
    env = dict(os.environ, HOME=str(here/'home'), TMPDIR=str(here/'tmp'), DOT_SAGE=str(here/'home/.sage'),
               PYTHONDONTWRITEBYTECODE='1', LEAN_PATH=str(execute/'lean'), OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1')
    start = time.monotonic(); p = subprocess.run(argv, cwd=here, env=env, capture_output=True, timeout=limit, preexec_fn=limits)
    for stream, data in (('stdout', p.stdout), ('stderr', p.stderr)):
        archive.put_once(here/'logs'/(name+'.'+stream), data)
    row = dict(name=name, argv=argv, exit_code=p.returncode, elapsed_seconds=time.monotonic()-start,
               stdout_sha256=archive.digest(p.stdout), stderr_sha256=archive.digest(p.stderr))
    receipts.append(row)
    archive.put_once(here/'logs'/(name+'.json'), archive.json_bytes(row))
    print(name, p.returncode, flush=True)
    assert p.returncode == 0, p.stderr.decode()
    return p
lean = '/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
for name in ('FTA2', 'FTLayout', 'FTRoots', 'FTBounds'):
    p = job('lean-'+name, [lean, '-j1', '-M2048', '-o', 'lean/'+name+'.olean', 'lean/'+name+'.lean'])
    assert not p.stdout and not p.stderr, name
for name in ('geometry', 'layout', 'bounds_table'):
    job('python-'+name, [sys.executable, '-B', 'scripts/check_'+name+'.py'])
generated_matches = {}
for name in ('geometry.json', 'geometry.csv', 'layout.json', 'layout.csv', 'bounds_table.json'):
    generated_matches[name] = archive.digest(archive.read(execute/'results'/name)) == files['results/'+name]
layout = json.loads(archive.read(execute/'results/layout.json'))
assert all(layout['closed_form_checks'].values()) and all(layout['frozen_checks'].values())
geometry = json.loads(archive.read(execute/'results/geometry.json'))
assert geometry['G1']['matches_pinned'] and geometry['G1']['matches_withdrawn']
independent = job('independent-sage', ['/home/footfalcon/.local/bin/sage', str(here/'independent_checks.py')], limit=180)
independent_data = json.loads(independent.stdout)
fft = json.loads(archive.read(snapshot/'results/fft3_error.json'))
maximum = max(v['empirical_const_maxerr_over_ell_u_l1'] for k, section in fft.items() if k.startswith('N')
              for name, v in section.items() if isinstance(v, dict) and 'empirical_const_maxerr_over_ell_u_l1' in v)
result = dict(status='PASS_SELECTED_CHECKS_WITH_OPEN_REVIEW_FINDINGS', snapshot_sha256=archive.digest(archive.read(here/'SNAPSHOT.json')),
    source_files=17, lean_modules=4, lean_logs_clean=True, python_scripts=3,
    generated_byte_matches=generated_matches, independent_checks=independent_data,
    stored_fft_empirical_constant_max=maximum, full_fft_replay=False, full_original_sage_replay=False,
    estimator_run=False, active_package_imported=False, supplied_manifest_mismatches=manifest_mismatches,
    live_changes_since_snapshot=[rel for rel, pin in files.items() if archive.digest(archive.read(original/rel)) != pin],
    jobs=receipts)
archive.put_once(here/'REVIEW_CHECKS.json', archive.json_bytes(result))
print(json.dumps(result, indent=2))
