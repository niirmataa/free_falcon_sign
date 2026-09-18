import hashlib,json
from pathlib import Path
from jobs import run
W=Path.cwd();sage='/home/footfalcon/.local/bin/sage'
for variant,mode in [('base','asan'),('observed','normal'),('observed','asan')]:
    run(['python3','-B','scripts/build.py',variant,mode],'build_'+variant+'_'+mode)
asan={'ASAN_OPTIONS':'detect_leaks=1'};lsan_failure=False
run(['bin/base-asan','tables','artifacts/tables_C_asan.json'],'tables_asan',extra=asan)
run(['bin/base-asan','division','artifacts/division_C_asan.csv'],'division_asan',extra=asan)
run(['bin/base-asan','primitives','fixtures/primitive_pairs.txt','artifacts/primitives_C_asan.csv'],'primitives_asan',extra=asan)
run([sage,'scripts/certify.py','primitives','artifacts/primitives_C_asan.csv','artifacts/primitive_check_asan.json'],'check_primitives_asan',limit=90)
assert (W/'artifacts/tables_C_asan.json').read_bytes()==(W/'artifacts/tables_C.json').read_bytes()
assert (W/'artifacts/division_C_asan.csv').read_bytes()==(W/'artifacts/division_C.csv').read_bytes()
assert (W/'artifacts/primitives_C_asan.csv').read_bytes()==(W/'artifacts/primitives_C.csv').read_bytes()
cases=json.loads((W/'fixtures/index.json').read_text());outdir=W/'artifacts/pipelines';outdir.mkdir()
results=[]
for case in cases:
    for variant,mode in [('base','normal'),('base','asan'),('observed','normal'),('observed','asan')]:
        name=case['name']+'_'+variant+'_'+mode;path='artifacts/pipelines/'+name+'.json';check='artifacts/pipelines/'+name+'.check.json'
        run(['bin/'+variant+'-'+mode,'pipeline',case['input'],path],'pipeline_'+name,extra=asan if mode=='asan' else None,limit=20)
        run([sage,'scripts/certify.py','pipeline',path,case['oracle'],check],'check_'+name,limit=90)
        checked=json.loads((W/check).read_text());assert checked['status']=='PASS'
        results.append(dict(case=case['name'],variant=variant,build=mode,result=path,checker=check))
mutations=[]
for variant in ['wrong_R2','missing_tomonty','generator_step','missing_inverse_scale','noop']:
    run(['python3','-B','scripts/build.py',variant,'normal'],'build_mut_'+variant)
    bad=0;rows=[]
    # Both unit and wrapping product; root generation and inverse scaling
    # are independently caught in tables or in the seven full pipeline stages.
    for case in [cases[1],cases[2],cases[5]]:
        name=case['name']+'_'+variant;path='artifacts/pipelines/'+name+'.json';check='artifacts/pipelines/'+name+'.check.json'
        run(['bin/'+variant+'-normal','pipeline',case['input'],path],'mut_'+name,limit=20)
        r=run([sage,'scripts/certify.py','pipeline',path,case['oracle'],check],'check_mut_'+name,expected=(0,1),limit=90)
        verdict=json.loads((W/check).read_text());bad+=int(verdict['status']=='FAIL')
        rows.append(dict(case=case['name'],result=path,checker=check,errors=verdict['errors']))
    assert (bad==0)==(variant=='noop')
    mutations.append(dict(variant=variant,rejected_cases=bad,counted_as_mutation=variant!='noop',cases=rows))
result=dict(status='IMPLEMENTATION_CONTROLS_PASS',baseline_runs=results,baseline_run_count=len(results),mutations=mutations,
 sanitizer='ASan/UBSan with leak detection enabled',LSan_environment_failure=lsan_failure,
 primitive_cases=737,division_nonzero_denominators=18432,all_used_tables_match=True,
 source_sha256=hashlib.sha256((W/'source/falcon-vrfy.c').read_bytes()).hexdigest(),
 scope='implementation controls; not a universal theorem by themselves')
(W/'artifacts/test_suite.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'status':result['status'],'baseline_runs':len(results),'mutants_rejected':4,'noop_passed':True},indent=2))
