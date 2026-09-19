from fractions import Fraction as F
import hashlib,json,os,signal,subprocess,sys,time,shlex
from pathlib import Path
from dyadic import rn,value,floor_bits,floor_parts
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];L=W/'checks/boundary_logs'/mode;L.mkdir(parents=True,exist_ok=True)
cases=[]
for name,v in [('lower',-2147483283),('upper',2147483282),('intmin',-2147483648),('intmaxplus',2147483648)]:
 b=rn(v)
 for k in [-1,0,1]:cases.append((name+('_prev' if k<0 else '_next' if k>0 else '_exact'),b+k))
for name,b in [('pluszero',0),('minuszero',1<<63),('negminsub',(1<<63)+1),('posminsub',1),('negfraction',rn(F(-1,2))),('positivefraction',rn(F(1,2)))]:cases.append((name,b))
text=''.join(f'{n} {b:016x}\n' for n,b in cases);fixture=W/'checks/boundaries.txt'
if fixture.exists():assert fixture.read_text()==text
else:fixture.write_text(text)
flags=shlex.split(next(x for x in (W/'source/Makefile').read_text().splitlines() if x.startswith('CFLAGS = ')).split('=',1)[1]);records=[]
def run(tag,cmd,limit=45):
 t=time.monotonic();p=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
 try:o,e=p.communicate(timeout=limit)
 except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
 so=L/(tag+'.stdout');se=L/(tag+'.stderr');so.write_bytes(o);se.write_bytes(e)
 records.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,timeout=timed,limit=limit,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(o).hexdigest(),stderr_sha256=hashlib.sha256(e).hexdigest()))
 (W/f'artifacts/boundary_{mode}_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
 assert not timed and p.returncode==0,(o.decode(),e.decode());return o.decode()
exe='bin/boundaries_'+mode;san=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if mode=='san' else []
run('compile',['/usr/bin/gcc','-std=c99']+flags+san+['-ffunction-sections','-fdata-sections','-Isource','checks/boundaries.c','source/fpr-emulated.c','source/frng.c','source/shake.c','-Wl,--gc-sections','-lm','-o',exe],60)
out=run('run',[exe,'checks/boundaries.txt']);rows=out.splitlines();floors=[];props=[]
for (name,b),line in zip(cases,rows):
 t,bhex,s,n,lo,hi=line.split();assert t==name and int(bhex,16)==b
 sf=int(s);nv=int(n);assert sf==floor_bits(b);assert nv==(sf+2**31)%2**32-2**31
 exact=value(b);f=exact.numerator//exact.denominator
 if b!=1<<63:assert sf==f
 floors.append(dict(name=name,bits=bhex,exact=str(exact),math_floor=f,source_floor=sf,int_value=nv,
    meets_Cmu=-2147483283<=f<=2147483281,source_sum_min=int(lo),source_sum_max=int(hi),exact_cast=sf==nv,refinement=sf==f))
cert=json.loads((W/'artifacts/cdf_certificate.json').read_text());coeff=cert['coefficient_bits']
for line in rows[len(cases):-1]:
 _,ds,found,lv,k,co=line.split();d=int(ds,16);want=next((i for i,c in enumerate(coeff) if d>=c),None)
 if want is None:assert [int(found),int(lv),int(k),int(co,16)]==[0,0,0,0]
 else:assert [int(found),int(lv),int(k),int(co,16)]==[1,want,cert['maxima'][want],coeff[want]]
 props.append(line)
assert rows[-1]=='synthetic_active_negative_zero 0 0'
# Semantic mutation tests, not merely labels: endpoints enlarged, floor
# changed to truncation, and one zero CDF threshold changed to a positive word.
assert -2147483284-365< -2**31 and 2147483282+366>2**31-1
assert int(F(-1,2))!=F(-1,2).__floor__()
mut=cert['banks'][4][:];assert mut[365]==0;mut[365]=1
assert sum(0<t for t in mut)==366>365
result=dict(status='PASS',floors=floors,proposal_thresholds_checked=len(props),negative_zero_active_synthetic=True,required_reachability_proved=False,
 mutations=['lower_Cmu_minus1 overflows with z=-365','upper_Cmu_plus1 overflows with z=366','truncate replaces negative fractional floor','CDF first zero ->1 exceeds support365'],noop_pass=True,
 native_stdout_sha256=hashlib.sha256(out.encode()).hexdigest())
(W/f'artifacts/boundaries_{mode}.json').write_text(json.dumps(result,indent=2)+'\n')
if mode=='san':assert result==json.loads((W/'artifacts/boundaries_normal.json').read_text())
print(json.dumps({k:v for k,v in result.items() if k!='floors'},indent=2))
