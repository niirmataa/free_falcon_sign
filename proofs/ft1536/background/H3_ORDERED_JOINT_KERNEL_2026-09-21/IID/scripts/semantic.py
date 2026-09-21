import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();paths=set(['TOOLCHAIN.txt','CDF_MASS.json','ACCEPTANCE_FLOOR.json','BYTE_SCHEDULE.json','OBLIGATIONS.json','SCALAR_KERNEL_CERTIFICATE.json','artifacts/source_binding.json','artifacts/formal_audit.json','artifacts/fixtures.json','artifacts/pmf_examples.json','artifacts/rational_oracle.json','artifacts/mutations.json','artifacts/sampler_examples.json','artifacts/ber_cases.json','artifacts/kernel_order.json','formal/IidAudit.lean','formal/IidTypes.lean'])
for pat in ['artifacts/fixtures/*.input','artifacts/fixtures/*.expected','artifacts/pmf/*.json','artifacts/mutations/*.json','artifacts/native_normal_*.json','artifacts/native_sanitized_*.json','logs/native_*.stdout','logs/native_*.stderr','logs/final/*','checks/*.inc','artifacts/diffs/*_observer.patch']:
 paths.update(p.relative_to(W).as_posix() for p in W.glob(pat))
rows=[dict(path=r,sha256=sha(W/r)) for r in sorted(paths)]
(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='SCALAR_IID_SEMANTIC_FILES_V1',count=len(rows),files=rows,note='Every listed output is deleted then regenerated in fresh replay; historical failures and wall-time receipts remain archived separately.'),indent=2)+'\n');print('SEMANTIC_FILES',len(rows))
