#!/usr/bin/env python3
"""Seal S05/012 provenance, never mathematics. Existing outputs are immutable.
The local run directories and the pinned S05/011 dependency snapshot are required.
Run from any cwd: python3 -B notes/SEAL_SCHUR_012.py
"""
from pathlib import Path
import hashlib,json,re,subprocess

S=Path(__file__).resolve().parent.parent; R=S.parents[3]; N=S/'notes'
B=S/'.build/schur_012'; OLD=S/'.build/key_support_011/dependencies'
BASE='ff5d03ee62d17eb514f94d6d63123f6e8bf4f0fd'
FINAL={'block_006':('SchurGeometry012',17),'spectral_003':('SpectralDiagonal012',6),
 'gaussian_004':('GaussianFromSchur012',10),'blockmass_002':('BlockGaussian012',5),
 'temperature_002':('TemperatureScale012',6),'harmonic_001':('HarmonicMass012',3)}
CAUSES={
 'block_001':'Completed with instance/linter warnings; rejected as final log.',
 'block_002':'Missing real StarOrderedRing instance and linter warnings.',
 'block_003':'Clean 13-theorem intermediate; superseded by atom expansion.',
 'block_004':'Wrong dot-product lemma arguments and scalarOffset precedence.',
 'block_005':'Completed with one unused simp argument warning.',
 'spectral_001':'Deprecated import and matrix-sum rewriting errors.',
 'spectral_002':'Pointwise diagonal_mul needed explicit multiplication indices.',
 'gaussian_001':'Points inverse and Gaussian atom rewriting errors.',
 'gaussian_002':'Ring goal treated translated-tail and expanded-tail as distinct terms.',
 'gaussian_003':'Clean eight-theorem intermediate; then added summability and positivity.',
 'blockmass_001':'Summability rewrites unfolded weight and produced style warnings.',
 'temperature_001':'Missing expected type for anonymous by proof before trans.'}
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
def pin(p):
 p=p.resolve()
 return {'path':str(p.relative_to(S)) if p.is_relative_to(S) else str(p),'sha256':sha(p)}
def load(p):return json.loads(p.read_text())
def save(name,value):
 with (N/name).open('x') as f:json.dump(value,f,indent=2,ensure_ascii=False);f.write('\n')
def run_record(d):
 r=load(d/'receipt.json'); so=(d/'stdout.txt').read_text(); se=(d/'stderr.txt').read_text()
 assert sha(d/'stdout.txt')==r['stdout_sha256'] and sha(d/'stderr.txt')==r['stderr_sha256']
 snaps=list((d/'source').rglob('*.lean')) if (d/'source').is_dir() else list(d.glob('*.lean'))
 assert len(snaps)==1 and sha(snaps[0])==r['snapshot_sha256']==r['source_sha256']
 return {'receipt_pin':pin(d/'receipt.json'),'receipt':r,'source_snapshot':pin(snaps[0]),'stdout':so,'stderr':se}

assert all(not (N/f).exists() for f in ['SCHUR_012_INPUTS.json','SCHUR_012_RECEIPT.json',
 'SCHUR_012_ATTEMPTS.json','SCHUR_012_CHECKS.json','CERTIFICATE_CLASSES_012.json','KERNEL_QUEUE_012.json'])
clean=[];hist=[];fresh=[]
for p in sorted((B/'runs').glob('*/receipt.json')):
 d=p.parent; z=run_record(d); r=z['receipt']
 if d.name in FINAL:
  name,count=FINAL[d.name]
  assert r['exit_code']==0 and not z['stderr'] and not re.search(r'warning:|error:|sorryAx',z['stdout'])
  assert sha(S/'formal'/(name+'.lean'))==r['source_sha256']
  assert z['stdout'].count('depends on axioms:')+z['stdout'].count('does not depend on any axioms')==count
  for line in z['stdout'].splitlines():
   if 'depends on axioms:' in line:
    assert set(re.search(r'\[(.*)\]',line).group(1).split(', '))<= {'propext','Classical.choice','Quot.sound'}
  a=Path(r['artifact']) if 'artifact' in r else d/(name+'.olean')
  assert sha(a)==r.get('artifact_sha256',r.get('olean_sha256'))
  z.update(module=name,kernel_theorems=count);clean.append(z)
 elif d.name.startswith('dependency_'):
  assert r['exit_code']==0 and not z['stderr'] and not z['stdout']
  assert sha(Path(r['artifact']))==r['artifact_sha256']
  fresh.append(z)
 else:z['cause']=CAUSES[d.name];hist.append(z)
assert len(clean)==6 and sum(z['kernel_theorems'] for z in clean)==47 and len(fresh)==5

# Verify the entire available baseline snapshot against the old, committed pins.
# Only a small dependency closure is consumed by 012; checking availability is not rebuilding it.
old=load(N/'KEY_SUPPORT_011_INPUTS.json'); pins=load(OLD/'PINS.json')
fresh_old={x['module']:x for x in old['fresh_dependency_receipts']};available=[]
for module,rec in pins['modules'].items():
 src=OLD/'sources'/(module.replace('.','/')+'.lean'); art=OLD/'lib'/(module.replace('.','/')+'.olean')
 assert sha(src)==rec['source_sha256']
 expected=rec.get('artifact_sha256') or fresh_old[module]['artifact_sha256']
 assert sha(art)==expected
 available.append({'module':module,'snapshot':pin(src),'artifact':pin(art)})
assert len(available)==700
libpins=load(B/'lib/PINS.json')
for z in libpins:
 assert sha(Path(z['source']))==z['source_sha256'] and sha(Path(z['artifact']))==z['artifact_sha256']
libs=pins['library_roots']; math=Path(libs['mathlib']['source']); direct={}
for source in [S/'formal'/(n+'.lean') for n,_ in FINAL.values()]:
 for line in source.read_text().splitlines():
  if line.startswith('import Mathlib.'):
   mod=line.split()[1]; direct[mod]={'source':pin(math/(mod.replace('.','/')+'.lean')),
    'artifact':pin(Path(libs['mathlib']['build'])/(mod.replace('.','/')+'.olean'))}
lean=Path(libs['lean']['build']).parents[1]/'bin/lean'
inputs={'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'base_commit':BASE,
 'inherited_inputs':pin(N/'KEY_SUPPORT_011_INPUTS.json'),'inherited_pin_file':pin(OLD/'PINS.json'),
 'available_baseline_snapshot':available,'local_library':libpins,
 'library_roots':libs,'direct_mathlib_imports':direct,'lean':pin(lean),
 'lean_version':subprocess.check_output([str(lean),'--version'],text=True).strip(),
 'mathlib_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=math,text=True).strip(),
 'scope':'Five Gaussian dependencies freshly built; 700 old snapshot modules checked as available, not all newly built or consumed.',
 'source_inputs':[pin(S/'formal'/(name+'.lean')) for name,_ in FINAL.values()]+[pin(N/x) for x in
 ['RUN_SCHUR_012.py','BUILD_MASS_012.py','BUILD_KEY_SUPPORT_011.py','SCHUR_012.sage','SEAL_SCHUR_012.py']]}
save('SCHUR_012_INPUTS.json',inputs)
save('SCHUR_012_CHECKS.json',load(B/'runs/sage_001/checks.json'))
setup=B/'runs/setup_failure_001'
save('SCHUR_012_ATTEMPTS.json',{'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'scope':'No failed elaboration is accepted as a proof. Snapshots are preserved in ignored persistent runtime.',
 'drafts':hist,'setup_failure':{'cause':(setup/'cause.txt').read_text(),
 'files':[pin(p) for p in sorted(setup.iterdir()) if p.is_file()],
 'old_pre_guard_directory':str(S/'.build/key_support_011/dependencies/runs/FT1536_Divergence_retry3')},
 'library_pin_history':[pin(p) for p in sorted(B.glob('lib_PINS_before_*.json'))]})
save('SCHUR_012_RECEIPT.json',{'id':'S05_SCHUR_012','condition_class':'proof_obligation',
 'conditions':['Q-SAMPLER'],'status':'KERNEL_CHECKED_CONDITIONAL_MASS_NOT_FT1536_INSTANCE',
 'base_commit':BASE,'packaging_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip(),
 'final_FT1536_QROM_theorem_eligible':False,'clean_lean_runs':clean,'fresh_dependency_runs':fresh,
 'execution_seconds':{'final_six_modules':sum(z['receipt']['elapsed_seconds'] for z in clean),
 'five_fresh_dependencies':sum(z['receipt']['elapsed_seconds'] for z in fresh),
 'all_lean_attempts':sum(z['receipt']['elapsed_seconds'] for z in clean+fresh+hist),
 'sage':load(B/'runs/sage_001/manifest.json')['run']['runtime_seconds']},
 'cost_scope':'These are proof/check execution costs, not sampler runtime. Sampler007 cost receipt unchanged.',
 'sage_manifest':load(B/'runs/sage_001/manifest.json'),'sage_manifest_pin':pin(B/'runs/sage_001/manifest.json'),
 'sage_manifest_validation':'valid evidence record; mathematical interpretation requires review',
 'latex':{'source':pin(N/'SCHUR_012.tex'),'compiler':'Codex built-in desktop editor','status':'success'},
 'remaining':['Concrete FT1536 coefficient Gram / Parseval / reciprocal Schur identities on the same material',
 'Kernel source harmonic bound and complete emitted-key law instance',
 'Whole-fiber identification with this block mass; finite box and sampler007 full law/moment/cost',
 'Quantum hash/embedding/reprogramming/PRG/resources and composition'],
 'all_h_certificate':False,'independent_review':False})
q=load(N/'KERNEL_QUEUE_011.json');q['previous']=pin(N/'KERNEL_QUEUE_011.json')
for item in q['selected_path']:
 if item['id']=='K-SCHUR-FIBER':
  item.update(status='GENERIC_GEOMETRY_AND_MASS_KERNEL_CHECKED_CONCRETE_INSTANCE_OPEN',
   available='47 kernel theorems012; exact atom, summability, common scale, temperature and harmonic consumer',
   remaining='Concrete coefficient-Gram/Parseval/reciprocal-Schur instance and identification with whole FT1536 fibers; source harmonic separately tracked')
q['closed_scoped_step']={'id':'K-SCHUR-MASS-012','status':'47_KERNEL_THEOREMS_WITH_EXACT_NAMED_INPUTS',
 'scope':'Conditional generic and concrete-parameter mass theorem; not the actual FT1536 instance or full sampler moment'}
save('KERNEL_QUEUE_012.json',q)
save('CERTIFICATE_CLASSES_012.json',{'id':'S05_CLASSES_012','previous':pin(N/'CERTIFICATE_CLASSES_011.json'),
 'classes':{'primary':'proof_obligation','conditions':['Q-SAMPLER'],
 'new_cryptographic_assumptions':[],'model_changes':[]},
 'certificates':[{'artifact':pin(S/'formal'/(name+'.lean')),'condition_class':'proof_obligation',
 'conditions':['Q-SAMPLER'],'kernel_theorems':count,'status':'KERNEL_CHECKED_IN_ITS_STATED_HYPOTHESES'} for name,count in FINAL.values()],
 'mass_error':'2^-34, not 2^-40 or the J/P excess e',
 'sampler_moment_and_actual_source_instance':'OPEN','final_FT1536_QROM_theorem_eligible':False})
print(json.dumps({'status':'SEALED_SCOPED_CONDITIONAL','kernel_theorems':47,'fresh_dependencies':5,
 'baseline_snapshot_checked':len(available),'prior_drafts_retained':len(hist)},indent=2))
