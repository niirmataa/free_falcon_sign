import argparse,hashlib,json,re,stat
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--originals',action='store_true');p.add_argument('--out',default='artifacts/audit.json');a=p.parse_args()
W=Path.cwd()
def read(path):
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [path,*path.parents]);assert stat.S_ISREG(path.lstat().st_mode)
    return path.read_bytes()
def sha(path):return hashlib.sha256(read(path)).hexdigest()
def load(rel):return json.loads(read(W/rel))
bind=load('artifacts/source_binding.json')
for manifest,base in [('inputs/source_hashes.sha256','reference'),('CANDIDATE.sha256','candidate')]:
    rows=read(W/manifest).decode().splitlines();assert len(rows)==17
    for line in rows:
        h,n=line.split();assert sha(W/base/n)==h
assert sha(W/'CANDIDATE.sha256')==bind['candidate_manifest_sha256']
assert sha(W/'candidate.patch')==bind['diff_sha256']
assert sha(W/'candidate/falcon-vrfy.c')==bind['candidate_sha256']
assert sha(W/'reference/falcon-vrfy.c')==bind['reference_sha256']
for v in ['reference','candidate']:
    text=read(W/('observed/'+v+'/falcon-vrfy.c')).decode()
    assert text.replace(bind['observer_injection'],'',1)==read(W/(v+'/falcon-vrfy.c')).decode()
    assert sha(W/('observed/'+v+'/falcon-vrfy.c'))==bind['observed_sources'][v]
candidate=read(W/'candidate/falcon-vrfy.c').decode()
assert candidate.count(bind['helper'])==1 and candidate.count('x[u] = ft1536_normalize_s2(s2[u]);')==1
assert 'if (ternary == 1 && logn == 10)' in candidate
assert 'return falcon_is_short((int16_t *)x, s2, logn, ternary);' in candidate
for name in [line.split()[1] for line in read(W/'inputs/source_hashes.sha256').decode().splitlines() if not line.endswith(' falcon-vrfy.c')]:
    assert read(W/'reference'/name)==read(W/'candidate'/name)
normal=load('artifacts/scalar-candidate-normal.json');asan=load('artifacts/scalar-candidate-asan.json');suite=load('artifacts/scalar_suite.json')
for r in [normal,asan]:
    assert r['status']=='SCALAR_PASS' and r['rows']==65536 and r['violations']==0 and r['complete_unique_coverage']
    assert r['old_canonical_count']==36866 and r['old_congruence_count']==51201 and r['agreement_on_old_canonical']==36866
assert normal['table_sha256']==sha(W/'artifacts/scalar-candidate-normal.csv')==asan['table_sha256']==sha(W/suite['asan_table'])
for row in suite['mutants']:
    r=load(row['checker_result']);assert r['rows']==65536
    assert (r['status']=='SCALAR_PASS')==(row['name']=='noop')
    assert r['table_sha256']==sha(W/('artifacts/scalar-'+row['name']+'.csv'))
assert load('artifacts/scalar-noop.json')['table_sha256']==normal['table_sha256']
reg=load('artifacts/regression_check.json');assert reg['status']=='REGRESSIONS_PASS' and reg['observed_and_plain_runs']==56
for row in load('artifacts/regression_runs.json'):
    x=load(row['output']);assert x['signed_s_unchanged'] and x['verify']==x['raw']
    assert read(W/row['output'])==read(W/row['actual_output'])
text=read(W/'formal/Rho.lean').decode();assert sha(W/'formal/Rho.lean')==bind['formal_sha256']
assert not re.search(r'\b(sorry|admit|axiom|unsafe|native_decide)\b',text)
names=re.findall(r'^theorem (\w+)',text,re.M);assert len(names)==12
commands=[json.loads(l) for l in read(W/'COMMANDS.log').splitlines()]
receipt=next(r for r in reversed(commands) if r.get('argv',[])[-1:]==['formal/Rho.lean'] and r['exit_code']==0)
stdout=read(W/receipt['stdout']).decode();axioms=set()
for name in names:assert "'FT1536."+name+"' " in stdout
assert 'sorryAx' not in stdout and 'error:' not in stdout
for fields in re.findall(r'depends on axioms: \[([^]]*)\]',stdout):axioms.update(x.strip() for x in fields.split(','))
assert axioms<={'propext','Classical.choice','Quot.sound'}
for r in commands:
    for k,h in r.get('stream_sha256',{}).items():assert sha(W/r[k])==h
for path in (W/'artifacts').glob('build-*.json'):
    b=json.loads(read(path));assert b['exit_code']==0 and sha(W/b['source'])==b['source_sha256']
    assert sha(W/b['binary'])==b['binary_sha256']
originals=0
for row in load('inputs/provenance.json'):
    assert sha(W/row['copy'])==row['sha256']
    if a.originals:assert sha(Path(row['path']))==row['sha256'];originals+=1
if a.originals:
    H=Path('/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon/build')
    for line in read(W/'inputs/source_hashes.sha256').decode().splitlines():
        h,n=line.split();assert sha(H/n)==h
out=dict(status='AUDIT_PASS',original_inputs_checked=originals,reference_files=17,candidate_files=17,changed_production_files=['falcon-vrfy.c'],
         scalar_inputs_per_build=65536,scalar_table_sha256=normal['table_sha256'],regression_runs=56,
         formal_theorems=names,axioms=sorted(axioms),formal_receipt=receipt['stdout'],
         candidate_sha256=bind['candidate_sha256'],candidate_manifest_sha256=bind['candidate_manifest_sha256'],
         source_integrated=False,owner_accepted=False,full_L_V='OPEN_FOR_CANDIDATE')
with (W/a.out).open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
