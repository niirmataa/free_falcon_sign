#!/usr/bin/env python3
"""Bounded two-process compiler campaign. No model or foreign worker is started."""
from pathlib import Path
import concurrent.futures, hashlib, json, os, subprocess, sys, threading
S=Path(__file__).resolve().parent.parent
B=S/'.build/local_leaves_017'
run=B/sys.argv[1];run.mkdir(exist_ok=False)
manifest=json.loads((B/'witness_sources001/MANIFEST.json').read_text())
cores=sorted(os.sched_getaffinity(0))[-2:]
assert len(cores)==2
lock=threading.Lock();stop=threading.Event()
def lane(lane):
 for j in range(1+lane,len(manifest['modules']),2):
  if stop.is_set():return
  r=manifest['modules'][j];name=r['module'];label=f'witness{j:03}001'
  src=B/'generated'/(name+'.lean')
  assert hashlib.sha256(src.read_bytes()).hexdigest()==r['sha256']
  cmd=[sys.executable,'-B',str(S/'notes/BUILD_LOCAL_LEAVES_017.py'),'generated',name,label]
  with (run/(label+'.log')).open('w') as f:
   result=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,
       preexec_fn=lambda:os.sched_setaffinity(0,{cores[lane]}))
  receipt=json.loads((B/'runs'/label/'receipt.json').read_text())
  record={k:receipt[k] for k in ['module','exit_code','warning_count','error_count','elapsed_seconds']}
  with lock:
   with (run/'progress.jsonl').open('a') as f:f.write(json.dumps(record)+'\n')
   print(json.dumps(record),flush=True)
  if result.returncode or receipt['warning_count'] or receipt['error_count']:
   stop.set();return
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
 list(pool.map(lane,range(2)))
if stop.is_set():sys.exit(1)
(run/'COMPLETE.json').write_text(json.dumps({'status':'ALL_COMPILED_CLEAN','first_batch':'witness000001','remaining_batches':120,'cores':cores})+'\n')
