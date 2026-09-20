import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_FPEMU_FLOOR_CT_2026-09-20.md')
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_FLOOR_CT_RUN_001')
assert sha(TASK)=='192b840e7b85937317c25897b3d211aab8716638a4bb65af9a64e55ce356e32e'
assert sha(I/'MANIFEST.sha256')=='2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c'
for p in I.rglob('*'):assert not p.is_symlink()
rows={}
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=line.split('  ',1);p=PurePosixPath(r)
 assert not p.is_absolute() and '..' not in p.parts and str(p)==r and r not in rows and re.fullmatch('[a-f0-9]{64}',h)
 assert sha(I/r)==h;rows[r]=h
assert len(rows)==382 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==381 and orig['base_commit']=='20ed84a86d9374b026e2ea9ab78f7656a6650a8c'
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
assert sum((I/r).stat().st_size for r in rows)==59892355
probes=[]
mounts=[]
for line in Path('/proc/self/mountinfo').read_text().splitlines():
 f=line.split();mounts.append(dict(mount=f[4],options=f[5].split(',')))
def covering(p):
 return max((m for m in mounts if str(p)==m['mount'] or str(p).startswith(m['mount'].rstrip('/')+'/')),key=lambda m:len(m['mount']))
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),False),(TASK,False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;result='writable_no_bytes_written'
 except OSError as e:assert not write and e.errno in [errno.EROFS,errno.EACCES];result=errno.errorcode[e.errno]
 m=covering(p);assert ('rw' if write else 'ro') in m['options']
 probes.append(dict(path=str(p),result=result,covering_mount=m))
for r in ['baseline/source','candidate/source','formal','checks','bin','harness','vendor','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for p in (I/'source').iterdir():
 assert p.is_file()
 for r in ['baseline/source','candidate/source']:shutil.copyfile(p,W/r/p.name);assert sha(p)==sha(W/r/p.name)
assert sha(I/'CANDIDATE.sha256')=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,r=line.split('  ',1);assert sha(W/'baseline/source'/r)==h
for folder,names in [('vendor',['dudect.h','LICENSE','README.md']),('harness',['benchmark.c','targets.c'])]:
 for name in names:shutil.copyfile(I/folder/name,W/folder/name);assert sha(W/folder/name)==rows[folder+'/'+name]
shutil.copyfile(I/'checks/fpemu_smoke.c',W/'checks/fpemu_smoke.c')
provenance=[dict(path=str(I/r),copy='inputs/bootstrap/'+r,sha256=h) for r,h in rows.items()]
provenance.append(dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256')))
for p,r in [(TASK,'TASK.md'),(W/'AGENTS.md','inputs/context/work_agents.md'),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),'inputs/context/repo_agents.md')]:
 shutil.copyfile(p,W/r);provenance.append(dict(path=str(p),copy=r,sha256=sha(p)))
with (W/'INPUTS.sha256').open('x') as f:
 for r in provenance:f.write(r['sha256']+'  '+r['path']+'\n')
(W/'inputs/provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
reuse=[]
for name in ['lean','dyadic','fp_literal','replaylib']:
 src=I/'ZERO/scripts'/(name+'.py');dst=W/'scripts'/(name+'.py');shutil.copyfile(src,dst)
 reuse.append(dict(input=str(src.relative_to(W)),copy=str(dst.relative_to(W)),sha256=sha(dst),byte_identical=True))
shutil.copyfile(I/'harness/campaign.py',W/'scripts/dudect_mechanics.py')
reuse.append(dict(input='inputs/bootstrap/harness/campaign.py',copy='scripts/dudect_mechanics.py',sha256=sha(W/'scripts/dudect_mechanics.py'),byte_identical=True,usage='selected public metadata/order helpers; original8h main never invoked'))
order=[]
def visit(mod):
 if mod in order:return
 src=I/'ZERO/formal'/(mod+'.lean');assert sha(src)==rows['ZERO/formal/'+mod+'.lean']
 for dep in re.findall(r'^import (\w+)',src.read_text(),re.M):
  if (I/'ZERO/formal'/(dep+'.lean')).exists():visit(dep)
 dst=W/'formal'/(mod+'.lean');shutil.copyfile(src,dst);order.append(mod)
 reuse.append(dict(input=str(src.relative_to(W)),copy=str(dst.relative_to(W)),sha256=sha(dst),byte_identical=True))
visit('SourceFloor')
(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
diff=''.join(difflib.unified_diff((I/'ZERO/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='bootstrap/ZERO/scripts/run.py',tofile='scripts/run.py'))
(W/'artifacts/diffs/run.patch').write_text(diff)
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,exclusive_executor_lock=True,probes=probes),indent=2)+'\n')
out=dict(members=len(rows),origins=381,source_files=17,public_inputs=len(provenance),member_bytes=59892355,max_member_bytes=max((I/r).stat().st_size for r in rows),all_pins_match=True,exact_scope=True,inherited_order=order)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
