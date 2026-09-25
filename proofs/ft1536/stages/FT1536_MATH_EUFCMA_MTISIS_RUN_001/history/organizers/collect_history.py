#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path
import shutil

W=Path(__file__).resolve().parent.parent
O=W/'output'
H=O/'history'
H.mkdir(exist_ok=True)
summary=[]
for d in sorted((W/'run').iterdir()):
    if not d.is_dir() or not (d/'formal').exists() or d.name.startswith('fresh_replay'): continue
    hd=H/d.name
    hd.mkdir(exist_ok=True)
    for sub in ['formal','sage','logs','generated']:
        if (d/sub).exists(): shutil.copytree(d/sub,hd/sub,dirs_exist_ok=True)
    for name in ['RECEIPTS.json','certificates.json']:
        if (d/name).exists(): shutil.copyfile(d/name,hd/name)
    rec=json.loads((d/'RECEIPTS.json').read_text()) if (d/'RECEIPTS.json').exists() else []
    summary.append(dict(run=d.name,jobs=[dict(name=r['name'],exit_code=r['exit_code']) for r in rec],
        final_receipt_present=bool(rec),scope='history only, not current semantic products'))
(H/'INDEX.json').write_text(json.dumps(summary,indent=2)+'\n')
(H/'INTERRUPTED.json').write_text(json.dumps(dict(run='basic_002',
    cause='harness foreground timeout120s',final_exit_code=None,
    followup='process check found no remaining own Lean/job process'),indent=2)+'\n')
toolhistory=H/'organizers'
toolhistory.mkdir(exist_ok=True)
for p in sorted((W/'run').glob('*.py')): shutil.copyfile(p,toolhistory/p.name)
shutil.copyfile(W/'WORK_STATE.md',H/'WORK_STATE.md')
print('Preserved attempt directories:',len(summary))
