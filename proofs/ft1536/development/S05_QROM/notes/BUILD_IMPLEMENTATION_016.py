#!/usr/bin/env python3
"""Bounded S05-only compiler, pinned015 closure; never mutates prior runs."""
from pathlib import Path
import json,hashlib,shutil,types,sys
S=Path(__file__).resolve().parent.parent;R=S.parents[3];B=S/'.build/implementation_016';LIB=B/'lib'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
P=S/'notes/BUILD_KEY_SUPPORT_011.py';manifest=S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256'
expected=dict(line.split('  ',1)[::-1] for line in manifest.read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py'];assert sha(P)==expected
h=types.ModuleType('helper');h.__file__=str(P);text=P.read_text();marker="\nif sys.argv[1]=='prepare':";assert text.count(marker)==1
helper=text.split(marker)[0]
if (sys.argv[1]=='upstream' and sys.argv[2]=='Run2.PolynomialReference') or sys.argv[1] in ['ProgramLaw016','RawConditioning016']:
 helper=helper.replace("'-s8192'","'-s65536'")
exec(compile(helper,str(P),'exec'),h.__dict__);h.BUILD=B
libs=json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots']
if sys.argv[1]=='prepare':
 LIB.mkdir(parents=True,exist_ok=False);records=[]
 for r in json.loads((S/'.build/box_moment_015/lib/PINS.json').read_text()):
  src=Path(r['source']);art=Path(r['artifact']);assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
  dest=LIB/(r['module'].replace('.','/')+'.olean');dest.parent.mkdir(parents=True,exist_ok=True)
  for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,dest.parent/f.name)
  records.append({'module':r['module'],'source':str(src),'source_sha256':sha(src),'artifact':str(dest),'artifact_sha256':sha(dest),'origin_artifact':str(art)})
 (LIB/'PINS.json').write_text(json.dumps(records,indent=2)+'\n');print(json.dumps({'reused':len(records)}));sys.exit(0)
if sys.argv[1]=='install':
 name,label=sys.argv[2:4];d=B/'runs'/label;r=json.loads((d/'receipt.json').read_text());src=Path(r['command'][-1]);art=Path(r['artifact'])
 assert r['exit_code']==r['warning_count']==r['error_count']==0;assert sha(src)==r['source_sha256'];assert sha(art)==r['artifact_sha256']
 dest=LIB/(name.replace('.','/')+'.olean');assert not dest.exists() or dest==art;dest.parent.mkdir(parents=True,exist_ok=True)
 if art!=dest:
  for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,dest.parent/f.name)
 pf=LIB/'PINS.json';shutil.copyfile(pf,d/'PINS_before.json');records=json.loads(pf.read_text());records.append({'module':name,'source':str(src),'source_sha256':sha(src),'artifact':str(dest),'artifact_sha256':sha(dest),'receipt':str(d/'receipt.json')});pf.write_text(json.dumps(records,indent=2)+'\n');sys.exit(0)
if sys.argv[1]=='control':
 name,label=sys.argv[2:4];src=S/'notes/CONTROL_FALLBACK_016.lean'
elif sys.argv[1]=='generated':
 name,label=sys.argv[2:4];src=B/'generated'/(name+'.lean')
elif sys.argv[1]=='upstream':
 name,label=sys.argv[2:4];src=R/'proofs/ft1536/development/T12_1/run2/formal'/(name.replace('.','/')+'.lean')
else:
 name,label=sys.argv[1:3];src=S/'formal'/(name+'.lean')
d=B/'runs'/label
sys.exit(0 if h.compile_one(src,d,name,LIB if sys.argv[1]=='upstream' else d/'lib',libs,LIB) else 1)
