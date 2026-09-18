import hashlib,json,os,stat,subprocess,sys
from pathlib import Path
W=Path.cwd();dest=Path(sys.argv[1]).absolute()
assert '..' not in dest.parts and dest.is_relative_to(W/'tmp') and dest.parent.is_dir() and not dest.exists()
assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in dest.parents)
if (W/'OUTPUTS.sha256').exists():
    raw=(W/'OUTPUTS.sha256').read_bytes();assert len(sys.argv)==3 and hashlib.sha256(raw).hexdigest()==sys.argv[2]
    for line in raw.decode().splitlines():
        digest,rel=line.split(maxsplit=1);p=Path(rel);assert not p.is_absolute() and '..' not in p.parts
        src=W/p;assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [src,*src.parents]);assert hashlib.sha256(src.read_bytes()).hexdigest()==digest
else:assert len(sys.argv)==2
dest.mkdir()
for name in ['source','inputs','scripts','formal','artifacts','bin','tmp','cache','logs']:(dest/name).mkdir()
for root in ['source','inputs','scripts','formal']:
    for base,dirs,files in os.walk(W/root,followlinks=False):
        for d in dirs:assert not (Path(base)/d).is_symlink()
        if Path(base)==W/'inputs' and 'slices' in dirs:dirs.remove('slices')
        for name in files:
            src=Path(base)/name;assert stat.S_ISREG(src.lstat().st_mode) and not src.is_symlink()
            if src==W/'formal/Tables.lean':continue  # regenerated from the new C table dump
            target=dest/src.relative_to(W);target.parent.mkdir(parents=True,exist_ok=True)
            with target.open('xb') as f:f.write(src.read_bytes())
(dest/'COMMANDS.log').touch()
sage='/home/footfalcon/.local/bin/sage';lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
steps=[(60,['python3','-B','scripts/bind.py']),(120,[lean,'formal/Words.lean']),
 (60,['python3','-B','scripts/build.py','base','normal']),
 (30,['bin/base-normal','tables','artifacts/tables_C.json']),
 (30,['bin/base-normal','division','artifacts/division_C.csv']),
 (120,[sage,'scripts/certify.py','constants']),(120,[sage,'scripts/certify.py','fixtures']),
 (30,['bin/base-normal','primitives','fixtures/primitive_pairs.txt','artifacts/primitives_C.csv']),
 (90,[sage,'scripts/certify.py','primitives','artifacts/primitives_C.csv','artifacts/primitive_check.json']),
 (60,['python3','-B','scripts/export_tables.py']),(240,[lean,'formal/Tables.lean']),
 (90,[lean,'formal/Linear.lean']),(90,[lean,'formal/Composition.lean']),
 (240,['python3','-B','scripts/test_suite.py']),(90,['python3','-B','scripts/audit.py'])]
for i,(limit,argv) in enumerate(steps):
    p=subprocess.run(['python3','-B','scripts/run.py',str(limit),*argv],cwd=dest,capture_output=True)
    for key,value in [('stdout',p.stdout),('stderr',p.stderr)]:(dest/'logs'/('replay_parent_'+str(i)+'.'+key)).write_bytes(value)
    print(json.dumps({'cwd':str(dest),'argv':argv,'exit_code':p.returncode}),flush=True)
    if p.returncode:print(p.stdout.decode(errors='replace'));print(p.stderr.decode(errors='replace'));raise SystemExit(p.returncode)
paths=['artifacts/source_binding.json','artifacts/tables_C.json','artifacts/division_C.csv','artifacts/primitives_C.csv',
       'artifacts/constants_certificate.json','artifacts/kernel_literals.json','formal/Tables.lean',
       'formal/Words.lean','formal/Linear.lean','formal/Composition.lean','artifacts/primitive_check.json','artifacts/test_suite.json']
paths += [str(p.relative_to(W)) for p in sorted((W/'artifacts/pipelines').glob('*.json'))]
matches=[]
for rel in paths:
    digest=hashlib.sha256((W/rel).read_bytes()).hexdigest();assert hashlib.sha256((dest/rel).read_bytes()).hexdigest()==digest,rel
    matches.append(dict(path=rel,sha256=digest))
out=dict(status='FRESH_REPLAY_PASS',destination=str(dest),matches=matches,anchor=sys.argv[2] if len(sys.argv)==3 else 'PRE_FREEZE_REHEARSAL',
         main_claim_still='PARTIAL_PROOF',source_overwritten=False)
with (dest/'REPLAY_RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps({'status':out['status'],'identical_semantic_files':len(matches),'main_claim':out['main_claim_still']},indent=2))
