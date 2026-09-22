import json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';rows=json.loads((W/'artifacts/reuse.json').read_text());order=[]
def visit(m,stage):
 p=I/stage/'formal'/(m.replace('.','/')+'.lean');assert p.is_file(),p
 dst=W/'formal'/(m.replace('.','/')+'.lean')
 if m in order:assert sha(dst)==sha(p);return
 for s in p.read_text().splitlines():
  if s.startswith('import '):
   for d in s.split()[1:]:
    if (I/stage/'formal'/(d.replace('.','/')+'.lean')).is_file():visit(d,stage)
 dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst);rows.append(dict(input=p.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True));order.append(m)
visit('H6PEvent','H6P');visit('SourceBytes','POST')
(W/'artifacts/reuse.json').write_text(json.dumps(rows,indent=2)+'\n');(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');print('INHERITED_MODULES',len(order))
