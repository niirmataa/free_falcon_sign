"""Independent roots from closed powers, ordinary labels, and polynomial quotient."""
from sage.all import GF,PolynomialRing
import hashlib,json
from pathlib import Path
W=Path.cwd();K=GF(18433);P=PolynomialRing(K,'X');X=P.gen();Phi=X**1536-X**768+1
nodes={};roots={};labels=[];monomials=[];bad=None;controls={}
for line in (W/'checks/lean_values.txt').read_text().splitlines():
    a=line.split()
    if a[0]=='node':
        b,j,w,z=map(int,a[1:5]);assert a[5]=='true'
        u=int(f'{b:09b}'[::-1],2)
        alpha=K(625)**(3*u+1+(u%2));expected=alpha*K(14648)**j
        assert K(w)*K(5184)==alpha and K(z)==expected
        assert Phi(expected)==0
        nodes[b,j]=expected
    elif a[0]=='root':roots[int(a[1])]=int(a[2])
    elif a[0]=='label':labels.append(tuple(map(int,a[1:])))
    elif a[0]=='rem':monomials.append((int(a[1]),list(map(int,a[2:]))))
    elif a[0]=='badrem':bad=(int(a[1]),list(map(int,a[2:])))
    elif a[0]=='control':controls[a[1]]=a[2]
    else:raise AssertionError(a[0])
for (b,j),z in nodes.items():assert z**768==K(roots[b])
for b,m,h,label in labels:
    assert m*(2*h)==1536
    for j in range(3):assert nodes[b,j]**h==K(label)
for k,a in monomials:
    assert len(a)==1536 and P(a)==X**k%Phi
    for z in nodes.values():assert P(a)(z)==z**k
assert bad is not None and P(bad[1])!=X**bad[0]%Phi
assert controls=={'noop':'true','word':'false','index':'false','sign':'false','cubic':'false'}
cases=json.loads((W/'checks/cases.json').read_text());digests=[]
for i,case in enumerate(cases):
    got={row.split()[0]:list(map(int,row.split()[1:])) for row in (W/f'checks/c{i}.txt').read_text().splitlines()}
    prod=P(case['h'])*P(case['r'])%Phi
    p=[int(prod[j]) for j in range(1536)];d=[int((prod-P(case['c']))[j]) for j in range(1536)]
    assert got==dict(p=p,d=d)
    digests.append(hashlib.sha256((W/f'checks/c{i}.txt').read_bytes()).hexdigest())
result=dict(status='PASS',independent_oracle='Sage GF(18433)[X]/(X^1536-X^768+1), closed root powers625',
    selected_nodes=len(nodes),root_label_checks=len(nodes),binary_label_checks=len(labels)*3,
    remMonomial_degrees=[k for k,_ in monomials],remMonomial_evaluations=len(nodes)*len(monomials),
    mutations_detected=['word+1','wrong physical index','wrong split sign','wrong cubic slot','wrong high-degree reduction sign'],
    noop_pass=True,pipeline_cases=[x['name'] for x in cases],pipeline_coefficients_checked=2*2*1536,
    pipeline_sha256=digests,note='Limited controls of new bindings, distinct from universal kernel theorems.')
(W/'artifacts/controls.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
