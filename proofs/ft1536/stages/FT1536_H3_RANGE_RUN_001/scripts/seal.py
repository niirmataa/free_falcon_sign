"""One-shot PARTIAL_PROOF freeze, without promotion of synthetic reachability."""
import hashlib,json,sys
from pathlib import Path
from replaylib import sha,member,verify_manifest
if sys.flags.optimize:raise RuntimeError('Python assertions required')
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
def load(p):return json.loads(member(W,p).read_text())
def write(p,x):
 with (W/p).open('x') as f:json.dump(x,f,indent=2,ensure_ascii=False);f.write('\n')
boot=verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','f9ea278838e9d1f8f959100175f56c62217997ff25611fccc0b9353dd9fcfe40');assert len(boot)==52
for line in (W/'inputs/bootstrap/CANDIDATE.sha256').read_text().splitlines():
 h,p=line.split('  ',1);assert sha(member(W,'source/'+p))==h
for r in load('inputs/provenance.json'):assert sha(member(W,r['copy']))==r['sha256']
a=load('artifacts/formal_audit.json');fresh=load('artifacts/fresh_replay.json')
assert a['checked_theorems']==49 and a['modules']==8 and a['all_final_logs_clean'] and not a['global_H3_range_proved']
for p,h in a['sources_sha256'].items():assert sha(member(W,p))==h
assert fresh['status']=='FRESH_REPLAY_PASS' and len(fresh['matches'])==96 and fresh['theorem_status']=='PARTIAL_PROOF'
for r in fresh['matches']:assert sha(member(W,r['path']))==r['sha256']
assert load('artifacts/probes_normal.json')==load('artifacts/probes_san.json')
assert load('artifacts/order_normal.json')==load('artifacts/order_san.json')
assert load('artifacts/boundaries_normal.json')==load('artifacts/boundaries_san.json')
assert load('artifacts/leaf_gap_normal.json')==load('artifacts/leaf_gap_san.json')
assert load('BOUND_LEDGER.json')['status']=='PARTIAL_PROOF'
write('RESULT.json',dict(schema='FT1536_H3_RANGE_RESULT_V1',status='PARTIAL_PROOF',H3_range_proved=False,
 required_domain_counterexample=False,extended_domain_diagnostics=True,
 exact_target='Emitted-KeyGen and actual M0 reachable pre-floor state -> mathematical floor in[-2147483283,2147483281], exact fpr_floor/long->int, proposal[-365,366], defined s+z.',
 new_results=['field-normalized floor refinement on explicit domain, negative-zero exception','kernel unsigned comparator/CDF support and selector bound','error-aware ordered terminal residual/next-center lemmas','source execution projection/call order and checked coefficient cap',
  'exact algebraic Schur/NTRU interfaces and coefficient term count','actual FPEMU normal/sanitizer diagnostics, including signed zero and underflow'],
 remaining_global_lemma='forall Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma), CenterClass(mu)',
 global_source_semantics_kernelized=False,reachability_definition='REACHABILITY.md',
 remaining_obligations=['reachable FPR-domain/negative-zero invariant','uniform source subtractive-LDL internal pivot/multiplier bounds','machine-error transfer through actual targets/split/merge and ordered prefixes','full emitted/loader-to-model refinement'],
 source_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),sign_source_sha256=sha(W/'source/falcon-sign.c'),FPEMU_source_sha256=sha(W/'source/fpr-emulated.c'),FPEMU_header_sha256=sha(W/'source/fpr-emulated.h'),
 base_commit='f5266765c5f0733fb3ab6a5e2906aa44d15e17f7',bootstrap_manifest_sha256=sha(W/'inputs/bootstrap/MANIFEST.sha256'),bootstrap_members=52,public_originals=50,
 task_sha256=sha(W/'inputs/task.md'),M0_decisions_preserved=True,honest_payload_capacity=4096,nonce_bytes=40,parametric_security_target=True,
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False,security_reduction_proved=False,
 formal_modules=8,checked_theorems=49,all_final_logs_clean=True,audit_stdout_sha256=a['audit_stdout_sha256'],full_types_sha256=a['full_types_sha256'],
 controls=dict(FPR_jobs_per_mode=112,exact_FPR_comparisons=83,boundary_words=18,selector_endpoints=15,order_callbacks_per_mode=12290,
   CDF_banks=5,CDF_rows=2560,synthetic_only=True,normal_asan_ubsan_match=True,noop_pass=True),
 replay_protocol='standard',rehearsal_status='FRESH_REPLAY_PASS',semantic_files=96,frozen_replay_receipt='artifacts/fresh_replay.json',report_sha256=sha(W/'REPORT.md')))
prefix=(W/'COMMANDS.log').read_bytes()
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(prefix)
write('artifacts/command_prefix.json',dict(path='COMMANDS.log',bytes=len(prefix),sha256=hashlib.sha256(prefix).hexdigest(),snapshot='artifacts/COMMANDS.frozen.log',note='Seal and later read-only receipts lie beyond this prefix.'))
docs=['AGENTS.md','REPORT.md','RESULT.json','CLAIM.md','OBLIGATIONS.json','REUSED_RESULTS.md','REACHABILITY.md','SOURCE_MODEL_BINDING.md','BOUND_LEDGER.json','BOUND_LEDGER.md','INPUTS.sha256','TOOLCHAIN.txt','REPLAY.md','OUTPUT_SCOPE.md']
files={W/p for p in docs}
for folder in ['source','inputs','formal','scripts','artifacts','logs','checks']:
 for p in (W/folder).rglob('*'):
  assert not p.is_symlink()
  if p.is_file() and '.olean' not in p.name and p.suffix not in ['.ilean','.pyc'] and '__pycache__' not in p.parts:files.add(p)
rels={p.relative_to(W).as_posix() for p in files};assert all(r['path'] in rels for r in fresh['matches'])
with (W/'OUTPUTS.sha256').open('x') as f:
 for p in sorted(files):f.write(sha(p)+'  '+p.relative_to(W).as_posix()+'\n')
print(json.dumps(dict(status='PARTIAL_PROOF',H3_range_proved=False,manifest_entries=len(files),REPORT=str(W/'REPORT.md'),REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256'),semantic_files=96,frozen_command_prefix_bytes=len(prefix)),indent=2))
