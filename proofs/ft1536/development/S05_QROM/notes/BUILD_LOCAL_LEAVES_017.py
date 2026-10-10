#!/usr/bin/env python3
"""Bounded S05-017 compiler with pinned016 inputs and fresh attempt directories."""
from pathlib import Path
import json,hashlib,shutil,types,sys,os
S=Path(__file__).resolve().parent.parent;R=S.parents[3];B=S/'.build/local_leaves_017';LIB=B/'lib'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
P=S/'notes/BUILD_KEY_SUPPORT_011.py';manifest=S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256'
expected=dict(line.split('  ',1)[::-1] for line in manifest.read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py'];assert sha(P)==expected
h=types.ModuleType('helper');h.__file__=str(P);text=P.read_text();marker="\nif sys.argv[1]=='prepare':";assert text.count(marker)==1
helper=text.split(marker)[0]
if True:
 helper=helper.replace("'-s8192'","'-s65536'")
exec(compile(helper,str(P),'exec'),h.__dict__);h.BUILD=B
libs=json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots']
if sys.argv[1]=='prepare':
 LIB.mkdir(parents=True,exist_ok=False);records=[]
 for r in json.loads((S/'.build/implementation_016/lib/PINS.json').read_text()):
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
 pf=LIB/'PINS.json';shutil.copyfile(pf,d/'PINS_before.json');records=json.loads(pf.read_text());records.append({'module':name,'source':str(src),'source_sha256':sha(src),'artifact':str(dest),'artifact_sha256':sha(dest),'receipt':str(d/'receipt.json')});tmp=pf.with_suffix('.next');assert not tmp.exists();tmp.write_text(json.dumps(records,indent=2)+'\n');tmp.replace(pf);sys.exit(0)
if sys.argv[1]=='generated':
 name,label=sys.argv[2:4];src=B/'generated'/(name+'.lean')
elif sys.argv[1]=='upstream':
 name,label=sys.argv[2:4];src=R/'proofs/ft1536/development/T12_1/run2/formal'/(name.replace('.','/')+'.lean')
else:
 name,label=sys.argv[1:3];src=S/'formal'/(name+'.lean')
d=B/'runs'/label
# The first witness batches used two efficiency cores. Keep the same one-core
# and memory/time caps, but place later batches on two distinct performance cores.
# This is scheduling only; the exact affinity and wrapper bytes are receipted.
wrapper_bytes=Path(__file__).read_bytes()
if name.startswith('GaussianWitness017_'):
 batch=int(name.rsplit('_',1)[1]);os.sched_setaffinity(0,{2 if batch%2==0 else 4})
affinity=sorted(os.sched_getaffinity(0))
ok=h.compile_one(src,d,name,LIB if sys.argv[1]=='upstream' else d/'lib',libs,LIB)
rp=d/'receipt.json';r=json.loads(rp.read_text());r['wrapper_sha256_at_launch']=hashlib.sha256(wrapper_bytes).hexdigest();r['affinity_at_launch']=affinity
(d/'wrapper_at_launch.py').write_bytes(wrapper_bytes);rp.write_text(json.dumps(r,indent=2)+'\n')
sys.exit(0 if ok else 1)
