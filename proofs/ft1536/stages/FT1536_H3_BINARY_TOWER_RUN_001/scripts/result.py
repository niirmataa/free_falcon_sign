import json
from pathlib import Path
from replaylib import member,sha
W=Path.cwd()
def load(r):return json.loads(member(W,r).read_text())
a=load('artifacts/formal_audit.json');c=load('artifacts/controls_normal.json');r=load('artifacts/fresh_replay.json');tower=load('TOWER_CERTIFICATE.json')
assert c==load('artifacts/controls_san.json') and a['all_final_logs_clean'] and not a['full_binary_tower_theorem_kernelized']
assert r['status']=='FRESH_REPLAY_PASS' and len(r['matches'])==175
for row in r['matches']:assert sha(member(W,row['path']))==row['sha256']
flags={k:tower[k] for k in ['binary_tower_proved','remaining_binary_subtrees_proved','source_inner7_totality_proved','levels_proved','full_binary_tower_theorem_kernelized',
 'H3_range_proved','global_reachability_proved','full_internal_tree_proved','sampler_law_proved','security_reduction_proved','baseline_source_integrated','source_changed','new_source_patch_integrated','protocol_wrapper_integrated','owner_accepted']}
out=dict(schema='H3_BINARY_TOWER_RESULT_V1',stage_id='FT1536_H3_BINARY_TOWER_RUN_001',status=tower['status'],proof_kind=tower['proof_kind'],C_compiler_kernel_refinement=False,
 domain='All unchanged P_key; isolated levels7..1 and all12 actual raw inner7 subtrees under the stated C/API model.',unresolved_numerical_premises=[],
 uniform_summaries=tower['uniform_summaries'],coverage=tower['coverage'],constants_file=tower['constants_file'],constants_sha256=tower['constants_sha256'],
 pins=dict(task_sha256='5d00e65d8a7f59d9b46e6d133eb81de1da374d6764b4600183e018710931cc14',bootstrap_manifest_sha256=sha(W/'inputs/bootstrap/MANIFEST.sha256'),
  candidate_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),base='b27a0557f785eabd30632eeea9da6b9cf170a7d0',report_sha256=sha(W/'REPORT.md')),
 checks=dict(lean_modules=a['modules'],checked_theorems=a['checked_theorems'],new_theorems=a['new_theorems'],all_final_logs_clean=True,
  nodes=1524,complex_positions=5376,raw_tree_words=12288,half_boundary_words=98,divisor_pairs=30,normal_and_asan_ubsan='PASS',finite_controls_are_not_universal_proof=True),
 replay=dict(pre_freeze_status=r['status'],semantic_matches=len(r['matches']),semantic_manifest_sha256=r['semantic_manifest_sha256'],protocol='python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256',
  post_freeze_receipt='tmp/final_standard_001/REPLAY_RESULT.json',post_freeze_receipt_in_outputs=False),next_lemma_document='NEXT_INTERFACE.md',
 next_lemma='Full defined raw-loader prefix assembly of ROOT/NODE3/NODE2/remaining trees,18432 raw words; stable rebuild/normalize is separately open.',**flags)
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(dict(status=out['status'],report_sha256=out['pins']['report_sha256'],semantic_matches=len(r['matches'])),indent=2))
