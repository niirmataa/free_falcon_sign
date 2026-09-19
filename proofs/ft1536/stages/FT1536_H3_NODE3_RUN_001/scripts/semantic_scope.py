import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();a=json.loads((W/'artifacts/formal_audit.json').read_text());files=set(a['sources_sha256'])
for folder in ['source','logs/final','inputs/slices']:
 for p in (W/folder).rglob('*'):
  assert not p.is_symlink()
  if p.is_file():files.add(p.relative_to(W).as_posix())
files.update(['ANALYTIC_PROOF.md','ROOT_CONSUMPTION.md','NODE3_FRAME.md','CLAIM.md','NEXT_INTERFACE.md','SOURCE_MODEL_BINDING.md','REUSED_RESULTS.md',
 'NODE3_CERTIFICATE.json','BOUND_LEDGER.json','BOUND_LEDGER.md','OBLIGATIONS.json','TOOLCHAIN.txt'])
for p in (W/'checks').glob('*'):
 if p.is_file():files.add(p.relative_to(W).as_posix())
files.update('artifacts/'+n+'.json' for n in ['formal_audit','inherited_order','controls_normal','controls_san','numeric_certificate','oracle','model_values','source_binding'])
with (W/'artifacts/semantic_manifest.sha256').open('x') as f:
 for rel in sorted(files):f.write(sha(W/rel)+'  '+rel+'\n')
out=dict(kind='PRE_FREEZE_SEMANTIC_ANCHOR',files=len(files),sha256=sha(W/'artifacts/semantic_manifest.sha256'),
 note='Proof documents copied byte-identically; all consumed Lean and new exact certificates/native checks rebuilt. Text replay is not kernel certification of the analytical argument.')
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
