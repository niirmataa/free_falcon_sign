import json,shutil,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();tag=sys.argv[1];assert tag and '/' not in tag and tag not in ['.','..'];D=W/'artifacts/attempts'/tag;D.mkdir(parents=True,exist_ok=False);rows=[]
for rel in sys.argv[2:]:
 p=W/rel;assert '..' not in Path(rel).parts
 for src in ([p] if p.is_file() else sorted(q for q in p.rglob('*') if q.is_file())):
  name=src.relative_to(W).as_posix();dst=D/name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst);rows.append(dict(path=name,sha256=sha(dst)))
last=json.loads((W/'COMMANDS.log').read_text().splitlines()[-1]);(D/'command.json').write_text(json.dumps(last,indent=2)+'\n')
for s in ['stdout','stderr']:shutil.copyfile(W/last[s],D/s)
(D/'FILES.json').write_text(json.dumps(rows,indent=2)+'\n');print(json.dumps(dict(archived=tag,files=len(rows))))
