import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap'
def load(p):return json.loads((W/p).read_text())
n=load('artifacts/numeric_certificate.json');l=load('ERROR_LEDGER.json');a=load('artifacts/formal_audit.json');s=load('artifacts/source_binding.json')
assert n['status']=='PASS_ALL_CANONICAL_CHALLENGE_FFT_AND_TARGET_ERRORS' and n['map']['all_symbolic_coefficients']==1179648
assert a['all_final_logs_clean'] and a['checked_theorems']==129 and a['new_theorems']==30
for mode in ['normal','san']:assert load('artifacts/controls_'+mode+'.json')['normalized_key_words_preserved']==24576
assert load('artifacts/oracle.json')['all_positions'] and load('artifacts/mutations.json')['status']=='PASS_TARGET_VALUE_ORDER_DOMAIN_MUTATIONS'
docs=['CLAIM.md','TARGET_FORMULAS.md','FFT_CHALLENGE_BOUNDS.md','ERROR_LEDGER.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','CALLER_BINDING.md','NEXT_INTERFACE.md','ERROR_LEDGER.json',
 'artifacts/numeric_certificate.json','artifacts/formal_audit.json','artifacts/source_binding.json','artifacts/source_checks.json','artifacts/controls_normal.json','artifacts/controls_san.json','artifacts/oracle.json','artifacts/mutations.json']
deps=['NORMALIZED/NORMALIZED_EXPANSION_CERTIFICATE.json','NORMALIZED/SQRT_DIV_CONTRACT.md','NORMALIZED/DOMAIN_AUDIT.md','RAW/RAW_PREFIX_CERTIFICATE.json','RAW/SOURCE_TRANSPORT.md','ROOT/ANALYTIC_PROOF.md','ROOT/EMITTED_BINDING.md','ROOT/artifacts/numeric_certificate.json','FLOOR/PATCH.diff']
out=dict(schema='FT1536_INITIAL_TARGET_CERTIFICATE_V1',status='H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL',author='Niirmata',source_pin=sha(I/'CANDIDATE.sha256'),base_commit='6c233cdb48e4fd274995dd1882e0de03305771c8',
 domain='All legal M0 emitted/same-STATIC-decode normalized keys, all canonical c∈[0,18432]^1536, legal target-entry buffers; no distribution or future norm-acceptance assumption',
 initial_target_prefix_proved=True,all_canonical_challenges=True,source_target_words_matched=True,fft_challenge_domain_proved=True,reciprocal_q_proved=True,
 ideal_reference_error_proved=True,rounded_basis_reference_error_proved=True,normalized_key_preserved=True,
 cut=dict(first=1849,last=1892,next_call=1897,next_function='ffSampling_fft3',source='falcon-sign.c'),
 source_words=dict(C='FFT3_C(map of_C canonical c)',ni=n['reciprocal']['word'],t1='scale_C(CM_C(copy(C),b01),neg_C(ni))',t0='scale_C(CM_C(C,b11),ni)',source_order=s['source_order']),
 references=dict(rounded0='val(Cw)*val(b11)/q',rounded1='-val(Cw)*val(b01)/q',ideal0='eval((-c*F/q) mod Phi)',ideal1='eval((c*f/q) mod Phi)',rounded_basis_determinant_assumed_q=False),
 fft_challenge_component_error=n['fft']['challenge_component_error_outward'],reciprocal=n['reciprocal'],targets=l['targets'],error_ledger_sha256=sha(W/'ERROR_LEDGER.json'),
 fft_map=n['map'],coefficient_space_norm_transport=True,source_iFFT_certified=False,
 memory=dict(sk_words=24576,tmp_words=10752,hm_words=1536,write_prefix=[0,3072],all_sk_preserved=True,hm_outputs_context_preserved=True,tmp_suffix_preserved=[3072,10752],future_tx_ty_tz_initialized_claimed=False),
 caller_binding_scope='Every legal do_sign entry, including legal entry after norm rejection; canonicality after defined H2P return only. Propagation across unproved sampling/postprocessing remains separate.',
 proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',initial_targets_fully_kernelized=False,C_compiler_verified=False,
 kernel_modules=a['modules'],kernel_theorems=a['checked_theorems'],new_kernel_theorems=a['new_theorems'],unresolved_required_numerical_or_totality_premises=[],
 global_reachability_proved=False,H3_range_proved=False,NumericCenter_from_initial_targets_proved=False,whole_sampler_termination_proved=False,whole_Sign_termination_proved=False,
 sampler_law_proved=False,security_reduction_proved=False,full_sign_ct_proved=False,source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False,
 proof_evidence={p:sha(W/p) for p in docs},upstream_dependencies={p:sha(I/p) for p in deps})
(W/'INITIAL_TARGET_CERTIFICATE.json').write_text(json.dumps(out,indent=2)+'\n')
ob=[]
for key,proof in [('ALL_CANONICAL_FFT18432','FFT_CHALLENGE_BOUNDS'),('SOURCE_NI_AND_WORD_MATCHING','TargetWords/TargetSequence; TARGET_FORMULAS'),('ROUNDED_AND_IDEAL_ERRORS','ERROR_LEDGER'),('COEFFICIENT_REFERENCE_NORMS','TargetAlgebra; ERROR_LEDGER'),('FULL_KEY_FRAME','TargetFrame; MEMORY_FRAME'),('DEFINED_H2P_AND_CALLER_ENTRY','CALLER_BINDING')]:ob.append(dict(id=key,status='PROVED_FOR_SCOPED_PINNED_DOMAIN',proof=proof))
for key in ['ENTRY_PROPAGATION_THROUGH_SAMPLER_POSTPROCESSING','ORDERED_REACH_TO_NUMERIC_CENTER','H2P_REJECTION_TERMINATION_OR_DISTRIBUTION','WHOLE_SIGN_TERMINATION','SAMPLER_LAW','SECURITY_REDUCTION','FULL_SIGN_CT']:ob.append(dict(id=key,status='OPEN_SEPARATE_OBLIGATION',proof='NEXT_INTERFACE/CALLER_BINDING'))
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(required_initial_target_obligations_closed=True,rows=ob),indent=2)+'\n')
print(json.dumps(dict(status=out['status'],fft_error=out['fft_challenge_component_error'],ni=out['reciprocal']['word'],targets=[dict(target=r['target'],ideal_error=r['ideal_reference_error_outward'],rounding_error=r['rounding_only_error_outward'],source_magnitude=r['source_modulus_and_component_upper']) for r in out['targets']],kernel_modules=a['modules'],theorems=a['checked_theorems']),indent=2))
