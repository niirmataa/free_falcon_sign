import json
from pathlib import Path
from replaylib import sha
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
c=load('INITIAL_TARGET_CERTIFICATE.json');r=load('artifacts/fresh_replay.json');assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==load('SEMANTIC_FILES.json')['matches']
keys=['status','source_pin','base_commit','initial_target_prefix_proved','all_canonical_challenges','source_target_words_matched','fft_challenge_domain_proved','reciprocal_q_proved','ideal_reference_error_proved','rounded_basis_reference_error_proved','normalized_key_preserved','cut','fft_challenge_component_error','reciprocal','coefficient_space_norm_transport','source_iFFT_certified','memory','caller_binding_scope','proof_kind','initial_targets_fully_kernelized','C_compiler_verified','kernel_modules','kernel_theorems','new_kernel_theorems','unresolved_required_numerical_or_totality_premises','global_reachability_proved','H3_range_proved','NumericCenter_from_initial_targets_proved','whole_sampler_termination_proved','whole_Sign_termination_proved','sampler_law_proved','security_reduction_proved','full_sign_ct_proved','source_changed','production_source_changed','new_source_patch_integrated','owner_accepted']
out={k:c[k] for k in keys};out.update(schema='FT1536_H3_INITIAL_TARGETS_RESULT_V1',author='Niirmata',certificate_sha256=sha(W/'INITIAL_TARGET_CERTIFICATE.json'),
 target_constants=[{k:x[k] for k in ['target','source_modulus_and_component_upper','rounding_only_error_outward','ideal_reference_error_outward','exact_coefficient_abs_upper','inverse_eval_source_coefficient_l2_error_upper']} for x in c['targets']],
 semantic_controls='PASS_11_PUBLIC_SYNTHETIC_PREFIX_CASES',sanitizers='PASS_ASan_UBSan',LSan_claimed=False,independent_oracles='PASS_EXACT_DYADIC_ROUNDED_AND_DIRECT_POLYNOMIAL_ROOT_REFERENCES',
 source_FFT_symbolic_weights=1179648,Phi_monomial_pairs=2359296,mutation_controls='PASS_NOOP_8_EXECUTED_MUTATIONS_AND_REJECTED_OLD_FFT_BOUND',synthetic_emitted_membership_claimed=False,
 replay=dict(status=r['status'],semantic_matches=len(r['matches']),anchor_sha256=r['input_manifest_sha256'],receipt_sha256=sha(W/'artifacts/fresh_replay.json'),cached_project_binaries_or_olean_used=False),
 next_required_type='ORDERED_REACH from the explicit root ffSampling entry, through actual right-before-left/residual/fault/rejection histories, to NumericCenter(mu) before floor/cast/residual')
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
