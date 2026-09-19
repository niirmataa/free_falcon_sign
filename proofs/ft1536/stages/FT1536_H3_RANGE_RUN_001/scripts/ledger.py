import hashlib,json
from pathlib import Path
W=Path.cwd()
def pin(p):return dict(path=p,sha256=hashlib.sha256((W/p).read_bytes()).hexdigest())
rows=[]
def row(i,claim,status,domain,evidence,need,error='none claimed'):
 rows.append(dict(id=i,claim=claim,status=status,domain=domain,evidence=[pin(p) for p in evidence],remaining_premise=need,error_model=error))
row('INPUT_IDENTITY','All52 bootstrap members/50 origins and17 sources match external pin.','VERIFIED','pinned bootstrap', ['artifacts/bootstrap_verified.json'],None)
row('EMITTED_KEY_BINDING','Success route requires both poly_big_to_small caps; |F_i|,|G_i|<=2047 on that path.','LOCAL_KERNEL_AND_SOURCE_ROUTE','actual successful KeyGen, not arbitrary loader keys',['formal/OrderedResidual.lean','inputs/slices/key_cap.txt','inputs/slices/key_solve_cap_return.txt','inputs/slices/key_emit_path.txt'],
 'Full emitted/encoding/loader semantic refinement retained as required-domain definition; no proof of ideal Babai quotient<=1/2.')
row('LOADER_TREE_BINDING','B00=g,B01=-f,B10=G,B11=-F FFT3; subtractive internal tree then1536 stored-width overwrites.','SOURCE_ORDER_BOUND','source loader success',['inputs/slices/loader_tree.txt','inputs/slices/leaf_normalize.txt','artifacts/order_normal.json'],
 'Uniform bounds on16896 internal words/divisors and relation to exact Gram. Synthetic tree values are not emitted-key evidence.')
row('FPR_DOMAIN','Positive/negative zero and exponent0 payloads need actual FPEMU semantics.','PARTIAL_WITH_NEW_EXTENDED_DIAGNOSTICS','all tested synthetic words; reachable class unresolved',['artifacts/fpr_analysis.json','formal/GuardPrefix.lean','formal/Floor.lean'],
 'Reach -> adequate normal/zero/subnormal/underflow class invariant, especially exclusion or explicit handling of negative-zero center.',
 'A universal u*abs(x)+2^-1075 bound is false for tested underflow; do not import it.')
row('FLOOR_REFINEMENT','Field-normalized source floor equals exact dyadic floor for exponent<=1053 excluding negativezero.','PROVED_LOCAL_MODEL_WITH_C_TRANSLATION','all sign/fraction values within explicit theorem premises',['formal/Floor.lean','artifacts/boundaries_normal.json'],
 'Reach -> CenterClass. Source bit-field reduction is documented separately; no complete C compiler theorem.',
 'Exact integer division; no FP rounding assumption used for floor.')
row('PROPOSAL_SUPPORT','All5 banks maximum29,59,118,235,365; first eligible selection; z in[-365,366].','PROVED_KERNEL_WITH_PINNED_C_BINDING','all128-bit uniform words, all boolean selector decisions',['formal/Comparator.lean','formal/Proposal.lean','formal/CDF.lean','artifacts/cdf_certificate.json','artifacts/boundaries_normal.json'],
 None,'Integer bit operations and exact threshold comparisons; no distribution claim.')
row('SOURCE_CALL_ORDER','Right-first source residual dataflow;3072 callbacks; first width index18431; paired then unscaled terminal sigma.','PROVED_LAYOUT_AND_CHECKED_EXECUTABLE_PROJECTION','source-shaped recursion and public artificial targets/trees',['formal/OrderedResidual.lean','scripts/order_model.py','artifacts/order_normal.json','artifacts/order_mutations.json'],
 'Whole Emitted/loader-to-projection proof is not kernelized; local controls do not establish required reachability.')
row('RESIDUAL_INDUCTION','Ordered terminal lemma derives next center only from prior residual and explicit errors.','PROVED_CONDITIONAL_NEW_INTERFACE','exact dyadics with common scaleD; active nonfault calls',['formal/OrderedResidual.lean'],
 'Base/recursive source certificates for center inputs and error terms at every inner/depth1/top node.',
 'Bounds retain E1,Ehalf,E2,E3/Eadd; never assign them a universal IEEE budget.')
row('ROOT_CENTER','Exact NTRU/Schur identities and coefficient-count bound2304 are verified; actual root center retains(r1-t1)*L.','EXACT_ALGEBRA_ONLY','nonzero exact g00,q and source coefficient caps',['artifacts/algebra.json'],
 'Computed target/tree/root residual and FFT coefficient error transfer. No actual root-center bound follows from this certificate.')
row('INTERNAL_CENTERS','Leaf-width premises alone do not control centers; real source local recursion gives next center12884901888 for artificial L=2^32.','OPEN_WITH_LOCAL_INSUFFICIENCY_WITNESS','synthetic tree, not Emitted, not loader output',['artifacts/leaf_gap_normal.json'],
 'Uniform source subtractive LDL internal multiplier/pivot certificate for emitted keys and machine error.',
 'Synthetic witness cannot be promoted to required-domain counterexample.')
row('MACHINE_ERROR_TRANSFER','Inspect FPR pack/add/mul/div/sqrt/half; exact dyadic oracle checks local normal endpoints and pathological classes.','OPEN_GLOBAL','backend-specific reachable operation classes',['artifacts/fpr_analysis.json','inputs/slices/FPR_pack.txt','inputs/slices/FPR_add.txt','inputs/slices/FPR_mul.txt','inputs/slices/FPR_div.txt','inputs/slices/FPR_sqrt.txt','inputs/slices/FPR_half_neg.txt'],
 'Prove domain and errors for all source operations; a blanket complete-IEEE model is unavailable.',
 'Mul treats all exponent0 operands as zero; div numerator exponent0 flushes sign to+0; sqrt assumes nonnegative and flushes exponent0; half edge cases do not implement gradual RN.')
row('H4_T5_CONSUMPTION','Stored widths, exact leaf theorem, paired scale and numerical internal tree are different interfaces.','SCOPED_REUSE_NO_PROMOTION','historical public projection has incomplete export by design',['inputs/bootstrap/legacy/H4/report.md','inputs/bootstrap/legacy/T5/THEOREM.md','inputs/bootstrap/legacy/T5/inputs/a1/NUMERICAL_SOUNDNESS.md','artifacts/fpr_analysis.json'],
 'Uniform FPEMU endpoint monotonicity/domain and internal-L transfer are not supplied by two endpoint checks or exact leaf>991.',
 'Stored width endpoints reproduced with actual FPEMU and independent exact RN; paired dss endpoints3f455555c49559f4..3fd203d2c1ca3682 are controls, not new global certificates.')
row('FAULT_PATHS','Sticky fault returns before floor; invalid mu/sigma rejected before floor, dss/gap/exponent only afterward.','PROVED_PREFIX_MODEL_AND_SOURCE_CONTROL','all prefix guards; synthetic sticky continuations',['formal/GuardPrefix.lean','inputs/slices/sampler_guards.txt','artifacts/order_normal.json','artifacts/probes_normal.json'],
 'Do not apply residual-closeness theorem after a fault; residual buffers continue through source recursion until generate sees fault.')
row('FINAL_REACHABILITY_LIFT','Required global Reach_call_C -> floor range + exact floor/cast + safe s+z.','OPEN','emitted-KeyGen support and all M0 reachable Sign prefixes',['REACHABILITY.md','formal/GuardPrefix.lean'],
 'forall Reach_call_C(...,mu,sigma), CenterClass(mu); must discharge internal bounds, zero-domain and machine errors. Local complete_local_lift is conditional, not a global H3 proof.')
out=dict(schema='FT1536_H3_RANGE_BOUND_LEDGER_V1',status='PARTIAL_PROOF',rows=rows,global_H3_range_proved=False,
 required_domain_counterexample=False,baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False,security_reduction_proved=False)
with (W/'BOUND_LEDGER.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
md=['# H3_RANGE — ledger faktów i domen','', 'Status całego etapu: PARTIAL_PROOF. Każdy bound ma odrębną domenę.']
for r in rows:
 md+=['','## '+r['id']+' — '+r['status'],r['claim'],'**Domena:** '+r['domain'],
  '**Błąd/arytmetyka:** '+r['error_model'],'**Pozostaje:** '+(r['remaining_premise'] or 'brak w zakresie tej lokalnej tezy'),
  '**Dowody/binding:** '+', '.join(p['path'] for p in r['evidence'])]
(W/'BOUND_LEDGER.md').write_text('\n\n'.join(md)+'\n')
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(schema='FT1536_H3_RANGE_OBLIGATIONS_V1',status='PARTIAL_PROOF',
 obligations=[dict(id=r['id'],status=r['status'],claim=r['claim'],gap=r['remaining_premise'],evidence=r['evidence']) for r in rows],
 blocking=['FPR_DOMAIN','INTERNAL_CENTERS','MACHINE_ERROR_TRANSFER','FINAL_REACHABILITY_LIFT'],
 next_exact_lemma='Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma) -> CenterClass(mu)',
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False,security_reduction_proved=False),indent=2)+'\n')
print(json.dumps(dict(rows=len(rows),status='PARTIAL_PROOF',required_domain_counterexample=False),indent=2))
