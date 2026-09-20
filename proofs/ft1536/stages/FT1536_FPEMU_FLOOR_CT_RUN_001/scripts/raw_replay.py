"""Recompute every official t state from complete raw streams; never new physical timing."""
import gzip,hashlib,itertools,json,subprocess,sys,time
from pathlib import Path
from streams import open_stream,digest
from replaylib import sha
W=Path.cwd()
def states(file):
 for line in file:
  if line.startswith(b'FT1536_BATCH '):yield json.loads(line.split(b' ',1)[1])
def recalc(binary,folder,tag,split_storage):
 out=W/'tmp/raw_replay'/tag;out.mkdir(parents=True,exist_ok=False)
 tick=time.monotonic();argv=[str(binary),'--replay']
 with (out/'stdout.txt').open('wb') as so,(out/'stderr.txt').open('wb') as se:
  p=subprocess.Popen(argv,stdin=subprocess.PIPE,stdout=so,stderr=se,cwd=W)
  raw=open_stream(folder,'timings.bin.gz') if split_storage else (folder/'timings.bin.gz').open('rb')
  try:
   with raw,gzip.GzipFile(fileobj=raw,mode='rb') as z:
    while data:=z.read(1<<20):p.stdin.write(data)
  finally:p.stdin.close()
  code=p.wait(timeout=120)
 assert code==0 and not (out/'stderr.txt').read_bytes(),(tag,code)
 expected=open_stream(folder,'stdout.txt') if split_storage else (folder/'stdout.txt').open('rb')
 n=0;state_hash=hashlib.sha256();last=None
 with expected,(out/'stdout.txt').open('rb') as got:
  for a,b in itertools.zip_longest(states(expected),states(got)):
   assert a is not None and a==b,(tag,n)
   state_hash.update((json.dumps(a,sort_keys=True,separators=(',',':'),allow_nan=False)+'\n').encode());n+=1;last=a
 assert n>0
 receipt=dict(tag=tag,argv=argv,cwd=str(W),exit_code=code,elapsed=time.monotonic()-tick,batches=n,
  all_102_states_exact=True,stdout_sha256=digest(out/'stdout.txt'),stderr_sha256=digest(out/'stderr.txt'),states_sha256=state_hash.hexdigest())
 (out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
 return dict(tag=tag,batches=n,all_102_states_exact=True,states_sha256=state_hash.hexdigest(),last_state=last['state'],n=last['n'],max_t=last['max_t'],replay_stdout_sha256=receipt['stdout_sha256'])
def main():
 mode=sys.argv[1];binary=W/'bin/dudect_baseline';rows=[]
 if mode=='historical':
  base=W/'inputs/bootstrap/DUD'
  paths=sorted(base.glob('campaign/round-*/*/timings.bin.gz'));assert len(paths)==12
  for i,p in enumerate(paths):
   r=recalc(binary,p.parent,f'historical_{i:02d}',False);r['trial']=p.parent.relative_to(base).as_posix();rows.append(r)
  out=dict(status='PASS_PROVIDED_HISTORICAL_RAW_PROJECTION',trials=rows,raw_trials_replayed=12,negative_raw_not_present=3,
   inventory='inputs/bootstrap/DUD/RAW_INVENTORY.json',maintainer_recalculation='inputs/bootstrap/DUD/RECEIPT_REVIEW.json',full_night_raw_archive_claimed=False)
  path=W/'artifacts/historical_recalculation.json'
 elif mode=='confirmatory':
  plan=json.loads((W/'TIMING_PLAN.json').read_text());run=json.loads((W/'timing/RUN.json').read_text())
  for i,r in enumerate(run['trials']):
   row=recalc(W/plan['binaries'][r['variant']]['path'],W/r['folder'],f'confirmatory_{i:02d}',True)
   row.update(round=r['round'],case_id=r['case_id'],variant=r['variant']);rows.append(row)
  assert len(rows)==30
  out=dict(status='PASS_ALL_RECORDED_CONFIRMATORY_RAW',trials=rows,all_102_states_exact=True,physical_timing_rerun=False)
  path=W/'artifacts/timing_recalculation.json'
 else:raise ValueError(mode)
 path.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],trials=len(rows),batches=sum(r['batches'] for r in rows)),indent=2))
if __name__=='__main__':main()
