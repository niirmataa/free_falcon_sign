#!/usr/bin/env python3
"""Retain overwritten files and pin byte-identical counterparts, without claiming original provenance."""
from pathlib import Path
import hashlib,json,shutil
W=Path(__file__).resolve().parents[1];E=W/'output/evidence/prior_run'; out=W/'output/evidence/overwritten_log_equivalents'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source={
 ('CONTROL_RECEIPTS.json','sage_oracle','stdout'):'word_asan_002/build/sage_oracle.stdout',
 ('CONTROL_RECEIPTS.json','normal_execute','stdout'):'word_asan_002/build/asan_execute.stdout',
 ('CONTROL_RECEIPTS.json','ubsan_execute','stdout'):'word_asan_002/build/asan_execute.stdout',
 ('CONTROL_RECEIPTS.json','no_producer_rejected','stderr'):'replay_001/000.stderr',
 ('LE_CONTROL_RECEIPTS.json','normal_execute','stdout'):'le_asan_002/build/asan_execute.stdout',
 ('LE_CONTROL_RECEIPTS.json','ubsan_execute','stdout'):'le_asan_002/build/asan_execute.stdout',
}
rows=[]
for (receipt,name,stream),origin in source.items():
    row=next(r for r in json.loads((E/'replay_001/build'/receipt).read_text()) if r['name']==name)
    stored=E/'replay_001/build'/row[stream]; expected=row[stream+'_sha256']
    src=E/origin
    assert sha(stored)!=expected and sha(src)==expected
    dest=out/receipt/name/(stream+'.log')
    dest.parent.mkdir(parents=True,exist_ok=True);assert not dest.exists()
    shutil.copyfile(src,dest);dest.chmod(0o444)
    rows.append({'receipt':'evidence/prior_run/replay_001/build/'+receipt,'child':name,'stream':stream,
                 'expected_hash':expected,'overwritten_path':'evidence/prior_run/replay_001/build/'+row[stream],
                 'overwritten_hash':sha(stored),'byte_identical_origin':'evidence/prior_run/'+origin,
                 'replacement_path':str(dest.relative_to(W/'output')),
                 'scope':'byte-equivalent witness from another pinned run, original historical log at replay_001 pathname overwritten; not an original-run path recovery'})
assert len(rows)==6
(W/'output/OVERWRITTEN_LOGS.json').write_text(json.dumps({'count':len(rows),'rows':rows},indent=2,sort_keys=True)+'\n')
print('OVERWRITTEN_LOG_EQUIVALENTS',len(rows), 'original path provenance not recoverable')
