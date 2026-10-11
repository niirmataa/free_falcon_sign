#!/usr/bin/env python3
"""One owned compiler at a time; measured RSS/maps, not mathematical evidence.
Owner authorised M6144 on2026-10-11. Never changes old build receipts.
Usage: python3 -B PROFILE_LEAN_020B.py SOURCE FRESH_LABEL
"""
from pathlib import Path
import os,sys,json,hashlib,subprocess,time,resource,re,fcntl
S=Path(__file__).resolve().parent.parent
B=S/'.build/pair_machine_020/cap_light_001'; D=B/'memory_001'
src=Path(sys.argv[1]).resolve(); label=sys.argv[2]
assert src.is_relative_to(S) and re.fullmatch(r'[a-z][a-z0-9_]*',label)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
lock=(D/'profile.lock').open('a');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
def memavail():
 return int(next(x.split()[1] for x in Path('/proc/meminfo').read_text().splitlines() if x.startswith('MemAvailable:')))
assert memavail()>=7*1024**2, 'insufficient available memory for6GiB diagnostic'
for p in Path('/proc').glob('[0-9]*'):
 try:
  if p.stat().st_uid==os.getuid():assert (p/'comm').read_text().strip()!='lean', 'another Lean is active'
 except (OSError,PermissionError):pass
pins=json.loads((B/'lib/PINS.json').read_text())
for r in pins:
 assert sha(Path(r['artifact']))==r['artifact_sha256']
 assert sha(Path(r['source']))==r['source_sha256']
out=D/label;out.mkdir(exist_ok=False)
(out/'source').mkdir();snap=out/'source'/src.name;snap.write_bytes(src.read_bytes())
(out/'runner_at_launch.py').write_bytes(Path(__file__).read_bytes())
libs=json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots']
lean=Path(libs['lean']['build']).parents[1]/'bin/lean'
env=os.environ.copy();env['LEAN_PATH']=':'.join([str(B/'lib')]+[v['build'] for k,v in libs.items() if k!='lean'])
for key,name in [('TMPDIR','tmp'),('XDG_CACHE_HOME','cache')]:
 p=out/name;p.mkdir();env[key]=str(p)
cmd=[str(lean),'--root='+str(out/'source'),'-j1','-s65536','-DElab.async=false',
 '-M6144','--profile','--stats','-o',str(out/(src.stem+'.olean')),str(snap)]
def caps():
 resource.setrlimit(resource.RLIMIT_AS,(10*1024**3,10*1024**3))
 resource.setrlimit(resource.RLIMIT_CPU,(110,115));resource.setrlimit(resource.RLIMIT_CORE,(0,0))
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
start=time.monotonic();samples=[];maps=[];lastmap=0;status='completed'
with (out/'stdout.txt').open('w') as so,(out/'stderr.txt').open('w') as se:
 proc=subprocess.Popen(cmd,cwd=out,env=env,stdout=so,stderr=se,preexec_fn=caps)
 while proc.poll() is None:
  elapsed=time.monotonic()-start
  try:
   raw=Path(f'/proc/{proc.pid}/status').read_text()
   fields={line.split(':',1)[0]:line.split(':',1)[1].strip() for line in raw.splitlines()}
   rss=int(fields.get('VmRSS','0 kB').split()[0]);avail=memavail()
   samples.append({'seconds':elapsed,'rss_KiB':rss,'hwm_KiB':int(fields.get('VmHWM','0 kB').split()[0]),'MemAvailable_KiB':avail})
   if elapsed-lastmap>=1 and rss>1024**2:
    rawmaps=Path(f'/proc/{proc.pid}/smaps').read_text()
    fn=f'smaps_{len(maps):03d}.txt';(out/fn).write_text(rawmaps)
    maps.append({'path':fn,'seconds':elapsed,'rss_KiB':rss});lastmap=elapsed
   if avail<2*1024**2:status='stopped_own_job_memory_pressure';proc.terminate();break
  except (OSError,ProcessLookupError):pass
  if elapsed>600:status='wall_timeout';proc.terminate();break
  time.sleep(0.2)
 try:rc=proc.wait(timeout=5)
 except subprocess.TimeoutExpired:proc.kill();rc=proc.wait()
log=(out/'stdout.txt').read_text()+(out/'stderr.txt').read_text()
receipt={'command':cmd,'original_source':str(src),'source_sha256':sha(snap),'exit_code':rc,'status':status,
 'elapsed_seconds':time.monotonic()-start,'compiler_peak_rss_KiB':resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
 'warning_count':log.count('warning:'),'error_count':log.count('error:'),'limits':{'Lean_M_MiB':6144,'AS_GiB':10,'CPU_seconds':110,'cores':1},
 'pins_sha256':sha(B/'lib/PINS.json'),'samples':samples,'maps':maps,'artifact_sha256':sha(out/(src.stem+'.olean')) if (out/(src.stem+'.olean')).exists() else None,
 'stdout_sha256':sha(out/'stdout.txt'),'stderr_sha256':sha(out/'stderr.txt'),'runner_sha256':sha(out/'runner_at_launch.py'),
 'scope':'diagnostic only; not installed as a proof dependency'}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({k:receipt[k] for k in ['status','exit_code','elapsed_seconds','compiler_peak_rss_KiB','warning_count','error_count']}))
sys.exit(0 if rc==0 else 1)
