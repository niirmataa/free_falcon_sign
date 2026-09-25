#!/usr/bin/env python3
"""Pin exact imported library source + cached artifacts; copy source closure only."""
import hashlib
import json
from pathlib import Path
import re
import shutil

W=Path(__file__).resolve().parent.parent
O=W/'output'
P01=W.parent/'B20_001/P01'
LEAN=Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0')

def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1048576),b''): h.update(b)
    return h.hexdigest()

roots={'mathlib':P01/'bootstrap/mathlib4'}
roots.update({p.name:p for p in (P01/'run/.lake/packages').iterdir() if p.is_dir()})
builds={k:p/'.lake/build/lib/lean' for k,p in roots.items()}
roots['lean']=LEAN/'src/lean'
builds['lean']=LEAN/'lib/lean'
imports={'Init'}
for p in (O/'formal').rglob('*.lean'):
    for line in p.read_text().splitlines():
        if m:=re.match(r'^import\s+([\w.]+)',line):
            if not m[1].startswith('FT1536.'): imports.add(m[1])
pending=list(imports)
seen=set()
records=[]
while pending:
    mod=pending.pop()
    if mod in seen: continue
    seen.add(mod)
    rel=Path(mod.replace('.','/'))
    candidates=[(k,root/(str(rel)+'.olean')) for k,root in builds.items()]
    key,olean=next((k,p) for k,p in candidates if p.exists())
    ilean=olean.with_suffix('.ilean')
    if ilean.exists():
        data=json.loads(ilean.read_text())
        pending.extend(i[0] for i in data['directImports'])
    else:
        source=roots[key]/(str(rel)+'.lean')
        if not source.exists(): raise RuntimeError(('No import metadata or source',mod))
        for line in source.read_text().splitlines():
            if m:=re.match(r'^(?:public\s+)?(?:meta\s+)?import\s+(?:all\s+)?([\w.]+)',line):
                pending.append(m[1])
    source=roots[key]/(str(rel)+'.lean')
    if not source.exists(): raise RuntimeError(('Missing source',key,mod))
    dest=O/'library-source'/key/(str(rel)+'.lean')
    dest.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(source,dest)
    artifacts=[]
    for ext in ['.olean','.olean.private','.olean.server','.ir','.ilean']:
        p=builds[key]/(str(rel)+ext)
        if p.exists(): artifacts.append(dict(path=str(p.relative_to(builds[key])),sha256=sha(p)))
    records.append(dict(module=mod,library=key,source=str(dest.relative_to(O)),
                        source_sha256=sha(source),artifacts=artifacts))
manifest=dict(schema='T12_1_LIBRARY_CLOSURE_V1',
    roots={k:dict(source=str(roots[k]),build=str(builds[k])) for k in roots},
    modules=sorted(records,key=lambda r:r['module']),
    provenance='P01 pinned reviewed toolchain, revisions in PREFLIGHT.json; exact artifact/source pins at use.',
    core_toolchain='leanprover/lean4:v4.34.0',cache_rebuilt_in_this_task=False)
(O/'LIBRARY_CLOSURE.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Pinned imported modules:',len(records))
