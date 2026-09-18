"""Read-only final validation with an externally supplied OUTPUTS pin."""
import hashlib,json,sys
from pathlib import Path
from replaylib import sha,verify_manifest
if sys.flags.optimize:raise RuntimeError('run with Python assertions enabled')
W=Path(__file__).absolute().parents[1]
if len(sys.argv)!=2:raise ValueError('external OUTPUTS SHA-256 required')
rows=verify_manifest(W,'OUTPUTS.sha256',sys.argv[1])
result=json.loads((W/'RESULT.json').read_text());prefix=json.loads((W/'artifacts/command_prefix.json').read_text())
assert result['status']=='L_NTT_PROVED_FOR_PINNED_MODEL' and result['L_NTT_proved'] and result['forward_product_proved']
assert result['remaining_global_hypotheses']==[] and not result['source_integrated'] and not result['owner_accepted'] and not result['full_L_V_proved']
assert sha(W/'REPORT.md')==result['report_sha256']
assert sha(W/prefix['snapshot'])==prefix['sha256']
if (W/'COMMANDS.log').exists():
    assert hashlib.sha256((W/'COMMANDS.log').read_bytes()[:prefix['bytes']]).hexdigest()==prefix['sha256']
fresh=json.loads((W/'artifacts/fresh_replay.json').read_text())
assert len(fresh['matches'])==217
for row in fresh['matches']:assert rows[row['path']]==row['sha256']
print(json.dumps(dict(status=result['status'],manifest='PASS',verified_entries=len(rows),command_prefix='PASS',
    replay_matches_bound=217,REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256')),indent=2))
