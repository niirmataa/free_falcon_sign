"""Audit all NEW proof modules. A clean conditional theorem is not global H3."""
import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();mods=['Floor','Comparator','Proposal','CDF','OrderedResidual','GuardPrefix']
if '--build' in sys.argv:
 p=subprocess.run([sys.executable,'-B','scripts/lean.py']+mods,timeout=120);assert p.returncode==0
decls=[];sources={}
for name in mods:
 p=W/'formal'/(name+'.lean');s=p.read_text();sources[str(p.relative_to(W))]=sha(p)
 assert not re.search(r'\b(sorry|admit|native_decide)\b',s) and not re.search(r'^\s*(axiom|opaque)\s',s,re.M)
 decls+=['H3Range.'+n for n in re.findall(r'^theorem ([\w.]+)',s,re.M)]
names=['floor_refinement','negative_zero_exception','negative_zero_sum_still_safe','lt128_correct','all_bank_support','proposal_return_safe',
 'terminal_right_then_left','next_terminal_center','checked_key_coefficients','guards_do_not_imply_floor_refinement','complete_local_lift']
audit='import GuardPrefix\nset_option pp.universes true\n'+'\n'.join('#check @H3Range.'+n for n in names)+'\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
types='import GuardPrefix\nset_option pp.all true\n'+'\n'.join('#check @H3Range.'+n for n in names)+'\n#print H3Range.complete_local_lift\n#print H3Range.CenterClass\n'
for n,s in [('Audit',audit),('Types',types)]:
 p=W/'formal'/(n+'.lean')
 if p.exists():assert p.read_text()==s
 else:p.write_text(s)
 sources[str(p.relative_to(W))]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','Audit','Types'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,(p.stdout.decode(),p.stderr.decode())
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())}
final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for n in mods+['Audit','Types']:
 r=latest[n];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(n+'.lean'))
 for stream in ['stdout','stderr']:
  p=W/r[stream];data=p.read_bytes();assert sha(p)==r[stream+'_sha256']
  assert not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(n,data.decode())
  (final/(n+'.'+stream)).write_bytes(data)
 receipts.append(r)
text=(final/'Audit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for n in decls:assert "'"+n+"'" in text,n
for dep in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in dep.split(', ')}<=allowed,dep
boot=verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','f9ea278838e9d1f8f959100175f56c62217997ff25611fccc0b9353dd9fcfe40');assert len(boot)==52
I=W/'inputs/bootstrap'
assert {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==50
for r in orig['files']:assert boot[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(dict(manifest_sha256=sha(I/'MANIFEST.sha256'),members=52,originals=50,exact_scope=True,source_files=17,all_hashes_match=True),indent=2)+'\n')
for row in json.loads((W/'inputs/provenance.json').read_text()):assert sha(W/row['copy'])==row['sha256']
for line in (W/'inputs/bootstrap/CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h
out=dict(status='PASS_LOCAL_PROOFS',modules=len(mods)+2,checked_theorems=len(decls),theorems=decls,sources_sha256=sources,all_final_logs_clean=True,
 axioms_allowed=sorted(allowed),audit_stdout_sha256=sha(final/'Audit.stdout'),full_types_sha256=sha(final/'Types.stdout'),
 global_H3_range_proved=False,remaining_global_goal='Reach_call_C(...) -> CenterClass(mu)',
 conditional_premises_explicit=['exponent<=1053','NotNegZero','C_mu','prior residual/errors for ordered lemmas'],bootstrap_members_checked=52)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['theorems','sources_sha256']},indent=2))
