#!/usr/bin/env python3
"""Fresh replay into an ABSENT destination, with predefined semantic matches."""
from pathlib import Path
import argparse
import hashlib
import json
import sys
from job import W, files, run, sha

p=argparse.ArgumentParser()
p.add_argument('destination')
p.add_argument('--baseline',default='run/final_001')
p.add_argument('--outputs-sha256')
args=p.parse_args()
dest=(W/args.destination).resolve()
base=(W/args.baseline).resolve()
assert dest.is_relative_to(W) and not dest.exists()
assert base.is_relative_to(W) and base.is_dir()
if (W/'OUTPUTS.sha256').exists():
    assert args.outputs_sha256 and sha(W/'OUTPUTS.sha256')==args.outputs_sha256
    for line in (W/'OUTPUTS.sha256').read_text().splitlines():
        h,rel=line.split('  ',1)
        assert not Path(rel).is_absolute() and '..' not in Path(rel).parts
        assert sha(W/rel)==h,rel
plan_path=W/'SEMANTIC_FILES.json'
plan=json.loads(plan_path.read_text())
before={part:files(W/part) for part in ['formal','scripts','checks']}
plan_sha=sha(plan_path)
code=run(dest,'full')
receipt=json.loads((dest/'receipt.json').read_text())
matches=[]
if code==0:
    for rel in plan['files']:
        actual=sha(dest/rel); expected=sha(base/rel)
        assert actual==expected,rel
        matches.append({'path':rel,'sha256':actual,'producer_receipt':'receipt.json',
                        'producer_exit_code':receipt['exit_code']})
after={part:files(W/part) for part in ['formal','scripts','checks']}
assert before==after and sha(plan_path)==plan_sha
result={'schema':'T03_RUN002_FRESH_REPLAY_V1',
        'status':'FRESH_REPLAY_PASS' if code==0 else 'FRESH_REPLAY_FAIL',
        'source_before':before,'source_after':after,'sources_unchanged':before==after,
        'plan_sha256':plan_sha,'matches':matches,'exit_code':code,
        'receipt_sha256':sha(dest/'receipt.json'),
        'source_recovery_proved':False,'owner_accepted':False}
(dest/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print(result['status'],len(matches),'semantic matches')
sys.exit(code)
