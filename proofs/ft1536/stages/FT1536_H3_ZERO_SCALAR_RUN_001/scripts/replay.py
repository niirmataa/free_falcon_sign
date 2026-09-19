import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import sha,member,verify_manifest
W=Path(__file__).absolute().parents[1]
def main():
 args=sys.argv[1:];rehearsal=len(args)==2 and args[0]=='--rehearsal'
 if rehearsal:
  if (W/'OUTPUTS.sha256').exists():raise ValueError('rehearsal is pre-freeze only')
  dest=args[1];p=member(W,'artifacts/semantic_manifest.sha256');sem=verify_manifest(W,'artifacts/semantic_manifest.sha256',sha(p));matches=[dict(path=p,sha256=h) for p,h in sorted(sem.items())];pin=None
 else:
  if len(args)!=2:raise ValueError('replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256')
  dest,pin=args;scope=verify_manifest(W,'OUTPUTS.sha256',pin);r=json.loads(member(W,'artifacts/fresh_replay.json').read_text());matches=r['matches'];seen=set()
  if r['status']!='FRESH_REPLAY_PASS' or not matches:raise ValueError('bad archived receipt')
  for r in matches:
   if r['path'] in seen or scope.get(r['path'])!=r['sha256']:raise ValueError('unbound match')
   seen.add(r['path'])
 D=Path(dest).absolute()
 if '..' in D.parts or not D.is_relative_to(W/'tmp') or D==W/'tmp' or D.exists() or D.is_symlink() or any(p.is_symlink() for p in D.parents):raise ValueError('DEST must be new under tmp/')
 D.mkdir(parents=True,exist_ok=False)
 def cp(rel):
  if not rehearsal and rel not in scope:raise ValueError('unmanifested input '+rel)
  p=member(W,rel);h=sha(p) if rehearsal else scope[rel]
  if sha(p)!=h:raise ValueError('input changed')
  t=D/rel;t.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,t);assert sha(t)==h
 for folder in ['inputs','source']:
  for p in sorted((W/folder).rglob('*')):
   if p.is_symlink():raise ValueError('symlink input')
   if p.is_file():cp(p.relative_to(W).as_posix())
 for rel in json.loads(member(W,'artifacts/formal_audit.json').read_text())['sources_sha256']:
  if Path(rel).name not in ['ZeroAudit.lean','ZeroTypes.lean']:cp(rel)
 for rel in ['ANALYTIC_PROOF.md','M0_COMPATIBILITY.md','checks/scalar.c']:cp(rel)
 for name in ['run','lean','dyadic','fp_literal','controls','check_phases','check_lean_values','certificate','source_bindings','ledger','audit','replaylib','toolchain']:cp('scripts/'+name+'.py')
 for rel in ['logs','artifacts','bin','tmp']:(D/rel).mkdir(exist_ok=True)
 jobs=[('kernel',180,False,['python3','-B','scripts/audit.py','--build']),('normal',120,False,['python3','-B','scripts/controls.py','normal']),
  ('sanitizers',120,True,['python3','-B','scripts/controls.py','san']),('phases',90,False,['python3','-B','scripts/check_phases.py']),
  ('model_values',150,False,['python3','-B','scripts/check_lean_values.py']),('certificate',90,False,['/home/footfalcon/.local/bin/sage','scripts/certificate.py']),
  ('binding',30,False,['python3','-B','scripts/source_bindings.py']),('ledger',30,False,['python3','-B','scripts/ledger.py']),('toolchain',90,False,['python3','-B','scripts/toolchain.py'])]
 records=[]
 for tag,limit,san,argv in jobs:
  cmd=['python3','-B','scripts/run.py',str(limit)]+argv;env=dict(os.environ);env['FT1536_ASAN']='1' if san else '0';env['PYTHONOPTIMIZE']='0'
  tick=time.monotonic();p=subprocess.run(cmd,cwd=D,env=env,capture_output=True,timeout=limit+15)
  so=D/'logs'/('replay_'+tag+'.stdout');se=D/'logs'/('replay_'+tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
  records.append(dict(tag=tag,argv=cmd,cwd=str(D),exit_code=p.returncode,limit=limit,asan_shadow_reservation=san,elapsed=time.monotonic()-tick,
   stdout=str(so.relative_to(D)),stderr=str(se.relative_to(D)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
  (D/'REPLAY_COMMANDS.json').write_text(json.dumps(records,indent=2)+'\n');print(tag,p.returncode,round(records[-1]['elapsed'],3),flush=True)
  if p.returncode:raise RuntimeError('replay job failed '+tag)
 for r in matches:
  if sha(member(D,r['path']))!=r['sha256']:raise ValueError('semantic mismatch '+r['path'])
 out=dict(status='FRESH_REPLAY_PASS',matches=matches,mode='rehearsal' if rehearsal else 'standard',expected_outputs_sha256=pin,
  local_proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',fully_kernelized_source_add_error=False,
  no_carried_olean_binary_cache=True,originals_required=False,asan_ubsan_replayed=True,H3_range_proved=False,global_reachability_proved=False,sampler_law_proved=False)
 (D/'REPLAY_RESULT.json').write_text(json.dumps(out,indent=2)+'\n')
 if rehearsal:
  out['semantic_manifest_sha256']=sha(W/'artifacts/semantic_manifest.sha256')
  with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
 print(json.dumps({k:v for k,v in out.items() if k!='matches'}|{'matched_files':len(matches)},indent=2))
if __name__=='__main__':main()
