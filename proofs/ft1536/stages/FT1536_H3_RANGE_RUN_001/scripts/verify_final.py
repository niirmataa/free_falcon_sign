import hashlib,json,sys
from pathlib import Path
from replaylib import sha,verify_manifest
if sys.flags.optimize:raise RuntimeError('assertions required')
W=Path(__file__).absolute().parents[1]
if len(sys.argv)!=2:raise ValueError('external OUTPUTS pin required')
rows=verify_manifest(W,'OUTPUTS.sha256',sys.argv[1]);r=json.loads((W/'RESULT.json').read_text())
assert r['status']=='PARTIAL_PROOF' and not r['H3_range_proved'] and not r['required_domain_counterexample']
assert r['baseline_source_integrated'] and not any(r[k] for k in ['source_changed','new_source_patch_integrated','protocol_wrapper_integrated','owner_accepted','security_reduction_proved'])
assert sha(W/'REPORT.md')==r['report_sha256']
p=json.loads((W/'artifacts/command_prefix.json').read_text());assert sha(W/p['snapshot'])==p['sha256']
if (W/'COMMANDS.log').exists():assert hashlib.sha256((W/'COMMANDS.log').read_bytes()[:p['bytes']]).hexdigest()==p['sha256']
fresh=json.loads((W/'artifacts/fresh_replay.json').read_text());assert len(fresh['matches'])==96
for m in fresh['matches']:assert rows[m['path']]==m['sha256']
print(json.dumps(dict(status=r['status'],manifest='PASS',verified_entries=len(rows),frozen_prefix='PASS',replay_matches_bound=96,REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256')),indent=2))
