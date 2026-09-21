import json
from pathlib import Path
from package_scope import ROOT_FILES,output_files
from replaylib import sha
from verify import verify
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists() and all((W/p).is_file() for p in ROOT_FILES)
matches=json.loads((W/'SEMANTIC_FILES.json').read_text())['matches'];r=json.loads((W/'artifacts/fresh_replay.json').read_text());assert r['status']=='FRESH_REPLAY_PASS' and r['matches']==matches
for x in matches:assert sha(W/x['path'])==x['sha256']
data=(W/'COMMANDS.log').read_bytes();p=W/'artifacts/COMMANDS.frozen.log'
with p.open('xb') as f:f.write(data)
prefix=dict(path=p.relative_to(W).as_posix(),sha256=sha(p),bytes=len(data),records=len(data.splitlines()),scope='Completed exact prefix before seal; finalization/post-freeze receipts only in new tmp destinations')
with (W/'artifacts/commands_prefix.json').open('x') as f:json.dump(prefix,f,indent=2);f.write('\n')
paths=output_files(W)
with (W/'OUTPUTS.sha256').open('x') as f:
 for name in paths:f.write(sha(W/name)+'  '+name+'\n')
print(json.dumps(verify(W,sha(W/'OUTPUTS.sha256')),indent=2))
