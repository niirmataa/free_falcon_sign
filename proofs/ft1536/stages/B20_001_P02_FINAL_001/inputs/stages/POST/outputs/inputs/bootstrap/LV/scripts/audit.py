"""Final source, clean-log and full theorem-type audit; --build is used by replay."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
W=Path.cwd();base=json.loads((W/'artifacts/inherited_modules.json').read_text())
new=['BridgeWords','Norm64','RawBridge','ByteCursor','DecodeStatic','DecodeNone','PublicKey','VerifyBytes','Initialization','MachineBindings','ParserRefinement','BridgeControlMain']
mods=base+new
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
if '--build' in sys.argv:
    p=subprocess.run([sys.executable,'-B','scripts/check_lean.py']+mods,timeout=230);assert p.returncode==0
decls=[];sources={}
for mod in mods:
    p=W/'formal'/(mod+'.lean');s=p.read_text();sources[str(p.relative_to(W))]=sha(p)
    assert not re.search(r'^\s*(axiom|opaque)\s',s,re.M) and not re.search(r'\b(sorry|admit|native_decide)\b',s)
    ns=re.search(r'^namespace (\w+)',s,re.M)
    for name in re.findall(r'^theorem ([\w.]+)',s,re.M):decls.append(ns.group(1)+'.'+name)
assert len(decls)==len(set(decls))
names=['CENTER_C','NORM64_EXACT','STRICT_B','RAW_VERIFIER_SOUND','unary_terminates','DECODE_NONE','DECODE_STATIC','PK_PREPARATION','L_V_BYTES','L_V_LOADED','L_V_SOURCE']
audit='import ParserRefinement\nimport BridgeControlMain\nset_option pp.universes true\n'
audit+='\n'.join('#check @FT1536Bridge.'+n for n in names)+'\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
types='import ParserRefinement\nset_option pp.all true\n'+'\n'.join('#check @FT1536Bridge.'+n for n in names)+'\n'
types+='\n'.join('#print FT1536Bridge.'+n for n in ['RAW_VERIFIER_SOUND','L_V_BYTES','L_V_LOADED'])+'\n'
for name,data in [('BridgeAudit',audit),('BridgeTypes',types)]:
    p=W/'formal'/(name+'.lean')
    if p.exists():assert p.read_text()==data
    else:p.write_text(data)
    sources[str(p.relative_to(W))]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/check_lean.py','BridgeAudit','BridgeTypes'],capture_output=True,timeout=90)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr)
assert p.returncode==0,(p.stdout.decode(),p.stderr.decode())
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel_checks.jsonl').read_text().splitlines())}
final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for mod in mods+['BridgeAudit','BridgeTypes']:
    r=latest[mod];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(mod+'.lean'))
    for stream in ['stdout','stderr']:
        data=(W/r[stream]).read_bytes();assert hashlib.sha256(data).hexdigest()==r[stream+'_sha256']
        assert not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(mod,data.decode())
        (final/(mod.replace('/','_')+'.'+stream)).write_bytes(data)
    receipts.append(r)
stdout=(final/'BridgeAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in stdout,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',stdout):
    assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed,dep
prov=json.loads((W/'inputs/provenance.json').read_text())
for r in prov:assert sha(W/r['copy'])==r['sha256'],r['copy']
result=dict(status='PASS',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=sum(x.startswith('FT1536Bridge.') for x in decls),
    theorems=decls,sources_sha256=sources,all_final_logs_clean=True,inherited_sources_unchanged=True,
    axioms_allowed=sorted(allowed),audit_stdout_sha256=sha(final/'BridgeAudit.stdout'),full_types_sha256=sha(final/'BridgeTypes.stdout'),
    full_theorems=['FT1536Bridge.'+n for n in names],remaining_bridge_hypotheses=[])
(W/'artifacts/formal_audit.json').write_text(json.dumps(result,indent=2)+'\n')
(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ['theorems','sources_sha256']},indent=2))
