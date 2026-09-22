import json,subprocess,sys
from pathlib import Path
W=Path.cwd();mods=[]
def visit(m):
 if m in mods:return
 p=W/'formal'/(m.replace('.','/')+'.lean')
 for s in p.read_text().splitlines():
  if s.startswith('import '):
   for d in s.split()[1:]:
    if (W/'formal'/(d.replace('.','/')+'.lean')).is_file():visit(d)
 mods.append(m)
for p in sorted((W/'formal').rglob('*.lean')):
 m=p.relative_to(W/'formal').as_posix()[:-5].replace('/','.')
 if m not in ['RetryAudit','RetryTypes']:visit(m)
(W/'artifacts/kernel_order.json').write_text(json.dumps(mods,indent=2)+'\n');k=int(sys.argv[1]);batch=mods[k*20:(k+1)*20];assert batch
p=subprocess.run([sys.executable,'-B','scripts/lean.py']+[m.replace('.','/') for m in batch],capture_output=True,timeout=230)
for stream,data in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/('kernel_batch_'+str(k)+'.'+stream)).write_bytes(data)
print('KERNEL_BATCH',k,'modules',len(batch),'exit',p.returncode,'full logs under logs/kernel_batch_'+str(k))
raise SystemExit(p.returncode)
