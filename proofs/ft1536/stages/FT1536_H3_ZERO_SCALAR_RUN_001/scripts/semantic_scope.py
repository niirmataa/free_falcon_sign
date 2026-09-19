import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();a=json.loads((W/'artifacts/formal_audit.json').read_text());files=set(a['sources_sha256'])
for folder in ['source','logs/final','inputs/slices']:
 for p in (W/folder).rglob('*'):
  assert not p.is_symlink()
  if p.is_file():files.add(p.relative_to(W).as_posix())
files.update(['ANALYTIC_PROOF.md','M0_COMPATIBILITY.md','ERROR_LEDGER.json','ERROR_LEDGER.md','OBLIGATIONS.json','TOOLCHAIN.txt',
 'checks/scalar.c','checks/scalars.txt','checks/model_jobs.txt','checks/model_values.txt',
 'artifacts/formal_audit.json','artifacts/controls_normal.json','artifacts/controls_san.json','artifacts/phase_controls.json','artifacts/lean_value_checks.json','artifacts/error_certificate.json','artifacts/source_binding.json'])
with (W/'artifacts/semantic_manifest.sha256').open('x') as f:
 for rel in sorted(files):f.write(sha(W/rel)+'  '+rel+'\n')
out=dict(kind='PRE_FREEZE_SEMANTIC_ANCHOR',files=len(files),sha256=sha(W/'artifacts/semantic_manifest.sha256'),
 note='Analytical proof document copied byte-identically; rank/exponent certificate, models, kernel proofs and native checks actually rerun. No global reachability/law claim.')
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
