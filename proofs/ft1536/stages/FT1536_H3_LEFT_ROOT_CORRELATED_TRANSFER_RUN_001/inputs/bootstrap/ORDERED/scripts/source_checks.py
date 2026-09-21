import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';r=verify_manifest(I,'MANIFEST.sha256','28a57d2c8e1361a7bc035b56426563187cf3903e1aa1cd1fa3ac4eeb5e1a3edc');assert len(r)==396 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(r)|{'MANIFEST.sha256'}
prov=json.loads((W/'inputs/provenance.json').read_text());assert len(prov)==400
for p in prov:assert sha(W/p['copy'])==p['sha256']
for p in json.loads((W/'artifacts/reuse.json').read_text()):assert sha(W/p['input'])==sha(W/p['copy'])==p['sha256']
names=[]
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h;names.append(n)
assert len(names)==17 and {p.name for p in (W/'source').iterdir()}==set(names)
adapt=[]
for old,new in [('TARGETS/scripts/controls.py','scripts/controls.py'),('TARGETS/scripts/audit.py','scripts/audit.py'),('TOWER/scripts/tower_model.py','scripts/ordered_model.py')]:
 p=W/'artifacts/diffs'/('binding_'+Path(new).stem+'.patch');p.write_text(''.join(difflib.unified_diff((I/old).read_text().splitlines(True),(W/new).read_text().splitlines(True),fromfile='inputs/bootstrap/'+old,tofile=new)))
 adapt.append(dict(input='inputs/bootstrap/'+old,input_sha256=sha(I/old),copy=new,sha256=sha(W/new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
docs=['CLAIM.md','INVARIANT.md','SCALAR_OUTCOMES.md','FAULT_REJECTION.md','ERROR_LEDGER.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','CALLER_RETRY_BINDING.md','FAILED_ROUTES.md','NEXT_INTERFACE.md','REUSED_RESULTS.md']
out=dict(status='PASS_SOURCE_PINS_AND_SCOPED_PROOF_BINDING',source_files=17,public_inputs=400,source_pin=sha(I/'CANDIDATE.sha256'),documents={p:sha(W/p) for p in docs},adaptations=adapt,source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_checks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],source_files=17,public_inputs=400)))
