import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ORDERED_JOINT_KERNEL_2026-09-21.md');BASE='64af4cbd4280f45f28f8f160b7ebdacebdf29734'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001')
assert sha(TASK)=='35e7ccd932be795569a7464a55bbbf2c85e3fe9c0919f9220e0d92bbf796be61'
assert sha(I/'MANIFEST.sha256')=='90f866ed86bf3d8b95903a666338f7b659bbd4cf519f27abba2f63708fa11a87'
rows={}
for p in I.rglob('*'):assert not p.is_symlink()
for s in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=s.split('  ',1);q=PurePosixPath(r);assert not q.is_absolute() and '..' not in q.parts and str(q)==r and r not in rows and re.fullmatch('[0-9a-f]{64}',h);assert sha(I/r)==h;rows[r]=h
assert len(rows)==755 and set(p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file())==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert orig['base_commit']==BASE and len(orig['files'])==753 and len({r['copy'] for r in orig['files']})==753
assert set(r['copy'] for r in orig['files'])==set(rows)-{'README.md','ORIGINS.json'}
for r in orig['files']:
 assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes'] and r['original'].startswith('git:'+BASE+':')
 q=PurePosixPath(r['original'].split(':',2)[2]);assert not q.is_absolute() and '..' not in q.parts
assert sum((I/r).stat().st_size for r in rows)==18250111
for name,h in re.findall(r'\| ([A-Za-z0-9_./-]+) \| `([a-f0-9]{64})` \|',TASK.read_text()):assert sha(I/name)==h,(name,h)
src={p:h for h,p in (s.split('  ',1) for s in (I/'CANDIDATE.sha256').read_text().splitlines())};assert len(src)==17 and set(p.name for p in (I/'source').iterdir())==set(src)
for n,h in src.items():assert sha(I/'source'/n)==h
mounts=[s.split() for s in Path('/proc/self/mountinfo').read_text().splitlines()];probes=[]
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(I/'source/falcon-sign.c',False),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),False),(TASK,False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;outcome='writable_no_write'
 except OSError as e:assert not write and e.errno in [errno.EROFS,errno.EACCES];outcome=errno.errorcode[e.errno]
 cover=max((f for f in mounts if str(p)==f[4] or str(p).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));assert ('rw' if write else 'ro') in cover[5].split(',');probes.append(dict(path=str(p),outcome=outcome,mount=cover[4],options=cover[5]))
assert os.readlink('/proc/self/ns/net')!=os.environ['FT1536_HOST_NET_NS']
cover=max((f for f in mounts if str(W)==f[4] or str(W).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));fstype=cover[cover.index('-')+1];assert fstype not in ['tmpfs','ramfs']
for r in ['source','formal','checks','bin','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for n,h in src.items():
 if not (W/'source'/n).exists():shutil.copyfile(I/'source'/n,W/'source'/n)
 assert sha(W/'source'/n)==h
prov=[dict(path=str(I/r),copy='inputs/bootstrap/'+r,sha256=h) for r,h in rows.items()]+[dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256'))]
for p,r in [(TASK,'TASK.md'),(W/'AGENTS.md','inputs/context/work_agents.md'),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),'inputs/context/repo_agents.md')]:shutil.copyfile(p,W/r);prov.append(dict(path=str(p),copy=r,sha256=sha(p)))
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in prov));(W/'inputs/provenance.json').write_text(json.dumps(prov,indent=2)+'\n');reuse=[]
for n in ['lean','dyadic','fp_literal','replaylib','literal_backend','half_model','backend','toolchain','kernel_model','archive_attempt']:
 p=I/'GAUSS/scripts'/(n+'.py');dst=W/'scripts'/(n+'.py');shutil.copyfile(p,dst);reuse.append(dict(input=p.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
(W/'artifacts/diffs/run.patch').write_text(''.join(difflib.unified_diff((I/'GAUSS/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='inputs/bootstrap/GAUSS/scripts/run.py',tofile='scripts/run.py')))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(only_W_writable=True,bootstrap_readonly=True,network_isolated=True,persistent_filesystem=fstype,probes=probes),indent=2)+'\n')
out=dict(status='PASS_TASK_BOOTSTRAP_EXACT_SCOPE_AND_DURABLE_SANDBOX',members=755,origins=753,member_bytes=18250111,public_inputs=len(prov),source_files=17,all_task_pins_match=True,origins_verified='exact copy set, byte sizes and hashes, safe git paths at pinned BASE; metadata authenticated by external bootstrap hash; no Git command or origin fetch',source_changed=False,network_isolated=True,persistent_filesystem=fstype)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
