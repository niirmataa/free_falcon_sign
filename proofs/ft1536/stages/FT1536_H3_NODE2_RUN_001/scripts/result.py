import json
from pathlib import Path
from replaylib import member,sha
W=Path.cwd()
def load(r):return json.loads(member(W,r).read_text())
a=load('artifacts/formal_audit.json');c=load('artifacts/controls_normal.json');r=load('artifacts/fresh_replay.json');node=load('NODE2_CERTIFICATE.json')
assert c==load('artifacts/controls_san.json') and a['all_final_logs_clean'] and not a['full_node2_theorem_kernelized']
assert r['status']=='FRESH_REPLAY_PASS' and len(r['matches'])==160
for row in r['matches']:assert sha(member(W,row['path']))==row['sha256']
flags={k:node[k] for k in ['H3_range_proved','global_reachability_proved','full_internal_tree_proved','sampler_law_proved','security_reduction_proved','baseline_source_integrated','source_changed','new_source_patch_integrated','protocol_wrapper_integrated','owner_accepted']}
out=dict(schema='H3_NODE2_RESULT_V1',stage_id='FT1536_H3_NODE2_RUN_001',status=node['status'],node2_certificate_proved=True,level=node['level'],
 proof_kind=node['proof_kind'],full_node2_theorem_kernelized=False,C_compiler_kernel_refinement=False,
 domain='All unchanged P_key, both b in Fin2, k in Fin3, f in Fin128; only first binary level SplitDeep9/LDL8.',
 unresolved_numerical_premises=[],uniform_c2=node['constants'],upstream_refinement=node['upstream_refinement'],half=node['half'],
 coarse_box_countermodel=node['coarse_box_countermodel'],frame_scope='Defined source prefixes and exact lifetimes; no earlier/lower recursion totality.',
 pins=dict(task_sha256='f4a28c97adde1a2cbc26b4274086d0db171c9e5cbf3eb607e4464d511d583900',bootstrap_manifest_sha256=sha(W/'inputs/bootstrap/MANIFEST.sha256'),
  candidate_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),base='afa52d89be2f21208ac3135e74a1a60fc66d52c4',report_sha256=sha(W/'REPORT.md')),
 checks=dict(lean_modules=a['modules'],checked_theorems=a['checked_theorems'],new_theorems=a['new_theorems'],all_final_logs_clean=True,
  physical_frequency_cases=768,raw_node_output_words=6144,half_boundary_words=98,post_half_subnormal_slots=128,root_imaginary_controls=768,frame_cases=3,
  normal_and_asan_ubsan='PASS',finite_controls_are_not_universal_proof=True),
 replay=dict(pre_freeze_status=r['status'],semantic_matches=len(r['matches']),semantic_manifest_sha256=r['semantic_manifest_sha256'],
  protocol='python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256',post_freeze_receipt='tmp/final_standard_001/REPLAY_RESULT.json',post_freeze_receipt_in_outputs=False),
 next_lemma_document='NEXT_INTERFACE.md',next_lemma='Exists fixed uniform c7: all P_key, b in Fin2,k in Fin3,ell in Fin2; SplitDeep8/Adj7/LDL_dim2(logn7) defined and Node2Level7Certificate at all64 positions.',**flags)
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(dict(status=out['status'],report_sha256=out['pins']['report_sha256'],semantic_matches=len(r['matches'])),indent=2))
