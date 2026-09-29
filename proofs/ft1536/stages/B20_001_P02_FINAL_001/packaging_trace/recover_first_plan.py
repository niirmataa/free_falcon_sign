#!/usr/bin/env python3
"""Record the already executed 15-match trial's exact predeclared semantic plan."""
from pathlib import Path
import hashlib,json
W=Path(__file__).resolve().parents[1];O=W/'output';p=O/'replay_evidence/fresh_001'
new=json.loads((O/'SEMANTIC_FILES.json').read_text())
assert len(new['matches'])==16 and new['matches'][-1]['path']=='042.stdout'
old={k:v for k,v in new.items() if k!='supplementary_full_term_source'}
old['matches']=new['matches'][:-1]
raw=json.dumps(old,indent=2,sort_keys=True)+'\n'
expected=next(h for h,name in (l.split('  ',1) for l in (p/'INPUTS.sha256').read_text().splitlines()) if name=='SEMANTIC_FILES.json')
assert hashlib.sha256(raw.encode()).hexdigest()==expected
assert not (p/'SEMANTIC_FILES.json').exists()
(p/'SEMANTIC_FILES.json').write_text(raw)
print('FIRST_PLAN_RECOVERED',expected,len(old['matches']))
