"""Bounded elaboration diagnostics; prefix copies are never final modules."""
import hashlib,json,signal,subprocess,time,os
from pathlib import Path
text=Path('formal/ForwardGlobal.lean').read_text();out=Path('formal/attempts');out.mkdir(exist_ok=True)
lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
rows=[]
for marker in ['middle_eval','cubic_eval','forwardMem_eval','forwardC_eval','FORWARD_GLOBAL','fromVec_canonical_mod','liftForward_eval','node_zero']:
    p=out/f'ForwardGlobal_before_{marker}.lean';data=text.split('theorem '+marker,1)[0]+'\nend FT1536Forward\n'
    with p.open('x') as f:f.write(data)
    argv=[lean,'-j1','-M2048','--root=formal',str(p)]
    t=time.monotonic();proc=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
    timed=False
    try:so,se=proc.communicate(timeout=15)
    except subprocess.TimeoutExpired:timed=True;os.killpg(proc.pid,signal.SIGKILL);so,se=proc.communicate()
    Path(str(p)+'.stdout').write_bytes(so);Path(str(p)+'.stderr').write_bytes(se)
    rows.append(dict(prefix_before=marker,argv=argv,source_sha256=hashlib.sha256(data.encode()).hexdigest(),timeout=timed,exit_code=proc.returncode,elapsed=time.monotonic()-t))
    print(json.dumps(rows[-1]),flush=True)
    if timed or proc.returncode:break
Path('artifacts/forward_probe.json').write_text(json.dumps(rows,indent=2)+'\n')
