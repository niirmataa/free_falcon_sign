import hashlib,json
from pathlib import Path
W=Path.cwd();audit=json.loads((W/'artifacts/formal_audit.json').read_text());files=set(audit['sources_sha256'])
for folder in ['source','logs/final','checks/fixtures','checks/variants']:
    for p in (W/folder).rglob('*'):
        assert not p.is_symlink()
        if p.is_file():files.add(p.relative_to(W).as_posix())
files.update(['checks/harness.c','checks/cases.json','checks/model_jobs.txt','checks/model_values.txt','checks/native_normal.json','checks/native_san.json',
 'artifacts/formal_audit.json','artifacts/controls.json','artifacts/native_binding.json','TOOLCHAIN.txt'])
files.update(p.relative_to(W).as_posix() for p in (W/'checks').glob('*_main.c'))
with (W/'artifacts/semantic_manifest.sha256').open('x') as f:
    for rel in sorted(files):f.write(hashlib.sha256((W/rel).read_bytes()).hexdigest()+'  '+rel+'\n')
prefix=(W/'COMMANDS.log').read_bytes()
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(dict(kind='PRE_FREEZE_SEMANTIC_ANCHOR',files=len(files),
    sha256=hashlib.sha256((W/'artifacts/semantic_manifest.sha256').read_bytes()).hexdigest(),
    command_prefix_bytes=len(prefix),command_prefix_sha256=hashlib.sha256(prefix).hexdigest()),indent=2)+'\n')
print((W/'artifacts/rehearsal_anchor.json').read_text())
