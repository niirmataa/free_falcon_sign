"""Independent exact arithmetic. Run this .py through the installed sage wrapper."""
import csv, hashlib, json, sys
from pathlib import Path
import sage.version
from sage.all import ZZ, GF, PolynomialRing
W=Path.cwd(); N=1536;q=ZZ(18433);B=ZZ(2093922385)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def put(rel,value):
    with (W/rel).open('x') as f:json.dump(value,f,indent=2);f.write('\n')
def versions():return dict(sage_version=sage.version.version,python_version=sys.version)
def energy(v):
    a=list(map(ZZ,v));return sum((a[i]*a[i]+a[i]*a[i+768]+a[i+768]*a[i+768] for i in range(768)),ZZ(0))
def encode(s,mode):
    if mode==0:return bytes([0x8a])+b''.join((int(x)%65536).to_bytes(2,'big') for x in s)
    bits=''.join(str(int(x<0))+format(abs(int(x))%256,'08b')+'0'*(abs(int(x))//256)+'1' for x in s)
    bits+='0'*((-len(bits))%8)
    return bytes([0xaa])+bytes(int(bits[i:i+8],2) for i in range(0,len(bits),8))

mode=sys.argv[1]
if mode=='scalar':
    path=W/sys.argv[2]; output=sys.argv[3]; rows=list(csv.DictReader(path.open()))
    assert len(rows)==65536 and list(rows[0])==['x','rho']
    assert [int(r['x']) for r in rows]==list(range(-32768,32768)), 'coverage/order/duplicates'
    errors=[];bad=0;old_can=0;old_cong=0;agree=0;edges={}
    edge_set={-32768,32767,-18434,-18433,-18432,-1,0,1,18432,18433,18434,-20000}
    for row in rows:
        x=ZZ(row['x']);y=ZZ(row['rho']);wanted=x%q
        flags=[]
        if not 0<=y<q:flags.append('RANGE')
        if (y-x)%q!=0:flags.append('CONGRUENCE')
        if y!=wanted:flags.append('CANONICAL_VALUE')
        if flags:
            bad+=1
            if len(errors)<16:errors.append(dict(x=int(x),actual=int(y),expected=int(wanted),reasons=flags))
        old=(x+(q if x<0 else 0))%65536
        canonical=(0<=old<q);congruent=((old-x)%q==0)
        assert canonical==(-q<=x<q)
        assert congruent==(-q<=x)
        old_can+=int(canonical);old_cong+=int(congruent)
        if canonical and old==y:agree+=1
        if int(x) in edge_set:edges[str(x)]=dict(actual=int(y),expected=int(wanted),old=int(old))
    result=dict(status='SCALAR_PASS' if bad==0 else 'SCALAR_FAIL',**versions(),rows=65536,
                complete_unique_coverage=True,table_sha256=sha(path),violations=bad,first_failures=errors,
                old_canonical_count=old_can,old_congruence_count=old_cong,agreement_on_old_canonical=agree,edges=edges)
    put(output,result);print(json.dumps(result,indent=2));sys.exit(0 if bad==0 else 1)
elif mode=='fixtures':
    d=W/'fixtures';d.mkdir()
    h=list(map(ZZ,(W/'inputs/key/canonical_public_h.txt').read_text().split()));assert len(h)==N
    P=PolynomialRing(GF(q),'X');X=P.gen();phi=X**N-X**768+1;hp=P(h)
    fixtures=[]
    for k in range(3):
        s=[0]*N;v=[0]*N;v[0]=3;v[768]=-2
        if k==1:s[1535]=-17
        if k==2:s[0]=9;s[768]=-4;v=[0]*N;v[1]=5;v[769]=-3
        cp=(hp*P(s)-P(v))%phi;c=[int(cp[i]) for i in range(N)]
        for codec in [0,1]:
            name=f'positive_{k}_{codec}';b=encode(s,codec)
            (d/(name+'.bin')).write_bytes(b)
            (d/(name+'.txt')).write_text(''.join(str(x)+'\n' for x in c))
            fixtures.append(dict(name=name,s=s,c=c,norm_first=v,norm=int(energy(v)+energy(s)),
              payload='fixtures/'+name+'.bin',challenge='fixtures/'+name+'.txt',expected_verify=1))
    put('fixtures/positive.json',fixtures)
    print(json.dumps(dict(status='EXACT_FIXTURES',**versions(),cases=len(fixtures),product='GF(q)[X] remainder by Phi'),indent=2))
elif mode=='regressions':
    w=json.loads((W/'inputs/witness/witness.json').read_text());fixtures=json.loads((W/'fixtures/positive.json').read_text())
    h=list(map(ZZ,(W/'inputs/key/canonical_public_h.txt').read_text().split()))
    P=PolynomialRing(GF(q),'X');X=P.gen();phi=X**N-X**768+1;hp=P(h)
    cases=[dict(name='witness',s=w['s'],c=w['c'],norm_first=None,norm=None)]+fixtures
    checks=[]
    for case in cases:
        s=case['s'];cp=(hp*P(s)-P(case['c']))%phi
        correct_first=[int((ZZ(cp[i])+9216)%q-9216) for i in range(N)]
        for version in ['reference','candidate']:
            for build in ['normal','asan']:
                prefix='artifacts/regressions/'+case['name']+'-'+version+'-'+build
                observed=json.loads((W/(prefix+'-observed.json')).read_text())
                plain=json.loads((W/(prefix+'-plain.json')).read_text())
                assert observed['decoded_s']==observed['norm_second']==plain['decoded_s']==s
                assert observed['signed_s_unchanged'] and plain['signed_s_unchanged']
                assert observed['point_calls']==plain['point_calls']==1
                expected_pre=[int(ZZ(x)%q) if version=='candidate' else int((ZZ(x)+(q if x<0 else 0))%65536) for x in s]
                assert observed['pre_ntt']==expected_pre
                if version=='candidate':assert all(0<=x<q for x in observed['pre_ntt'])
                if case['name']=='witness' and version=='reference':
                    first=[0]*N;expected_v=1;expected_norm=400000000
                else:
                    first=correct_first;expected_norm=int(energy(first)+energy(s))
                    expected_v=int(expected_norm<B)
                assert observed['norm_first']==first
                assert observed['norm']==expected_norm
                assert observed['verify']==observed['raw']==plain['verify']==plain['raw']==expected_v
                if case['name']!='witness':assert expected_v==1 and first==case['norm_first'] and expected_norm==case['norm']
                else:
                    assert observed['pre_ntt'][0]==(16866 if version=='candidate' else 63969)
                    assert expected_norm==(43058711057 if version=='candidate' else 400000000)
                checks.append(dict(case=case['name'],version=version,build=build,verify=expected_v,norm=expected_norm,
                                   normalized_s0=observed['pre_ntt'][0],signed_s0=s[0]))
    out=dict(status='REGRESSIONS_PASS',**versions(),checks=checks,observed_and_plain_runs=2*len(checks),
             norm_and_product='exact ZZ and GF(q)[X], independent of tested NTT',full_L_V_proved=False)
    put('artifacts/regression_check.json',out);print(json.dumps(out,indent=2))
else:raise SystemExit('unknown mode')
