#!/usr/bin/env python3
"""Bounded Lean runner; only organization, hashes and logs (no math in Python)."""
import json,os,sys,subprocess,time,hashlib,resource
from pathlib import Path
s=Path(__file__).resolve().parent.parent
repo=s.parents[3]
out=s/sys.argv[1];out.mkdir(parents=True,exist_ok=False)
src=s/'formal/PivotOrder008.lean'
(out/src.name).write_bytes(src.read_bytes())
cfg=repo/'proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002/continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003/run/CONFIG.json'
a=json.loads(cfg.read_text());libs=a['library_roots'];lean=Path(libs['lean']['build']).parents[1]/'bin/lean'
env=os.environ.copy();env['LEAN_PATH']=':'.join(v['build'] for k,v in libs.items() if k!='lean')
for k,sub in [('TMPDIR','tmp'),('XDG_CACHE_HOME','cache')]:
 p=s/'.build/bridge_008'/sub;p.mkdir(parents=True,exist_ok=True);env[k]=str(p)
cmd=[str(lean),'-j1','-M2048','-o',str(out/'PivotOrder008.olean'),str(out/src.name)]
def caps():
 resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
 resource.setrlimit(resource.RLIMIT_CPU,(90,95))
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
start=time.monotonic();status='completed'
with (out/'stdout.txt').open('w') as so,(out/'stderr.txt').open('w') as se:
 try:ret=subprocess.run(cmd,cwd=out,env=env,stdout=so,stderr=se,timeout=100,preexec_fn=caps).returncode
 except subprocess.TimeoutExpired:ret=None;status='timeout'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt={'command':cmd,'status':status,'exit_code':ret,'elapsed_seconds':time.monotonic()-start,
 'source_sha256':sha(src),'snapshot_sha256':sha(out/src.name),'runner_sha256':sha(Path(__file__)),
 'config_sha256':sha(cfg),'library_roots':libs,'resource_limits':{'wall_seconds':100,'cpu_seconds':90,'memory_bytes':3*1024**3,'cores':1},
 'stdout_sha256':sha(out/'stdout.txt'),'stderr_sha256':sha(out/'stderr.txt'),
 'olean_sha256':sha(out/'PivotOrder008.olean') if (out/'PivotOrder008.olean').exists() else None,
 'scope':'Elementary identities only; coefficient/source binding remains textual and emitted-key witness OPEN'}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'path':str(out),'status':status,'exit_code':ret,'seconds':receipt['elapsed_seconds']}))
sys.exit(0 if ret==0 else 1)
