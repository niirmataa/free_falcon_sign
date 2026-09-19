"""Standard replay: ABSENT_DEST EXPECTED_OUTPUTS_SHA256 [--rehearsal].

Only DEST is written. Tests use the copied bounded bwrap runner; original
package/manifest is never modified. All deterministic results are byte matched.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import sys
import time

W=Path(__file__).resolve().parents[1]

def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def safe(root,rel):
    p=Path(rel)
    assert not p.is_absolute() and '..' not in p.parts and p.parts
    out=root
    for part in p.parts:
        out=out/part
        assert not out.is_symlink(),str(out)
    return out

def verify_manifest(path,pin):
    assert re.fullmatch('[0-9a-f]{64}',pin)
    assert digest(path)==pin,'manifest hash mismatch'
    entries={}
    for ln in path.read_text().splitlines():
        h,rel=ln.split('  ',1)
        assert re.fullmatch('[0-9a-f]{64}',h) and rel not in entries
        assert rel!='OUTPUTS.sha256'
        p=safe(W,rel)
        assert p.is_file() and digest(p)==h,rel
        entries[rel]=h
    return entries

def replay(dest,pin,rehearsal=False):
    manifest=W/('artifacts/rehearsal_anchor.sha256' if rehearsal else 'OUTPUTS.sha256')
    entries=verify_manifest(manifest,pin)
    dest=Path(dest)
    assert dest.is_absolute() and dest.is_relative_to(W) and dest!=W
    safe(W,str(dest.relative_to(W)))
    assert not dest.exists(),'DEST must be absent'
    assert dest.parent.is_dir(),'DEST parent must exist'
    semantics=json.loads((W/'SEMANTIC_FILES.json').read_text())
    assert len(set(semantics))==len(semantics) and all(n in entries for n in semantics)
    seed=[n for n in entries if n.startswith(('inputs/','scripts/','checks/'))]
    dest.mkdir()
    for rel in seed:
        p=safe(dest,rel);p.parent.mkdir(parents=True,exist_ok=True)
        p.write_bytes((W/rel).read_bytes())
    (dest/'logs/replay_driver').mkdir(parents=True)
    sage='/home/footfalcon/.local/bin/sage'
    steps=[('verify',30,False,['python3','-B','scripts/verify.py']),
           ('build-normal',60,False,['python3','-B','scripts/build.py','normal']),
           ('arithmetic-normal',180,False,['python3','-B','scripts/arithmetic.py','normal']),
           ('build-asan',60,True,['python3','-B','scripts/build.py','asan']),
           ('arithmetic-asan',180,True,['python3','-B','scripts/arithmetic.py','asan']),
           ('oracle-controls',30,True,['python3','-B','scripts/controls.py']),
           ('platform',120,False,['python3','-B','scripts/platform_review.py']),
           ('rigorous',120,False,[sage,'scripts/rigorous.py']),
           ('formal',240,False,['python3','-B','scripts/formal_review.py']),
           ('production-asm',90,False,['python3','-B','scripts/production_asm.py']),
           ('matrix',30,False,['python3','-B','scripts/matrix.py']),
           ('package-controls',30,False,['python3','-B','scripts/package_controls.py'])]
    receipts=[]
    for name,limit,asan,cmd in steps:
        env=dict(os.environ,FT1536_ASAN='1' if asan else '0',PYTHONDONTWRITEBYTECODE='1',PYTHONOPTIMIZE='0')
        argv=[sys.executable,'-B','scripts/run.py',str(limit),*cmd]
        tick=time.monotonic()
        # The runner enforces per-job limits inside a new PID/network namespace.
        p=subprocess.run(argv,cwd=dest,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=limit+15)
        for stream,data in [('stdout',p.stdout),('stderr',p.stderr)]:
            (dest/f'logs/replay_driver/{name}.{stream}').write_bytes(data)
        receipts.append(dict(step=name,argv=argv,cwd=str(dest),exit_code=p.returncode,
            wall_limit_seconds=limit,asan_shadow=asan,elapsed_seconds=time.monotonic()-tick,
            stdout_sha256=hashlib.sha256(p.stdout).hexdigest(),stderr_sha256=hashlib.sha256(p.stderr).hexdigest()))
        (dest/'logs/replay_driver/receipts.json').write_text(json.dumps(receipts,indent=2,sort_keys=True)+'\n')
        assert p.returncode==0,f'{name}: failed; receipts in {dest}'
    matches=[]
    for rel in semantics:
        h=digest(safe(dest,rel))
        assert h==entries[rel],f'semantic mismatch {rel}: {h} != {entries[rel]}'
        matches.append(dict(path=rel,sha256=h))
    result=dict(status='FRESH_REPLAY_PASS',mode='pre-freeze rehearsal' if rehearsal else 'post-freeze standard',
                expected_outputs_sha256=pin,manifest_members=len(entries),matches=matches,
                fresh_build=True,sanitizers='PASS',timing='NOT_RUN',steps=len(steps),
                new_artifacts_only_under_dest=True,original_manifest_unchanged=digest(manifest)==pin)
    (dest/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print(json.dumps(result,indent=2,sort_keys=True))
    return result

if __name__=='__main__':
    assert len(sys.argv) in (3,4)
    assert len(sys.argv)==3 or sys.argv[3]=='--rehearsal'
    replay(sys.argv[1],sys.argv[2],len(sys.argv)==4)
