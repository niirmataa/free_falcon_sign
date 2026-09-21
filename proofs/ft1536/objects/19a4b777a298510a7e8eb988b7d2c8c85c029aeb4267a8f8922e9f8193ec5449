import hashlib,json,os,signal,subprocess,sys,time
from pathlib import Path
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];logs=W/'checks/logs'/mode;logs.mkdir(parents=True,exist_ok=True)
flags=json.loads((W/'artifacts/compiler_flags.json').read_text())['argv'];records=[]
def run(tag,args,limit=30):
    t=time.monotonic();p=subprocess.Popen(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
    try:o,e=p.communicate(timeout=limit)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
    so=logs/(tag+'.stdout');se=logs/(tag+'.stderr');so.write_bytes(o);se.write_bytes(e)
    records.append(dict(argv=args,cwd=str(W),exit_code=p.returncode,timeout=timed,limit_seconds=limit,elapsed=time.monotonic()-t,
      stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(o).hexdigest(),stderr_sha256=hashlib.sha256(e).hexdigest()))
    (W/f'artifacts/{mode}_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
    assert not timed and p.returncode==0,(tag,o.decode(),e.decode())
    return o
out={}
for variant in (['baseline'] if mode=='san' else ['baseline','noop','terminator','j7','framing']):
    exe='bin/'+mode+'_'+variant
    san=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if mode=='san' else []
    run('gcc_'+variant,['/usr/bin/gcc','-std=c99']+flags+san+['-ffunction-sections','-fdata-sections','-Isource','checks/'+variant+'_main.c','-Wl,--gc-sections','-o',exe],60)
    out[variant]={}
    for case in (['witness','exact3073','zero','not_short'] if variant in ['baseline','noop'] else ['witness']):
        out[variant][case]=json.loads(run(variant+'_'+case,[exe,case]))
(W/f'checks/native_{mode}.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(mode=mode,variants=list(out),runs=len(records)),indent=2))
