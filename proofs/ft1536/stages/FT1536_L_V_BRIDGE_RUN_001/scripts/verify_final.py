"""Read-only verification with an external final manifest pin."""
import hashlib,json,sys
from pathlib import Path
from replaylib import sha,verify_manifest
if sys.flags.optimize:raise RuntimeError('Python assertions must be enabled')
W=Path(__file__).absolute().parents[1]
if len(sys.argv)!=2:raise ValueError('external OUTPUTS SHA-256 required')
rows=verify_manifest(W,'OUTPUTS.sha256',sys.argv[1]);r=json.loads((W/'RESULT.json').read_text())
assert r['status']=='L_V_PROVED_FOR_PINNED_MODEL' and r['full_L_V_proved']
assert r['full_L_V_source_sha256']==sha(W/'source/falcon-vrfy.c')
assert r['remaining_bridge_hypotheses']==[] and not r['source_integrated'] and not r['owner_accepted']
assert sha(W/'REPORT.md')==r['report_sha256']
p=json.loads((W/'artifacts/command_prefix.json').read_text());assert sha(W/p['snapshot'])==p['sha256']
if (W/'COMMANDS.log').exists():assert hashlib.sha256((W/'COMMANDS.log').read_bytes()[:p['bytes']]).hexdigest()==p['sha256']
fresh=json.loads((W/'artifacts/fresh_replay.json').read_text());assert len(fresh['matches'])==402
for m in fresh['matches']:assert rows[m['path']]==m['sha256']
print(json.dumps(dict(status=r['status'],manifest='PASS',verified_entries=len(rows),command_prefix='PASS',replay_matches_bound=402,
    REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256')),indent=2))
