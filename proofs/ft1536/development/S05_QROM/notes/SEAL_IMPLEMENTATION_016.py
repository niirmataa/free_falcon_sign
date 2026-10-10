#!/usr/bin/env python3
"""Exact provenance seal of016. No mathematical checking is delegated to Python."""
from pathlib import Path
import json,hashlib,re,subprocess
S=Path(__file__).resolve().parent.parent;R=S.parents[3];B=S/'.build/implementation_016';N=S/'notes'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':str(p.relative_to(R)),'sha256':sha(p)}
write=lambda name,data:(N/name).write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n')
ORDER=['FiniteLaw016','FiniteIndex016','CapExecution016','RejectionDomination016','BitTapes016','ProductLaw016','CapDomination016','CoarseBudget016','SamplerCode016','SamplerSupport016','SamplerAC016','ProgramLaw016','RawConditioning016','RawPairDomination016','ActualTables016','ImplementationBridge016','ActualInterface016']
LABELS=['finitelaw001','index001','cap002','reject004','bits002','product004','capdom003','budget002','code004','support002','ac002','law012','rawcond007','rawpair002','actual001','bridge002','interface001']
COUNTS=[7,1,8,8,7,6,3,6,5,11,3,6,6,5,6,5,3]
replay=json.loads((B/'replay_001/REPLAY_RECEIPT.json').read_text());assert replay['new_audited_exports']==sum(COUNTS)==96
source_commit=json.loads((B/'SOURCE_COMMIT_RECEIPT.json').read_text())['commit']
for line in (N/'IMPLEMENTATION_016_SOURCE_FILES.sha256').read_text().splitlines():
 expected,rel=line.split('  ',1);p=S/rel;assert sha(p)==expected
 assert hashlib.sha256(subprocess.check_output(['git','show',source_commit+':'+str(p.relative_to(R))],cwd=R)).hexdigest()==expected
prior=json.loads((B/'replay_001/prior/PINS.json').read_text());assert len(prior)==74
inputs=[]
for r in prior:
 assert sha(Path(r['source']))==r['source_sha256'] and sha(Path(r['artifact']))==r['artifact_sha256']
 inputs.append({k:r[k] for k in ['module','source','source_sha256','artifact','artifact_sha256']})
records=[]
def clean(d,count):
 r=json.loads((d/'receipt.json').read_text());so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 assert r['exit_code']==r['error_count']==r['warning_count']==0 and not se and 'sorryAx' not in so
 assert sha(Path(r['artifact']))==r['artifact_sha256'];assert sha(Path(r['command'][-1]))==r['source_sha256']
 assert len(re.findall(r'depends on axioms:|does not depend on any axioms',so))==count
 for axioms in re.findall(r'depends on axioms:\s*\[([^]]*)\]',so):
  assert set(axioms.replace('\n','').split(', '))<={'propext','Classical.choice','Quot.sound'}
 return r,so
for m,label,n in zip(ORDER,LABELS,COUNTS):
 d=B/'runs'/label;fresh=B/'replay_001/runs'/m;r,so=clean(d,n);rr,sso=clean(fresh,n);assert so==sso
 src=S/'formal'/(m+'.lean');assert sha(src)==r['source_sha256']==rr['source_sha256']
 records.append({'module':m,'audited_exports':n,'source':pin(src),'final_receipt':pin(d/'receipt.json'),
  'fresh_receipt':pin(fresh/'receipt.json'),'final_seconds':r['elapsed_seconds'],'fresh_seconds':rr['elapsed_seconds'],
  'fresh_artifact_sha256':rr['artifact_sha256'],'stdout':so})
control,control_out=clean(B/'runs/control001',3);assert sha(N/'CONTROL_FALLBACK_016.lean')==control['source_sha256']
gen=json.loads((B/'generated/MANIFEST.json').read_text())['modules'];generated=[]
for k,x in enumerate(gen):
 src=Path(x['source']);assert sha(src)==x['sha256']
 r,_=clean(B/'runs'/('table'+str(k).zfill(2)+'001'),0);rr,_=clean(B/'replay_001/runs'/x['module'],0)
 assert r['source_sha256']==rr['source_sha256']==sha(src)
 generated.append({**x,'fresh_artifact_sha256':rr['artifact_sha256'],'fresh_seconds':rr['elapsed_seconds']})
known={r['module'] for r in inputs}|set(ORDER)|{x['module'] for x in gen}
for row in inputs+[{'module':m,'source':str(S/'formal'/(m+'.lean'))} for m in ORDER]+gen:
 for line in Path(row['source']).read_text().splitlines():
  if line.startswith('import '):
   for dep in line.split()[1:]:assert dep in known or dep.startswith(('Mathlib','Lean','Std','Batteries','Qq','Aesop','Init')),(row['module'],dep)
# Retain all finite attempts, including clean superseded/debug runs. Generated literals
# are reproduced by the pinned generator rather than duplicated in this receipt.
causes={
 'targetlaw001':'Isolated Run2 directory shadowed the existing Run2 namespace; use a complete module root.',
 'polynomialref001':'Inherited proof stack overflow under8MiB; same source succeeded with bounded64MiB stack.',
 'cap001':'Unused generic instances and missing classical decidability in the law proof.',
 'bits001':'Missing Fin type annotation; unused simp argument.',
 'product001':'Deprecated/superfluous tactics, wrong ordered-product lemma and finite-enumeration normalization.',
 'product002':'Stack overflow while identifying inherited/canonical box enumeration; explicit instance boundary fixed it.',
 'support001':'Let-bound trial not reduced before split; missing integer cast normalization and deprecated spelling.',
 'ac001':'Ambiguous samplerLaw name; qualified the intended Run2 definition.',
 'budget001':'Positivity tactic needed explicit unfolding of R.',
 'bridge001':'Dependent DecidablePred prevented an ordinary rewrite; used definitionally identical predicate.',
 'code001':'Deep finite Seed instance synthesis needed explicit component instances.',
 'code002':'Finite/decidable Seed instance and tactic layout errors.',
 'code003':'Remaining tactic layout/Seed decidability.',
 'control001':'Clean finite negative control: shared complement versus fresh complement.',
}
attempts=[]
for d in sorted((B/'runs').iterdir()):
 if not (d/'receipt.json').exists():continue
 r=json.loads((d/'receipt.json').read_text());m=r['module']
 if m.startswith('PublicTables016'):continue
 src=Path(r['command'][-1]);so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 final=d.name in LABELS or d.name in ['targetlaw002','rawproduct001','polynomialref002','control001']
 cause=causes.get(d.name)
 if cause is None:
  if final:cause='Clean final source in stated scope.'
  elif d.name.startswith('reject') or d.name.startswith('rawpair') or d.name=='capdom002' or d.name=='product003':cause='Mathematics accepted; unused instance/binder or tactic warning removed in final source.'
  elif d.name.startswith('law') or d.name.startswith('rawcond') or d.name.startswith('probe'):cause='Retained elaboration/diagnostic route: opaque computation, finite-enumeration/implicit-instance transport or parser details. Failed run is not proof evidence. Final route uses explicit legacy instances, explicit unfolding and generalized match scrutinee.'
  else:cause='Superseded attempt; exact source and diagnostics retained below.'
 attempts.append({'label':d.name,'module':m,'receipt':pin(d/'receipt.json'),'exit_code':r['exit_code'],'warnings':r['warning_count'],
  'status':'FINAL' if final else 'RETAINED_SUPERSEDED','cause':cause,'source_sha256':sha(src),'source':src.read_text(),'stdout':so,'stderr':se})
sage=[]
for label in ['sage001','sage002','sage003','sage004','local_leaves001','literal_binding001','generator001']:
 d=B/label;src=d/'source.sage';out=(d/'stdout.txt').read_text();err=(d/'stderr.txt').read_text();res=d/'RESULT.json'
 status='COMPLETED' if not err else 'FAILED_RETAINED'
 cause={'sage001':'False coarse2^-70 fallback-envelope assertion; corrected to the exact interval(2^-70,2^-69).',
  'sage002':'All arithmetic assertions passed, then Sage Integer JSON serialization failed.',
  'sage003':'Arithmetic passed. Correlation example comment omitted the complement; final004 explicitly enumerates the intended2/4 outcomes and corrects that description.',
  'sage004':'Corrected complete finite enumeration and all exact arithmetic pass.',
  'local_leaves001':'Rigorous balls support four local budgets using inherited007 normalizer interval; not kernel leaf instances.',
  'literal_binding001':'Every92162 public literal and every chunk index checked by independent lexical readback.',
  'generator001':'Generated13 modules containing the exact public integer literals.'}[label]
 sage.append({'label':label,'status':status,'cause':cause,'source':pin(src),'source_text':src.read_text(),'stdout':out,'stderr':err,'result':json.loads(res.read_text()) if res.exists() else None})
assert not (B/'sage004/stderr.txt').read_text() and 'PASS:' in (B/'sage004/stdout.txt').read_text()
assert sha(B/'sage004/source.sage')==sha(N/'CHECK_IMPLEMENTATION_016.sage')
assert json.loads((B/'sage003/RESULT.json').read_text())['alpha_exact']==json.loads((B/'sage004/RESULT.json').read_text())['alpha_exact']
for label in ['local_leaves001','literal_binding001']:
 assert not (B/label/'stderr.txt').read_text() and (B/label/'RESULT.json').exists()
write('IMPLEMENTATION_016_ATTEMPTS.json',{'policy':'Retained append-only runtime; source/log copies below. Compiler-error sorryAx and failed controls are not evidence.','lean':attempts,'sage':sage})
write('IMPLEMENTATION_016_INPUTS.json',{'base_commit':'efce319823364df27ca2053478a1f6959f47e924','source_commit':source_commit,
 'prior_project_modules':inputs,'source_manifest':pin(N/'IMPLEMENTATION_016_SOURCE_FILES.sha256'),'public_literals':pin(N/'LARGE_ARTIFACTS_016.json'),
 'library_roots':json.loads((N/'BOX_MOMENT_015_INPUTS.json').read_text())['library_roots'],'inherited_fresh_builds':[{k:json.loads((B/'runs'/label/'receipt.json').read_text())[k] for k in ['module','source_sha256','artifact_sha256','exit_code','warning_count','elapsed_seconds','command']} for label in ['targetlaw002','rawproduct001','polynomialref002']]})
write('IMPLEMENTATION_016_CHECKS.json',{'verdict':'conditional on a named input','unconditional_result':'ActualTables016.actual_all_h_ac: support for the concrete reference sampler for every h and context; not an all-h small moment.',
 'review_kind':'AUTHOR_SELF_REVIEW_NOT_INDEPENDENT','passed':['Exact finite-bit value/uniform and tape partition laws','All cap/fallback branches including cap0 and zero acceptance','Actual literal table instance with unconditional norm/signed16/no-none/AC','Full product, rejection normalization cancellation and both cap laws derived from code','Same exact M gives global Gaussian tail; no extra tilt','Moment2^-47 only under four named local fields and M','Public initial/context independence and same covered public-key law','96 final/replay axiom audits and3 separate negative-control proofs, standard axioms only','30-module fresh closure:17 proof and13 generated data;74 inherited modules pinned','92162 literals independently checked; integer acceptance recomputed; local bounds remain numeric','Machine operation cost not inferred from tape slots; CDF linear and coefficient multiplication costs explicit limitations'],
 'conditional_local_inputs':['PairLeaves.rejection','PairLeaves.raw','PairLeaves.zero_mass','CubeLeaf'],
 'open':['Kernel modulo/CDF counts and rounding-to-Gaussian proof','Kernel fixed normalizer and cube-density instances','Operational implementation cost and optimized Python/C source equivalence','Actual emitted-key law and canonical harmonic source coverage','Whole Sign/PRG source binding and quantum mechanisms/composition'],
 'proofreading':{'scope':'new sources and standalone theorem note','mathematical_correction':'The finite shared-fallback example was clarified to use1-b and explicitly enumerated; earlier source retained. False2^-70 auxiliary budget corrected to2^-69 with kernel negative bound preserved.','latex':'Codex native compiler success, no repairs'}})
write('IMPLEMENTATION_016_RECEIPT.json',{'id':'S05_IMPLEMENTATION_016','status':'PARTIAL_PROOF_CONDITIONAL_KERNEL_REFERENCE_SAMPLER','base_commit':'efce319823364df27ca2053478a1f6959f47e924','source_commit':source_commit,'audited_exports':96,'separate_control_theorems':3,
 'proof_modules':records,'generated_modules':generated,'fresh_replay':pin(B/'replay_001/REPLAY_RECEIPT.json'),'control':{'receipt':pin(B/'runs/control001/receipt.json'),'stdout':control_out},
 'fresh_closure_seconds':sum(x['elapsed_seconds'] for x in replay['modules']),'prior_modules_reused':74,
 'proof_build_limits':{'cores':1,'cpu_soft_seconds':110,'cpu_hard_seconds':115,'wall_seconds':120,'address_space_GiB':8,'Lean_memory_MiB':4096,'fresh_stack_MiB':64},
 'execution_resources':{'bit_tape_positions':24662538240,'logical_pair_attempt_slots':24084480,'fresh_cube_positions':30720,'meaning':'Kernel arithmetic/declared tape shape only. Not a bound on evaluated recursive calls, primitive operations, repeated reads, memory or precomputation.','reference_cdf':'linear first-hit search; not Sage bisect cost','reference_multiplication':'existing per-coefficient double sum; not Sage multiplication cost','machine_bit_cost_certificate':False,'source_Python_C_equivalence':False},
 'mathematical_scope':{'all_h_AC_actual_literals':True,'all_h_small_moment':False,'full_second_excess_if_local_leaves_and_M':'<=2^-47','PairLeaves_instance':False,'CubeLeaf_instance':False,'actual_KeyGen_coverage':False,'QROM_security_theorem':False},
 'latex':{'source':pin(N/'IMPLEMENTATION_016.tex'),'compiler':'Codex desktop native compiler','result':'success','repairs':0},'runner_pins':[pin(N/x) for x in ['BUILD_IMPLEMENTATION_016.py','REPLAY_IMPLEMENTATION_016.py','SEAL_IMPLEMENTATION_016.py','BUILD_KEY_SUPPORT_011.py']],
 'source_history':pin(N/'IMPLEMENTATION_016_SOURCE_FILES.sha256'),'input_hashes_are_not_mathematics':True,'independent_review':False,'push':False})
write('CERTIFICATE_CLASSES_016.json',{'id':'S05_CLASSES_016','previous':pin(N/'CERTIFICATE_CLASSES_015.json'),
 'artifacts':[{'artifact':pin(S/'formal'/(m+'.lean')),'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'audited_exports':c,'status':'KERNEL_IN_EXACT_STATED_SCOPE'} for m,c in zip(ORDER,COUNTS)],
 'open_local_fields':[{'name':x,'class':'proof_obligation','condition':'Q-SAMPLER','status':'NUMERIC_SUPPORT_NOT_KERNEL_INSTANCE'} for x in ['PairLeaves.rejection','PairLeaves.raw','PairLeaves.zero_mass','CubeLeaf']],
 'Q_RESC':{'class':'proof_obligation','status':'OPEN_OPERATIONAL_COST','available':'logical slot counts and compilation receipts; neither proves execution cost'},
 'model':{'class':'model','description':'independent fair fixed-bit tape, existing finite coefficient Sign, all modeled failures retained'},
 'new_cryptographic_assumptions':[],'model_changes':[],'may_consume_kernel_results_with_exact_hypotheses':True,'full_QROM_claim':False})
q=json.loads((N/'KERNEL_QUEUE_015.json').read_text());q['previous']=pin(N/'KERNEL_QUEUE_015.json')
for x in q['selected_path']:
 if x['id']=='K-SAMPLER-007':x.update(status='KERNEL_REFERENCE_CODE_LOCAL_LEAVES_OPEN',available='Concrete finite-tape actualSampler and pinned public literal tables, exact cap/product/full-law semantics, all-h AC',remaining='Fill PairLeaves(actual tables) and CubeLeaf; operational costs and optimized Python/C equivalence remain separate')
 if x['id']=='K-FULL-MOMENT-007':x.update(status='KERNEL_CODE_TO_MOMENT_IF_LOCAL_LEAVES_AND_M',available='016 derives whole-code domination from raw local fields and M, then015 gives2^-47 including aborts and same key law',remaining='Actual instances of four local analytic fields; emitted-key source coverage still separate')
q['selected_path'].insert(3,{'id':'K-LOCAL-TABLE-LEAVES-017','condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'status':'OPEN_KERNEL_INSTANCES','available':'Exact raw-code law, all table literals, Sage acceptance/convolution and rigorous numeric margins; coarse composition constants kernel','remaining':'Modulo/CDF count identity; rounding-to-Gaussian raw pointwise bound; fixed normalizer and cube-density proofs','final_gate':True})
for i,x in enumerate(q['selected_path'],1):x['priority']=i
q['closed_scoped_step']={'id':'K-IMPLEMENTATION-016','status':'96_KERNEL_EXPORTS_PLUS3_NEGATIVE_CONTROLS','scope':'Concrete reference execution/support and conditional local-leaf-to-full-moment chain; not completed analytic or source/cost instance'}
write('KERNEL_QUEUE_016.json',q)
print(json.dumps({'audited_exports':96,'negative_control_theorems':3,'new_generated_modules':len(gen),'fresh_seconds':sum(x['elapsed_seconds'] for x in replay['modules']),'retained_lean_runs':len(attempts),'retained_sage_runs':len(sage)}))
