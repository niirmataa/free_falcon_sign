"""Execute exactly the frozen A/B schedule, one worker; no compilation or replay."""
import json,os,signal,time
from pathlib import Path
import dudect_mechanics as dm
from replaylib import sha
from streams import seal_stream
W=Path.cwd();plan=json.loads((W/'TIMING_PLAN.json').read_text());T=W/'timing';T.mkdir(exist_ok=True)
assert not (T/'RUN.json').exists() and not (T/'STOP').exists()
assert sha(W/'candidate/source/fpr-emulated.h')==plan['candidate_header_sha256']
assert sha(W/'vendor/dudect.h')==plan['vendor_sha256']
for n,h in plan['harness'].items():assert sha(W/'harness'/n)==h
for r in plan['binaries'].values():assert sha(W/r['path'])==r['sha256']
for r,h in plan['readiness'].items():assert sha(W/r)==h
for sig in [signal.SIGINT,signal.SIGTERM]:signal.signal(sig,dm.stop_handler)
start=time.monotonic();deadline=start+plan['global_wall_budget_seconds'];run=dict(status='RUNNING',start_utc=dm.utc(),plan_sha256=sha(W/'TIMING_PLAN.json'),trials=[],host_scope=plan['host_scope'],cpu=plan['cpu'])
dm.dump(T/'RUN.json',run);error=None
try:
 for i,s in enumerate(plan['schedule']):
  if dm.STOP or time.monotonic()+65>deadline:raise RuntimeError('STOP_OR_GLOBAL_DEADLINE')
  folder=T/f"r{s['round']}_c{s['case_id']}_{s['variant']}"
  row=dm.run_trial(T,W/plan['binaries'][s['variant']]['path'],folder,s['case_id'],s['public_order'],s['engine_budget_seconds'],plan['cpu'])
  if row['seconds']>plan['trial_wall_limit_seconds']:row['status']='INCONCLUSIVE';row['reason']='TRIAL_WALL_LIMIT_EXCEEDED'
  records={}
  for name in ['stdout.txt','stderr.txt','timings.bin.gz']:
   records[name]=seal_stream(folder,name,W/'tmp/unsplit_timing'/folder.name)
  (folder/'STREAMS.json').write_text(json.dumps(records,indent=2)+'\n')
  r=dict(round=s['round'],case_id=s['case_id'],case=s['case'],variant=s['variant'],folder=folder.relative_to(W).as_posix(),status=row['status'],
   n=row['result']['n'] if row['result'] else None,max_t=row['last_batch']['max_t'] if row['last_batch'] else None,
   seconds=row['seconds'],raw_complete=row['raw_complete'],reason=row['reason'],receipt_sha256=sha(folder/'receipt.json'),streams_sha256=sha(folder/'STREAMS.json'))
  run['trials'].append(r);dm.dump(T/'RUN.json',run);print(json.dumps(r),flush=True)
  if not row['raw_complete']:raise RuntimeError('INCOMPLETE_TRIAL_RETAINED')
 run['status']='COMPLETED_PRESPECIFIED_SCHEDULE'
except (Exception,KeyboardInterrupt) as e:
 error=str(e);run['status']='INCONCLUSIVE_INTERRUPTED'
run.update(end_utc=dm.utc(),elapsed_seconds=time.monotonic()-start,error=error,all_workers_finished=True)
dm.dump(T/'RUN.json',run);dm.dump(T/'machine_final.json',dm.snapshot())
print(json.dumps(dict(status=run['status'],trials=len(run['trials']),elapsed_seconds=run['elapsed_seconds'],error=error),indent=2))
raise SystemExit(0 if run['status']=='COMPLETED_PRESPECIFIED_SCHEDULE' else 2)
