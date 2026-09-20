import os,stat
from pathlib import Path
from replaylib import sha,member
ROOT_FILES=set('AGENTS.md TASK.md REPORT.md RESULT.json CLAIM.md COMPOSITION.md SOURCE_TRANSPORT.md SOURCE_MODEL_BINDING.md MEMORY_LAYOUT.md LEAF_MAP.json NEXT_INTERFACE.md OBLIGATIONS.json REUSED_RESULTS.md RAW_PREFIX_CERTIFICATE.json INPUTS.sha256 TOOLCHAIN.txt OUTPUT_SCOPE.md REPLAY.md SEMANTIC_FILES.json'.split())
ROOT_DIRS=set('inputs source formal checks scripts logs artifacts'.split());EXCLUDED=set('tmp bin cache COMMANDS.log executor.lock OUTPUTS.sha256'.split())
def output_files(root):
 root=Path(root);out=[]
 for p in sorted(root.iterdir()):
  if p.name in EXCLUDED:continue
  assert not p.is_symlink(),p
  if p.is_file():assert p.name in ROOT_FILES and p.stat().st_size<=32*2**20,p;out.append(p.name);continue
  assert p.is_dir() and p.name in ROOT_DIRS,p
  for base,dirs,files in os.walk(p,followlinks=False):
   assert all(not (Path(base)/d).is_symlink() for d in dirs)
   for n in sorted(files):
    q=Path(base)/n;rel=q.relative_to(root)
    if p.name=='formal' and q.suffix in ['.olean','.ilean']:continue
    assert stat.S_ISREG(q.lstat().st_mode) and not q.is_symlink() and '__pycache__' not in rel.parts,q
    assert q.suffix not in ['.o','.olean','.ilean','.pyc'] and q.stat().st_size<=32*2**20,q
    out.append(rel.as_posix())
 return sorted(out)
def semantic_paths(root):
 root=Path(root);paths=set(['TOOLCHAIN.txt','LEAF_MAP.json','RAW_PREFIX_CERTIFICATE.json','OBLIGATIONS.json','formal/RawAudit.lean','formal/RawTypes.lean',
  'inputs/previous_fpr-emulated.h','checks/raw_prefix.inc','checks/transport_unit.c','artifacts/diffs/raw_prefix.patch','artifacts/diffs/tower_certificate.patch'])
 paths.update('artifacts/'+n+'.json' for n in ['source_transport','source_checks','tower_numeric_certificate','composition_certificate','formal_audit','kernel_order','fixtures','controls_normal','controls_san','mutations'])
 for pat in ['checks/data/*','checks/mutations/*','checks/logs/*/*.stdout','checks/logs/*/*.stderr','logs/final/*','logs/toolchain_*.stdout','logs/toolchain_*.stderr','artifacts/preprocessed/*.i','artifacts/preprocessed/*.stderr','artifacts/diffs/binding_*.patch']:
  paths.update(p.relative_to(root).as_posix() for p in root.glob(pat) if p.is_file())
 for p in paths:member(root,p)
 return sorted(paths)
def semantic_rows(root):return [dict(path=p,sha256=sha(member(root,p))) for p in semantic_paths(root)]
def seed_paths(entries):
 fixed=set('AGENTS.md TASK.md INPUTS.sha256 CLAIM.md COMPOSITION.md SOURCE_TRANSPORT.md SOURCE_MODEL_BINDING.md MEMORY_LAYOUT.md NEXT_INTERFACE.md REUSED_RESULTS.md inputs/provenance.json artifacts/reuse.json checks/raw.c'.split())
 paths=set(fixed)
 for p in entries:
  if p.startswith(('inputs/bootstrap/','inputs/context/','source/','scripts/')):paths.add(p)
  if p.startswith('formal/') and p.endswith('.lean') and Path(p).name not in ['RawAudit.lean','RawTypes.lean']:paths.add(p)
 assert paths<=set(entries),paths-set(entries)
 return sorted(paths)
