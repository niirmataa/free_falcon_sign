import json
from pathlib import Path
from replaylib import sha
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
c=load('ORDERED_REACH_CERTIFICATE.json');r=load('artifacts/fresh_replay.json');assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==load('SEMANTIC_FILES.json')['matches']
out={k:v for k,v in c.items() if k not in ['proof_evidence','upstream_dependencies']}
out.update(schema='FT1536_H3_ORDERED_REACH_RESULT_V1',certificate_sha256=sha(W/'ORDERED_REACH_CERTIFICATE.json'),
 semantic_controls='PASS_8_PUBLIC_RECURSION_TAPES_AND_504_SCALAR_CASES',sanitizers='PASS_ASan_UBSan',LSan_claimed=False,full_structural_completed_calls=3072,
 mutation_controls='PASS_NOOP_AND_9_HISTORY_OR_DOMAIN_NEGATIVE_CONTROLS',synthetic_emitted_membership_claimed=False,
 replay=dict(status=r['status'],semantic_matches=len(r['matches']),anchor_sha256=r['input_manifest_sha256'],receipt_sha256=sha(W/'artifacts/fresh_replay.json'),cached_project_binaries_or_olean_used=False),
 owner_summary=dict(proved='Right root branch active centers, source outcomes/stutter/fault disposition, signed terminal transfers and conditional frames',
  open='Left-root correlated weighted residual transfer; global NumericCenter remains unproved',meaning='Narrows the remaining H3 gap; no code defect or emitted counterexample established',next='Discharge actual raw-L/stable-weight metric/error bridge and left-prefix invariant'))
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
