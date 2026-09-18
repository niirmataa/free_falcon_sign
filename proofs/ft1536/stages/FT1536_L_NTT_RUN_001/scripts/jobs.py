import datetime,hashlib,json,os,signal,subprocess,time
from pathlib import Path
W=Path.cwd()
def run(argv,label,expected=(0,),limit=60,extra=None):
    env=dict(os.environ);env.update(extra or {})
    start=datetime.datetime.now(datetime.timezone.utc).isoformat();tick=time.monotonic()
    p=subprocess.Popen(argv,cwd=W,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
    timed=False
    try:out,err=p.communicate(timeout=limit)
    except subprocess.TimeoutExpired:
        timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    paths={}
    for key,data in [('stdout',out),('stderr',err)]:
        rel='logs/job_'+label+'.'+key
        with (W/rel).open('xb') as f:f.write(data)
        paths[key]=rel
    row=dict(start_utc=start,cwd=str(W),argv=argv,exit_code=p.returncode,timeout=timed,wall_limit_seconds=limit,
      elapsed_seconds=time.monotonic()-tick,**paths,stream_sha256={'stdout':hashlib.sha256(out).hexdigest(),'stderr':hashlib.sha256(err).hexdigest()},
      expected_exit_codes=list(expected),extra_environment=extra or {})
    with (W/'COMMANDS.log').open('a') as f:f.write(json.dumps(row,sort_keys=True)+'\n')
    print(json.dumps(dict(job=label,exit_code=p.returncode,timeout=timed)),flush=True)
    if timed or p.returncode not in expected:
        print(out.decode(errors='replace'));print(err.decode(errors='replace'));raise RuntimeError(label)
    return row
