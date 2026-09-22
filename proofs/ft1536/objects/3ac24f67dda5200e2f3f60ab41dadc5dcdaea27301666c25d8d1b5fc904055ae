"""Additional kernel-axiom audit and independent complete FFT-port controls."""
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import sys
import time

repo = Path('/home/footfalcon/free_falcon_sign'); here = Path(__file__).resolve().parent
relative = Path('proofs/ft1536/work/FT_FAMILY_SCALING_2026-09-21')
execute = here/'execute_repo'/relative
sys.path.insert(0, str(repo/'proofs/ft1536/tools'))
import archive
names = []
for module in ('FTA2', 'FTLayout', 'FTRoots', 'FTBounds'):
    source = archive.read(execute/'lean'/(module+'.lean')).decode()
    source = re.sub(r'/\-.*?\-/', '', source, flags=re.S)
    source = re.sub(r'--[^\n]*', '', source)
    assert not re.search(r'\b(sorry|admit|native_decide|axiom|opaque)\b|Lean\.ofReduceBool', source)
    names += ['FTFamily.'+name for name in re.findall(r'^theorem\s+(\w+)', source, re.M)]
audit = '\n'.join('import '+m for m in ('FTA2', 'FTLayout', 'FTRoots', 'FTBounds'))+'\n'
audit += '\n'.join('#print axioms '+n+'\n#check @'+n+'\n#print '+n for n in names)+'\n'
archive.put_once(execute/'lean/ReviewAudit.lean', audit.encode())
def limits(): resource.setrlimit(resource.RLIMIT_AS, (8*2**30, 8*2**30))
def job(name, command, limit):
    argv = ['bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid', '--ro-bind', '/', '/',
            '--bind', str(here), str(here), '--proc', '/proc', '--dev', '/dev', '--chdir', str(execute), '--', *command]
    env = dict(os.environ, HOME=str(here/'home'), TMPDIR=str(here/'tmp'), DOT_SAGE=str(here/'home/.sage'),
               PYTHONDONTWRITEBYTECODE='1', LEAN_PATH=str(execute/'lean'), OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1')
    start = time.monotonic(); p = subprocess.run(argv, cwd=here, env=env, capture_output=True, timeout=limit, preexec_fn=limits)
    for stream, data in (('stdout', p.stdout), ('stderr', p.stderr)):
        archive.put_once(here/'logs'/(name+'.'+stream), data)
    row = dict(name=name, argv=argv, exit_code=p.returncode, elapsed_seconds=time.monotonic()-start,
               stdout_sha256=archive.digest(p.stdout), stderr_sha256=archive.digest(p.stderr))
    archive.put_once(here/'logs'/(name+'.json'), archive.json_bytes(row))
    assert p.returncode == 0, p.stderr.decode()
    return p, row
lean = '/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
kernel_job = json.loads(archive.read(here/'logs/kernel-audit.json'))
kernel_stdout = archive.checked_bytes(here/'logs/kernel-audit.stdout', kernel_job['stdout_sha256'])
kernel_stderr = archive.checked_bytes(here/'logs/kernel-audit.stderr', kernel_job['stderr_sha256'])
assert kernel_job['exit_code'] == 0 and not kernel_stderr
assert not re.search(rb'warning:|error:|sorryAx|Lean.ofReduceBool', kernel_stdout)
for deps in re.findall(r'depends on axioms: \[([^]]*)\]', kernel_stdout.decode()):
    assert set(deps.split(', ')) <= {'propext', 'Classical.choice', 'Quot.sound'}
p, fft_job = job('independent-fft-002', ['/home/footfalcon/.local/bin/sage', str(here/'fft_oracle.py')], 240)
fft = json.loads(p.stdout); assert len(fft['cases']) == 12
snapshot = json.loads(archive.read(here/'SNAPSHOT.json'))
changed = [rel for rel, pin in snapshot['files'].items() if archive.digest(archive.read(repo/relative/rel)) != pin]
result = dict(status='PASS_ADDITIONAL_SCOPED_CHECKS', named_kernel_theorems=len(names), declarations=names,
    kernel_terms_types_axioms_checked=True, fft_port_cases=12, fft=fft, jobs=[kernel_job, fft_job],
    author_package_changes_since_snapshot=changed, full_original_sage_replay=False,
    official_full_package_replay=False, source_security_proved=False)
archive.put_once(here/'EXTRA_CHECKS.json', archive.json_bytes(result))
print(json.dumps({k: v for k, v in result.items() if k not in ('fft', 'jobs', 'declarations')}, indent=2))
