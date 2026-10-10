#!/usr/bin/env python3
"""Bounded local S05 builds; reuse pinned compiler definitions and libraries.
Never executes the older helper's CLI or touches another worker's runtime.
"""
from pathlib import Path
import types,json,sys,hashlib,shutil
S=Path(__file__).resolve().parent.parent
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py']
assert sha(P)==expected
marker="\nif sys.argv[1]=='prepare':";text=P.read_text();assert text.count(marker)==1
h=types.ModuleType('s05_compiler');h.__file__=str(P)
exec(compile(text.split(marker)[0],str(P),'exec'),h.__dict__)
h.BUILD=S/'.build/gram_013'
libs=json.loads((h.BASE/'PINS.json').read_text())['library_roots']
LIB=h.BUILD/'lib'
if sys.argv[1]=='prepare':
 LIB.mkdir(parents=True,exist_ok=False)
 base=json.loads((h.BASE/'PINS.json').read_text())['modules']
 extra={r['module']:r for r in json.loads((S/'.build/schur_012/lib/PINS.json').read_text())}
 records={}
 def visit(module):
  if module in records or module.startswith(('Mathlib','Lean','Std','Init','Batteries','Qq','Aesop')):return
  if module in extra:
   r=extra[module];src=Path(r['source']);art=Path(r['artifact']);assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
  else:
   r=base[module];src=h.BASE/'sources'/(module.replace('.','/')+'.lean');art=h.BASE/'lib'/(module.replace('.','/')+'.olean')
   assert sha(src)==r['source_sha256']
  target=LIB/(module.replace('.','/')+'.olean');target.parent.mkdir(parents=True,exist_ok=True)
  for file in art.parent.glob(art.name+'*'):shutil.copyfile(file,target.parent/file.name)
  records[module]={'module':module,'source':str(src),'source_sha256':sha(src),'artifact':str(target),'artifact_sha256':sha(target),'origin_artifact':str(art)}
  for line in src.read_text().splitlines():
   if line.startswith('import '):
    for dep in line.split()[1:]:visit(dep)
 for module in ['Run2.ActualNTRUFiber','SchurGeometry012']:visit(module)
 (LIB/'PINS.json').write_text(json.dumps(list(records.values()),indent=2)+'\n')
 print(json.dumps({'pinned_project_modules':len(records)}));sys.exit(0)
name,label=sys.argv[1:3];d=h.BUILD/'runs'/label
ok=h.compile_one(S/'formal'/(name+'.lean'),d,name,d/'lib',libs,LIB)
sys.exit(0 if ok else 1)
