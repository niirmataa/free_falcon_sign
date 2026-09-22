import json,shutil,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'tmp'/sys.argv[1];A=W/'artifacts/rehearsal';assert D.is_dir() and not A.exists();result=json.loads((D/'REPLAY_RESULT.json').read_text());assert result['status']=='FRESH_REPLAY_PASS' and result['matches'] and result['matched']==result['expected_files']
paths=[D/p for p in ['COMMANDS.log','REPLAY_COMMANDS.json','REPLAY_RESULT.json']]+[p for p in (D/'logs').rglob('*') if p.is_file()]
paths +=[D/'artifacts'/p for p in ['kernel.jsonl','final_kernel_receipts.json','build_normal.json','build_sanitized.json','toolchain_commands.json','native_receipts_normal.json','native_receipts_sanitized.json']];rows=[]
for p in sorted(paths):
 r=p.relative_to(D).as_posix();dst=A/r;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst);rows.append(dict(path=dst.relative_to(W).as_posix(),sha256=sha(dst)))
shutil.copyfile(D/'REPLAY_RESULT.json',W/'artifacts/fresh_replay.json')
(W/'artifacts/rehearsal_evidence.json').write_text(json.dumps(dict(status='PASS_ARCHIVED_FRESH_REHEARSAL',files=rows,matched=result['matched'],expected=result['expected_files'],external_anchor_sha256=result['external_manifest_sha256'],sealed_receipt_sha256=sha(W/'artifacts/fresh_replay.json')),indent=2)+'\n');print('ARCHIVED_FRESH_REPLAY',len(rows),'matches',result['matched'])
