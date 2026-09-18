"""Freeze the pre-freeze rehearsal anchor; do not substitute it for OUTPUTS."""
import hashlib,json
from pathlib import Path
W=Path.cwd();audit=json.loads((W/'artifacts/formal_audit.json').read_text())
files=set(audit['source_sha256'])
for directory in ['source','logs/final']:
    for p in (W/directory).rglob('*'):
        assert not p.is_symlink()
        if p.is_file():files.add(p.relative_to(W).as_posix())
files.update(['checks/pipeline.c','checks/cases.json','checks/case0.txt','checks/case1.txt','checks/c0.txt','checks/c1.txt','checks/lean_values.txt',
 'artifacts/formal_audit.json','artifacts/controls.json','artifacts/leaf_binding.json','TOOLCHAIN.txt'])
with (W/'artifacts/semantic_manifest.sha256').open('x') as f:
    for rel in sorted(files):f.write(hashlib.sha256((W/rel).read_bytes()).hexdigest()+'  '+rel+'\n')
prefix=(W/'COMMANDS.log').read_bytes()
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(dict(kind='PRE_FREEZE_SEMANTIC_ANCHOR',files=len(files),
    sha256=hashlib.sha256((W/'artifacts/semantic_manifest.sha256').read_bytes()).hexdigest(),
    command_prefix_bytes=len(prefix),command_prefix_sha256=hashlib.sha256(prefix).hexdigest()),indent=2)+'\n')
print((W/'artifacts/rehearsal_anchor.json').read_text())
