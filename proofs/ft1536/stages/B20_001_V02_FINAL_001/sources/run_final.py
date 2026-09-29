"""Receipt-complete own Sage/C/Lean controls, after independent P02 replay."""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time

W = Path(__file__).resolve().parents[2]
R = W.parents[4]
O = W/'inputs/subject'
S = W/'run/own_controls'
D = W/'run/own_final_001'
IN = O/'inputs/source17'
P01 = R/'proofs/ft1536/work/B20_001/P01'
LEAN = '/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
SAGE = '/home/footfalcon/.local/bin/sage'
MAX = 8 * 1024**3


def digest(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for block in iter(lambda: f.read(1024*1024), b''):
            h.update(block)
    return h.hexdigest()


def utc():
    return datetime.now(timezone.utc).isoformat()


def main():
    assert not D.exists()
    for name in ('source','build','logs','home','tmp','cache','sage','config','data'):
        (D/name).mkdir(parents=True, exist_ok=True)
    for src in ('check_words.sage','check_pinned.c','ReviewChecks.lean'):
        shutil.copyfile(S/src,D/'source'/src)
        (D/'source'/src).chmod(0o444)
    shutil.copyfile(D/'source/check_words.sage',D/'build/check_words.sage')
    before = {p.name:digest(p) for p in (D/'source').iterdir()}
    assert digest(O/'inputs/source17/fpr-emulated.h') == '6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
    assert digest(O/'inputs/source17/shake.c') == 'c3e7864bf4139264f8c287053214bf869e242757bf555235da81454e40ea316a'
    assert digest(O/'REPORT.md') == 'ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5'
    libs = [P01/'bootstrap/mathlib4/.lake/build/lib/lean'] + [p/'.lake/build/lib/lean'
            for p in sorted((P01/'run/.lake/packages').iterdir()) if p.is_dir()]
    env = {'PATH':'/home/footfalcon/.local/bin:/home/footfalcon/miniforge3/envs/sage/bin:/usr/bin:/bin',
           'LANG':'C.UTF-8', 'HOME':str(D/'home'), 'TMPDIR':str(D/'tmp'),
           'TMP':str(D/'tmp'), 'TEMP':str(D/'tmp'), 'DOT_SAGE':str(D/'sage'),
           'XDG_CACHE_HOME':str(D/'cache'), 'XDG_CONFIG_HOME':str(D/'config'),
           'XDG_DATA_HOME':str(D/'data'), 'PYTHONDONTWRITEBYTECODE':'1',
           'ASAN_OPTIONS':'detect_leaks=0','OMP_NUM_THREADS':'1',
           'OPENBLAS_NUM_THREADS':'1','LEAN_PATH':':'.join(map(str,[W/'run/v02_fresh_001/build']+libs))}
    sandbox = ['/usr/bin/bwrap','--die-with-parent','--unshare-net','--ro-bind','/','/',
               '--proc','/proc','--dev-bind','/dev','/dev','--bind',str(D),str(D),
               '--ro-bind',str(D/'source'),str(D/'source'),
               '--ro-bind',str(IN),str(IN),'--bind',str(D/'tmp'),'/tmp']
    rec = {'schema':'V02_OWN_FINAL_CONTROLS_V1','start':utc(),'source_before':before,
           'source_pin':{'fpr-emulated.h':digest(IN/'fpr-emulated.h'),
                         'shake.c':digest(IN/'shake.c')},
           'environment':env,'network':'unshare-net','steps':[],
           'reason':'receipt-complete rerun of own controls after first successful checks lacked exact per-job timestamps'}

    def step(name, command, cwd, expected=0, as_limit=True, timeout=300):
        n = len(rec['steps'])
        argv = sandbox + ['--chdir',str(cwd)]
        if as_limit:
            argv += ['/usr/bin/prlimit','--as='+str(MAX),'--']
        argv += list(command)
        stdout = D/'logs'/f'{n:03d}_{name}.stdout'
        stderr = D/'logs'/f'{n:03d}_{name}.stderr'
        started = utc(); t0 = time.monotonic(); timed_out = False
        with stdout.open('wb') as out, stderr.open('wb') as err:
            p = subprocess.Popen(argv,cwd=cwd,env=env,stdout=out,stderr=err,start_new_session=True)
            try:
                code = p.wait(timeout=timeout)
            except subprocess.TimeoutExpired:
                os.killpg(p.pid,signal.SIGKILL)
                p.wait(); code=124;timed_out=True
        item = {'name':name,'argv':argv,'cwd':str(cwd),'start_utc':started,
                'stop_utc':utc(),'elapsed_s':time.monotonic()-t0,'exit_code':code,
                'expected_exit':expected,'timed_out':timed_out,
                'stdout':str(stdout.relative_to(D)),'stdout_sha256':digest(stdout),
                'stderr':str(stderr.relative_to(D)),'stderr_sha256':digest(stderr)}
        rec['steps'].append(item)
        print(name,'exit',code,'expected',expected,flush=True)
        assert not timed_out and code == expected, name
        if code == 0:
            assert stderr.stat().st_size == 0 and 'warning:' not in stdout.read_text(errors='replace'), name

    error = None
    try:
        step('sage', [SAGE,'check_words.sage'],D/'build')
        summary=json.loads((D/'build/sage_result.json').read_text())
        assert summary['rows']==1437 and summary['preparser'] is True
        assert digest(D/'build/review_vectors.tsv') == digest(W/'run/own_sage_005/build/review_vectors.tsv')
        base = ['/usr/bin/gcc','-std=c11','-O1','-Wall','-Wextra','-ffunction-sections',
                '-fdata-sections','-Wl,--gc-sections','-I',str(IN),str(D/'source/check_pinned.c')]
        step('ubsan_compile',base+['-fsanitize=undefined','-fno-sanitize-recover=all',
                                   '-o',str(D/'build/check_ubsan')],D/'build')
        step('ubsan_execute',[str(D/'build/check_ubsan'),str(D/'build/review_vectors.tsv')],D/'build')
        step('asan_compile',base+['-g','-fsanitize=address,undefined','-fno-sanitize-recover=all',
                                 '-o',str(D/'build/check_asan')],D/'build')
        step('asan_execute',[str(D/'build/check_asan'),str(D/'build/review_vectors.tsv')],
             D/'build',as_limit=False)
        step('lean', [LEAN,'-j1','-M2048','--root='+str(D/'source'),
                      '-o',str(D/'build/ReviewChecks.olean'),str(D/'source/ReviewChecks.lean')],
             D/'source', timeout=1800)
        for name, expected in (('sign',1),('shift',1),('rounding',1),('invalid_shift',4)):
            fixture=W/'run/own_mutations_001'/f'{name}.tsv'
            shutil.copyfile(fixture,D/'build'/f'{name}.tsv')
            assert digest(fixture)==digest(D/'build'/f'{name}.tsv')
            step('negative_'+name,[str(D/'build/check_ubsan'),str(D/'build'/f'{name}.tsv')],
                 D/'build',expected=expected)
    except Exception as exc:
        error=repr(exc)
    rec['stop']=utc()
    rec['source_after']={p.name:digest(p) for p in (D/'source').iterdir()}
    rec['sources_unchanged']=(before == rec['source_after'])
    rec['result']='PASS' if error is None and rec['sources_unchanged'] else 'FAILED'
    rec['error']=error
    products=['review_vectors.tsv','sage_result.json','ReviewChecks.olean'] + [n+'.tsv' for n in ('sign','shift','rounding','invalid_shift')]
    rec['products']={name:digest(D/'build'/name) for name in products if (D/'build'/name).is_file()}
    (D/'receipt.json').write_text(json.dumps(rec,indent=2,sort_keys=True)+'\n')
    assert rec['result']=='PASS',error
    assert len(rec['steps'])==10
    print(json.dumps({'result':rec['result'],'steps':len(rec['steps']),
                      'sage_rows':summary['rows'],'sources_unchanged':True},sort_keys=True))


if __name__=='__main__':
    main()
