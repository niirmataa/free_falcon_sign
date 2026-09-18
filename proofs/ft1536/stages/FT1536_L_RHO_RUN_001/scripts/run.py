#!/usr/bin/env python3
"""Bounded, logged child commands; filesystem writable only in this W."""
import datetime, fcntl, hashlib, json, os, resource, signal, subprocess, sys, time
from pathlib import Path
W=Path(__file__).absolute().parents[1]
limit=int(sys.argv[1]); argv=sys.argv[2:]
assert argv and 1<=limit<=240
for rel in ["logs","artifacts","tmp","cache/home","cache/sage","cache/mpl","cache/ipython"]:
    (W/rel).mkdir(parents=True,exist_ok=True)
env=dict(os.environ)
env.update(HOME=str(W/"cache/home"),TMPDIR=str(W/"tmp"),TMP=str(W/"tmp"),TEMP=str(W/"tmp"),
 XDG_CACHE_HOME=str(W/"cache"),DOT_SAGE=str(W/"cache/sage"),MPLCONFIGDIR=str(W/"cache/mpl"),
 IPYTHONDIR=str(W/"cache/ipython"),PYTHONDONTWRITEBYTECODE="1",PYTHONPYCACHEPREFIX=str(W/"cache/pycache"),
 MAMBA_ROOT_PREFIX="/home/footfalcon/miniforge3",GIT_OPTIONAL_LOCKS="0",OMP_NUM_THREADS="1",OPENBLAS_NUM_THREADS="1")
box=["/usr/bin/bwrap","--die-with-parent","--unshare-net","--ro-bind","/","/","--bind",str(W),str(W),
     "--proc","/proc","--dev","/dev","--chdir",str(W)]
if (W/"reference").exists():box += ["--ro-bind",str(W/"reference"),str(W/"reference")]
box += ["--"]
def bounds():
    resource.setrlimit(resource.RLIMIT_CPU,(limit,limit+1))
    resource.setrlimit(resource.RLIMIT_CORE,(0,0))
    # ASan needs a large virtual address reservation; physical use is modest.
    resource.setrlimit(resource.RLIMIT_NOFILE,(256,256))
start=datetime.datetime.now(datetime.timezone.utc).isoformat(); tag=start.replace(":","").replace(".","")
with (W/"executor.lock").open("a") as lock:
    fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    tick=time.monotonic()
    p=subprocess.Popen(box+argv,cwd=W,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                       start_new_session=True,preexec_fn=bounds)
    timed=False
    try:out,err=p.communicate(timeout=limit)
    except subprocess.TimeoutExpired:
        timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    streams={}
    for name,value in [("stdout",out),("stderr",err)]:
        rel="logs/"+tag+"."+name
        with (W/rel).open("xb") as f:f.write(value)
        streams[name]=rel
    row=dict(start_utc=start,cwd=str(W),argv=argv,sandbox=box,exit_code=p.returncode,
             timeout=timed,wall_limit_seconds=limit,cpu_limit_seconds=limit,
             elapsed_seconds=time.monotonic()-tick,**streams,
             stream_sha256={"stdout":hashlib.sha256(out).hexdigest(),"stderr":hashlib.sha256(err).hexdigest()},
             environment={k:env[k] for k in ["HOME","TMPDIR","DOT_SAGE","XDG_CACHE_HOME","MAMBA_ROOT_PREFIX","GIT_OPTIONAL_LOCKS"]})
    with (W/"COMMANDS.log").open("a") as f:f.write(json.dumps(row,sort_keys=True)+"\n")
sys.stdout.buffer.write(out);sys.stderr.buffer.write(err)
sys.exit(124 if timed else p.returncode)
