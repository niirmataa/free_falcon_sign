#!/usr/bin/env python3
"""Scoped compilation of existing Gaussian dependencies and new S05 geometry.
Uses the committed S05/011 runner as a library; never starts an upstream job.
"""
from pathlib import Path
import types,json,sys,hashlib,shutil
S=Path(__file__).resolve().parent.parent;B=S/'.build/schur_012';LIB=B/'lib'
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
# Load only the pinned utility definitions, not its historical CLI dispatcher.
expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py']
assert hashlib.sha256(P.read_bytes()).hexdigest()==expected
text=P.read_text();marker="\nif sys.argv[1]=='prepare':";assert text.count(marker)==1
helper=types.ModuleType('s05_compiler');helper.__file__=str(P)
exec(compile(text.split(marker)[0],str(P),'exec'),helper.__dict__)
helper.BUILD=B
base=json.loads((helper.BASE/'PINS.json').read_text());libs=base['library_roots']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
if sys.argv[1]=='dependencies':
 LIB.mkdir(parents=True,exist_ok=False);records=[]
 for name,run in [('SchurGeometry012','block_006'),('SpectralDiagonal012','spectral_003')]:
  d=B/'runs'/run;r=json.loads((d/'receipt.json').read_text());src=S/'formal'/(name+'.lean');art=d/(name+'.olean')
  assert r['exit_code']==0 and sha(src)==r['source_sha256'] and sha(art)==r['olean_sha256']
  assert not (d/'stderr.txt').read_text() and 'warning:' not in (d/'stdout.txt').read_text()
  for f in d.glob(name+'.olean*'):
   shutil.copyfile(f,LIB/f.name)
  records.append({'module':name,'source':str(src),'source_sha256':sha(src),'artifact':str(LIB/art.name),'artifact_sha256':sha(LIB/art.name),'receipt':str(d/'receipt.json')})
 for module in ['Run2.A2Theta','Run2.ShiftedGaussian','Run2.TriangularGaussian','Run2.T5ThetaNumeric','Run2.T5ScalarMass']:
  src=S.parents[3]/'proofs/ft1536/development/T12_1/run2/formal'/(module.replace('.','/')+'.lean')
  out=B/'runs'/('dependency_'+module.replace('.','_'))
  if not helper.compile_one(src,out,module,LIB,libs):sys.exit(1)
  r=json.loads((out/'receipt.json').read_text());assert r['warning_count']==0
  records.append({'module':module,'source':str(src),'source_sha256':sha(src),'artifact':r['artifact'],'artifact_sha256':r['artifact_sha256'],'receipt':str(out/'receipt.json')})
 (LIB/'PINS.json').write_text(json.dumps(records,indent=2)+'\n')
elif sys.argv[1]=='module':
 name,label=sys.argv[2:4];out=B/'runs'/label
 if not helper.compile_one(S/'formal'/(name+'.lean'),out,name,out/'lib',libs,LIB):sys.exit(1)
else:raise ValueError('dependencies | module NAME FRESH_LABEL')
