"""Preserve complete fresh-replay receipts outside excluded tmp/cache trees."""
import hashlib,json,shutil
from pathlib import Path
W=Path.cwd();D=W/'tmp/rehearsal_001';out=W/'artifacts/rehearsal';assert D.is_dir() and not out.exists()
files=[D/'COMMANDS.log',D/'REPLAY_COMMANDS.json',D/'REPLAY_RESULT.json']
for folder in ['logs','artifacts','checks/logs']:
    files.extend(p for p in (D/folder).rglob('*') if p.is_file())
rows=[]
for p in sorted(set(files)):
    assert not p.is_symlink();rel=p.relative_to(D);target=out/rel;target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(p,target);h=hashlib.sha256(target.read_bytes()).hexdigest()
    assert h==hashlib.sha256(p.read_bytes()).hexdigest();rows.append(dict(path=target.relative_to(W).as_posix(),sha256=h))
(W/'artifacts/rehearsal_evidence.json').write_text(json.dumps(dict(copied=len(rows),files=rows,
    note='Verbatim fresh command streams and receipts; timings/cwd differ from primary run and are not semantic comparisons.'),indent=2)+'\n')
print(json.dumps(dict(copied=len(rows),fresh_matches=len(json.loads((W/'artifacts/fresh_replay.json').read_text())['matches']))))
