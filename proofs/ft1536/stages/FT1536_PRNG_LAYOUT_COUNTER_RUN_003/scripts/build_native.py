"""Build the original-C-slice harness: normal, ASan/UBSan, alternate branch.

Flags mirror the pinned Makefile (`CC = c99`, `CFLAGS = -W -Wall -O`, GCC
14.2); the alternate branch is compiled with -DFALCON_LE_U=0 on the same LE
host and is tagged as an LE-host emulation control, NOT a big-endian
hardware test.
"""
import json
from pathlib import Path
from common import W,run_logged
from replaylib import sha
SRC=W/'source';H=W/'harness';BIN=W/'bin'
BUILDS={
 'normal':['c99','-W','-Wall','-O'],
 'sanitized':['c99','-W','-Wall','-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all'],
 'altbranch':['c99','-W','-Wall','-O','-DFALCON_LE_U=0']}
def main():
 BIN.mkdir(exist_ok=True);recs=[]
 for name,flags in BUILDS.items():
  binp=BIN/('prng-harness-'+name)
  argv=flags+['-I',str(SRC),str(H/'prng_harness.c'),str(SRC/'frng.c'),'-o',str(binp)]
  rec,so,se=run_logged('build_'+name,argv,cwd=W,timeout=900)
  assert rec['exit_code']==0,('build failed',name,se.decode()[-3000:])
  assert se==b'' and so==b'',('non-clean build log',name,so,se)
  recs.append(dict(name=name,flags=flags,exit_code=rec['exit_code'],binary=binp.name,binary_sha256=sha(binp),stdout_sha256=rec['stdout_sha256'],stderr_sha256=rec['stderr_sha256'],clean_log=True))
 (W/'receipts/build.json').write_text(json.dumps(dict(schema='PRNG_T021_BUILD_V1',driver='c99',gcc='14.2.0-19',flags_note='literal pinned Makefile -W -Wall -O plus sanitizer/branch controls',builds=recs),indent=2)+'\n')
 print(json.dumps(recs,indent=2))
if __name__=='__main__':main()
