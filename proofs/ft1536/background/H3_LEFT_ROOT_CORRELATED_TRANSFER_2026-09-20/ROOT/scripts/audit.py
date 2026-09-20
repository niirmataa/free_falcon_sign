import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();old=json.loads((W/'artifacts/inherited_order.json').read_text());new=['RootDiv','RootFrame','RootBounds','RootModel'];mods=old+new
if '--build' in sys.argv:
 p=subprocess.run([sys.executable,'-B','scripts/lean.py']+mods,timeout=180);assert p.returncode==0
decls=[];newdecls=[];sources={}
for mod in mods:
 p=W/'formal'/(mod+'.lean');text=p.read_text();sources[str(p.relative_to(W))]=sha(p)
 assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M) and not re.search(r'\b(sorry|admit|native_decide)\b',text)
 ns=re.search(r'^namespace (\w+)',text,re.M)
 for name in re.findall(r'^theorem ([\w.]+)',text,re.M):
  full=ns.group(1)+'.'+name;decls.append(full)
  if mod in new:newdecls.append(full)
audit='import RootModel\nset_option pp.universes true\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
types='import RootModel\nset_option pp.all true\n'+'\n'.join('#check @'+n+'\n#print '+n for n in newdecls)+'\n'
types+='\n'.join('#print RootLDL.'+n for n in ['step','loop','mulC','divC','store','runStores'])+'\n'
for n,data in [('RootAudit',audit),('RootTypes',types)]:
 p=W/'formal'/(n+'.lean')
 if p.exists():assert p.read_text()==data
 else:p.write_text(data)
 sources[str(p.relative_to(W))]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','RootAudit','RootTypes'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,p.stderr.decode()
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())};final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for mod in mods+['RootAudit','RootTypes']:
 r=latest[mod];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(mod+'.lean'))
 for stream in ['stdout','stderr']:
  p=W/r[stream];data=p.read_bytes();assert sha(p)==r[stream+'_sha256'] and not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(mod,data.decode())
  (final/(mod+'.'+stream)).write_bytes(data)
 receipts.append(r)
text=(final/'RootAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in text,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed,dep
boot=verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73');assert len(boot)==106
I=W/'inputs/bootstrap';assert {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
for r in json.loads((W/'inputs/provenance.json').read_text()):assert sha(W/r['copy'])==r['sha256']
for mod in old:assert sha(W/'formal'/(mod+'.lean'))==boot['ZERO/formal/'+mod+'.lean']
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h
out=dict(status='PASS_KERNEL_SUBSET_AND_PROVENANCE',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=len(newdecls),
 theorems=decls,new_declarations=newdecls,sources_sha256=sources,all_final_logs_clean=True,allowed_axioms=sorted(allowed),
 inherited_modules_unchanged=len(old),audit_stdout_sha256=sha(final/'RootAudit.stdout'),full_types_terms_sha256=sha(final/'RootTypes.stdout'),
 analytical_proofs={r:sha(W/r) for r in ['ANALYTIC_PROOF.md','EMITTED_BINDING.md','ROOT_FRAME.md']},
 full_root_theorem_kernelized=False,proof_layer='Kernel integer lemmas/models; universal root/source/composition analytical with exact Sage certificates.',
 H3_range_proved=False,full_internal_tree_proved=False,global_reachability_proved=False,sampler_law_proved=False)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['theorems','new_declarations','sources_sha256']},indent=2))
