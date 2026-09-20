import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ORDERED_REACH_2026-09-20.md')
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ORDERED_REACH_RUN_001')
assert sha(TASK)=='f1852f4e8012033174a7d9d224ec7fca348a5bedb0d346fc61f33bb92290aeae'
assert sha(I/'MANIFEST.sha256')=='28a57d2c8e1361a7bc035b56426563187cf3903e1aa1cd1fa3ac4eeb5e1a3edc'
rows={}
for p in I.rglob('*'):assert not p.is_symlink()
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=line.split('  ',1);p=PurePosixPath(r);assert not p.is_absolute() and '..' not in p.parts and str(p)==r and r not in rows and re.fullmatch('[a-f0-9]{64}',h);assert sha(I/r)==h;rows[r]=h
assert len(rows)==396 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==394 and orig['base_commit']=='99ceb981cb0ef76e9e72b59ce325485b1908412f'
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
assert sum((I/r).stat().st_size for r in rows)==8324239
assert sha(I/'CANDIDATE.sha256')=='56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
srcrows={n:h for h,n in (s.split('  ',1) for s in (I/'CANDIDATE.sha256').read_text().splitlines())};assert len(srcrows)==17 and set(p.name for p in (I/'source').iterdir())==set(srcrows)
for n,h in srcrows.items():assert sha(I/'source'/n)==h
mounts=[s.split() for s in Path('/proc/self/mountinfo').read_text().splitlines()];probes=[]
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(I/'source/falcon-sign.c',False),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),False),(TASK,False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;result='writable_no_bytes_written'
 except OSError as e:assert not write and e.errno in [errno.EROFS,errno.EACCES];result=errno.errorcode[e.errno]
 cover=max((f for f in mounts if str(p)==f[4] or str(p).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));assert ('rw' if write else 'ro') in cover[5].split(',');probes.append(dict(path=str(p),result=result,mount=cover[4],options=cover[5]))
for r in ['source','formal','checks','bin','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for n,h in srcrows.items():shutil.copyfile(I/'source'/n,W/'source'/n);assert sha(W/'source'/n)==h
prov=[dict(path=str(I/r),copy='inputs/bootstrap/'+r,sha256=h) for r,h in rows.items()]+[dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256'))]
for p,r in [(TASK,'TASK.md'),(W/'AGENTS.md','inputs/context/work_agents.md'),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),'inputs/context/repo_agents.md')]:shutil.copyfile(p,W/r);prov.append(dict(path=str(p),copy=r,sha256=sha(p)))
manifest=''.join(r['sha256']+'  '+r['path']+'\n' for r in prov)
if (W/'INPUTS.sha256').exists():assert (W/'INPUTS.sha256').read_text()==manifest
else:(W/'INPUTS.sha256').write_text(manifest)
(W/'inputs/provenance.json').write_text(json.dumps(prov,indent=2)+'\n');reuse=[]
for n in ['lean','dyadic','fp_literal','replaylib','literal_backend','half_model','root_model','backend','toolchain']:
 src=I/'TARGETS/scripts'/(n+'.py');dst=W/'scripts'/(n+'.py');shutil.copyfile(src,dst);reuse.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
order=[]
def visit(m,stage):
 if m in order:return
 src=I/stage/'formal'/(m+'.lean');assert src.is_file()
 for dep in re.findall(r'^import (\w+)',src.read_text(),re.M):
  if (I/stage/'formal'/(dep+'.lean')).exists():visit(dep,stage)
 dst=W/'formal'/src.name;shutil.copyfile(src,dst);order.append(m);reuse.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
visit('TargetSequence','TARGETS');visit('ErrorArithmetic','ZERO');visit('Half','TOWER')
(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
(W/'artifacts/diffs/run.patch').write_text(''.join(difflib.unified_diff((I/'TARGETS/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='inputs/bootstrap/TARGETS/scripts/run.py',tofile='scripts/run.py')))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,network_namespace=os.readlink('/proc/self/ns/net'),probes=probes),indent=2)+'\n')
out=dict(status='PASS',members=396,origins=394,source_files=17,public_inputs=len(prov),member_bytes=8324239,all_pins_match=True,exact_scope=True,source_changed=False,inherited_modules=order)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
