import json,struct
from pathlib import Path
from ordered_model import Machine
from dyadic import value,rn
from replaylib import sha
W=Path.cwd();D=W/'checks/mutations';D.mkdir(parents=True,exist_ok=True);rows=[]
jobs=[('noop','normal_endpoints'),('wrong_root_order','normal_endpoints'),('omit_split1','normal_endpoints'),('stale_mu0','normal_endpoints'),('omit_final_sub','normal_endpoints'),('late_snapshot','normal_endpoints'),('fault_as_close','base_large_fault'),('nonreturn_as_zero','nonreturn_prefix')]
for kind,case in jobs:
 p=json.loads((W/'checks/data'/(case+'.meta.json')).read_text());m=Machine(W,p['tree'],p['t0'],p['t1'],p['tape'],None if kind=='noop' else kind);r=m.run(p['mode'])
 orig=json.loads((W/'checks/data'/(case+'.calls.json')).read_text());original_mem=(W/'checks/data'/(case+'.memory.bin')).read_bytes();memory=struct.pack('<10752Q',*m.mem['T']);accept=r==p['result'] and orig==m.calls and original_mem==memory
 assert accept==(kind=='noop'),kind
 (D/(kind+'.trace')).write_text('\n'.join(m.events)+'\n');(D/(kind+'.calls.json')).write_text(json.dumps(m.calls,indent=2)+'\n');(D/(kind+'.memory.bin')).write_bytes(memory)
 rows.append(dict(kind=kind,checker_accepts=accept,result=r,first_center_or_outcome_difference=next((i for i,(a,b) in enumerate(zip(orig,m.calls)) if a!=b),None),trace_sha256=sha(D/(kind+'.trace')),memory_sha256=sha(D/(kind+'.memory.bin'))));print(json.dumps(dict(mutation=kind,accepted=accept)),flush=True)
# First unresolved domain stops before floor; must not disappear by assuming NumericCenter in a history definition.
p=json.loads((W/'checks/data/base_large_fault.meta.json').read_text());p['t1'][0]=rn(2**40);p['tape'][0]=['N',0,0,0];m=Machine(W,p['tree'],p['t0'],p['t1'],p['tape']);r=m.run('base');assert r['status']=='PRE_FLOOR_DOMAIN_STOP'
(D/'unsafe_entry.calls.json').write_text(json.dumps(m.calls,indent=2)+'\n')
rows.append(dict(kind='hidden_NumericCenter_premise',checker_accepts=False,result=r,membership='Synthetic extended root entry, not TARGETS/P_key/emitted',evidence_sha256=sha(D/'unsafe_entry.calls.json')))
rows.append(dict(kind='typical_sample_support_cap3',checker_accepts=False,source_bank4_support=365,admissible_endpoint=366,membership='All-bank support countermodel, not source probabilistic witness'))
out=dict(status='PASS_HISTORY_DOMAIN_MUTATIONS',rows=rows,required_domain_counterexample=False,normal_tape_is_source_outcome_overapproximation=True)
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],controls=len(rows)),indent=2))
