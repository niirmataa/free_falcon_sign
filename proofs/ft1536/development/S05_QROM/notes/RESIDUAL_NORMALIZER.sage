# Exact finite diagnostic for the generic residual-normalizer identity.
# This is a toy model of the identity, not an FT1536 security experiment.
import json,sys
from pathlib import Path
OUT=Path(sys.argv[1]); OUT.mkdir(parents=True,exist_ok=True)
result=OUT/'identity_checks.json'
if result.exists(): raise FileExistsError('Refusing to overwrite '+str(result))
rows=[]
for q in [3,5]:
    domain=list(range(-2,3)); weight={x:QQ(2)^(-x*x) for x in domain}; Z=sum(weight.values())
    fiber={r:sum(weight[x] for x in domain if x%q==r) for r in range(q)}
    assert all(v>0 for v in fiber.values())
    for h in range(q):
        for c in range(q):
            Zhc=sum(weight[y]*fiber[(c-h*y)%q] for y in domain)
            pairs=[(x,y) for x in domain for y in domain if (x+h*y-c)%q==0]
            P={(x,y):weight[x]*weight[y]/Zhc for x,y in pairs}
            J={(x,y):weight[y]/Z*weight[x]/fiber[(c-h*y)%q] for x,y in pairs}
            assert sum(P.values())==1 and sum(J.values())==1
            actual=sum(J[z]^2/P[z] for z in pairs)
            predicted=(sum(weight[y]/Z*fiber[(c-h*y)%q] for y in domain)
                       *sum(weight[y]/Z/fiber[(c-h*y)%q] for y in domain))
            assert actual==predicted and actual>=1
            if h==0: assert actual==1
            rows.append({'q':int(q),'h':int(h),'c':int(c),'second_exact':str(actual)})
assert any(QQ(r['second_exact'])>1 for r in rows if r['h']!=0)
result.write_text(json.dumps({'status':'EXACT_IDENTITY_VERIFIED_IN_34_TOY_CASES',
    'domain':[-2,-1,0,1,2],'weights':'2^(-x^2), exact QQ','cases':rows,
    'non_claims':['Not an FT1536 parameter instantiation.','Does not prove a general useful upper bound.']},indent=2,default=lambda x:int(x) if isinstance(x,Integer) else str(x))+'\n')
print('PASS: 34 exact cases; zero key gives factor 1; nonzero examples expose normalizer variation')
