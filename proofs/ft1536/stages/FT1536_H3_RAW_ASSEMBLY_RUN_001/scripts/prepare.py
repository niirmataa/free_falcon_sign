import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_RAW_ASSEMBLY_2026-09-20.md')
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_RAW_ASSEMBLY_RUN_001')
assert sha(TASK)=='f667184425ee1b00d19d9a5fde757b66b607ff698dd611245b1a361174f7bf1f'
assert sha(I/'MANIFEST.sha256')=='5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4'
for p in I.rglob('*'):assert not p.is_symlink()
rows={}
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=line.split('  ',1);p=PurePosixPath(r)
 assert not p.is_absolute() and '..' not in p.parts and str(p)==r and r not in rows and re.fullmatch('[a-f0-9]{64}',h)
 assert sha(I/r)==h;rows[r]=h
assert len(rows)==308 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==306 and orig['base_commit']=='6ed89cac3249bdfe6d874c6616fd2899f4b3ef6a'
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
assert sum((I/r).stat().st_size for r in rows)==5907504
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
(W/'inputs/provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
reuse=[]
for n in ['lean','dyadic','fp_literal','replaylib']:
 src=I/'TOWER/scripts'/(n+'.py');dst=W/'scripts'/(n+'.py');shutil.copyfile(src,dst)
 reuse.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
for src in sorted((I/'TOWER/formal').glob('*.lean')):
 dst=W/'formal'/src.name;shutil.copyfile(src,dst);reuse.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
diff=''.join(difflib.unified_diff((I/'TOWER/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='inputs/bootstrap/TOWER/scripts/run.py',tofile='scripts/run.py'))
(W/'artifacts/diffs/run.patch').write_text(diff)
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,exclusive_executor_lock=True,network_namespace=os.readlink('/proc/self/ns/net'),network_interfaces=sorted(p.name for p in Path('/sys/class/net').iterdir()),probes=probes),indent=2)+'\n')
out=dict(status='PASS',members=308,origins=306,source_files=17,public_inputs=len(provenance),member_bytes=5907504,all_pins_match=True,exact_scope=True,source_changed=False)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
