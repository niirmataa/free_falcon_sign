"""Independent exact quotient-ring/norm oracle and all-source/model comparisons."""
from sage.all import GF,PolynomialRing
import json
from pathlib import Path
W=Path.cwd();K=GF(18433);P=PolynomialRing(K,'X');X=P.gen();phi=X**1536-X**768+1;N=1536;B=2093922385
cases=json.loads((W/'checks/cases.json').read_text());normal=json.loads((W/'checks/native_normal.json').read_text())
san=json.loads((W/'checks/native_san.json').read_text());model={}
for line in (W/'checks/model_values.txt').read_text().splitlines():
    a=line.split();kind,name=a[:2]
    if kind in ['sig','pk']:model[kind,name]=dict(ok=a[2]=='true',used=int(a[3]),values=list(map(int,a[4:])))
    elif kind=='norm':model[kind,name]=dict(ok=a[2]=='true',norm=int(a[3]))
    else:model[kind,name]=dict(out=int(a[2]),correction=int(a[3]),stored_bits=int(a[4]))
def Q0(a):return sum(a[i]*a[i]+a[i]*a[i+768]+a[i+768]*a[i+768] for i in range(768))
def oracle(h,s,c):
    poly=P(h)*P(s)%phi
    d=[(int(poly[i])-c[i])%18433 for i in range(N)]
    first=[x if x<=9216 else x-18433 for x in d]
    ext=[-x for x in first]
    assert Q0(ext)==Q0(first)
    assert all((ext[i]+int(poly[i])-c[i])%18433==0 for i in range(N))
    return first,Q0(first)+Q0(s)
decisions=[]
for case in cases['verify']:
    name=case['name'];obs=normal['observer']['verify'][name];plain=normal['plain']['verify'][name]
    sig=model['sig',name];pk=model['pk',name]
    assert obs['decoded_used']==sig['used'] and (obs['decoded'] or [])==sig['values'],name
    assert obs['pk_ret']==pk['used'] and (obs['pk_values'] or [])==pk['values'],name
    assert obs['load']==int(pk['ok']),name
    c=list(map(int,(W/case['c']).read_text().split()))
    expected=-2 if not pk['ok'] else -1 if not sig['ok'] else None
    Q=None
    if expected is None:
        first,Q=oracle(pk['values'],sig['values'],c)
        expected=int(Q<B)
        assert obs['s1']==first and obs['norm']==Q,(name,obs['norm'],Q)
    else:assert obs['norm'] is None and obs['s1'] is None,name
    assert obs['verify']==expected,(name,obs['verify'],expected)
    assert obs['point_calls']==int(pk['ok'] and sig['ok']),name
    if pk['ok'] and sig['used']:
        _,rq=oracle(pk['values'],sig['values'],c);assert obs['raw']==int(rq<B),name
    else:assert obs['raw']==-9,name
    for key in ['load','verify','point_calls','decoded_used','decoded','raw','pk_ret','pk_values']:assert plain[key]==obs[key],(name,key)
    assert san['observer']['verify'][name]==obs,('san',name)
    decisions.append(dict(name=name,verify=expected,norm=Q,source_plain_matches=True,model_decoder_matches=True,sanitizer_matches=True))
for case in cases['norm']:
    name=case['name'];obs=normal['observer']['norm'][name];plain=normal['plain']['norm'][name];m=model['norm',name]
    a=list(map(int,(W/case['path']).read_text().split()));q=Q0(a[:N])+Q0(a[N:])
    assert q==case['Q']==obs['norm']==m['norm'],name
    assert obs['return']==plain['return']==int(m['ok'])==int(q<B),name
    assert san['observer']['norm'][name]==obs,name
for d in cases['centers']:
    expected=d if d<=9216 else d-18433;m=model['center','c'+str(d)]
    assert m==dict(out=expected,correction=d-expected,stored_bits=expected%65536)
    assert normal['observer']['center'][str(d)]==m==normal['plain']['center'][str(d)]==san['observer']['center'][str(d)]
mut=[]
for name,data in normal.items():
    if name in ['plain','observer']:continue
    changes=[]
    for kind,items in data.items():
        for key,row in items.items():
            if row!=normal['observer'][kind][key]:changes.append(kind+':'+key)
    assert bool(changes)==(name!='noop'),(name,changes)
    mut.append(dict(name=name,detected=bool(changes),differences=changes))
old=next(x for x in decisions if x['name']=='old_witness');assert old['verify']==0 and old['norm']==43058711057
for delta in [0,1,2]:
    for mode in [0,1]:
        row=next(x for x in decisions if x['name']==f'bound_{delta}_{mode}')
        assert row['norm']==B+delta-1 and row['verify']==int(delta==0)
assert next(x for x in decisions if x['name']=='pk_trailing')['verify']==1
result=dict(status='PASS',verify_cases=len(decisions),norm_cases=len(cases['norm']),center_cases=len(cases['centers']),
    baseline_source_models_match=True,plain_observer_decisions_match=True,asan_ubsan_match=True,
    mutations=mut,old_witness=old,strict_boundary_decisions=[x for x in decisions if x['name'].startswith('bound_')],
    decisions=decisions,PK_trailing_bytes_accepted=True,maximum_signature_bytes=max((W/c['sig']).stat().st_size for c in cases['verify']),
    unary_wrap='Universal UnaryRun/ZeroPrefix/unary_skip_zeros/unary_wrap proof; no hundreds-of-MiB payload materialized.',
    oracle='Sage GF(18433)[X]/Phi plus exact integer A2 norm; no call to source NTT in oracle.')
(W/'artifacts/controls.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ['decisions','strict_boundary_decisions']},indent=2))
