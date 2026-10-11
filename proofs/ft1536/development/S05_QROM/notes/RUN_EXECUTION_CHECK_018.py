#!/usr/bin/env python3
"""Run the standard Sage preparser in a fresh durable directory; no math here."""
from pathlib import Path
import hashlib,json,os,resource,shutil,signal,subprocess,sys,time
S=Path(__file__).resolve().parent.parent
D=S/'.build/execution_018'/sys.argv[1]
D.mkdir(exist_ok=False)
source=S/'notes/CHECK_EXECUTION_018.sage';snap=D/source.name
shutil.copyfile(source,snap)
exe=Path('/home/footfalcon/miniforge3/envs/sage/bin/sage')
assert exe.is_file()
env=os.environ.copy();env['PATH']=str(exe.parent)+os.pathsep+env['PATH']
for key,sub in [('TMPDIR','tmp'),('XDG_CACHE_HOME','cache'),('DOT_SAGE','sage')]:
 p=D/sub;p.mkdir();env[key]=str(p)
def limits():
 resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
 resource.setrlimit(resource.RLIMIT_CPU,(55,58))
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
cmd=[str(exe),str(snap)];start=time.monotonic();status='completed'
with (D/'stdout.txt').open('w') as out,(D/'stderr.txt').open('w') as err:
 p=subprocess.Popen(cmd,cwd=D,env=env,stdout=out,stderr=err,preexec_fn=limits,start_new_session=True)
 try:code=p.wait(timeout=60)
 except subprocess.TimeoutExpired:
  os.killpg(p.pid,signal.SIGKILL);code=p.wait();status='timeout'
rec={'command':cmd,'status':status,'exit_code':code,'elapsed_seconds':time.monotonic()-start,'source_sha256':sha(snap),'wrapper_sha256':sha(Path(__file__)),'executable_sha256':sha(exe),'stdout_sha256':sha(D/'stdout.txt'),'stderr_sha256':sha(D/'stderr.txt'),'result_sha256':sha(D/'result.json') if (D/'result.json').exists() else None,'cost_label':'Sage process only, not sampler runtime','preparser':'standard sage file.sage'}
(D/'receipt.json').write_text(json.dumps(rec,indent=2)+'\n')
print(json.dumps(rec));sys.exit(0 if code==0 else 1)
