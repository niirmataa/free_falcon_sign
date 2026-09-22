import fcntl,json
from pathlib import Path
from replaylib import sha
from scope import ANCHOR,members
W=Path.cwd();A=W/ANCHOR;assert not A.exists() and not (W/'OUTPUTS.sha256').exists()
lock=(W/'executor.lock').open('a');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
data=(W/'COMMANDS.log').read_bytes();assert data.endswith(b'\n');records=[json.loads(s) for s in data.splitlines()]
(W/'artifacts/COMMANDS.rehearsal.log').write_bytes(data)
(W/'artifacts/rehearsal_commands_receipt.json').write_text(json.dumps(dict(records=len(records),bytes=len(data),sha256=sha(W/'artifacts/COMMANDS.rehearsal.log'),completed_prefix=True),indent=2)+'\n')
paths=members(W,anchor=True);A.write_text(''.join(sha(W/p)+'  '+p+'\n' for p in paths));print('ANCHOR',len(paths),sha(A))
