import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();numeric=json.loads((W/'artifacts/numeric_certificate.json').read_text());audit=json.loads((W/'artifacts/formal_audit.json').read_text())
assert numeric['status']=='PASS_UNIFORM_C3_COMPOSITION' and audit['all_final_logs_clean']
assert json.loads((W/'artifacts/controls_normal.json').read_text())==json.loads((W/'artifacts/controls_san.json').read_text())
status='H3_NODE3_PROVED_FOR_PINNED_MODEL'
flags=dict(H3_range_proved=False,global_reachability_proved=False,full_internal_tree_proved=False,sampler_law_proved=False,security_reduction_proved=False,
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False)
spec=[
 ('ROOT_CONSUMPTION','PROVED_REUSED_WITH_PREMISES_DISCHARGED','Unchanged P_key; ROOT correlated spectrum/Gram envelope and chronological g00 facts.', ['ROOT_CONSUMPTION.md','inputs/bootstrap/ROOT/ROOT_CERTIFICATE.json']),
 ('SPLIT_TOP_MAP','PROVED_ANALYTIC_WITH_EXACT_IDENTITIES','All256 positions; x,x omega,x omega² -> x³, child real j/imag j+256; phased unitary Hermitian Gram.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json','formal/NodeInverse.lean']),
 ('SPLIT_TOP_ERROR','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Source six kappa multiplications, not ideal1/3; errors1/8192 and1/16.', ['ANALYTIC_PROOF.md','formal/NodeInverse.lean','artifacts/numeric_certificate.json']),
 ('ADJ_AND_IMAGINARY','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_DATAFLOW','Adj sign flip preserved; diagonal-only projection is a proof object, actual imaginary words remain.', ['ANALYTIC_PROOF.md','formal/NodeDataflow.lean','artifacts/controls_normal.json']),
 ('FIRST_DIVISOR','PROVED_SOURCE_ANALYTIC','Hermitian comparison eigen lower1/4 or16 gives first real t0 domain before division.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json']),
 ('NODE3_D11','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Positive real d11 lower1/8 or8, normal and bounded, established before final L21 division.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json','formal/NodeConstants.lean']),
 ('NODE3_L10_L20_L21','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Actual per-component divisions/order; norms<2,<2,<4, explicit errors to exact reference and H.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json']),
 ('NODE3_D22','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Actual subtractive d22 with real-slot tmp*d11; positive lower1/8 or8, imaginary/error bounds separate.', ['ANALYTIC_PROOF.md','formal/NodeDataflow.lean','artifacts/numeric_certificate.json']),
 ('PRIMITIVE_DOMAINS','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_INTEGER_LEMMAS','New div[1/16,2^35], operands<=2^100, exp0/underflow/pack and inverse3 accounted; no complete IEEE assumption.', ['ANALYTIC_PROOF.md','formal/NodeInverse.lean','artifacts/model_values.json']),
 ('NODE3_FRAME','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_FRAME','All source repeated const aliases, branch1 storage reuse and defined-prefix binding; no lower-tree totality claim.', ['NODE3_FRAME.md','formal/NodeFrame.lean','artifacts/controls_normal.json']),
 ('LOWER_TREE_OPEN','OPEN','split_deep/inner positive pivots, imaginary propagation and all lower levels.', ['NEXT_INTERFACE.md']),
 ('INITIAL_TARGETS_OPEN','OPEN','Independent source FFT(c)/basis products/inverse(q) initialization.', ['NEXT_INTERFACE.md','inputs/bootstrap/H3/REACHABILITY.md']),
 ('ORDERED_REACH_OPEN','OPEN','Full emitted/M0 prefix -> NumericCenter before ZERO residual use, including pre-dss/norm rejection/fault handling.', ['NEXT_INTERFACE.md','inputs/bootstrap/M0/H3_INTERFACE.md'])]
rows=[dict(id=id,status=s,claim=claim,evidence=[dict(path=r,sha256=sha(W/r)) for r in files]) for id,s,claim,files in spec]
layer='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF'
out=dict(schema='H3_NODE3_BOUND_LEDGER_V1',status=status,rows=rows,constants=numeric['constants'],proof_kind=layer,full_node3_theorem_kernelized=False,**flags)
node=dict(schema='H3_NODE3_CERTIFICATE_V1',status=status,uniform_record='One fixed c3 with two branch records, independent of p and j.',
 required_domain='For all Key4 p with the exact ROOT P_key, both b in Fin2 and every j in Fin256; inherited Emitted_C same-STATIC-decode binding.',
 unresolved_numerical_premises=[],api_model_premises=['GCC14.2/C99/Linux x86_64 LP64 portable FPEMU with pinned Makefile flags','legal sizes/lifetimes; outputs and scratch disjoint from const inputs; repeated const aliases allowed'],
 source_slice='SplitTop_C(v,10); Adj(t1/t2,9,0); LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0)',
 constants=numeric['constants'],inverse3=numeric['inverse3'],split_map=numeric['split_map'],primitive=numeric['primitive'],
 stronger_comparison=dict(H='Hermitian h=Re(t0), lower u1,u2,u1; proof object, not changed C',eigen_lower=['1/4','16'],
  symmetry='||u1|-|u2||<=2s; |q2-d|<=4s',source_errors='real d11 error<=64U*h; real d22<=65536U*h; L21 error<=1024U*h/d',
  imag='tau=Im(t0), |tau|<=h; pivot imaginary parts close to tau; tmp imaginary raw+0'),
 proof_kind=layer,full_node3_theorem_kernelized=False,C_compiler_kernel_refinement=False,
 evidence=[dict(path=r,sha256=sha(W/r)) for r in ['ANALYTIC_PROOF.md','ROOT_CONSUMPTION.md','NODE3_FRAME.md','artifacts/numeric_certificate.json','artifacts/formal_audit.json']],**flags)
ob=dict(schema='H3_NODE3_OBLIGATIONS_V1',local_status=status,local_node3_open=[],obligations=rows[10:]+[dict(id='SAMPLER_LAW_OPEN',status='OPEN',claim='Independent distribution/acceptance/hybrid interface; no automatic loss or abort.')],
 optional_kernelization='Full universal source spectral/error composition is proved analytically, not a completed kernel C theorem.',next_lemma_document='NEXT_INTERFACE.md',**flags)
for name,data in [('BOUND_LEDGER.json',out),('NODE3_CERTIFICATE.json',node),('OBLIGATIONS.json',ob)]:
 (W/name).write_text(json.dumps(data,indent=2)+'\n')
lines=['# H3_NODE3 — bound ledger','',status,'','| ID | Status | Claim |','|---|---|---|']
lines+=['| '+r['id']+' | '+r['status']+' | '+r['claim']+' |' for r in rows]
lines+=['','Pełne c3/evidence/piny: JSON. Mixed analytic/kernel; full_node3_theorem_kernelized=false.','Lower tree, targets, global Reach i sampler law pozostają otwarte.']
(W/'BOUND_LEDGER.md').write_text('\n'.join(lines)+'\n');print(json.dumps(dict(status=status,rows=len(rows),branches=len(numeric['constants']),**flags),indent=2))
