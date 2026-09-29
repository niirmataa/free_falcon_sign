import json,re,subprocess,sys
from pathlib import Path
W=Path.cwd();order=[]
def visit(m):
 if m in order:return
 p=W/'formal'/(m.replace('.','/')+'.lean')
 for line in p.read_text().splitlines():
  if line.startswith('import '):
   for d in line.split()[1:]:
    if (W/'formal'/(d.replace('.','/')+'.lean')).exists():visit(d)
 order.append(m)
for p in sorted((W/'formal').rglob('*.lean')):
 m=p.relative_to(W/'formal').as_posix()[:-5].replace('/','.')
 if m not in ['PostAudit','PostTypes']:visit(m)
(W/'artifacts/kernel_order.json').write_text(json.dumps(order,indent=2)+'\n')
index=int(sys.argv[1]) if len(sys.argv)>1 else 0;batch=order[index*24:(index+1)*24];assert batch
p=subprocess.run([sys.executable,'-B','scripts/lean.py']+[m.replace('.','/') for m in batch],timeout=230);raise SystemExit(p.returncode)
