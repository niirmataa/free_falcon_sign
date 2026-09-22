"""Final W-only checkpoint; run after report job has finished, not inside run.py."""
import fcntl,json
from pathlib import Path
from replaylib import sha,verify_manifest
from scope import members
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
with (W/'executor.lock').open('a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 C=json.loads((W/'IID_RETRY_CERTIFICATE.json').read_text());R=json.loads((W/'RESULT.json').read_text())
 assert C['status']==R['status']=='IID_RETRY_COMPOSITION_PROVED_FOR_PINNED_IID_BUFFER_MODEL'
 assert R['certificate_sha256']==sha(W/'IID_RETRY_CERTIFICATE.json')
 F=json.loads((W/'artifacts/fresh_replay.json').read_text());assert F['status']=='FRESH_REPLAY_PASS' and F['matched']==F['expected_files']
 E=json.loads((W/'SEMANTIC_FILES.json').read_text());assert F['matches']==E['files']
 for r in E['files']:assert sha(W/r['path'])==r['sha256']
 for p,h in C['proof_files'].items():assert sha(W/p)==h
 verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256',C['bootstrap_sha256'])
 data=(W/'COMMANDS.log').read_bytes();assert data.endswith(b'\n');commands=[json.loads(s) for s in data.splitlines()]
 assert commands[-1]['exit_code']==0 and not commands[-1]['timeout']
 (W/'artifacts/COMMANDS.frozen.log').write_bytes(data)
 (W/'artifacts/freeze.json').write_text(json.dumps(dict(status='FROZEN_AFTER_SUCCESSFUL_REHEARSAL',report_sha256=sha(W/'REPORT.md'),commands_records=len(commands),commands_bytes=len(data),commands_sha256=sha(W/'artifacts/COMMANDS.frozen.log'),semantic_files=len(E['files']),source_changed=False,production_source_changed=False,owner_accepted=False,handoff_channel='current TUI chat only; relay cancelled'),indent=2)+'\n')
 paths=members(W);(W/'OUTPUTS.sha256').write_text(''.join(sha(W/p)+'  '+p+'\n' for p in paths))
 pin=sha(W/'OUTPUTS.sha256');assert set(verify_manifest(W,'OUTPUTS.sha256',pin))==set(paths)
 print(json.dumps(dict(status='FROZEN',members=len(paths),member_bytes=sum((W/p).stat().st_size for p in paths),report_sha256=sha(W/'REPORT.md'),outputs_sha256=pin,semantic_files=len(E['files'])),indent=2))
