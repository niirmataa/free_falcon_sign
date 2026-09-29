import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();paths=set(['TOOLCHAIN.txt','artifacts/numeric_certificate.json','artifacts/source_binding.json','artifacts/fixtures.json','artifacts/formal_audit.json','artifacts/kernel_order.json','artifacts/mutations.json','artifacts/inverse_oracle.json','formal/PostAudit.lean','formal/PostTypes.lean','PRECAST_DISPOSITION.json','ERROR_LEDGER.json','ERROR_LEDGER.md','REUSED_RESULTS.md','OBLIGATIONS.json','SOURCE_POSTPROCESSING_CERTIFICATE.json'])
for pat in ['artifacts/fixtures/*.input','artifacts/models/*.json','artifacts/mutations/*.json','artifacts/native_normal_*.json','artifacts/native_sanitized_*.json','logs/native_*.stdout','logs/native_*.stderr','logs/final/*','checks/*_original.inc','checks/*_observer.inc','artifacts/diffs/*_observer.patch']:
 paths.update(p.relative_to(W).as_posix() for p in W.glob(pat))
paths.update('artifacts/oracle_'+c['name']+'.json' for c in json.loads((W/'artifacts/inverse_oracle.json').read_text())['cases'])
rows=[dict(path=r,sha256=sha(W/r)) for r in sorted(paths)]
(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='POST_SEMANTIC_FILES_V1',count=len(rows),files=rows,note='Regenerated files removed before fresh jobs; every expected path compared by SHA256. Historical attempts/receipts and timings remain archived, not semantic matches.'),indent=2)+'\n');print('SEMANTIC_FILES',len(rows))
