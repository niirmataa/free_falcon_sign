#!/usr/bin/env python3
"""Write-once S05/014 provenance and scope. Hashing/organization only."""
from pathlib import Path
import json,hashlib,re,subprocess
S=Path(__file__).resolve().parent.parent;R=S.parents[3];N=S/'notes';B=S/'.build/primary_014'
BASE='bc9decf3c4f6d23d9e8982a361bae2f5f582c2ba'
FINAL={'monomial_003':('MonomialIsometry014',10),'primary_003':('PrimaryBlock014',14),
 'mass_001':('ActualMass014',5),'roots_003':('RootMoments014',17),'parseval_004':('Parseval014',9),
 'evaluation_002':('Evaluation014',11),'full_eval_001':('FullEvaluation014',8),
 'spectral_blocks_002':('SpectralBlocks014',11),'reciprocal_004':('ReciprocalSchur014',20),
 'mass_condition_001':('SamplerMassCondition014',3),'interface_001':('GeometryInterface014',0)}
CAUSES={'monomial_001':'Implicit mk_self argument, sum body needed parentheses, and API errors.',
 'monomial_002':'Degree1536 recursion allowance, integer-cast rewrite matching, extra solved-goal tactics, and unit-vector sum elimination.',
 'primary_001':'Unit-vector branches, implicit rewrite matching and injectivity indices; excessive kernel memory from expanding a constant Fin768 sum. Rejected product, including its named failed-kernel axiom, is not consumed.',
 'primary_002':'Final integer arithmetic step and unused simp arguments.',
 'roots_001':'Correct intermediate with an unnecessary-simpa warning; rejected as final log.',
 'roots_002':'Missing second power reassociation, extra solved-goal tactics and deprecated if_neg.',
 'parseval_001':'Exponent rewrite affected both sides; star_ite unavailable; first tactic branch did not close contradiction goals.',
 'parseval_002':'Native stack overflow from broad simplification; abort exit-6, retained.',
 'parseval_003':'apply_ite simplification hit recursion limit; replaced by explicit finite branch proof; unused tactic removed.',
 'evaluation_001':'Broad simplification of degree1536 evaluation exceeded recursion; replaced by explicit ring-hom rewrites.',
 'spectral_blocks_001':'selected index map required noncomputable marker; mathematical proofs printed standard axioms but the module exit was nonzero.',
 'reciprocal_001':'Subtraction rewrite, star_inv versus star_inv0, ambiguous spectrum name and consequent warnings.',
 'reciprocal_002':'One extra tactic after a solved field goal and two unused simp arguments.',
 'reciprocal_003':'Explicit map_sub preservation subgoal and real/complex projection/cast normalization.'}
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return h.hexdigest()
def pin(p):
 p=p.resolve()
 return {'path':str(p.relative_to(R)) if p.is_relative_to(R) else str(p),'sha256':sha(p)}
def load(p):return json.loads(p.read_text())
def save(name,data):
 with (N/name).open('x') as f:json.dump(data,f,indent=2,ensure_ascii=False);f.write('\n')
names=['ACTUAL_HARMONIC_014_INPUTS.json','ACTUAL_HARMONIC_014_RECEIPT.json','ACTUAL_HARMONIC_014_ATTEMPTS.json',
 'ACTUAL_HARMONIC_014_CHECKS.json','CERTIFICATE_CLASSES_014.json','KERNEL_QUEUE_014.json']
assert all(not (N/x).exists() for x in names)
def record(d):
 p=d/'receipt.json';r=load(p);so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 assert sha(d/'stdout.txt')==r['stdout_sha256'] and sha(d/'stderr.txt')==r['stderr_sha256']
 src=d/'source'/(r['module'].replace('.','/')+'.lean')
 assert sha(src)==r['source_sha256']==r['snapshot_sha256']
 return {'run':d.name,'receipt_pin':pin(p),'receipt':r,'snapshot':pin(src),'stdout':so,'stderr':se}
def clean_record(z,count):
 r=z['receipt'];so=z['stdout']
 assert r['exit_code']==0 and r['warning_count']==r['error_count']==0 and not z['stderr']
 assert not re.search(r'warning:|error:|sorryAx',so)
 assert sha(Path(r['artifact']))==r['artifact_sha256']
 assert sha(S/'formal'/(r['module']+'.lean'))==r['source_sha256']
 axes=re.findall(r'depends on axioms:\s*\[([^]]*)\]',so,re.S)
 if count:assert len(axes)+so.count('does not depend on any axioms')==count
 for a in axes:
  a=re.sub(r'\.\{[^}]*\}','',a)
  assert set(a.replace('\n','').replace(' ','').split(','))<={'propext','Classical.choice','Quot.sound'}
 z['new_theorems']=count
clean=[];drafts=[]
for p in sorted((B/'runs').glob('*/receipt.json')):
 z=record(p.parent)
 if p.parent.name in FINAL:
  module,count=FINAL[p.parent.name];assert z['receipt']['module']==module
  clean_record(z,count);clean.append(z)
 else:z['cause']=CAUSES[p.parent.name];drafts.append(z)
assert len(clean)==11 and sum(z['new_theorems'] for z in clean)==108 and len(drafts)==14
rr=load(B/'replay_001/REPLAY_RECEIPT.json');assert rr['status']=='CLEAN_FRESH_LOCAL_BUILD' and rr['new_theorems']==108
original={z['receipt']['module']:z for z in clean};replay=[]
for x in rr['modules']:
 assert sha(Path(x['receipt']))==x['receipt_sha256']
 z=record(Path(x['receipt']).parent);clean_record(z,x['new_theorems'])
 assert z['stdout']==original[x['module']]['stdout'];replay.append(z)
assert len(replay)==11
prior=load(B/'replay_001/prior_library/PINS.json');assert len(prior)==20
known={}
old=load(N/'KEY_SUPPORT_011_INPUTS.json');fresh_old={r['module']:r for r in old['fresh_dependency_receipts']}
for m,x in old['modules'].items():
 known.setdefault(m,set()).add((x['source_sha256'],x.get('artifact_sha256') or fresh_old[m]['artifact_sha256']))
for x in load(S/'.build/schur_012/lib/PINS.json')+load(S/'.build/gram_013/lib/PINS.json'):
 known.setdefault(x['module'],set()).add((x['source_sha256'],x['artifact_sha256']))
for name,receipt in [('CoefficientGram013',S/'.build/gram_013/runs/gram_011/receipt.json'),
 ('HarmonicMass012',S/'.build/schur_012/runs/harmonic_001/receipt.json')]:
 x=load(receipt);known.setdefault(name,set()).add((x['source_sha256'],x['artifact_sha256']))
for x in prior:
 assert sha(Path(x['source']))==x['source_sha256'] and sha(Path(x['artifact']))==x['artifact_sha256']
 assert (x['source_sha256'],x['artifact_sha256']) in known[x['module']]
libs=old['library_roots'];math=Path(libs['mathlib']['source']);mathbuild=Path(libs['mathlib']['build'])
external=['Mathlib.RingTheory.RootsOfUnity.Complex','Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots',
 'Mathlib.RingTheory.AdjoinRoot','Mathlib.Algebra.Ring.GeomSum','Mathlib.LinearAlgebra.Matrix.NonsingularInverse',
 'Mathlib.LinearAlgebra.Matrix.ConjTranspose','Mathlib.Data.Matrix.Mul','Mathlib.Tactic']
inputs={'base_commit':BASE,'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'prior_project_modules':prior,'prior_project_module_count':20,'current_local_library':load(B/'lib/PINS.json'),
 'library_roots':libs,'mathlib_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=math,text=True).strip(),
 'external_sources':[pin(math/(m.replace('.','/')+'.lean')) for m in external],
 'external_artifacts':[pin(mathbuild/(m.replace('.','/')+'.olean')) for m in external],
 'prior_checkpoints':[pin(N/x) for x in ['KEY_SUPPORT_011_INPUTS.json','SCHUR_012_OUTPUTS.sha256','COEFFICIENT_GRAM_013_OUTPUTS.sha256',
 'REUSE_MAP_013.md','SAMPLER_007_CERTIFICATE.json','TARGET_CONTRACT_001.tex']],
 'scope':'Current sources fresh; twenty prior artifacts pinned/reused, not a new whole-ROM rebuild or review.'}
sage=load(B/'runs/sage_002/manifest.json');assert sage['run']['exit_status']==0 and sage['run']['status']=='completed'
for x in sage['input_artifacts']:assert sha(S/x['path'])==x['sha256']==x['sha256_after']
for x in sage['outputs']:assert sha(S/x['path'])==x['sha256']
checks=load(B/'runs/sage_002/checks.json');assert len(checks['cases'])==9 and checks['monomial_shift_cases']==792
assert all(checks['negative_controls'].values()) and checks['norm_only_cannot_certify_quotient']
failed=load(B/'runs/sage_001/manifest.json');assert failed['run']['status']=='failed'
old_source=B/'runs/sage_001/source/PRIMARY_SPECTRAL_014.sage'
assert sha(old_source)==failed['input_artifacts'][0]['sha256']
attempts={'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'lean_drafts':drafts,
 'sage_failure':{'manifest':failed,'source_snapshot':pin(old_source),'cause':load(B/'runs/sage_001/cause.json'),
 'stdout':(B/'runs/sage_001/stdout.txt').read_text(),'stderr':(B/'runs/sage_001/stderr.txt').read_text()},
 'library_history':[pin(p) for p in sorted(B.glob('PINS_before_*.json'))],
 'reconciliation':'After user-turn steering, completed mass_condition/interface receipts were read and validated; no job was restarted just because its process handle was unavailable.',
 'scope':'All failed mathematical source snapshots retained in persistent ignored runtime. Failed sorryAx/named kernel error products are not accepted.'}
receipt={'id':'S05_ACTUAL_HARMONIC_014','condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'base_commit':BASE,'status':'KERNEL_ACTUAL_HARMONIC_TO_MASS_CONDITIONAL_ON_KEY_HARMONIC_BOUND',
 'new_theorems':108,'clean_lean_runs':clean,'fresh_replay':{'summary':rr,'summary_pin':pin(B/'replay_001/REPLAY_RECEIPT.json'),
 'runs':replay,'all_stdout_byte_identical_to_original':True},
 'cost_seconds':{'final_modules_and_interface':sum(z['receipt']['elapsed_seconds'] for z in clean),
 'all_initial_lean_attempts':sum(z['receipt']['elapsed_seconds'] for z in clean+drafts),
 'fresh_replay':sum(z['receipt']['elapsed_seconds'] for z in replay),'sage_final':sage['run']['runtime_seconds'],
 'sage_failed':failed['run']['runtime_seconds']},
 'cost_scope':'Proof/check wall times, not sampler cost; every run has its own caps in the embedded receipt.',
 'sage_manifest':sage,'sage_manifest_validation':'valid evidence record; mathematical interpretation requires review',
 'latex':{'source':pin(N/'ACTUAL_HARMONIC_014.tex'),'compiler':'Codex desktop built-in editor','status':'success'},
 'mathematical_inputs':['usual exact NTRU/public/inverse equations on the same material','ternary f/g','canonical exact H(f,g)>=991'],
 'derived_not_assumed':['monomial multiplication isometry','primary cap4608','canonical Parseval','actual spectral A/C/D',
 'reciprocal Schur equality','all-target/all-temperature common mass scale','sampler007 exact three-temperature M'],
 'remaining':['whole emitted KeyGen/source harmonic kernel and canonical source-root dictionary','full finite-box/implementation/failure/moment/cost certificate007',
 'Q-BIND and quantum mechanisms/PRG/resources'],
 'independent_review':False,'new_cryptographic_assumptions':[],'final_QROM_theorem_eligible':False}
queue=load(N/'KERNEL_QUEUE_013.json');queue['previous']=pin(N/'KERNEL_QUEUE_013.json')
for x in queue['selected_path']:
 if x['id']=='K-SCHUR-FIBER':x.update(status='KERNEL_ACTUAL_HARMONIC_TO_MASS',
  available='014 actual monomial cap, canonical Parseval, spectral blocks, reciprocal Schur, whole fiber and exact M007',
  remaining='Geometric implication closed under NTRU/public/inverse/ternarity/H>=991. Source discharge belongs to K-HARMONIC-SOURCE and K-KEY-INSTANCE, not an assumed spectral equality.')
 if x['id']=='K-HARMONIC-SOURCE':x.update(available='H3 ROOT/STABLE and010 mixed composition;014 proves canonical roots/evaluation/harmonic-to-mass',
  remaining='Exact source-root/representative correspondence and full source-to-canonical H>=991 kernel for all emitted material')
 if x['id']=='K-FULL-MOMENT-007':x['available']='007 textual full J/P, ROM generic law algebra,011 OnKeys and014 kernel M from canonical H>=991'
queue['closed_scoped_step']={'id':'K-ACTUAL-HARMONIC-014','status':'108_KERNEL_DECLARATIONS_AND_EXACT_M007_INTERFACE',
 'scope':'One larger geometry package; full source/Sign/sampler/QROM obligations remain.'}
classes={'id':'S05_CLASSES_014','previous':pin(N/'CERTIFICATE_CLASSES_013.json'),
 'artifacts':[{'artifact':pin(S/'formal'/(name+'.lean')),'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'new_theorems':count,'status':'KERNEL_IN_STATED_SCOPE' if count else 'EXACT_INTERFACE_INSPECTION'} for name,count in FINAL.values()],
 'harmonic_bound':'Source proof obligation, not a new cryptographic assumption.',
 'mass_error':'2^-34 relative infinite-mass error, not the J/P excess e',
 'new_cryptographic_assumptions':[],'model_changes':[],'final_QROM_theorem_eligible':False}
for name,data in zip(names,[inputs,receipt,attempts,checks,classes,queue]):save(name,data)
files=[S/'formal'/(name+'.lean') for name,_ in FINAL.values()]+[N/x for x in names]+[N/x for x in
 ['BUILD_PRIMARY_014.py','REPLAY_GEOMETRY_014.py','SEAL_GEOMETRY_014.py','PRIMARY_SPECTRAL_014.sage',
 'ACTUAL_HARMONIC_014.tex','ACTUAL_HARMONIC_014_CHECKPOINT.md','TODO_QUANTITATIVE_GEOMETRY_014.md']]
with (N/'ACTUAL_HARMONIC_014_OUTPUTS.sha256').open('x') as f:
 for p in sorted(files):f.write(sha(p)+'  '+str(p.relative_to(S))+'\n')
print(json.dumps({'status':'SEALED_SCOPED_KERNEL_GEOMETRY','new_theorems':108,'fresh_modules_and_interface':11,
 'retained_lean_drafts':len(drafts),'prior_modules':20,'output_files':len(files)},indent=2))
