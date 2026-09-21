import json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';rows=json.loads((W/'artifacts/reuse.json').read_text());order=[]
def visit(m,stage):
 src=I/stage/'formal'/(m+'.lean');assert src.is_file()
 if m in order:assert sha(W/'formal'/(m+'.lean'))==sha(src);return
 for s in src.read_text().splitlines():
  if s.startswith('import '):
   for d in s.split()[1:]:
    if (I/stage/'formal'/(d+'.lean')).exists():visit(d,stage)
 dst=W/'formal'/(m+'.lean');shutil.copyfile(src,dst);rows.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True));order.append(m)
visit('ReachOutcomes','ORDERED')
(W/'artifacts/reuse.json').write_text(json.dumps(rows,indent=2)+'\n');(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');print('INHERITED_MODULES',len(order))
