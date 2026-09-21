import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';r=verify_manifest(I,'MANIFEST.sha256','16977cc646bf5bd5af62f7f86e1c992ab24cafd05188a3c5dbeeae96e2a7a97e')
assert len(r)==198 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(r)|{'MANIFEST.sha256'}
prov=json.loads((W/'inputs/provenance.json').read_text());assert len(prov)==202
for p in prov:assert sha(W/p['copy'])==p['sha256']
for p in json.loads((W/'artifacts/reuse.json').read_text()):assert sha(W/p['input'])==sha(W/p['copy'])==p['sha256']
names=[]
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h;names.append(n)
assert len(names)==17 and {p.name for p in (W/'source').iterdir()}==set(names)
adapt=[]
for old,new in [('ROOT/scripts/certificate.py','scripts/numeric_certificate.py'),('ROOT/scripts/controls.py','scripts/controls.py'),('NORMALIZED/scripts/audit.py','scripts/audit.py'),('ROOT/scripts/root_model.py','scripts/target_model.py')]:
 p=W/'artifacts/diffs'/('binding_'+Path(new).stem+'.patch');p.write_text(''.join(difflib.unified_diff((I/old).read_text().splitlines(True),(W/new).read_text().splitlines(True),fromfile='inputs/bootstrap/'+old,tofile=new)))
 adapt.append(dict(input='inputs/bootstrap/'+old,input_sha256=sha(I/old),copy=new,sha256=sha(W/new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
docs=['CLAIM.md','TARGET_FORMULAS.md','FFT_CHALLENGE_BOUNDS.md','ERROR_LEDGER.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','CALLER_BINDING.md','NEXT_INTERFACE.md','REUSED_RESULTS.md']
out=dict(status='PASS_SOURCE_PINS_AND_TARGET_PROOF_BINDING',source_files=17,public_inputs=202,source_pin=sha(I/'CANDIDATE.sha256'),documents={p:sha(W/p) for p in docs},adaptations=adapt,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_checks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],source_files=17,public_inputs=202)))
