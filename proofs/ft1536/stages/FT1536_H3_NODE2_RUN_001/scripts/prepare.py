import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_NODE2_2026-09-19.md')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_NODE2_RUN_001')
assert sha(TASK)=='f4a28c97adde1a2cbc26b4274086d0db171c9e5cbf3eb607e4464d511d583900'
assert sha(I/'MANIFEST.sha256')=='f92dbaa6f4262f2cce5d4bd27e002da0f684f87a92fef8619bee226221782178'
for p in I.rglob('*'):assert not p.is_symlink()
rows={}
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=line.split('  ',1);p=PurePosixPath(r)
 assert not p.is_absolute() and '..' not in p.parts and str(p)==r and r not in rows and re.fullmatch('[a-f0-9]{64}',h)
 assert sha(I/r)==h;rows[r]=h
assert len(rows)==120 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==118 and orig['base_commit']=='afa52d89be2f21208ac3135e74a1a60fc66d52c4'
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
probes=[]
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),False),(TASK,False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;result='writable_no_bytes_written'
 except OSError as e:assert not write and e.errno==errno.EROFS;result='EROFS'
 probes.append(dict(path=str(p),result=result))
for r in ['source','formal','checks','bin','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for p in (I/'source').iterdir():assert p.is_file();shutil.copyfile(p,W/'source'/p.name);assert sha(p)==sha(W/'source'/p.name)
assert sha(I/'CANDIDATE.sha256')=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,r=line.split('  ',1);assert sha(W/'source'/r)==h
provenance=[dict(path=str(I/r),copy='inputs/bootstrap/'+r,sha256=h) for r,h in rows.items()]
provenance.append(dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256')))
for p,r in [(TASK,'inputs/context/task.md'),(W/'AGENTS.md','inputs/context/work_agents.md'),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),'inputs/context/repo_agents.md')]:
 shutil.copyfile(p,W/r);provenance.append(dict(path=str(p),copy=r,sha256=sha(p)))
with (W/'INPUTS.sha256').open('x') as f:
 for r in provenance:f.write(r['sha256']+'  '+r['path']+'\n')
(W/'inputs/provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
reuse=[]
for name in ['lean','dyadic','fp_literal','replaylib','backend','root_model','node_model','toolchain']:
 src=I/'NODE3/scripts'/(name+'.py');dst=W/'scripts'/(name+'.py');shutil.copyfile(src,dst)
 reuse.append(dict(input=str(src.relative_to(W)),copy=str(dst.relative_to(W)),sha256=sha(dst),byte_identical=True))
order=[]
def visit(mod):
 if mod in order:return
 src=I/'NODE3/formal'/(mod+'.lean');assert sha(src)==rows['NODE3/formal/'+mod+'.lean']
 for dep in re.findall(r'^import (\w+)',src.read_text(),re.M):
  if (I/'NODE3/formal'/(dep+'.lean')).exists():visit(dep)
 dst=W/'formal'/(mod+'.lean');shutil.copyfile(src,dst);order.append(mod)
 reuse.append(dict(input=str(src.relative_to(W)),copy=str(dst.relative_to(W)),sha256=sha(dst),byte_identical=True))
visit('NodeConstants');visit('NodeFrame')
(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n')
(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
diff=''.join(difflib.unified_diff((I/'NODE3/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='bootstrap/NODE3/scripts/run.py',tofile='scripts/run.py'))
(W/'artifacts/diffs/run.patch').write_text(diff)
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,exclusive_executor_lock=True,probes=probes),indent=2)+'\n')
out=dict(members=len(rows),originals=118,source_files=17,public_inputs=len(provenance),all_pins_match=True,exact_scope=True,inherited_order=order)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
