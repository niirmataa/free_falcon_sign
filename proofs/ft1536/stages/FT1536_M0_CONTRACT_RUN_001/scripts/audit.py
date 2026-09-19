"""Audit limited M0 proofs and unchanged dependencies, not the pending security reduction."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
W=Path.cwd();base=json.loads((W/'artifacts/inherited_modules.json').read_text());new=['CapacityMath','EncoderCount','CapacityEndpoint','Framing'];mods=base+new
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
if '--build' in sys.argv:
    p=subprocess.run([sys.executable,'-B','scripts/check_lean.py']+mods,timeout=230);assert p.returncode==0
decls=[];sources={}
for mod in mods:
    p=W/'formal'/(mod+'.lean');s=p.read_text();sources[str(p.relative_to(W))]=sha(p)
    assert not re.search(r'^\s*(axiom|opaque)\s',s,re.M) and not re.search(r'\b(sorry|admit|native_decide)\b',s)
    ns=re.search(r'^namespace (\w+)',s,re.M)
    for name in re.findall(r'^theorem ([\w.]+)',s,re.M):decls.append(ns.group(1)+'.'+name)
names=['CAPACITY_3160','capacity_after_source_norm','STATIC_FITS_4096','positive_encoder_length','witness_norm','witness_length','framing_injective','repartition_rejected','parent_shake_budget']
audit='import CapacityEndpoint\nimport Framing\nset_option pp.universes true\n'
audit+='\n'.join('#check @FT1536M0.'+n for n in names)+'\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
types='import CapacityEndpoint\nimport Framing\nset_option pp.all true\n'+'\n'.join('#check @FT1536M0.'+n for n in names)+'\n#print FT1536M0.STATIC_FITS_4096\n'
for name,data in [('M0Audit',audit),('M0Types',types)]:
    p=W/'formal'/(name+'.lean')
    if p.exists():assert p.read_text()==data
    else:p.write_text(data)
    sources[str(p.relative_to(W))]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/check_lean.py','M0Audit','M0Types'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,(p.stdout.decode(),p.stderr.decode())
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel_checks.jsonl').read_text().splitlines())}
final=W/'logs/final';final.mkdir(exist_ok=True);records=[]
for mod in mods+['M0Audit','M0Types']:
    r=latest[mod];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(mod+'.lean'))
    for stream in ['stdout','stderr']:
        data=(W/r[stream]).read_bytes();assert hashlib.sha256(data).hexdigest()==r[stream+'_sha256']
        assert not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(mod,data.decode())
        (final/(mod.replace('/','_')+'.'+stream)).write_bytes(data)
    records.append(r)
stdout=(final/'M0Audit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in stdout,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',stdout):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed,dep
for r in json.loads((W/'inputs/provenance.json').read_text()):assert sha(W/r['copy'])==r['sha256'],r['copy']
out=dict(status='PASS',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=sum(n.startswith('FT1536M0.') for n in decls),
    theorems=decls,sources_sha256=sources,all_final_logs_clean=True,inherited_sources_unchanged=True,axioms_allowed=sorted(allowed),
    audit_stdout_sha256=sha(final/'M0Audit.stdout'),full_types_sha256=sha(final/'M0Types.stdout'),
    scope='capacity, source encoder count guards, exact witness, framing, parent byte budget; not a security reduction',security_reduction_proved=False)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['theorems','sources_sha256']},indent=2))
