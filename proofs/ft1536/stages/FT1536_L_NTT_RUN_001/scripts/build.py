import hashlib,json,shlex,subprocess,sys
from pathlib import Path
W=Path.cwd();variant,mode=sys.argv[1:3];assert mode in ['normal','asan']
for row in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,n=row.split();assert hashlib.sha256((W/'source'/n).read_bytes()).hexdigest()==h
source='source/falcon-vrfy.c' if variant=='base' else ('observed/falcon-vrfy.c' if variant=='observed' else 'mutants/'+variant+'/falcon-vrfy.c')
flags=shlex.split(next(l for l in (W/'source/Makefile').read_text().splitlines() if l.startswith('CFLAGS =')).split('=',1)[1])
out=W/'bin'/(variant+'-'+mode);assert not out.exists()
extra=['-std=c99','-DSOURCE_FILE="../'+source+'"','-DOBSERVED='+str(int(variant=='observed'))]
if mode=='asan':extra+=['-fsanitize=address,undefined','-fno-sanitize-recover=all','-g']
argv=['/usr/bin/gcc',*flags,*extra,'-Isource','scripts/harness.c','source/falcon-enc.c','source/shake.c','-o',str(out),'-lm']
p=subprocess.run(argv,capture_output=True,text=True)
record=dict(argv=argv,cwd=str(W),exit_code=p.returncode,stdout=p.stdout,stderr=p.stderr,source=source,
            source_sha256=hashlib.sha256((W/source).read_bytes()).hexdigest(),binary=str(out.relative_to(W)),
            binary_sha256=hashlib.sha256(out.read_bytes()).hexdigest() if p.returncode==0 else None)
with (W/('artifacts/build-'+variant+'-'+mode+'.json')).open('x') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(record,indent=2));sys.exit(p.returncode)
