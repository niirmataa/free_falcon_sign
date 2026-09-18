"""Read-only cross-binding checks; no promotion of the conditional theorem."""
import argparse,hashlib,json,re,stat
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--originals',action='store_true');p.add_argument('--out',default='artifacts/audit.json');args=p.parse_args()
W=Path.cwd()
def data(path):
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [path,*path.parents]);assert stat.S_ISREG(path.lstat().st_mode)
    return path.read_bytes()
def sha(path):return hashlib.sha256(data(path)).hexdigest()
def load(rel):return json.loads(data(W/rel))
source_sha='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
assert sha(W/'source/falcon-vrfy.c')==source_sha
mf=data(W/'inputs/source_hashes.sha256');assert hashlib.sha256(mf).hexdigest()=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
for line in mf.decode().splitlines():
    h,name=line.split();assert sha(W/'source'/name)==h
binding=load('artifacts/source_binding.json');lines=data(W/'source/falcon-vrfy.c').decode().splitlines(True)
for row in binding['slices']:
    lo,hi=row['lines'];expected=''.join(lines[lo-1:hi]).encode()
    assert data(W/row['path'])==expected and sha(W/row['path'])==row['sha256']
observed=data(W/'observed/falcon-vrfy.c').decode()
assert observed.replace(binding['observer_injection'],'',1)==data(W/'source/falcon-vrfy.c').decode()
assert sha(W/'observed/falcon-vrfy.c')==binding['observer_sha256']
cert=load('artifacts/constants_certificate.json');actual=load('artifacts/tables_C.json');literals=load('artifacts/kernel_literals.json')
assert cert['source_tables_sha256']==sha(W/'artifacts/tables_C.json')==literals['tables_C_sha256']
assert cert['gm']==actual['gm'] and cert['igm']==actual['igm']
assert len(actual['gm'])==len(actual['igm'])==1024
assert cert['source_sha256']==source_sha==literals['source_sha256']
assert cert['initialized_indices']==list(range(1024)) and sorted(cert['generator_writes'])==list(range(1024))
assert all(0<=i<1024 for i in cert['generator_reads'])
assert [r['exponent'] for r in cert['division_schedule']]==[1,2,3,6,7,14,28,35,63,126,252,287,574,1148,2296,4592,9184,18368,18431]
gm,ig=actual['gm'],actual['igm'];q=18433
assert literals['families']['units']==[[i,gm[i],ig[i]] for i in range(1024)]
assert literals['families']['parents']==[[i,2*i,gm[2*i],gm[i],ig[2*i],ig[i]] for i in range(1,512)]
assert literals['families']['tree']==[[2 if i<256 else 3,i,gm[i],gm[2*i],gm[2*i+1]] for i in range(2,512)]
assert literals['families']['sequence']==cert['generator_rows']
def mul(a,b):return a*b%q
rows2=[]
def two(A,I):
    for j in range(2):rows2.append(I[j]+A[0]+A[1]+[2 if j==0 else 0,2 if j==1 else 0])
a=gm[1]*5184%q;rr=ig[0]*5184%q
two([[1,a],[1,(1-a)%q]], [[(1-rr)%q,(1+rr)%q],[2*rr%q,-2*rr%q]])
for j in range(2,512):
    s=gm[j]*5184%q;si=ig[j]*5184%q;two([[1,s],[1,-s%q]],[[1,1],[si,-si%q]])
assert rows2==literals['families']['rows2']
rows3=[];omega=a*a%q;wi=(ig[1]*5184%q)**2%q
for j in range(512,1024):
    x=gm[j]*5184%q;ix=ig[j]*5184%q
    A=[[1,x,x*x%q],[1,x*omega%q,x*x*omega*omega%q],[1,x*omega*omega%q,x*x*omega%q]]
    I=[[1,1,1],[ix,ix*wi%q,ix*wi*wi%q],[ix*ix%q,ix*ix*wi*wi%q,ix*ix*wi%q]]
    for k in range(3):rows3.append(I[k]+sum(A,[])+[3 if i==k else 0 for i in range(3)])
assert rows3==literals['families']['rows3']
text=data(W/'formal/Tables.lean').decode();assert sha(W/'formal/Tables.lean')==literals['lean_sha256']
for family,expected in literals['families'].items():
    chunks=re.findall(r'def '+family+r'_(\d+) : List \(List Int\) := (\[\[.*?\]\])\n',text,re.S)
    assert [int(k) for k,_ in chunks]==list(range((len(expected)+31)//32))
    recovered=[]
    for _,literal in chunks:recovered.extend(json.loads(literal))
    assert recovered==expected,family
commands=[json.loads(x) for x in data(W/'COMMANDS.log').splitlines()]
formal=[];total=0
for name in ['Words','Linear','Tables','Composition']:
    rel='formal/'+name+'.lean';t=data(W/rel).decode();names=re.findall(r'^theorem (\w+)',t,re.M)
    assert not re.search(r'\b(sorry|admit|axiom|unsafe|native_decide)\b',t)
    receipt=next(r for r in reversed(commands) if r.get('argv',[])[-1:]==[rel] and r.get('exit_code')==0)
    out=data(W/receipt['stdout']).decode();assert 'sorryAx' not in out and 'error:' not in out
    for th in names:assert '.'+th+"' " in out,(rel,th)
    axioms=set()
    for s in re.findall(r'depends on axioms: \[([^]]*)\]',out):axioms.update(x.strip() for x in s.split(','))
    assert axioms<={'propext','Classical.choice','Quot.sound'}
    total+=len(names);formal.append(dict(file=rel,sha256=sha(W/rel),theorems=len(names),axioms=sorted(axioms),receipt=receipt['stdout']))
assert 'forward_product : ∀ h r' in data(W/'formal/Composition.lean').decode()
assert 'inverse_forward : ∀ a' in data(W/'formal/Composition.lean').decode()
test=load('artifacts/test_suite.json');assert test['status']=='IMPLEMENTATION_CONTROLS_PASS' and test['baseline_run_count']==28
fixtures={x['name']:x for x in load('fixtures/index.json')}
for row in test['baseline_runs']:
    checked=load(row['checker']);assert checked['status']=='PASS'
    assert checked['input_sha256']==sha(W/row['result'])
    assert checked['oracle_sha256']==sha(W/fixtures[row['case']]['oracle'])
for row in test['mutations']:
    assert (row['rejected_cases']==0)==(row['variant']=='noop')
    for case in row['cases']:
        checked=load(case['checker']);assert checked['input_sha256']==sha(W/case['result'])
        assert checked['oracle_sha256']==sha(W/fixtures[case['case']]['oracle'])
for path in (W/'artifacts').glob('build-*.json'):
    built=json.loads(data(path));assert built['exit_code']==0
    assert sha(W/built['source'])==built['source_sha256']
    assert sha(W/built['binary'])==built['binary_sha256']
assert load('artifacts/primitive_check.json')['errors']==[]
assert load('artifacts/primitive_check_asan.json')['errors']==[]
for r in commands:
    for key,h in r.get('stream_sha256',{}).items():assert sha(W/r[key])==h
originals=0
for row in load('inputs/provenance.json'):
    assert sha(W/row['copy'])==row['sha256']
    if args.originals:assert sha(Path(row['path']))==row['sha256'];originals+=1
out=dict(status='BINDINGS_VERIFIED',source_files=17,original_inputs_checked=originals,formal=formal,total_theorems=total,
         kernel_constant_record_counts=literals['counts'],baseline_pipelines=28,primitive_cases=737,division_denominators=18432,
         final_theorem='L_NTT_after_global_interfaces',final_theorem_scope='CONDITIONAL_NOT_INSTANTIATED_FOR_SOURCE',
         permitted_main_verdict='PARTIAL_PROOF',global_open=['FORWARD_GLOBAL','INVERSE_GLOBAL','SOURCE_GLOBAL_INSTANTIATION'])
with (W/args.out).open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
