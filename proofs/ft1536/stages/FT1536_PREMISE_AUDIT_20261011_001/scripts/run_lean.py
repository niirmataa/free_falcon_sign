"""One isolated Lean process; immutable attempt sources and raw receipts."""
from pathlib import Path
import os,sys,subprocess,json,hashlib,datetime,time,resource
W=Path(__file__).resolve().parents[1]
LEAN=Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    label,source=sys.argv[1:3];p=W/source
    dest=W/'attempts'/label;dest.mkdir(parents=True,exist_ok=False)
    frozen=dest/p.name;frozen.write_bytes(p.read_bytes())
    cfg=json.loads((W/'CONFIG.json').read_text());env=os.environ.copy()
    env['LEAN_NUM_THREADS']='1'
    env.update({'TMPDIR':str(W/'tmp'),'XDG_CACHE_HOME':str(W/'cache'),
       'LEAN_PATH':':'.join(([env['AUDIT_LEAN_LIB']] if env.get('AUDIT_LEAN_LIB') else [])+[str(W/'lib')]+[e['build'] for e in cfg['library_roots'].values()])})
    cmd=[str(LEAN),'-j1','-M6144','-DElab.async=false','-o',str(dest/(p.stem+'.olean')),str(frozen)]
    start=datetime.datetime.now(datetime.timezone.utc).isoformat();t=time.monotonic()
    def limit():resource.setrlimit(resource.RLIMIT_AS,(24*1024**3,24*1024**3))
    with (dest/'stdout.log').open('wb') as out,(dest/'stderr.log').open('wb') as err:
        try:code=subprocess.run(cmd,cwd=W,env=env,stdout=out,stderr=err,timeout=600,preexec_fn=limit).returncode
        except subprocess.TimeoutExpired:code=124
    logs=(dest/'stdout.log').read_text(errors='replace')+(dest/'stderr.log').read_text(errors='replace')
    rec={'label':label,'argv':cmd,'cwd':str(W),'start_utc':start,'stop_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
         'elapsed_s':time.monotonic()-t,'exit_code':code,'source':str(frozen.relative_to(W)),
         'source_sha256':sha(frozen),'runner_sha256':sha(Path(__file__)),'lean_sha256':sha(LEAN),
         'clean_log':code==0 and 'warning:' not in logs and 'error:' not in logs,
         'stdout_sha256':sha(dest/'stdout.log'),'stderr_sha256':sha(dest/'stderr.log'),
         'maxrss_kib':resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
         'environment':{k:env[k] for k in ['TMPDIR','XDG_CACHE_HOME','LEAN_PATH']}}
    if (dest/(p.stem+'.olean')).exists():rec['olean_sha256']=sha(dest/(p.stem+'.olean'))
    (dest/'RECEIPT.json').write_text(json.dumps(rec,indent=2)+'\n')
    print(json.dumps({k:v for k,v in rec.items() if k not in ('environment','argv')},indent=2));print(logs[:7000])
    sys.exit(code)
if __name__=='__main__':main()
