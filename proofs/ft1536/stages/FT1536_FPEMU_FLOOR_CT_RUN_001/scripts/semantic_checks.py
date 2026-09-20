import json,re,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);rows=[]
def run(tag,argv):
 t=time.monotonic();p=subprocess.run(argv,capture_output=True,timeout=120);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 rows.append(dict(argv=argv,cwd=str(W),exit_code=p.returncode,limit=120,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(rows,indent=2)+'\n');assert p.returncode==0,(tag,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'baseline/source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]+['-std=c99']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
objects=[]
for variant in ['baseline','candidate']:
 o='bin/'+variant+'_floor_'+mode+'.o';objects.append(o)
 run('compile_'+variant,['/usr/bin/gcc']+flags+['-I'+variant+'/source','-c','checks/'+variant+'_floor.c','-o',o])
exe='bin/semantic_'+mode;run('link',['/usr/bin/gcc']+flags+['checks/semantic.c']+objects+['-o',exe])
result=json.loads(run('corpus',[exe,'checks/data/corpus.bin','checks/data/actual_'+mode+'.bin']))
assert result['cases']==json.loads((W/'artifacts/corpus.json').read_text())['cases']
smokes=[]
for variant in ['baseline','candidate']:
 path=variant+'/source';exe='bin/smoke_'+variant+'_'+mode
 run('compile_smoke_'+variant,['/usr/bin/gcc']+flags+['-I'+path,'checks/fpemu_smoke.c',path+'/fpr-emulated.c','-lm','-o',exe])
 r=json.loads(run('smoke_'+variant,[exe]));assert r['checks']==12 and r['result']=='PASS';smokes.append(dict(variant=variant,**r))
out=dict(status='PASS_BIT_EXACT_CORPUS_AND_SMOKE',cases=result['cases'],all_exponents_and_signs=True,random_words=1000000,
 actual_sha256=sha(W/'checks/data'/('actual_'+mode+'.bin')),corpus_sha256=sha(W/'checks/data/corpus.bin'),smoke=smokes,LSan_claimed=False)
(W/'artifacts'/('semantic_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
