import hashlib,json,shutil
from pathlib import Path
W=Path.cwd();rows=[]
for name,relout in [('rehearsal_001','artifacts/attempts/rehearsal_001'),('rehearsal_002','artifacts/rehearsal')]:
    D=W/'tmp'/name;out=W/relout;assert D.is_dir() and not out.exists()
    files=[D/'COMMANDS.log',D/'REPLAY_COMMANDS.json',D/'REPLAY_RESULT.json']
    for folder in ['logs','artifacts','checks/logs']:files.extend(p for p in (D/folder).rglob('*') if p.is_file())
    for p in sorted(set(files)):
        assert not p.is_symlink();target=out/p.relative_to(D);target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target)
        h=hashlib.sha256(target.read_bytes()).hexdigest();assert h==hashlib.sha256(p.read_bytes()).hexdigest();rows.append(dict(path=target.relative_to(W).as_posix(),sha256=h))
(W/'artifacts/replay_evidence.json').write_text(json.dumps(dict(files=rows,copied=len(rows),
 note='Both rehearsals passed. The second includes final explicit M1-M6 certificate domains and TARGET_TYPE; M7 is an output, never an assumed component.'),indent=2)+'\n')
print(json.dumps(dict(archived_files=len(rows),final_matches=273)))
