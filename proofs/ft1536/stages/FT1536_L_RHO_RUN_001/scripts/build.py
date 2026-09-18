import hashlib,json,shlex,subprocess,sys
from pathlib import Path
W=Path.cwd();kind,variant,mode=sys.argv[1:4]
assert kind in ['enum','verify-observed','verify-plain'] and mode in ['normal','asan']
base='reference' if variant=='reference' else 'candidate'
mf='inputs/source_hashes.sha256' if base=='reference' else 'CANDIDATE.sha256'
for line in (W/mf).read_text().splitlines():
    h,n=line.split();assert hashlib.sha256((W/base/n).read_bytes()).hexdigest()==h
if kind=='enum':
    assert variant!='reference'
    src='candidate/falcon-vrfy.c' if variant=='candidate' else 'mutants/'+variant+'/falcon-vrfy.c'
    harness='scripts/enumerate.c';observe=0
else:
    assert variant in ['reference','candidate']
    observe=int(kind=='verify-observed')
    src=('observed/'+variant if observe else variant)+'/falcon-vrfy.c'
    harness='scripts/verify_driver.c'
flags=shlex.split(next(l for l in (W/'reference/Makefile').read_text().splitlines() if l.startswith('CFLAGS =')).split('=',1)[1])
name='-'.join([kind,variant,mode]);out=W/'bin'/name;assert not out.exists()
extra=['-std=c99','-DVERIFY_SOURCE="../'+src+'"','-DOBSERVE='+str(observe)]
if mode=='asan':extra+=['-fsanitize=address,undefined','-fno-sanitize-recover=all','-g']
cmd=['/usr/bin/gcc',*flags,*extra,'-I'+base,harness,base+'/falcon-enc.c',base+'/shake.c','-o',str(out),'-lm']
p=subprocess.run(cmd,capture_output=True,text=True)
record=dict(argv=cmd,cwd=str(W),exit_code=p.returncode,stdout=p.stdout,stderr=p.stderr,
             source=src,source_sha256=hashlib.sha256((W/src).read_bytes()).hexdigest(),
             binary=str(out.relative_to(W)),binary_sha256=hashlib.sha256(out.read_bytes()).hexdigest() if p.returncode==0 else None)
with (W/('artifacts/build-'+name+'.json')).open('x') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(record,indent=2));sys.exit(p.returncode)
