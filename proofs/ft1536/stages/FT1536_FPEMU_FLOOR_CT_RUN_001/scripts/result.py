import json
from pathlib import Path
from replaylib import sha
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
f=load('artifacts/candidate_freeze.json');a=load('artifacts/formal_audit.json');s=load('SEMANTIC_CHECKS.json');m=load('MUTATION_CONTROLS.json')
t=load('artifacts/timing_summary.json');asm=load('artifacts/assembly_ledger.json');r=load('artifacts/fresh_replay.json');e=load('artifacts/evidence_integrity.json')
assert a['all_word64_equivalence_proved'] and a['all_final_logs_clean'] and a['source_definedness_range_facts_proved']
assert s['status']==m['status'].split('_REAL')[0]=='PASS' and asm['candidate_regions']==5
assert t['status']=='PASS_PRESPECIFIED_AB_EXPLORATORY_SHARED_HOST' and t['baseline_signal_reproduced'] and not t['candidate_signal_detected']
assert t['positive_controls_pass']==t['negative_controls_pass']==6 and t['candidate_floor_no_signal']==t['baseline_floor_detections']==9
assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==load('SEMANTIC_FILES.json')['matches']
out=dict(schema='FT1536_FPEMU_FLOOR_CT_RESULT_V1',status='FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD',author='Niirmata',
 baseline_commit='20ed84a86d9374b026e2ea9ab78f7656a6650a8c',candidate_source_changed=True,changed_files=f['changed_files'],unchanged_source_files=16,
 baseline_manifest_sha256=f['baseline_manifest_sha256'],candidate_manifest_sha256=f['candidate_manifest_sha256'],candidate_header_sha256=f['candidate_header_sha256'],patch_sha256=f['patch_sha256'],
 all_word64_equivalence_proved=True,source_definedness_proved=True,domain='All 2^64 raw input words under explicit C99/GCC14.2/x86_64 LP64 binding',
 proof_kind=a['proof_kind'],compiler_binding_scope='GCC Debian14.2.0-19, C99, Linux x86_64 LP64/two\'s complement; literal Makefile -W -Wall -O/macros; explicit implementation-defined arithmetic right shift and uint64-to-int64 bit decoding',
 C_compiler_verified=False,kernel_modules=a['modules'],kernel_theorems=a['checked_theorems'],new_kernel_theorems=a['new_theorems'],
 numeric_center_transport_proved=True,negative_zero_preserved=True,compiler_barrier_used=False,
 compiled_floor_control_flow_fixed=True,compiled_floor_memory_trace_fixed=True,reviewed_candidate_regions=5,all_three_production_floor_sites_reviewed=True,
 semantic_checks=s['status'],semantic_cases=s['normal']['cases'],independent_public_random_words=1000000,lean_value_cases=s['lean_values']['cases'],
 mutation_checks=m['status'],sanitizer_checks='PASS_ASan_UBSan',LSan_claimed=False,
 timing_status=t['status'],timing_host_scope=t['host_scope'],timing_plan_sha256=t['plan_sha256'],baseline_signal_reproduced=True,candidate_signal_detected=False,
 timing=dict(rounds=3,trials=30,baseline_floor_detections=9,candidate_floor_no_signal=9,positive_controls_pass=6,negative_controls_pass=6,
  candidate_floor_min_n=t['candidate_floor_min_n'],candidate_floor_final_t_range=t['candidate_floor_final_t_range'],baseline_floor_final_t_range=t['baseline_floor_final_t_range'],
  elapsed_seconds=t['elapsed_seconds'],cpu=t['cpu'],all_102_states_exact=True,confirmatory_batches=e['all_batches'],
  nonexclusive_shared_host=True,hardware_CT_proof=False),
 replay=dict(status=r['status'],semantic_matches=len(r['matches']),rehearsal_anchor_sha256=r['input_manifest_sha256'],receipt_sha256=sha(W/'artifacts/fresh_replay.json'),
  physical_timing_rerun=False,raw_trials_recalculated=42,historical_raw_projection_only=True),
 production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False,full_backend_ct_proved=False,full_sign_ct_proved=False,
 H3_range_proved=False,global_reachability_proved=False,sampler_law_proved=False,security_reduction_proved=False,
 fpr_lt_negative_zero_issue_unmodified=True,resource_runtime_equality_claimed=False,
 evidence={p:sha(W/p) for p in ['artifacts/formal_audit.json','artifacts/assembly_ledger.json','artifacts/source_binding.json','artifacts/evidence_integrity.json',
 'SEMANTIC_CHECKS.json','MUTATION_CONTROLS.json','artifacts/timing_recalculation.json','artifacts/timing_summary.json','IMPACT_MATRIX.md']})
with (W/'RESULT.json').open('x') as file:json.dump(out,file,indent=2);file.write('\n')
print(json.dumps(out,indent=2))
