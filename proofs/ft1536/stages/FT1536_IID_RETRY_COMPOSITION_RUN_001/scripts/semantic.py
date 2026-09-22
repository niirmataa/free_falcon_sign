import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();paths=set(['TOOLCHAIN.txt','SCHEDULER.json','STOPPED_COMPOSITION.json','RESOURCE_BOUND.json','ERROR_LEDGER.json','OBLIGATIONS.json','IID_RETRY_CERTIFICATE.json','artifacts/input_validation.json','artifacts/source_binding.json','artifacts/kernel_order.json','artifacts/formal_audit.json','artifacts/fixtures.json','artifacts/target_words.json','artifacts/probability_controls.json','artifacts/mutations.json','artifacts/sage_qq.json','artifacts/reset.expected','artifacts/reset_normal.json','artifacts/reset_sanitized.json','formal/RetryAudit.lean','formal/RetryTypes.lean'])
paths.add('artifacts/diffs/run.patch')
for pat in ['artifacts/fixtures/*.input','artifacts/fixtures/*.expected','artifacts/models/*.json','artifacts/native_normal_*.json','artifacts/native_sanitized_*.json','artifacts/mutations/*.patch','artifacts/diffs/*.patch','logs/native_*.stdout','logs/native_*.stderr','logs/reset_*.stdout','logs/reset_*.stderr','logs/final/*','checks/*.inc','checks/mutations/**/*.c','checks/mutations/**/*.inc']:
 paths.update(p.relative_to(W).as_posix() for p in W.glob(pat))
# run.patch is initial-run provenance; regenerate its exact diff as well.
import difflib
old=W/'inputs/bootstrap/H6P/scripts/run.py';new=W/'scripts/run.py'
(W/'artifacts/diffs/run.patch').write_text(''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile='inputs/bootstrap/H6P/scripts/run.py',tofile='scripts/run.py')))
rows=[dict(path=p,sha256=sha(W/p)) for p in sorted(paths)]
(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='IID_RETRY_SEMANTIC_FILES_V1',game='G_retry_IID',region='post-H2P3327-3421 cap16 and STATIC codec',event='WholeRegionBad across reached/completed BOTH-vector pre-narrow outputs',count=len(rows),files=rows),indent=2)+'\n');print('SEMANTIC_FILES',len(rows))
