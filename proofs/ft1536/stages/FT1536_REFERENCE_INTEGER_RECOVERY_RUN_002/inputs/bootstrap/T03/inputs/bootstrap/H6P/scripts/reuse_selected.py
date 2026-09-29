import json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';rows=json.loads((W/'artifacts/reuse.json').read_text());order=[]
def cp(src,dest):
 p=W/dest;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,p);rows.append(dict(input=src.relative_to(W).as_posix(),copy=dest,sha256=sha(p),byte_identical=True))
def visit(m):
 if m in order:return
 p=I/'JOINT/formal'/(m+'.lean');assert p.is_file()
 for s in p.read_text().splitlines():
  if s.startswith('import '):
   for d in s.split()[1:]:
    if (I/'JOINT/formal'/(d+'.lean')).is_file():visit(d)
 cp(p,'formal/'+m+'.lean');order.append(m)
visit('JointMetrics');visit('RintRefinement')
for name in ['kernel_model','codec_model','post_binding']:cp(I/'JOINT/scripts'/(name+'.py'),'scripts/'+name+'.py')
cp(I/'JOINT/checks/ordered_template.c','checks/map.c');cp(I/'JOINT/checks/post.c','checks/post.c')
(W/'artifacts/reuse.json').write_text(json.dumps(rows,indent=2)+'\n');(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');print('SELECTED_INHERITED_MODULES',len(order))
