import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap'
def load(p):return json.loads((W/p).read_text())
b=load('artifacts/bounds.json');a=load('artifacts/formal_audit.json');assert a['all_final_logs_clean'] and a['checked_theorems']==179 and a['new_theorems']==23
assert b['right_numeric_abs_bound']==156276714 and b['global_mu_numeric_proved']==False
for mode in ['normal','san']:
 assert load('artifacts/controls_'+mode+'.json')['tree_root_inputs_and_canaries_preserved']
 assert load('artifacts/scalar_'+mode+'.json')['full_BerExp_integer_word_match']
assert load('artifacts/mutations.json')['status']=='PASS_HISTORY_DOMAIN_MUTATIONS'
ledger=dict(schema='FT1536_ORDERED_REACH_ERROR_LEDGER_V1',status='PARTIAL_PROOF',right_branch=b['refined_right'],old_L_bound_right=b['coarse_right'],
 proved_margin=dict(scope='FIRST_ROOT_RIGHT_BRANCH_ACTIVE_CALLS_ONLY',absolute_mu=b['right_numeric_abs_bound'],lower=b['right_NumericCenter_lower_margin'],upper=b['right_NumericCenter_upper_margin']),
 transfer=load('artifacts/transfer_certificate.json'),scalar_contract=load('artifacts/scalar_contract.json'),failed_loose_route=b['full_root_loose_route'],open_weighted_diagnostic=b['weighted_candidate'],
 global_source_numeric_margin=None,global_bound_closed=False,required_domain_counterexample=False)
(W/'ERROR_LEDGER.json').write_text(json.dumps(ledger,indent=2)+'\n')
docs=['CLAIM.md','INVARIANT.md','SCALAR_OUTCOMES.md','FAULT_REJECTION.md','ERROR_LEDGER.md','ERROR_LEDGER.json','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','CALLER_RETRY_BINDING.md','FAILED_ROUTES.md','NEXT_INTERFACE.md',
 'artifacts/bounds.json','artifacts/transfer_certificate.json','artifacts/scalar_contract.json','artifacts/formal_audit.json','artifacts/source_binding.json','artifacts/source_checks.json','artifacts/controls_normal.json','artifacts/controls_san.json','artifacts/scalar_normal.json','artifacts/scalar_san.json','artifacts/mutations.json']
deps=['TARGETS/INITIAL_TARGET_CERTIFICATE.json','NORMALIZED/NORMALIZED_EXPANSION_CERTIFICATE.json','ZERO/ANALYTIC_PROOF.md','ZERO/REPORT.md','TOWER/TOWER_CERTIFICATE.json','TOWER/INDUCTION.md','NODE3/ANALYTIC_PROOF.md','ROOT/ANALYTIC_PROOF.md','FLOOR/REPORT.md','legacy/T5/GLOBAL_LEAF_A2_BRIDGE.md']
out=dict(schema='FT1536_ORDERED_REACH_CERTIFICATE_V1',status='PARTIAL_PROOF',author='Niirmata',source_pin=sha(I/'CANDIDATE.sha256'),base_commit='99ceb981cb0ef76e9e72b59ce325485b1908412f',
 required_entry='Legal emitted/same-STATIC-decode normalized key, all canonical challenges, actual root entry from TARGETS with source initial faultNONE and legal PRNG/context byte-read interface',
 required_cut='sampler_large source2864, before floor/long-to-int/residual',ordered_root_reach_proved=False,all_reached_mu_numeric=False,mu_domain_before_floor_proved=False,
 right_branch_mu_domain_proved=True,right_branch_scope='First root right/t1 physical branch1, all finite active source histories before entry into root left branch',
 right_active_call_positions=1536,right_abs_mu_bound=156276714,source_numeric_center_margin=ledger['proved_margin'],global_source_numeric_center_margin=None,
 scalar_return_interface_proved=True,scalar_return_scope='Conditional on independently established current NumericCenter, normalized width class and legal byte reads; includes support, integer/BerExp arithmetic, not accuracy/law/termination',
 scalar_internal_definedness_scope='Each consumed finite scalar iteration after those premises; not safety of initial mu inferred from guard or full sampler termination',
 intercall_primitive_domains_proved=False,right_branch_intercall_domains_proved=True,terminal_split1_merge1_source_contracts_proved=True,
 fault_handling_scope='Sticky fault excludes later active floors; fault0 carries no residual-closeness. Faulted-tail arithmetic/postprocessing not proved globally; injections only abstract test outcomes',
 fault_unreachable_for_certified_entries=False,caller_entry_binding_proved=True,retry_frame_scope='Conditional defined legal caller prefixes; reset source3357, no totality/propagation across unproved sampling/postprocessing',
 sampling_memory_frame_scope='Defined prefixes, live/disjoint buffers and context; high-water8702; immutable tree/root targets',
 normal_return_history_not_assumed_globally=True,rejection_stutter_has_no_caller_error=True,nonreturn_is_not_return_zero=True,
 first_open_type=b['weighted_candidate']['missing_type'],first_unclosed_source_transition='Root updated t0 at1818-1820 -> second SplitTop1828/left sampling1829-1830 -> subsequent active center',
 strongest_closed_root_updated_target_bound=b['full_root_loose_route']['root_updated_target_cap'],failed_candidate_global_mu_majorant=b['full_root_loose_route']['full_mu_majorant'],
 weighted_candidate_is_not_source_theorem=True,required_domain_counterexample=False,P_key_strengthened=False,probabilistic_exception_added=False,
 proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PARTIAL_PROOF',fully_kernelized=False,C_compiler_verified=False,kernel_modules=a['modules'],kernel_theorems=a['checked_theorems'],new_kernel_theorems=a['new_theorems'],
 H3_range_proved=False,old_CenterClass_reach_proved=False,global_reachability_proved=False,whole_sampler_termination_proved=False,whole_Sign_termination_proved=False,postprocessing_precast_safety_proved=False,
 sampler_law_proved=False,security_reduction_proved=False,full_sign_ct_proved=False,source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False,
 proof_evidence={p:sha(W/p) for p in docs},upstream_dependencies={p:sha(I/p) for p in deps})
(W/'ORDERED_REACH_CERTIFICATE.json').write_text(json.dumps(out,indent=2)+'\n')
rows=[dict(id=k,status='PROVED_SCOPED',evidence=v) for k,v in [('RIGHT_BRANCH_NUMERIC_CENTER','INVARIANT'),('SCALAR_CONDITIONAL_OUTCOMES','SCALAR_OUTCOMES'),('FAULT_STUTTER_DISPOSITION','FAULT_REJECTION'),('SIGNED_SPLIT1_MERGE1','transfer_certificate'),('CONDITIONAL_FRAME_CALLER','MEMORY_FRAME/CALLER_RETRY_BINDING')]]
rows += [dict(id=k,status='OPEN',evidence='FAILED_ROUTES/NEXT_INTERFACE') for k in ['LEFT_ROOT_CORRELATED_TRANSFER','RAW_L_STABLE_WEIGHT_METRIC_DEFECT','GLOBAL_NUMERIC_CENTER','FAULTED_TAIL_POSTPROCESSING_PRECAST','WHOLE_REJECTION_SIGN_TERMINATION','SAMPLER_LAW','SECURITY_REDUCTION','FULL_SIGN_CT']]
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(main_required_goal_closed=False,rows=rows),indent=2)+'\n');print(json.dumps({k:out[k] for k in ['status','ordered_root_reach_proved','right_branch_mu_domain_proved','right_abs_mu_bound','source_numeric_center_margin','first_open_type','kernel_modules','kernel_theorems']},indent=2))
