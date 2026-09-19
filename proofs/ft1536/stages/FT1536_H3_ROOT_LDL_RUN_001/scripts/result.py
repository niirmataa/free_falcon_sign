import json
from pathlib import Path
from replaylib import member,sha
W=Path.cwd()
def load(r):return json.loads(member(W,r).read_text())
a=load('artifacts/formal_audit.json');c=load('artifacts/controls_normal.json');r=load('artifacts/fresh_replay.json');root=load('ROOT_CERTIFICATE.json')
assert c==load('artifacts/controls_san.json') and a['all_final_logs_clean'] and not a['full_root_theorem_kernelized']
assert r['status']=='FRESH_REPLAY_PASS' and len(r['matches'])==131
for row in r['matches']:assert sha(member(W,row['path']))==row['sha256']
flags={k:root[k] for k in ['H3_range_proved','global_reachability_proved','full_internal_tree_proved','sampler_law_proved','security_reduction_proved','baseline_source_integrated','source_changed','new_source_patch_integrated','protocol_wrapper_integrated','owner_accepted']}
out=dict(schema='H3_ROOT_LDL_RESULT_V1',stage_id='FT1536_H3_ROOT_LDL_RUN_001',status=root['status'],root_certificate_proved=True,
 proof_kind=root['proof_kind'],full_root_theorem_kernelized=False,C_compiler_kernel_refinement=False,
 domain='All Emitted_C same-key source decoding; proved superset P_key, full N1536 and every768 physical complex slot.',
 unresolved_numerical_premises=[],constants=root['constants'],frame_scope='Every defined prefix reaching the actual root call; no claim that all earlier subtree arithmetic is defined.',
 pins=dict(task_sha256='792e4f012e3fd2c0a744d1d6cd8449858386f1c19958c6a8a4ceabdeca561693',bootstrap_manifest_sha256=sha(W/'inputs/bootstrap/MANIFEST.sha256'),
  candidate_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),base='9a76ecfd72d83e131d79299f0249bca1efdf9468',report_sha256=sha(W/'REPORT.md')),
 checks=dict(lean_modules=a['modules'],checked_theorems=a['checked_theorems'],new_theorems=a['new_theorems'],all_final_logs_clean=True,
  FFT_symbolic_weights=1179648,NTT_symbolic_weights=2359296,scalar_pairs=334,root_frequency_controls=768,full_polynomial_cases=2,frame_cases=3,
  independent_RBF_components=6208,normal_and_asan_ubsan='PASS',finite_controls_are_not_universal_proof=True),
 replay=dict(pre_freeze_status=r['status'],semantic_matches=len(r['matches']),semantic_manifest_sha256=r['semantic_manifest_sha256'],
  protocol='python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256',post_freeze_receipt='tmp/final_standard_001/REPLAY_RESULT.json',post_freeze_receipt_in_outputs=False),
 next_lemma_document='NEXT_INTERFACE.md',next_lemma='Exists uniform rational Node3Constants with positive divisor/pivot lower bounds, for all P_key p and both root branches: source SplitTop/Adj/LDL_dim3 defined and full Node3Certificate at all256 frequencies.',**flags)
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(dict(status=out['status'],report_sha256=out['pins']['report_sha256'],semantic_matches=len(r['matches'])),indent=2))
