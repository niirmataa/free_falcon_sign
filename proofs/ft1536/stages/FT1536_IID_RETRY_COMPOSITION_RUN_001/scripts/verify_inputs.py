"""Local pinned-input validation, including replay without original paths."""
import errno,json,os,re
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';pin='daa95bc07516271ff897f95af11b3c90950ccb1a7dc20f0f3da5e994785a46b8'
rows=verify_manifest(I,'MANIFEST.sha256',pin);assert len(rows)==1270
assert all(not p.is_symlink() for p in I.rglob('*'))
assert {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
assert sum((I/r).stat().st_size for r in rows)==28214575
orig=json.loads((I/'ORIGINS.json').read_text());assert orig['base_commit']=='1ba7ae07c17d135fc8eff4aac7b56f8c2b3bc88c' and len(orig['files'])==1268
assert len({r['copy'] for r in orig['files']})==1268
for r in orig['files']:assert r['original'].startswith('git:') and rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
assert sha(W/'TASK.md')=='f773b8f31f7d307850ee3d1eb948bb05ceacee5589d5c4971e3eaee34c5bed97'
for n,h in re.findall(r'\| ([A-Za-z0-9_./-]+) \| `([a-f0-9]{64})` \|',(W/'TASK.md').read_text()):assert sha(I/n)==h
src={r:h for h,r in (s.split('  ',1) for s in (I/'CANDIDATE.sha256').read_text().splitlines())}
assert len(src)==17 and {p.name for p in (W/'source').iterdir()}==set(src)
for n,h in src.items():assert sha(W/'source'/n)==sha(I/'source'/n)==h
prov=json.loads((W/'inputs/provenance.json').read_text());assert len(prov)==1275
for r in prov:assert sha(W/r['copy'])==r['sha256']
assert (W/'INPUTS.sha256').read_text()==''.join(r['sha256']+'  '+r['path']+'\n' for r in prov)
for r in json.loads((W/'artifacts/reuse.json').read_text()):assert sha(W/r['copy'])==sha(W/r['input'])==r['sha256']
env={k:os.environ[k] for k in ['HOME','TMPDIR','DOT_SAGE','XDG_CACHE_HOME','LEAN_PATH']}
assert all(Path(v).is_relative_to(W) for v in env.values())
assert os.readlink('/proc/self/ns/net')!=os.environ['FT1536_HOST_NET_NS']
for p in [I/'MANIFEST.sha256',W/'source/falcon-sign.c']:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);raise AssertionError('input writable')
 except OSError as e:assert e.errno in [errno.EROFS,errno.EACCES]
original=os.environ.get('FT1536_REPLAY_ORIGINAL')
if original:assert not (Path(original)/'TASK.md').exists() and not (Path(original)/'source/falcon-sign.c').exists()
assert '-DSIGN_MAX_ATTEMPTS=16' in (W/'source/Makefile').read_text()
out=dict(status='PASS_EXACT_LOCAL_INPUTS_AND_SOURCE_PINS',bootstrap_members=1270,Git_origins=1268,bootstrap_bytes=28214575,public_inputs=1275,source_files=17,task_sha256=sha(W/'TASK.md'),bootstrap_sha256=pin,source_manifest_sha256=sha(I/'CANDIDATE.sha256'),original_paths_not_needed=True)
(W/'artifacts/input_validation.json').write_text(json.dumps(out,indent=2)+'\n')
(W/'artifacts/validation_environment.json').write_text(json.dumps(dict(cwd=str(W),environment=env,original_hidden=bool(original),network_off=True,inputs_readonly=True),indent=2)+'\n')
print(out['status'])
