import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();paths=set(['TOOLCHAIN.txt','SOURCE_ORDER.json','JOINT_COMPARISON.json','SUPPORT_EXIT.json','RESOURCE_BOUND.json','ERROR_LEDGER.json','ERROR_LEDGER.md','OBLIGATIONS.json','ORDERED_JOINT_CERTIFICATE.json','artifacts/source_binding.json','artifacts/scalar_binding.json','artifacts/post_binding.json','artifacts/closure_instance.json','artifacts/formal_audit.json','artifacts/fixtures.json','artifacts/byte_schedule.json','artifacts/projection_control.json','artifacts/probability_trees.json','artifacts/mutations.json','artifacts/kernel_order.json','formal/JointAudit.lean','formal/JointTypes.lean'])
for pat in ['artifacts/fixtures_*.json','artifacts/fixtures/*.input','artifacts/fixtures/*.expected','artifacts/controls/*.json','artifacts/probability/*.json','artifacts/mutations/*.json','artifacts/native_normal.json','artifacts/native_sanitized.json','logs/native_*.stdout','logs/native_*.stderr','logs/final/*','checks/*.inc','checks/joint.c','artifacts/diffs/*_observer.patch','artifacts/diffs/joint_driver.patch']:
 paths.update(p.relative_to(W).as_posix() for p in W.glob(pat))
# joint_scalar.inc is a hand-written source seed, not a generated include.
paths.remove('checks/joint_scalar.inc')
rows=[dict(path=r,sha256=sha(W/r)) for r in sorted(paths)];(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='ORDERED_JOINT_SEMANTIC_FILES_V1',count=len(rows),files=rows,note='Every listed generated output removed before fresh jobs; source seeds retained; no project binaries/olean/cache imported.'),indent=2)+'\n');print('SEMANTIC_FILES',len(rows))
