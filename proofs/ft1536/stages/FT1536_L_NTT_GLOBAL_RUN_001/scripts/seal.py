"""Seal one new partial-proof package; never modifies any predecessor."""
import hashlib,json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(rel):return json.loads((W/rel).read_text())
def write(rel,data):
    with (W/rel).open('x') as f:json.dump(data,f,indent=2,ensure_ascii=False);f.write('\n')
assert not (W/'OUTPUTS.sha256').exists()
prov=load('inputs/provenance.json');assert len(prov)==38
for rec in prov:
    for p in [Path(rec['path']),W/rec['copy']]:
        assert not p.is_symlink() and sha(p)==rec['sha256'],str(p)
manifest=W/'inputs/source_hashes.sha256'
assert sha(manifest)=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
source_rows=manifest.read_text().splitlines();assert len(source_rows)==17
for line in source_rows:
    wanted,rel=line.split('  ',1);assert sha(W/'source'/rel)==wanted
write('artifacts/input_audit.json',dict(original_inputs_unchanged=38,copies_match=38,source_files_unchanged=17,
    source_manifest_sha256=sha(manifest),INPUTS_sha256=sha(W/'INPUTS.sha256')))
audit=load('artifacts/formal_audit.json');replay=load('artifacts/replay_result.json');control=load('artifacts/controls.json');sage=load('artifacts/sage_controls.json')
assert audit['all_final_logs_clean'] and audit['checked_theorems']==351 and audit['modules']==18
assert replay['status']=='PASS' and replay['semantic_files_equal']==103
for rel,h in audit['sources_sha256'].items():assert sha(W/rel)==h
for rec in replay['files']:
    assert sha(W/rec['path'])==rec['sha256'] and sha(W/'replay'/rec['path'])==rec['sha256']
src=(W/'source/falcon-vrfy.c').read_bytes();lines=src.splitlines(keepends=True)
spans=[('forward_root',1001,1010,'forwardRootOp'),('forward_binary',1015,1037,'forwardMiddle/forwardBinaryOp'),
 ('forward_cubic',1042,1061,'forwardCubicOp'),('inverse_cubic',1089,1108,'inverseCubicOp'),
 ('inverse_binary',1113,1135,'inverseMiddle/inverseBinaryOp'),('inverse_root',1140,1149,'inverseRootOp'),
 ('scaling',1155,1158,'scaleStep'),('poly_helpers',1185,1243,'toMontC/montPointC/subtractC')]
write('artifacts/source_model_binding.json',dict(source_sha256=sha(W/'source/falcon-vrfy.c'),logn=10,ternary=1,
    table_initialized_used_prefix=[0,1023],table_binding='artifacts/twiddle_binding.json',
    C_translation='SOURCE_MODEL_BINDING.md',formal_model_sha256=audit['sources_sha256'],
    spans=[dict(name=n,lines=[a,b],sha256=hashlib.sha256(b''.join(lines[a-1:b])).hexdigest(),model=m) for n,a,b,m in spans],
    status='PINNED_SOURCE_EXPLICIT_TRANSLATION_KERNEL_MODEL_AND_LIMITED_EXECUTION_CONTROLS'))

previous=load('inputs/context/9_OBLIGATIONS.json');assert len(previous['obligations'])==16
updates={
 'INDEX_INIT':('PROVED_MODEL_WITH_REUSED_GENERATOR',['Layouts.pair_address_bound','Layouts.triple_address_bound','LocalInverse.forward_params_ok','ForwardProgress.initialized_binary_read','ForwardProgress.initialized_cubic_read'],None),
 'LOCAL_BLOCKS':('PROVED_BOUND_SOURCE_EXPRESSIONS',['Expressions.eval_linear','BlockExpressions.blockCheck_sound','BlockExpressions.*_bind','BlockChecks.local_checked','LocalInverse.root_inverse/binary_inverse/cubic_inverse'],None),
 'FORWARD_GLOBAL':('OPEN_WITH_NEW_COEFFICIENT_STAGE_RESULTS',['ForwardProgress.root_coefficients','ForwardProgress.binary_coefficients','INVARIANTS.md'],
  'Prove for every canonical v: forwardC v [3i+j] = sum(k=0..1535,v[k]*(ordinary(gmAt(512+i))*14648^j)^k) mod18433. Missing: induction connecting all eight actual binary-stage buffers to labelled CRT remainders, then cubic evaluation in physical order.'),
 'INVERSE_GLOBAL':('PROVED_MODEL_WITH_C_TRANSLATION',['InverseGlobal.middle_reverse_inverse','InverseGlobal.inverseMem_forwardMem','InverseGlobal.inverseC_forwardC','InverseGlobal.inverse_forward','SOURCE_MODEL_BINDING.md'],None),
 'PRODUCT':('CONDITIONAL_ONLY_ON_FORWARD_PRODUCT',['Pipeline.L_NTT_pending_forward','InverseGlobal.inverse_forward','Deps/Composition.productCoefficient/remMonomial'],
  'Remaining explicit hypothesis: forall h r, liftForward(product h r)=pointMul(liftForward h)(liftForward r). Requires FORWARD_GLOBAL, roots of Phi, coefficient-sum algebra and canonicalization invariance. inverse_forward is discharged.'),
 'SUBTRACT':('SOURCE_POINTWISE_PROVED_PRODUCT_IDENTIFICATION_CONDITIONAL',['Stages.point_prefix','Pipeline.subtractC_eq','Pipeline.L_NTT_pending_forward'],'Identification d=canonical(h*r-c) still requires PRODUCT.'),
 'RHO_SUBSTITUTION':('CONDITIONAL_ON_L_NTT',['inputs/certificates/L_RHO_RESULT.json','CLAIM.md'],'L_RHO remains consumed locally; universal PRODUCT is open, so the final h*s-c substitution is not closed.'),
 'SOURCE_BINDING':('VERIFIED_BYTES_AND_EXPLICIT_C_TRANSLATION',['artifacts/input_audit.json','artifacts/source_model_binding.json','artifacts/control_binding.json','SOURCE_MODEL_BINDING.md'],None),
 'IMPLEMENTATION_CHECKS':('NEW_LIMITED_CONTROLS_AND_FRESH_REPLAY_PASS',['artifacts/controls.json','artifacts/sage_controls.json','artifacts/replay_result.json'],'Finite controls do not close FORWARD_GLOBAL/PRODUCT; inherited broader PREV tests were not rerun.')
}
rows=[]
for old in previous['obligations']:
    ident=old['id']
    row=dict(id=ident,claim=old['claim'],previous_status=old['status'],source_lines=old['source_lines'],
             previous_record='inputs/context/9_OBLIGATIONS.json#'+ident,previous_record_pin='5467801aac9c25f3c1f757f3c640fefcbb6074524874da0312a6e97aaa163bd8')
    if ident in updates:status,evidence,gap=updates[ident]
    else:status,evidence,gap='REUSED_'+old['status'],['REUSED_RESULTS.md','formal/Deps/','logs/final/'],old['gap']
    row.update(status=status,evidence=evidence,gap=gap);rows.append(row)
new=[
 ('BUFFER_PREFIX','Every sequential prefix obeys old-snapshot/per-block/frame invariant','Buffer.prefix_invariant; Layouts.source_pair_prefix/source_triple_prefix; Stages.point_prefix'),
 ('CANONICAL_STATES','Every full forward/inverse source-model state is canonical on1536 cells','SourceModel.forward_canonical/inverse_canonical'),
 ('EXPRESSION_SOUNDNESS','Finite source-expression coefficient checks imply action on all canonical block inputs','Expressions.eval_linear/eval_diagonal; BlockExpressions.blockCheck_sound and *_bind'),
 ('DOMAIN_LIFT','Explicit canonical lift agrees with source C domain, and inverse_forward holds for all Vec','SourceModel.liftForward_agrees/liftInverse_agrees; InverseGlobal.inverse_forward'),
 ('PIPELINE_BINDING','Sequential tomonty/montPoint/subtract source-model loops equal the mathematical composition','Pipeline.toMontC_eq/montPointC_eq/subtractC_eq/pipelineC_lift')]
for ident,claim,evidence in new:rows.append(dict(id=ident,claim=claim,status='PROVED_MODEL',evidence=[evidence],gap=None))
write('OBLIGATIONS.json',dict(schema='FT1536_L_NTT_GLOBAL_OBLIGATIONS_V1',main_result='PARTIAL_PROOF',
    source_sha256=sha(W/'source/falcon-vrfy.c'),source_integrated=False,owner_accepted=False,full_L_V_proved=False,
    obligations=rows,blocking=['FORWARD_GLOBAL','PRODUCT'],
    nearest_dependencies=dict(FORWARD_GLOBAL=['BUFFER_PREFIX','root_coefficients','binary_coefficients','reused Tables parent/tree facts','global CRT remainder induction'],
                              PRODUCT=['FORWARD_GLOBAL','roots of Phi','unchanged productCoefficient/remMonomial','canonicalization invariance'])))
new_theorems=sum(n.startswith('FT1536Global.') for n in audit['theorems']);assert new_theorems==165
write('RESULT.json',dict(schema='FT1536_L_NTT_GLOBAL_RESULT_V1',status='PARTIAL_PROOF',
    L_NTT_proved=False,INVERSE_GLOBAL_proved_for_pinned_model=True,inverse_forward_instantiated=True,
    FORWARD_GLOBAL_proved=False,forward_product_instantiated=False,PRODUCT_proved=False,
    source_integrated=False,owner_accepted=False,full_L_V_proved=False,
    source_sha256=sha(W/'source/falcon-vrfy.c'),source_manifest_sha256=sha(manifest),
    predecessor_report_sha256='b89d618d7c1d3992fa1a9ea0ae8c84dcc348448f035905b87a03c37e20dfd650',
    predecessor_outputs_sha256='f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f',
    L_RHO_result_sha256=sha(W/'inputs/certificates/L_RHO_RESULT.json'),
    formal_checked_theorems=351,new_theorems=165,final_modules=18,all_final_logs_clean=True,
    audit_stdout_sha256=audit['audit_stdout_sha256'],full_types='logs/final/Audit.stdout',
    conditional_pipeline_theorem='FT1536Global.L_NTT_pending_forward',remaining_explicit_global_hypotheses=['forward_product'],
    controls=control,sage_controls=sage,replay_semantic_files_equal=103,report_sha256=sha(W/'REPORT.md'),
    recommended_next_step='Close source-buffer/CRT forward invariant and forward_product, reusing the now closed inverse_forward.'))

prefix=(W/'COMMANDS.log').read_bytes()
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(prefix)
write('artifacts/command_prefix.json',dict(path='COMMANDS.log',bytes=len(prefix),sha256=hashlib.sha256(prefix).hexdigest(),
    snapshot='artifacts/COMMANDS.frozen.log',note='receipt of seal and subsequent read-only verification are outside this frozen prefix'))
main=['AGENTS.md','CLAIM.md','REPORT.md','RESULT.json','OBLIGATIONS.json','REUSED_RESULTS.md','SOURCE_MODEL_BINDING.md',
      'INVARIANTS.md','REPLAY.md','OUTPUT_SCOPE.md','INPUTS.sha256','TOOLCHAIN.txt']
files={W/p for p in main}
folders=['source','inputs','formal','scripts','artifacts','logs','checks',
         'replay/source','replay/inputs','replay/formal','replay/scripts','replay/artifacts','replay/logs','replay/checks']
for folder in folders:
    for p in (W/folder).rglob('*'):
        assert not p.is_symlink(),str(p)
        if p.is_file() and '.olean' not in p.name and p.suffix!='.ilean':files.add(p)
files.add(W/'replay/COMMANDS.log')
assert all(p.is_file() and not p.is_symlink() for p in files)
with (W/'OUTPUTS.sha256').open('x') as f:
    for p in sorted(files):f.write(sha(p)+'  '+p.relative_to(W).as_posix()+'\n')
print(json.dumps(dict(status='PARTIAL_PROOF',manifest_entries=len(files),obligations=len(rows),
    REPORT=str(W/'REPORT.md'),REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256'),
    command_prefix_bytes=len(prefix),source_unchanged=True),indent=2))
