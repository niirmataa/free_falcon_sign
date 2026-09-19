"""Synthetic full-bit C/source-model/dyadic comparisons; not a reachability test."""
import hashlib,json,os,signal,subprocess,sys,time,shlex
from pathlib import Path
from fractions import Fraction as F
from dyadic import value,rn
import fp_literal as C
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];L=W/'checks/logs'/mode;L.mkdir(parents=True,exist_ok=True)
words=set([0,1,2,(1<<52)-1,1<<52,(1<<52)+1,(2<<52)-1])
for e in [2,31,511,900,969,970,1020,1021,1022,1023,1024,1030,1040,1052,1053]:
 for f in [0,1,(1<<51)-1,1<<51,(1<<52)-2,(1<<52)-1]:words.add((e<<52)|f)
for n in [1,2,365,366,367,731,732,2147483281,2147483282,2147483283,2147483648]:
 b=rn(n);words.update([b-1,b,b+1])
words=sorted(words|{w|(1<<63) for w in words})
jobs=[(x,z,-2147483283<=value(x)<2147483282) for x in words for z in [-365,-1,0,1,366]]
fixture=''.join(f'{x:016x} {z} {int(dom)}\n' for x,z,dom in jobs)
path=W/'checks/scalars.txt'
if path.exists():assert path.read_text()==fixture
else:path.write_text(fixture)
records=[]
def run(tag,args,limit=60):
 p=subprocess.Popen(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);t=time.monotonic();timed=False
 try:o,e=p.communicate(timeout=limit)
 except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
 so=L/(tag+'.stdout');se=L/(tag+'.stderr');so.write_bytes(o);se.write_bytes(e)
 records.append(dict(argv=args,cwd=str(W),exit_code=p.returncode,timeout=timed,limit=limit,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(o).hexdigest(),stderr_sha256=hashlib.sha256(e).hexdigest()))
 (W/f'artifacts/{mode}_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
 assert not timed and p.returncode==0,(tag,o.decode(),e.decode());return o.decode()
flags=shlex.split(next(l for l in (W/'source/Makefile').read_text().splitlines() if l.startswith('CFLAGS = ')).split('=',1)[1])
san=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if mode=='san' else []
exe='bin/scalar_'+mode
run('compile',['/usr/bin/gcc','-std=c99']+flags+san+['-Isource','checks/scalar.c','source/fpr-emulated.c','-lm','-o',exe])
text=run('run',[exe,'checks/scalars.txt']);lines=text.splitlines();assert len(lines)==len(jobs)
E=F(1,1<<20);maxr=F(0);maxres=F(0);selected=[];nonzero_errors=[];zero_classes=set();count=0;outside=0
for i,((x,z,dom),line) in enumerate(zip(jobs,lines)):
 t=line.split();assert int(t[1])==i and int(t[2],16)==x
 s=int(t[3]);assert s==C.floor(x)
 if not dom:assert t[0]=='outside';outside+=1;continue
 assert t[0]=='inside';_,_,_,_,zz,y,os,oy,r,res,delta=t
 zz=int(zz);y=int(y);os,oy,r,res,delta=[int(t,16) for t in [os,oy,r,res,delta]]
 assert zz==z and s==value(x).__floor__()-int(x==(1<<63)) and y==s+z
 assert -(1<<31)<=s<(1<<31) and -(1<<31)<=y<(1<<31)
 assert os==C.of(s)==rn(s) and oy==C.of(y)==rn(y)
 assert [r,res,delta]==[C.center(x),C.residual(x,z),C.sub(C.of(1),C.center(x))]
 rho=value(x)-s;exactres=value(x)-y;er=abs(value(r)-rho);ee=abs(value(res)-exactres)
 assert 0<=rho<=1 and abs(exactres)<=366
 assert er<=E and ee<=E and abs(value(res))<=366+E
 assert 0<=value(r)<=1 and 0<=value(delta)<=1
 assert r>>63==0 and delta>>63==0 and (r==0 or (r>>52)&2047) and (delta==0 or (delta>>52)&2047)
 maxr=max(maxr,er);maxres=max(maxres,ee);count+=1
 if res&((1<<63)-1)==0:zero_classes.add(f'{res:016x}')
 if ee:nonzero_errors.append(dict(x=f'{x:016x}',z=z,error=str(ee)))
 if x in [0,1,1<<63,(1<<63)+1,rn(-F(1,2)),rn(2147483281)]:selected.append(dict(x=f'{x:016x}',z=z,s=s,y=y,r_bits=f'{r:016x}',res_bits=f'{res:016x}',delta_bits=f'{delta:016x}',rho=str(rho),E_r=str(er),E_res=str(ee)))
assert C.floor(1<<63)==-1 and value(1<<63).__floor__()==0
assert C.floor(rn(F(-1,2)))==-1 and int(F(-1,2))==0
assert value(1<<63)-C.floor(1<<63)==1
assert value(C.center((1<<63)+1))==1
assert nonzero_errors and abs(value(C.sub(1,C.of(0)))-value(1))>0
assert 2147483282+366>2**31-1 and -2147483284-365< -2**31
noop=[C.center(x^0) for x in words];assert noop==[C.center(x) for x in words]
out=dict(status='PASS_CONTROLS_NOT_UNIVERSAL_PROOF',word_patterns=len(words),inside_pairs=count,outside_pairs_stopped_before_sum=outside,
 input_sha256=hashlib.sha256(fixture.encode()).hexdigest(),native_output_sha256=hashlib.sha256(text.encode()).hexdigest(),
 literal_model_raw_bits_equal=True,of_equals_exact_dyadic=True,proposed_E_r=str(E),proposed_E_res=str(E),
 maximum_observed_E_r=str(maxr),maximum_observed_E_res=str(maxres),residual_zero_classes=sorted(zero_classes),selected=selected,
 mutations_detected=['omit eps0','floor to truncation','rho<1 instead of <=1','zero rounding allowance','omit underflow term','integer endpoint moved by1'],noop_pass=True,
 note='No KeyGen/Sign execution or reachability claim. Universal proof is separate from these finite controls.')
(W/f'artifacts/controls_{mode}.json').write_text(json.dumps(out,indent=2)+'\n')
if mode=='san':assert out==json.loads((W/'artifacts/controls_normal.json').read_text())
print(json.dumps({k:v for k,v in out.items() if k!='selected'},indent=2))
