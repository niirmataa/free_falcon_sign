"""Last writer to the package; controller logs go only to its new tmp directory."""
import json
from pathlib import Path
from package_scope import output_files,ROOT_FILES
from replaylib import sha
from verify import verify
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
assert all((W/p).is_file() for p in ROOT_FILES)
matches=json.loads((W/'SEMANTIC_FILES.json').read_text())['matches'];r=json.loads((W/'artifacts/fresh_replay.json').read_text())
assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==matches
for x in matches:assert sha(W/x['path'])==x['sha256']
data=(W/'COMMANDS.log').read_bytes();path=W/'artifacts/COMMANDS.frozen.log'
with path.open('xb') as f:f.write(data)
prefix=dict(path=path.relative_to(W).as_posix(),sha256=sha(path),bytes=len(data),records=len(data.splitlines()),
 scope='Exact completed-command prefix before seal; finalization/post-freeze controller receipts live only under new tmp destinations.')
with (W/'artifacts/commands_prefix.json').open('x') as f:json.dump(prefix,f,indent=2);f.write('\n')
paths=output_files(W)
with (W/'OUTPUTS.sha256').open('x') as f:
 for p in paths:f.write(sha(W/p)+'  '+p+'\n')
print(json.dumps(verify(W,sha(W/'OUTPUTS.sha256')),indent=2))
