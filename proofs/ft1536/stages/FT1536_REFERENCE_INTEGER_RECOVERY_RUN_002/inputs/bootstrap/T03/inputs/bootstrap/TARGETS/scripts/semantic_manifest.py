import json,sys
from pathlib import Path
from package_scope import semantic_rows,output_files
from replaylib import sha
W=Path.cwd();mode=sys.argv[1]
if mode=='semantic':
 rows=semantic_rows(W);(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='FT1536_INITIAL_TARGETS_SEMANTIC_V1',matches=rows),indent=2)+'\n');print(json.dumps(dict(semantic_matches=len(rows))))
elif mode=='anchor':
 p=W/'artifacts/rehearsal_inputs.sha256';assert not p.exists();paths=output_files(W)
 with p.open('x') as f:
  for r in paths:f.write(sha(W/r)+'  '+r+'\n')
 out=dict(path=p.relative_to(W).as_posix(),sha256=sha(p),members=len(paths),no_cycle='Before rehearsal result/report/final OUTPUTS; excludes itself and this receipt.')
 (W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
else:raise ValueError(mode)
