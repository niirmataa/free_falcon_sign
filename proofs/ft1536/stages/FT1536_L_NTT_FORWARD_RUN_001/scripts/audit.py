"""Clean final source/axiom audit. --build reconstructs all modules from sources."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
W=Path.cwd()
inherited=json.loads((W/'artifacts/inherited_modules.json').read_text())
new=['Sums','Evaluation','CRTStages','NodeArithmetic']+[f'LeafData/C{i:02}' for i in range(32)]+[
 'LeafChecks','LeafFacts','ForwardGlobal','Monomials','Product','Complete','CheckerControls','ControlMain']
modules=inherited+new
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
if '--build' in sys.argv:
    p=subprocess.run([sys.executable,'-B','scripts/check_lean.py']+modules,timeout=230)
    assert p.returncode==0
decls=[];sources={}
for name in modules:
    path=W/'formal'/(name+'.lean');text=path.read_text()
    assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M)
    assert not re.search(r'\b(sorry|admit|native_decide)\b',text)
    ns=re.search(r'^namespace (\w+)',text,re.M)
    for t in re.findall(r'^theorem ([\w.]+)',text,re.M):decls.append(ns.group(1)+'.'+t)
    sources[str(path.relative_to(W))]=sha(path)
assert len(decls)==len(set(decls))
main=['FORWARD_GLOBAL','node_zero','forward_product','product_canonical_inputs','L_NTT','L_NTT_p','L_NTT_d','L_NTT_ranges','L_NTT_rho','L_NTT_rho_ranges']
audit='import Complete\nimport CheckerControls\nimport ControlMain\nset_option pp.universes true\n'
audit+='\n'.join('#check @FT1536Forward.'+n for n in main)+'\n'
audit+='\n'.join('#print axioms '+n for n in decls)+'\n'
types='import Complete\nset_option pp.all true\n'
types+='\n'.join('#check @FT1536Forward.'+n for n in main)+'\n#print FT1536Forward.L_NTT\n#print FT1536Forward.L_NTT_rho\n'
for name,text in [('Audit',audit),('AuditTypes',types)]:
    path=W/'formal'/(name+'.lean')
    if path.exists():assert path.read_text()==text
    else:path.write_text(text)
    sources[str(path.relative_to(W))]=sha(path)
p=subprocess.run([sys.executable,'-B','scripts/check_lean.py','Audit','AuditTypes'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr)
assert p.returncode==0,(p.stdout.decode(),p.stderr.decode())
latest={}
for line in (W/'artifacts/kernel_checks.jsonl').read_text().splitlines():
    r=json.loads(line)
    if r['module'] in modules+['Audit','AuditTypes']:latest[r['module']]=r
final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for name in modules+['Audit','AuditTypes']:
    r=latest[name];assert r['exit_code']==0 and not r['timeout']
    assert r['source_sha256']==sha(W/'formal'/(name+'.lean'))
    for stream in ['stdout','stderr']:
        data=(W/r[stream]).read_bytes();assert hashlib.sha256(data).hexdigest()==r[stream+'_sha256']
        assert not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(name,stream,data.decode())
        (final/(name.replace('/','_')+'.'+stream)).write_bytes(data)
    receipts.append(r)
allowed={'propext','Classical.choice','Quot.sound'}
stdout=(final/'Audit.stdout').read_text()
for n in decls:assert "'"+n+"'" in stdout,n
for deps in re.findall(r'depends on axioms: \[([^]]*)\]',stdout):
    names={re.sub(r'\.\{[^}]*\}$','',a) for a in deps.split(', ')};assert names<=allowed,deps
prov=json.loads((W/'inputs/provenance.json').read_text())
for rec in prov:
    assert sha(W/rec['copy'])==rec['sha256'],rec['copy']
adapt=json.loads((W/'artifacts/adaptations.json').read_text())
assert sha(W/'inputs/RHO/Rho.lean')==adapt['old_sha256'] and sha(W/'formal/Rho.lean')==adapt['new_sha256']
assert (W/'formal/Rho.lean').read_text()==(W/'inputs/RHO/Rho.lean').read_text().replace('if_pos','ite_eq_left').replace('if_neg','ite_eq_right')
for n in inherited:
    if n=='Rho':continue
    rel='formal/'+n+'.lean';assert sources[rel]==next(x['sha256'] for x in prov if x['copy']==rel)
result=dict(status='PASS',modules=len(modules)+2,checked_theorems=len(decls),
    new_theorems=sum(n.startswith('FT1536Forward.') for n in decls),theorems=decls,
    all_final_logs_clean=True,axioms_allowed=sorted(allowed),source_sha256=sources,
    audit_stdout_sha256=sha(final/'Audit.stdout'),full_types_sha256=sha(final/'AuditTypes.stdout'),
    inherited_models_byte_identical=True,remaining_global_hypotheses=[],
    final_theorems=['FT1536Forward.'+n for n in main])
(W/'artifacts/formal_audit.json').write_text(json.dumps(result,indent=2)+'\n')
(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ['theorems','source_sha256']},indent=2))
