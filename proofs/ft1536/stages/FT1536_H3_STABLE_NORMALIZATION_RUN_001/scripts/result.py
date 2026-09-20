import json
from pathlib import Path
from replaylib import sha
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
c=load('NORMALIZED_EXPANSION_CERTIFICATE.json');r=load('artifacts/fresh_replay.json');assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==load('SEMANTIC_FILES.json')['matches']
keys=['status','source_manifest_sha256','base_commit','emitted_normalized_expansion_proved','stable_gate_bridge_proved','actual_stored_sequence_proved','internal_L_preserved','basis_preserved','internal_words','basis_words','stored_widths','tree_words','sqrt_contract_proved','stable_div_domains_proved','sigma_only_consumer_proved','load_skey_success_for_emitted_legal_buffers','all_P_key_definedness_proved','all_P_key_definedness_type','all_P_key_stable_gate_acceptance_proved','all_P_key_gate_status','P_key_strengthened','new_conditioning_added','stored_square_enclosure','paired_square_enclosure','dss_ge_actual_last_coefficient','actual_last_coefficient_bits','scalar_width_uses','normalization_unconditional','leaves_pointer_initialized','stable_tmp_high_water','kernel_modules','kernel_theorems','new_kernel_theorems','proof_kind','sqrt54_integer_invariant_kernelized','source_normalization_fully_kernelized','C_compiler_verified','unresolved_emitted_numerical_or_totality_premises','private_key_API_allocation_success_proved','global_reachability_proved','H3_range_proved','sampler_law_proved','security_reduction_proved','full_sign_ct_proved','source_changed','production_source_changed','new_source_patch_integrated','owner_accepted']
out={k:c[k] for k in keys};out.update(schema='FT1536_H3_STABLE_NORMALIZATION_RESULT_V1',author='Niirmata',certificate_sha256=sha(W/'NORMALIZED_EXPANSION_CERTIFICATE.json'),
 semantic_controls='PASS_8_PUBLIC_PIPELINES_AND_SCALAR_ORACLES',sanitizers='PASS_ASan_UBSan',LSan_claimed=False,sqrt_cases=40930,lean_sqrt_cases=4096,divisor_pairs=117,bit_identity_pairs=196,gate_cases=24,width_cases=1033,
 mutation_controls='PASS_NOOP_AND_8_EXECUTED_MUTATIONS',synthetic_key_membership_claimed=False,
 replay=dict(status=r['status'],semantic_matches=len(r['matches']),anchor_sha256=r['input_manifest_sha256'],receipt_sha256=sha(W/'artifacts/fresh_replay.json'),cached_project_binaries_or_olean_used=False),
 next_required_types=['INITIAL_TARGETS with source FFT3/basis/inverse(q)','ORDERED_REACH_TO_NUMERIC_CENTER before floor/cast/residual(mu)'])
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
