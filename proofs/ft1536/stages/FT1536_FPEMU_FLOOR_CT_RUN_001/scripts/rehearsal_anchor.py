import json
from pathlib import Path
from package_scope import output_files
from replaylib import sha
W=Path.cwd();dest=W/'artifacts/rehearsal_inputs.sha256';assert not dest.exists()
rows=output_files(W)
with dest.open('x') as f:
 for p in rows:f.write(sha(W/p)+'  '+p+'\n')
out=dict(schema='FT1536_PREFREEZE_REHEARSAL_ANCHOR_V1',path=dest.relative_to(W).as_posix(),sha256=sha(dest),members=len(rows),
 no_cycle='Anchor predates rehearsal result/report/final OUTPUTS; does not include itself or this receipt.')
(W/'artifacts/rehearsal_anchor.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
