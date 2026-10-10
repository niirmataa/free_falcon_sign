#!/usr/bin/env python3
"""Write-once provenance for S05/013; no mathematical computation in Python."""
from pathlib import Path
import json,hashlib,re,subprocess
S=Path(__file__).resolve().parent.parent;R=S.parents[3];N=S/'notes';B=S/'.build/gram_013'
BASE='75ae62d660c28aba862c33cee5d9477aa0da0dd2'
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return h.hexdigest()
def pin(p):return {'path':str(p.resolve().relative_to(R)) if p.resolve().is_relative_to(R) else str(p.resolve()),'sha256':sha(p)}
def load(p):return json.loads(p.read_text())
def save(name,data):
 with (N/name).open('x') as f:json.dump(data,f,indent=2,ensure_ascii=False);f.write('\n')
CASES={
 'gram_001':'Import failed because a partial Run2 directory in the 012 library shadowed the complete 011 root. Isolated 013 library resolves it.',
 'gram_002':'Cardinality decide recursion, casted matrix-vector equality and incorrect Boolean sum lemma name.',
 'gram_003':'Definitional unfolding hit recursion limits; explicit sum rewrites needed; sum order and unused simp warning.',
 'gram_004':'Global add_comm simplification hit heartbeat limit; replaced by one final commutation.',
 'gram_005':'Clean 12-theorem intermediate, before adding inverse, positivity and affine fiber.',
 'gram_006':'Symmetry case split, cast/scalar equality, and ext picked matrix coordinate instead of linear-map input.',
 'gram_007':'Explicit integer ring-hom casting and global map_zsmul API required; unused simp argument.',
 'gram_008':'Wrong argument order of map_zsmul.',
 'gram_009':'Coercion of AddEquiv needed explicit change before rewriting pack_unpack.',
 'gram_010':'Generic one-sided inverse elaboration recursed; explicit Matrix.mul_eq_one_comm_of_equiv resolves it.'}
for name in ['COEFFICIENT_GRAM_013_INPUTS.json','COEFFICIENT_GRAM_013_RECEIPT.json',
 'COEFFICIENT_GRAM_013_ATTEMPTS.json','COEFFICIENT_GRAM_013_CHECKS.json','KERNEL_QUEUE_013.json','CERTIFICATE_CLASSES_013.json']:
 assert not (N/name).exists(),name
runs=[]
for p in sorted((B/'runs').glob('gram_*/receipt.json')):
 d=p.parent;r=load(p);src=d/'source/CoefficientGram013.lean';so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 assert sha(src)==r['source_sha256']==r['snapshot_sha256']
 assert sha(d/'stdout.txt')==r['stdout_sha256'] and sha(d/'stderr.txt')==r['stderr_sha256']
 z={'run':d.name,'receipt_pin':pin(p),'receipt':r,'snapshot':pin(src),'stdout':so,'stderr':se}
 if d.name=='gram_011':
  assert r['exit_code']==0 and r['warning_count']==0 and not se
  assert not re.search(r'warning:|error:|sorryAx',so)
  assert sha(S/'formal/CoefficientGram013.lean')==r['source_sha256']
  assert sha(Path(r['artifact']))==r['artifact_sha256']
  axes=re.findall(r'depends on axioms:\s*\[([^]]*)\]',so,re.S)
  assert len(axes)+so.count('does not depend on any axioms')==27
  for a in axes:assert set(a.replace('\n','').replace(' ','').split(','))<={'propext','Classical.choice','Quot.sound'}
  final=z
 else:z['cause']=CASES[d.name];runs.append(z)
assert len(runs)==10
old=load(N/'KEY_SUPPORT_011_INPUTS.json');older={r['module']:r for r in old['fresh_dependency_receipts']}
oldmods=old['modules'];newer={r['module']:r for r in load(S/'.build/schur_012/lib/PINS.json')}
libs=load(B/'lib/PINS.json')
for e in libs:
 assert sha(Path(e['source']))==e['source_sha256'] and sha(Path(e['artifact']))==e['artifact_sha256']
 origin=newer.get(e['module']) or oldmods[e['module']]
 assert e['source_sha256']==origin['source_sha256']
 expected=origin.get('artifact_sha256') or older[e['module']]['artifact_sha256']
 assert e['artifact_sha256']==expected
assert len(libs)==9
reuse={
 'run2/formal/Run2/ActualNTRUFiber.lean':['coordinates','coordinates_formula','gaussian_fiber_in_basis'],
 'run2/formal/Run2/ShiftedGaussian.lean':['shifted_summable','shifted_mass_bounds'],
 'run2/formal/Run2/TriangularGaussian.lean':['tower_summable','triangular_mass_bounds'],
 'run2/formal/Run2/T5ScalarMass.lean':['uniform_shifted_mass_3072'],
 'run2/formal/GramLDL.lean':['BasisLeafAlgebra','gram_ldl_scalar_pivots'],
 't5/formal/Run2/T5Cholesky.lean':['pointsEquiv','quad_choleskyTower'],
 't5/formal/Run2/T5CholeskyCert.lean':['CholeskyKeyCert','scale_choleskyTower','keyTowerCert_of_cholesky'],
 't5/formal/Run2/T5TowerMass.lean':['scale_tiltTower','localExponent_tiltTower','infFiberMass_eq_quad'],
 't5/formal/Run2/T5GateBudget.lean':['gateCoefficientCap','product_sandwich'],
 't5/formal/Run2/T5Tail.lean':['TiltCert','tilt_sum_bound','coord_tail_bound'],
 't5/formal/Run2/T5BoxTransport.lean':['BoxTransportCert','flat_reject_of_towers'],
 'source3/formal/Source3/KeygenMakeRetryTransport.lean':['CertEntryFrame','retry_entry','readTmp_of_binding_attempt']}
reusepins=[]
for rel,exports in reuse.items():
 p=S.parent/'T12_1'/rel;text=p.read_text();locators={}
 for export in exports:
  matches=[i for i,line in enumerate(text.splitlines(),1) if re.match(r'(?:noncomputable )?(?:def|theorem|structure) '+export+r'\b',line)]
  assert len(matches)==1,(rel,export,matches);locators[export]=matches[0]
 committed=subprocess.check_output(['git','show',BASE+':'+str(p.relative_to(R))]);assert hashlib.sha256(committed).hexdigest()==sha(p)
 reusepins.append({'artifact':pin(p),'exports':locators,'status':'TYPE_READ_FOR_REUSE; no new replay of this module unless among the nine imported pins'})
math=Path(old['library_roots']['mathlib']['source']);mathbuild=Path(old['library_roots']['mathlib']['build'])
mathnames=['Mathlib.LinearAlgebra.Matrix.ToLin','Mathlib.LinearAlgebra.Matrix.PosDef',
 'Mathlib.Data.Matrix.Mul','Mathlib.LinearAlgebra.Matrix.NonsingularInverse','Mathlib.Algebra.Module.LinearMap.Defs']
inputs={'base_commit':BASE,'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'project_dependency_pins':libs,'dependency_count':9,'older_input_manifest':pin(N/'KEY_SUPPORT_011_INPUTS.json'),
 'prior_geometry_manifest':pin(N/'SCHUR_012_OUTPUTS.sha256'),'library_roots':old['library_roots'],
 'mathlib_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=math,text=True).strip(),
 'direct_mathlib_sources':[pin(math/(m.replace('.','/')+'.lean')) for m in mathnames],
 'direct_mathlib_artifacts':[pin(mathbuild/(m.replace('.','/')+'.olean')) for m in mathnames],
 'reuse_map_inputs':reusepins,'source3_scope':pin(S.parent/'T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_058.json'),
 'scope':'Only nine existing project modules imported for the new algebra; reuse-map inspection is not a new independent review of T5/source3.'}
save('COEFFICIENT_GRAM_013_INPUTS.json',inputs)
save('COEFFICIENT_GRAM_013_CHECKS.json',load(B/'runs/sage_001/checks.json'))
save('COEFFICIENT_GRAM_013_ATTEMPTS.json',{'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'history':runs,'scope':'All mathematical source snapshots retained. Failed elaborations, including printed sorryAx, are rejected; gram005 is a clean superseded intermediate.'})
save('COEFFICIENT_GRAM_013_RECEIPT.json',{'id':'S05_COEFFICIENT_GRAM_013','base_commit':BASE,
 'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'status':'KERNEL_CHECKED_ACTUAL_COEFFICIENT_GRAM_ALGEBRA_NOT_FULL_SOURCE_INSTANCE',
 'kernel_theorems':27,'lean_final':final,'lean_version':subprocess.check_output([
 str(Path(old['library_roots']['lean']['build']).parents[1]/'bin/lean'),'--version'],text=True).strip(),
 'source':pin(S/'formal/CoefficientGram013.lean'),'orchestrator':pin(N/'BUILD_GRAM_013.py'),
 'proof_cost_seconds':{'final_lean':final['receipt']['elapsed_seconds'],
 'all_lean_attempts':final['receipt']['elapsed_seconds']+sum(r['receipt']['elapsed_seconds'] for r in runs),
 'sage':load(B/'runs/sage_001/manifest.json')['run']['runtime_seconds']},
 'cost_scope':'Proof/check costs only; not sampler execution cost.',
 'sage_manifest':load(B/'runs/sage_001/manifest.json'),'sage_manifest_pin':pin(B/'runs/sage_001/manifest.json'),
 'sage_validation':'valid evidence record; mathematical interpretation requires review',
 'latex':{'source':pin(N/'COEFFICIENT_GRAM_013.tex'),'compiler':'Codex desktop built-in','status':'success'},
 'hypotheses':{'actual_energy':'arbitrary integer f,g,F,G,u; exact fixed coefficient quotient',
 'positive_gram_and_affine_shift':'exact NTRU fG-gF=18433',
 'whole_fiber':'same material plus h*f=g and fInv*f=1 modulo18433'},
 'not_assumed':['gramEq','quadEq','positive Gram','inverse matrix'],
 'remaining':['coordinate permutation to selected two-block order','primary diagonal cap and spectral Schur/Parseval',
 'bounded Cholesky/T5 or concrete harmonic012 instance','kernel source harmonic and actual emitted-law/Sign bindings',
 'finite box and all branches/moment/cost of sampler007','all remaining QROM mechanisms'],
 'new_cryptographic_assumptions':[],'independent_review':False,'final_QROM_theorem_eligible':False})
q=load(N/'KERNEL_QUEUE_012.json');q['previous']=pin(N/'KERNEL_QUEUE_012.json');q['reuse_map']=pin(N/'REUSE_MAP_013.md')
for e in q['selected_path']:
 if e['id']=='K-SCHUR-FIBER':
  e.update(status='ACTUAL_COEFFICIENT_ENERGY_AND_POSDEF_KERNEL; QUANTITATIVE_SPECTRAL_INSTANCE_OPEN',
   available='013 actual coefficient matrix, NTRU inverse, positive Gram, affine energy and full-fiber reindex; 012 generic mass; existing T5 tower/Cholesky/scale/tilt',
   remaining='Chosen two-block permutation, primary cap and reciprocal spectral Schur/Parseval; bounded factorization/interface into old T5 or012. No repeat of generic mass/tower/temperature proofs.')
q['closed_scoped_step']={'id':'K-COEFFICIENT-GRAM-013','status':'KERNEL_ALGEBRA_WITH_USUAL_NTRU_PUBLIC_EQUATIONS',
 'scope':'Concrete matrix/energy/inverse/positive Gram/full-fiber identity; not source execution or quantitative mass.'}
save('KERNEL_QUEUE_013.json',q)
save('CERTIFICATE_CLASSES_013.json',{'id':'S05_CLASSES_013','previous':pin(N/'CERTIFICATE_CLASSES_012.json'),
 'artifacts':[{'artifact':pin(S/'formal/CoefficientGram013.lean'),'condition_class':'proof_obligation',
 'conditions':['Q-SAMPLER'],'kernel_theorems':27,'status':'KERNEL_ALGEBRA_UNDER_USUAL_NTRU_PUBLIC_EQUATIONS'},
 {'artifact':pin(N/'COEFFICIENT_GRAM_013_CHECKS.json'),'condition_class':'proof_obligation',
 'conditions':['Q-SAMPLER'],'status':'FINITE_EXACT_CONTROLS_ONLY'}],
 'new_cryptographic_assumptions':[],'model_changes':[],'final_QROM_theorem_eligible':False})
files=[S/'formal/CoefficientGram013.lean']+[N/name for name in ['BUILD_GRAM_013.py','SEAL_GRAM_013.py',
 'REUSE_MAP_013.md','COEFFICIENT_GRAM_013.sage','COEFFICIENT_GRAM_013.tex','COEFFICIENT_GRAM_013_CHECKPOINT.md',
 'COEFFICIENT_GRAM_013_INPUTS.json','COEFFICIENT_GRAM_013_RECEIPT.json','COEFFICIENT_GRAM_013_ATTEMPTS.json',
 'COEFFICIENT_GRAM_013_CHECKS.json','KERNEL_QUEUE_013.json','CERTIFICATE_CLASSES_013.json']]
with (N/'COEFFICIENT_GRAM_013_OUTPUTS.sha256').open('x') as f:
 for p in sorted(files):f.write(sha(p)+'  '+str(p.relative_to(S))+'\n')
print(json.dumps({'status':'SEALED_SCOPED_ALGEBRA','kernel_theorems':27,'dependencies_checked':len(libs),
 'retained_prior_attempts':len(runs),'output_files':len(files)},indent=2))
