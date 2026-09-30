#!/usr/bin/env python3
"""Read-only intake of the owner-supplied MiMo package. Writes only our W."""
import hashlib,json,re
from pathlib import Path
from datetime import datetime,timezone
W=Path(__file__).resolve().parent.parent
S=W.parent/'FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/output'
D=W/'run/GAME_BINDING_REVIEW_001'
D.mkdir(exist_ok=True)
def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1048576),b''):h.update(b)
    return h.hexdigest()
expected={'OUTPUTS.sha256':'6f0d4f42f1a71526070864f162252e4105d012786104d50ef1ed16eca7975e7f',
    'REPORT.md':'e593d91ed0e827bd240a145a31d2767407c4ea55eafd34e9a07252b49cd10d7c',
    'REPLAY_SEED.sha256':'ec2eab35a865104957e4826dcd4a213d0259690e8ec3fe4b1e5087d90f7e8dbc'}
result=dict(time=datetime.now(timezone.utc).isoformat(),source=str(S),physical_source=str(S.resolve()),
    pin_provenance='Full pins read from owner-indicated output/HANDOFF.md; not a separate cryptographic channel.',
    handoff_sha256=sha(S/'HANDOFF.md'),anchors={},manifests={},errors=[])
for name,pin in expected.items():
    actual=sha(S/name);result['anchors'][name]=dict(expected=pin,actual=actual,match=actual==pin)
    if actual!=pin:result['errors'].append('anchor mismatch '+name)
for name in ['OUTPUTS.sha256','INPUTS.sha256','REPLAY_SEED.sha256','INHERITED_SOURCES.sha256']:
    if not (S/name).exists():continue
    seen=set();bad=[]
    for line in (S/name).read_text().splitlines():
        h,rel=line.split(maxsplit=1);rel=rel.lstrip('*');p=S/rel
        if rel in seen or Path(rel).is_absolute() or '..' in Path(rel).parts:
            bad.append(dict(path=rel,error='duplicate/unsafe path'));continue
        seen.add(rel)
        if not p.is_file():bad.append(dict(path=rel,error='missing'));continue
        if p.is_symlink() or not p.resolve().is_relative_to(S.resolve()):bad.append(dict(path=rel,error='symlink/escape'));continue
        actual=sha(p)
        if actual!=h:bad.append(dict(path=rel,error='hash mismatch',expected=h,actual=actual))
    result['manifests'][name]=dict(members=len(seen),bad=bad)
    result['errors'] += [name+': '+x['path']+' '+x['error'] for x in bad]
rec=json.loads((S/'replay/REPLAY_RESULT.json').read_text())
result['author_replay']=dict(status=rec.get('status'),exports=rec.get('exports_audited'),
    jobs=len(rec.get('receipts',[])),comparisons=rec.get('comparisons'))
logs=[]
for r in rec.get('receipts',[]):
    for kind in ['stdout','stderr']:
        p=S/'replay'/r[kind]
        match=p.is_file() and sha(p)==r[kind+'_sha256']
        logs.append(dict(job=r['name'],kind=kind,path=str(p.relative_to(S)),match=match))
        if not match:result['errors'].append('raw log mismatch '+str(p.relative_to(S)))
result['author_raw_logs']=logs
exports=json.loads((S/'FORMAL_EXPORTS.json').read_text())['exports']
result['export_count']=len(exports)
result['own_fresh_replay_performed']=False
result['status']='INTEGRITY_PASS' if not result['errors'] else 'INTEGRITY_FAIL'
(D/'INTAKE.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:result[k] for k in ['status','physical_source','anchors','manifests','export_count','errors']},indent=2))
if result['errors']:raise SystemExit(1)
