"""Retain the independent H6P replay, exact scope and separate numerical review."""
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from fractions import Fraction as F

repo = Path('/home/footfalcon/free_falcon_sign'); root = repo/'proofs/ft1536'
here = Path(__file__).resolve().parent
sys.path.insert(0, str(root/'tools'))
import archive
stage = 'FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001'
pin = 'a11735ac8fbc76aaa72d220f02acfd6f7254ee72ecfac8ab1004cbb843bda7d5'
report = '3c425b1c1e863c7bfb3cbde6284b299a926cb2fb51e89279035e2ce1da0081cd'
certpin = '89dacd3248ffb4ca9cab106faae6723a3c12a99802243209f70a67d92092b278'
status = 'H6P_REFERENCE_BAD_EVENT_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL'
parent = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo).decode().strip()
archive.require(parent == '0c1ddc19000dc448fe6219af9f2251d4667eb7cb', 'Parent')
archive.verify_stage(root, stage); base = root/'stages'/stage
archive.checked_bytes(base/'REPORT.md', report)
run = root/'replay-work'/stage/'maintainer-replay-001'; child = run/'seed/tmp/replay'
target = root/'validation/2026-09-22-h6p-reference-bad-event'
def load(p): return json.loads(archive.read(child/p))
ex = json.loads(archive.read(run/'execution.json'))
archive.require(ex['execution_result'] == 'PASS' and ex['semantic_files'] == 197
    and ex['claimed_status'] == status and ex['manifest_sha256'] == pin
    and not ex['timed_out'] and ex['exit_code'] == 0, 'Execution')
result = json.loads(archive.checked_bytes(child/'REPLAY_RESULT.json', ex['replay_result_sha256']))
archive.require(result['status'] == 'FRESH_REPLAY_PASS' and result['game'] == 'IID_BUFFER'
    and result['reference'] == 'Q_S' and result['fresh_without_project_cache']
    and result['source_scope_unchanged'] and not result['mismatches']
    and not result['real_prng_to_iid_bridge_proved'], 'Replay scope')
archive.require(archive.check_replay_result(base, child,
    json.loads(archive.read(base/'artifacts/fresh_replay.json')), result) == 197, 'Matches')
sources = {'capture.py': Path(__file__), 'independent_numerics.py': here/'independent_numerics.py',
    'execution.json': run/'execution.json', 'stdout.txt': run/'stdout.txt', 'stderr.txt': run/'stderr.txt',
    'REPLAY_RESULT.json': child/'REPLAY_RESULT.json', 'REPLAY_COMMANDS.json': child/'REPLAY_COMMANDS.json',
    'COMMANDS.log': child/'COMMANDS.log'}
for p in ('FAILED_ROUTES.md', 'COUNTERMODELS.md', 'NEXT_INTERFACE.md'): sources[p] = base/p
for s in ('stdout', 'stderr'): archive.checked_bytes(run/(s+'.txt'), ex[s+'_sha256'])
for p in archive.semantic_rows(result): sources[p] = child/p
def keep(p): sources[p] = child/p
def streams(r, paths=None, clean=False):
    archive.require(r['exit_code'] == 0 and not r.get('timeout', False), 'Failed job')
    for s in ('stdout', 'stderr'):
        p = r[s] if paths is None else paths[s]; data = archive.checked_bytes(child/p, r[s+'_sha256']); keep(p)
        if clean: archive.require(not re.search(rb'warning:|error:|sorryAx|Lean.ofReduceBool', data), 'Kernel log')
        if s == 'stderr': archive.require(not re.search(rb'ERROR: AddressSanitizer|runtime error:', data), 'Sanitizer diagnostic')
jobs = load('REPLAY_COMMANDS.json'); archive.require(len(jobs) == 27, 'Driver count')
for r in jobs: streams(r, {s: 'logs/replay_job_'+str(r['index'])+'.'+s for s in ('stdout', 'stderr')})
prefix = archive.read(base/'artifacts/COMMANDS.final_prefix.log'); live = archive.read(child/'COMMANDS.log')
archive.require(live.startswith(prefix), 'Frozen command prefix')
commands = [json.loads(s) for s in live[len(prefix):].decode().splitlines()]
archive.require(len(commands) == 27, 'Executor count')
for r in commands:
    archive.require(r['exit_code'] == 0 and not r['timeout'], 'Executor')
    for s in ('stdout', 'stderr'): archive.checked_bytes(child/r[s], r['stream_sha256'][s]); keep(r[s])
kernel = load('artifacts/final_kernel_receipts.json'); archive.require(len(kernel) == 48, 'Kernel jobs')
keep('artifacts/final_kernel_receipts.json'); keep('artifacts/kernel.jsonl')
for r in kernel: streams(r, clean=True)
native = {}
for mode in ('normal', 'sanitized'):
    rows = []
    for group in range(4):
        p = f'artifacts/native_receipts_{mode}_{group}.json'; keep(p); batch = load(p)
        for r in batch: streams(r, {s: f"logs/native_{mode}_{r['case']}."+s for s in ('stdout', 'stderr')})
        rows.extend(batch)
    archive.require(len(rows) == 7, 'Native count'); native[mode] = {r['case']: r['stdout_sha256'] for r in rows}
    p = 'artifacts/build_'+mode+'.json'; keep(p); builds = load(p)
    archive.require(len(builds) == 2, 'Build count')
    for name, r in zip(('map', 'post'), builds):
        archive.require('checks/'+name+'.c' in r['argv'], 'Build binding')
        streams(r, {s: f'logs/build_{mode}_{name}.'+s for s in ('stdout', 'stderr')})
archive.require(native['normal'] == native['sanitized'], 'Native outputs')
keep('artifacts/toolchain_commands.json')
for i, r in enumerate(load('artifacts/toolchain_commands.json')):
    streams(r, {s: f'logs/toolchain_{i}.'+s for s in ('stdout', 'stderr')})
for p in ('logs/audit_driver.stdout', 'logs/audit_driver.stderr'): keep(p)
audit = load('artifacts/formal_audit.json')
archive.require((audit['modules'], audit['checked_theorems'], audit['new_theorems'], audit['inherited_modules_unchanged'])
    == (48, 327, 26, 42) and audit['all_final_logs_clean'] and not audit['fully_kernelized'], 'Audit')
for p, h in audit['sources_sha256'].items(): archive.checked_bytes(child/p, h)
for name, key in (('H6PAudit', 'audit_stdout_sha256'), ('H6PTypes', 'types_terms_stdout_sha256')):
    archive.checked_bytes(child/'logs/final'/(name+'.stdout'), audit[key])
cert = json.loads(archive.checked_bytes(child/'H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json', certpin))
archive.require(cert['status'] == status and cert['game'] == 'IID_BUFFER', 'Claim')
for group in ('proof_documents', 'evidence'):
    for p, h in cert[group].items(): archive.checked_bytes(child/p, h)
for k, v in cert['flags'].items(): archive.require(cert[k] is v, 'Duplicated flag')
proved = ('source_noise_map_proved', 'coefficients_entry_measurable_proved', 'source_variance_proxy_proved',
    'full_source_roundoff_bound_proved', 'conditional_discrete_Gaussian_MGF_proved',
    'local_support_conditioning_cost_proved', 'rint_event_bridge_proved',
    'joint_reference_BadPrecast_bound_proved', 'joint_BadPrecast_bound_proved', 'one_root_IID_event_transfer_proved')
for k in proved: archive.require(cert[k] is True, k)
for k in ('universal_Safe16_proved', 'Safe16_proved', 'reference_integer_recovery_proved', 'Sign_to_Verify_proved',
    'real_prng_to_iid_bridge_proved', 'retry_composition_proved', 'whole_real_Sign_termination_proved',
    'security_reduction_proved', 'full_Sign_CT_proved', 'fully_kernelized', 'C_compiler_verified',
    'source_changed', 'production_source_changed', 'new_source_patch_integrated', 'owner_accepted', 'required_domain_counterexample'):
    archive.require(cert[k] is False, k)
archive.require(cert['new_M0_eta_pre'] is None and not cert['EXIT_in_event']
    and cert['source_map']['offset'] == '0' and cert['source_map']['coefficients_depend_on'] == 'entry only', 'Scope')
tail = load('JOINT_TAIL_BOUND.json')
archive.require(tail['scope'] == 'ONE_ROOT_ONLY' and tail['coefficients'] == 3072 and tail['signed_tail_events'] == 6144
    and F(cert['q_bound']) == F(tail['reference_q_upper']) <= F(1, 2**119)
    and F(cert['one_root_IID_bound']) == F(tail['IID_upper']) <= F(1, 2**84), 'Bounds')
archive.require(F(tail['variance_proxy']) < 5462457 and F(tail['roundoff']) < 1095, 'Source ceilings')
checks = cert['checks']
archive.require(checks['adaptive_Gaussian_atoms'] == 1209 and checks['full_root_map_fixtures'] == 2
    and checks['all_coefficients_checked_each'] == 3072 and checks['meaningful_mutations'] == 12 and checks['noop'] == 1, 'Controls')
source = archive.manifest(archive.checked_bytes(child/'inputs/bootstrap/CANDIDATE.sha256',
    '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'))
for p, h in source.items(): archive.checked_bytes(child/'source'/p, h)

for p in ('home', 'tmp'): (here/p).mkdir(exist_ok=True)
argv = ['bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid', '--ro-bind', '/', '/',
    '--bind', str(here), str(here), '--proc', '/proc', '--dev', '/dev', '--chdir', str(here), '--',
    '/home/footfalcon/.local/bin/sage', str(here/'independent_numerics.py'), str(child)]
env = dict(os.environ, HOME=str(here/'home'), TMPDIR=str(here/'tmp'), DOT_SAGE=str(here/'home/.sage'),
    PYTHONDONTWRITEBYTECODE='1', OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1')
t = time.monotonic(); p = subprocess.run(argv, cwd=here, env=env, capture_output=True, timeout=120)
for s, data in (('stdout', p.stdout), ('stderr', p.stderr)):
    path = here/('independent_numeric.'+s); archive.put_once(path, data); sources[path.name] = path
archive.require(p.returncode == 0 and not p.stderr, 'Independent numeric check: '+p.stderr.decode())
independent = json.loads(p.stdout)
archive.require(independent['status'] == 'PASS_INDEPENDENT_RATIONAL_AND_RBF768_H6P_CHECKS', 'Independent status')
numeric_receipt = dict(argv=argv, exit_code=p.returncode, elapsed_seconds=time.monotonic()-t,
    stdout_sha256=archive.digest(p.stdout), stderr_sha256=archive.digest(p.stderr))
archive.put_once(here/'independent_numeric.json', archive.json_bytes(numeric_receipt))
sources['independent_numeric.json'] = here/'independent_numeric.json'
review = dict(status='PASS_REPLAY_AND_SCOPED_H6P_REFERENCE_EVENT_REVIEW', claim_status=status,
    parent_commit=parent, manifest_sha256=pin, report_sha256=report, certificate_sha256=certpin,
    game='IID_BUFFER', reference='Q_S', event='joint BadPrecast, BOTH1536 pre-narrow vectors, Live only',
    scope='ONE_ROOT, each required emitted/canonical entry and legal entry PAST', semantic_files=197,
    modules=48, theorems=327, new_theorems=26, inherited_modules=42, native_cases_each_mode=7,
    reference_upper='2^-119', IID_one_root_upper='2^-84', variance_integer_upper=5462457,
    full_roundoff_integer_upper=1095, independent_numerics=independent, proved_flags=list(proved),
    proof_kind=cert['proof_kind'], fully_kernelized=False, owner_accepted=False, source_changed=False,
    universal_Safe16_proved=False, real_prng_to_iid_bridge_proved=False, retry_composition_proved=False,
    reference_integer_recovery_proved=False, Sign_to_Verify_proved=False, new_M0_eta_pre=None,
    canonical_root=str(repo))
files = {}
for name, path in sorted(sources.items()):
    data = archive.checked_bytes(path); archive.put_once(target/name, data); files[name] = archive.digest(data)
data = archive.json_bytes(review); archive.put_once(target/'review_checks.json', data)
files['review_checks.json'] = archive.digest(data)
archive.put_once(target/'VALIDATION.sha256', ''.join(h+'  '+name+'\n' for name, h in sorted(files.items())).encode())
print(json.dumps(dict(status=review['status'], files=len(files), bytes=sum((target/name).stat().st_size for name in files),
    validation_sha256=archive.digest(archive.read(target/'VALIDATION.sha256')), independent_numerics=independent), indent=2))
