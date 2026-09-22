"""Run the authoritative SageMath computations with `sage <file>.sage`.

Pinned launcher /home/footfalcon/.local/bin/sage (SageMath 10.9); the standard
entry is used, with the preparser enabled; HOME/TMPDIR/DOT_SAGE/XDG_CACHE_HOME
are redirected under this durable W.  No network is used.
"""
import fcntl,json,os,subprocess,time
from pathlib import Path
from replaylib import sha
from common import W
COMMANDS_LOG=W/'COMMANDS.log'
def append_record(rec):
    with COMMANDS_LOG.open('a') as f:
        fcntl.flock(f.fileno(),fcntl.LOCK_EX)
        f.write(json.dumps(rec,sort_keys=True)+'\n')
        f.flush()
SAGE='/home/footfalcon/.local/bin/sage'
SAGE_VERSION='10.9'
SCRIPTS=[('model','model/prng_model.sage'),('checker','model/prng_checker.sage')]
def boxed(name,rel,env):
    """Run `sage <rel>` through a small argv box so the subprocess ps line
    is the REAL pinned launcher invocation, not the mamba runner frame.

    Returns (stdout, stderr, combined, exit_code, started, killed): on a
    deadline the whole process group is killed and `killed` is True.
    """
    box=['/usr/bin/env','-S','--',SAGE,rel]
    import time
    started=time.strftime('%Y-%m-%dT%H:%M:%S%z')
    deadline=2300.0
    p=subprocess.Popen(box,cwd=str(W),env=env,stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,start_new_session=True)
    try:
        so,se=p.communicate(timeout=deadline)
        killed=False
    except subprocess.TimeoutExpired:
        import signal
        os.killpg(p.pid,signal.SIGKILL)
        so,se=p.communicate()
        killed=True
    out=(so or b'')+(se or b'')
    code=p.returncode if p.returncode is not None else 'KILLED'
    return so or b'',se or b'',out,code,started,killed
def version_boxed(env):
    p=subprocess.run([SAGE,'--version'],cwd=str(W),env=env,
        capture_output=True,timeout=600,text=False)
    return (p.stdout or b'')+(p.stderr or b''),p.returncode
def write_sage_logs(name,so,se,out):
    from common import write_logs
    lo,se_p=write_logs('sage_'+name,so if so else out,se if se else b'')
    return lo,se_p
def main():
 for d in (W/'cache/home',W/'cache/tmp',W/'cache/sage'):d.mkdir(parents=True,exist_ok=True)
 env=dict(os.environ)
 env.update(HOME=str(W/'cache/home'),TMPDIR=str(W/'cache/tmp'),TMP=str(W/'cache/tmp'),TEMP=str(W/'cache/tmp'),DOT_SAGE=str(W/'cache/sage'),XDG_CACHE_HOME=str(W/'cache'),PYTHONDONTWRITEBYTECODE='1')
 recs=[]
 for name,rel in SCRIPTS:
  so,se,out,code,started,killed=boxed(name,rel,env)
  log_so,log_se=write_sage_logs(name,so,se,out)
  append_record(dict(name='sage_'+name,argv=[SAGE,rel],cwd=str(W),
      exit_code=code,timeout=killed,started=started,
      stdout_bytes=len(so),stderr_bytes=len(se),
      stdout_sha256=sha(log_so),stderr_sha256=sha(log_se)))
  assert code==0 and not killed,('sage failed',name,code,killed,(so+se+out)[-2000:])
  recs.append(dict(name=name,script=rel,script_sha256=sha(W/rel),exit_code=code,timeout=killed,
      stdout_sha256=sha(log_so),stderr_sha256=sha(log_se)))
 vout,vcode=version_boxed(env)
 log_so,log_se=write_sage_logs('version',b'',b'',vout)
 assert vcode==0,('sage --version failed',(vout)[-1000:])
 (W/'receipts/sage_run.json').write_text(json.dumps(dict(schema='PRNG_T021_SAGE_RUN_V1',launcher=SAGE,entry='sage <file>.sage (standard preparser)',version_output=(W/'logs/sage_version.stdout').read_text().strip(),scripts=recs),indent=2)+'\n')
 print(json.dumps(recs,indent=2))
if __name__=='__main__':main()
