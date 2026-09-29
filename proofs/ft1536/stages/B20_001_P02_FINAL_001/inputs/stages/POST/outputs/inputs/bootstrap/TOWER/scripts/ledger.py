import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();num=json.loads((W/'artifacts/numeric_certificate.json').read_text());audit=json.loads((W/'artifacts/formal_audit.json').read_text())
assert num['status']=='PASS_INIT_AND_ALL_LEVELS' and audit['all_final_logs_clean']
assert json.loads((W/'artifacts/controls_normal.json').read_text())==json.loads((W/'artifacts/controls_san.json').read_text())
status='H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL'
flags=dict(binary_tower_proved=True,remaining_binary_subtrees_proved=True,source_inner7_totality_proved=True,levels_proved=[7,6,5,4,3,2,1],full_binary_tower_theorem_kernelized=False,
 H3_range_proved=False,global_reachability_proved=False,full_internal_tree_proved=False,sampler_law_proved=False,security_reduction_proved=False,
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False)
spec=[
 ('INIT_REFINEMENT','PROVED_ANALYTIC_WITH_EXACT_CERTIFICATE','New stronger NODE3/S8 bases from actual real root spectrum and prior pointwise errors; old c2 not iterated.', ['INDUCTION.md','artifacts/numeric_certificate.json']),
 ('LEVEL7','PROVED_UNIFORM_LOCAL','Exact NODE2 NEXT_INTERFACE, all12 entries and768 positions.', ['LEVEL7.md','artifacts/numeric_certificate.json']),
 ('STEP_DOMAIN','PROVED_SOURCE_ANALYTIC','Finite capped source ops, half classes, positive div[1/16,2^35] established before each use.', ['INDUCTION.md','inputs/bootstrap/NODE2/ANALYTIC_PROOF.md']),
 ('REAL_IMAG_INVARIANT','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_ALGEBRA','Separate children; real loss I²/m with imaginary difference retained, bounded mean imaginary and rounding.', ['INDUCTION.md','formal/TowerMargin.lean']),
 ('LEVELS_7_TO_1','PROVED_UNIFORM_ALL_PATHS','1524 nodes,768 positions each level, exact outward grid2^-40 records and positive lowers.', ['INDUCTION.md','artifacts/numeric_certificate.json','formal/TowerShape.lean']),
 ('EXACT_REFERENCE','PROVED_ANALYTIC','Independent exact references from NODE2; propagated errors and reference max bound; not source H.', ['INDUCTION.md','artifacts/oracle.json']),
 ('BASE_INNER1','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_STRUCTURE','Actual dim2, two L words and two raw real leaf stores, return4; no inner0/SplitDeep1.', ['INDUCTION.md','formal/TowerOrder.lean','artifacts/controls_normal.json']),
 ('ACTUAL_RECURSION','PROVED_SOURCE_INDUCTION_MIXED','12 original inner7 subtrees terminate with defined instructions, numeric domains and matching source-order tree.', ['INDUCTION.md','formal/TowerExecution.lean','artifacts/controls_normal.json']),
 ('LAYOUT_FRAME','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_STRUCTURE','Inputs preserved; size(k+1)2^k, scratch<=2*2^k,1024/256 per subtree;10752 L and1536 leaves.', ['INDUCTION.md','ASSEMBLY_INTERFACE.md','formal/TowerShape.lean','formal/TowerOrder.lean']),
 ('ASSEMBLY_OPEN','OPEN','Full root/cubic/level8/remaining raw-loader prefix assembly is a separate theorem.', ['ASSEMBLY_INTERFACE.md','NEXT_INTERFACE.md']),
 ('NORMALIZATION_OPEN','OPEN','Stable rebuild and normalized widths, sqrt/inverse/domains/gates remain separate.', ['NEXT_INTERFACE.md']),
 ('INITIAL_TARGETS_OPEN','OPEN','Source target FFT/basis/inverse(q) initialization.', ['NEXT_INTERFACE.md']),
 ('ORDERED_REACH_OPEN','OPEN','Full M0 prefix -> NumericCenter before ZERO; pre-dss/norm rejection and fault paths.', ['NEXT_INTERFACE.md']),
 ('SAMPLER_LAW_OPEN','OPEN','Source distribution/acceptance/hybrids, no automatic global loss/abort.', ['NEXT_INTERFACE.md'])]
rows=[dict(id=i,status=s,claim=c,evidence=[dict(path=r,sha256=sha(W/r)) for r in fs]) for i,s,c,fs in spec]
layer='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF'
ledger=dict(schema='BINARY_TOWER_BOUND_LEDGER_V1',status=status,rows=rows,uniform_summaries=num['uniform_summaries'],proof_kind=layer,**flags)
tower=dict(schema='FT1536_BINARY_TOWER_CERTIFICATE_V1',status=status,required_domain='All unchanged P_key and inherited emitted/same-STATIC-decode domain; all levels7..1/paths/slots and12 inner7 entries.',
 unresolved_numerical_premises=[],api_model_premises=['Pinned C99/GCC14.2/LP64 portable FPEMU and Makefile flags','Legal aligned buffers/lifetimes; tree/scratch disjoint from inputs; repeated const g00=g11 alias'],
 constants_file='artifacts/numeric_certificate.json',constants_sha256=sha(W/'artifacts/numeric_certificate.json'),uniform_summaries=num['uniform_summaries'],coverage=num['coverage'],
 source_execution='First child from existing g00; frame; local LDL; second child from computed d11; base real stores. Actual terminating recursion, not only isolated slices.',
 proof_kind=layer,C_compiler_kernel_refinement=False,
 evidence=[dict(path=r,sha256=sha(W/r)) for r in ['INDUCTION.md','LEVEL7.md','ASSEMBLY_INTERFACE.md','artifacts/numeric_certificate.json','artifacts/formal_audit.json']],**flags)
ob=dict(schema='BINARY_TOWER_OBLIGATIONS_V1',local_status=status,layers_A_B_open=[],proved_levels=flags['levels_proved'],open_levels=[],obligations=rows[9:],
 optional_kernelization='Full source numeric/memory instantiation currently analytical; abstract execution theorem has explicit discharged premises.',next_lemma_document='NEXT_INTERFACE.md',**flags)
for name,data in [('BOUND_LEDGER.json',ledger),('TOWER_CERTIFICATE.json',tower),('OBLIGATIONS.json',ob)]:
 (W/name).write_text(json.dumps(data,indent=2)+'\n')
lines=['# BINARY_TOWER — bound ledger','',status,'','| ID | Status | Claim |','|---|---|---|']
lines+=['| '+r['id']+' | '+r['status']+' | '+r['claim']+' |' for r in rows]
lines+=['','A+B proved in mixed scope; kernelization false. Assembly/normalize/targets/Reach/law remain open.']
(W/'BOUND_LEDGER.md').write_text('\n'.join(lines)+'\n');print(json.dumps(dict(status=status,rows=len(rows),**flags),indent=2))
