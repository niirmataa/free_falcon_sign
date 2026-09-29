import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap'
def load(p):return json.loads((W/p).read_text())
c=load('artifacts/composition_certificate.json');a=load('artifacts/formal_audit.json');tr=load('artifacts/source_transport.json');mu=load('artifacts/mutations.json')
assert c['unresolved_numerical_premises']==[] and c['tower_numeric_recomputed_byte_identical'] and tr['floor_unreachable_in_both']
assert a['all_final_logs_clean'] and a['new_theorems']==33 and a['checked_theorems']==180
for mode in ['normal','san']:assert load('artifacts/controls_'+mode+'.json')['all_18432_tree_and_6144_basis_words_match']
assert mu['status']=='PASS_EXECUTED_MODEL_MUTATIONS_AND_INVALID_PREFLIGHT'
proofs=['COMPOSITION.md','MEMORY_LAYOUT.md','SOURCE_TRANSPORT.md','SOURCE_MODEL_BINDING.md','NEXT_INTERFACE.md','artifacts/composition_certificate.json','artifacts/formal_audit.json','artifacts/source_transport.json','artifacts/controls_normal.json','artifacts/controls_san.json','artifacts/mutations.json']
deps=['ROOT/ROOT_CERTIFICATE.json','ROOT/ANALYTIC_PROOF.md','ROOT/EMITTED_BINDING.md','NODE3/NODE3_CERTIFICATE.json','NODE2/NODE2_CERTIFICATE.json','NODE2/UPSTREAM_REFINEMENT.md','TOWER/TOWER_CERTIFICATE.json','TOWER/INDUCTION.md','TOWER/ASSEMBLY_INTERFACE.md','TOWER/artifacts/numeric_certificate.json','FLOOR/REPORT.md','FLOOR/PATCH.diff']
out=dict(schema='FT1536_RAW_PREFIX_CERTIFICATE_V1',status='H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL',author='Niirmata',
 source_manifest_sha256=sha(I/'CANDIDATE.sha256'),base_commit='6ed89cac3249bdfe6d874c6616fd2899f4b3ef6a',
 domain='All unchanged P_key(p) with LegalRawExpansionBuffers(memory,p); emitted/same-STATIC-decode corollary',
 conclusion='Actual defined terminating load_skey raw prefix through return of ffLDL_fft3 at source1253; exact source basis/tree snapshots, physical layout/order/frame',
 raw_loader_prefix_proved=True,raw_tree_assembly_proved=True,raw_prefix_totality_proved=True,emitted_corollary_proved=True,source_transport_proved=True,
 basis_words=6144,raw_tree_words=18432,internal_words=16896,leaf_words=1536,sk_words=24576,tmp_words=10752,tmp_high_water=8192,
 internal_word_class='finite source L components',leaf_word_class='positive finite source subtractive raw real pivots, not normalized widths',
 source_order='branch0 including all children; root LDL; read root D; branch1 including all children. Every inner8 first child precedes local LDL.',
 basis_matching='SourceFFT_B_CANDIDATE(p) in order g,-f,G,-F',tree_matching='RootSlice L plus two cubic branches, each three inner8 with two actual inner7; source read-time snapshots',
 leaf_map=dict(path='LEAF_MAP.json',sha256=sha(W/'LEAF_MAP.json'),universal_word_sequence='Map ordered positions to literal base g00[0]/d11[0] at their actual read/store moments'),
 memory_frame='Basis and root Gram preserved during tree builder; coefficients and memory outside raw write footprints preserved; root/lower D storage may be reused only after its consumed split read',
 proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',raw_prefix_fully_kernelized=False,C_compiler_verified=False,
 numerical_instantiation='COMPOSITION sections2-7 closes every LocalDomains field on actual source words; freshly recomputed S8/inner7 records with earlier ROOT/NODE3/NODE2 certificates',
 unresolved_numerical_or_totality_premises=[],P_key_strengthened=False,completed_prefix_assumed=False,
 normalized_expansion_proved=False,full_private_loader_proved=False,H3_range_proved=False,global_reachability_proved=False,sampler_law_proved=False,security_reduction_proved=False,full_sign_ct_proved=False,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False,
 proof_evidence={p:sha(W/p) for p in proofs},upstream_dependencies={p:sha(I/p) for p in deps})
(W/'RAW_PREFIX_CERTIFICATE.json').write_text(json.dumps(out,indent=2)+'\n')
obligations=[]
for key,evidence in [('RAW_BASIS_GRAM','COMPOSITION sections2-3'),('RAW_BRANCH0','COMPOSITION sections4-6'),('ACTUAL_INNER8_TOTALITY','COMPOSITION section5'),('ROOT_AFTER_BRANCH0','COMPOSITION section6'),('D_SNAPSHOT_AND_BRANCH1','COMPOSITION section7'),('RAW_LAYOUT_MATCHING_FRAME','MEMORY_LAYOUT; RawLayout/RawMatching'),('EMITTED_COROLLARY','COMPOSITION section8; ROOT EMITTED_BINDING'),('SOURCE_TRANSPORT','SOURCE_TRANSPORT')]:
 obligations.append(dict(id=key,status='PROVED_FOR_PINNED_MODEL',evidence=evidence,kind=out['proof_kind']))
for key in ['STABLE_REBUILD_AND_NORMALIZATION','FULL_PRIVATE_LOADER','INITIAL_TARGETS','ORDERED_REACH_TO_NUMERIC_CENTER','SAMPLER_LAW','SECURITY_REDUCTION','FULL_SIGN_CT']:
 obligations.append(dict(id=key,status='OPEN_SEPARATE_STAGE',evidence='NEXT_INTERFACE.md'))
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(required_raw_obligations_closed=True,rows=obligations),indent=2)+'\n')
print(json.dumps({k:out[k] for k in ['status','raw_prefix_totality_proved','raw_tree_assembly_proved','emitted_corollary_proved','internal_words','leaf_words','proof_kind','raw_prefix_fully_kernelized']},indent=2))
