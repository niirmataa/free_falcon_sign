#!/usr/bin/env python3
"""Verify completed017 evidence and emit scoped metadata. No theorem is inferred from hashes."""
from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent.parent;B=S/'.build/local_leaves_017';R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def write(name,value):
 p=S/'notes'/name;assert not p.exists(),('never overwrite sealed result',p)
 p.write_text(json.dumps(value,indent=2)+'\n')
def check_receipt(p):
 r=json.loads(p.read_text());d=p.parent
 assert r['exit_code']==r['warning_count']==r['error_count']==0,(p,r['exit_code'])
 assert sha(Path(r['command'][-1]))==r['source_sha256']
 assert sha(Path(r['artifact']))==r['artifact_sha256']
 for stream in ['stdout','stderr']:assert sha(d/(stream+'.txt'))==r[stream+'_sha256']
 so=(d/'stdout.txt').read_text();assert not (d/'stderr.txt').read_text() and 'sorryAx' not in so
 for axioms in re.findall(r'depends on axioms:\s*\[([^]]*)\]',so):
  assert set(axioms.replace('\n','').replace(' ','').split(','))<={'propext','Classical.choice','Quot.sound'}
 return r

done=B/'finish001/COMPLETE.json';assert json.loads(done.read_text())['status']=='FINAL_INTERFACE_AND_REPLAY_CLEAN'
rp=B/'structural_replay001/REPLAY_RECEIPT.json';replay=json.loads(rp.read_text())
finite_path=B/'finish001/FINITE_WITNESS_RECEIPT.json';finite=json.loads(finite_path.read_text())
selected=json.loads((B/'witness_sources003/SELECTED.json').read_text())
assert len(finite['modules'])==211 and finite['logical_rows']==61441
modules=[]
for v in replay['modules']:
 r=check_receipt(Path(v['receipt']));assert sha(Path(v['source']))==v['source_sha256']
 modules.append({**v,'source':str(Path(v['source']).relative_to(S))})
dim=check_receipt(B/'runs/dimensions002/receipt.json')
modules.append({'module':'GlobalDimensionsObstruction017','source':'formal/GlobalDimensionsObstruction017.lean',
 'source_sha256':sha(S/'formal/GlobalDimensionsObstruction017.lean'),'audited_exports':2,
 'receipt':str(B/'runs/dimensions002/receipt.json'),'receipt_sha256':sha(B/'runs/dimensions002/receipt.json'),
 'artifact':dim['artifact'],'artifact_sha256':dim['artifact_sha256'],'elapsed_seconds':dim['elapsed_seconds']})
for v in finite['modules']:
 r=check_receipt(Path(v['receipt']));assert r['source_sha256']==v['sha256']
agg=check_receipt(B/'runs/aggregate001/receipt.json');actual=check_receipt(B/'runs/actual001/receipt.json')
for p in [B/'budget002/receipt.json',B/'sandwich002/receipt.json',B/'emitter002/receipt.json']:
 assert json.loads(p.read_text())['exit_code']==0
assert json.loads((B/'CANONICAL_GENERATION_CHECK_001.json').read_text())['status']=='EXACT_PUBLIC_CERTIFICATE_SOURCES_REPRODUCED'
prior=json.loads((B/'structural_replay001/prior/PINS.json').read_text())
for v in prior:
 assert sha(Path(v['source']))==v['source_sha256'] and sha(Path(v['artifact']))==v['artifact_sha256']

attempts=[]
selected_receipts={str(Path(v['receipt']).resolve()) for v in finite['modules']}
selected_receipts|={str(Path(v['receipt']).resolve()) for v in modules}
selected_receipts|={str((B/'runs'/l/'receipt.json').resolve()) for l in ['aggregate001','actual001']}
for p in sorted((B/'runs').glob('*/receipt.json')):
 r=json.loads(p.read_text());so=(p.parent/'stdout.txt').read_text();se=(p.parent/'stderr.txt').read_text()
 role='SELECTED' if str(p.resolve()) in selected_receipts else 'RETAINED_PRELIMINARY_OR_SUPERSEDED'
 if 'Diagnostic' in r['module']:role='EVALUATION_ONLY_NOT_PROOF'
 if r['exit_code']!=0:
  role='FAILED_RETAINED'
  if 'memory' in (so+se).lower():cause='memory limit; unchanged source snapshots retained'
  elif 'object file' in so or 'unknown module' in so:cause='import/root/dependency seam'
  elif r['status']=='timeout':cause='bounded wall timeout'
  else:cause='elaboration/type/notation/tactic failure; exact diagnostics retained'
 elif r['warning_count']:cause='superseded warning-bearing attempt'
 else:cause='clean recorded run; exact role is separate from compilation success'
 attempts.append({'label':p.parent.name,'module':r['module'],'role':role,'cause':cause,
  'exit_code':r['exit_code'],'warnings':r['warning_count'],'elapsed_seconds':r['elapsed_seconds'],
  'receipt_sha256':sha(p),'source_sha256':r['source_sha256'],'stdout_sha256':sha(p.parent/'stdout.txt'),
  'stderr_sha256':sha(p.parent/'stderr.txt')})
write('LOCAL_LEAVES_017_ATTEMPTS.json',{'attempts':attempts,
 'failed_sage_budget001':'Output expression accidentally combined an existence assertion with write_text; exact arithmetic assertions passed, but run exited1. Not accepted. Corrected budget002 kept separately.',
 'certificate_regeneration':'sandwich001 retained with time in JSON; sandwich002 separates timing. Exact numeric values and all nine emitted Lean sources agree byte for byte.',
 'batch_routes':'witness_sources001:30 selected clean prefix modules; witness030001 memory failure. witness_sources002:smaller modules, rest005001 and singleton8-block memoryprobe fail. witness_sources003:individual row theorem route selected; no rows omitted.',
 'not_independent_review':True})
data=json.loads((B/'emitter002/generated/MANIFEST.json').read_text())
write('LARGE_ARTIFACTS_017.json',{'id':'S05_017_FINITE_KERNEL_WITNESSES','status':'REPRODUCIBLE_GENERATED_DATA_AND_KERNEL_PROOF_SOURCES',
 'table_input':{'path':str(S/'.build/implementation_016/inputs/tables.json'),'sha256':sha(S/'.build/implementation_016/inputs/tables.json')},
 'canonical_certificate':{'path':str(B/'sandwich002/CERTIFICATE.json'),'sha256':sha(B/'sandwich002/CERTIFICATE.json')},
 'data_modules':data['modules'],'selected_witnesses':selected,'finite_receipt_sha256':sha(finite_path),
 'generators':[{'path':'notes/'+n,'sha256':sha(S/'notes'/n)} for n in ['GENERATE_GAUSSIAN_CERT_017.sage','EMIT_GAUSSIAN_CERT_017.sage','EMIT_GAUSSIAN_WITNESSES_017.py','EMIT_GAUSSIAN_ROWS_017.py']],
 'reproduction':'Recreate canonical JSON, emit nine data modules, generate original prefix and individual-row continuation in fresh directories. Compare every selected source SHA; compile with bounded runner and complete aggregate. Generation alone is not proof.',
 'preserved_failed_route_generators':['notes/EMIT_GAUSSIAN_REST_017.py']})
write('LOCAL_LEAVES_017_INPUTS.json',{'base_commit':'32d2639ae913c088c6fe7ec163caaf0385b246e8',
 'source_checkpoints':['2ae6e140','77a65116','6d7b15df','ef354c48'],
 'observed_main':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip(),
 'previous_receipt':{'path':'notes/IMPLEMENTATION_016_RECEIPT.json','sha256':sha(S/'notes/IMPLEMENTATION_016_RECEIPT.json')},
 'library_roots':json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots'],
 'toolchain':json.loads((B/'TOOLCHAIN_001.json').read_text()),
 'toolchain_record_sha256':sha(B/'TOOLCHAIN_001.json'),
 'replay_prior_pin_sha256':sha(B/'structural_replay001/prior/PINS.json'),
 'source3_counterexample_input_closure':{'pairs':486,'path':str(B/'DIMENSIONS_INPUT_PINS_001.json'),'sha256':sha(B/'DIMENSIONS_INPUT_PINS_001.json')},
 'model':'independent fair fixed tape; same finite Sign law and every modeled failure; no new cryptographic assumption'})
write('LOCAL_LEAVES_017_CHECKS.json',{'status':'CLEAN_KERNEL_AND_EXACT_SAGE_IN_STATED_SCOPE',
 'modules':modules,'audited_exports':sum(v['audited_exports'] for v in modules),
 'finite_rows':61441,'dyadic_states':30721,'cdf_weights':30721,'thresholds':61441,
 'selected_finite_modules':211,'aggregate_exports':5,'scalar_row_witnesses':46081,'eight_row_prefix_witnesses':1920,
 'negative_controls':'LiteralControls017:three rejected mutations plus exact nonuniform modulo count/probability controls',
 'obstructions':'BoundedAddressObstruction017:three exports; GlobalDimensionsObstruction017:two exports; exact pinned ROM types only',
 'structural_replay_sha256':sha(rp),'finite_receipt_sha256':sha(finite_path),
 'actual_receipt_sha256':sha(B/'runs/actual001/receipt.json'),'aggregate_receipt_sha256':sha(B/'runs/aggregate001/receipt.json'),
 'canonical_generation_check_sha256':sha(B/'CANONICAL_GENERATION_CHECK_001.json')})
cost={'scope':'PROOF_GENERATION_AND_VERIFICATION_ONLY_NOT_SAMPLER_EXECUTION',
 'finite_module_elapsed_sum_seconds':sum(v['elapsed_seconds'] for v in finite['modules']),
 'fresh_structural_elapsed_sum_seconds':sum(v['elapsed_seconds'] for v in replay['modules']),
 'peak_observed_compiler_rss_KiB':max(v.get('compiler_peak_rss_KiB') or 0 for v in finite['modules']),
 'missing_RSS_samples':'Older prefix and pilot receipts did not measure RSS; missing is not zero.',
 'limits_per_compiler':{'cores':1,'memory_cap_MiB':4096,'address_space_GiB':8,'stack_MiB':64,'CPU_soft_seconds':110,'wall_seconds':120},
 'parallel_schedules':'Original two E cores, then two P cores; retained16-block route three P cores; selected individual-row continuation four P cores0/2/4/6 with memory-aware launch guard.',
 'logical_sampler_bits':24662538240,'logical_pair_proposal_slots':24084480,
 'operational_sampler_cost':'OPEN; logical slots are not measured calls/operations/time/memory; functional recomputation and implementation equivalence remain separate.'}
write('LOCAL_LEAVES_017_RECEIPT.json',{'id':'S05_LOCAL_LEAVES_017','status':'PARTIAL_PROOF_CONDITIONAL_ON_M_NOT_REVIEWED',
 'closed':'All actual PairLeaves and CubeLeaf instances. Actual code moment under exactly MassCondition; all-h AC inherited016.',
 'moment':'second(J,P) <= 1 + 2^-47; full modeled Option responses, every state, public initial corollary, same covered key law.',
 'open':['actual emitted-key/source harmonic coverage of(M)','full Sign/API and PRG binding','operational sampler cost and implementation equivalence','QROM mechanisms and final reduction resources'],
 'new_crypto_assumptions':[],'strengthened_M':False,'full_QROM_claim':False,
 'proof_costs':cost,'checks_sha256':sha(S/'notes/LOCAL_LEAVES_017_CHECKS.json'),
 'inputs_sha256':sha(S/'notes/LOCAL_LEAVES_017_INPUTS.json'),'attempts_sha256':sha(S/'notes/LOCAL_LEAVES_017_ATTEMPTS.json'),
 'large_artifacts_sha256':sha(S/'notes/LARGE_ARTIFACTS_017.json')})
print(json.dumps({'status':'SEALED_SCOPED_EVIDENCE','modules':len(modules),'audited_exports':sum(v['audited_exports'] for v in modules),'finite_rows':61441}))
