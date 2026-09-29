#!/usr/bin/env python3
"""Independent post-freeze exact-set/hash/receipt check without modifying output."""
from pathlib import Path
import hashlib,json
W=Path(__file__).resolve().parents[1];O=W/'output'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def verify(base,manifest,excluded=()):
    rows={}
    for line in manifest.read_text().splitlines():
        h,n=line.split('  ',1);p=Path(n)
        assert not p.is_absolute() and '..' not in p.parts and n not in rows
        f=base/p
        assert f.is_file() and not f.is_symlink() and f.resolve().is_relative_to(base.resolve()) and sha(f)==h,n
        rows[n]=h
    actual={p.relative_to(base).as_posix() for p in base.rglob('*') if p.is_file()}
    assert not any(p.is_symlink() for p in base.rglob('*'))
    assert actual-set(excluded)==set(rows),(len(actual),len(rows),sorted(actual-set(rows))[:10])
    return len(rows)
old=verify(O/'predecessor',O/'predecessor/OUTPUTS.sha256',('OUTPUTS.sha256',))
assert old==68
final=verify(O,O/'OUTPUTS.sha256',('OUTPUTS.sha256',))
static=('inputs','formal','predecessor','evidence','context','library_provenance','replay')
staticset={p.relative_to(O).as_posix() for d in static for p in (O/d).rglob('*') if p.is_file()}|{'SEMANTIC_FILES.json'}
index={n:h for h,n in (line.split('  ',1) for line in (O/'INPUTS.sha256').read_text().splitlines())}
assert set(index)==staticset and all(sha(O/n)==h for n,h in index.items())
result=json.loads((O/'RESULT.json').read_text());replay=json.loads((O/'REPLAY_RESULT.json').read_text())
assert result['status']=='PARTIAL_PROOF' and not result['owner_accepted']
assert result['task_id']=='B20_001_P02_WORD_FPEMU_REFINEMENT' and result['packaging_task_id']=='FT1536_P02_FREEZE_CLOSURE_RUN_001'
assert replay['status']=='FRESH_REPLAY_PASS' and replay['steps']==43 and len(replay['matched_semantics'])==16
assert result['new_package_head']==json.loads((O/'HEAD_CONTEXT.json').read_text())['head']
print('FROZEN_SUCCESSOR_VERIFY_PASS',final,'outputs',len(index),'static inputs',
      'HEAD',result['new_package_head'],'REPORT',sha(O/'REPORT.md'),'OUTPUTS',sha(O/'OUTPUTS.sha256'))
