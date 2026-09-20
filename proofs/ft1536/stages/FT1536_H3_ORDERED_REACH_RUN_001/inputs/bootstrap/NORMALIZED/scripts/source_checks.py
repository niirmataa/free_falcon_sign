import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';rows=verify_manifest(I,'MANIFEST.sha256','58f027900b3283bdf6f488ddb4fdeaa1e6c80b69253cf7d03a7855d3898478f7')
assert len(rows)==272 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
provenance=json.loads((W/'inputs/provenance.json').read_text());assert len(provenance)==276
for r in provenance:assert sha(W/r['copy'])==r['sha256']
for r in json.loads((W/'artifacts/reuse.json').read_text()):assert sha(W/r['copy'])==sha(W/r['input'])==r['sha256']
names=[]
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h;names.append(n)
assert len(names)==17 and {p.name for p in (W/'source').iterdir()}==set(names)
adapt=[]
for old,new in [('RAW/scripts/backend.py','scripts/backend.py'),('RAW/scripts/controls.py','scripts/controls.py'),('RAW/scripts/audit.py','scripts/audit.py'),('RAW/formal/PackOf.lean','formal/SqrtPack.lean')]:
 dest=W/'artifacts/diffs'/('binding_'+Path(new).stem+'.patch');dest.write_text(''.join(difflib.unified_diff((I/old).read_text().splitlines(True),(W/new).read_text().splitlines(True),fromfile='inputs/bootstrap/'+old,tofile=new)))
 adapt.append(dict(input='inputs/bootstrap/'+old,input_sha256=sha(I/old),copy=new,sha256=sha(W/new),diff=dest.relative_to(W).as_posix(),diff_sha256=sha(dest)))
docs=['CLAIM.md','DOMAIN_AUDIT.md','EMITTED_STABLE_BINDING.md','NORMALIZATION.md','SQRT_DIV_CONTRACT.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','NEXT_INTERFACE.md','REUSED_RESULTS.md']
out=dict(status='PASS_SOURCE_AND_TYPED_PROOF_BINDING',source_files=17,public_inputs=276,source_manifest_sha256=sha(I/'CANDIDATE.sha256'),
 proof_documents={p:sha(W/p) for p in docs},adaptations=adapt,source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_checks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],source_files=17,public_inputs=276)))
