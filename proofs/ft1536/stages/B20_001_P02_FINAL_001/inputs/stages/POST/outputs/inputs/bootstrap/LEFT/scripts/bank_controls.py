import json,re,shlex,subprocess,sys,time
from fractions import Fraction as F
from pathlib import Path
from backend import of,mul,div,sqrt,sub,add,half,cm,cs,conj
from root_model import tables
from fp_literal import floor
from dyadic import value,rn
from ordered_model import sigma_bank,numeric,IW,SUP
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];D=W/'checks/banks';D.mkdir(exist_ok=True);log=W/'checks/bank_logs'/mode;log.mkdir(parents=True,exist_ok=True)
cert=json.loads((W/'BANK_WEIGHTED_BOUNDS.json').read_text());lo=F(cert['gate']['D_min']);hi=F(cert['gate']['D_max']);bitslo=rn(lo);bitshi=rn(hi)
Ds={bitslo,bitslo+1,bitshi-1,bitshi}
for c in cert['coefficients'][:-1]:
 for factor in [F(1),F(4,3)]:
  center=rn(2*768**2*factor*F(c['value']))
  Ds.update(w for w in range(center-8,center+9) if bitslo<=w<=bitshi)
Ds=sorted(Ds);rows=[];payload=[];expected=[]
for i,d in enumerate(Ds):
 for flags in [0,1,2,3,13]:
  t0=(1<<63) if flags==13 else rn(F(10000000* ((i%3)-1),1)+F(1,8));t1=(1<<63) if flags==13 else rn(F(13,8)* ((i%5)-2))
  s0=div(of(768),sqrt(d));s1=mul(IW,s0);ds0=div(of(1),mul(mul(s0,s0),of(2)));ds1=div(of(1),mul(mul(s1,s1),of(2)));j0=sigma_bank(s0);j1=sigma_bank(s1)
  k0=0 if flags&4 else SUP[j0];k1=0 if flags&8 else SUP[j1];assert numeric(t1)
  a1=floor(t1)+(1+k1 if flags&1 else -k1);r1=sub(t1,of(a1));rx=half(r1);mu0=add(t0,rx);assert numeric(mu0)
  a0=floor(mu0)+(1+k0 if flags&2 else -k0);u0=sub(mu0,of(a0));r0=sub(u0,rx)
  lam=value(d);energy=lam*(value(r0)**2+value(r0)*value(r1)+value(r1)**2);defect=value(r0)+value(r1)/2-value(u0)
  assert abs(defect)<F(cert['terminal_half_last_sub_defect']) and energy<F(cert['terminal_A2_energy_integer_upper'])
  for kind,j,s,r in [('stored',j0,s0,u0),('paired',j1,s1,r1)]:
   rec=next(x for x in cert['records'] if x['width_class']==kind and x['bank']==j);assert F(rec['variance_lower'])<value(s)**2<=F(rec['variance_upper']) and lam*value(r)**2<=F(rec['D_residual_squared_upper'])
  vals=[s0,s1,ds0,ds1,r1,rx,mu0,u0,r0,d];payload.append(f'{d:016x} {t0:016x} {t1:016x} {flags}\n');expected.append(f'{j0} {j1} {k0} {k1} '+' '.join(f'{v:016x}' for v in vals)+f' {a0} {a1}\n')
  rows.append(dict(D=f'{d:016x}',flags=flags,bank0=j0,bank1=j1,sigma0=f'{s0:016x}',sigma1=f'{s1:016x}',dss0=f'{ds0:016x}',dss1=f'{ds1:016x}',normal0=f'{u0:016x}',r0=f'{r0:016x}',r1=f'{r1:016x}',half_defect=str(defect),energy=str(energy)))
(D/'input.txt').write_text(''.join(payload));(D/'expected.txt').write_text(''.join(expected));(D/'exact_metrics.json').write_text(json.dumps(rows,indent=2)+'\n')
commands=[]
def run(tag,cmd,data=None):
 t=time.monotonic();p=subprocess.run(cmd,input=data,capture_output=True,timeout=120);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr);commands.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(so),stderr_sha256=sha(se)));(log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0 and not p.stderr,(tag,p.returncode,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/terminal_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/terminal.c','source/falcon-fft.c','source/fpr-emulated.c','-lm','-o',exe]);assert run('terminal',[exe,'terminal'],(D/'input.txt').read_bytes())==(D/'expected.txt').read_bytes()
rot=cm(cs((of(28),of(1)),(of(28),of(-1))),conj(tables(W)[0][2]));imag_words=[of(28),of(0),half(rot[0]),half(rot[1])]
assert run('imag',[exe,'imag'])==(' '.join(f'{w:016x}' for w in imag_words)+'\n').encode()
(D/'imaginary.json').write_text(json.dumps(dict(inputs=[of(28),of(28),of(1),of(-1)],source_split_words=imag_words,offdiagonal_squared=str(value(imag_words[2])**2+value(imag_words[3])**2)),indent=2)+'\n')
a=rn(F(1,2**40));b=of(2**30);x=add(a,b);z=sub(x,b);assert z!=a
assert run('roundoff',[exe,'cancel'],f'{a:016x} {b:016x}\n'.encode())==f'{x:016x} {z:016x}\n'.encode()
(D/'roundoff.json').write_text(json.dumps(dict(a=f'{a:016x}',b=f'{b:016x}',sum=f'{x:016x}',difference=f'{z:016x}',error=str(value(z)-value(a))),indent=2)+'\n')
out=dict(status='PASS_ACTUAL_BANK_BOUNDARIES_PAIRED_TERMINAL_ENERGY',mode=mode,cases=len(rows),distinct_D=len(Ds),banks_covered=sorted(set(r['bank0'] for r in rows)|set(r['bank1'] for r in rows)),
 all_word_outputs_and_exact_dyadic_energy_match=True,signed_zero_half_and_roundoff_checked=True,full_KeyGen_or_Sign=False,scope='Local gated public leaf arrays, not emitted-key witnesses',LSan_claimed=False,metrics_sha256=sha(D/'exact_metrics.json'))
(W/'artifacts'/('banks_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
