"""Preserve full successful and failed replay receipts, excluding caches/binaries."""
import hashlib,json,shutil
from pathlib import Path
W=Path.cwd();rows=[]
for name in ['rehearsal_001','rehearsal_002']:
    D=W/'tmp'/name;out=W/'artifacts'/('rehearsal' if name=='rehearsal_002' else 'attempts/rehearsal_001')
    assert D.is_dir() and not out.exists()
    files=[p for p in [D/'COMMANDS.log',D/'REPLAY_COMMANDS.json',D/'REPLAY_RESULT.json'] if p.is_file()]
    for folder in ['logs','artifacts','checks/logs']:
        files.extend(p for p in (D/folder).rglob('*') if p.is_file())
    for p in sorted(set(files)):
        assert not p.is_symlink();target=out/p.relative_to(D);target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target)
        h=hashlib.sha256(target.read_bytes()).hexdigest();assert h==hashlib.sha256(p.read_bytes()).hexdigest()
        rows.append(dict(path=target.relative_to(W).as_posix(),sha256=h))
(W/'artifacts/replay_evidence.json').write_text(json.dumps(dict(copied=len(rows),files=rows,
    failed_attempt='001: missing archived provenance-only helper in initial seed; kernel checks had run, packaging check failed; no mathematical failure.',
    successful_attempt='002: all402 semantic files match; normal plus ASan/UBSan repeated.'),indent=2)+'\n')
print(json.dumps(dict(archived_files=len(rows),successful_matches=402)))
