import json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';rows=json.loads((W/'artifacts/reuse.json').read_text());order=[]
def copy(p,r):
 dst=W/r;dst.parent.mkdir(parents=True,exist_ok=True)
 if dst.exists():assert sha(dst)==sha(p)
 else:shutil.copyfile(p,dst)
 if not any(x['copy']==r for x in rows):rows.append(dict(input=p.relative_to(W).as_posix(),copy=r,sha256=sha(p),byte_identical=True))
for src,names in [('ORDERED',['ordered_model','root_model']),('POST',['post_model','codec_model'])]:
 for n in names:copy(I/src/'scripts'/(n+'.py'),'scripts/'+n+'.py')
for src,n,dst in [('ORDERED','ordered','ordered_template'),('IID','kernel','kernel'),('POST','post','post')]:copy(I/src/'checks'/(n+'.c'),'checks/'+dst+'.c')
for src,dst in [('IID','scalar_binding'),('POST','post_binding')]:copy(I/src/'scripts/source_binding.py','scripts/'+dst+'.py')
def visit(name):
 if name in order:return
 r=name.replace('.','/')+'.lean';choices=[I/d/'formal'/r for d in ['POST','GAUSS','IID','ORDERED'] if (I/d/'formal'/r).is_file()];assert choices,name
 p=choices[0]
 for s in p.read_text().splitlines():
  if s.startswith('import '):
   for n in s.split()[1:]:
    if any((I/d/'formal'/(n.replace('.','/')+'.lean')).is_file() for d in ['POST','GAUSS','IID','ORDERED']):visit(n)
 copy(p,'formal/'+r);order.append(name)
for name in ['IidRejection','LeftClosure','SourceBytes','RintRefinement','GaussianMetrics']:visit(name)
(W/'artifacts/reuse.json').write_text(json.dumps(rows,indent=2)+'\n');(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n');print('REUSED',len(rows),'FORMAL',len(order))
