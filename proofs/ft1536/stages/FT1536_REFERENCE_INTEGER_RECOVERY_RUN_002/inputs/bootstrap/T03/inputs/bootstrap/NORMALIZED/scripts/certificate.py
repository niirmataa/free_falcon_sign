import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap'
def load(p):return json.loads((W/p).read_text())
a=load('artifacts/formal_audit.json');b=load('WIDTH_BOUNDS.json');s=load('artifacts/source_binding.json');m=load('artifacts/map_certificate.json')
assert a['all_final_logs_clean'] and a['sqrt54_integer_invariant_kernelized'] and a['checked_theorems']==230 and a['new_theorems']==50
assert b['summary']['all_dss_ge_actual_last_coefficient'] and b['summary']['paired_variance_strictly_below768']
assert s['gate00_tokens_equal_after_name_map'] and s['reverse_reciprocal_tokens_equal'] and s['aggregate_scan_tokens_equal'] and s['portable_sqrt54_active']
for mode in ['normal','san']:assert load('artifacts/controls_'+mode+'.json')['all_16896_internal_and_6144_basis_words_preserved']
assert load('artifacts/mutations.json')['status']=='PASS_EXECUTED_STRUCTURAL_SCALAR_AND_FLAG_MUTATIONS'
proofs=['CLAIM.md','DOMAIN_AUDIT.md','EMITTED_STABLE_BINDING.md','NORMALIZATION.md','SQRT_DIV_CONTRACT.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','NEXT_INTERFACE.md','WIDTH_BOUNDS.json',
 'artifacts/formal_audit.json','artifacts/map_certificate.json','artifacts/source_binding.json','artifacts/source_checks.json','artifacts/controls_normal.json','artifacts/controls_san.json','artifacts/mutations.json','artifacts/lean_values.json']
deps=['RAW/RAW_PREFIX_CERTIFICATE.json','RAW/LEAF_MAP.json','RAW/COMPOSITION.md','ROOT/EMITTED_BINDING.md','ROOT/ANALYTIC_PROOF.md','review/NEXT_SCOPE.md','legacy/H4/report.md','legacy/H4/SOURCE_BINDING.md']
out=dict(schema='FT1536_NORMALIZED_EXPANSION_CERTIFICATE_V1',status='H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL',author='Niirmata',
 source_manifest_sha256=sha(I/'CANDIDATE.sha256'),base_commit='a53d7231795fb5c7317bc836baaf0ccd3ec2652f',
 domain='All legal M0 Emitted_CANDIDATE(E,sk,pk), same SourceDecodeSameSTATIC=p, RawPrefixCertificate and legal suffix buffers; fixed q18433/logn10/ter1/sigma768',
 emitted_normalized_expansion_proved=True,stable_gate_bridge_proved=True,actual_stored_sequence_proved=True,
 internal_L_preserved=True,basis_preserved=True,internal_words=16896,basis_words=6144,stored_widths=1536,tree_words=18432,
 sqrt_contract_proved=True,stable_div_domains_proved=True,sigma_only_consumer_proved=True,load_skey_success_for_emitted_legal_buffers=True,
 source_gate_from='Final successful attempt must pass certificate8110 before break8134 and both serializers; bit-identical root/core/scan coupling transfers existing acceptance',
 all_P_key_definedness_proved=True,all_P_key_definedness_type='P_key+RawPrefix+legal fixed-profile buffers -> defined stable helper/normalize, exact sequence/frame, return equals source gate Boolean',
 all_P_key_stable_gate_acceptance_proved=False,all_P_key_gate_status='OPEN_NOT_DISPROVED',P_key_strengthened=False,new_conditioning_added=False,
 source_stable_sequence='Literal top means/products/divisions, three256-word binary recursions, primary768, D[1535-u]=positive(div(of(q^2),primary[u])), full scan',
 actual_stored_sequence='S0[i]=div_C(of_C(768),sqrt_C(D[i])); write at exact RAW_LEAF_MAP[i]',
 paired_sequence='S1[i]=mul_C(0x3ff279a74590331c,S0[i]); separate from stored leaf',
 dss_expression='inv_C(mul_C(sqr_C(S),of_C(2)))',width_bounds_file='WIDTH_BOUNDS.json',width_bounds_sha256=sha(W/'WIDTH_BOUNDS.json'),
 stored_square_enclosure=['1.7763','575.9999'],paired_square_enclosure=['2.3684','767.9999'],H4_for_actual_FPEMU_stored_words=True,
 dss_ge_actual_last_coefficient=True,actual_last_coefficient_bits='3f45555555555555',scalar_width_uses=3072,
 normalization_unconditional=True,leaves_pointer_initialized=True,stable_tmp_high_water=3072,tmp_capacity_words=10752,sk_capacity_words=24576,
 kernel_modules=a['modules'],kernel_theorems=a['checked_theorems'],new_kernel_theorems=a['new_theorems'],proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',
 sqrt54_integer_invariant_kernelized=True,source_normalization_fully_kernelized=False,C_compiler_verified=False,
 unresolved_emitted_numerical_or_totality_premises=[],private_key_API_allocation_success_proved=False,global_reachability_proved=False,H3_range_proved=False,
 sampler_law_proved=False,security_reduction_proved=False,full_sign_ct_proved=False,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False,
 proof_evidence={p:sha(W/p) for p in proofs},upstream_dependencies={p:sha(I/p) for p in deps})
(W/'NORMALIZED_EXPANSION_CERTIFICATE.json').write_text(json.dumps(out,indent=2)+'\n')
rows=[]
for key,evidence in [('MANDATORY_EMITTED_STABLE_GATE','EMITTED_STABLE_BINDING'),('BITWISE_ROOT_CORE_SCAN_BRIDGE','StableBits; SOURCE_MODEL_BINDING'),('SQRT54_AND_PACK','Sqrt54/SqrtPack; SQRT_DIV_CONTRACT'),
 ('EXTENDED_DIV_DOMAIN','RootDiv + new exponent/range bridge'),('ALL_P_KEY_COMPUTATION','NORMALIZATION sections1-2'),('EMITTED_STORED_WIDTHS','NORMALIZATION section3'),('PAIRED_AND_SIGMA_ONLY_DSS','NORMALIZATION section4'),('LEAF_MAP_FRAME_RETURN','NormalizeMap; MEMORY_FRAME')]:
 rows.append(dict(id=key,status='PROVED_FOR_SCOPED_PINNED_DOMAIN',evidence=evidence))
for key in ['ALL_P_KEY_NARROW_GATE_ACCEPTANCE','INITIAL_TARGETS','ORDERED_REACH_TO_NUMERIC_CENTER','SAMPLER_LAW','SECURITY_REDUCTION','FULL_SIGN_CT','PRIVATE_KEY_API_ALLOCATION_SUCCESS']:
 rows.append(dict(id=key,status='OPEN_NOT_CLAIMED',evidence='DOMAIN_AUDIT/NEXT_INTERFACE'))
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(main_emitted_obligations_closed=True,rows=rows),indent=2)+'\n')
print(json.dumps({k:out[k] for k in ['status','all_P_key_definedness_proved','all_P_key_stable_gate_acceptance_proved','stored_square_enclosure','paired_square_enclosure','kernel_modules','kernel_theorems','new_kernel_theorems','proof_kind']},indent=2))
