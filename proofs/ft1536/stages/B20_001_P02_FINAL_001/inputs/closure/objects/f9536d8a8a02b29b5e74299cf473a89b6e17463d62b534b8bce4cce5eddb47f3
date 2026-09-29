import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();num=json.loads((W/'artifacts/numeric_certificate.json').read_text());audit=json.loads((W/'artifacts/formal_audit.json').read_text())
assert num['status']=='PASS_UNIFORM_FIRST_BINARY_COMPOSITION' and audit['all_final_logs_clean']
assert json.loads((W/'artifacts/controls_normal.json').read_text())==json.loads((W/'artifacts/controls_san.json').read_text())
status='H3_NODE2_PROVED_FOR_PINNED_MODEL';flags=dict(H3_range_proved=False,global_reachability_proved=False,full_internal_tree_proved=False,sampler_law_proved=False,security_reduction_proved=False,
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False)
spec=[
 ('NODE3_CONSUMPTION','PROVED_REUSE_WITH_DOMAINS','Unchanged P_key, NODE3 source/reference and tau bounds with pins; no old box substituted for full record.', ['REUSED_RESULTS.md','inputs/bootstrap/NODE3/NODE3_CERTIFICATE.json']),
 ('UPSTREAM_REFINEMENT','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','New root imag<8U*j<1 and NODE3 imaginary vector refinement, without changing old certificates.', ['UPSTREAM_REFINEMENT.md','artifacts/numeric_certificate.json']),
 ('SPLIT_DEEP_MAP','PROVED_ANALYTIC_WITH_KERNEL_INDEX_AND_EXACT_AUDIT','All128 pairs x,-x -> x², actual square256+f, half scaling, Adj.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json','formal/BinaryMargin.lean']),
 ('HALF_DOMAIN_ERROR','PROVED_KERNEL_WITH_SOURCE_TRANSLATION','All finite words: error<=2^-1023; zeros/exp0, exponent1 subnormal, exponent>=2 exact; raw bits separate.', ['formal/Half.lean','scripts/half_model.py','artifacts/model_values.json']),
 ('SPLIT_DEEP_ERROR','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Actual add/half and sub/mul/half; delta1/16384 or1/32 including half boundaries.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json']),
 ('PAIRED_REAL_IMAG_MARGIN','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_IDENTITY','ra*rb-(tau_a-tau_b)²/4 retained; refined bounds give H eigen lower1/16 or4.', ['UPSTREAM_REFINEMENT.md','ANALYTIC_PROOF.md','formal/BinaryMargin.lean']),
 ('FIRST_DIVISOR','PROVED_SOURCE_ANALYTIC','Source real s0 in proved existing div[1/16,2^35], before division; no future pivot premise.', ['ANALYTIC_PROOF.md','formal/BinaryConstants.lean']),
 ('NODE2_MULTIPLIER','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Direct real-slot divisions; norm L<2 and explicit reference errors.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json']),
 ('NODE2_SCHUR','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Actual subtractive sequence; real d11 lower1/32 or2, finite normal, explicit complex errors.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json']),
 ('IMAGINARY_PROPAGATION','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_HALF','Imag s0 may be subnormal; generic add bound, no unproved raw sub(x,+0) preservation. Output imag<=1/8192 or9/8.', ['ANALYTIC_PROOF.md','formal/Half.lean','artifacts/controls_normal.json']),
 ('NODE2_FRAME','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_FRAME','NODE3 diagonal lifetimes, real source read order and defined-prefix input binding; no earlier-recursion totality.', ['NODE2_FRAME.md','formal/BinaryFrame.lean','artifacts/controls_normal.json']),
 ('LOWER_TREE_OPEN','OPEN','Level7 and all remaining lower nodes require separate domain/margin/frame composition.', ['NEXT_INTERFACE.md']),
 ('INITIAL_TARGETS_OPEN','OPEN','Separate FFT(c)/basis/inverse(q) source initialization.', ['NEXT_INTERFACE.md','inputs/bootstrap/H3/REACHABILITY.md']),
 ('ORDERED_REACH_OPEN','OPEN','Full emitted/M0 prefix -> NumericCenter before ZERO; includes pre-dss/norm rejected/fault branches.', ['NEXT_INTERFACE.md','inputs/bootstrap/M0/H3_INTERFACE.md'])]
rows=[dict(id=i,status=s,claim=c,evidence=[dict(path=r,sha256=sha(W/r)) for r in files]) for i,s,c,files in spec]
layer='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF'
out=dict(schema='H3_NODE2_BOUND_LEDGER_V1',status=status,level=num['level'],rows=rows,constants=num['constants'],proof_kind=layer,full_node2_theorem_kernelized=False,**flags)
cert=dict(schema='H3_NODE2_CERTIFICATE_V1',status=status,level=num['level'],uniform_record='One fixed c2, six (b,k) rational records, all128 frequencies per group.',
 required_domain='For every unchanged ROOT P_key p; inherited same-STATIC decode of Emitted_C.',unresolved_numerical_premises=[],
 api_model_premises=['Pinned GCC14.2/C99/LP64 portable FPEMU and Makefile flags','Legal sizes/lifetimes and disjoint outputs/scratch; repeated const s0 alias allowed'],
 source_slice='NODE3 select(t0,d11,d22); SplitDeep9; Adj8; source LDL_dim2(s0,u1,s0,8,0)',
 constants=num['constants'],half=num['half'],map=num['map'],upstream_refinement=num['upstream_refinement'],
 stronger_relation='Paired determinant includes imaginary difference; actual H eigen lower1/16 or4; real source d11 error<64U*h and imag error to split tau<64U*h.',
 coarse_box_countermodel=num['coarse_box_countermodel'],proof_kind=layer,full_node2_theorem_kernelized=False,C_compiler_kernel_refinement=False,
 evidence=[dict(path=r,sha256=sha(W/r)) for r in ['ANALYTIC_PROOF.md','UPSTREAM_REFINEMENT.md','NODE2_FRAME.md','artifacts/numeric_certificate.json','artifacts/formal_audit.json']],**flags)
ob=dict(schema='H3_NODE2_OBLIGATIONS_V1',local_status=status,local_level8_open=[],obligations=rows[11:]+[dict(id='SAMPLER_LAW_OPEN',status='OPEN',claim='Separate distribution/acceptance/hybrid interface.')],
 optional_kernelization='Universal source refinement and complex/matrix composition remain analytical, already proved in that layer.',next_lemma_document='NEXT_INTERFACE.md',**flags)
for name,data in [('BOUND_LEDGER.json',out),('NODE2_CERTIFICATE.json',cert),('OBLIGATIONS.json',ob)]:
 (W/name).write_text(json.dumps(data,indent=2)+'\n')
lines=['# H3_NODE2 — bound ledger','',status,'','| ID | Status | Claim |','|---|---|---|']
lines+=['| '+r['id']+' | '+r['status']+' | '+r['claim']+' |' for r in rows]
lines+=['','Full pins/constants: JSON. First split9/LDL8 only; full_node2_theorem_kernelized=false.','Coarse-box countermodel is not a P_key/emitted counterexample; current local goal is proved.']
(W/'BOUND_LEDGER.md').write_text('\n'.join(lines)+'\n');print(json.dumps(dict(status=status,rows=len(rows),groups=6,level=num['level'],**flags),indent=2))
