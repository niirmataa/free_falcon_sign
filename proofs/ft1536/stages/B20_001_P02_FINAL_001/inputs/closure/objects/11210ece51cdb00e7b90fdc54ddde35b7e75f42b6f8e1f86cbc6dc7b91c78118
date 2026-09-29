import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();mods=json.loads((W/'artifacts/kernel_order.json').read_text());new={'GaussianMul','GaussianIntervals','GaussianMetrics','GaussianData'};decls=[];fresh=[];sources={}
for m in mods:
 p=W/'formal'/(m+'.lean');s=p.read_text();sources[p.relative_to(W).as_posix()]=sha(p);assert not re.search(r'^\s*(axiom|opaque)\s',s,re.M) and not re.search(r'\b(sorry|admit|native_decide|Lean.ofReduceBool)\b',s)
 scopes=[]
 for line in s.splitlines():
  ns=re.match(r'^namespace\s+(\S+)',line);sec=re.match(r'^section(?:\s+(\S+))?\s*$',line)
  if ns:scopes.append(('namespace',ns[1]))
  elif sec:scopes.append(('section',sec[1] or ''))
  elif re.match(r'^end(?:\s+\S+)?\s*$',line):assert scopes;scopes.pop()
  t=re.match(r'^(?:theorem|lemma)\s+([\w.]+)',line)
  if t:
   name='.'.join([n for k,n in scopes if k=='namespace']+[t[1]]);decls.append(name)
   if m in new:fresh.append(name)
 assert not scopes,m
imports=''.join('import '+m+'\n' for m in mods)
texts={'GaussianAudit':imports+'set_option pp.universes true\n'+'\n'.join('#print axioms '+n for n in decls)+'\n','GaussianTypes':imports+'set_option pp.all true\n'+'\n'.join('#check @'+n+'\n#print '+n for n in fresh)+'\n'}
for name,text in texts.items():
 p=W/'formal'/(name+'.lean')
 if p.exists():assert p.read_text()==text
 else:p.write_text(text)
 sources[p.relative_to(W).as_posix()]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','GaussianAudit','GaussianTypes'],capture_output=True,timeout=120)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,p.stdout.decode()+p.stderr.decode()
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())};final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for m in mods+list(texts):
 r=latest[m];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(m+'.lean'))
 for stream in ['stdout','stderr']:
  p=W/r[stream];b=p.read_bytes();assert sha(p)==r[stream+'_sha256'] and not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',b),(m,stream);(final/(m+'.'+stream)).write_bytes(b)
 receipts.append(r)
text=(final/'GaussianAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in text,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed
verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','30721120fb8ed7721aa4fe14f960fe90a0614221e58cbb3d7bd523fedc25de27')
for r in json.loads((W/'artifacts/reuse.json').read_text()):assert sha(W/r['copy'])==sha(W/r['input'])==r['sha256']
out=dict(status='PASS_KERNEL_SOURCE_REFINEMENT_INTERVAL_NORMALIZATION_AND_SUPPORT_LEMMAS',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=len(fresh),inherited_modules_unchanged=len(mods)-len(new),new_declarations=fresh,all_theorems=decls,sources_sha256=sources,all_final_logs_clean=True,allowed_axioms=sorted(allowed),audit_stdout_sha256=sha(final/'GaussianAudit.stdout'),types_terms_stdout_sha256=sha(final/'GaussianTypes.stdout'),proof_kind='MIXED_KERNEL_UNIVERSAL_ANALYTICAL_SOURCE_AND_QQ_RBF_PROOF',fully_kernelized=False,C_compiler_verified=False,boundary='Kernel integer limbs/rounding consumers, source bracket data, scaled Bernstein/normalization algebra and support logic; actual floating source refinement, real Gaussian/Taylor/tail/metric instantiation are analytical with exact QQ/RBF certificates.')
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['new_declarations','all_theorems','sources_sha256']},indent=2))
