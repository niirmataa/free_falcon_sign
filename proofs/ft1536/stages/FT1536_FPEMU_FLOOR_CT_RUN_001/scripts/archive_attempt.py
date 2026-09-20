import json,shutil,sys,time
from pathlib import Path
from replaylib import member,sha
W=Path.cwd();out=W/'artifacts/attempts'/str(time.time_ns());out.mkdir(parents=True);rows=[]
for rel in sys.argv[1:]:
 base=W/rel
 candidates=[base] if base.is_file() else sorted(p for p in base.rglob('*') if p.is_file())
 assert candidates
 for p in candidates:
  r=p.relative_to(W).as_posix();p=member(W,r);t=out/r;t.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,t)
  rows.append(dict(original=r,copy=t.relative_to(W).as_posix(),sha256=sha(t)))
(out/'INDEX.json').write_text(json.dumps(rows,indent=2)+'\n');print(json.dumps(rows,indent=2))
