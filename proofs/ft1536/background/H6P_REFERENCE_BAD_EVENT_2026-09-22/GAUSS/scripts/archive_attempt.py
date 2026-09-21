import json,shutil,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'artifacts/attempts'/sys.argv[1];D.mkdir(parents=True,exist_ok=False);rows=[]
for r in sys.argv[2:]:
 p=W/r;dst=D/r;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst);rows.append(dict(path=r,sha256=sha(dst)))
last=json.loads((W/'COMMANDS.log').read_text().splitlines()[-1]);(D/'command.json').write_text(json.dumps(last,indent=2)+'\n')
for s in ['stdout','stderr']:shutil.copyfile(W/last[s],D/s)
(D/'FILES.json').write_text(json.dumps(rows,indent=2)+'\n');print('ARCHIVED',D.name,len(rows))
