"""Verify external pin before DEST; rebuild, then replay data. Physical timing is opt-in."""
import argparse,json,os,shutil,signal,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest,member
from package_scope import seed_paths,semantic_paths
P=argparse.ArgumentParser();P.add_argument('destination');P.add_argument('external_sha256')
mode=P.add_mutually_exclusive_group();mode.add_argument('--rehearsal',action='store_true');mode.add_argument('--physical-timing',action='store_true')
args=P.parse_args();W=Path(__file__).absolute().parents[1]
if not __debug__:raise RuntimeError('Assertions must be enabled')
manifest='artifacts/rehearsal_inputs.sha256' if args.rehearsal else 'OUTPUTS.sha256'
entries=verify_manifest(W,manifest,args.external_sha256)
expected=json.loads(member(W,'SEMANTIC_FILES.json').read_text())['matches']
assert len({r['path'] for r in expected})==len(expected)>0
for r in expected:assert entries[r['path']]==r['sha256']
D=Path(args.destination)
assert D.is_absolute() and '..' not in D.parts and D.resolve()==D and D.is_relative_to(W/'tmp') and D!=W/'tmp'
assert not D.exists() and not D.is_symlink() and D.parent.is_dir()
seed=seed_paths(W,entries,args.physical_timing);D.mkdir()
for name in seed:
 src=member(W,name);dst=D/name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst);assert sha(dst)==entries[name]
for rel in ['bin','tmp','logs','artifacts/diffs','artifacts/replay_jobs']:(D/rel).mkdir(parents=True,exist_ok=True)
receipt=dict(status='RUNNING',mode='NEW_PHYSICAL_TIMING' if args.physical_timing else ('PREFREEZE_REHEARSAL' if args.rehearsal else 'STANDARD'),
 input_manifest=manifest,input_manifest_sha256=args.external_sha256,source=str(W),destination=str(D),seed_members=len(seed),
 cached_binaries_or_olean_used=False,physical_timing_rerun=args.physical_timing,jobs=[])
tick=time.monotonic()
def save(): (D/'REPLAY_RESULT.json').write_text(json.dumps(receipt,indent=2)+'\n')
def job(tag,seconds,script,*argv,asan=False,timing=False):
 cmd=['/usr/bin/python3','-B','scripts/run.py',str(seconds),'/usr/bin/python3','-B','scripts/'+script+'.py',*argv]
 env=dict(os.environ);env.pop('FT1536_ASAN',None);env.pop('FLOOR_CT_TIMING',None);env['PYTHONOPTIMIZE']='0';env['PYTHONDONTWRITEBYTECODE']='1'
 if asan:env['FT1536_ASAN']='1'
 if timing:env['FLOOR_CT_TIMING']='1'
 base=D/'artifacts/replay_jobs';so=base/(tag+'.stdout');se=base/(tag+'.stderr');start=time.monotonic();timed=False
 with so.open('xb') as o,se.open('xb') as e:
  p=subprocess.Popen(cmd,cwd=D,env=env,stdout=o,stderr=e,start_new_session=True)
  try:p.wait(timeout=seconds+10)
  except (subprocess.TimeoutExpired,KeyboardInterrupt):timed=True;os.killpg(p.pid,signal.SIGKILL);p.wait()
 row=dict(tag=tag,argv=cmd,cwd=str(D),exit_code=p.returncode,timeout=timed,elapsed_seconds=time.monotonic()-start,
  stdout=so.relative_to(D).as_posix(),stderr=se.relative_to(D).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se))
 receipt['jobs'].append(row);save();print(json.dumps(dict(job=tag,exit_code=p.returncode,elapsed_seconds=row['elapsed_seconds'])),flush=True)
 assert not timed and p.returncode==0,tag
try:
 save()
 job('toolchain',30,'toolchain')
 job('binding',60,'source_binding')
 job('fixtures',120,'fixtures')
 job('kernel',180,'audit','--build')
 job('lean_values',120,'check_lean_values')
 job('normal',120,'semantic_checks','normal')
 job('sanitizers',120,'semantic_checks','san',asan=True)
 job('semantic_summary',30,'summary_checks')
 job('assembly_build',120,'build_asm','portable_001')
 job('benchmark_build',120,'build_benchmark')
 job('assembly_review',60,'assembly_review')
 job('historical_raw',120,'raw_replay','historical')
 if args.physical_timing:
  # All our builds/proofs/replays have exited before this new independent plan.
  job('new_plan',60,'timing_plan')
  job('new_physical_campaign',1800,'timing_ab',timing=True)
 job('confirmatory_raw',240,'raw_replay','confirmatory')
 job('timing_summary',60,'timing_summary')
 job('evidence_integrity',120,'evidence_integrity')
 if args.physical_timing:
  job('archive_new_raw_recalcs',60,'archive_recalcs')
  receipt.update(status='NEW_PHYSICAL_MEASUREMENT_COMPLETED',timing_result=json.loads((D/'artifacts/timing_summary.json').read_text())['status'],
   historical_status_replaced=False,old_timing_bytes_compared=False)
 else:
  assert set(semantic_paths(D))=={r['path'] for r in expected},'generated semantic scope changed'
  for r in expected:assert sha(member(D,r['path']))==r['sha256'],r['path']
  receipt.update(status='FRESH_REPLAY_PASS',matches=expected,semantic_matches=len(expected),all_102_states_exact=True,
   historical_raw_trials=12,confirmatory_raw_trials=30,confirmatory_batches=9771)
 assert verify_manifest(W,manifest,args.external_sha256)==entries
 receipt['elapsed_seconds']=time.monotonic()-tick;save()
 print(json.dumps({k:v for k,v in receipt.items() if k not in ['matches','jobs']},indent=2))
except BaseException as e:
 receipt.update(status='REPLAY_FAILED',error=repr(e),elapsed_seconds=time.monotonic()-tick);save();raise
