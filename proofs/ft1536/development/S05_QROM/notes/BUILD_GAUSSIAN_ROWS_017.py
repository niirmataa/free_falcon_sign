#!/usr/bin/env python3
"""Four bounded one-core compilers, individual row witnesses. No models or Git."""
from pathlib import Path
import concurrent.futures,hashlib,json,os,subprocess,sys,threading,time
S=Path(__file__).resolve().parent.parent;B=S/'.build/local_leaves_017'
run=B/sys.argv[1];run.mkdir(exist_ok=False)
items=json.loads((B/'witness_sources003/SELECTED.json').read_text())['row_modules']
lock=threading.Lock();stop=threading.Event()
def lane(lane):
 for j in range(1+lane,len(items),4):
  if stop.is_set():return
  while int(next(x.split()[1] for x in Path('/proc/meminfo').read_text().splitlines() if x.startswith('MemAvailable:')))<3*1024**2:
   if stop.wait(1):return
  r=items[j];name=r['module'];label=r['label']
  src=B/'generated'/(name+'.lean');assert hashlib.sha256(src.read_bytes()).hexdigest()==r['sha256']
  env=os.environ.copy();env['S05_WITNESS_CPU']=str([0,2,4,6][lane])
  with (run/(label+'.log')).open('w') as f:
   result=subprocess.run([sys.executable,'-B',str(S/'notes/BUILD_LOCAL_LEAVES_017.py'),'generated',name,label],
     env=env,stdout=f,stderr=subprocess.STDOUT)
  p=B/'runs'/label/'receipt.json'
  receipt=json.loads(p.read_text()) if p.exists() else {'module':name,'exit_code':result.returncode,'warning_count':None,'error_count':None,'elapsed_seconds':None,'compiler_peak_rss_KiB':None}
  record={k:receipt.get(k) for k in ['module','exit_code','warning_count','error_count','elapsed_seconds','compiler_peak_rss_KiB']}
  with lock:
   with (run/'progress.jsonl').open('a') as f:f.write(json.dumps(record)+'\n')
   print(json.dumps(record),flush=True)
  if result.returncode or record['warning_count'] or record['error_count']:
   stop.set();return
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:list(pool.map(lane,range(4)))
if stop.is_set():sys.exit(1)
(run/'COMPLETE.json').write_text(json.dumps({'status':'ALL_INDIVIDUAL_ROW_MODULES_CLEAN','first_batch':'rows000001','remaining_batches':len(items)-1,'cores':[0,2,4,6]})+'\n')
