import json,shutil,sys
from pathlib import Path
from replaylib import sha,member
W=Path.cwd();D=Path(sys.argv[1]);assert D.is_relative_to(W/'tmp');r=json.loads((D/'REPLAY_RESULT.json').read_text());assert r['status']=='FRESH_REPLAY_PASS'
expected=json.loads((W/'SEMANTIC_FILES.json').read_text())['matches'];assert r['matches']==expected
for x in expected:assert sha(member(W,x['path']))==sha(member(D,x['path']))==x['sha256']
out=W/'artifacts/rehearsal';out.mkdir(exist_ok=False);copies=[]
paths=['COMMANDS.log','REPLAY_RESULT.json','artifacts/kernel.jsonl','artifacts/final_kernel_receipts.json','artifacts/toolchain_commands.json','artifacts/preprocessed/commands.json','checks/logs/normal/commands.json','checks/logs/san/commands.json','checks/bank_logs/normal/commands.json','checks/bank_logs/san/commands.json']
paths+=sorted(p.relative_to(D).as_posix() for d in ['logs','artifacts/replay_jobs'] for p in (D/d).rglob('*') if p.is_file())
for name in paths:
 dst=out/name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(member(D,name),dst);assert dst.stat().st_size<=32*2**20;copies.append(dict(path=dst.relative_to(W).as_posix(),sha256=sha(dst)))
with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(r,f,indent=2);f.write('\n')
(W/'artifacts/rehearsal_archive.json').write_text(json.dumps(dict(status='PASS',semantic_matches=len(expected),copies=copies),indent=2)+'\n');print(json.dumps(dict(status='PASS',semantic_matches=len(expected),full_receipt_streams=len(copies))))
