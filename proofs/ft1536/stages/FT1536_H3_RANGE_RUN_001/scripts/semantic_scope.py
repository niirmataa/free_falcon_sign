import hashlib,json
from pathlib import Path
W=Path.cwd();audit=json.loads((W/'artifacts/formal_audit.json').read_text());files=set(audit['sources_sha256'])
for folder in ['source','logs/final','inputs/slices']:
 for p in (W/folder).rglob('*'):
  assert not p.is_symlink()
  if p.is_file():files.add(p.relative_to(W).as_posix())
for name in ['probe.c','order.c','boundaries.c','leaf_gap.c','boundaries.txt']:files.add('checks/'+name)
for name in ['tables_C.txt','cdf_certificate.json','probes_normal.json','probes_san.json','fpr_analysis.json',
  'order_normal.json','order_san.json','order_mutations.json','boundaries_normal.json','boundaries_san.json',
  'leaf_gap_normal.json','leaf_gap_san.json','algebra.json','source_bindings.json','formal_audit.json']:
 files.add('artifacts/'+name)
for n in ['baseline','minusL','fault','terminal_negzero','noop']:files.add('artifacts/order_'+n+'_trace.json')
files.update(['REACHABILITY.md','BOUND_LEDGER.json','BOUND_LEDGER.md','OBLIGATIONS.json','TOOLCHAIN.txt'])
with (W/'artifacts/semantic_manifest.sha256').open('x') as f:
 for rel in sorted(files):f.write(hashlib.sha256((W/rel).read_bytes()).hexdigest()+'  '+rel+'\n')
prefix=(W/'COMMANDS.log').read_bytes();out=dict(files=len(files),kind='PRE_FREEZE_SEMANTIC_ANCHOR',sha256=hashlib.sha256((W/'artifacts/semantic_manifest.sha256').read_bytes()).hexdigest(),
 command_prefix_bytes=len(prefix),command_prefix_sha256=hashlib.sha256(prefix).hexdigest(),scope='Reproduces new partial proofs and controls, not full required-domain reachability.')
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
