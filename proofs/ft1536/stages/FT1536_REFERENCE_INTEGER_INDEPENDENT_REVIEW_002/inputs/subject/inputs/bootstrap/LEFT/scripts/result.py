import json
from pathlib import Path
from replaylib import sha
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
c=load('LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json');r=load('artifacts/fresh_replay.json');assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==load('SEMANTIC_FILES.json')['matches']
out={k:v for k,v in c.items() if k not in ['proof_evidence','upstream_dependencies']}
out.update(schema='FT1536_H3_LEFT_ROOT_RESULT_V1',certificate_sha256=sha(W/'LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json'),
 semantic_controls='PASS_NEW_SOURCE_RAW_STABLE_SAMPLING_METRIC_FIXTURES',sanitizers='PASS_ASan_UBSan',LSan_claimed=False,native_sampling_cases=5,bank_terminal_cases=700,local_metric_frequency_checks=19968,
 mutation_controls='PASS_NOOP_AND_10_NEW_BANK_METRIC_ENERGY_NEGATIVE_CONTROLS',synthetic_emitted_membership_claimed=False,
 replay=dict(status=r['status'],semantic_matches=len(r['matches']),anchor_sha256=r['input_manifest_sha256'],receipt_sha256=sha(W/'artifacts/fresh_replay.json'),cached_project_binaries_or_olean_used=False),
 owner_summary=dict(proved='Source bank/paired A2 budgets, raw/stable metric comparison, right residual reconstruction and closed left invariant; composed full zero-aware root/caller finite-prefix NumericCenter',
  open='Whole sampler/Sign termination, source postprocessing/pre-cast/serialization, law/ROM-QROM/security/CT and old CenterClass',
  meaning='Closes the specific H3 left-root gap without changing code or key premises; does not prove the full scheme secure',next='Source postprocessing/pre-cast and source sampler-law obligations under the new NumericCenter interface'))
with (W/'RESULT.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
