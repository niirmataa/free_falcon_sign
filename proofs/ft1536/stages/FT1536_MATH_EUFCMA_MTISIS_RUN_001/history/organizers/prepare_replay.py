#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path
import shutil
import sys

W=Path(__file__).resolve().parent.parent
O=W/'output'
A=W/'run'/sys.argv[1]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
audit=A/'logs/Audit.stdout'
assert (A/'logs/Audit.stderr').stat().st_size==0
assert 'error:' not in audit.read_text() and 'warning:' not in audit.read_text()
shutil.copyfile(audit,O/'formal_types.txt')
products={'work/certificates.json':sha(O/'certificates.json'),
          'work/generated/Certificate.lean':sha(O/'formal/FT1536/Certificate.lean'),
          'logs/Audit.stdout':sha(audit)}
(O/'EXPECTED.json').write_text(json.dumps(dict(schema='T12_1_PREDECLARED_PRODUCTS_V1',products=products,
    rationale='Exact regenerated Sage certificate, kernel-consumed generated Lean, full typed/transitive-axiom export log.'),indent=2)+'\n')
pins=json.loads((O/'inputs/bootstrap/TOOLCHAIN_PINS.json').read_text())
lean=pins['lean']['observed_path']; sage=pins['sage']['launcher']
(O/'TOOLCHAIN.json').write_text(json.dumps(dict(lean=dict(version='4.34.0',executable=lean,sha256=sha(Path(lean))),
    sage=dict(version='10.9',launcher=sage,launcher_sha256=sha(Path(sage)),invocation='sage check_bounds.sage'),
    mathlib_commit=pins['mathlib']['commit'],library_closure='LIBRARY_CLOSURE.json',
    source_inventory='LIBRARY_SOURCES.sha256',reuse='Exact hashed RO upstream cache; own project rebuilt fresh.'),indent=2)+'\n')
(O/'GOAL_SPEC.json').write_text(json.dumps(dict(schema='T12_1_GOALS_V1',
    task_sha256='0fe2ad810e476e44e6cc3a1bca0bcc409004810cfe4b5424523ba914ac9e0cc3',
    before_proof_spec='GOAL_SPEC.md',checked_types='formal_types.txt',checked_types_sha256=sha(audit),
    exports='FORMAL_EXPORTS.json',missing_interfaces='NEXT_INTERFACE.md',
    goal_status='PARTIAL_PROOF'),indent=2)+'\n')
# A fixed sealed semantic seed breaks the manifest/receipt self-reference.
included=[]
for p in sorted(O.rglob('*')):
    if not p.is_file(): continue
    r=p.relative_to(O)
    if r.parts[0] in {'formal','sage','tools','inputs','library-source'} or r.name in {
        'BUILD.json','FORMAL_EXPORTS.json','LIBRARY_CLOSURE.json','LIBRARY_SOURCES.sha256',
        'TOOLCHAIN.json','EXPECTED.json','INPUTS.sha256'}:
        included.append(f'{sha(p)}  {r}')
(O/'REPLAY_SEED.sha256').write_text('\n'.join(included)+'\n')
print('REPLAY_SEED_SHA256='+sha(O/'REPLAY_SEED.sha256'))
