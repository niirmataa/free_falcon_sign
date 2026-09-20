import json,os,subprocess,time
from pathlib import Path
import dudect_mechanics as dm
from replaylib import sha
W=Path.cwd();assert not (W/'TIMING_PLAN.json').exists();freeze=json.loads((W/'artifacts/candidate_freeze.json').read_text())
assert sha(W/'candidate/source/fpr-emulated.h')==freeze['candidate_header_sha256']
build=json.loads((W/'artifacts/benchmark_build.json').read_text())
for r in build['binaries'].values():assert sha(W/r['path'])==r['sha256']
assert json.loads((W/'artifacts/formal_audit.json').read_text())['all_final_logs_clean']
assert json.loads((W/'artifacts/assembly_ledger.json').read_text())['status']=='PASS_PINNED_FLOOR_FIXED_CONTROL_AND_MEMORY_TRACE'
host=W/'artifacts/timing_host';host.mkdir(exist_ok=True);commands=[]
for name,argv in [('lscpu',['/usr/bin/lscpu']),('kernel',['/usr/bin/uname','-a']),('processes',['/usr/bin/ps','-eo','pid,comm,pcpu,psr','--sort=-pcpu'])]:
 p=subprocess.run(argv,capture_output=True,timeout=15);(host/(name+'.stdout')).write_bytes(p.stdout);(host/(name+'.stderr')).write_bytes(p.stderr)
 commands.append(dict(argv=argv,exit_code=p.returncode,stdout_sha256=sha(host/(name+'.stdout')),stderr_sha256=sha(host/(name+'.stderr'))));assert p.returncode==0
(host/'cpuinfo.txt').write_text(Path('/proc/cpuinfo').read_text());(host/'commands.json').write_text(json.dumps(commands,indent=2)+'\n')
before=dm.snapshot();cpu,busy=dm.choose_cpu();after=dm.snapshot()
assert str(cpu)==dm.read_optional(f'/sys/devices/system/cpu/cpu{cpu}/topology/thread_siblings_list')
(host/'selection.json').write_text(json.dumps(dict(cpu=cpu,busy_fraction_five_seconds=busy,non_SMT_verified=True,exclusive_reservation=False,before=before,after=after),indent=2)+'\n')
schedule=[]
for r in range(3):
 for c in [1,0,2,3,4]:
  for variant in (['baseline','candidate'] if r in [0,2] else ['candidate','baseline']):
   schedule.append(dict(round=r,case_id=c,case=dm.CASES[c],variant=variant,public_order=dm.order_for(r,c),engine_budget_seconds=30))
assert len(schedule)==30
plan=dict(schema='FT1536_FLOOR_CT_CONFIRMATORY_PLAN_V1',created_utc=dm.utc(),candidate_header_sha256=freeze['candidate_header_sha256'],candidate_manifest_sha256=freeze['candidate_manifest_sha256'],
 cpu=cpu,non_SMT_verified=True,host_scope='EXPLORATORY_SHARED_HOST_NOT_EXCLUSIVELY_RESERVED',preselection_busy_fraction=busy[cpu],
 global_wall_budget_seconds=1800,trial_wall_limit_seconds=60,engine_budget_seconds=30,batch_watchdog_seconds=120,
 min_uncropped_per_class=1000000,log_bytes_per_second=2*2**20,batch_size=100000,chunk_size=64,warmups=10000,
 reason_for_30_seconds='Prespecified per-trial engine budget below60s, with bounded last-batch/cleanup reserve; unchanged minimum counts and engine stop threshold.',
 schedule=schedule,binaries=build['binaries'],vendor_sha256=sha(W/'vendor/dudect.h'),harness=build['harness'],
 engine_commit='dc269651fb2567e46755cfb2a13d3875592968b5',threshold_unchanged=True,
 comparison_policy='Require positive controls, negative controls no signal and n>=1e6, baseline floor signal, and candidate no signal with n>=1e6 in all rounds. Incomplete/budget/observed interference -> INCONCLUSIVE. No selection or retry.',
 readiness={r:sha(W/r) for r in ['artifacts/formal_audit.json','artifacts/semantic_normal.json','artifacts/semantic_san.json','artifacts/assembly_ledger.json','artifacts/historical_recalculation.json']})
with (W/'TIMING_PLAN.json').open('x') as f:json.dump(plan,f,indent=2);f.write('\n')
print(json.dumps(dict(status='PLAN_FROZEN_BEFORE_FIRST_MEASUREMENT',plan_sha256=sha(W/'TIMING_PLAN.json'),cpu=cpu,busy_fraction=busy[cpu],trials=30,engine_seconds=30,global_budget=1800,host_scope=plan['host_scope']),indent=2))
