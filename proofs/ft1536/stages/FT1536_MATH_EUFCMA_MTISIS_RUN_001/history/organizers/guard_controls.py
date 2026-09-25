#!/usr/bin/env python3
"""Negative controls for archive/runner integrity; not mathematical tests."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
from datetime import datetime, timezone

W=Path(__file__).resolve().parent.parent
O=W/'output'
D=W/'run/guard_controls_001'
D.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
seed='a5ff7f1a2f34dd0735b35c1b84afb915773c226e797f16b0b767bea777b4b707'
script=O/'tools/replay.py'
env=os.environ.copy()
for key,sub in [('HOME','home'),('TMPDIR','tmp'),('XDG_CACHE_HOME','cache')]:
    (D/sub).mkdir(exist_ok=True);env[key]=str(D/sub)
tests=[]
def check(label,bundle,manifest,pin,dest,needle):
    argv=['python3','-B',str(script),'--bundle',str(bundle),'--dest',str(dest),
          '--manifest',manifest,'--manifest-sha',pin]
    existed=dest.exists()
    proc=subprocess.run(argv,capture_output=True,env=env,timeout=1800)
    out,err=D/(label+'.stdout'),D/(label+'.stderr')
    out.write_bytes(proc.stdout);err.write_bytes(proc.stderr)
    ok=proc.returncode!=0 and needle.encode() in proc.stderr and dest.exists()==existed
    tests.append(dict(name=label,argv=argv,exit_code=proc.returncode,
        expected_failure=needle,pass_control=ok,dest_created=False if not existed else None,
        stdout=out.name,stdout_sha256=sha(out),stderr=err.name,stderr_sha256=sha(err)))
    assert ok,label
check('wrong_external_pin',O,'REPLAY_SEED.sha256','0'*64,D/'never_created1','EXTERNAL_MANIFEST_PIN_MISMATCH')
check('existing_dest',O,'REPLAY_SEED.sha256',seed,W/'run/fresh_replay_001','DEST_MUST_BE_NEW')
fixture=D/'fixture';fixture.mkdir()
(fixture/'data').write_text('original\n')
(fixture/'MANIFEST.sha256').write_text(sha(fixture/'data')+'  data\n')
pin=sha(fixture/'MANIFEST.sha256')
(fixture/'data').write_text('modified\n')
check('modified_member',fixture,'MANIFEST.sha256',pin,D/'never_created2','MEMBER_PIN_MISMATCH')
(fixture/'data').write_text('original\n')
check('incomplete_manifest',fixture,'MANIFEST.sha256',pin,D/'never_created3','MANIFEST_OMITS_REPLAY_INPUTS')
(D/'RESULT.json').write_text(json.dumps(dict(time=datetime.now(timezone.utc).isoformat(),tests=tests),indent=2)+'\n')
print('REPLAY_GUARDS_PASS 4/4 expected rejections before proof execution')
