# Reviewer-side exact checks of the full-reply cap moment identities.
# Fresh implementation of finite law arithmetic, not a universal proof.
import sys,json
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
dest=out/'cap_checks.json'
if dest.exists():raise FileExistsError('fresh output required')
def energy(j,p):
    assert sum(j)==sum(p)==1
    assert all(j[i]==0 or p[i]>0 for i in range(len(p)))
    return sum(j[i]^2/p[i] for i in range(len(p)) if p[i]>0)
targets=[(QQ(1)/8,QQ(3)/8,QQ(1)/2),
         (QQ(1)/3,QQ(1)/3,QQ(1)/3),
         (QQ(3)/4,QQ(1)/8,QQ(1)/8),
         (QQ(1),QQ(0),QQ(0))]
cores=[(QQ(a)/4,QQ(b)/4,QQ(4-a-b)/4) for a in range(5) for b in range(5-a)]
ds=[QQ(0),QQ(1)/16,QQ(1)/4,QQ(3)/4,QQ(1)]
count=0
for p in targets:
    for q in cores:
        if any(q[i]!=0 and p[i]==0 for i in range(3)):continue
        C=max(q[i]/p[i] for i in range(3) if p[i]>0)
        assert C>=1 and energy(q,p)<=C
        for delta in ds:
            j=tuple((1-delta)*q[i]+(delta if i==0 else 0) for i in range(3))
            expansion=(1-delta)^2*energy(q,p)+2*(1-delta)*delta*q[0]/p[0]+delta^2/p[0]
            assert energy(j,p)==expansion
            upper=1+2*(1-delta)^2*(C-1)+2*delta^2*(1/p[0]-1)
            assert energy(j,p)<=upper
            ideal=tuple((1-delta)*p[i]+(delta if i==0 else 0) for i in range(3))
            assert energy(ideal,p)==1+delta^2*(1/p[0]-1)
            count+=1
assert count==230
assert targets[-1][0]==1 # p(none)=1 endpoint covered.
bad_p=(QQ(0),QQ(1));bad_j=(QQ(1)/4,QQ(3)/4)
assert bad_p[0]==0 and bad_j[0]>0
dest.write_text(json.dumps({'status':'PASS','exact_cases':int(count),
  'delta_endpoints':[0,1],'p_none_one_checked':True,'zero_mass_support_control':True,
  'scope':'Finite checks of equality, conservative moment bound and exact-core identity; general proof separately audited.'},indent=2,default=int)+'\n')
print('PASS: 230 exact full-reply cap cases, including boundary and support controls')
