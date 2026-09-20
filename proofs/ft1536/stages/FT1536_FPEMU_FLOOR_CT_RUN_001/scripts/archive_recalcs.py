import json,shutil
from pathlib import Path
from streams import seal_stream
from replaylib import sha
W=Path.cwd();target=W/'artifacts/raw_replay';target.mkdir(exist_ok=False);rows=[]
for src in sorted((W/'tmp/raw_replay').iterdir()):
 if not src.is_dir():continue
 dst=target/src.name;dst.mkdir()
 for name in ['stdout.txt','stderr.txt','receipt.json']:shutil.copyfile(src/name,dst/name)
 records={name:seal_stream(dst,name,W/'tmp/unsplit_recalcs'/src.name) for name in ['stdout.txt','stderr.txt']}
 (dst/'STREAMS.json').write_text(json.dumps(records,indent=2)+'\n')
 rows.append(dict(tag=src.name,receipt_sha256=sha(dst/'receipt.json'),streams_sha256=sha(dst/'STREAMS.json')))
assert len(rows)==42
(W/'artifacts/raw_replay_archive.json').write_text(json.dumps(rows,indent=2)+'\n');print(json.dumps(dict(archived_recalculations=len(rows))))
