"""Export proof/source bindings and the obligation delta, without changing inputs."""
import hashlib,json
from pathlib import Path
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
def write(p,v):
    with (W/p).open('x') as f:json.dump(v,f,indent=2,ensure_ascii=False);f.write('\n')
audit=load('artifacts/formal_audit.json');prov=load('inputs/provenance.json')
for row in prov:assert sha(row['copy'])==row['sha256']
source_pin='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
assert sha('source/falcon-vrfy.c')==source_pin
assert sha('inputs/source_hashes.sha256')=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,rel=line.split('  ',1);assert sha('source/'+rel)==h
unchanged={r['copy']:r['sha256'] for r in prov if r['copy'].startswith('formal/')}
assert len(unchanged)==16
write('artifacts/input_audit.json',dict(pinned_local_inputs=len(prov),all_copies_match=True,source_files=17,
    source_sha256=source_pin,source_manifest_sha256=sha('inputs/source_hashes.sha256'),unchanged_inherited_formal=unchanged))
write('artifacts/source_model_binding.json',dict(source_sha256=source_pin,source_file='source/falcon-vrfy.c',
    inherited_C_translation='inputs/PREV/SOURCE_MODEL_BINDING.md',inherited_C_translation_sha256=sha('inputs/PREV/SOURCE_MODEL_BINDING.md'),
    source_model_definitions_changed=False,unchanged_inherited_formal=unchanged,
    new_binding=[
      dict(source_lines=[1001,1010],proof='CRTStages.root_block_eval',consumes='ForwardProgress.root_coefficients'),
      dict(source_lines=[1015,1037],proof='CRTStages.binary_block_eval; ForwardGlobal.middle_eval',consumes='binary_coefficients; source prefix/layout; actual forwardSchedule'),
      dict(source_lines=[1042,1061],proof='ForwardGlobal.cubic_eval; FORWARD_GLOBAL',consumes='cubeF_bind; eval_linear; nodeCheck_sound; indexed leaf_facts'),
      dict(source_lines=[1185,1243],proof='Complete.L_NTT/L_NTT_p/L_NTT_d',consumes='Pipeline.L_NTT_pending_forward instantiated with Product.forward_product'),
      dict(source_lines=[1377,1424],proof='Complete.L_NTT_rho',consumes='adapted Rho.rho_contract; product_canonical_inputs')],
    new_checks='artifacts/leaf_binding.json; artifacts/controls.json',C_instrumentation='none; checks/pipeline.c includes unchanged source directly',
    qualifications='Kernel proof of the pinned concrete models, combined with the unchanged inherited C99/GCC/LP64 translation and valid-buffer assumptions.'))
old=load('inputs/PREV/OBLIGATIONS.json');changes={
 'FORWARD_GLOBAL':('PROVED_MODEL_WITH_INHERITED_C_TRANSLATION',['ForwardGlobal.FORWARD_GLOBAL','ForwardGlobal.middle_eval','LeafFacts.leaf_facts']),
 'PRODUCT':('PROVED',['Product.productCoefficient_eq','Monomials.remMonomial_eval','Product.product_eval','Product.forward_product','Complete.L_NTT']),
 'SUBTRACT':('PROVED',['Complete.L_NTT_d','Complete.L_NTT_ranges']),
 'RHO_SUBSTITUTION':('PROVED_FOR_INT16_INPUTS',['Rho.rho_contract','Complete.rhoVec_eq','Product.product_canonical_inputs','Complete.L_NTT_rho']),
 'IMPLEMENTATION_CHECKS':('NEW_LIMITED_CONTROLS_PASSED',['artifacts/controls.json','CheckerControls.lean']),
 'SOURCE_BINDING':('VERIFIED_UNCHANGED_MODELS_WITH_NEW_FORWARD_LINKS',['artifacts/input_audit.json','artifacts/source_model_binding.json'])}
rows=[]
for x in old['obligations']:
    ident=x['id'];new=ident in changes
    status,evidence=changes[ident] if new else ('REUSED_CLOSED_FROM_PREV',['inputs/PREV/OBLIGATIONS.json#'+ident,'REUSED_RESULTS.md'])
    rows.append(dict(id=ident,claim=x['claim'],previous_status=x['status'],origin='new' if new else 'inherited',
        status=status,evidence=evidence,gap=None,
        note='Supplemental half contract is inherited, not used by ternary forward.' if ident=='W_HALF' else None))
for ident,claim,evidence in [
 ('EVALUATION_INVARIANT','Root and every actual split preserve independent finite polynomial evaluation; induction over eight real stages.',['Sums.lean','Evaluation.split_preserves_eval','CRTStages.lean','ForwardGlobal.middle_eval']),
 ('NODE_CERTIFICATE','All1536 physical nodes have actual ancestor labels, PhiZero and source cubic coefficients; no final label hypothesis.',['NodeArithmetic.powFast_correct/nodeCheck_sound','LeafChecks.leaf_checked','LeafFacts.leaf_facts']),
 ('MONOMIAL_REDUCTION','For every required degree0..3070, unchanged remMonomial evaluates to z^k at each root of Phi.',['Monomials.remMonomial_eval']),
 ('FULL_L_NTT','Concrete source pipeline yields canonical product and product-minus-c for every canonical h,r,c.',['Complete.L_NTT','Complete.L_NTT_ranges','Complete.pipeline_intermediate_ranges']),
 ('STANDARD_REPLAY','Fresh sources and external OUTPUTS pin; local archived inputs only.',['scripts/replay.py','artifacts/fresh_replay.json','artifacts/replay_protocol_tests.json'])]:
    rows.append(dict(id=ident,claim=claim,origin='new',status='PROVED' if ident!='STANDARD_REPLAY' else 'REHEARSAL_PASS_STANDARD_INTERFACE_READY',evidence=evidence,gap=None))
write('OBLIGATIONS.json',dict(schema='FT1536_L_NTT_FORWARD_OBLIGATIONS_V1',status='L_NTT_PROVED_FOR_PINNED_MODEL',
    source_sha256=source_pin,previous_matrix_sha256=sha('inputs/PREV/OBLIGATIONS.json'),obligations=rows,
    blocking=[],source_integrated=False,owner_accepted=False,full_L_V_proved=False,
    scope_note='Remaining parser/centering/norm/strict-B/security obligations belong to full L_V and are outside L_NTT.'))
print(json.dumps(dict(status='L_NTT_PROVED_FOR_PINNED_MODEL',obligations=len(rows),inputs=len(prov),models_unchanged=len(unchanged)),indent=2))
