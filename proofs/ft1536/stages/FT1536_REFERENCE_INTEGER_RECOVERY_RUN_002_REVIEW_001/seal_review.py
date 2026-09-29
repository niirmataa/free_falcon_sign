#!/usr/bin/env python3
"""Frozen output manifest after successful independent review; run exactly once."""
from pathlib import Path
import hashlib,json
W=Path(__file__).resolve().parents[1]; O=W/'output'; I=W/'inputs'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(I/'MANIFEST.sha256')=='6a784862e05cfffec5b691e286ff146c31c88e3be71d4b636456de2c8e3ef9d2'
assert sha(O/'INPUTS.sha256')==sha(I/'MANIFEST.sha256')
assert sha(I/'subject/REPORT.md')=='b2e8c9af003edee089b49156541e631e3ab8bb01c93f9cad521edf7b66a59dfc'
assert sha(I/'subject/OUTPUTS.sha256')=='12df61056ddada2f79c1b94b3b17e8f326db2b3a2cbe53d1694754d79d7958cc'
review=json.loads((O/'REVIEW_RESULT.json').read_text())
assert review['verdict']=='PASS_SCOPED_REVIEW' and not review['full_recovery']
assert review['source_gap'] is None and not review['owner_accepted']
for name in ['input_audit','claim_audit','reviewer_arithmetic','reviewer_lean','collect_evidence']:
    assert (O/(name+'.exit')).read_text().strip()=='0',name
r=json.loads((O/'evidence/fresh_002/REPLAY_RESULT.json').read_text())
assert r['status']=='FRESH_REPLAY_PASS' and len(r['matches'])==10 and r['sources_unchanged']
for mode in ['ubsan_001','asan_001']:
    receipt=json.loads((O/'evidence'/mode/'receipt.json').read_text())
    assert receipt['exit_code']==0 and len(receipt['steps'])==3
manifest=O/'REVIEW_OUTPUTS.sha256'
assert not manifest.exists()
paths=sorted((p for p in O.rglob('*') if p.is_file()),key=lambda p:p.relative_to(O).as_posix())
assert all(not p.is_symlink() for p in O.rglob('*'))
assert not any(p.suffix in ['.olean','.o','.so','.pyc'] for p in paths)
assert len(paths)>100
manifest.write_text(''.join(sha(p)+'  '+p.relative_to(O).as_posix()+'\n' for p in paths))
print(json.dumps({'status':'FROZEN_REVIEW','files':len(paths),'report_sha256':sha(O/'REVIEW.md'),
                  'outputs_sha256':sha(manifest)},indent=2))
