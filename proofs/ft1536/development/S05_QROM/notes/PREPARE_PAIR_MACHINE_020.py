#!/usr/bin/env python3
"""Verify and copy pinned dependencies into a NEW own020 world. No foreign replay.
Missing source/artifact is a hard error. Rebuilding missing upstream artifacts
requires their own recorded reproduction route, not a silent current-source swap.
"""
from pathlib import Path
import hashlib,json,re,shutil,sys
S=Path(__file__).resolve().parent.parent
world=sys.argv[1];assert re.fullmatch(r'[a-z][a-z0-9_]*',world)
B=S/'.build/pair_machine_020'/world
assert not B.exists(), 'fresh world required; preserve prior attempts'
inputs=json.loads((S/'notes/PAIR_MACHINE_020_INPUTS.json').read_text())
extra=json.loads((S/'notes/PAIR_MACHINE_020_REUSE.json').read_text())
rows=inputs['reused']+extra['added_pure_modules']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len({r['module'] for r in rows})==len(rows)
# Complete validation precedes any writes.
for r in rows:
 for k in ['source','artifact']:
  p=Path(r[k]);assert p.is_file(),str(p)
  assert sha(p)==r[k+'_sha256'],str(p)
L=B/'lib';L.mkdir(parents=True);out=[]
for r0 in rows:
 r=r0.copy();a=Path(r['artifact']);p=L/(r['module'].replace('.','/')+'.olean')
 p.parent.mkdir(parents=True,exist_ok=True)
 for f in a.parent.glob(a.name+'*'):shutil.copyfile(f,p.parent/f.name)
 r['origin_artifact']=str(a);r['artifact']=str(p);out.append(r)
(L/'PINS.json').write_text(json.dumps(out,indent=2)+'\n')
f=B/'no_fallback_dependency_root';f.mkdir();(f/'PINS.json').write_text('{"policy":"no fallback"}\n')
(B/'PREPARE_RECEIPT.json').write_text(json.dumps({'world':world,'modules':len(out),
 'runner_sha256':sha(Path(__file__)),'inputs_sha256':sha(S/'notes/PAIR_MACHINE_020_INPUTS.json'),
 'reuse_sha256':sha(S/'notes/PAIR_MACHINE_020_REUSE.json'),'foreign_builds_started':False},indent=2)+'\n')
print(json.dumps({'world':world,'verified_copied_modules':len(out)}))
