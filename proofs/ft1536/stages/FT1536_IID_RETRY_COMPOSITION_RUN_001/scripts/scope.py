"""Explicit immutable package scope, distinct from generated replay semantics."""
import os
from pathlib import Path
EXCLUDED_TOP={'tmp','runtime','cache','bin','executor.lock','COMMANDS.log','OUTPUTS.sha256'}
ANCHOR='artifacts/rehearsal_anchor.sha256'
def members(root,anchor=False):
 root=Path(root);out=[]
 for here,dirs,files in os.walk(root,followlinks=False):
  h=Path(here);rel=h.relative_to(root)
  dirs[:]=sorted(d for d in dirs if d!='__pycache__' and not (h==root and d in EXCLUDED_TOP))
  for d in dirs:assert not (h/d).is_symlink(),h/d
  for f in sorted(files):
   p=h/f;r=p.relative_to(root).as_posix()
   if h==root and f in EXCLUDED_TOP:continue
   if rel.parts and rel.parts[0]=='formal' and p.suffix in ['.olean','.ilean','.trace']:continue
   if anchor and r==ANCHOR:continue
   assert not p.is_symlink() and p.is_file() and p.stat().st_size<=32*1024**2,r
   out.append(r)
 return sorted(out)
def seed_file(r):
 if r.startswith(('inputs/','source/','scripts/')):return True
 if r.startswith('formal/') and r.endswith('.lean'):return r not in ['formal/RetryAudit.lean','formal/RetryTypes.lean']
 if r in ['checks/retry.c','checks/reset.c','artifacts/reuse.json','INPUTS.sha256']:return True
 return '/' not in r and r.endswith('.md') and r!='REPORT.md'
