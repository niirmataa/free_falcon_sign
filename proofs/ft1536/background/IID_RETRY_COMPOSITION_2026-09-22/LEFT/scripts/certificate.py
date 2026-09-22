import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap'
def load(p):return json.loads((W/p).read_text())
b=load('BANK_WEIGHTED_BOUNDS.json');m=load('artifacts/metric_bounds.json');e=load('artifacts/energy_transfer.json');a=load('artifacts/formal_audit.json')
assert a['all_final_logs_clean'] and a['checked_theorems']==206 and a['new_theorems']==27
assert m['products'][1]['metric_to_stable_integer_factor']==6 and e['full_composition']['global_abs_mu']==937866518
for mode in ['normal','san']:
 assert load('artifacts/controls_'+mode+'.json')['source_frames_canaries'] and load('artifacts/banks_'+mode+'.json')['all_word_outputs_and_exact_dyadic_energy_match']
assert load('artifacts/metric_oracle.json')['status']=='PASS_INDEPENDENT_METRIC_ENERGY_AND_EXACT_RECIPROCAL_ORACLES'
assert load('artifacts/mutations.json')['status']=='PASS_NEW_BANK_METRIC_ENERGY_MUTATIONS'
ledger=dict(schema='FT1536_LEFT_ROOT_ERROR_LEDGER_V1',status='PROVED_FOR_SCOPED_PINNED_DOMAIN',bank=b,metric=m,energy=e,
 domains=dict(bank='Normalized actual stored/paired widths, selected-bank comparisons; current NumericCenter before scalar residual',metric='Actual key raw tree/local snapshots from P_key and source stable sequence; all local m/I/H domains discharged',energy='Right completion faultNONE; normal terminal pairs, no termination premise',left='Every subsequent active finite source prefix; current mu bound precedes ZERO'),
 source_PC=dict(root_transfer=[1818,1828],left_call=[1829,1830],scalar_floor=2864),discharge='METRIC_BRIDGE/BANK_WEIGHTED_BOUNDS/RIGHT_RESIDUAL_ENERGY/ROOT_TRANSFER/LEFT_INVARIANT')
(W/'ERROR_LEDGER.json').write_text(json.dumps(ledger,indent=2)+'\n')
docs=['CLAIM.md','METRIC_BRIDGE.md','BANK_WEIGHTED_BOUNDS.md','RIGHT_RESIDUAL_ENERGY.md','ROOT_TRANSFER.md','LEFT_INVARIANT.md','ORDERED_COMPOSITION.md','ERROR_LEDGER.md','ERROR_LEDGER.json','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','FAULT_REJECTION.md','CALLER_RETRY_BINDING.md','FAILED_ROUTES.md','NEXT_INTERFACE.md',
 'BANK_WEIGHTED_BOUNDS.json','artifacts/metric_bounds.json','artifacts/energy_transfer.json','artifacts/formal_audit.json','artifacts/source_binding.json','artifacts/source_checks.json','artifacts/controls_normal.json','artifacts/controls_san.json','artifacts/banks_normal.json','artifacts/banks_san.json','artifacts/metric_oracle.json','artifacts/mutations.json']
deps=['ORDERED/ORDERED_REACH_CERTIFICATE.json','ORDERED/INVARIANT.md','ORDERED/SCALAR_OUTCOMES.md','TARGETS/INITIAL_TARGET_CERTIFICATE.json','NORMALIZED/NORMALIZED_EXPANSION_CERTIFICATE.json','ZERO/ANALYTIC_PROOF.md','TOWER/TOWER_CERTIFICATE.json','TOWER/artifacts/numeric_certificate.json','NODE3/ANALYTIC_PROOF.md','ROOT/ANALYTIC_PROOF.md','ROOT/artifacts/numeric_certificate.json','RAW/LEAF_MAP.json','legacy/T5/GLOBAL_LEAF_A2_BRIDGE.md']
out=dict(schema='FT1536_LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE_V1',status='H3_LEFT_ROOT_CORRELATED_TRANSFER_PROVED_FOR_EMITTED_PINNED_MODEL',composition_status='H3_ORDERED_NUMERIC_CENTER_PROVED_FOR_EMITTED_PINNED_MODEL',author='Niirmata',
 source_pin=sha(I/'CANDIDATE.sha256'),base_commit='7664277d6da6839973e8a00db5b20c834bb63adc',
 entry='Same required emitted/same-STATIC/canonical normalized root entries and legal typed memory/context/byte-read interface as ORDERED; no future norm acceptance',
 transfer_premise='Actual right subtree completed with faultNONE; not a claim that every rejection loop terminates',
 bank_weighted_bounds_proved=True,raw_stable_metric_bridge_proved=True,right_residual_energy_proved=True,source_root_transfer_proved=True,left_forward_closure_proved=True,left_active_mu_numeric_proved=True,
 ordered_root_reach_proved=True,all_reached_mu_numeric=True,mu_domain_before_floor_proved=True,intercall_primitive_domains_proved=True,
 intercall_primitive_domains_scope='Certified actual root sampling finite prefixes under the stated legal scalar/context interface, before each consumed operation; excludes postprocessing and arbitrary faulty/malformed entries',
 terminal_weighted_A2_budget=b['terminal_A2_energy_integer_upper'],right_terminal_budget=b['right_768_terminal_budget'],right_metric_factor=6,root_gain_squared_upper=77565,
 root_U_frequency_cap=e['root']['actual_U_frequency_cap'],root_U_inverse_eval_coefficient_cap=e['root']['actual_U_inverse_eval_coefficient_cap'],
 left_source_numeric_center_margin=e['full_composition'],global_source_numeric_center_margin=e['full_composition'],
 fault_disposition='Active floor implies no earlier sticky fault. After current NumericCenter and normalized-width/arithmetic facts, source fault predicates are excluded forward on certified legal prefixes. External/test fault tails do not receive normal closeness.',
 fault_unreachable_for_certified_entries=True,fault_unreachable_scope='Required root entry and legal typed PRNG/byte interface; conditional finite-prefix arithmetic, not hardware corruption or arbitrary callback tapes',
 caller_entry_binding_proved=True,retry_frame_scope='Legal entry after defined caller prefix; source reset and immutable sk/hm. No totality/propagation through unproved postprocessing.',
 proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',fully_kernelized=False,C_compiler_verified=False,kernel_modules=a['modules'],kernel_theorems=a['checked_theorems'],new_kernel_theorems=a['new_theorems'],
 unresolved_main_transfer_premises=[],P_key_strengthened=False,raw_L_equal_stable_L_assumed=False,rounded_basis_determinant_equal_q_assumed=False,new_conditioning_or_epsilon_added=False,
 historical_ORDERED_status='PARTIAL_PROOF_UNCHANGED',old_CenterClass_reach_proved=False,H3_range_proved=False,whole_Sign_global_reach_proved=False,
 whole_sampler_termination_proved=False,whole_Sign_termination_proved=False,postprocessing_precast_safety_proved=False,sampler_law_proved=False,security_reduction_proved=False,full_sign_ct_proved=False,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False,required_domain_counterexample=False,
 proof_evidence={p:sha(W/p) for p in docs},upstream_dependencies={p:sha(I/p) for p in deps})
(W/'LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json').write_text(json.dumps(out,indent=2)+'\n')
rows=[dict(id=k,status='PROVED_FOR_SCOPED_PINNED_DOMAIN',evidence=v) for k,v in [('SOURCE_BANK_WEIGHT','BANK_WEIGHTED_BOUNDS'),('RAW_STABLE_METRIC','METRIC_BRIDGE'),('RIGHT_RESIDUAL_ENERGY','RIGHT_RESIDUAL_ENERGY'),('ACTUAL_ROOT_TRANSFER','ROOT_TRANSFER'),('LEFT_FORWARD_CLOSURE','LEFT_INVARIANT'),('FULL_ZERO_AWARE_ROOT_COMPOSITION','ORDERED_COMPOSITION')]]
rows += [dict(id=k,status='OPEN_SEPARATE_SCOPE',evidence='NEXT_INTERFACE') for k in ['OLD_CENTERCLASS_REACH','SOURCE_POSTPROCESSING_PRECAST_SERIALIZATION','WHOLE_REJECTION_SIGN_TERMINATION','SAMPLER_LAW','ROM_QROM_REDUCTION','FULL_SIGN_CT']]
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(main_transfer_closed=True,full_zero_aware_root_composition_closed=True,rows=rows),indent=2)+'\n');print(json.dumps({k:out[k] for k in ['status','composition_status','right_metric_factor','root_gain_squared_upper','global_source_numeric_center_margin','kernel_modules','kernel_theorems']},indent=2))
