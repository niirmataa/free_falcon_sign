import hashlib,json
from pathlib import Path
from jobs import run
W=Path.cwd();sage='/home/footfalcon/.local/bin/sage'
run([sage,'scripts/check_sage.py','fixtures'],'fixtures')
for variant in ['reference','candidate']:
    for mode in ['normal','asan']:
        for kind in ['verify-observed','verify-plain']:
            name='-'.join([kind,variant,mode]);binary=W/'bin'/name
            if binary.exists():
                receipt=json.loads((W/('artifacts/build-'+name+'.json')).read_text())
                assert hashlib.sha256(binary.read_bytes()).hexdigest()==receipt['binary_sha256']
            else:run(['python3','-B','scripts/build.py',kind,variant,mode],'build_'+name)
(W/'artifacts/regressions').mkdir()
cases=[dict(name='witness',payload='inputs/witness/witness.bin',challenge='inputs/witness/witness_c.txt')]
cases+=json.loads((W/'fixtures/positive.json').read_text())
asan_env=json.loads((W/'artifacts/scalar_suite.json').read_text())['sanitizer_options']
rows=[]
for case in cases:
    for variant in ['reference','candidate']:
        for mode in ['normal','asan']:
            for observation in ['observed','plain']:
                name=case['name']+'-'+variant+'-'+mode+'-'+observation
                binary='bin/verify-'+observation+'-'+variant+'-'+mode
                final='artifacts/regressions/'+name+'.json'
                actual=final if mode=='normal' else final.removesuffix('.json')+'.attempt1.json'
                cmd=[binary,'inputs/key/canonical_public_key.bin',case['challenge'],case['payload'],actual]
                r=run(cmd,'reg_'+name,expected=(0,) if mode=='normal' else (0,1),limit=20,extra=asan_env if mode=='asan' else None)
                if r['exit_code']!=0:
                    err=(W/r['stderr']).read_text()
                    assert 'LeakSanitizer' in err and ('ptrace' in err or 'does not work' in err)
                    asan_env={'ASAN_OPTIONS':'detect_leaks=0'}
                    actual=final.removesuffix('.json')+'.attempt2.json';cmd[-1]=actual
                    r=run(cmd,'reg_'+name+'_noleak',limit=20,extra=asan_env)
                if actual!=final:
                    with (W/final).open('xb') as f:f.write((W/actual).read_bytes())
                rows.append(dict(case=case['name'],version=variant,build=mode,observation=observation,
                                 output=final,actual_output=actual,receipt_stdout=r['stdout'],receipt_stderr=r['stderr'],
                                 sanitizer_environment=asan_env.copy() if mode=='asan' else {}))
with (W/'artifacts/regression_runs.json').open('x') as f:json.dump(rows,f,indent=2);f.write('\n')
run([sage,'scripts/check_sage.py','regressions'],'check_regressions')
print(json.dumps({'runs':len(rows),'cases':len(cases),'final_ASAN_environment':asan_env}))
