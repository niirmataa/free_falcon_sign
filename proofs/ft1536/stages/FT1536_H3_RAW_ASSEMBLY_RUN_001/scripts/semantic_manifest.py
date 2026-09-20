import json,sys
from pathlib import Path
from package_scope import semantic_rows,output_files
from replaylib import sha
W=Path.cwd();mode=sys.argv[1]
if mode=='semantic':
 rows=semantic_rows(W);(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='FT1536_RAW_ASSEMBLY_SEMANTIC_V1',matches=rows),indent=2)+'\n');print(json.dumps(dict(semantic_matches=len(rows))))
elif mode=='anchor':
 dest=W/'artifacts/rehearsal_inputs.sha256';assert not dest.exists();paths=output_files(W)
 with dest.open('x') as f:
  for p in paths:f.write(sha(W/p)+'  '+p+'\n')
 out=dict(path='artifacts/rehearsal_inputs.sha256',sha256=sha(dest),members=len(paths),no_cycle='Snapshot before rehearsal result/report/final OUTPUTS; excludes itself and this receipt.')
 (W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
else:raise ValueError(mode)
