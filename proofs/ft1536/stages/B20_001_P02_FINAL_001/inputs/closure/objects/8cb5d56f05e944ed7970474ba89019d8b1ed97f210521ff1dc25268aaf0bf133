"""Bounded diagnostic prefix compilation, outside final modules."""
import hashlib,json,os,re,signal,subprocess,sys,time
from pathlib import Path
src=Path(sys.argv[1]);text=src.read_text();tag=hashlib.sha256(text.encode()).hexdigest()[:12]
ns=re.search(r'^namespace (\w+)',text,re.M).group(1);out=Path('formal/attempts');out.mkdir(exist_ok=True);rows=[]
for marker in sys.argv[2:]:
    path=out/f'{src.stem}_{tag}_before_{marker}.lean';data=text.split('theorem '+marker,1)[0]+'\nend '+ns+'\n'
    with path.open('x') as f:f.write(data)
    argv=['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','-j1','-M2048','--root=formal',str(path)]
    tick=time.monotonic();p=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
    try:so,se=p.communicate(timeout=12)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);so,se=p.communicate()
    Path(str(path)+'.stdout').write_bytes(so);Path(str(path)+'.stderr').write_bytes(se)
    row=dict(source=str(src),prefix_before=marker,argv=argv,timeout=timed,exit_code=p.returncode,elapsed=time.monotonic()-tick)
    rows.append(row);print(json.dumps(row),flush=True)
    if timed or p.returncode:break
Path('artifacts/probe_'+src.stem+'_'+tag+'.json').write_text(json.dumps(rows,indent=2)+'\n')
