"""Independent QQ mass/count/geometric and reduced-width cardinality checks."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ
from dyadic import value
from replaylib import sha
W=Path.cwd();cdf=json.loads((W/'CDF_MASS.json').read_text());pmf=json.loads((W/'artifacts/pmf_examples.json').read_text());checks=[]
for c in pmf['examples']:
 data=json.loads((W/c['path']).read_text());T=list(map(ZZ,cdf['banks'][data['bank']]['thresholds']));R=ZZ(2)**128;A=QQ(0);ys=set()
 for atom in data['atoms']:
  k=atom['k'];count=(R-T[0]) if k==0 else T[k-1]-T[k];e=atom['e'];z=ZZ(atom['Z'])
  beta=QQ(0) if e>=64 else QQ(min(z,ZZ(2)**55))/ZZ(2)**(e+55);w=QQ(count)/(2*R)*beta
  assert w==QQ(ZZ(atom['weight_numerator']))/ZZ(2)**264 and atom['y'] not in ys;ys.add(atom['y']);A+=w
 assert A==QQ(data['A']) and QQ(1)/256<=A<=1
 finite=[]
 for n in [1,2,5,16,64]:
  returned=sum(A*(1-A)**k for k in range(n));tail=(1-A)**n;assert returned+tail==1 and tail<=(QQ(255)/256)**n;finite.append(dict(n=n,return_mass=str(returned),tail=str(tail)))
 checks.append(dict(path=c['path'],sha256=sha(W/c['path']),normalizer=str(A),finite_prefix_checks=finite))
# Independent mathematical truncation test ONLY in its small domain.
rawlines=(W/'artifacts/fixtures/high_trunc_comparator.input').read_text().splitlines();answers=(W/'logs/native_normal_high_trunc_comparator.stdout').read_text().splitlines();small=0
for s,a in zip(rawlines,answers):
 x,y,w,z=[int(t,16) for t in s.split()];hi,tr,cmp=a.split();assert int(hi,16)==x*y//2**64 and int(cmp)==int(w<z)
 if (x>>52)&2047<2047:
  v=value(x)
  if 0<=v<2**62:assert int(tr,16)==v.numerator//v.denominator;small+=1
# Reduced-width exhaustive checks are controls of cardinality/bijection, not 128-bit enumeration.
low_checks=0
for h in [4,8,16,32]:
 modulus=8*h
 for z in range(2*h):
  c=sum(((w-z)%modulus)//(modulus//2)==1 for w in range(h));assert c==min(z,h);low_checks+=1
limb_checks=0;B=16
for x in range(B*B):
 for y in range(B*B):
  x0=x%B;x1=x//B;y0=y%B;y1=y//B;a=x0*y1+x0*y0//B;b=x1*y0;c=a//B+b//B+(a%B+b%B)//B+x1*y1;assert c==x*y//(B*B);limb_checks+=1
resources=dict(a_min='1/256',E_N_upper='256',E_returned_bytes_upper='8448',E_new_refills_upper=str(QQ(1)+QQ(33*256)/4087),E_discarded_bytes_upper=str(9*(QQ(1)+QQ(33*256)/4087)),E_new_generated_bytes_upper=str(4096*(QQ(1)+QQ(33*256)/4087)),tail='Pr_IID_BUFFER[N>m|PAST] <= (255/256)^m',ghost_cap_only=True)
out=dict(status='PASS_INDEPENDENT_QQ_MASS_AND_CARDINALITY_CONTROLS',game='IID_BUFFER',conditioning='legal PAST, excluding unread buffer and future tape',pmf_examples=len(checks),checks=checks,small_trunc_native_cases=small,low_comparator_reduced_cases=low_checks,limb_reduced_pairs=limb_checks,resources=resources,real_PRNG_executed=False)
(W/'artifacts/rational_oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='checks'},indent=2))
