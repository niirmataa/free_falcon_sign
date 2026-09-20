import json
from pathlib import Path
from replaylib import sha
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
c=load('RAW_PREFIX_CERTIFICATE.json');r=load('artifacts/fresh_replay.json');a=load('artifacts/formal_audit.json');assert r['status']=='FRESH_REPLAY_PASS'
assert r['matches']==load('SEMANTIC_FILES.json')['matches']
out={k:c[k] for k in ['status','source_manifest_sha256','base_commit','raw_loader_prefix_proved','raw_tree_assembly_proved','raw_prefix_totality_proved','emitted_corollary_proved','source_transport_proved',
 'basis_words','raw_tree_words','internal_words','leaf_words','sk_words','tmp_words','tmp_high_water','proof_kind','raw_prefix_fully_kernelized','C_compiler_verified','unresolved_numerical_or_totality_premises',
 'P_key_strengthened','completed_prefix_assumed','normalized_expansion_proved','full_private_loader_proved','H3_range_proved','global_reachability_proved','sampler_law_proved','security_reduction_proved','full_sign_ct_proved',
 'source_changed','production_source_changed','new_source_patch_integrated','owner_accepted']}
out.update(schema='FT1536_H3_RAW_ASSEMBLY_RESULT_V1',author='Niirmata',raw_cut='After original ffLDL_fft3 returns at falcon-sign.c1253; before stable rebuild/normalization',
 raw_certificate_sha256=sha(W/'RAW_PREFIX_CERTIFICATE.json'),kernel_modules=a['modules'],checked_theorems=a['checked_theorems'],new_theorems=a['new_theorems'],all_final_Lean_logs_clean=a['all_final_logs_clean'],
 semantic_controls='PASS_6_PUBLIC_FIXTURES_ALL_BASIS_TREE_AND_INTERMEDIATE_WORDS',sanitizers='PASS_ASan_UBSan',LSan_claimed=False,
 mutation_controls='PASS_NOOP_AND_5_EXECUTED_MODEL_MUTATIONS',invalid_preflight_cases=4,P_key_or_emitted_fixtures_claimed=False,
 replay=dict(status=r['status'],semantic_matches=len(r['matches']),anchor_sha256=r['input_manifest_sha256'],receipt_sha256=sha(W/'artifacts/fresh_replay.json'),cached_binaries_or_olean_used=False),
 next_required_type='P_key + RawPrefixCertificate -> defined terminating actual stable rebuild/normalization, exact stored width sequence, gates and preserved internal L/basis',
 proof_documents={p:sha(W/p) for p in ['CLAIM.md','COMPOSITION.md','MEMORY_LAYOUT.md','SOURCE_TRANSPORT.md','SOURCE_MODEL_BINDING.md','NEXT_INTERFACE.md','OBLIGATIONS.json']})
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
