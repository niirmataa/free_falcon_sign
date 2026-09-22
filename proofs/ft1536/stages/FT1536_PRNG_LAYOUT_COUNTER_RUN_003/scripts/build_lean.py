"""Build the Lean 4 kernel module (organization only).

Runs the pinned Lean 4.34 toolchain on formal/CounterLayout.lean with -j1
-M2048 (single worker, bounded memory), exactly as the author does; the
mathematics lives in the .lean file.  Asserts exit 0, empty stderr (clean
logs, no warning suppression) and the expected `#print axioms` lines on
stdout.  HOME/TMPDIR are redirected under this durable W; no network use.
"""
import os
from pathlib import Path
from common import W,run_logged
LEAN='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
def main():
    for d in (W/'cache/home',W/'cache/tmp'):
        d.mkdir(parents=True,exist_ok=True)
    env=dict(os.environ)
    env.update(HOME=str(W/'cache/home'),TMPDIR=str(W/'cache/tmp'),
               TMP=str(W/'cache/tmp'),TEMP=str(W/'cache/tmp'),
               LEAN_PATH=str(W/'formal'),PYTHONDONTWRITEBYTECODE='1')
    rec,so,se=run_logged('lean_counter_layout',
        [LEAN,'-j1','-M2048','--root=formal','formal/CounterLayout.lean'],
        cwd=W,env=env,timeout=1200)
    assert rec['exit_code']==0,('lean failed',se.decode()[-3000:])
    assert rec['stderr_bytes']==0,'lean stderr not empty'
    out=so.decode()
    assert 'depends on axioms' in out,'missing #print axioms lines'
    assert 'sorry' not in out.lower(),'forbidden token in lean output'
    print('LEAN_OK')
if __name__=='__main__':main()
