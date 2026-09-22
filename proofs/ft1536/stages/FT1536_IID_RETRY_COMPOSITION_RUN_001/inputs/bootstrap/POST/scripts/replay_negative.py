import json,subprocess,sys
from pathlib import Path
W=Path.cwd();D=W/'tmp/rejected_wrong_external_pin';assert not D.exists()
cmd=[sys.executable,'-B','scripts/replay.py',str(D),'0'*64,'--anchor'];p=subprocess.run(cmd,capture_output=True,timeout=30)
for s,d in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/('replay_wrong_pin.'+s)).write_bytes(d)
assert p.returncode!=0 and b'manifest external pin mismatch' in p.stderr and not D.exists()
(W/'artifacts/replay_negative.json').write_text(json.dumps(dict(status='PASS_BAD_EXTERNAL_PIN_REJECTED_BEFORE_DEST',argv=cmd,exit_code=p.returncode,destination_created=False),indent=2)+'\n');print('PASS_BAD_EXTERNAL_PIN_REJECTED_BEFORE_DEST')
