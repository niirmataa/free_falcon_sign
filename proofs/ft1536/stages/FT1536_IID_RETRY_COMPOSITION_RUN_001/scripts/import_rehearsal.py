import json,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=Path(sys.argv[1]);assert D.is_absolute() and D.is_relative_to(W/'tmp')
R=json.loads((D/'REPLAY_RESULT.json').read_text());assert R['status']=='FRESH_REPLAY_PASS' and R['matched']==R['expected_files'] and R['matches']
assert R['external_manifest_sha256']==sha(W/'artifacts/rehearsal_anchor.sha256')
for r in R['matches']:assert sha(W/r['path'])==sha(D/r['path'])==r['sha256']
p=W/'artifacts/fresh_replay.json';assert not p.exists();p.write_bytes((D/'REPLAY_RESULT.json').read_bytes());print('SEALED_REHEARSAL_RECEIPT',R['matched'],sha(p))
