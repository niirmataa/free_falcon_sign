"""One or more explicitly named modules, with full bounded receipts."""
import hashlib,json,os,signal,subprocess,sys,time
from pathlib import Path
W=Path.cwd();lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
mods=json.loads((W/'artifacts/inherited_modules.json').read_text()) if sys.argv[1:]==['--inherited'] else sys.argv[1:]
assert mods
for mod in mods:
    path=W/'formal'/(mod+'.lean');assert path.is_file()
    tag=mod.replace('/','_')+'_'+str(time.time_ns());base=W/'logs'/tag
    argv=[lean,'-j1','-M2048','--root=formal','-o',f'formal/{mod}.olean',f'formal/{mod}.lean']
    start=time.monotonic();p=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
    timed=False
    try:out,err=p.communicate(timeout=180)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    so=str(base)+'.stdout';se=str(base)+'.stderr';Path(so).write_bytes(out);Path(se).write_bytes(err)
    rec=dict(module=mod,source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),argv=argv,cwd=str(W),exit_code=p.returncode,timeout=timed,
        seconds=time.monotonic()-start,wall_limit_seconds=180,address_space_bytes=8*1024**3,heap_MiB=2048,
        stdout=str(Path(so).relative_to(W)),stderr=str(Path(se).relative_to(W)),stdout_sha256=hashlib.sha256(out).hexdigest(),stderr_sha256=hashlib.sha256(err).hexdigest())
    with (W/'artifacts/kernel_checks.jsonl').open('a') as f:f.write(json.dumps(rec,sort_keys=True)+'\n')
    sys.stdout.buffer.write(out);sys.stderr.buffer.write(err);sys.stdout.flush();sys.stderr.flush()
    print(mod,p.returncode,round(rec['seconds'],3),flush=True)
    if timed or p.returncode:sys.exit(124 if timed else p.returncode)
