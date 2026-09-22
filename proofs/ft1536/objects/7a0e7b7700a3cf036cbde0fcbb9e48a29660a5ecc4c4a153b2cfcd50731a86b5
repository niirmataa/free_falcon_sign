import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();paths=set(['TOOLCHAIN.txt','SOURCE_NOISE_MAP.json','VARIANCE_BRIDGE.json','ERROR_LEDGER.json','CONDITIONAL_MGF.json','JOINT_TAIL_BOUND.json','H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json','OBLIGATIONS.json','artifacts/source_binding.json','artifacts/kernel_order.json','artifacts/formal_audit.json','artifacts/mgf_controls.json','artifacts/mutations.json','artifacts/failed_routes_numeric.json','formal/H6PAudit.lean','formal/H6PTypes.lean'])
for pat in ['artifacts/fixtures_*.json','artifacts/fixtures/*.input','artifacts/fixtures/*.expected','artifacts/controls/*.json','artifacts/map_oracle_*.json','artifacts/adjoint_*.json','artifacts/mutations/*.json','artifacts/native_normal_*.json','artifacts/native_sanitized_*.json','logs/native_*.stdout','logs/native_*.stderr','logs/final/*','checks/*.inc','artifacts/diffs/*_observer.patch']:
 paths.update(p.relative_to(W).as_posix() for p in W.glob(pat))
rows=[dict(path=r,sha256=sha(W/r)) for r in sorted(paths)];(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='H6P_SEMANTIC_FILES_V1',game='IID_BUFFER',reference='Q_S',event='joint pre-narrow BadPrecast, one root',count=len(rows),files=rows),indent=2)+'\n');print('SEMANTIC_FILES',len(rows))
