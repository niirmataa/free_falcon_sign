"""Check independent provenance, measured-build pins and complete ordered streams."""
import datetime,json
from pathlib import Path
from dudect_mechanics import order_for
from replaylib import sha,verify_manifest,member
from streams import open_stream,LIMIT
W=Path.cwd();I=W/'inputs/bootstrap'
boot=verify_manifest(I,'MANIFEST.sha256','2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c')
assert len(boot)==382 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
assert not any(p.is_symlink() for p in I.rglob('*'))
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==381
for r in orig['files']:assert boot[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
provenance=json.loads((W/'inputs/provenance.json').read_text())
inputs={n:h for h,n in (s.split('  ',1) for s in (W/'INPUTS.sha256').read_text().splitlines())}
assert len(inputs)==len(provenance)==386 and inputs=={r['path']:r['sha256'] for r in provenance}
for r in provenance:assert sha(member(W,r['copy']))==r['sha256']
freeze=json.loads((W/'artifacts/candidate_freeze.json').read_text());plan=json.loads((W/'TIMING_PLAN.json').read_text());run=json.loads((W/'timing/RUN.json').read_text())
build=json.loads((W/'artifacts/benchmark_build.json').read_text());recalc=json.loads((W/'artifacts/timing_recalculation.json').read_text())
assert sha(W/'candidate/CANDIDATE.sha256')==plan['candidate_manifest_sha256']==freeze['candidate_manifest_sha256']
assert sha(W/'candidate/source/fpr-emulated.h')==plan['candidate_header_sha256']==freeze['candidate_header_sha256']
assert sha(W/'PATCH.diff')==freeze['patch_sha256']
assert plan['binaries']==build['binaries'] and plan['harness']==build['harness'] and sha(W/'vendor/dudect.h')==plan['vendor_sha256']
for r in plan['binaries'].values():assert sha(W/r['path'])==r['sha256']
for p,h in plan['readiness'].items():assert sha(member(W,p))==h,p
expected=[dict(round=r,case_id=c,variant=v,public_order=order_for(r,c)) for r in range(3) for c in [1,0,2,3,4] for v in (['baseline','candidate'] if r!=1 else ['candidate','baseline'])]
assert len(plan['schedule'])==len(run['trials'])==len(recalc['trials'])==30
assert run['plan_sha256']==sha(W/'TIMING_PLAN.json') and run['all_workers_finished'] and run['elapsed_seconds']<=1800
dt=datetime.datetime.fromisoformat;previous=dt(plan['created_utc']);assert previous<=dt(run['start_utc']);streams=0;parts=0;total=0;batches=0
for s,r,rr,e in zip(plan['schedule'],run['trials'],recalc['trials'],expected):
 for k,v in e.items():assert s[k]==v
 for k in ['round','case_id','variant']:assert r[k]==rr[k]==e[k]
 folder=W/r['folder'];rec=json.loads((folder/'receipt.json').read_text());records=json.loads((folder/'STREAMS.json').read_text())
 assert sha(folder/'receipt.json')==r['receipt_sha256'] and sha(folder/'STREAMS.json')==r['streams_sha256']
 assert previous<=dt(rec['start_utc'])<=dt(rec['end_utc'])<=dt(run['end_utc']);previous=dt(rec['end_utc'])
 assert rec['seconds']==r['seconds'] and rec['seconds']<=60 and rec['public_order']==s['public_order'] and rec['cpu']==plan['cpu']
 assert rec['raw_complete'] and rec['reason'] is None and rec['status']==r['status'] and rec['exit_code'] in [0,10]
 assert rec['frames']==rec['result']['batches']==rr['batches'] and rec['result']['n']==rr['n']==r['n']
 assert rec['last_batch']['max_t']==rr['max_t']==r['max_t'] and rr['all_102_states_exact']
 assert set(records)=={'stdout.txt','stderr.txt','timings.bin.gz'}
 for name,record in records.items():
  assert record['sha256']==rec['files'][name] and sum(p['bytes'] for p in record['parts'])==record['bytes']
  for p in record['parts']:assert 0<=p['bytes']<=LIMIT and member(folder,p['path']).stat().st_size==p['bytes']
  with open_stream(folder,name) as f:
   while f.read(1<<20):pass
  streams+=1;parts+=len(record['parts']);total+=record['bytes']
 batches+=rr['batches']
out=dict(status='PASS_PROVENANCE_MEASURED_BUILD_AND_LOSSLESS_STREAMS',bootstrap_members=382,origins=381,public_inputs=386,
 measured_binaries_match_rebuild=True,readiness_pins_match=True,ordered_nonoverlapping_trials=30,complete_streams=streams,
 storage_parts=parts,stream_bytes=total,all_batches=batches,part_limit_bytes=LIMIT,all_parts_and_full_stream_hashes_verified=True,
 timing_plan_sha256=sha(W/'TIMING_PLAN.json'),host_scope=plan['host_scope'],physical_timing_rerun=False)
(W/'artifacts/evidence_integrity.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
