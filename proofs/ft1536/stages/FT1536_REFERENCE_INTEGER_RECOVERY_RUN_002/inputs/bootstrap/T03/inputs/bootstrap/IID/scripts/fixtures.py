"""Public boundary/tape fixtures, exact rational PMFs; no random seed or PRNG."""
import json
from pathlib import Path
from fractions import Fraction as Q
from kernel_model import constants,entry,iteration,ber,Buffer,schedule,trunc_bits,high_limb,numeric
from backend import of,mul,div,sub
from dyadic import rn,value
from replaylib import sha
W=Path.cwd();D=W/'artifacts/fixtures';D.mkdir(exist_ok=True);P=W/'artifacts/pmf';P.mkdir(exist_ok=True);cases=[];banks,coefs,C=constants(W)
def save(name,mode,inp,out,count,scope):
 a=D/(name+'.input');b=D/(name+'.expected');a.write_text(inp);b.write_text(out);cases.append(dict(name=name,mode=mode,input=a.relative_to(W).as_posix(),expected=b.relative_to(W).as_posix(),input_sha256=sha(a),expected_sha256=sha(b),cases=count,scope=scope,preflight=True))
def gf(ev):
 return f"G {ev['n']} {ev['old'][0]} {ev['old'][1]} {ev['read'][0]} {ev['read'][1]} {ev['after'][0]} {ev['after'][1]} {ev['discard']} {ev['value']:016x}\n"
def bf(m):
 return f" {m['e']} {m['safe_s']} {m['over']} {m['accepted']} "+' '.join(f'{m[k]:016x}' for k in ['rB','scaled','z','Z'])+' '+ ' '.join(f'{v:016x}' for v in m['steps'])+'\n'
points={0,1,2**64-1,2**64,2**64+1,2**127-1,2**127,2**128-1}
for T in banks:
 for t in T:
  points.update(u for u in [t-1,t,t+1] if 0<=u<2**128)
points=sorted(points);save('cdf_boundaries','cdf',''.join(f'{u>>64:016x} {u%(2**64):016x}\n' for u in points),''.join(' '.join(str(sum(u<t for t in T)) for T in banks)+'\n' for u in points),len(points),'ALL_BANKS_COMMON_U128_STRICT_THRESHOLDS_AND_CARRIES')
blocks=[bytes((j*101+i*29+(i>>4))%256 for i in range(4096)) for j in range(2)];out=[]
for p in range(4096):
 b=Buffer(blocks,p);b.proposal();out.append(f'CASE {p}\n'+''.join(gf(e) for e in b.events)+f'END {b.ptr} {b.block} {b.dropped} {b.returned}\n')
b=Buffer(blocks,4095);b.get(1);out.append('U8_LAST\n'+gf(b.events[0]));save('getters_all_ptrs','getters','',''.join(out),4097,'ALL_VALID_START_PTRS_PLUS_U8_LAST_BYTE')
boundary=[0,1,2,2**31-1,2**31,2**32-1,2**32,2**32+1,2**63-1,2**63,2**64-2,2**64-1]
raw={s<<63|e<<52|m for s in [0,1] for e in range(2048) for m in [0,1,2**51,2**52-1]};pairs=[(x,y) for x in boundary for y in boundary]+[(x,((x*0x9e3779b97f4a7c15)^0xa50123)&(2**64-1)) for x in sorted(raw)]
tests=[];answers=[];cmp=[(0,0),(0,1),(1,1),(2**55-1,2**55-1),(2**55-1,2**55),(2**55-1,2**55+1),(0,2**56-1)]
for i,(x,y) in enumerate(pairs):
 w,z=cmp[i%len(cmp)];hi=high_limb(x,y);assert hi==(x*y)>>64
 tests.append(f'{x:016x} {y:016x} {w:016x} {z:016x}\n');answers.append(f'{hi:016x} {trunc_bits(x):016x} {int(w<z)}\n')
save('high_trunc_comparator','primitive',''.join(tests),''.join(answers),len(pairs),'ALL_EXPONENT_RAW_TRUNC_EXTENDED; FULL_UINT64_HIGH_PRODUCT; LOW55_COMPARATOR_DOMAIN')
xs={0,1,2**52-1,of(1),of(44),of(45),of(64),rn(Q(1,3)),rn(Q(1,4)),rn(Q(524287))}
ln=value(0x3fe62e42fefa39ef)
for e in [1,2,63,64,65,393,1000,700000]:
 w=rn(e*ln);xs.update([w-1,w,w+1])
tests=[];answers=[];ber_cases=[]
for x in sorted(xs):
 pre=ber(W,x)
 for w0,w1 in [(0,0),(0,2**55-1),(1,0),(2**64-1,2**64-1),(0,min(pre['Z'],2**55-1)),(0,max(0,min(pre['Z']-1,2**55-1)))]:
  m=ber(W,x,w0,w1);tests.append(f'{x:016x} {w0:016x} {w1:016x}\n');answers.append('B'+bf(m));ber_cases.append(dict(x=x,w0=w0,w1=w1,**m))
save('berexp_boundaries','ber',''.join(tests),''.join(answers),len(tests),'NONNEGATIVE_X_BELOW_2^19; E0_63_64_AND_COARSE_REMAINDERS')
(W/'artifacts/ber_cases.json').write_text(json.dumps(ber_cases,separators=(',',':'))+'\n')
mus=[0,1<<63,1,(1<<63)|1,rn(Q(1,2)),rn(Q(-1,2)),rn(Q(33,8)),rn(-2147483283),rn(2147483281)]
sigmas=[rn(Q(4,3)),of(4),of(8),of(16),of(24),rn(Q(277,10))];pmfs=[];tests=[];answers=[];iterations=0;part=0
def flush():
 global tests,answers,part
 if tests:save('iterations_'+str(part).zfill(2),'iter',''.join(tests),''.join(answers),len(tests),'PUBLIC_LOCAL_REQUIRED_ENVELOPE_RAW_INPUTS; FULL_FINITE_PMF_ATOMS');part+=1;tests=[];answers=[]
for mi,mu in enumerate(mus):
 for si,sigma in enumerate(sigmas):
  en=entry(W,mu,sigma);j=en['bank'];T=banks[j];mass=[a-b for a,b in zip([2**128]+T,T+[0])];atoms=[]
  for k,count in enumerate(mass):
   if not count:continue
   U=T[k] if k<512 else 0
   for bit in [0,1]:
    w0=0 if (k+bit)%3 else 2**64-1;w1=0 if k%2 else 2**55-1;m=iteration(W,en,U,bit,w0,w1);assert m['k']==k
    weight=Q(count,2**129)*Q(m['ber']['beta']);number=weight*2**264;assert number.denominator==1
    atoms.append(dict(k=k,b=bit,y=m['output'],x=f"{m['x']:016x}",e=m['ber']['e'],rB=f"{m['ber']['rB']:016x}",Z=str(m['ber']['Z']),proposal_numerator=str(count),weight_numerator=str(number.numerator)))
    tests.append(f'{mu:016x} {sigma:016x} {U>>64:016x} {U%(2**64):016x} {bit} {w0:016x} {w1:016x}\n')
    answers.append(f"I {m['s']} {k} {j} {m['output']} "+' '.join(f'{m[v]:016x}' for v in ['r','dss','coefficient','delta','gap','tail','x'])+bf(m['ber']));iterations+=1
    if len(tests)>=1500:flush()
  total=sum(int(a['weight_numerator']) for a in atoms);assert 2**264//256<=total<=2**264 and total>0 and sum(Q(int(a['weight_numerator']),total) for a in atoms)==1
  record=dict(mu=f'{mu:016x}',sigma=f'{sigma:016x}',scope='public local width-envelope word pair, not emitted membership',bank=j,entry=en,iteration_denominator=str(2**264),normalizer_numerator=str(total),A=str(Q(total,2**264)),returned_pmf='weight_numerator/normalizer_numerator',atoms=atoms,zero_accepted_weights=sum(int(a['weight_numerator'])==0 for a in atoms),mass_conservation=True)
  record['game']='IID_BUFFER';record['conditioning']='fixed entry mu/sigma words and legal PAST, excluding unread buffer'
  p=P/(f'case_{mi}_{si}.json');p.write_text(json.dumps(record,indent=2)+'\n');pmfs.append(dict(path=p.relative_to(W).as_posix(),sha256=sha(p),A=record['A'],bank=j))
flush()
(W/'artifacts/pmf_examples.json').write_text(json.dumps(dict(status='PASS_EXACT_NORMALIZED_PMFS',game='IID_BUFFER',examples=pmfs,examples_count=len(pmfs),iteration_atoms=iterations),indent=2)+'\n')
# Exact finite original sampler traces; getter/IT/BE observers only reveal past reads.
def trace(mu,sigma,ptr,fault,rawblocks):
 b=Buffer(rawblocks,ptr);lines=[];ret=None;tag='NORMAL_RETURN'
 def get(n):
  v=b.get(n);lines.append(gf(b.events[-1]));return v
 if fault:return f'RESULT FAULT_RETURN 0 {fault} {ptr} 0 0 0\n'
 if ((mu>>52)&2047)==2047 or sigma>>63 or ((sigma>>52)&2047)==2047 or value(sigma)<=0:return f'RESULT FAULT_RETURN 0 1 {ptr} 0 0 0\n'
 if sigma==of(32):
  s=0;r=0;dss=div(of(1),mul(mul(sigma,sigma),of(2)));lines.append(f'ENTRY {s} {r:016x} {dss:016x}\n');get(8);get(8);fault=2;ret=0;tag='FAULT_RETURN'
 else:
  en=entry(W,mu,sigma);lines.append(f"ENTRY {en['s']} {en['r']:016x} {en['dss']:016x}\n")
  try:
   while True:
    hi=get(8);lo=get(8);bit=get(1)&1;U=hi*2**64+lo;m=iteration(W,en,U,bit);lines.append(f"IT {m['k']} {bit} {en['bank']} {m['delta']:016x} {m['gap']:016x} {m['x']:016x}\n")
    w0=get(8);w1=get(8);z=ber(W,m['x'],w0,w1);lines.append(f"BE {m['x']:016x} {z['e']} {z['rB']:016x} {z['expm']:016x} {z['Z']:016x} {z['safe_s']} {z['over']} {z['accepted']}\n")
    if z['accepted']:ret=m['output'];break
  except EOFError:tag='HARNESS_EXHAUSTED'
 lines.append(f"RESULT {tag} {ret if ret is not None else 'NONE'} {fault} {b.ptr} {b.block} {b.dropped} {b.returned}\n");return ''.join(lines)
def programmed(ptr,props):
 raw=[bytearray(4096) for _ in range(3)];b=Buffer(raw,ptr)
 for values in props:
  for n,v in zip([8,8,1,8,8],values):
   b.get(n);ev=b.events[-1];j,off=ev['read'];raw[j][off:off+n]=int(v).to_bytes(n,'little')
 return [bytes(x) for x in raw]
loop_cases=[]
for name,mu,ptr in [('normal_zero',0,0),('negative_zero',1<<63,4087),('half_boundary',rn(Q(1,2)),4086),('delta_one',rn(Q(-1,2)),4095)]:
 # k0 and smaller delta guarantee positive acceptance; both Bernoulli words zero.
 en=entry(W,mu,rn(Q(4,3)));bit=0 if value(en['r'])<=Q(1,2) else 1
 raw=programmed(ptr,[(2**64-1,2**64-1,bit,0,0)]);loop_cases.append((name,mu,rn(Q(4,3)),ptr,0,raw))
for ptr in [0,4070,4087,4095]:
 props=[(0,0,0,0,0)]*3+[(2**64-1,2**64-1,0,0,0)];loop_cases.append(('three_rejects_'+str(ptr),0,rn(Q(4,3)),ptr,0,programmed(ptr,props)))
loop_cases += [('finite_stutter',0,rn(Q(4,3)),0,0,[bytes(4096)]),('sticky_fault',0,of(2),4095,3,[bytes(4096)]),('invalid_sigma',0,0,0,0,[bytes(4096)]),('invalid_mu',0x7ff0000000000001,of(2),0,0,[bytes(4096)]),('no_bank',0,of(32),4087,0,[bytes(4096),bytes(4096)])]
loop_records=[]
for name,mu,sigma,ptr,fault,blocks in loop_cases:
 out=trace(mu,sigma,ptr,fault,blocks);inp=f'{mu:016x} {sigma:016x} {ptr} {fault} {len(blocks)}\n'+''.join(b.hex()+'\n' for b in blocks);save('sampler_'+name,'sampler',inp,out,1,'PUBLIC_TEST_REFILL; bounded original sampler; exhausted tape is harness nonreturn observation')
 loop_records.append(dict(name=name,last_line=out.splitlines()[-1],getter_reads=sum(s.startswith('G ') for s in out.splitlines()),completed_proposals=sum(s.startswith('BE ') for s in out.splitlines())))
(W/'artifacts/sampler_examples.json').write_text(json.dumps(loop_records,indent=2)+'\n')
out=dict(status='PASS_PREFLIGHT_EXACT_PUBLIC_FIXTURES',cases=cases,counts=dict(cdf=len(points),getter_start_pointers=4096,primitive=len(pairs),berexp=len(ber_cases),pmf_examples=len(pmfs),iteration_atoms=iterations,sampler_traces=len(loop_cases)),seeded_PRNG_executed=False,new_keys_generated=False)
(W/'artifacts/fixtures.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],counts=out['counts'],native_invocations=len(cases)),indent=2))
