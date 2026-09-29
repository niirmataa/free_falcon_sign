import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();mods=[];new=['StableBits','Sqrt54','SqrtPack','NormalizeMap','StableOutcome','SqrtMain']
def visit(m):
 if m in mods:return
 for d in re.findall(r'^import (\w+)',(W/'formal'/(m+'.lean')).read_text(),re.M):
  if (W/'formal'/(d+'.lean')).exists():visit(d)
 mods.append(m)
for p in sorted((W/'formal').glob('*.lean')):
 if p.stem not in ['RawAudit','RawTypes','StableAudit','StableTypes']:visit(p.stem)
(W/'artifacts/kernel_order.json').write_text(json.dumps(mods,indent=2)+'\n')
decls=[];fresh=[];sources={}
for m in mods:
 p=W/'formal'/(m+'.lean');text=p.read_text();sources[p.relative_to(W).as_posix()]=sha(p)
 assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M) and not re.search(r'\b(sorry|admit|native_decide|Lean.ofReduceBool)\b',text)
 ns=re.search(r'^namespace (\w+)',text,re.M)
 for n in re.findall(r'^theorem ([\w.]+)',text,re.M):
  name=ns[1]+'.'+n;decls.append(name)
  if m in new:fresh.append(name)
imports=''.join('import '+m+'\n' for m in mods)
a=imports+'set_option pp.universes true\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
t=imports+'set_option pp.all true\n'+'\n'.join('#check @'+n+'\n#print '+n for n in fresh)+'\n'
t+='\n'.join('#print '+n for n in ['StableSqrt.step','StableSqrt.runBits','StableNorm.swapFlag','StableNorm.gate','StableNorm.scan','StableNorm.leafPos','StableNorm.fullMap'])+'\n'
for name,text in [('StableAudit',a),('StableTypes',t)]:
 p=W/'formal'/(name+'.lean')
 if p.exists():assert p.read_text()==text
 else:p.write_text(text)
 sources[p.relative_to(W).as_posix()]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','StableAudit','StableTypes'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,(p.stdout.decode(),p.stderr.decode())
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())};final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for m in mods+['StableAudit','StableTypes']:
 r=latest[m];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(m+'.lean'))
 for s in ['stdout','stderr']:
  p=W/r[s];data=p.read_bytes();assert sha(p)==r[s+'_sha256'] and not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(m,s)
  (final/(m+'.'+s)).write_bytes(data)
 receipts.append(r)
text=(final/'StableAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in text,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed
I=W/'inputs/bootstrap';boot=verify_manifest(I,'MANIFEST.sha256','58f027900b3283bdf6f488ddb4fdeaa1e6c80b69253cf7d03a7855d3898478f7')
for m in mods:
 if m not in new:assert sha(W/'formal'/(m+'.lean'))==boot['RAW/formal/'+m+'.lean']
out=dict(status='PASS_KERNEL_SQRT54_BIT_BRIDGE_GATE_MAPPING_AND_SCOPED_CONSUMERS',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=len(fresh),
 inherited_modules_unchanged=len(mods)-len(new),new_declarations=fresh,all_theorems=decls,sources_sha256=sources,all_final_logs_clean=True,allowed_axioms=sorted(allowed),
 audit_stdout_sha256=sha(final/'StableAudit.stdout'),types_terms_stdout_sha256=sha(final/'StableTypes.stdout'),
 proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',sqrt54_integer_invariant_kernelized=True,source_normalization_fully_kernelized=False,C_compiler_verified=False)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['sources_sha256','all_theorems','new_declarations']},indent=2))
