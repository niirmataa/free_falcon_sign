#!/usr/bin/env python3
"""S05-only bounded compiler with pinned reuse and topological dependency builds.
No upstream job is resumed; no Git mutation. Mathematical work stays in Lean/Sage.
"""
from pathlib import Path
import types,json,sys,hashlib,shutil
S=Path(__file__).resolve().parent.parent;R=S.parents[3];B=S/'.build/box_moment_015';LIB=B/'lib';BASE=B/'prior'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py']
assert sha(P)==expected
marker="\nif sys.argv[1]=='prepare':";text=P.read_text();assert text.count(marker)==1
h=types.ModuleType('s05_compiler');h.__file__=str(P)
exec(compile(text.split(marker)[0],str(P),'exec'),h.__dict__);h.BUILD=B
old=json.loads((S/'notes/KEY_SUPPORT_011_INPUTS.json').read_text());libs=old['library_roots']
if sys.argv[1]=='prepare':
 LIB.mkdir(parents=True,exist_ok=False);BASE.mkdir();known={};fresh_old={r['module']:r for r in old['fresh_dependency_receipts']}
 for m,r in old['modules'].items():
  src=h.BASE/'sources'/(m.replace('.','/')+'.lean');art=h.BASE/'lib'/(m.replace('.','/')+'.olean')
  known[m]={'module':m,'source':str(src),'source_sha256':r['source_sha256'],'artifact':str(art),
   'artifact_sha256':r.get('artifact_sha256') or fresh_old[m]['artifact_sha256']}
 for r in json.loads((S/'.build/primary_014/replay_001/prior_library/PINS.json').read_text()):known[r['module']]=r
 for r in json.loads((S/'.build/primary_014/replay_001/REPLAY_RECEIPT.json').read_text())['modules']:
  r={**r,'source':str(S/'formal'/(r['module']+'.lean'))};known[r['module']]=r
 records={};order=[];cached=[]
 def visit(m):
  if m in records or m.startswith(('Mathlib','Lean','Std','Init','Batteries','Qq','Aesop')):return
  if m in known:
   r=known[m];src=Path(r['source']);art=Path(r['artifact'])
   assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256'],m
   dest=LIB/(m.replace('.','/')+'.olean');dest.parent.mkdir(parents=True,exist_ok=True)
   for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,dest.parent/f.name)
   rec={**r,'artifact':str(dest),'origin_artifact':str(art),'mode':'pinned_reuse'};cached.append(rec)
  else:
   candidates=[R/'proofs/ft1536/development/T12_1'/c/'formal'/(m.replace('.','/')+'.lean') for c in ['run2','t5','source3']]
   src=next((p for p in candidates if p.exists()),None);assert src is not None,('missing source',m)
   snap=B/'dependency_sources'/(m.replace('.','/')+'.lean');snap.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,snap)
   rec={'module':m,'source':str(snap),'source_sha256':sha(snap),'original_source':str(src),'mode':'fresh_dependency'}
  records[m]=rec
  for line in src.read_text().splitlines():
   if line.startswith('import '):
    for dep in line.split()[1:]:visit(dep)
  if rec['mode']=='fresh_dependency':order.append(m)
 for m in ['SamplerMassCondition014','Run2.T5BoxBound','Run2.CenteringTriangle','Run2.NormalizerComparison','Run2.FiberBinding','Run2.LawBinding']:visit(m)
 (BASE/'PINS.json').write_text(json.dumps(cached,indent=2)+'\n')
 (B/'DEPENDENCIES.json').write_text(json.dumps({'modules':records,'fresh_order':order,'library_roots':libs},indent=2)+'\n')
 print(json.dumps({'all_project_modules':len(records),'reused':len(cached),'fresh':len(order),'fresh_order':order},indent=2));sys.exit(0)
if sys.argv[1]=='dependencies':
 records=json.loads((BASE/'PINS.json').read_text())
 for m in json.loads((B/'DEPENDENCIES.json').read_text())['fresh_order']:
  src=B/'dependency_sources'/(m.replace('.','/')+'.lean');d=B/'runs'/('dependency_'+m.replace('.','_'))
  if d.exists():
   rec=json.loads((d/'receipt.json').read_text())
   assert rec['exit_code']==0 and sha(src)==rec['source_sha256'] and sha(Path(rec['artifact']))==rec['artifact_sha256']
  else:
   if not h.compile_one(src,d,m,LIB,libs,BASE):sys.exit(1)
   rec=json.loads((d/'receipt.json').read_text())
  records.append({**rec,'source':str(src),'mode':'fresh_dependency'})
 assert not (LIB/'PINS.json').exists()
 (LIB/'PINS.json').write_text(json.dumps(records,indent=2)+'\n')
 sys.exit(0)
if sys.argv[1]=='install':
 name,label=sys.argv[2:4];d=B/'runs'/label;r=json.loads((d/'receipt.json').read_text());src=S/'formal'/(name+'.lean');art=Path(r['artifact'])
 assert r['exit_code']==0 and r['warning_count']==0 and sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
 assert not (LIB/art.name).exists()
 for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,LIB/f.name)
 pins=LIB/'PINS.json';before=d/'installed_PINS_before.json';assert not before.exists();shutil.copyfile(pins,before)
 records=json.loads(pins.read_text());records.append({**r,'source':str(src),'artifact':str(LIB/art.name),'mode':'fresh_S05'})
 pins.write_text(json.dumps(records,indent=2)+'\n')
 sys.exit(0)
name,label=sys.argv[1:3];d=B/'runs'/label
# Each fresh dependency product must exist before compiling a consumer.
for m in json.loads((B/'DEPENDENCIES.json').read_text())['fresh_order']:
 assert (LIB/(m.replace('.','/')+'.olean')).exists(),m
ok=h.compile_one(S/'formal'/(name+'.lean'),d,name,d/'lib',libs,LIB)
sys.exit(0 if ok else 1)
