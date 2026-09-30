#!/usr/bin/env python3
"""Independent read-only replay of the relocated MiMo package in our own W.
The author's guarded alternate-root runner is preserved, not edited/run with
weakened guards. This controller has the reviewer's own W-only path policy.
"""
import argparse,hashlib,json,os,re,resource,shutil,subprocess,time
from pathlib import Path
from datetime import datetime,timezone
W=Path(__file__).resolve().parent.parent
ap=argparse.ArgumentParser()
ap.add_argument('--source',default=str(W.parent/'FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/output'))
ap.add_argument('--pin',default='6f0d4f42f1a71526070864f162252e4105d012786104d50ef1ed16eca7975e7f')
ap.add_argument('--review',default='GAME_BINDING_REVIEW_001')
args=ap.parse_args()
assert re.fullmatch(r'GAME_BINDING_REVIEW_[0-9]+',args.review)
assert re.fullmatch(r'[a-f0-9]{64}',args.pin)
S=Path(args.source).resolve();D=W/'run'/args.review/'replay_001';PIN=args.pin
def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1048576),b''):h.update(b)
    return h.hexdigest()
def verify():
    assert sha(S/'OUTPUTS.sha256')==PIN
    names=set()
    for line in (S/'OUTPUTS.sha256').read_text().splitlines():
        h,n=line.split(maxsplit=1)
        assert n not in names and not Path(n).is_absolute() and '..' not in Path(n).parts
        names.add(n);p=S/n
        assert p.is_file() and not p.is_symlink() and p.resolve().is_relative_to(S.resolve())
        assert sha(p)==h,n
    return len(names)
members=verify()
assert not D.exists() and D.resolve().is_relative_to(W.resolve()) and not D.is_relative_to(S)
original_source=S
snapshot=D.parent/('source_snapshot_'+PIN[:8])
snapshot.mkdir(parents=True,exist_ok=False)
for line in (S/'OUTPUTS.sha256').read_text().splitlines():
    _,name=line.split(maxsplit=1)
    target=snapshot/name;target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(S/name,target)
shutil.copyfile(S/'OUTPUTS.sha256',snapshot/'OUTPUTS.sha256')
shutil.copyfile(S/'HANDOFF.md',snapshot/'AUTHOR_HANDOFF.md')
assert members==verify()
S=snapshot
assert members==verify()
closure=json.loads((S/'LIBRARY_CLOSURE.json').read_text())
for item in closure['modules']:
    root=closure['roots'][item['library']]
    p=Path(root['source'])/(item['module'].replace('.','/')+'.lean')
    assert p.is_file() and sha(p)==item['source_sha256'],('library source',item['module'])
    for art in item['artifacts']:assert sha(Path(root['build'])/art['path'])==art['sha256']
print('INTAKE_PASS',members,'members;',len(closure['modules']),'library modules',flush=True)
D.mkdir(parents=True)
for sub in ['logs','home','tmp','cache','work','lib']:(D/sub).mkdir()
shutil.copytree(S/'formal',D/'formal');shutil.copytree(S/'sage',D/'sage')
tc=json.loads((S/'TOOLCHAIN.json').read_text());build=json.loads((S/'BUILD.json').read_text())
lean=tc['lean']['executable'];sage=tc['sage']['launcher']
assert sha(Path(lean))==tc['lean']['sha256'];assert sha(Path(sage))==tc['sage']['launcher_sha256']
env=os.environ.copy();env.update(HOME=str(D/'home'),TMPDIR=str(D/'tmp'),TMP=str(D/'tmp'),TEMP=str(D/'tmp'),
    DOT_SAGE=str(D/'home/.sage'),XDG_CACHE_HOME=str(D/'cache'),MPLCONFIGDIR=str(D/'cache/mpl'),
    OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1',
    LEAN_PATH=':'.join([str(D/'lib')]+[r['build'] for r in closure['roots'].values() if r.get('build')]))
jobs=[]
def step(name,argv,cwd):
    out=D/'logs'/(name+'.stdout');err=D/'logs'/(name+'.stderr')
    sandbox=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--ro-bind','/','/',
        '--dev-bind','/dev','/dev','--bind',str(D),str(D),'--bind',str(D/'tmp'),'/tmp',
        '--chdir',str(cwd),'/usr/bin/prlimit','--as=12884901888','--']
    start=datetime.now(timezone.utc).isoformat();t=time.monotonic()
    with out.open('wb') as fo,err.open('wb') as fe:
        try:rc=subprocess.run(sandbox+argv,stdout=fo,stderr=fe,env=env,timeout=1800).returncode
        except subprocess.TimeoutExpired:rc=124
    rec=dict(name=name,argv=argv,sandbox=sandbox,cwd=str(cwd),start=start,
        elapsed_s=round(time.monotonic()-t,3),exit_code=rc,
        stdout=str(out.relative_to(D)),stdout_sha256=sha(out),stderr=str(err.relative_to(D)),stderr_sha256=sha(err),
        maxrss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
    (D/'logs'/(name+'.receipt.json')).write_text(json.dumps(rec,indent=2)+'\n');jobs.append(rec)
    (D/'EXECUTION_RECEIPTS.json').write_text(json.dumps(jobs,indent=2)+'\n')
    print(name,rc,rec['elapsed_s'],flush=True)
    assert rc==0,(name,rc)
    assert not err.read_bytes(),('stderr',name)
    assert 'warning:' not in out.read_text() and 'error:' not in out.read_text(),('unclean',name)
    assert rec['maxrss_kib']<=8*1024*1024
step('lean_version',[lean,'--version'],D/'work')
step('sage_version',[sage,'--version'],D/'work')
step('sage_controls',[sage,str(D/'sage/check_games.sage')],D/'work')
assert sha(D/'work/generated/GameCertificate.lean')==sha(S/'formal/FT1536/GameCertificate.lean')
for mod in build['modules']:
    p=D/'formal'/(mod.replace('.','/')+'.lean');obj=D/'lib'/(mod.replace('.','/')+'.olean');obj.parent.mkdir(parents=True,exist_ok=True)
    step(mod.replace('.','_'),[lean]+build['lean_flags']+['-o',str(obj),str(p)],D/'formal')
expected=json.loads((S/'EXPECTED.json').read_text())['products']
matches=[dict(product=n,expected=h,actual=sha(D/n),match=sha(D/n)==h) for n,h in expected.items()]
assert all(x['match'] for x in matches)
text=(D/'logs/Audit.stdout').read_text();axioms={}
for m in re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",text):
    axioms[m[1]]=[re.sub(r'\.\{[^}]+\}','',a.strip()) for a in (m[2] or '').split(',') if a.strip()]
exports=json.loads((S/'FORMAL_EXPORTS.json').read_text())['exports']
assert set(axioms)=={e['name'] for e in exports}
assert all(set(v)<={'propext','Classical.choice','Quot.sound'} for v in axioms.values())
assert members==verify()
result=dict(status='FRESH_REPLAY_PASS',source=str(S),external_output_pin=PIN,source_members=members,
    jobs=len(jobs),products=matches,axioms=axioms,exports=len(exports),own_cache_fresh=True,
    role='independent rebuild of another model package; not owner acceptance',
    original_source=str(original_source),
    path_policy='own W only; author alternate-root guard and sealed package unchanged; fixed snapshot while author continues')
(D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
print('FRESH_REPLAY_PASS',len(jobs),len(exports),len(matches),flush=True)
