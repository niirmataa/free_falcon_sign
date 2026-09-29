from pathlib import Path
def members(root):
 root=Path(root);out=[]
 for p in sorted(root.rglob('*')):
  r=p.relative_to(root)
  if r.parts[0] in ['tmp','bin','cache'] or '__pycache__' in r.parts:continue
  if p.is_symlink():raise ValueError('symlink '+str(r))
  if not p.is_file():continue
  if str(r) in ['COMMANDS.log','executor.lock','OUTPUTS.sha256'] or p.suffix in ['.olean','.ilean','.pyc']:continue
  if p.stat().st_size>32*1024**2:raise ValueError('oversize '+str(r))
  out.append(r.as_posix())
 return out
