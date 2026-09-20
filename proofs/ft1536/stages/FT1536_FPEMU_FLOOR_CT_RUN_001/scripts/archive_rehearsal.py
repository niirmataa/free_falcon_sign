import json,shutil,sys
from pathlib import Path
from replaylib import sha,member
from streams import seal_stream
W=Path.cwd();D=Path(sys.argv[1]);assert D.is_relative_to(W/'tmp')
r=json.loads((D/'REPLAY_RESULT.json').read_text());assert r['status']=='FRESH_REPLAY_PASS'
expected=json.loads((W/'SEMANTIC_FILES.json').read_text())['matches'];assert r['matches']==expected
for x in expected:assert sha(member(W,x['path']))==sha(member(D,x['path']))==x['sha256']
target=W/'artifacts/rehearsal';target.mkdir(exist_ok=False);copies=[]
paths=['COMMANDS.log','REPLAY_RESULT.json','artifacts/kernel.jsonl','artifacts/final_kernel_receipts.json','artifacts/lean_values_command.json','artifacts/toolchain_commands.json',
 'artifacts/asm/portable_001/commands.json','artifacts/benchmark_build/commands.json','checks/logs/normal/commands.json','checks/logs/san/commands.json']
paths+=sorted(p.relative_to(D).as_posix() for folder in ['logs','artifacts/replay_jobs','tmp/raw_replay'] for p in (D/folder).rglob('*') if p.is_file())
for p in paths:
 src=member(D,p);dst=target/p;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst)
 copies.append(dict(original=p,archive=dst.relative_to(W).as_posix(),sha256=sha(dst),bytes=dst.stat().st_size))
 for_limit=dst.stat().st_size
 if for_limit>32*2**20:
  rec=seal_stream(dst.parent,dst.name,W/'tmp/rehearsal_unsplit'/Path(p).parent)
  (dst.parent/(dst.name+'.STREAM.json')).write_text(json.dumps(rec,indent=2)+'\n')
with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(r,f,indent=2);f.write('\n')
(W/'artifacts/rehearsal_archive.json').write_text(json.dumps(dict(status='PASS',copies=copies,semantic_matches=len(expected)),indent=2)+'\n')
print(json.dumps(dict(status='PASS',semantic_matches=len(expected),full_receipt_streams=len(copies))))
