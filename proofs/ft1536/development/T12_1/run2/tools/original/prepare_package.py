#!/usr/bin/env python3
import hashlib,json,re,shutil
from pathlib import Path
W=Path(__file__).resolve().parent.parent; O=W/'output'; F=W/'run/formal'
old=W.parent/'FT1536_MATH_EUFCMA_MTISIS_RUN_001/output'
INHERITED=['FT1536.'+x for x in ['Basic','MathSign','Geometry','Divergence','EventTransfer',
    'Adaptive','RetryDivergence','ROM','Collision','PublicSimulation','PublicCode','Relation',
    'Model','TraceBound','Certificate']]
NEW=['Run2.'+x for x in ['FiniteDist','Games','EmitMixture','BadVerify','GameInvariants',
    'FiberBinding','LazySampling','LawBinding','CorrectnessProbability','PaidSteps','TableCost',
    'UniformErrorBound','MTBinding','NumericCertificate']]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
generated=W/'run/sage_error_001/generated/NumericCertificate.lean'
shutil.copyfile(generated,F/'Run2/NumericCertificate.lean')
shutil.copyfile(old/'sage/check_bounds.sage',W/'run/sage/check_bounds.sage')
exports=[]
for mod in INHERITED+NEW:
    p=F/(mod.replace('.','/')+'.lean'); ns=[]
    for n,line in enumerate(p.read_text().splitlines(),1):
        if m:=re.match(r'^namespace\s+(\S+)',line):ns.append(m[1])
        if re.match(r'^end(?:\s|$)',line) and ns:ns.pop()
        if m:=re.match(r'^theorem\s+(\w+)',line):
            exports.append(dict(name='.'.join(ns+[m[1]]),source='formal/'+str(p.relative_to(F)),
                line=n,status='PROVED_KERNEL',inherited=mod in INHERITED))
audit='\n'.join('import '+m for m in INHERITED+NEW)+'\nset_option format.width 120\n'
for e in exports:audit+='\n#check @'+e['name']+'\n#print axioms '+e['name']+'\n'
(F/'AuditRun2.lean').write_text(audit)
O.mkdir(exist_ok=True)
for root in ['formal','sage']:
    source=W/'run'/root
    for p in sorted(source.rglob('*')):
        if p.is_file() and p.name!='Probe.lean':
            target=O/root/p.relative_to(source); target.parent.mkdir(parents=True,exist_ok=True)
            shutil.copyfile(p,target)
shutil.copytree(W/'inputs/bootstrap',O/'inputs/bootstrap',dirs_exist_ok=True)
shutil.copyfile(old/'TOOLCHAIN.json',O/'TOOLCHAIN.json')
shutil.copyfile(old/'LIBRARY_SOURCES.sha256',O/'LIBRARY_SOURCES.sha256')
shutil.copyfile(W/'run/GOAL_SPEC.md',O/'GOAL_SPEC.md')
shutil.copyfile(W/'run/sage_error_001/error_certificate.json',O/'error_certificate.json')
shutil.copyfile(old/'certificates.json',O/'certificates.json')
(O/'FORMAL_EXPORTS.json').write_text(json.dumps(dict(schema='RUN002_EXPORTS_V1',overall_status='PARTIAL_PROOF',
    exports=exports,missing_main_export='forall A, exists B=Reduction.build A S with full resource and EUF bound'),indent=2)+'\n')
(O/'BUILD.json').write_text(json.dumps(dict(modules=INHERITED+NEW+['AuditRun2'],
    lean_flags=['-j1','-M6144'],wall_s=1800,address_space_bytes=12884901888,normal_rss_budget_bytes=8589934592),indent=2)+'\n')
lines=[f'{sha(p)}  {p.relative_to(O)}' for p in sorted((O/'inputs').rglob('*')) if p.is_file()]
(O/'INPUTS.sha256').write_text('\n'.join(lines)+'\n')
print('EXPORTS',len(exports),'inherited',sum(e['inherited'] for e in exports),'new',sum(not e['inherited'] for e in exports))
