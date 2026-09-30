from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ
A=matrix(ZZ,[[2,1],[1,2]])
data=[]
for flag in [0,1]:
    v=pari(A).qfrep(64,flag)
    data.append(dict(flag=int(flag),type=str(v.type()),values=[str(v[i]) for i in range(min(16,len(v)))]))
manual=[sum(ZZ(a*a+a*b+b*b==n) for a in range(-10,11) for b in range(-10,11)) for n in range(1,17)]
Path('qfrep_probe.json').write_text(json.dumps(dict(cases=data,manual=[str(x) for x in manual]),indent=int(2))+'\n')
print(json.dumps(dict(cases=data,manual=[str(x) for x in manual])))
