import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import sha,member,verify_manifest
W=Path(__file__).absolute().parents[1]
def main():
 args=sys.argv[1:];rehearsal=len(args)==2 and args[0]=='--rehearsal'
 if rehearsal:
  if (W/'OUTPUTS.sha256').exists():raise ValueError('rehearsal only before freeze')
  dest=args[1];p=member(W,'artifacts/semantic_manifest.sha256');rows=verify_manifest(W,'artifacts/semantic_manifest.sha256',sha(p))
  matches=[dict(path=p,sha256=h) for p,h in sorted(rows.items())];pin=None
 else:
  if len(args)!=2:raise ValueError('replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256')
  dest,pin=args;scope=verify_manifest(W,'OUTPUTS.sha256',pin);old=json.loads(member(W,'artifacts/fresh_replay.json').read_text());matches=old['matches'];seen=set()
  if old['status']!='FRESH_REPLAY_PASS' or not matches:raise ValueError('invalid archived replay')
  for r in matches:
   if r['path'] in seen or scope.get(r['path'])!=r['sha256']:raise ValueError('unbound match')
   seen.add(r['path'])
 D=Path(dest).absolute()
 if '..' in D.parts or not D.is_relative_to(W/'tmp') or D==W/'tmp' or D.exists() or D.is_symlink() or any(x.is_symlink() for x in D.parents):raise ValueError('DEST must be new under tmp')
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
 for name in ['Floor','Comparator','Proposal','OrderedResidual','GuardPrefix']:cp('formal/'+name+'.lean')
 for name in ['probe.c','order.c','boundaries.c','leaf_gap.c']:cp('checks/'+name)
 cp('REACHABILITY.md')
 for name in ['run','lean','probe','dyadic','analyze_probes','export_cdf','order_model','order_checks','boundaries','leaf_gap','algebra','source_bindings','ledger','audit','replaylib','toolchain']:cp('scripts/'+name+'.py')
 for name in ['artifacts','logs','bin','tmp']:(D/name).mkdir(exist_ok=True)
 jobs=[('probe_normal',120,False,['python3','-B','scripts/probe.py','normal']),('probe_san',120,True,['python3','-B','scripts/probe.py','san']),
  ('cdf',30,False,['python3','-B','scripts/export_cdf.py']),('analysis',60,False,['python3','-B','scripts/analyze_probes.py']),
  ('order_normal',180,False,['python3','-B','scripts/order_checks.py','normal']),('order_san',180,True,['python3','-B','scripts/order_checks.py','san']),
  ('bound_normal',120,False,['python3','-B','scripts/boundaries.py','normal']),('bound_san',120,True,['python3','-B','scripts/boundaries.py','san']),
  ('gap_normal',120,False,['python3','-B','scripts/leaf_gap.py','normal']),('gap_san',120,True,['python3','-B','scripts/leaf_gap.py','san']),
  ('algebra',60,False,['/home/footfalcon/.local/bin/sage','scripts/algebra.py']),('binding',30,False,['python3','-B','scripts/source_bindings.py']),
  ('kernel',180,False,['python3','-B','scripts/audit.py','--build']),('ledger',30,False,['python3','-B','scripts/ledger.py']),('toolchain',90,False,['python3','-B','scripts/toolchain.py'])]
 records=[]
 for tag,limit,san,argv in jobs:
  cmd=['python3','-B','scripts/run.py',str(limit)]+argv;env=dict(os.environ);env['FT1536_ASAN']='1' if san else '0';env['PYTHONOPTIMIZE']='0'
  t=time.monotonic();p=subprocess.run(cmd,cwd=D,env=env,capture_output=True,timeout=limit+15)
  so=D/'logs'/('replay_'+tag+'.stdout');se=D/'logs'/('replay_'+tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
  records.append(dict(tag=tag,argv=cmd,cwd=str(D),exit_code=p.returncode,limit=limit,asan_shadow_reservation=san,elapsed=time.monotonic()-t,
   stdout=str(so.relative_to(D)),stderr=str(se.relative_to(D)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
  (D/'REPLAY_COMMANDS.json').write_text(json.dumps(records,indent=2)+'\n');print(tag,p.returncode,round(records[-1]['elapsed'],3),flush=True)
  if p.returncode:raise RuntimeError('replay job failed '+tag)
 for r in matches:
  if sha(member(D,r['path']))!=r['sha256']:raise ValueError('semantic mismatch '+r['path'])
 result=dict(status='FRESH_REPLAY_PASS',matches=matches,mode='rehearsal' if rehearsal else 'standard',expected_outputs_sha256=pin,
  theorem_status='PARTIAL_PROOF',global_H3_range_proved=False,no_carried_olean_binary_cache=True,originals_required=False,asan_ubsan_replayed=True)
 (D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
 if rehearsal:
  result['semantic_manifest_sha256']=sha(W/'artifacts/semantic_manifest.sha256')
  with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(result,f,indent=2);f.write('\n')
 print(json.dumps({k:v for k,v in result.items() if k!='matches'}|{'matched_files':len(matches)},indent=2))
if __name__=='__main__':main()
