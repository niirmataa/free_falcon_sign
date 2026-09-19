import json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'tmp/rehearsal_001';O=W/'artifacts/rehearsal';assert D.is_dir() and not O.exists()
receipt=json.loads((W/'artifacts/fresh_replay.json').read_text());files=[D/'COMMANDS.log',D/'REPLAY_COMMANDS.json',D/'REPLAY_RESULT.json']
for folder in ['logs','artifacts','checks/logs']:files.extend(p for p in (D/folder).rglob('*') if p.is_file())
rows=[]
for p in sorted(set(files)):
 assert not p.is_symlink();t=O/p.relative_to(D);t.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,t);assert sha(p)==sha(t)
 rows.append(dict(path=t.relative_to(W).as_posix(),sha256=sha(t)))
(W/'artifacts/replay_evidence.json').write_text(json.dumps(dict(copied=len(rows),files=rows,semantic_matches=len(receipt['matches']),note='Full verbatim rehearsal streams/receipts; analytical proof remains separately reviewed.'),indent=2)+'\n')
print(json.dumps(dict(archived_files=len(rows),semantic_matches=len(receipt['matches']))))
