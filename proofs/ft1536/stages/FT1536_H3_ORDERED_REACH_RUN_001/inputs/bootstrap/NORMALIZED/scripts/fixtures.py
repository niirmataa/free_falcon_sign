import json,struct
from fractions import Fraction as Q
from pathlib import Path
from dyadic import value,rn,sqrt_rn
from backend import sqrt,div,mul,add,neg,of,U,ETA
from stable_model import Stable,recompute_roots,normalize,initial_sk,sigma_only,gate_single,MIN,MAX
from replaylib import sha
W=Path.cwd();D=W/'checks/data';D.mkdir(parents=True,exist_ok=True)
mant=[0,1,2,3,1023,1024,2**25-1,2**25,2**25+1,2**50-1,2**50,2**50+1,2**51-1,2**51,2**52-2,2**52-1]
words=[0,1<<63]+[(e<<52)|f for e in range(1,2047) for f in mant]
state=0x4654535441424c45
for _ in range(8192):
 state=(state+0x9e3779b97f4a7c15)%(2**64);z=state;z=((z^(z>>30))*0xbf58476d1ce4e5b9)%(2**64);z=((z^(z>>27))*0x94d049bb133111eb)%(2**64);z^=z>>31
 words.append(((1+(z>>52)%2046)<<52)|(z%(2**52)))
words=list(dict.fromkeys(words));answers=[];lean=[];mutant=None
for i,x in enumerate(words):
 z,tr=sqrt(x,True);v=value(x);actual=value(z)
 assert z==sqrt_rn(v)
 if v:assert (1-Q(1,2**52))**2*v<=actual*actual<=(1+Q(1,2**52))**2*v
 answers.append(z)
 if i<4096:
  a=((x%(2**52))|2**52)*(2 if (((x>>52)&2047)-1023)%2 else 1);lean.append((a,tr['q'],tr['residual']))
 if mutant is None and ((x>>52)&2047)>0:
  from fp_literal import pack
  wrong=pack(0,tr['e'],tr['q']<<1)
  if wrong!=z:mutant=dict(raw=f'{x:016x}',expected=f'{z:016x}',without_sticky=f'{wrong:016x}')
assert mutant is not None
(D/'sqrt.input').write_text(''.join(f'{x:016x}\n' for x in words));(D/'sqrt.expected').write_text(''.join(f'{z:016x}\n' for z in answers))
(D/'sqrt_lean.input').write_text(''.join(str(a)+'\n' for a,q,r in lean));(D/'sqrt_lean.expected').write_text(''.join(f'{q} {r}\n' for a,q,r in lean))
pairs=[]
xs=[0,1<<63,1,(1<<63)|1,0x000fffffffffffff]+[rn(x) for x in [Q(1,2**1022),Q(-1,2**1022),Q(1,3),-3,1,768,2**71,2**100]]
ys=[rn(y) for y in [Q(1,2**16),Q(1,16),Q(1,2),1,3,2**35,3*2**46,2**48,2**80]]
for x in xs:
 for y in ys:
  z=div(x,y);ideal=value(x)/value(y);assert abs(value(z)-ideal)<=U*abs(ideal)+ETA;pairs.append((x,y,z))
(D/'div.input').write_text(''.join(f'{x:016x} {y:016x}\n' for x,y,z in pairs));(D/'div.expected').write_text(''.join(f'{z:016x}\n' for x,y,z in pairs))
bitswords=[0,1<<63,1,(1<<63)|1,0xfffffffffffff,0x800fffffffffffff]+[rn(x) for x in [1,-1,3,-3,Q(1,2**1022),Q(-1,2**1022),1536,-1536]]
bits=[]
for x in bitswords:
 for y in bitswords:
  a=mul(x,x);b=mul(y,y);an=mul(neg(x),neg(x));bn=mul(neg(y),neg(y));s=add(a,b);t=add(b,a);assert a==an and b==bn and s==t
  bits.append((x,y,[a,an,b,bn,s,t]))
(D/'bits.input').write_text(''.join(f'{x:016x} {y:016x}\n' for x,y,_ in bits));(D/'bits.expected').write_text(''.join(' '.join(f'{z:016x}' for z in out)+'\n' for _,_,out in bits))
gates=[]
for x in [MIN-1,MIN,MIN+1,MAX-1,MAX,MAX+1,0,1<<63,0x7ff0000000000000,0xfff0000000000000,0x7ff8000000000001,0xbff0000000000000]:
 for bad in [0,1]:gates.append((x,bad,gate_single(x,bad)))
(D/'gate.input').write_text(''.join(f'{x:016x} {b}\n' for x,b,_ in gates));(D/'gate.expected').write_text(''.join(f'{y:016x} {b} {ok}\n' for _,_,(y,b,ok) in gates))
widths=[MIN-1,MIN,MIN+1,MAX-1,MAX,MAX+1]+[MIN+((MAX-MIN)*i)//1023 for i in range(1024)]+[rn(Q(1,4)),rn(1),rn(2**31)]
wb=json.loads((W/'WIDTH_BOUNDS.json').read_text());last=int(wb['selector']['coefficients_bits'][-1],16);wout=[]
for x in widths:
 r=sqrt(x);s=div(of(768),r);s,p,ds,dp=sigma_only(s);found=[int(ds>=last),int(dp>=last)]
 if MIN<=x<=MAX:
  for kind,z,d in [('stored',s,ds),('paired',p,dp)]:
   c=wb[kind];assert Q(c['real_square_lower'])<=value(z)**2<=Q(c['real_square_upper']) and Q(c['dss_lower'])<=value(d)<=Q(c['dss_upper'])
  assert found==[1,1]
 wout.append([r,s,p,ds,dp,*found])
(D/'widths.input').write_text(''.join(f'{x:016x}\n' for x in widths));(D/'widths.expected').write_text(''.join(' '.join([*(f'{v:016x}' for v in row[:5]),*(str(v) for v in row[5:])])+'\n' for row in wout))
rows=[]
def save(name,mode,payload,roots):
 m=Stable();leaves,ok,_=m.roots(roots);sk,reads=normalize(leaves,initial_sk(),m,W)
 expected=('\n'.join(m.events)+'\nG '+' '.join(f'{x:016x}' for x in roots)+'\nL '+' '.join(f'{x:016x}' for x in leaves)+'\nK '+' '.join(f'{x:016x}' for x in sk)+f'\nEND {int(ok)} 1536 18432 1536 16896 6144 3072 FRAME_CANARIES_PASS\n').encode()
 (D/(name+'.input')).write_bytes(payload);(D/(name+'.expected')).write_bytes(expected);(D/(name+'.leaves.bin')).write_bytes(struct.pack('<1536Q',*leaves));(D/(name+'.sk.bin')).write_bytes(struct.pack('<24576Q',*sk))
 (D/(name+'.reads.json')).write_text(json.dumps(reads,indent=2)+'\n')
 rows.append(dict(name=name,mode=mode,stable_ok=ok,operations=len(m.events),input_sha256=sha(D/(name+'.input')),output_sha256=sha(D/(name+'.expected')),preflight='PASS_SOURCE_DOMAINS_BEFORE_NATIVE',membership='Synthetic local helper domain, not P_key/emitted witness'))
roots_cases={
 'roots_flat':[rn(3000)]*768+[0]*768,
 'roots_vary':[rn(2048+16*(i%17)+(i%3)) for i in range(768)]+[0]*768,
 'roots_high':[rn(2**23)]*768+[0]*768,
 'roots_invalid':[0,1<<63,0x7ff0000000000000,0x7ff8000000000001,0xbff0000000000000,1,rn(Q(1,4)),rn(Q(1,2))]+[rn(3000)]*760+[0]*768}
for name,roots in roots_cases.items():save(name,'roots',''.join(f'{x:016x}\n' for x in roots).encode(),roots)
for name,mode,a,b in [('coeff_flat','suffix',55,11),('coeff_zero','suffix',0,0),('coeff_alias','suffix_alias',40,40),('coeff_vary','suffix',40,40)]:
 polys=[[0]*1536 for _ in range(2)];polys[0][0]=a;polys[1][0]=b
 if name=='coeff_vary':polys[0][1]=1;polys[1][3]=-1
 roots=recompute_roots(W,polys);assert roots==recompute_roots(W,polys,True)
 save(name,mode,''.join(str(x)+'\n' for p in polys for x in p).encode(),roots)
out=dict(status='PASS_INDEPENDENT_PREFLIGHT_AND_EXACT_ORACLES',sqrt_words=len(words),sqrt_exponents=2046,random_words=8192,public_seed='4654535441424c45',
 sqrt_matches_independent_isqrt_RN_oracle_on_tests=True,RN_not_assumed_in_universal_contract=True,lean_sqrt_cases=len(lean),div_pairs=len(pairs),bit_identity_pairs=len(bits),gate_cases=len(gates),width_cases=len(widths),
 sqrt_sticky_mutation=mutant,pipelines=rows,source_bound_sigma2_H4_checked=True,paired_and_dss_bounds_checked=True,synthetic_key_membership_claimed=False)
(W/'artifacts/fixtures.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
