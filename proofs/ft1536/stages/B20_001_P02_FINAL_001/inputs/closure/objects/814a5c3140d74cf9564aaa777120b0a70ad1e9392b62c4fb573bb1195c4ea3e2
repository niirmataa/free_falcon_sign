import difflib,errno,json,os
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';rows=verify_manifest(I,'MANIFEST.sha256','5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4')
assert len(rows)==308 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
provenance=json.loads((W/'inputs/provenance.json').read_text())
for r in provenance:assert sha(W/r['copy'])==r['sha256']
assert len(provenance)==312
for r in json.loads((W/'artifacts/reuse.json').read_text()):
 assert sha(W/r['copy'])==r['sha256'],r['copy']
 if r['byte_identical']:assert sha(W/r['input'])==r['sha256']
 else:
  assert sha(W/r['input'])==r['input_sha256']
  text=''.join(difflib.unified_diff((W/r['input']).read_text().splitlines(True),(W/r['copy']).read_text().splitlines(True),fromfile=r['input'],tofile=r['copy']))
  p=W/r['diff']
  if p.exists():assert p.read_text()==text
  else:p.write_text(text)
names=[]
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h;names.append(n)
assert len(names)==17 and {p.name for p in (W/'source').iterdir()}==set(names)
mounts=[line.split() for line in Path('/proc/self/mountinfo').read_text().splitlines()]
for p in [W/'source/falcon-sign.c',I/'MANIFEST.sha256']:
 covering=max((f for f in mounts if str(p)==f[4] or str(p).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));assert 'ro' in covering[5].split(',')
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);raise AssertionError('readonly source required')
 except OSError as e:assert e.errno in [errno.EROFS,errno.EACCES]
adaptations=[]
for old,new in [('TOWER/checks/tower.c','checks/raw.c'),('TOWER/scripts/controls.py','scripts/controls.py'),('TOWER/scripts/tower_model.py','scripts/raw_model.py'),('TOWER/scripts/backend.py','scripts/backend.py')]:
 p=W/'artifacts/diffs'/('binding_'+Path(new).stem+'.patch');text=''.join(difflib.unified_diff((I/old).read_text().splitlines(True),(W/new).read_text().splitlines(True),fromfile='inputs/bootstrap/'+old,tofile=new));p.write_text(text)
 adaptations.append(dict(input='inputs/bootstrap/'+old,input_sha256=sha(I/old),copy=new,sha256=sha(W/new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
docs=['CLAIM.md','COMPOSITION.md','MEMORY_LAYOUT.md','SOURCE_TRANSPORT.md','SOURCE_MODEL_BINDING.md','NEXT_INTERFACE.md','REUSED_RESULTS.md']
out=dict(status='PASS_SOURCE_PINS_READONLY_AND_PROOF_BINDING',source_files=17,public_inputs=312,source_readonly_mount_verified=True,bootstrap_readonly_mount_verified=True,
 source_sha256=sha(I/'CANDIDATE.sha256'),proof_documents={p:sha(W/p) for p in docs},adaptations=adaptations,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_checks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],source_files=17,public_inputs=312,adaptations=len(adaptations))))
