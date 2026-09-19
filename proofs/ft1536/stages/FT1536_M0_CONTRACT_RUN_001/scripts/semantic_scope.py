import hashlib,json
from pathlib import Path
W=Path.cwd();a=json.loads((W/'artifacts/formal_audit.json').read_text());files=set(a['sources_sha256'])
for folder in ['source','logs/final','checks/variants','inputs/slices']:
    for p in (W/folder).rglob('*'):
        assert not p.is_symlink()
        if p.is_file():files.add(p.relative_to(W).as_posix())
files.update(p.relative_to(W).as_posix() for p in (W/'checks').glob('*_main.c'))
specs=['DECISIONS.md','GAME.md','RESOURCE_MODEL.md','H3_INTERFACE.md','TARGET_TYPE.md','CAPACITY.md','SOURCE_MODEL_BINDING.md','REUSED_RESULTS.md']
files.update(specs+['PROFILE.json','HOP_LEDGER.json','HOP_LEDGER.md','checks/capacity.c','checks/native_normal.json','checks/native_san.json',
  'artifacts/formal_audit.json','artifacts/compiler_flags.json','artifacts/control_binding.json','artifacts/capacity_checks.json',
  'artifacts/contract_checks.json','artifacts/source_binding.json','TOOLCHAIN.txt'])
with (W/'artifacts/semantic_manifest.sha256').open('x') as f:
    for rel in sorted(files):f.write(hashlib.sha256((W/rel).read_bytes()).hexdigest()+'  '+rel+'\n')
prefix=(W/'COMMANDS.log').read_bytes();out=dict(kind='PRE_FREEZE_SEMANTIC_ANCHOR',files=len(files),copied_specifications=specs,
    sha256=hashlib.sha256((W/'artifacts/semantic_manifest.sha256').read_bytes()).hexdigest(),
    command_prefix_bytes=len(prefix),command_prefix_sha256=hashlib.sha256(prefix).hexdigest(),
    note='Spec/document byte equality is not a proof of their future security premises.')
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
