import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();mods=json.loads((W/'artifacts/kernel_order.json').read_text());new=['RawLayout','RawComposition','RawMatching'];decls=[];fresh=[];sources={}
for m in mods:
 p=W/'formal'/(m+'.lean');text=p.read_text();sources[p.relative_to(W).as_posix()]=sha(p)
 assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M) and not re.search(r'\b(sorry|admit|native_decide|Lean.ofReduceBool)\b',text)
 ns=re.search(r'^namespace (\w+)',text,re.M)
 for n in re.findall(r'^theorem ([\w.]+)',text,re.M):
  name=ns[1]+'.'+n;decls.append(name)
  if m in new:fresh.append(name)
imports=''.join('import '+m+'\n' for m in mods)
audit=imports+'set_option pp.universes true\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
types=imports+'set_option pp.all true\n'+'\n'.join('#check @'+n+'\n#print '+n for n in fresh)+'\n'
types+='\n'.join('#print RawAssembly.'+n for n in ['Ops','LocalDomains','depth','top','rawPrefix','treeStore','keepAfterGram'])+'\n'
for n,text in [('RawAudit',audit),('RawTypes',types)]:
 p=W/'formal'/(n+'.lean')
 if p.exists():assert p.read_text()==text
 else:p.write_text(text)
 sources[p.relative_to(W).as_posix()]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','RawAudit','RawTypes'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,p.stderr.decode()
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())};final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for m in mods+['RawAudit','RawTypes']:
 r=latest[m];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(m+'.lean'))
 for s in ['stdout','stderr']:
  p=W/r[s];data=p.read_bytes();assert sha(p)==r[s+'_sha256'] and not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(m,s)
  (final/(m+'.'+s)).write_bytes(data)
 receipts.append(r)
text=(final/'RawAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in text,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed,dep
I=W/'inputs/bootstrap';boot=verify_manifest(I,'MANIFEST.sha256','5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4')
for m in mods:
 if m not in new:assert sha(W/'formal'/(m+'.lean'))==boot['TOWER/formal/'+m+'.lean']
out=dict(status='PASS_KERNEL_LOCAL_DOMAIN_COMPOSITION_LAYOUT_FRAME_MATCHING',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=len(fresh),
 new_declarations=fresh,all_theorems=decls,source_sha256=sources,all_final_logs_clean=True,allowed_axioms=sorted(allowed),inherited_modules_unchanged=len(mods)-len(new),
 audit_stdout_sha256=sha(final/'RawAudit.stdout'),types_terms_stdout_sha256=sha(final/'RawTypes.stdout'),
 proof_boundary='Generic partial-operation composition and integer/layout/frame lemmas kernel checked. Actual P_key numerical/source-memory instantiation is the separate universal analytical proof in COMPOSITION.md.',
 raw_prefix_fully_kernelized=False,C_compiler_verified=False)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['source_sha256','all_theorems','new_declarations']},indent=2))
