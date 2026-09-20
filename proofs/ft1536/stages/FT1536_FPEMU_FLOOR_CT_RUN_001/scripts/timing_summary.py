import hashlib,json
from pathlib import Path
from streams import open_stream,digest
from replaylib import sha
W=Path.cwd();plan=json.loads((W/'TIMING_PLAN.json').read_text());run=json.loads((W/'timing/RUN.json').read_text());replay=json.loads((W/'artifacts/timing_recalculation.json').read_text())
assert run['plan_sha256']==sha(W/'TIMING_PLAN.json') and len(run['trials'])==len(plan['schedule'])==30
assert run['status']=='COMPLETED_PRESPECIFIED_SCHEDULE' and run['elapsed_seconds']<=1800 and run['all_workers_finished']
rows=[];storage=0;maxpart=0
for i,(s,r,rr) in enumerate(zip(plan['schedule'],run['trials'],replay['trials'])):
 for k in ['round','case_id','variant']:assert s[k]==r[k]==rr[k]
 folder=W/r['folder'];rec=json.loads((folder/'receipt.json').read_text());streams=json.loads((folder/'STREAMS.json').read_text())
 assert rec['public_order']==s['public_order'] and rec['cpu']==plan['cpu'] and rec['raw_complete'] and rec['seconds']<=60
 assert rr['all_102_states_exact'] and rr['n']==r['n'] and rr['max_t']==r['max_t']
 batches=[]
 with open_stream(folder,'stdout.txt') as f:
  for line in f:
   if line.startswith(b'FT1536_BATCH '):batches.append(json.loads(line.split(b' ',1)[1]))
 assert len(batches)==rr['batches']
 peak=max(x['max_t'] for x in batches if x['max_t'] is not None)
 for name,v in streams.items():
  assert v['sha256']==rec['files'][name] and sum(p['bytes'] for p in v['parts'])==v['bytes']
  for p in v['parts']:assert p['bytes']<=32*2**20;storage+=p['bytes'];maxpart=max(maxpart,p['bytes'])
 passed=(r['status']=='LEAKAGE_FOUND') if r['case_id']==1 or (r['variant']=='baseline' and r['case_id'] in [2,3,4]) else (r['status']=='NO_LEAKAGE_EVIDENCE_YET' and min(r['n'])>=1000000)
 rows.append(dict(**r,peak_batch_max_t=peak,meets_prespecified_rule=passed,raw_batches=len(batches),all_102_states_recalculated=True))
pos=[r for r in rows if r['case_id']==1];neg=[r for r in rows if r['case_id']==0];base=[r for r in rows if r['variant']=='baseline' and r['case_id'] in [2,3,4]];cand=[r for r in rows if r['variant']=='candidate' and r['case_id'] in [2,3,4]]
ok=all(r['meets_prespecified_rule'] for r in rows)
out=dict(status='PASS_PRESPECIFIED_AB_EXPLORATORY_SHARED_HOST' if ok else 'INCONCLUSIVE_OR_SIGNAL',trials=rows,
 complete_rounds=3,plan_sha256=sha(W/'TIMING_PLAN.json'),elapsed_seconds=run['elapsed_seconds'],cpu=plan['cpu'],host_scope=plan['host_scope'],
 baseline_signal_reproduced=all(r['status']=='LEAKAGE_FOUND' for r in base),candidate_signal_detected=any(r['status']=='LEAKAGE_FOUND' for r in cand),
 positive_controls_pass=sum(r['meets_prespecified_rule'] for r in pos),negative_controls_pass=sum(r['meets_prespecified_rule'] for r in neg),
 baseline_floor_detections=sum(r['status']=='LEAKAGE_FOUND' for r in base),candidate_floor_no_signal=sum(r['status']=='NO_LEAKAGE_EVIDENCE_YET' for r in cand),
 candidate_floor_min_n=min(min(r['n']) for r in cand),candidate_floor_final_t_range=[min(r['max_t'] for r in cand),max(r['max_t'] for r in cand)],
 baseline_floor_final_t_range=[min(r['max_t'] for r in base),max(r['max_t'] for r in base)],
 storage_bytes=storage,max_stream_part_bytes=maxpart,all_raw_complete=True,all_102_states_recalculated=True,physical_timing_rerun=False,
 interpretation='No diagnosed control/execution failure; host not reserved, variable frequency/interference cannot be excluded. Qualified one-build evidence, not hardware/backend/Sign CT proof.')
(W/'artifacts/timing_summary.json').write_text(json.dumps(out,indent=2)+'\n')
lines=['# FPEMU_FLOOR_CT — prespecified A/B','',out['status'],'',
 f"CPU{plan['cpu']}, non-SMT verified, shared host. Frozen plan `{out['plan_sha256']}`.",
 f"30 trials /3 rounds, elapsed {run['elapsed_seconds']:.3f}s; each engine budget30s, every observed trial<60s, global1800s.",
 'Official engine/harness/classes0..4/order/warmup/chunk64/batch100000/thresholds unchanged.',
 'No tuning/retry/selection; all outcomes, raw streams,102 test states and percentiles retained.',
 '', '| Round | Case | Variant | Result | n0 / n1 | final max abs(t) | peak batch max abs(t) |', '|---|---|---|---|---|---|---|']
for r in rows:lines.append(f"|{r['round']}|{r['case']}|{r['variant']}|{r['status']}|{r['n'][0]} / {r['n'][1]}|{r['max_t']:.9g}|{r['peak_batch_max_t']:.9g}|")
lines+=['',f"Baseline floor detections {out['baseline_floor_detections']}/9; candidate no-signal {out['candidate_floor_no_signal']}/9.",
 f"Positive controls {out['positive_controls_pass']}/6; negative controls {out['negative_controls_pass']}/6. Candidate floor minimum per-class n={out['candidate_floor_min_n']}.",
  f"All{sum(r['raw_batches'] for r in rows)} recorded batches were independently reread and recalculated by the unchanged official engine; all102 states match exactly. This is deterministic recalculation, not a second statistical method or new physical campaign.",
 'Machine before/after/latest snapshots per trial, cpuinfo/kernel/topology/process and CPU selection receipts are retained. Affinity is not exclusive core reservation. No privileged OS changes or background worker remains.',
 'Known shared-host conditions and variable frequency remain an exploratory limitation; no blanket CT claim follows from NO_LEAKAGE_EVIDENCE_YET.',
 'Each STREAMS.json specifies lossless ordered parts, sizes and whole-stream hashes. Largest part <=32MiB. No subsampling/outlier removal outside the official engine.',
 'Baseline night context is only the delivered projection:12 supplied raw streams replayed here; external negative/other raw were not read or represented as a full archive.']
(W/'TIMING_REPORT.md').write_text('\n'.join(lines)+'\n')
print(json.dumps({k:v for k,v in out.items() if k!='trials'},indent=2))
