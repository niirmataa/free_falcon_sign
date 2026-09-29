import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';r=verify_manifest(I,'MANIFEST.sha256','5bbd7b14d05275ad0cf46a72e9b8d24d5c67001f7597761edb07d86d444173d4');assert len(r)==579 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(r)|{'MANIFEST.sha256'}
prov=json.loads((W/'inputs/provenance.json').read_text());assert len(prov)==583
for p in prov:assert sha(W/p['copy'])==p['sha256']
for name in ['reuse','control_reuse']:
 for p in json.loads((W/'artifacts'/(name+'.json')).read_text()):assert sha(W/p['input'])==sha(W/p['copy'])==p['sha256']
names=[]
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h;names.append(n)
assert len(names)==17 and {p.name for p in (W/'source').iterdir()}==set(names)
adapt=[]
for old,new in [('ORDERED/scripts/bounds.py','scripts/energy_transfer.py'),('ORDERED/scripts/audit.py','scripts/audit.py'),('ORDERED/scripts/controls.py','scripts/controls.py'),('TOWER/scripts/tower_model.py','scripts/tree_model.py'),('NORMALIZED/scripts/width_bounds.py','scripts/bank_bounds.py')]:
 p=W/'artifacts/diffs'/('binding_'+Path(new).stem+'.patch');p.write_text(''.join(difflib.unified_diff((I/old).read_text().splitlines(True),(W/new).read_text().splitlines(True),fromfile='inputs/bootstrap/'+old,tofile=new)))
 adapt.append(dict(input='inputs/bootstrap/'+old,input_sha256=sha(I/old),copy=new,sha256=sha(W/new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
docs=['CLAIM.md','METRIC_BRIDGE.md','BANK_WEIGHTED_BOUNDS.md','RIGHT_RESIDUAL_ENERGY.md','ROOT_TRANSFER.md','LEFT_INVARIANT.md','ORDERED_COMPOSITION.md','ERROR_LEDGER.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','FAULT_REJECTION.md','CALLER_RETRY_BINDING.md','FAILED_ROUTES.md','NEXT_INTERFACE.md','REUSED_RESULTS.md']
out=dict(status='PASS_SOURCE_PINS_AND_ACTUAL_METRIC_PROOF_BINDING',source_files=17,public_inputs=583,source_pin=sha(I/'CANDIDATE.sha256'),documents={p:sha(W/p) for p in docs},adaptations=adapt,source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_checks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],source_files=17,public_inputs=583)))
