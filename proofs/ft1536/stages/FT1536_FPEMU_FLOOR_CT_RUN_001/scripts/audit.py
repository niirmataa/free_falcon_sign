import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();old=json.loads((W/'artifacts/inherited_order.json').read_text());new=['FloorWord','FloorConsumers','FloorMain'];mods=old+new
if '--build' in sys.argv:
 p=subprocess.run([sys.executable,'-B','scripts/lean.py']+mods,timeout=180);assert p.returncode==0
decls=[];newdecls=[];sources={}
for mod in mods:
 p=W/'formal'/(mod+'.lean');text=p.read_text();sources[str(p.relative_to(W))]=sha(p)
 assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M) and not re.search(r'\b(sorry|admit|native_decide|Lean.ofReduceBool)\b',text)
 ns=re.search(r'^namespace (\w+)',text,re.M)
 for n in re.findall(r'^theorem ([\w.]+)',text,re.M):
  full=ns.group(1)+'.'+n;decls.append(full)
  if mod in new:newdecls.append(full)
a='import FloorConsumers\nset_option pp.universes true\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
t='import FloorConsumers\nset_option pp.all true\n'+'\n'.join('#check @'+n+'\n#print '+n for n in newdecls)+'\n'
t+='\n'.join('#print FloorCT.'+n for n in ['irsh','candidateBits','candidateLong','DefinedLP64'])+'\n'
for n,data in [('EquivAudit',a),('EquivTypes',t)]:
 p=W/'formal'/(n+'.lean')
 if p.exists():assert p.read_text()==data
 else:p.write_text(data)
 sources[str(p.relative_to(W))]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','EquivAudit','EquivTypes'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,p.stderr.decode()
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())};final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for mod in mods+['EquivAudit','EquivTypes']:
 r=latest[mod];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(mod+'.lean'))
 for stream in ['stdout','stderr']:
  p=W/r[stream];data=p.read_bytes();assert sha(p)==r[stream+'_sha256'] and not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(mod,data.decode())
  (final/(mod+'.'+stream)).write_bytes(data)
 receipts.append(r)
text=(final/'EquivAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in text,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed,dep
I=W/'inputs/bootstrap';boot=verify_manifest(I,'MANIFEST.sha256','2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c');assert len(boot)==382
assert {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
for r in json.loads((W/'inputs/provenance.json').read_text()):assert sha(W/r['copy'])==r['sha256']
for mod in old:assert sha(W/'formal'/(mod+'.lean'))==boot['ZERO/formal/'+mod+'.lean']
out=dict(status='PASS_KERNEL_ALL_WORD64_EQUIVALENCE_AND_RANGE_FACTS',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=len(newdecls),
 theorems=decls,new_declarations=newdecls,sources_sha256=sources,all_final_logs_clean=True,allowed_axioms=sorted(allowed),inherited_modules_unchanged=len(old),
 audit_stdout_sha256=sha(final/'EquivAudit.stdout'),full_types_terms_sha256=sha(final/'EquivTypes.stdout'),
 all_word64_equivalence_proved=True,source_definedness_range_facts_proved=True,numeric_center_transport_proved=True,
 proof_kind='KERNEL_INTEGER_BIT_MODEL_WITH_EXPLICIT_C99_GCC_LP64_SOURCE_BINDING',C_compiler_verified=False)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['theorems','new_declarations','sources_sha256']},indent=2))
