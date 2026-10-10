#!/usr/bin/env python3
"""Bounded S05/014 build, with a complete isolated project-module root."""
from pathlib import Path
import types,json,sys,hashlib,shutil
S=Path(__file__).resolve().parent.parent;B=S/'.build/primary_014';LIB=B/'lib'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py']
assert sha(P)==expected
marker="\nif sys.argv[1]=='prepare':";text=P.read_text();assert text.count(marker)==1
h=types.ModuleType('s05_compiler');h.__file__=str(P)
exec(compile(text.split(marker)[0],str(P),'exec'),h.__dict__);h.BUILD=B
libs=json.loads((h.BASE/'PINS.json').read_text())['library_roots']
if sys.argv[1]=='prepare':
 LIB.mkdir(parents=True,exist_ok=False);records=[]
 for r in json.loads((S/'.build/gram_013/lib/PINS.json').read_text()):
  assert sha(Path(r['source']))==r['source_sha256'] and sha(Path(r['artifact']))==r['artifact_sha256']
  art=Path(r['artifact']);dest=LIB/(r['module'].replace('.','/')+'.olean');dest.parent.mkdir(parents=True,exist_ok=True)
  for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,dest.parent/f.name)
  records.append({**r,'origin_artifact':str(art),'artifact':str(dest)})
 name='CoefficientGram013';d=S/'.build/gram_013/runs/gram_011';r=json.loads((d/'receipt.json').read_text())
 src=S/'formal'/(name+'.lean');art=Path(r['artifact']);assert r['exit_code']==0 and r['warning_count']==0
 assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
 for f in art.parent.glob(name+'.olean*'):shutil.copyfile(f,LIB/f.name)
 records.append({'module':name,'source':str(src),'source_sha256':sha(src),'artifact':str(LIB/art.name),
  'artifact_sha256':sha(art),'receipt':str(d/'receipt.json')})
 (LIB/'PINS.json').write_text(json.dumps(records,indent=2)+'\n')
 print(json.dumps({'modules':len(records)}));sys.exit(0)
if sys.argv[1]=='install':
 name,label=sys.argv[2:4];d=B/'runs'/label;r=json.loads((d/'receipt.json').read_text())
 src=S/'formal'/(name+'.lean');art=Path(r['artifact']);assert r['exit_code']==0 and r['warning_count']==0
 assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
 assert not (LIB/art.name).exists()
 for f in art.parent.glob(name+'.olean*'):shutil.copyfile(f,LIB/f.name)
 pinfile=LIB/'PINS.json';records=json.loads(pinfile.read_text())
 shutil.copyfile(pinfile,B/('PINS_before_'+name+'.json'))
 records.append({'module':name,'source':str(src),'source_sha256':sha(src),'artifact':str(LIB/art.name),
  'artifact_sha256':sha(art),'receipt':str(d/'receipt.json')})
 pinfile.write_text(json.dumps(records,indent=2)+'\n');sys.exit(0)
name,label=sys.argv[1:3];d=B/'runs'/label
ok=h.compile_one(S/'formal'/(name+'.lean'),d,name,d/'lib',libs,LIB)
sys.exit(0 if ok else 1)
