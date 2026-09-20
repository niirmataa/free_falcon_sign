"""Bounded H3_NODE3 jobs, only W writable; bootstrap/source read-only."""
import datetime,fcntl,hashlib,json,os,resource,signal,subprocess,sys,time
from pathlib import Path
W=Path(__file__).absolute().parents[1];limit=int(sys.argv[1]);argv=sys.argv[2:]
assert argv and 1<=limit<=240
asan=os.environ.get('FT1536_ASAN')=='1'
for rel in ['logs','artifacts','tmp','cache/home','cache/sage','cache/mpl','cache/ipython']:(W/rel).mkdir(parents=True,exist_ok=True)
env=dict(os.environ);env.update(HOME=str(W/'cache/home'),TMPDIR=str(W/'tmp'),TMP=str(W/'tmp'),TEMP=str(W/'tmp'),
 XDG_CACHE_HOME=str(W/'cache'),DOT_SAGE=str(W/'cache/sage'),MPLCONFIGDIR=str(W/'cache/mpl'),IPYTHONDIR=str(W/'cache/ipython'),
 PYTHONDONTWRITEBYTECODE='1',PYTHONOPTIMIZE='0',MAMBA_ROOT_PREFIX='/home/footfalcon/miniforge3',GIT_OPTIONAL_LOCKS='0',
 OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',LEAN_PATH=str(W/'formal'),ASAN_OPTIONS='detect_leaks=0:abort_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
box=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--unshare-pid','--ro-bind','/','/','--bind',str(W),str(W),'--proc','/proc','--dev','/dev','--chdir',str(W)]
for rel in ['inputs/bootstrap','source']:
 if (W/rel).exists():box+=['--ro-bind',str(W/rel),str(W/rel)]
box+=['--']
def bounds():
 resource.setrlimit(resource.RLIMIT_CPU,(limit,limit+1));resource.setrlimit(resource.RLIMIT_CORE,(0,0));resource.setrlimit(resource.RLIMIT_NOFILE,(256,256))
 if not asan:resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
start=datetime.datetime.now(datetime.timezone.utc).isoformat();tag=start.replace(':','').replace('.','')
with (W/'executor.lock').open('a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB);t=time.monotonic();p=subprocess.Popen(box+argv,cwd=W,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True,preexec_fn=bounds);timed=False
 try:o,e=p.communicate(timeout=limit)
 except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
 paths={}
 for k,data in [('stdout',o),('stderr',e)]:
  rel='logs/'+tag+'.'+k
  with (W/rel).open('xb') as f:f.write(data)
  paths[k]=rel
 row=dict(start_utc=start,cwd=str(W),argv=argv,sandbox=box,exit_code=p.returncode,timeout=timed,wall_limit_seconds=limit,cpu_limit_seconds=limit,
  address_space_bytes=None if asan else 8*1024**3,asan_shadow_reservation=asan,elapsed_seconds=time.monotonic()-t,**paths,
  stream_sha256={'stdout':hashlib.sha256(o).hexdigest(),'stderr':hashlib.sha256(e).hexdigest()},
  environment={k:env[k] for k in ['HOME','TMPDIR','DOT_SAGE','XDG_CACHE_HOME','LEAN_PATH','GIT_OPTIONAL_LOCKS','PYTHONOPTIMIZE']})
 with (W/'COMMANDS.log').open('a') as f:f.write(json.dumps(row,sort_keys=True)+'\n')
sys.stdout.buffer.write(o);sys.stderr.buffer.write(e);sys.exit(124 if timed else p.returncode)
