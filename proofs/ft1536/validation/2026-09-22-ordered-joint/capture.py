"""Retain the independent ordered-joint replay and its explicit probability scope."""
from fractions import Fraction as F
import json
from pathlib import Path
import re
import subprocess
import sys

repo = Path('/home/footfalcon/free_falcon_sign'); root = repo/'proofs/ft1536'
sys.path.insert(0, str(root/'tools'))
import archive

stage = 'FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001'
pin = 'da8cfccceea6837fc21edd04e46157351d91ad2d317a37286c05f41f3126e263'
report = 'b150ca1284600dbda3a40ae3656a2058d8a6c0f3b7cfb1e38d15a9ccc5e78c59'
certpin = '2461bfa9d86f246117634bd453716fd076c669aedbe5300894993a0c78921768'
status = 'H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL'
parent = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo).decode().strip()
archive.require(parent == '683b71be3e5f988d494431e46ac643169d93764a', 'Parent')
archive.verify_stage(root, stage); base = root/'stages'/stage
archive.checked_bytes(base/'REPORT.md', report)
run = root/'replay-work'/stage/'maintainer-replay-001'; child = run/'seed/tmp/replay'
target = root/'validation/2026-09-22-ordered-joint'
def load(p): return json.loads(archive.read(child/p))
ex = json.loads(archive.read(run/'execution.json'))
archive.require(ex['execution_result'] == 'PASS' and ex['semantic_files'] == 359
                and ex['claimed_status'] == status and ex['manifest_sha256'] == pin
                and not ex['timed_out'] and ex['exit_code'] == 0, 'Execution')
result = json.loads(archive.checked_bytes(child/'REPLAY_RESULT.json', ex['replay_result_sha256']))
archive.require(result['status'] == 'FRESH_REPLAY_PASS' and result['game'] == 'IID_BUFFER'
                and result['fresh_without_project_cache'] and result['source_scope_unchanged']
                and not result['mismatches'] and not result['real_prng_to_iid_bridge_proved'], 'Scope')
archive.require(archive.check_replay_result(base, child, json.loads(archive.read(base/'artifacts/fresh_replay.json')), result) == 359, 'Matches')
sources = {'capture.py': Path(__file__), 'execution.json': run/'execution.json',
           'stdout.txt': run/'stdout.txt', 'stderr.txt': run/'stderr.txt',
           'REPLAY_RESULT.json': child/'REPLAY_RESULT.json',
           'REPLAY_COMMANDS.json': child/'REPLAY_COMMANDS.json', 'COMMANDS.log': child/'COMMANDS.log'}
for p in ('FAILED_ROUTES.md', 'COUNTERMODELS.md', 'NEXT_INTERFACE.md'): sources[p] = base/p
for s in ('stdout', 'stderr'): archive.checked_bytes(run/(s+'.txt'), ex[s+'_sha256'])
for p in archive.semantic_rows(result): sources[p] = child/p
def keep(p): sources[p] = child/p
def streams(r, paths=None, clean=False):
    archive.require(r['exit_code'] == 0 and not r.get('timeout', False), 'Failed job')
    for s in ('stdout', 'stderr'):
        p = r[s] if paths is None else paths[s]
        data = archive.checked_bytes(child/p, r[s+'_sha256']); keep(p)
        if clean: archive.require(not re.search(rb'warning:|error:|sorryAx|Lean.ofReduceBool', data), 'Kernel log')
        if s == 'stderr': archive.require(not re.search(rb'ERROR: AddressSanitizer|runtime error:', data), 'Sanitizer diagnostic')
jobs = load('REPLAY_COMMANDS.json'); archive.require(len(jobs) == 23, 'Driver count')
for r in jobs: streams(r, {s: 'logs/replay_job_'+str(r['index'])+'.'+s for s in ('stdout', 'stderr')})
prefix = archive.read(base/'artifacts/COMMANDS.final_prefix.log'); live = archive.read(child/'COMMANDS.log')
archive.require(live.startswith(prefix), 'Frozen command prefix')
commands = [json.loads(s) for s in live[len(prefix):].decode().splitlines()]
archive.require(len(commands) == 23, 'Executor count')
for r in commands:
    archive.require(r['exit_code'] == 0 and not r['timeout'], 'Executor')
    for s in ('stdout', 'stderr'): archive.checked_bytes(child/r[s], r['stream_sha256'][s]); keep(r[s])
kernel = load('artifacts/final_kernel_receipts.json'); archive.require(len(kernel) == 114, 'Kernel jobs')
keep('artifacts/final_kernel_receipts.json'); keep('artifacts/kernel.jsonl')
for r in kernel: streams(r, clean=True)
native = {}
for mode in ('normal', 'sanitized'):
    p = f'artifacts/native_receipts_{mode}.json'; keep(p); rows = load(p)
    archive.require(len(rows) == 9, 'Native count')
    for r in rows: streams(r, {s: f"logs/native_{mode}_{r['case']}."+s for s in ('stdout', 'stderr')})
    native[mode] = {r['case']: r['stdout_sha256'] for r in rows}
    p = 'artifacts/build_'+mode+'.json'; keep(p); builds = load(p)
    archive.require(len(builds) == 3, 'Build count')
    for name, r in zip(('joint', 'kernel', 'post'), builds):
        archive.require('checks/'+name+'.c' in r['argv'], 'Build binding')
        streams(r, {s: f'logs/build_{mode}_{name}.'+s for s in ('stdout', 'stderr')})
archive.require(native['normal'] == native['sanitized'], 'Native outputs')
keep('artifacts/toolchain_commands.json')
for i, r in enumerate(load('artifacts/toolchain_commands.json')):
    streams(r, {s: f'logs/toolchain_{i}.'+s for s in ('stdout', 'stderr')})
for p in ('logs/audit_driver.stdout', 'logs/audit_driver.stderr'): keep(p)
audit = load('artifacts/formal_audit.json')
archive.require((audit['modules'], audit['checked_theorems'], audit['new_theorems'], audit['inherited_modules_unchanged'])
                == (114, 884, 37, 107) and audit['all_final_logs_clean'] and not audit['fully_kernelized'], 'Audit')
for p, h in audit['sources_sha256'].items(): archive.checked_bytes(child/p, h)
for name, key in [('JointAudit', 'audit_stdout_sha256'), ('JointTypes', 'types_terms_stdout_sha256')]:
    archive.checked_bytes(child/'logs/final'/(name+'.stdout'), audit[key])
cert = json.loads(archive.checked_bytes(child/'ORDERED_JOINT_CERTIFICATE.json', certpin))
archive.require(cert['status'] == status and cert['game'] == 'IID_BUFFER' and cert['root_call_count'] == 3072, 'Claim')
for group in ('proof_documents', 'evidence'):
    for p, h in cert[group].items(): archive.checked_bytes(child/p, h)
for k, v in cert['flags'].items(): archive.require(cert[k] is v, 'Duplicated flag')
proved = ('root_source_closure_proved', 'value_projection_frame_proved', 'exact_joint_value_law_proved',
          'exact_joint_NY_law_proved', 'exact_resource_and_revealed_byte_law_proved', 'stopped_root_fresh_tail_proved',
          'root_a_s_return_IID', 'resource_bound_proved', 'reference_processes_defined', 'support_exit_bound_proved',
          'adaptive_directed_comparison_proved', 'common_conditional_lift_proved', 'POST_pushforward_proved',
          'H6P_event_transfer_proved', 'full_ordered_joint_law_proved')
for k in proved: archive.require(cert[k] is True, k)
for k in ('real_prng_to_iid_bridge_proved', 'joint_BadPrecast_bound_proved', 'Safe16_proved',
          'reference_integer_recovery_proved', 'Sign_to_Verify_proved', 'full_Sign_CT_proved',
          'whole_real_Sign_termination_proved', 'security_reduction_proved', 'global_lattice_Gaussian_law_proved',
          'retry_composition_proved', 'fully_kernelized', 'C_compiler_verified', 'source_changed',
          'production_source_changed', 'new_source_patch_integrated', 'owner_accepted', 'required_domain_counterexample'):
    archive.require(cert[k] is False, k)
ledger = load('ERROR_LEDGER.json'); M = 3072; kappa = F(1, 2**60)
delta = M*kappa/(1-M*kappa)
archive.require(F(ledger['kappa']) == kappa and ledger['M'] == M
                and F(ledger['Delta_rational_upper']) == delta == F(3, 2**50-3)
                and delta < F(1, 2**48), 'Adaptive second-moment bound')
# TV <= sqrt(delta)/2; exact rational check avoids any floating-point sqrt.
archive.require(delta/4 < F(1, 2**25)**2, 'TV bound')
tau = F(ledger['tau'])
archive.require(0 < M*tau == F(ledger['exit_upper']) < F(1, 2**50), 'Support exit')
archive.require(ledger['reference_q_for_BadPrecast'] is None and ledger['real_PRNG_loss'] is None
                and ledger['new_M0_epsilon'] is None and ledger['support_tail_counted_once'], 'Open consumers')
metrics = cert['metrics']
archive.require([(r['from_law'], r['to_law']) for r in metrics[:2]] == [('P_value', 'Q_stop'), ('P_value', 'Q_S')]
              and all(r['direction'] == 'forward' and F(r['rational_upper']) == delta for r in metrics[:2]), 'Direction')
archive.require(metrics[5]['from_law'] == 'Q_stop' and metrics[5]['value'] == 'infinity'
                and not metrics[5]['absolute_continuity'] and metrics[6]['upper_expression'] == '2^811008-1', 'Reverse metrics')
archive.require(not cert['reference_processes']['QS_equals_whole_survival_conditioning']
                and not cert['reference_processes']['ideal_global_lattice_Gaussian'], 'Reference distinction')
resource = load('RESOURCE_BOUND.json'); z = F(17, 16)
factor = (z/(8-7*z))/z**16
archive.require(resource['M'] == M and F(resource['A_lower']) == F(1, 8)
                and resource['expected_T'] == 8*M and resource['expected_returned_bytes'] == 33*8*M, 'Mean resource')
archive.require(F(resource['mgf']['chernoff_factor']) == factor < F(3, 4)
                and F(3, 4)**3 < F(1, 2) and resource['mgf']['T_cap'] == 16*M
                and resource['mgf']['independence_not_assumed'], 'Chernoff resource tail')
archive.require(M*F(7, 8)**768 < F(1, 2**136), 'Retained union resource tail')
budget = resource['ghost_budget']; cap = 16*M; R = min(cap, 1+(33*cap)//4087)
archive.require(budget == dict(T=cap, returned_bytes=33*cap, new_refills=R, discarded_bytes=9*R,
                new_generated_bytes=4096*R, including_entry_block=4096*(R+1))
                and not resource['ghost_is_source_abort'] and not resource['real_termination_proved'], 'Ghost accounting')
mut = load('artifacts/mutations.json')
archive.require(mut['detected'] == 12 and mut['noop'] == 1 and not mut['required_domain_counterexample'], 'Mutations')
for r in mut['rows']: archive.checked_bytes(child/r['path'], r['sha256'])
trees = load('artifacts/probability_trees.json')
archive.require(len(trees['cases']) == 4 and not trees['source_probability_proof']
                and F(trees['countermodel']['TV_QS_conditioned']) == F(1, 10), 'Abstract controls')
checks = cert['checks']
archive.require((checks['scalar_calls'], checks['proposals'], checks['getter_start_ptrs']) == (6148, 9376, 4096)
                and checks['full_root_tapes'] == 2 and checks['POST_suffix_codec_cases'] == 4, 'Control counts')
src = archive.manifest(archive.checked_bytes(child/'inputs/bootstrap/CANDIDATE.sha256',
    '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'))
for p, h in src.items(): archive.checked_bytes(child/'source'/p, h)
files = {}
for p, path in sorted(sources.items()):
    data = archive.checked_bytes(path); archive.put_once(target/p, data); files[p] = archive.digest(data)
review = dict(status='PASS_REPLAY_AND_SCOPED_ORDERED_JOINT_REVIEW', claim_status=status, game='IID_BUFFER',
    parent_commit=parent, manifest_sha256=pin, report_sha256=report, certificate_sha256=certpin,
    semantic_files=359, modules=114, theorems=884, new_theorems=37, inherited_modules=107,
    root_calls=M, native_batches_each_mode=9, scalar_calls=6148, proposals=9376, getter_start_ptrs=4096,
    chi2_from='P_value', chi2_to=['Q_S', 'Q_stop'], exact_Delta='(1+2^-60)^3072-1',
    rational_Delta_upper=str(delta), chi2_upper='2^-48', TV_upper='2^-25', support_exit_upper='2^-50',
    reverse_Qstop_chi2='infinity', reverse_QS_chi2_upper='2^811008-1',
    QS_is_whole_survival_conditioning=False, expected_proposals=24576,
    ghost_proposal_cap=49152, ghost_tail_upper='2^-1024', ghost_is_source_abort=False,
    mutations_detected=12, noop=1, proof_kind=cert['proof_kind'], fully_kernelized=False,
    real_prng_to_iid_bridge_proved=False, reference_BadPrecast_probability=None,
    joint_BadPrecast_bound_proved=False, retry_composition_proved=False,
    global_lattice_Gaussian_law_proved=False, owner_accepted=False, source_changed=False,
    canonical_root=str(repo), proved_flags=list(proved))
data = archive.json_bytes(review); archive.put_once(target/'review_checks.json', data)
files['review_checks.json'] = archive.digest(data)
archive.put_once(target/'VALIDATION.sha256', ''.join(h+'  '+p+'\n' for p, h in sorted(files.items())).encode())
print(json.dumps(dict(status=review['status'], files=len(files), bytes=sum((target/p).stat().st_size for p in files),
    validation_manifest_sha256=archive.digest(archive.read(target/'VALIDATION.sha256'))), indent=2))
