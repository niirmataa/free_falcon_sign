import difflib,errno,hashlib,json,os,re,shutil
from pathlib import Path,PurePosixPath
W=Path.cwd();I=W/'inputs/bootstrap';TASK=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ROOT_LDL_2026-09-19.md')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert W==Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ROOT_LDL_RUN_001')
assert sha(TASK)=='792e4f012e3fd2c0a744d1d6cd8449858386f1c19958c6a8a4ceabdeca561693'
assert sha(I/'MANIFEST.sha256')=='f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73'
rows={}
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,r=line.split('  ',1);p=PurePosixPath(r)
 assert not p.is_absolute() and '..' not in p.parts and str(p)==r and r not in rows and re.fullmatch('[a-f0-9]{64}',h)
 assert sha(I/r)==h;rows[r]=h
for p in I.rglob('*'):assert not p.is_symlink()
assert len(rows)==106 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==104 and orig['base_commit']=='9a76ecfd72d83e131d79299f0249bca1efdf9468'
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
probes=[]
for p,write in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(Path('/home/footfalcon/free_falcon_sign/AGENTS.md'),False),(TASK,False)]:
 try:
  fd=os.open(p,os.O_WRONLY);os.close(fd);assert write;result='writable_no_bytes_written'
 except OSError as e:assert not write and e.errno==errno.EROFS;result='EROFS'
 probes.append(dict(path=str(p),result=result))
for r in ['source','formal','checks','bin','inputs/context','artifacts/diffs']:(W/r).mkdir(parents=True,exist_ok=True)
for p in (I/'source').iterdir():
 assert p.is_file();shutil.copyfile(p,W/'source'/p.name);assert sha(p)==sha(W/'source'/p.name)
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
for name in ['lean','dyadic','fp_literal','replaylib']:
 src=I/'ZERO/scripts'/(name+'.py');dst=W/'scripts'/(name+'.py');shutil.copyfile(src,dst)
 reuse.append(dict(input=str(src.relative_to(W)),copy=str(dst.relative_to(W)),sha256=sha(dst),byte_identical=True))
# Only the actually consumed ZERO integer dependencies; no carried olean.
for name in ['Floor','ValueDomain','BitErrors','PackOf']:
 src=I/'ZERO/formal'/(name+'.lean');dst=W/'formal'/(name+'.lean');shutil.copyfile(src,dst)
 reuse.append(dict(input=str(src.relative_to(W)),copy=str(dst.relative_to(W)),sha256=sha(dst),byte_identical=True))
diff=''.join(difflib.unified_diff((I/'ZERO/scripts/run.py').read_text().splitlines(True),(W/'scripts/run.py').read_text().splitlines(True),fromfile='bootstrap/ZERO/scripts/run.py',tofile='scripts/run.py'))
(W/'artifacts/diffs/run.patch').write_text(diff)
(W/'artifacts/reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,exclusive_executor_lock=True,probes=probes),indent=2)+'\n')
out=dict(members=len(rows),originals=104,source_files=17,public_inputs=len(provenance),all_pins_match=True,exact_scope=True)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
