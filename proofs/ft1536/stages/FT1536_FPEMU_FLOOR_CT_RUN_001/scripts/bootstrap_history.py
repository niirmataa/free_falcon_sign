import hashlib,json,shutil
from pathlib import Path
W=Path.cwd();out=W/'artifacts/attempts/bootstrap_probe_v1';out.mkdir(parents=True,exist_ok=False)
files=[W/'scripts/prepare.py',W/'COMMANDS.log']+sorted((W/'logs').glob('*'))
rows=[]
for p in files:
 if not p.is_file():continue
 r=p.relative_to(W);t=out/r;t.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,t)
 rows.append(dict(path=str(t.relative_to(W)),sha256=hashlib.sha256(t.read_bytes()).hexdigest()))
(out/'INDEX.json').write_text(json.dumps(rows,indent=2)+'\n');print(json.dumps(dict(archived_files=len(rows))))
