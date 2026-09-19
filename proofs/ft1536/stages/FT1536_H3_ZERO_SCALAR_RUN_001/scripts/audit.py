"""Kernel and provenance audit. Universal analytical B is labelled separately."""
import json,re,subprocess,sys
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();old=['Floor','Comparator','Proposal','CDF','OrderedResidual','GuardPrefix'];new=['ValueDomain','SourceFloor','ZeroRho','BitErrors','PackOf','ErrorArithmetic','EndpointFacts','LiteralAdd','ModelMain'];mods=old+new
if '--build' in sys.argv:
 p=subprocess.run([sys.executable,'-B','scripts/lean.py']+mods,timeout=180);assert p.returncode==0
decls=[];sources={}
for mod in mods:
 p=W/'formal'/(mod+'.lean');text=p.read_text();sources[str(p.relative_to(W))]=sha(p)
 assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M) and not re.search(r'\b(sorry|admit|native_decide)\b',text)
 ns=re.search(r'^namespace (\w+)',text,re.M)
 for name in re.findall(r'^theorem ([\w.]+)',text,re.M):decls.append(ns.group(1)+'.'+name)
names=['NumericCenter','exponent_from_value','FLOOR_ZERO','C_INT_BRIDGE','OF_EXACT','RHO_CLOSED','EXACT_RESIDUAL_366',
 'SUB_CENTER_CONTRACT','SUB_RESIDUAL_CONTRACT','R_DELTA_DOMAIN','CONSUME_SUB_RESIDUAL','ORDERED_ZERO_TERMINAL']
audit='import LiteralAdd\nimport ModelMain\nset_option pp.universes true\n'+'\n'.join('#check @ZeroScalar.'+n for n in names)+'\n'+'\n'.join('#print axioms '+n for n in decls)+'\n'
types='import LiteralAdd\nset_option pp.all true\n'+'\n'.join('#check @ZeroScalar.'+n for n in names)+'\n'
types+='\n'.join('#print ZeroScalar.'+n for n in ['NumericCenter','FLOOR_ZERO','C_INT_BRIDGE','CONSUME_SUB_RESIDUAL'])+'\n'
for name,data in [('ZeroAudit',audit),('ZeroTypes',types)]:
 p=W/'formal'/(name+'.lean')
 if p.exists():assert p.read_text()==data
 else:p.write_text(data)
 sources[str(p.relative_to(W))]=sha(p)
p=subprocess.run([sys.executable,'-B','scripts/lean.py','ZeroAudit','ZeroTypes'],capture_output=True,timeout=60)
(W/'logs/audit_driver.stdout').write_bytes(p.stdout);(W/'logs/audit_driver.stderr').write_bytes(p.stderr);assert p.returncode==0,(p.stdout.decode(),p.stderr.decode())
latest={r['module']:r for r in map(json.loads,(W/'artifacts/kernel.jsonl').read_text().splitlines())}
final=W/'logs/final';final.mkdir(exist_ok=True);receipts=[]
for mod in mods+['ZeroAudit','ZeroTypes']:
 r=latest[mod];assert r['exit_code']==0 and not r['timeout'] and r['source_sha256']==sha(W/'formal'/(mod+'.lean'))
 for stream in ['stdout','stderr']:
  p=W/r[stream];data=p.read_bytes();assert sha(p)==r[stream+'_sha256'];assert not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',data),(mod,data.decode())
  (final/(mod+'.'+stream)).write_bytes(data)
 receipts.append(r)
text=(final/'ZeroAudit.stdout').read_text();allowed={'propext','Classical.choice','Quot.sound'}
for name in decls:assert "'"+name+"'" in text,name
for deps in re.findall(r'depends on axioms: \[([^]]*)\]',text):assert {re.sub(r'\.\{[^}]*\}$','',n) for n in deps.split(', ')}<=allowed,deps
boot=verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','e8eb2b091e9396d08afbdd3f8b4adebbebf97e7a0890306c5cf07c8e7beb4099');assert len(boot)==73
I=W/'inputs/bootstrap';assert {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==71
for r in orig['files']:assert boot[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
for r in json.loads((W/'inputs/provenance.json').read_text()):assert sha(W/r['copy'])==r['sha256']
for mod in old:assert sha(W/'formal'/(mod+'.lean'))==boot['H3/formal/'+mod+'.lean']
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h
out=dict(status='PASS_KERNEL_SUBSET_AND_INPUT_BINDING',modules=len(mods)+2,checked_theorems=len(decls),new_theorems=sum(n.startswith('ZeroScalar.') for n in decls),
 theorems=decls,sources_sha256=sources,all_final_logs_clean=True,axioms_allowed=sorted(allowed),bootstrap_members=73,inherited_modules_unchanged=6,
 audit_stdout_sha256=sha(final/'ZeroAudit.stdout'),full_types_sha256=sha(final/'ZeroTypes.stdout'),
 B_universal_proof_kind='ANALYTICAL_SOURCE_PROOF_WITH_KERNEL_INTEGER_LEMMAS',B_fully_kernelized=False,
 consumer_analytic_premise_explicit=True,analytic_proof_sha256=sha(W/'ANALYTIC_PROOF.md'),
 H3_range_proved=False,global_reachability_proved=False,sampler_law_proved=False)
(W/'artifacts/formal_audit.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/final_kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['theorems','sources_sha256']},indent=2))
