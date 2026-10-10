#!/usr/bin/env python3
"""Fresh structural closure. Large finite witnesses are pinned, not re-enumerated."""
from pathlib import Path
import hashlib,json,shutil,sys,types
S=Path(__file__).resolve().parent.parent;W=S/'.build/local_leaves_017'
ORDER=['PairNormalizer017','CubeUniform017','CubeDensity017','SmallExp017',
 'GaussianPolynomial017','ModuloCounts017','CDFSelection017','CountProbability017',
 'PairInfinite017','PairTail017','CentralMass017','GaussianSandwich017',
 'GaussianCheck017','GaussianChunks017','GaussianLiterals017','CDFProbability017',
 'PairProbability017','PairGeometry017','PairBudget017','PairDensity017','PairLeaves017',
 'LiteralControls017','BoundedAddressObstruction017']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py']
assert sha(P)==expected
B=W/sys.argv[2];BASE=B/'prior'
h=types.ModuleType('helper');h.__file__=str(P)
helper=P.read_text().split("\nif sys.argv[1]=='prepare':")[0].replace("'-s8192'","'-s65536'")
exec(compile(helper,str(P),'exec'),h.__dict__);h.BUILD=B
libs=json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots']

def add_pin(r):
 src=Path(r['source']);art=Path(r['artifact'])
 assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
 dst=BASE/(r['module'].replace('.','/')+'.olean');dst.parent.mkdir(parents=True,exist_ok=True)
 assert not dst.exists()
 for p in art.parent.glob(art.name+'*'):shutil.copyfile(p,dst.parent/p.name)
 return {**r,'artifact':str(dst),'origin_artifact':str(art)}

if sys.argv[1]=='structural':
 B.mkdir(parents=True,exist_ok=False);BASE.mkdir();prior=[]
 for r in json.loads((W/'lib/PINS.json').read_text()):
  if r['module'].endswith('017') and r['module'] in ORDER:continue
  if r['module'].startswith('GaussianWitness017'):continue
  if r['module']=='ActualInterface017':continue
  prior.append(add_pin(r))
 assert len(prior)==113,len(prior)
 (BASE/'PINS.json').write_text(json.dumps(prior,indent=2)+'\n')
 sequence=ORDER;results=[]
elif sys.argv[1]=='final':
 results=json.loads((B/'STRUCTURAL_RECEIPT.json').read_text())['modules']
 prior=json.loads((BASE/'PINS.json').read_text());names={r['module'] for r in prior}
 selected=json.loads((W/'witness_sources003/SELECTED.json').read_text())
 witness_names={r['module'] for r in selected['selected']}|{selected['aggregate']['module']}
 for r in json.loads((W/'lib/PINS.json').read_text()):
  if r['module'] in witness_names:
   assert r['module'] not in names
   prior.append(add_pin(r));names.add(r['module'])
 assert witness_names<=names and len(witness_names)==212
 old=BASE/'PINS_before_witness.json';assert not old.exists();shutil.copyfile(BASE/'PINS.json',old)
 (BASE/'PINS.json').write_text(json.dumps(prior,indent=2)+'\n')
 sequence=['GaussianPrefix017','TableWidths017','ActualInterface017']
else:raise ValueError('structural|final FRESH_LABEL')

for name in sequence:
 src=S/'formal'/(name+'.lean');d=B/'runs'/name
 if not h.compile_one(src,d,name,B/'lib',libs,BASE):sys.exit(1)
 r=json.loads((d/'receipt.json').read_text());so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 assert r['exit_code']==r['warning_count']==r['error_count']==0 and not se and 'sorryAx' not in so
 count=src.read_text().count('#print axioms ')
 assert so.count('depends on axioms:')+so.count('does not depend on any axioms')==count
 for block in so.split('depends on axioms:')[1:]:
  atoms=block.split('[')[1].split(']')[0].replace('\n','').replace(' ','').split(',')
  assert set(atoms)<={'propext','Classical.choice','Quot.sound'},atoms
 results.append({'module':name,'source':str(src),'source_sha256':sha(src),
  'audited_exports':count,'artifact':r['artifact'],'artifact_sha256':r['artifact_sha256'],
  'receipt':str(d/'receipt.json'),'receipt_sha256':sha(d/'receipt.json'),
  'elapsed_seconds':r['elapsed_seconds']})
out=B/('STRUCTURAL_RECEIPT.json' if sys.argv[1]=='structural' else 'REPLAY_RECEIPT.json');assert not out.exists()
out.write_text(json.dumps({'status':'CLEAN_FRESH_STRUCTURAL_CLOSURE' if sys.argv[1]=='structural' else 'CLEAN_FRESH_FINAL_INTERFACE',
 'modules':results,'prior_pin_sha256':sha(BASE/'PINS.json'),'runner_sha256':sha(Path(__file__)),
 'finite_witness_policy':'Each original generated witness gets its own clean kernel build; final structural replay reuses exact pinned witness artifacts rather than repeating the large finite enumeration.'},indent=2)+'\n')
print(json.dumps({'status':'CLEAN','modules':len(results),'exports':sum(r['audited_exports'] for r in results)}))
