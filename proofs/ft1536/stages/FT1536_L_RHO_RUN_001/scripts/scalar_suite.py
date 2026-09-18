import json
from pathlib import Path
from jobs import run
W=Path.cwd();sage='/home/footfalcon/.local/bin/sage';receipts=[]
receipts.append(run([sage,'scripts/check_sage.py','scalar','artifacts/scalar-candidate-normal.csv','artifacts/scalar-candidate-normal.json'],'check_candidate_normal'))
run(['python3','-B','scripts/build.py','enum','candidate','asan'],'build_enum_asan')
# Start with leak detection enabled; only the known LSan/ptrace failure can
# license the narrowly scoped retry without LSan.
r=run(['bin/enum-candidate-asan','artifacts/scalar-candidate-asan.csv'],'enum_asan',expected=(0,1),extra={'ASAN_OPTIONS':'detect_leaks=1'})
lsan=False
if r['exit_code']!=0:
    err=(W/r['stderr']).read_text()
    assert 'LeakSanitizer' in err and ('ptrace' in err or 'does not work' in err),'unexpected sanitizer failure'
    lsan=True
    # Preserve this first table, even though execution had an environmental failure.
    run(['bin/enum-candidate-asan','artifacts/scalar-candidate-asan-noleak.csv'],'enum_asan_noleak',extra={'ASAN_OPTIONS':'detect_leaks=0'})
table='artifacts/scalar-candidate-asan-noleak.csv' if lsan else 'artifacts/scalar-candidate-asan.csv'
receipts.append(run([sage,'scripts/check_sage.py','scalar',table,'artifacts/scalar-candidate-asan.json'],'check_candidate_asan'))
mut=[]
for name in ['old_map','early_u16','wrong_modulus','negative_C_remainder','noop']:
    run(['python3','-B','scripts/build.py','enum',name,'normal'],'build_'+name)
    table='artifacts/scalar-'+name+'.csv';out='artifacts/scalar-'+name+'.json'
    run(['bin/enum-'+name+'-normal',table],'enum_'+name)
    result=run([sage,'scripts/check_sage.py','scalar',table,out],'check_'+name,expected=(0,) if name=='noop' else (1,))
    checked=json.loads((W/out).read_text())
    assert checked['complete_unique_coverage'] and ((checked['violations']==0)==(name=='noop'))
    mut.append(dict(name=name,checker_result=out,violations=checked['violations'],counted_as_rejected=name!='noop'))
result=dict(candidate_normal='artifacts/scalar-candidate-normal.json',candidate_asan='artifacts/scalar-candidate-asan.json',
            asan_table=table if False else ('artifacts/scalar-candidate-asan-noleak.csv' if lsan else 'artifacts/scalar-candidate-asan.csv'),
            lsan_environment_failure=lsan,sanitizer_options={'ASAN_OPTIONS':'detect_leaks=0' if lsan else 'detect_leaks=1'},
            mutants=mut,independent_checker='scripts/check_sage.py (unchanged for all tables)')
with (W/'artifacts/scalar_suite.json').open('x') as f:json.dump(result,f,indent=2);f.write('\n')
print(json.dumps(result,indent=2))
