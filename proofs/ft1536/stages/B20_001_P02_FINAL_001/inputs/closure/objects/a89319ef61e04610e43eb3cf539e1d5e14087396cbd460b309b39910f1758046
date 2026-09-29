import json
from fractions import Fraction as Q
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap'
def read(p):return json.loads((W/p).read_text())
def dump(p,x):(W/p).write_text(json.dumps(x,indent=2)+'\n')
verify_manifest(I,'MANIFEST.sha256','90f866ed86bf3d8b95903a666338f7b659bbd4cf519f27abba2f63708fa11a87')
for h,n in (s.split('  ',1) for s in (I/'CANDIDATE.sha256').read_text().splitlines()):assert sha(W/'source'/n)==h
order=read('SOURCE_ORDER.json');joint=read('JOINT_COMPARISON.json');resource=read('RESOURCE_BOUND.json');support=read('SUPPORT_EXIT.json');audit=read('artifacts/formal_audit.json');fixtures=read('artifacts/fixtures.json');mut=read('artifacts/mutations.json');pt=read('artifacts/probability_trees.json');closure=read('artifacts/closure_instance.json')
assert order['root_call_count']==3072 and audit['all_final_logs_clean'] and audit['new_theorems']==37
a=read('artifacts/native_normal.json')['matches'];b=read('artifacts/native_sanitized.json')['matches'];assert a==b and len(a)==fixtures['native_batches']==9
assert fixtures['total_scalar_calls']==6148 and fixtures['total_proposals']==9376 and mut['detected']==12 and len(pt['cases'])==4
assert Q(support['exit_rational_upper'])<Q(1,2**50) and Q(joint['metrics'][0]['rational_upper'])<Q(1,2**48)
proofs={
 'root_source_closure_proved':'PREFIX_CLOSURE.md',
 'value_projection_frame_proved':'SOURCE_ORDER.md',
 'exact_joint_value_law_proved':'JOINT_LAW.md',
 'exact_joint_NY_law_proved':'JOINT_LAW.md',
 'exact_resource_and_revealed_byte_law_proved':'JOINT_LAW.md',
 'stopped_root_fresh_tail_proved':'JOINT_LAW.md',
 'root_a_s_return_IID':'JOINT_LAW.md',
 'resource_bound_proved':'RESOURCE_BOUND.md',
 'reference_processes_defined':'REFERENCE_PROCESSES.md',
 'support_exit_bound_proved':'SUPPORT_EXIT.md',
 'adaptive_directed_comparison_proved':'JOINT_COMPARISON.md',
 'common_conditional_lift_proved':'REFERENCE_PROCESSES.md',
 'POST_pushforward_proved':'POSTPROCESSING_PUSHFORWARD.md',
 'H6P_event_transfer_proved':'H6P_INTERFACE.md'}
flags={k:True for k in proofs};flags['full_ordered_joint_law_proved']=True
for k in ['real_prng_to_iid_bridge_proved','joint_BadPrecast_bound_proved','Safe16_proved','reference_integer_recovery_proved','Sign_to_Verify_proved','full_Sign_CT_proved','whole_real_Sign_termination_proved','security_reduction_proved','global_lattice_Gaussian_law_proved','retry_composition_proved','fully_kernelized','C_compiler_verified','source_changed','production_source_changed','new_source_patch_integrated','owner_accepted','required_domain_counterexample']:flags[k]=False
obl=[dict(id=k,status='PROVED_FOR_ONE_ROOT_IID_BUFFER',proof=p,proof_sha256=sha(W/p)) for k,p in proofs.items()]
obl +=[dict(id=k,status='OPEN_OR_OUT_OF_SCOPE') for k in flags if not flags[k] and k not in ['source_changed','production_source_changed','new_source_patch_integrated','owner_accepted','fully_kernelized','C_compiler_verified','required_domain_counterexample']]
dump('OBLIGATIONS.json',dict(schema='ORDERED_JOINT_OBLIGATIONS_V1',game='IID_BUFFER',scope='one required root invocation',obligations=obl,missing_required_task_obligations=[],no_eta_pre_assigned=True,POST_historical_status='PARTIAL_PROOF',ORDERED_historical_status='PARTIAL_PROOF_UNCHANGED'))
ledger=dict(schema='ORDERED_JOINT_ERROR_LEDGER_V1',game='IID_BUFFER',source_numerical_premises=closure,epsilon=joint['epsilon'],kappa=joint['kappa'],tau=support['tau'],M=3072,metric_exports=joint['metrics'],exact_Delta_expression='(1+2^-60)^3072-1',Delta_rational_upper=joint['metrics'][0]['rational_upper'],TV_export='2^-25',exit_upper=support['exit_rational_upper'],exit_power2='2^-50',reference_q_for_BadPrecast=None,BadPrecast_transfer='p<=min(1,q+min(2^-25,sqrt(Delta*q*(1-q))))',real_PRNG_loss=None,new_M0_epsilon=None,support_tail_counted_once=True,resources=resource['ghost_budget'],resource_tail='2^-1024',dependencies={p:sha(W/p) for p in ['SOURCE_ORDER.json','JOINT_COMPARISON.json','SUPPORT_EXIT.json','RESOURCE_BOUND.json','artifacts/closure_instance.json']})
dump('ERROR_LEDGER.json',ledger)
(W/'ERROR_LEDGER.md').write_text('''# Ledger — one root IID_BUFFER

| Etap / miara | Actual source instance / wynik |
|---|---|
|Source count / domain|M3072; current mu right≤156276714,left≤937866518; terminal DQ_A2≤849346588|
|Scalar acceptance|A_h≥1/8 (GAUSS); historyczne IID1/256 bez zmian|
|Scalar TV / forward chi2|epsilon2^-36,kappa2^-60,ta sama legalnaPAST i prefix words|
|Exact support-tail|tau z SUPPORT_EXIT.json; table tails,holes,cutoff ujęte raz|
|Local conditioning|(1+chi2(K||G_S))=(1-t)(1+chi2(K||G))|
|Joint forward chi2|(1+2^-60)^3072−1≤3/(2^50−3)<2^-48|
|Joint TV do Q_S/Q_stop|≤2^-25; alternatywa sequential3/2^26 luźniejsza|
|Q_S versus Q_stop|TV=Q_stop(EXIT)≤3072tau<2^-50,osobny export|
|Reverse Q_stop → P|∞ przez positive EXIT|
|Reverse Q_S → P|≤2^811008−1,wyprowadzony ale bardzo luźny|
|POST / common lift|data processing / exact preservation odpowiednio|
|BadPrecast|q pozostaje OPEN; p≤q+min(TV,sqrt(Delta*q*(1-q)))|
|Resources|E[T]≤24576;ghostT≤49152 z complement<2^-1024|
|Real PRNG / whole Sign|OPEN; żadnego computational lossu nie dopisano|

Pełne exact rationals,definitions,directions,scope i dependency hashes w JSON.
Nie dodajemy EXIT drugi raz do forward chi2/TV,nie stosujemy independent marginals,
nie podstawiamy nieudowodnionego Gaussian q i nie wpisujemy eta_pre do M0.
''')
docs=['CLAIM.md','SOURCE_ORDER.md','PREFIX_CLOSURE.md','JOINT_LAW.md','RESOURCE_BOUND.md','REFERENCE_PROCESSES.md','SUPPORT_EXIT.md','JOINT_COMPARISON.md','POSTPROCESSING_PUSHFORWARD.md','H6P_INTERFACE.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','ERROR_LEDGER.md','COUNTERMODELS.md','FAILED_ROUTES.md','NEXT_INTERFACE.md','REUSED_RESULTS.md']
evidence=['SOURCE_ORDER.json','JOINT_COMPARISON.json','SUPPORT_EXIT.json','RESOURCE_BOUND.json','ERROR_LEDGER.json','OBLIGATIONS.json','artifacts/source_binding.json','artifacts/closure_instance.json','artifacts/formal_audit.json','artifacts/fixtures.json','artifacts/projection_control.json','artifacts/native_normal.json','artifacts/native_sanitized.json','artifacts/probability_trees.json','artifacts/mutations.json']
cert=dict(schema='FT1536_ORDERED_JOINT_CERTIFICATE_V1',status='H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL',author='Niirmata',source_attribution='Falcon Project / Thomas Pornin; license preserved',task_date='2026-09-21',completion_date='2026-09-22',game='IID_BUFFER',scope='one required emitted/canonical root invocation, conditional on legal entry PAST; not whole Sign',base_commit='64af4cbd4280f45f28f8f160b7ebdacebdf29734',task_pin=sha(W/'TASK.md'),bootstrap_pin=sha(I/'MANIFEST.sha256'),source_pin=sha(I/'CANDIDATE.sha256'),**flags,flags=flags,root_call_count=3072,entry_definition=closure['required_domain'],source_closure=closure['closure_proof'],exact_joint_value_law='prod_i K_(entry,y_<i)(y_i), zero at first unsupported atom without evaluating later C',exact_joint_NY_law='prod_i (1-A_h_i)^(n_i-1) w_h_i(y_i)',revealed_byte_scope='each compatible complete raw getter transcript of T proposals has probability2^(-264T); dropped/unread cells marginalized; positions/resources deterministic given entryptr,N',resource_scope=resource,reference_processes=dict(Q_S='local G_h conditioned on exact positive K support S_h',Q_stop='untruncated G_h; first unsupported mathematical y returns EXIT before any C conversion/update',ideal_global_lattice_Gaussian=False,QS_equals_whole_survival_conditioning=False),support_exit_bound=support,metrics=joint['metrics'],reference_resource_lift='H_y=P_SOURCE(Z|Y=y), same kernel on both sides, singleton NoSourceResource on EXIT; exact TV/forwardchi2 preservation on (Y,Z); ghost, not Gaussian implementation or real seeded transcript',postprocessing='literal source POST pushforward incl both pre-narrow vectors,storednorm,conditionalSTATICmap; EXIT retained; POST historical PARTIAL_PROOF',H6P_event_transfer='for q=Q(BadPrecast on BOTH pre-narrow vectors, live paths), p<=min(1,q+min(2^-25,sqrt(Delta*q*(1-q)))); q unproved; WholeCallBad conditional interface only',proof_kind=audit['proof_kind'],mixed_boundary=audit['boundary'],checks=dict(kernel_modules=audit['modules'],checked_theorems=audit['checked_theorems'],new_theorems=audit['new_theorems'],inherited_modules=audit['inherited_modules_unchanged'],native_batches_each=9,scalar_calls=6148,proposals=9376,cutoff_rejections=fixtures['cutoff_rejections'],getter_start_ptrs=4096,final_u8_case=True,full_root_tapes=2,terminal_zero_cases=2,POST_suffix_codec_cases=4,normal_and_ASan_UBSan=True,LSan=False,adaptive_QQ_trees=4,mutations_detected=12,noop=1),countermodels=dict(local_vs_whole_conditioning='abstract QQ two-step countermodel TV1/10, not Emitted source witness',support_window='local D_env positive proposal but forced cutoff, no Emitted membership',value_resources='synthetic native equal value traces with differing N and ptr'),all_jobs_bounded_single_worker=True,proof_documents={p:sha(W/p) for p in docs},evidence={p:sha(W/p) for p in evidence},sample_maxima_used_as_uniform_proof=False)
dump('ORDERED_JOINT_CERTIFICATE.json',cert);print(json.dumps(dict(status=cert['status'],game=cert['game'],root_calls=3072,TV='2^-25',forward_chi2='2^-48',EXIT='2^-50',kernel_modules=audit['modules'],theorems=audit['checked_theorems']),indent=2))
