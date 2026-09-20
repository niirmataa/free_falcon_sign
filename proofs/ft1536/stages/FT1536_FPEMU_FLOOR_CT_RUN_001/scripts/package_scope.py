"""Explicit archive scope, deterministic outputs, and replay seed; no cached binaries."""
import os,stat
from pathlib import Path
from replaylib import sha,member
ROOT_FILES=set('AGENTS.md TASK.md CLAIM.md REPORT.md RESULT.json PATCH.diff SEMANTICS.md EQUIVALENCE.md SOURCE_MODEL_BINDING.md REUSED_RESULTS.md ASSEMBLY_REVIEW.md IMPACT_MATRIX.md SEMANTIC_CHECKS.json MUTATION_CONTROLS.json TIMING_PLAN.json TIMING_REPORT.md RAW_FORMAT.md INPUTS.sha256 TOOLCHAIN.txt OUTPUT_SCOPE.md REPLAY.md SEMANTIC_FILES.json'.split())
ROOT_DIRS=set('inputs baseline candidate formal checks scripts logs artifacts harness vendor timing'.split())
EXCLUDED_ROOT=set('tmp bin cache COMMANDS.log executor.lock OUTPUTS.sha256'.split())
def output_files(root):
 root=Path(root);out=[]
 for p in sorted(root.iterdir()):
  if p.name in EXCLUDED_ROOT:continue
  assert not p.is_symlink(),p
  if p.is_file():assert p.name in ROOT_FILES,p;out.append(p.relative_to(root).as_posix());continue
  assert p.is_dir() and p.name in ROOT_DIRS,p
  for base,dirs,files in os.walk(p,followlinks=False):
   assert all(not (Path(base)/d).is_symlink() for d in dirs)
   for n in sorted(files):
    q=Path(base)/n;rel=q.relative_to(root)
    if p.name=='formal' and q.suffix in ['.olean','.ilean']:continue
    assert stat.S_ISREG(q.lstat().st_mode) and not q.is_symlink(),q
    assert q.suffix not in ['.o','.olean','.ilean','.pyc'] and '__pycache__' not in rel.parts,q
    assert q.stat().st_size<=32*2**20,q
    out.append(rel.as_posix())
 return sorted(out)
def semantic_paths(root):
 root=Path(root)
 fixed=['TOOLCHAIN.txt','SEMANTIC_CHECKS.json','MUTATION_CONTROLS.json','TIMING_REPORT.md','formal/EquivAudit.lean','formal/EquivTypes.lean']
 fixed+=['artifacts/'+p+'.json' for p in ['formal_audit','corpus','semantic_normal','semantic_san','lean_values','assembly_ledger','benchmark_build','source_binding','historical_recalculation','timing_recalculation','timing_summary','evidence_integrity']]
 patterns=['checks/data/*','checks/logs/*/*.stdout','checks/logs/*/*.stderr','logs/final/*','logs/toolchain_*.stdout','logs/toolchain_*.stderr','logs/lean_values.*','inputs/slices/*','artifacts/diffs/binding_*.patch','artifacts/asm/portable_001/*','artifacts/benchmark_build/*']
 paths=set(fixed)
 for pat in patterns:
  paths.update(p.relative_to(root).as_posix() for p in root.glob(pat) if p.is_file() and p.name!='commands.json')
 for p in paths:member(root,p)
 return sorted(paths)
def semantic_rows(root):return [dict(path=p,sha256=sha(member(root,p))) for p in semantic_paths(root)]
def seed_paths(root,entries,physical=False):
 root=Path(root);fixed={'TASK.md','AGENTS.md','INPUTS.sha256','PATCH.diff','candidate/CANDIDATE.sha256',
  'SEMANTICS.md','EQUIVALENCE.md','SOURCE_MODEL_BINDING.md','ASSEMBLY_REVIEW.md','IMPACT_MATRIX.md',
  'artifacts/inherited_order.json','artifacts/candidate_freeze.json','artifacts/reuse.json','inputs/provenance.json'}
 if not physical:fixed.add('TIMING_PLAN.json')
 paths=set(fixed)
 for p in entries:
  if p.startswith(('inputs/bootstrap/','inputs/context/','baseline/','candidate/source/','harness/','vendor/','scripts/')):paths.add(p)
  if p.startswith('formal/') and p.endswith('.lean') and Path(p).name not in ['EquivAudit.lean','EquivTypes.lean']:paths.add(p)
  if p.startswith('checks/') and p.endswith('.c'):paths.add(p)
  if not physical and p.startswith('timing/'):paths.add(p)
 assert paths<=set(entries),paths-set(entries)
 return sorted(paths)
