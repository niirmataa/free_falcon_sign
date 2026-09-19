import json
from pathlib import Path
from replaylib import member,sha
W=Path.cwd()
def load(r):return json.loads(member(W,r).read_text())
a=load('artifacts/formal_audit.json');c=load('artifacts/controls_normal.json');r=load('artifacts/fresh_replay.json');node=load('NODE3_CERTIFICATE.json')
assert c==load('artifacts/controls_san.json') and a['all_final_logs_clean'] and not a['full_node3_theorem_kernelized']
assert r['status']=='FRESH_REPLAY_PASS' and len(r['matches'])==123
for row in r['matches']:assert sha(member(W,row['path']))==row['sha256']
flags={k:node[k] for k in ['H3_range_proved','global_reachability_proved','full_internal_tree_proved','sampler_law_proved','security_reduction_proved','baseline_source_integrated','source_changed','new_source_patch_integrated','protocol_wrapper_integrated','owner_accepted']}
out=dict(schema='H3_NODE3_RESULT_V1',stage_id='FT1536_H3_NODE3_RUN_001',status=node['status'],node3_certificate_proved=True,
 proof_kind=node['proof_kind'],full_node3_theorem_kernelized=False,C_compiler_kernel_refinement=False,
 domain='All unchanged ROOT P_key p, both b in Fin2, all j in Fin256, same emitted/STATIC decoding support.',
 unresolved_numerical_premises=[],uniform_c3=node['constants'],inverse3=node['inverse3'],
 frame_scope='Literal repeated const aliases and scratch reuse; only defined-prefix binding, no lower-tree totality.',
 pins=dict(task_sha256='9960e9a2a5f749761f8c7aba4d861e8b4fd5ba98a6523cb0d4d2cae61bbb1d30',bootstrap_manifest_sha256=sha(W/'inputs/bootstrap/MANIFEST.sha256'),
  candidate_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),base='3d6bf58b833d729983718f80da020118fa94188a',report_sha256=sha(W/'REPORT.md')),
 checks=dict(lean_modules=a['modules'],checked_theorems=a['checked_theorems'],new_theorems=a['new_theorems'],all_final_logs_clean=True,
  physical_frequency_cases=512,raw_node_output_words=8192,scalar_pairs=176,independent_oracle_complex_outputs=4096,
  normal_and_asan_ubsan='PASS',finite_controls_are_not_universal_proof=True),
 replay=dict(pre_freeze_status=r['status'],semantic_matches=len(r['matches']),semantic_manifest_sha256=r['semantic_manifest_sha256'],
  protocol='python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256',post_freeze_receipt='tmp/final_standard_001/REPLAY_RESULT.json',post_freeze_receipt_in_outputs=False),
 next_lemma_document='NEXT_INTERFACE.md',next_lemma='Exists uniform rational c2, for all P_key p, both root branches and three source diagonal branches: SplitDeep/Adj/LDL_dim2 defined and Node2Certificate at all128 frequencies.',**flags)
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(dict(status=out['status'],report_sha256=out['pins']['report_sha256'],semantic_matches=len(r['matches'])),indent=2))
