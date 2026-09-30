"""Inventory and kernel-axiom audit of the new machine integration components.

This is a development audit, not the final clean replay of RUN_002.
Only source inventory, execution and log/hash bookkeeping happen in Python.
"""
import json,re,subprocess,sys
from pathlib import Path
from job import W,sha

groups={
    'MiMoIntegration':'MiMoIntegration',
    'SignedMachine':'BitArithmetic','WordEncoding':'BitArithmetic',
    'FieldProgram':'FieldProgram','PolynomialMachine':'PolynomialMachine',
    'NormMachine':'NormMachine','ScalarMachine':'BitArithmetic',
    'OperationTrace':'OperationTrace','ByteMachine':'ByteMachine',
    'TableMachine':'TableMachine','ReferenceFinish':'ReferenceFinish',
    'NonceBits':'NonceBits','FileArithmetic':'FileArithmetic',
    'FileVerifier':'FileVerifier','VerifierResources':'FileVerifier',
    'VerifierInputs':'FileVerifier','BitFinish':'BitFinish','BitReduction':'BitReduction',
    'StateResources':'StateResources','PeakExecution':'PeakExecution',
    'LocalBitCode':'LocalBitCode','PublicEncoding':'PublicEncoding',
    'SamplerMachine':'SamplerMachine','AdversaryMachine':'AdversaryMachine',
}
label=sys.argv[1]
assert re.fullmatch(r'machine_audit_[0-9]+',label)
exports=[];sources={}
for module,namespace in groups.items():
    p=W/'run/formal/Run2'/f'{module}.lean'
    sources[str(p.relative_to(W))]=sha(p)
    for name in re.findall(r'^theorem\s+(\w+)',p.read_text(),re.M):
        exports.append(f'FT1536.Run2.{namespace}.{name}')
assert len(exports)==len(set(exports))
audit='\n'.join(f'import Run2.{m}' for m in groups)+'\n\n'
audit+='\n'.join(f'#print axioms {name}' for name in exports)+'\n'
(W/'run/formal/MachineAudit.lean').write_text(audit)
r=subprocess.run([sys.executable,'-B',str(W/'run/job.py'),label,'lean','MachineAudit'],cwd=W)
if r.returncode:raise SystemExit(r.returncode)
D=W/'run'/label;log=(D/'logs/MachineAudit.stdout').read_text()
assert not (D/'logs/MachineAudit.stderr').read_bytes()
assert 'warning:' not in log and 'error:' not in log
observed={}
for match in re.finditer(r"'([^']+)' depends on axioms: \[([^\]]*)\]",log):
    observed[match[1]]=[s.strip() for s in match[2].split(',') if s.strip()]
for match in re.finditer(r"'([^']+)' does not depend on any axioms",log):observed[match[1]]=[]
assert set(observed)==set(exports),(len(observed),len(exports),set(exports)-set(observed))
allowed={'propext','Classical.choice','Quot.sound'}
assert all(set(v)<=allowed for v in observed.values()),observed
result=dict(status='PASS_SCOPED_DEVELOPMENT_AUDIT',clean_final_replay=False,
    scope='new integration component theorem axioms; no whole-reducer resource claim',
    modules=list(groups),exports=len(exports),sources=sources,axioms=observed,
    audit_stdout_sha256=sha(D/'logs/MachineAudit.stdout'),receipts=sha(D/'RECEIPTS.json'))
(D/'MACHINE_COMPONENTS_AUDIT.json').write_text(json.dumps(result,indent=2)+'\n')
print('MACHINE_COMPONENTS_AUDIT_PASS',len(exports))
