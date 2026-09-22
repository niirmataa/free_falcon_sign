import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
ID='FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001';REPO=Path('/home/footfalcon/free_falcon_sign');W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H6P_REFERENCE_BAD_EVENT_2026-09-22.md');CURRENT=REPO/'proofs/ft1536/CURRENT_TASK.md'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert W==REPO/'proofs/ft1536/work'/ID and not (W/'OUTPUTS.sha256').exists()
assert sha(TASK)=='cdaa0ed0ce877774e5ba914329d6ceb71b7df756152ab47c8c2006d47683c9c7'
assert sha(I/'MANIFEST.sha256')=='4e66e844d425ab9cd8cc6441f4852101f48acfcc178de0d6988f0ec785e42369'
ct=CURRENT.read_text();assert ID in ct and str(W) in ct and str(TASK) in ct and '22e6dd41507a0e990b584dad8d1f4c8834d4c289' in ct and sha(TASK) in ct and sha(I/'MANIFEST.sha256') in ct
assert ID in (W/'AGENTS.md').read_text() and ID in TASK.read_text()
rows={}
for p in I.rglob('*'):assert not p.is_symlink()
for s in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=s.split('  ',1);q=PurePosixPath(r);assert not q.is_absolute() and '..' not in q.parts and str(q)==r and r not in rows and re.fullmatch('[0-9a-f]{64}',h);assert sha(I/r)==h;rows[r]=h
assert len(rows)==1144 and set(p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file())==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert orig['base_commit']=='22e6dd41507a0e990b584dad8d1f4c8834d4c289' and len(orig['files'])==1142 and len({r['copy'] for r in orig['files']})==1142
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes'] and r['original'].startswith('git:')
assert sum((I/r).stat().st_size for r in rows)==26388316
for name,h in re.findall(r'\| ([A-Za-z0-9_./-]+) \| `([a-f0-9]{64})` \|',TASK.read_text()):assert sha(I/name)==h,(name,h)
src={p:h for h,p in (s.split('  ',1) for s in (I/'CANDIDATE.sha256').read_text().splitlines())};assert len(src)==17 and set(p.name for p in (I/'source').iterdir())==set(src)
for n,h in src.items():assert sha(I/'source'/n)==h
mounts=[s.split() for s in Path('/proc/self/mountinfo').read_text().splitlines()];probes=[]
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(I/'source/falcon-sign.c',False),(REPO/'AGENTS.md',False),(CURRENT,False),(TASK,False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;outcome='writable_no_write'
 except OSError as e:assert not write and e.errno in [errno.EROFS,errno.EACCES];outcome=errno.errorcode[e.errno]
 cover=max((f for f in mounts if str(p)==f[4] or str(p).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));assert ('rw' if write else 'ro') in cover[5].split(',');probes.append(dict(path=str(p),outcome=outcome,mount=cover[4],options=cover[5]))
assert os.readlink('/proc/self/ns/net')!=os.environ['FT1536_HOST_NET_NS']
cover=max((f for f in mounts if str(W)==f[4] or str(W).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));fstype=cover[cover.index('-')+1];assert fstype not in ['tmpfs','ramfs']
disk=shutil.disk_usage(W);assert disk.free>2*1024**3
for r in ['source','formal','checks','bin','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for n,h in src.items():
 if not (W/'source'/n).exists():shutil.copyfile(I/'source'/n,W/'source'/n)
 assert sha(W/'source'/n)==h
prov=[dict(path=str(I/r),copy='inputs/bootstrap/'+r,sha256=h) for r,h in rows.items()]+[dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256'))]
for p,r in [(TASK,'TASK.md'),(W/'AGENTS.md','inputs/context/work_agents.md'),(REPO/'AGENTS.md','inputs/context/repo_agents.md'),(CURRENT,'inputs/context/CURRENT_TASK.md')]:shutil.copyfile(p,W/r);prov.append(dict(path=str(p),copy=r,sha256=sha(p)))
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in prov));(W/'inputs/provenance.json').write_text(json.dumps(prov,indent=2)+'\n');reuse=[]
for n in ['lean','dyadic','fp_literal','replaylib','literal_backend','half_model','backend','toolchain','root_model','post_model','ordered_model','archive_attempt']:
 p=I/'JOINT/scripts'/(n+'.py');dst=W/'scripts'/(n+'.py');shutil.copyfile(p,dst);reuse.append(dict(input=p.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
(W/'artifacts/diffs/run.patch').write_text(''.join(difflib.unified_diff((I/'JOINT/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='inputs/bootstrap/JOINT/scripts/run.py',tofile='scripts/run.py')))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(task_id=ID,only_W_writable=True,bootstrap_readonly=True,network_isolated=True,persistent_filesystem=fstype,disk_free_bytes=disk.free,probes=probes),indent=2)+'\n')
out=dict(status='PASS_ACTIVE_TASK_PINS_EXACT_BOOTSTRAP_AND_SANDBOX',task_id=ID,members=1144,origins=1142,member_bytes=26388316,public_inputs=len(prov),source_files=17,all_task_pins_match=True,current_task_agrees=True,source_changed=False,persistent_filesystem=fstype,disk_free_bytes=disk.free)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
