import hashlib,json
from pathlib import Path
W=Path(__file__).resolve().parent.parent;S=W.parent/'FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/output'
D=W/'run/GAME_BINDING_REVIEW_001'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
out=dict(status='RELOCATED_INPUTS_VERIFIED',mapping=[],errors=[],note='Initial INTAKE.json used bundle-root for ancillary manifests; actual bases recorded here. Sealed package unchanged.')
for name in ['INPUTS.sha256','INHERITED_SOURCES.sha256','NEW_SOURCES.sha256']:
    for line in (S/name).read_text().splitlines():
        h,n=line.split(maxsplit=1)
        if name=='INPUTS.sha256':p=S.parent/'inputs/bootstrap'/n
        elif name=='INHERITED_SOURCES.sha256':
            prefix='/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/output/'
            assert n.startswith(prefix);p=S/n[len(prefix):]
        else:p=S/'formal/FT1536'/n
        actual=sha(p) if p.is_file() else None
        out['mapping'].append(dict(manifest=name,original=n,resolved=str(p),expected=h,actual=actual,match=actual==h))
        if actual!=h:out['errors'].append(str(p))
task=S.parent/'inputs/bootstrap/FT1536_ZADANIE_EUFCMA_GAME_BINDING_2026-09-23.md'
out['task_sha256']=sha(task)
newtask=W.parent/'FT1536_EUFCMA_GAME_BINDING_zlecenie/FT1536_EUFCMA_GAME_BINDING_task/FT1536_ZADANIE_EUFCMA_GAME_BINDING_2026-09-23.md'
out['owner_added_task_matches']=newtask.is_file() and sha(newtask)==sha(task)
if out['errors']:out['status']='PRIMARY_BYTES_PASS_SECONDARY_MANIFEST_STALE'
(D/'RELOCATION.json').write_text(json.dumps(out,indent=2)+'\n')
assert out['owner_added_task_matches']
print('RELOCATION_RESULT',out['status'],len(out['mapping']),'refs; mismatches',out['errors'],
    '; owner task matches',out['task_sha256'])
if out['errors']:raise SystemExit(1)
