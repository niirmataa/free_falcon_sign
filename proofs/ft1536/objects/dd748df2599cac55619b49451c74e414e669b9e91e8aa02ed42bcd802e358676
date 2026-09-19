import hashlib,json,os,signal,subprocess,sys,time
from pathlib import Path
W=Path.cwd();LE='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
for mod in sys.argv[1:]:
    src=W/'formal'/(mod+'.lean');tag=mod.replace('/','_')+'_'+str(time.time_ns());cmd=[LE,'-j1','-M2048','--root=formal','-o','formal/'+mod+'.olean','formal/'+mod+'.lean']
    t=time.monotonic();p=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
    try:so,se=p.communicate(timeout=180)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);so,se=p.communicate()
    paths={}
    for stream,data in [('stdout',so),('stderr',se)]:
        rel='logs/'+tag+'.'+stream;(W/rel).write_bytes(data);paths[stream]=rel;paths[stream+'_sha256']=hashlib.sha256(data).hexdigest()
    r=dict(module=mod,source_sha256=hashlib.sha256(src.read_bytes()).hexdigest(),argv=cmd,cwd=str(W),exit_code=p.returncode,timeout=timed,
      wall_limit=180,address_space_bytes=8*1024**3,heap_MiB=2048,elapsed=time.monotonic()-t,**paths)
    with (W/'artifacts/kernel.jsonl').open('a') as f:f.write(json.dumps(r,sort_keys=True)+'\n')
    sys.stdout.buffer.write(so);sys.stderr.buffer.write(se);sys.stdout.flush();print(mod,p.returncode,round(r['elapsed'],3),flush=True)
    if timed or p.returncode:sys.exit(124 if timed else p.returncode)
