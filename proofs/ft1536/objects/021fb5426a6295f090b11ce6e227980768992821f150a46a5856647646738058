import argparse,json,os,shutil,signal,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest,member
from package_scope import seed_paths,semantic_paths
P=argparse.ArgumentParser();P.add_argument('destination');P.add_argument('external_sha256');P.add_argument('--rehearsal',action='store_true');args=P.parse_args()
if not __debug__:raise RuntimeError('Assertions must remain enabled')
W=Path(__file__).absolute().parents[1];manifest='artifacts/rehearsal_inputs.sha256' if args.rehearsal else 'OUTPUTS.sha256'
entries=verify_manifest(W,manifest,args.external_sha256);expected=json.loads(member(W,'SEMANTIC_FILES.json').read_text())['matches'];assert len({r['path'] for r in expected})==len(expected)>0
for r in expected:assert entries[r['path']]==r['sha256']
D=Path(args.destination);assert D.is_absolute() and '..' not in D.parts and D.resolve()==D and D.is_relative_to(W/'tmp') and D!=W/'tmp'
assert not D.exists() and not D.is_symlink() and D.parent.is_dir();seed=seed_paths(entries);D.mkdir()
for name in seed:
 dst=D/name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(member(W,name),dst);assert sha(dst)==entries[name]
for rel in ['bin','tmp','logs','artifacts/diffs','artifacts/replay_jobs']:(D/rel).mkdir(parents=True,exist_ok=True)
r=dict(status='RUNNING',mode='PREFREEZE_REHEARSAL' if args.rehearsal else 'STANDARD',input_manifest=manifest,input_manifest_sha256=args.external_sha256,source=str(W),destination=str(D),seed_members=len(seed),cached_olean_or_binaries_used=False,source_changed=False,jobs=[]);tick=time.monotonic()
def save():(D/'REPLAY_RESULT.json').write_text(json.dumps(r,indent=2)+'\n')
def job(tag,seconds,script,*arguments,asan=False,sage=False):
 interpreter=['/home/footfalcon/.local/bin/sage'] if sage else ['/usr/bin/python3','-B'];cmd=['/usr/bin/python3','-B','scripts/run.py',str(seconds)]+interpreter+['scripts/'+script+'.py',*arguments]
 env=dict(os.environ);env.pop('FT1536_ASAN',None);env['PYTHONOPTIMIZE']='0';env['PYTHONDONTWRITEBYTECODE']='1'
 if asan:env['FT1536_ASAN']='1'
 base=D/'artifacts/replay_jobs';so=base/(tag+'.stdout');se=base/(tag+'.stderr');start=time.monotonic();timed=False
 with so.open('xb') as o,se.open('xb') as e:
  p=subprocess.Popen(cmd,cwd=D,env=env,stdout=o,stderr=e,start_new_session=True)
  try:p.wait(timeout=seconds+10)
  except (subprocess.TimeoutExpired,KeyboardInterrupt):timed=True;os.killpg(p.pid,signal.SIGKILL);p.wait()
 row=dict(tag=tag,argv=cmd,cwd=str(D),exit_code=p.returncode,timeout=timed,elapsed_seconds=time.monotonic()-start,stdout=so.relative_to(D).as_posix(),stderr=se.relative_to(D).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se));r['jobs'].append(row);save()
 print(json.dumps(dict(job=tag,exit_code=p.returncode,elapsed_seconds=row['elapsed_seconds'])),flush=True);assert not timed and p.returncode==0,tag
try:
 save();job('toolchain',60,'toolchain');job('binding',120,'source_binding');job('source_checks',60,'source_checks')
 job('bank_bounds',120,'bank_bounds',sage=True);job('metric_bounds',120,'metric_bounds',sage=True);job('energy_transfer',120,'energy_transfer',sage=True)
 job('kernel',240,'kernel_build');job('audit',90,'audit');job('fixtures',240,'fixtures');job('normal',180,'controls','normal');job('sanitizers',180,'controls','san',asan=True)
 job('banks_normal',180,'bank_controls','normal');job('banks_san',180,'bank_controls','san',asan=True);job('metric_oracle',240,'metric_oracle',sage=True);job('mutations',60,'mutations');job('certificate',60,'certificate')
 assert set(semantic_paths(D))=={x['path'] for x in expected},'generated semantic scope changed'
 for x in expected:assert sha(member(D,x['path']))==x['sha256'],x['path']
 assert verify_manifest(W,manifest,args.external_sha256)==entries
 r.update(status='FRESH_REPLAY_PASS',matches=expected,semantic_matches=len(expected),elapsed_seconds=time.monotonic()-tick);save();print(json.dumps({k:v for k,v in r.items() if k not in ['matches','jobs']},indent=2))
except BaseException as e:r.update(status='REPLAY_FAILED',error=repr(e),elapsed_seconds=time.monotonic()-tick);save();raise
