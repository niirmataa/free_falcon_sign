import json,subprocess,sys
from pathlib import Path
W=Path.cwd();mods=[]
def visit(m):
 if m in mods:return
 for s in (W/'formal'/(m.replace('.','/')+'.lean')).read_text().splitlines():
  if s.startswith('import '):
   for d in s.split()[1:]:
    if (W/'formal'/(d.replace('.','/')+'.lean')).exists():visit(d)
 mods.append(m)
visit('JointPost');(W/'artifacts/kernel_order.json').write_text(json.dumps(mods,indent=2)+'\n');k=int(sys.argv[1]);batch=mods[k*20:(k+1)*20];assert batch
raise SystemExit(subprocess.run([sys.executable,'-B','scripts/lean.py']+[m.replace('.','/') for m in batch],timeout=230).returncode)
