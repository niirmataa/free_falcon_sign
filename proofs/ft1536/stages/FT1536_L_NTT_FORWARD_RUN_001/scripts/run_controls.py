"""Small bounded execution controls, retaining unfiltered child streams."""
import hashlib,json,os,signal,subprocess,time
from pathlib import Path
W=Path.cwd();logs=W/'checks/logs';logs.mkdir(exist_ok=True);rows=[]
lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
def run(tag,argv,limit,outrel=None):
    start=time.monotonic();p=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
    try:out,err=p.communicate(timeout=limit)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    so=W/outrel if outrel else logs/(tag+'.stdout');se=logs/(tag+'.stderr')
    so.write_bytes(out);se.write_bytes(err)
    rows.append(dict(tag=tag,argv=argv,cwd=str(W),exit_code=p.returncode,timeout=timed,limit=limit,elapsed=time.monotonic()-start,
      stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(out).hexdigest(),stderr_sha256=hashlib.sha256(err).hexdigest()))
    (W/'artifacts/control_receipts.json').write_text(json.dumps(rows,indent=2)+'\n')
    print(tag,p.returncode,round(rows[-1]['elapsed'],3),flush=True)
    assert not timed and p.returncode==0,(argv,out.decode(),err.decode())
    return out,err
out,err=run('lean',[lean,'-j1','-M2048','--run','formal/ControlMain.lean','checks/lean_values.txt'],60)
assert b'warning:' not in out+err and b'error:' not in out+err
run('gcc',['/usr/bin/gcc','-std=c99','-O2','-ffunction-sections','-fdata-sections','-Isource','checks/pipeline.c','-Wl,--gc-sections','-o','bin/pipeline_check'],30)
for i in range(2):run(f'c{i}',['bin/pipeline_check',f'checks/case{i}.txt'],30,f'checks/c{i}.txt')
run('sage',['/home/footfalcon/.local/bin/sage','scripts/sage_controls.py'],90)
print((W/'artifacts/controls.json').read_text())
