import hashlib,json,shutil
from pathlib import Path
W=Path(__file__).resolve().parent.parent;O=W/'output'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
audit=W/'run/audit_baseline_003/logs/AuditRun2.stdout'
assert not (audit.parent/'AuditRun2.stderr').read_bytes()
assert 'warning:' not in audit.read_text() and 'error:' not in audit.read_text()
shutil.copyfile(audit,O/'formal_types.txt')
expected={'work/inherited/certificates.json':sha(O/'certificates.json'),
    'work/inherited/generated/Certificate.lean':sha(O/'formal/FT1536/Certificate.lean'),
    'work/new/error_certificate.json':sha(O/'error_certificate.json'),
    'work/new/generated/NumericCertificate.lean':sha(O/'formal/Run2/NumericCertificate.lean'),
    'logs/AuditRun2.stdout':sha(audit)}
(O/'EXPECTED.json').write_text(json.dumps(dict(products=expected,predeclared=True),indent=2)+'\n')
(O/'GOAL_SPEC.json').write_text(json.dumps(dict(task_id='FT1536_MATH_EUFCMA_MTISIS_RUN_002',
    status='PARTIAL_PROOF',intended='GOAL_SPEC.md',actual_types='formal_types.txt',
    actual_types_sha256=sha(audit),missing_types='NEXT_INTERFACE.md'),indent=2)+'\n')
include=[]
for p in sorted(O.rglob('*')):
    if not p.is_file():continue
    r=p.relative_to(O)
    if r.parts[0] in {'formal','sage','tools','inputs','library-source'} or r.name in {
        'BUILD.json','FORMAL_EXPORTS.json','LIBRARY_CLOSURE.json','LIBRARY_SOURCES.sha256',
        'TOOLCHAIN.json','EXPECTED.json','INPUTS.sha256'}:
        include.append(f'{sha(p)}  {r}')
(O/'REPLAY_INPUTS.sha256').write_text('\n'.join(include)+'\n')
print('REPLAY_INPUTS_SHA256='+sha(O/'REPLAY_INPUTS.sha256'))
