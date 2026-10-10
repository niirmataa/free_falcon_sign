#!/usr/bin/env python3
"""Seal exact S05-015 source/log metadata. Mathematics stays in Lean/Sage."""
from pathlib import Path
import json,hashlib,re,subprocess
S=Path(__file__).resolve().parent.parent;R=S.parents[3];B=S/'.build/box_moment_015';N=S/'notes'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':str(p.relative_to(R)),'sha256':sha(p)}
write=lambda n,d:(N/n).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n')
ORDER=['BoxSupport015','BoxTail015','NormTail015','AcceptedMarginal015','FullMoment015','SamplerInterface015']
LABELS=['support001','tail003','norm002','marginal002','full003','interface001'];COUNTS=[9,8,5,9,13,3]
replay=json.loads((B/'replay_001/REPLAY_RECEIPT.json').read_text());assert replay['new_theorems']==47
prior=json.loads((B/'replay_001/prior_library/PINS.json').read_text());assert len(prior)==65
inputs=[]
for x in prior:
 src=Path(x['source']);art=Path(x['artifact']);assert sha(src)==x['source_sha256'] and sha(art)==x['artifact_sha256']
 inputs.append({k:x[k] for k in ['module','source','source_sha256','artifact','artifact_sha256']})
# Closed import graph: no project import silently obtained from a fallback root.
available={r['module'] for r in inputs}|set(ORDER)
for x in inputs+[{'module':m,'source':str(S/'formal'/(m+'.lean'))} for m in ORDER]:
 for line in Path(x['source']).read_text().splitlines():
  if line.startswith('import '):
   for dep in line.split()[1:]:assert dep in available or dep.startswith(('Mathlib','Lean','Std','Batteries','Qq','Aesop','Init')),(x['module'],dep)
final=[]
for name,label,count in zip(ORDER,LABELS,COUNTS):
 src=S/'formal'/(name+'.lean');d=B/'runs'/label;r=json.loads((d/'receipt.json').read_text());rd=B/'replay_001/runs'/name;rr=json.loads((rd/'receipt.json').read_text())
 for run,rec in [(d,r),(rd,rr)]:
  assert rec['exit_code']==rec['warning_count']==rec['error_count']==0
  assert sha(src)==rec['source_sha256']==rec['snapshot_sha256'];assert sha(Path(rec['artifact']))==rec['artifact_sha256']
  out=(run/'stdout.txt').read_text();assert not (run/'stderr.txt').read_text();assert 'sorryAx' not in out
  assert len(re.findall(r'depends on axioms:|does not depend on any axioms',out))==count
  for ax in re.findall(r'depends on axioms:\s*\[([^]]*)\]',out):assert set(ax.replace('\n','').split(', '))<={'propext','Classical.choice','Quot.sound'}
 assert (d/'stdout.txt').read_bytes()==(rd/'stdout.txt').read_bytes()
 final.append({'module':name,'new_theorems':count,'source':pin(src),'final_receipt':pin(d/'receipt.json'),'replay_receipt':pin(rd/'receipt.json'),'final_seconds':r['elapsed_seconds'],'replay_seconds':rr['elapsed_seconds'],'artifact_sha256':rr['artifact_sha256'],'stdout':(rd/'stdout.txt').read_text()})
failed_causes={
 'tail001':'Elaboration only: protected tsum comparison name, inverse/one-div rewrite, positivity of opaque upper.',
 'tail002':'Elaboration only: explicit function/set arguments to tsum_subtype_le; unnecessarySeqFocus warning.',
 'norm001':'Mathematical proof accepted; one unnecessarySeqFocus warning. Superseded by clean norm002.',
 'marginal001':'Elaboration only: normalize zMass/acceptedTotal, correct rewrite direction, implicit type parameter of Law.uniform.',
 'full001':'Elaboration only: omitted natural exponent argument to pow_le_pow_left₀.',
 'full002':'Clean strengthened certificate; full003 adds actual-harmonic consumer without changing the bound.'}
attempts=[]
for d in sorted((B/'runs').iterdir()):
 if d.name.startswith('dependency_') or d.name=='inherited_support001':continue
 r=json.loads((d/'receipt.json').read_text());src=d/'source'/(r['module']+'.lean')
 attempts.append({'label':d.name,'receipt':pin(d/'receipt.json'),'exit_code':r['exit_code'],'warning_count':r['warning_count'],'status':'FINAL' if d.name in LABELS else 'RETAINED_SUPERSEDED','cause':failed_causes.get(d.name,'Clean final mathematical source.'),'source_sha256':sha(src),'source':src.read_text(),'stdout':(d/'stdout.txt').read_text(),'stderr':(d/'stderr.txt').read_text()})
fresh=[]
for d in sorted((B/'runs').iterdir()):
 if not(d.name.startswith('dependency_') or d.name=='inherited_support001'):continue
 r=json.loads((d/'receipt.json').read_text());assert r['exit_code']==r['warning_count']==r['error_count']==0
 fresh.append({'module':r['module'],'receipt':pin(d/'receipt.json'),'source_sha256':r['source_sha256'],'artifact_sha256':r['artifact_sha256'],'seconds':r['elapsed_seconds']})
assert len(fresh)==17
sage=[]
for label,checks in [('sage001',8),('sage002',10)]:
 d=B/label;out=(d/'stdout.txt').read_text();assert f'PASS {checks} exact rational certificates' in out;assert not (d/'stderr.txt').read_text()
 sage.append({'label':label,'status':'PASS_EXACT_QQ_CHECKS','source':pin(d/'source.sage'),'source_text':(d/'source.sage').read_text(),'stdout':out,'stderr':'','mathematical_authority':'Sage standard preparser, QQ; 512-bit balls diagnostic only','elapsed_seconds':None,'elapsed_note':'Wall duration was not separately recorded; no sampler runtime is inferred.'})
assert sha(B/'sage002/source.sage')==sha(N/'CHECK_BOX_MOMENT_015.sage')
oldreceipt=json.loads((N/'SAMPLER_007_RECEIPT.json').read_text())
write('BOX_MOMENT_015_INPUTS.json',{'base_commit':'80233ea4132ba1bbb3065b3b5fc5e6d291e4e710','prior_project_modules':inputs,'fresh_inherited_builds':fresh,'library_roots':json.loads((B/'DEPENDENCIES.json').read_text())['library_roots'],'legacy_007_cost_pin':pin(N/'SAMPLER_007_RECEIPT.json')})
write('BOX_MOMENT_015_ATTEMPTS.json',{'policy':'Append-only runtime attempts retained; source and diagnostic text copied here. Compiler-error sorryAx outputs are not evidence.','lean':attempts,'sage':sage})
write('BOX_MOMENT_015_CHECKS.json',{'verdict':'conditional on a named input','review_kind':'AUTHOR_SELF_REVIEW_NOT_INDEPENDENT','claim':'M and full-outcome domination J <= (1+2^-60)J0 imply AC(J,P) and second(J,P)<=1+2^-47','dependency_chain':['014 exact M','positive M => Summable','exact finite restriction and outside energy','box lower bound and finite flatness','exact tN norm rejection','accepted mass partition and centered energy from ROM','full mixture including none and joint_bound from ROM','domination transfer','011 resetInitial and SAME covered key law'],'checks':[{'item':x,'status':'passed'} for x in ['Quantifiers: common K before all c, only exact three temperatures','Finite box and energy identical to GaussianFiberTilt/PublicSimulation','Strict norm Q<B and both norm-cap and emission failures retained','L(none) unrestricted; no success conditioning in final J/P','J relative to P, with separate AC at P=0','Centered mean cancellation, not pointwise square','Conservative constants and strengthened budget explicit','No runtime efficiency inferred from law certificate','All-state wrapper uses public initial, same key law used once','47 declarations in final and fresh logs; only standard Lean axioms','Source text/pins and closed project import graph verified']], 'conditional_inputs':['Actual sampler code domination, all coins/cap/fallback outcomes','Actual emitted-key law support and canonical harmonic source bridge'], 'open':['Executable Lean sampler007 and machine resource certificate','Full source Sign/PRG binding','Quantum mechanisms and composition'], 'proofreading':{'scope':'six new modules, theorem note and checkpoint','mathematical_token_changes':'none during final self-review','latex':'native compiler success; source preserved; no PDF export'}})
write('BOX_MOMENT_015_RECEIPT.json',{'id':'S05_BOX_MOMENT_015','status':'CONDITIONAL_KERNEL_FULL_REPLY_MOMENT','base_commit':'80233ea4132ba1bbb3065b3b5fc5e6d291e4e710','new_theorems':47,'final_modules':final,'fresh_replay':pin(B/'replay_001/REPLAY_RECEIPT.json'),'prior_modules_reused_in_replay':65,'fresh_inherited_modules_built':17,'proof_build_cost':{'final_seconds':sum(x['final_seconds'] for x in final),'fresh_replay_seconds':sum(x['replay_seconds'] for x in final),'fresh_dependency_seconds':sum(x['seconds'] for x in fresh),'per_compile_limits':{'cores':1,'cpu_seconds':110,'wall_seconds':120,'address_space_GiB':8,'Lean_memory_MiB':4096}},'sampler_cost':{'status':'INHERITED_TEXTUAL_007_NOT_CERTIFIED_BY_015','pin':pin(N/'SAMPLER_007_RECEIPT.json'),'recorded':oldreceipt['cost'],'source_domination_instance':False,'machine_bit_cost_certificate':False},'budgets':{'infinite_mass_error':'2^-34','unnormalized_box_loss_over_K':'<=2^-160','finite_flatness':'2^-32','norm_rejection':'<2^-24','domination_factor':'1+2^-60','new_full_second_excess':'<=2^-47','historical_007_corollary':'<=2^-44','envelope_above_2^-48':'kernel proved; not an actual-law lower bound'},'latex':{'source':pin(N/'BOX_MOMENT_015.tex'),'compiler':'Codex desktop native compiler','result':'success','repairs':0},'runner_pins':[pin(N/p) for p in ['BUILD_BOX_015.py','REPLAY_BOX_015.py','SEAL_BOX_015.py','BUILD_KEY_SUPPORT_011.py']],'no_new_cryptographic_assumption':True,'model_changes':[],'QROM_security_theorem':False,'independent_review':False,'push':False})
write('CERTIFICATE_CLASSES_015.json',{'id':'S05_CLASSES_015','previous':pin(N/'CERTIFICATE_CLASSES_014.json'),'artifacts':[{'artifact':pin(S/'formal'/(m+'.lean')),'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'new_theorems':n,'status':'KERNEL_IN_STATED_SCOPE'} for m,n in zip(ORDER,COUNTS)],'Q_RESC':'Inherited007 cost is textual;015 proof-build time is not sampler cost. OPEN instance.','model':'Existing finite Sign with classical signing; every modeled none retained. Source/API binding remains open.','new_cryptographic_assumptions':[],'final_QROM_theorem_eligible':False})
q=json.loads((N/'KERNEL_QUEUE_014.json').read_text());q['previous']=pin(N/'KERNEL_QUEUE_014.json')
for item in q['selected_path']:
 if item['id']=='K-FULL-MOMENT-007':item.update(status='KERNEL_CONDITIONAL_FULL_MOMENT_015',available='Exact M => finite box/flatness/rejection => full AC and J/P <=1+2^-47 under named code-domination input; initial/all-state/same-key wrappers kernel',remaining='Supply actual Sampler007 implementation domination and source coverage; conditional constructors are not instances')
 if item['id']=='K-SAMPLER-007':item['remaining']='NEXT: formal pair/vector cap law and both fallback branches; actual Sampler code dominance <=1+2^-60; separate bit-cost/runtime receipt'
q['closed_scoped_step']={'id':'K-BOX-MOMENT-015','status':'47_KERNEL_DECLARATIONS','scope':'Three-temperature M to full Option-valued reply moment, public initial and same key law, under explicit domination/coverage inputs.'}
write('KERNEL_QUEUE_015.json',q)
print(json.dumps({'sealed_new_theorems':47,'prior_pins':len(inputs),'fresh_inherited':len(fresh),'replay_seconds':sum(x['replay_seconds'] for x in final)}))
