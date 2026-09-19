from replaylib import member
TOP=('AGENTS.md','ANALYTIC_PROOF.md','ROOT_CONSUMPTION.md','NODE3_FRAME.md','REPORT.md','RESULT.json','CLAIM.md',
 'NODE3_CERTIFICATE.json','BOUND_LEDGER.json','BOUND_LEDGER.md','OBLIGATIONS.json','NEXT_INTERFACE.md',
 'SOURCE_MODEL_BINDING.md','REUSED_RESULTS.md','INPUTS.sha256','TOOLCHAIN.txt','OUTPUT_SCOPE.md','REPLAY.md')
def selected_files(root):
 paths=set(TOP)
 for rel in TOP:member(root,rel)
 for folder in ['source','inputs','formal','scripts','checks','artifacts','logs']:
  base=root/folder
  if base.is_symlink() or not base.is_dir():raise ValueError('invalid scope directory '+folder)
  for p in base.rglob('*'):
   if p.is_symlink():raise ValueError('symlink in scope '+str(p))
   if p.is_dir():continue
   if not p.is_file():raise ValueError('nonregular member '+str(p))
   if p.suffix not in {'.olean','.ilean','.pyc'}:paths.add(p.relative_to(root).as_posix())
 return sorted(paths)
