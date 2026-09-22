"""Deterministic T02.1 pipeline, run by the author (cwd = W) and by the fresh
replay inside its own DEST (cwd = DEST).  Only scripts organize execution;
all arithmetic lives in model/*.sage executed as `sage <file>.sage`."""
import subprocess,sys
from pathlib import Path
W=Path(__file__).absolute().parents[1]
STEPS=[['python3','scripts/preflight.py'],
       ['python3','scripts/gen_fixtures.py'],
       ['python3','scripts/gen_kat.py'],
       ['python3','scripts/build_native.py'],
       ['python3','scripts/run_native.py'],
       ['python3','scripts/run_sage.py'],
       ['python3','scripts/build_lean.py'],
       ['python3','scripts/claims.py'],
       ['python3','scripts/semantic.py']]
def main():
    for step in STEPS:
        print('>>>',' '.join(step),flush=True)
        subprocess.run([str(s) for s in step],cwd=str(W),check=True)
    print('RECIPE_OK')
if __name__=='__main__':
    main()
