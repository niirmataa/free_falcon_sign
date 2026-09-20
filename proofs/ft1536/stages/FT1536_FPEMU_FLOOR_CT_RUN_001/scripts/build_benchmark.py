import json,re,shlex,subprocess,time
from pathlib import Path
from replaylib import sha
from dudect_mechanics import order_for
from fixtures import oracle
W=Path.cwd();out=W/'artifacts/benchmark_build';out.mkdir(exist_ok=True);rows=[];bins={};objects=[]
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'baseline/source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]
def run(name,argv):
 t=time.monotonic();p=subprocess.run(argv,capture_output=True,timeout=120);so=out/(name+'.stdout');se=out/(name+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 rows.append(dict(argv=argv,cwd=str(W),limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (out/'commands.json').write_text(json.dumps(rows,indent=2)+'\n');assert p.returncode==0,(name,p.stderr.decode());return p.stdout
for variant in ['baseline','candidate']:
 vf=flags+['-std=c99','-I'+variant+'/source','-Ivendor'];obs=[]
 for name,src in [('benchmark','harness/benchmark.c'),('targets','harness/targets.c'),('fpr',variant+'/source/fpr-emulated.c')]:
  obj='bin/'+variant+'_'+name+'.o';obs.append(obj);run(variant+'_'+name,['/usr/bin/gcc']+vf+['-c',src,'-o',obj])
  objects.append(dict(variant=variant,unit=name,path=obj,sha256=sha(W/obj)))
 binary='bin/dudect_'+variant;run(variant+'_link',['/usr/bin/gcc']+obs+['-lm','-o',binary]);bins[variant]=dict(path=binary,sha256=sha(W/binary))
 dis=run(variant+'_disassembly',['/usr/bin/objdump','-drwC',binary]);(out/(variant+'.dis')).write_bytes(dis)
 run(variant+'_targets_asm',['/usr/bin/gcc']+vf+['-fverbose-asm','-S','harness/targets.c','-o',str((out/(variant+'_targets.s')).relative_to(W))])
 for r in range(3):
  for case in [0,1,2,3,4]:
   data=run(f'{variant}_fixtures_{r}_{case}',[binary,'--fixtures',str(case),order_for(r,case)])
   count=[0,0]
   for line in data.decode().splitlines():
    c,x,y,z=line.split();c=int(c);x,y,z=[int(v,16) for v in [x,y,z]];count[c]+=1
    if case==1:
     expected=1
     for _ in range(256 if c else 8):expected=(expected*6364136223846793005+1)%(2**64)
    else:expected=oracle(x)
    assert z==expected
   assert count==[1024,1024]
for unit in ['benchmark','fpr']:
 assert objects[[o['unit'] for o in objects].index(unit)]['sha256']==[o for o in objects if o['unit']==unit][-1]['sha256']
result=dict(status='PASS_IDENTICAL_ENGINE_AND_FIXTURES',binaries=bins,objects=objects,fixture_cases=5,round_orders=3,per_class=1024,
 vendor_sha256=sha(W/'vendor/dudect.h'),harness={r:sha(W/'harness'/r) for r in ['benchmark.c','targets.c']},flags=flags)
(W/'artifacts/benchmark_build.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
