#!/usr/bin/env python3
"""Run the standard Sage preparser in a fresh durable directory; no math here."""
from pathlib import Path
import hashlib,json,os,resource,shutil,signal,subprocess,sys,time
S=Path(__file__).resolve().parent.parent
D=S/'.build/pair_machine_020'/sys.argv[1]
D.mkdir(exist_ok=False)
source=S/'notes/CHECK_PAIR_MACHINE_020.sage';snap=D/source.name
shutil.copyfile(source,snap)
program=S/'.build/pair_machine_020/PROGRAM_020.json'
shutil.copyfile(program,D/'program.json')
exe=Path('/home/footfalcon/miniforge3/envs/sage/bin/sage')
assert exe.is_file()
env=os.environ.copy();env['PATH']=str(exe.parent)+os.pathsep+env['PATH']
for key,sub in [('TMPDIR','tmp'),('XDG_CACHE_HOME','cache'),('DOT_SAGE','sage')]:
 p=D/sub;p.mkdir();env[key]=str(p)
if len(sys.argv)>2 and sys.argv[2]=='diagnostic':
 diag=D/'diagnostic';diag.mkdir()
 (diag/'sitecustomize.py').write_text('import faulthandler\nfaulthandler.dump_traceback_later(30,repeat=True)\n')
 env['PYTHONPATH']=str(diag)+os.pathsep+env.get('PYTHONPATH','')
def limits():
 resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
 resource.setrlimit(resource.RLIMIT_CPU,(300,305))
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
cmd=[str(exe),str(snap)];start=time.monotonic();status='completed'
with (D/'stdout.txt').open('w') as out,(D/'stderr.txt').open('w') as err:
 p=subprocess.Popen(cmd,cwd=D,env=env,stdout=out,stderr=err,preexec_fn=limits,start_new_session=True)
 try:code=p.wait(timeout=360)
 except subprocess.TimeoutExpired:
  os.killpg(p.pid,signal.SIGKILL);code=p.wait();status='timeout'
rec={'command':cmd,'status':status,'exit_code':code,'elapsed_seconds':time.monotonic()-start,'source_sha256':sha(snap),'wrapper_sha256':sha(Path(__file__)),'executable_sha256':sha(exe),'stdout_sha256':sha(D/'stdout.txt'),'stderr_sha256':sha(D/'stderr.txt'),'program_sha256':sha(D/'program.json'),'result_sha256':sha(D/'result.json') if (D/'result.json').exists() else None,'cpu_seconds':300,'wall_seconds':360,'cost_label':'Sage process only, not sampler runtime','preparser':'standard sage file.sage'}
(D/'receipt.json').write_text(json.dumps(rec,indent=2)+'\n')
print(json.dumps(rec));sys.exit(0 if code==0 else 1)
