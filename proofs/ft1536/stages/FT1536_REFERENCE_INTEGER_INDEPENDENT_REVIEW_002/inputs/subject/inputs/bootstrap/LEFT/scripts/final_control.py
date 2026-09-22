import json,os,resource,signal,subprocess,sys,time
from pathlib import Path
from replaylib import sha
from verify import verify
W=Path(__file__).absolute().parents[1];mode=sys.argv[1];assert mode in ['seal','replay']
if mode=='replay':before=verify(W,sys.argv[2])
D=W/'tmp'/('final_'+mode+'_001');assert not D.exists();D.mkdir()
env=dict(os.environ);env.update(PYTHONOPTIMIZE='0',PYTHONDONTWRITEBYTECODE='1',GIT_OPTIONAL_LOCKS='0',HOME=str(D),TMPDIR=str(D),TMP=str(D),TEMP=str(D),XDG_CACHE_HOME=str(D/'cache'),DOT_SAGE=str(D/'sage'));env.pop('FT1536_ASAN',None)
scope=W if mode=='seal' else D
cmd=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--unshare-pid','--ro-bind','/','/','--bind',str(scope),str(scope),'--proc','/proc','--dev','/dev']
if mode=='seal':
 for rel in ['inputs/bootstrap','source']:cmd+=['--ro-bind',str(W/rel),str(W/rel)]
for p in [Path('/home/footfalcon/Dokumenty'),Path('/home/footfalcon/H'),Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/stages')]:
 if p.exists():cmd+=['--tmpfs',str(p),'--remount-ro',str(p)]
cmd+=['--chdir',str(W),'--','/usr/bin/python3','-B','scripts/seal.py' if mode=='seal' else 'scripts/replay.py']
if mode=='replay':cmd+=[str(D/'replay'),sys.argv[2]]
limit=60 if mode=='seal' else 240
def bounds():
 resource.setrlimit(resource.RLIMIT_CPU,(limit,limit+1));resource.setrlimit(resource.RLIMIT_CORE,(0,0));resource.setrlimit(resource.RLIMIT_NOFILE,(512,512))
 if mode=='seal':resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
start=time.monotonic();timed=False
with (D/'stdout.txt').open('xb') as o,(D/'stderr.txt').open('xb') as e:
 p=subprocess.Popen(cmd,cwd=W,env=env,stdout=o,stderr=e,start_new_session=True,preexec_fn=bounds)
 try:p.wait(timeout=limit)
 except (subprocess.TimeoutExpired,KeyboardInterrupt):timed=True;os.killpg(p.pid,signal.SIGKILL);p.wait()
receipt=dict(mode=mode,argv=cmd,cwd=str(W),wall_limit_seconds=limit,cpu_limit_seconds=limit,exit_code=p.returncode,timed_out=timed,elapsed_seconds=time.monotonic()-start,stdout_sha256=sha(D/'stdout.txt'),stderr_sha256=sha(D/'stderr.txt'),package_readonly=mode=='replay',receipt_root=str(D))
(D/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2));assert p.returncode==0 and not timed,'Inspect preserved controller receipts'
after=verify(W,sys.argv[2] if mode=='replay' else sha(W/'OUTPUTS.sha256'))
if mode=='replay':
 assert after==before;child=json.loads((D/'replay/REPLAY_RESULT.json').read_text());assert child['status']=='FRESH_REPLAY_PASS'
 print(json.dumps(dict(standard_replay='PASS',semantic_matches=child['semantic_matches'],receipt=str(D/'replay/REPLAY_RESULT.json')),indent=2))
print(json.dumps(after,indent=2))
