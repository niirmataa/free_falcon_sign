"""Fresh exact kernels/bank boundaries/complete reduction brackets and primitives."""
import json
from pathlib import Path
from fractions import Fraction as Q
from kernel_model import constants,entry,iteration,ber,expword,trunc_bits,numeric
from backend import mul,sub,div,sqrt,of
from dyadic import value,rn
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';D=W/'artifacts/fixtures';D.mkdir(exist_ok=True);P=W/'artifacts/kernels';P.mkdir(exist_ok=True)
banks,coefs,C=constants(W);dom=json.loads((W/'REDUCTION_DOMAIN.json').read_text());wit=json.loads((W/'artifacts/witnesses.json').read_text());width=json.loads((I/'NORMALIZED/WIDTH_BOUNDS.json').read_text());cases=[]
def save(name,mode,inp,out,count,scope):
 a=D/(name+'.input');b=D/(name+'.expected');a.write_text(inp);b.write_text(out);cases.append(dict(name=name,mode=mode,input=a.relative_to(W).as_posix(),expected=b.relative_to(W).as_posix(),input_sha256=sha(a),expected_sha256=sha(b),count=count,scope=scope,preflight=True))
def bf(m):return f" {m['e']} {m['safe_s']} {m['over']} {m['accepted']} "+' '.join(f'{m[k]:016x}' for k in ['rB','scaled','z','Z'])+' '+' '.join(f'{v:016x}' for v in m['steps'])+'\n'
# Source brackets, their neighbors, cutoff and exact source e*log2 neighborhoods.
xs=set([0,1,2**52-1,of(273)])
for r in dom['buckets']:
 for field in ['x_first','x_last','source_e_log2']:
  w=int(r[field],16);xs.update(x for x in [w-1,w,w+1] if 0<=x<=of(273))
tests=[];answers=[]
for x in sorted(xs):
 m=ber(W,x);assert value(x)>=0 and value(x)<=273
 for w0,w1 in [(0,0),(0,2**55-1)]:tests.append(f'{x:016x} {w0:016x} {w1:016x}\n');answers.append('B'+bf(ber(W,x,w0,w1)))
save('reduction_all_boundaries','ber',''.join(tests),''.join(answers),len(tests),'ALL_394_SOURCE_EXPONENT_INTERVAL_ENDPOINTS_AND_NEIGHBORS; broader BerExp x domain')
# Full-bit primitive controls for the refined normal multiplication and center phases.
ms=[]
for ex in range(1022,1032):
 for f in [0,1,2**20-1,2**32,2**51-1,2**51,2**52-2,2**52-1]:
  x=ex<<52|f
  if value(x)<=273:ms.append((x,0x3ff71547652b82fe))
ms += [(of(e),0x3fe62e42fefa39ef) for e in range(394)]
rs={0,1<<63,1,(1<<63)|1,2**52-1,(1<<63)|(2**52-1),of(1),of(-1),rn(Q(1,2)),rn(Q(-1,2)),of(937866518),of(-937866518),rn(-2147483283),rn(2147483281)}
for s in [0,1]:
 for e in [0,1,900,960,969,970,1021,1022,1023,1051,1052,1053]:
  for f in [0,1,2**51,2**52-1]:
   x=s<<63|e<<52|f
   if numeric(x):rs.add(x)
for x in list(rs):
 for v in [x-1,x+1]:
  if 0<=v<2**64 and numeric(v):rs.add(v)
out=[]
for x in sorted(rs):
 s=entry(W,x,rn(Q(4,3)))['s'];r=sub(x,of(s));delta=sub(of(1),r)
 assert abs(value(r)-(value(x)-s))<=Q(1,2**51) and abs(value(delta)-(1-value(r)))<=Q(1,2**51)
 out.append(f'{s} {r:016x} {delta:016x}\n')
save('center_refinement','center',''.join(f'{x:016x}\n' for x in sorted(rs)),''.join(out),len(rs),'NumericCenter incl both zeros, subnormals, exponent/cancellation endpoints')
for x,y in ms:
 if x!=0:assert mul(x,y)==rn(value(x)*value(y))
save('normal_mul_refinement','mul',''.join(f'{x:016x} {y:016x}\n' for x,y in ms),''.join(f'{mul(x,y):016x}\n' for x,y in ms),len(ms),'normal fixed-constant exact RN controls, not enumeration of all fractions')
expinputs={0,1,2**52-1,0x3fe62e42fefa39ef,rn(Q(dom['global_rB_upper']))}
for w in wit['negative_expm_extended']:expinputs.add(int(w['rB'],16))
for r in dom['buckets']:expinputs.update([int(r['rB_first'],16),int(r['rB_last'],16)])
for q in [Q(1,2**63),Q(1,2**55),Q(1,2),Q(7,10),Q(1)]:
 w=rn(q);expinputs.update([w-1,w,w+1])
out=[]
for r in sorted(expinputs):
 y,t=expword(W,r);assert abs(value(r))<2
 out.append(' '.join(f'{v:016x}' for v in [t['scaled'],trunc_bits(t['scaled']),t['z']]+t['steps']+[y])+'\n')
save('expm_domains','expm',''.join(f'{r:016x}\n' for r in sorted(expinputs)),''.join(out),len(expinputs),'actual nonnegative domain plus separately labelled EXTENDED_EXPM negative/fixed-point inputs')
raws=[of(331776),int(width['gate']['min_bits'],16),int(width['gate']['max_bits'],16)];out=[]
for raw in raws:
 root=sqrt(raw);sigma=div(of(768),root);pair=mul(sigma,0x3ff279a74590331c);out.append(f'{root:016x} {sigma:016x} {pair:016x}\n')
save('standalone_normalizer','leaf',''.join(f'{x:016x}\n' for x in raws),''.join(out),len(raws),'standalone source leaf normalization, no whole tree/key or Emitted membership')
# Independent baseline set plus fresh first-bank boundary pairs and explicit witnesses.
points={}
for p in sorted((I/'IID/artifacts/pmf').glob('*.json')):
 old=json.loads(p.read_text());points[(int(old['mu'],16),int(old['sigma'],16))]=dict(origin='PINNED_IID_BASELINE',old_path=p.relative_to(W).as_posix(),old=old)
assert len(points)==54
def env_classes(mu,sigma):
 en=entry(W,mu,sigma)
 return [c for c in ['stored','paired'] if Q(width[c]['value_lower'])<=value(sigma)<=Q(width[c]['value_upper']) and Q(width[c]['dss_lower'])<=value(en['dss'])<=Q(width[c]['dss_upper'])]
for j in range(1,5):
 lo,hi=rn(Q(4,3)),rn(Q(277,10))
 while lo<hi:
  mid=(lo+hi)//2
  if entry(W,0,mid)['bank']>=j:hi=mid
  else:lo=mid+1
 for sig in [lo-1,lo,lo+1]:
  for mu in [0,1<<63,rn(Q(3,8))]:points[(mu,sig)]=dict(origin='FRESH_FIRST_BANK_BOUNDARY')
for c in ['stored','paired']:
 for sig in [int(width[c]['word_interval']['lower'],16)+16,int(width[c]['word_interval']['upper'],16)-16]:
  for mu in [0,1<<63]:
   if env_classes(mu,sig):points[(mu,sig)]=dict(origin='FRESH_WIDTH_CLASS_ENDPOINT')
for w in wit['overrun_scalar_witnesses']:points[(int(w['mu'],16),int(w['sigma'],16))]=dict(origin='SCALAR_DERIVED_STANDALONE_LEAF_OVERRUN')
catalog=[];tests=[];answers=[];part=0;total=0
def flush():
 global tests,answers,part
 if tests:save('scalar_atoms_'+str(part).zfill(2),'iter',''.join(tests),''.join(answers),len(tests),'all source atoms of public D_env points; Gaussian metrics do not derive the uniform bound');part+=1;tests=[];answers=[]
for index,((mu,sigma),info) in enumerate(points.items()):
 classes=env_classes(mu,sigma);assert classes,(mu,sigma,info['origin']);en=entry(W,mu,sigma);j=en['bank'];T=banks[j];mass=[a-b for a,b in zip([2**128]+T,T+[0])];atoms=[]
 for k,count in enumerate(mass):
  if not count:continue
  U=T[k]
  for b in [0,1]:
   w0=0;w1=0 if k%2 else 2**55-1;m=iteration(W,en,U,b,w0,w1);weight=Q(count,2**129)*Q(m['ber']['beta']);num=weight*2**264;assert num.denominator==1
   atoms.append(dict(k=k,b=b,y=m['output'],x=f"{m['x']:016x}",e=m['ber']['e'],rB=f"{m['ber']['rB']:016x}",Z=str(m['ber']['Z']),proposal_numerator=str(count),weight_numerator=str(num.numerator)))
   tests.append(f'{mu:016x} {sigma:016x} {U>>64:016x} {U%(2**64):016x} {b} {w0:016x} {w1:016x}\n');answers.append(f"I {m['s']} {k} {j} {m['output']} "+' '.join(f'{m[v]:016x}' for v in ['r','dss','coefficient','delta','gap','tail','x'])+bf(m['ber']));total+=1
   if len(tests)>=1500:flush()
 A=sum(int(a['weight_numerator']) for a in atoms);assert 2**264//8<A<=2**264
 if 'old' in info:
  old=info['old'];assert A==int(old['normalizer_numerator']) and atoms==old['atoms']
 record=dict(game='IID_BUFFER',mu=f'{mu:016x}',sigma=f'{sigma:016x}',origin=info['origin'],domain='D_env',width_classes=classes,Emitted_membership_proved=False,bank=j,s_C=en['s'],r_C=f"{en['r']:016x}",dss_C=f"{en['dss']:016x}",normalizer_numerator=str(A),iteration_denominator=str(2**264),A=str(Q(A,2**264)),atoms=atoms,old_baseline_matches=('old' in info))
 name=f'kernel_{index:03d}.json';p=P/name;p.write_text(json.dumps(record,indent=2)+'\n');catalog.append(dict(path=p.relative_to(W).as_posix(),sha256=sha(p),mu=record['mu'],sigma=record['sigma'],origin=record['origin']))
flush()
(W/'artifacts/kernel_examples.json').write_text(json.dumps(dict(status='PASS_FRESH_EXACT_KERNELS',game='IID_BUFFER',cases=catalog,total=len(catalog),old_baselines_matched=54,native_scalar_atoms=total),indent=2)+'\n')
(W/'artifacts/fixtures.json').write_text(json.dumps(dict(status='PASS_FRESH_DOMAIN_PREFLIGHT_AND_EXPECTED_WORDS',cases=cases,kernels=len(catalog),old_baselines=54,scalar_atoms=total,source_changed=False),indent=2)+'\n');print(json.dumps(dict(status='PASS_FRESH_FIXTURES',kernels=len(catalog),scalar_atoms=total,native_invocations=len(cases)),indent=2))
