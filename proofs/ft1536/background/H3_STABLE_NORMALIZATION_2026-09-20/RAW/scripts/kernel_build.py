import json,re,subprocess,sys
from pathlib import Path
W=Path.cwd();order=[]
def visit(m):
 if m in order:return
 p=W/'formal'/(m+'.lean')
 for d in re.findall(r'^import (\w+)',p.read_text(),re.M):
  if (W/'formal'/(d+'.lean')).is_file():visit(d)
 order.append(m)
for p in sorted((W/'formal').glob('*.lean')):
 if p.stem not in ['TowerAudit','TowerTypes','RawAudit','RawTypes']:visit(p.stem)
(W/'artifacts/kernel_order.json').write_text(json.dumps(order,indent=2)+'\n')
p=subprocess.run([sys.executable,'-B','scripts/lean.py']+order,timeout=230);raise SystemExit(p.returncode)
