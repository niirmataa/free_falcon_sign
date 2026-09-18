"""Two explicit public cases for the newly closed product/rho composition."""
import hashlib,json
from pathlib import Path
W=Path.cwd();C=W/'checks';C.mkdir(exist_ok=True);(W/'bin').mkdir(exist_ok=True)
q=18433;cases=[]
h=[(31*i+7)%q for i in range(1536)];r=[(17*i*i+23*i+11)%q for i in range(1536)];c=[(73*i+19)%q for i in range(1536)]
cases.append(dict(name='canonical_dense',rho=False,h=h,r=r,c=c))
h=[0]*1536
for i,v in [(0,1),(767,18432),(768,2),(1535,3)]:h[i]=v
s=[(97*i+12345)%65536-32768 for i in range(1536)]
s[:8]=[-32768,-18434,-18433,-1,0,18432,18433,32767]
cases.append(dict(name='rho_boundaries',rho=True,h=h,r=s,c=[(i*i+1)%q for i in range(1536)]))
for i,case in enumerate(cases):
    values=[int(case['rho'])]+case['h']+case['r']+case['c']
    with (C/f'case{i}.txt').open('x') as f:f.write(' '.join(map(str,values))+'\n')
with (C/'cases.json').open('x') as f:json.dump(cases,f,indent=2);f.write('\n')
print(json.dumps(dict(cases=2,fixture_sha256=hashlib.sha256((C/'cases.json').read_bytes()).hexdigest(),synthetic_public=True)))
