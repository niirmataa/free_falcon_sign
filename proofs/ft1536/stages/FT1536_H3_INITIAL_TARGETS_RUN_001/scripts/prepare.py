import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_INITIAL_TARGETS_2026-09-20.md')
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_INITIAL_TARGETS_RUN_001')
assert sha(TASK)=='a8bfe078ced0a6742cafae3950aa9c6020d4b3a58a677aab46731d75564fdfda'
assert sha(I/'MANIFEST.sha256')=='16977cc646bf5bd5af62f7f86e1c992ab24cafd05188a3c5dbeeae96e2a7a97e'
for p in I.rglob('*'):assert not p.is_symlink()
rows={}
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=line.split('  ',1);p=PurePosixPath(r);assert not p.is_absolute() and '..' not in p.parts and str(p)==r and r not in rows and re.fullmatch('[a-f0-9]{64}',h)
 assert sha(I/r)==h;rows[r]=h
assert len(rows)==198 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==196 and orig['base_commit']=='6c233cdb48e4fd274995dd1882e0de03305771c8'
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
assert sum((I/r).stat().st_size for r in rows)==4277189
assert sha(I/'CANDIDATE.sha256')=='56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
srcrows={}
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(I/'source'/n)==h;srcrows[n]=h
assert len(srcrows)==17 and set(p.name for p in (I/'source').iterdir())==set(srcrows)
mounts=[]
for line in Path('/proc/self/mountinfo').read_text().splitlines():
 f=line.split();mounts.append(dict(mount=f[4],options=f[5].split(',')))
probes=[]
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(I/'source/falcon-sign.c',False),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),False),(TASK,False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;result='writable_no_bytes_written'
 except OSError as e:assert not write and e.errno in [errno.EROFS,errno.EACCES];result=errno.errorcode[e.errno]
 cover=max((m for m in mounts if str(p)==m['mount'] or str(p).startswith(m['mount'].rstrip('/')+'/')),key=lambda m:len(m['mount']))
 assert ('rw' if write else 'ro') in cover['options'];probes.append(dict(path=str(p),result=result,covering_mount=cover))
for r in ['source','formal','checks','bin','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for n,h in srcrows.items():shutil.copyfile(I/'source'/n,W/'source'/n);assert sha(W/'source'/n)==h
provenance=[dict(path=str(I/r),copy='inputs/bootstrap/'+r,sha256=h) for r,h in rows.items()]
provenance.append(dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256')))
for p,r in [(TASK,'TASK.md'),(W/'AGENTS.md','inputs/context/work_agents.md'),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),'inputs/context/repo_agents.md')]:
 shutil.copyfile(p,W/r);provenance.append(dict(path=str(p),copy=r,sha256=sha(p)))
with (W/'INPUTS.sha256').open('x') as f:
 for r in provenance:f.write(r['sha256']+'  '+r['path']+'\n')
(W/'inputs/provenance.json').write_text(json.dumps(provenance,indent=2)+'\n');reuse=[]
for n in ['lean','dyadic','fp_literal','replaylib','literal_backend','half_model','root_model','backend','toolchain']:
 src=I/'NORMALIZED/scripts'/(n+'.py');dst=W/'scripts'/(n+'.py');shutil.copyfile(src,dst);reuse.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
order=[]
def visit(m):
 if m in order:return
 src=I/'NORMALIZED/formal'/(m+'.lean');assert sha(src)==rows['NORMALIZED/formal/'+m+'.lean']
 for dep in re.findall(r'^import (\w+)',src.read_text(),re.M):
  if (I/'NORMALIZED/formal'/(dep+'.lean')).exists():visit(dep)
 dst=W/'formal'/src.name;shutil.copyfile(src,dst);order.append(m)
 reuse.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
visit('RootModel')
(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
diff=''.join(difflib.unified_diff((I/'NORMALIZED/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='inputs/bootstrap/NORMALIZED/scripts/run.py',tofile='scripts/run.py'))
(W/'artifacts/diffs/run.patch').write_text(diff)
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,exclusive_executor_lock=True,network_namespace=os.readlink('/proc/self/ns/net'),probes=probes),indent=2)+'\n')
out=dict(status='PASS',members=198,origins=196,source_files=17,public_inputs=len(provenance),member_bytes=4277189,all_pins_match=True,exact_scope=True,source_changed=False,inherited_modules=order)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
