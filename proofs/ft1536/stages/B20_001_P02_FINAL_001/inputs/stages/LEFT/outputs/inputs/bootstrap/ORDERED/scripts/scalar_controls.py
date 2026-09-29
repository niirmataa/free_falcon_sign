import json,re,shlex,subprocess,sys,time
from fractions import Fraction as F
from pathlib import Path
from backend import add,sub,mul,div,of
from fp_literal import floor,u64
from dyadic import value,rn
from ordered_model import numeric,COE,SUP
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];D=W/'checks/scalar';D.mkdir(exist_ok=True);log=W/'checks/scalar_logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
text=(W/'source/ft1536-adaptive-cdf-tables.h').read_text();pairs=[tuple(map(int,x)) for x in re.findall(r'\{\s*(\d+)u,\s*(\d+)u\s*\}',text.split('ft_adaptive_cdf[',1)[1])];banks=[[hi*2**64+lo for hi,lo in pairs[j*512:(j+1)*512]] for j in range(5)]
h=(W/'source/fpr-emulated.h').read_text();const=lambda n:int(re.search(r'static const fpr '+n+r' = 0x([0-9a-fA-F]+)ULL',h)[1],16)
expm=[int(x,16) for x in re.findall(r'0x([0-9a-fA-F]+)ULL',h.split('fpr_expm_p63_coefficients[13]',1)[1].split('};',1)[0])];assert len(expm)==13
def trunc(x):
 e=(x>>52)&2047;t=x>>63;xu=((u64(x<<10)|2**62)&(2**63-1));cc=1085-e;xu>>=cc&63;xu&=u64(-(((cc-64)&0xffffffff)>>31));return u64((xu^u64(-t))+t)
def expword(x):
 y=expm[0];z=u64(trunc(mul(x,0x43e0000000000000))<<1)
 for coefficient in expm[1:]:y=u64(coefficient-(z*y>>64))
 return y
mus=[0,1<<63,1,0x8000000000000001,rn(-2147483283),rn(2147483281),rn(F(-1,2)),rn(F(1,2)),rn(F(33,8))]
sigmas=[rn(F(4,3)),rn(2),rn(4),rn(8),rn(16),rn(24),rn(F(277,10))]
rows=[];payload=[];answers=[]
for i,mu in enumerate(mus):
 for j,sigma in enumerate(sigmas):
  assert numeric(mu);s=floor(mu);r=sub(mu,of(s));dss=div(of(1),mul(mul(sigma,sigma),of(2)));level=next(k for k,a in enumerate(COE) if dss>=a)
  for order in [0,2**128-1,banks[level][SUP[level]-1],max(0,banks[level][SUP[level]-1]-1)]:
   k=sum(order<x for x in banks[level]);assert k<=SUP[level]
   for b in [0,1]:
    delta=sub(of(1),r) if b else r;gap=sub(dss,COE[level]);assert gap>>63==0 and 0<=value(r)<=1 and 0<=value(delta)<=1
    x=add(mul(of(k*k),gap),mul(add(mul(of(2*k),delta),mul(delta,delta)),dss));assert x>>63==0 and 0<=value(x)<2**19
    bs=floor(mul(x,const('fpr_inv_ln2')));br=sub(x,mul(of(bs),const('fpr_log2')));assert 0<=bs<2**20 and abs(value(br))<2
    over=int(bs>63);safe=min(bs,63);w0=(i+j+b)*7919;w1=order%(2**64);cut=expword(br)>>8;left=w0^((w0>>safe)<<safe);accept=int(left==0)&(1^over)&int(((w1%(2**55)-cut)%(2**64))>>63)
    out=s+(1+k if b else -k);assert -2**31<=out<2**31
    payload.append(f'{mu:016x} {sigma:016x} {order>>64:016x} {order%(2**64):016x} {b} {w0:016x} {w1:016x}\n')
    answers.append(f'{s} {k} {level} {r:016x} {dss:016x} {delta:016x} {gap:016x} {x:016x} {bs} {safe} {over} {br:016x} {cut:016x} {accept} {out}\n')
    rows.append(dict(mu=f'{mu:016x}',sigma=f'{sigma:016x}',bank=level,k=k,b=b,x=f'{x:016x}',BerExp_s=bs,r=f'{br:016x}'))
(D/'input.txt').write_text(''.join(payload));(D/'expected.txt').write_text(''.join(answers))
def run(tag,cmd,data=None):
 tick=time.monotonic();p=subprocess.run(cmd,input=data,capture_output=True,timeout=120);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr);commands.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,elapsed=time.monotonic()-tick,stdout_sha256=sha(so),stderr_sha256=sha(se)));(log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0 and not p.stderr,(tag,p.returncode,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/scalar_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/scalar.c','source/fpr-emulated.c','-lm','-o',exe]);out=run('cases',[exe],(D/'input.txt').read_bytes());assert out==(D/'expected.txt').read_bytes()
result=dict(status='PASS_SOURCE_SCALAR_SUPPORT_AND_BEREXP_ARITHMETIC_SLICES',mode=mode,cases=len(rows),banks_support=SUP,max_BerExp_s=max(r['BerExp_s'] for r in rows),
 independent_u128_threshold_comparison=True,full_BerExp_integer_word_match=True,probability_or_rejection_termination_claimed=False,legal_public_word_reads_only=True,LSan_claimed=False,expected_sha256=sha(D/'expected.txt'))
(W/'artifacts'/('scalar_'+mode+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
