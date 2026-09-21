import json
from pathlib import Path
from replaylib import sha
from scope import members
W=Path.cwd();A=W/'artifacts/rehearsal_anchor.sha256';assert not A.exists()
data=(W/'COMMANDS.log').read_bytes();assert data.endswith(b'\n');rows=[json.loads(s) for s in data.splitlines()]
(W/'artifacts/COMMANDS.frozen.log').write_bytes(data)
(W/'artifacts/commands_frozen_receipt.json').write_text(json.dumps(dict(bytes=len(data),records=len(rows),sha256=sha(W/'artifacts/COMMANDS.frozen.log'),meaning='Completed prefix before rehearsal anchor; dynamic tail and fresh replay receipts are separate.'),indent=2)+'\n')
A.write_text(''.join(sha(W/r)+'  '+r+'\n' for r in members(W)))
print(json.dumps(dict(anchor=A.name,sha256=sha(A),members=len(A.read_text().splitlines())),indent=2))
