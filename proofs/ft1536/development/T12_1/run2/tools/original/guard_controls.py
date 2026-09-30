import hashlib,json,os,subprocess
from pathlib import Path
W=Path(__file__).resolve().parent.parent;O=W/'output';D=W/'run/guard_controls_001';D.mkdir()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
script=O/'tools/replay.py';pin='c817333127090bdf16b869b18fd8721e282fe6af4232f0dd985e4380279fef17'
env=os.environ.copy()
for key,sub in [('HOME','home'),('TMPDIR','tmp'),('XDG_CACHE_HOME','cache')]:
    (D/sub).mkdir();env[key]=str(D/sub)
tests=[]
def check(name,bundle,manifest,pin,dest,needle):
    args=['python3','-B',str(script),'--bundle',str(bundle),'--dest',str(dest),
          '--manifest',manifest,'--manifest-sha',pin]
    existed=dest.exists();p=subprocess.run(args,capture_output=True,env=env,timeout=1800)
    (D/(name+'.stdout')).write_bytes(p.stdout);(D/(name+'.stderr')).write_bytes(p.stderr)
    ok=p.returncode!=0 and needle.encode() in p.stderr and existed==dest.exists()
    tests.append(dict(name=name,argv=args,exit_code=p.returncode,expected_error=needle,passed=ok,
        stdout=name+'.stdout',stdout_sha256=sha(D/(name+'.stdout')),
        stderr=name+'.stderr',stderr_sha256=sha(D/(name+'.stderr'))))
    assert ok,name
check('bad_pin',O,'REPLAY_INPUTS.sha256','0'*64,D/'never1','EXTERNAL_MANIFEST_PIN_MISMATCH')
check('existing_dest',O,'REPLAY_INPUTS.sha256',pin,W/'run/fresh_replay_001','DEST_MUST_BE_NEW')
F=D/'fixture';F.mkdir();(F/'data').write_text('before\n')
(F/'MANIFEST').write_text(sha(F/'data')+'  data\n');p=sha(F/'MANIFEST')
(F/'data').write_text('after\n')
check('bad_member',F,'MANIFEST',p,D/'never2','MEMBER_PIN_MISMATCH')
(F/'data').write_text('before\n')
check('missing_inputs',F,'MANIFEST',p,D/'never3','MANIFEST_OMITS_REPLAY_INPUTS')
(D/'RESULT.json').write_text(json.dumps(tests,indent=2)+'\n')
print('GUARDS_PASS 4/4 before proof execution')
