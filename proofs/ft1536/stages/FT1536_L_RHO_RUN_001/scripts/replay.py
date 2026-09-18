"""Rebuild in an absent directory under this bundle's tmp; preserve source run."""
import hashlib,json,os,stat,subprocess,sys
from pathlib import Path
W=Path.cwd();dest=Path(sys.argv[1]).absolute()
assert '..' not in dest.parts and dest.is_relative_to(W/'tmp') and dest.parent.is_dir() and not dest.exists()
assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in dest.parents)
if (W/'OUTPUTS.sha256').exists():
    raw=(W/'OUTPUTS.sha256').read_bytes();assert len(sys.argv)==3 and hashlib.sha256(raw).hexdigest()==sys.argv[2]
    for line in raw.decode().splitlines():
        h,rel=line.split(maxsplit=1);p=Path(rel);assert not p.is_absolute() and '..' not in p.parts
        path=W/p;assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [path,*path.parents])
        assert hashlib.sha256(path.read_bytes()).hexdigest()==h
else:assert len(sys.argv)==2
dest.mkdir()
for name in ['reference','candidate','inputs','scripts','formal','artifacts','bin','tmp','cache','logs']:(dest/name).mkdir()
for root in ['reference','candidate','inputs','scripts','formal']:
    for base,dirs,files in os.walk(W/root,followlinks=False):
        for d in dirs:assert not (Path(base)/d).is_symlink()
        for name in files:
            p=Path(base)/name;assert stat.S_ISREG(p.lstat().st_mode) and not p.is_symlink()
            t=dest/p.relative_to(W);t.parent.mkdir(parents=True,exist_ok=True)
            with t.open('xb') as f:f.write(p.read_bytes())
(dest/'COMMANDS.log').touch()
commands=[['python3','-B','scripts/bind.py'],
 ['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','formal/Rho.lean'],
 ['python3','-B','scripts/build.py','enum','candidate','normal'],
 ['bin/enum-candidate-normal','artifacts/scalar-candidate-normal.csv'],
 ['python3','-B','scripts/scalar_suite.py'],['python3','-B','scripts/regression_suite.py'],
 ['python3','-B','scripts/audit.py']]
for cmd in commands:
    limit=240 if any(x.endswith('_suite.py') for x in cmd) else 90
    p=subprocess.run(['python3','-B','scripts/run.py',str(limit),*cmd],cwd=dest,capture_output=True)
    tag='replay_parent_'+str(commands.index(cmd))
    for k,b in [('stdout',p.stdout),('stderr',p.stderr)]:
        (dest/'logs'/(tag+'.'+k)).write_bytes(b)
    print(json.dumps({'cwd':str(dest),'argv':cmd,'exit_code':p.returncode}),flush=True)
    if p.returncode:print(p.stdout.decode());print(p.stderr.decode());raise SystemExit(p.returncode)
matches=[]
for rel in ['candidate.patch','CANDIDATE.sha256','artifacts/source_binding.json','formal/Rho.lean',
            'artifacts/scalar-candidate-normal.csv','artifacts/scalar-candidate-normal.json',
            'artifacts/regression_check.json','fixtures/positive.json']:
    h=hashlib.sha256((W/rel).read_bytes()).hexdigest();assert hashlib.sha256((dest/rel).read_bytes()).hexdigest()==h,rel
    matches.append(dict(path=rel,sha256=h))
for path in sorted((W/'artifacts/regressions').glob('*.json')):
    if '.attempt' in path.name:continue
    rel=str(path.relative_to(W));h=hashlib.sha256(path.read_bytes()).hexdigest()
    assert hashlib.sha256((dest/rel).read_bytes()).hexdigest()==h,rel
    matches.append(dict(path=rel,sha256=h))
out=dict(status='FRESH_REPLAY_PASS',destination=str(dest),matches=matches,anchor=sys.argv[2] if len(sys.argv)==3 else 'PRE_FREEZE_REHEARSAL')
with (dest/'REPLAY_RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps({'status':out['status'],'identical_files':len(matches)},indent=2))
