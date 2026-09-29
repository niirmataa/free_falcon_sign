#!/usr/bin/env python3
"""Literal source extraction and logged C commands; mathematical oracle is .sage."""
from pathlib import Path
import hashlib
import json
import os
import shlex
import subprocess
import sys
import time

W=Path(os.environ['RUN002_W'])
DEST=Path(os.environ['RUN002_DEST'])
OUT=DEST/'build'
SRC=W/'inputs/bootstrap/T03/inputs/bootstrap/source'
MODE=sys.argv[1]
assert MODE in ('normal','ubsan','asan')

def sha(p):
    with p.open('rb') as f: return hashlib.file_digest(f,'sha256').hexdigest()

lines=(SRC/'falcon-sign.c').read_text().splitlines(keepends=True)
terminal=''.join(lines[1632:1650])
suffix=''.join(lines[1901:1912])
assert 'r0 = fpr_add(r0, rx);' in terminal
assert 'memcpy(ty, t0, n * sizeof *t0);' in suffix
assert suffix.index('falcon_poly_mul_fft3(t1, b11') < suffix.index('falcon_poly_add_fft3(t1, ty')
license_text=''.join(lines[:next(i+1 for i,l in enumerate(lines) if '*/' in l)])
template=(DEST/'source/checks/local_slices.c.in').read_text()
code=template.replace('@LICENSE@',license_text).replace('@TERMINAL@',terminal).replace('@SUFFIX@',suffix)
assert '@TERMINAL@' not in code
(OUT/'local_slices.c').write_text(code)
make=(SRC/'Makefile').read_text()
flags=shlex.split(next(l for l in make.splitlines() if l.startswith('CFLAGS = ')).split(' = ',1)[1])
# Make's escaped quote spelling is consumed by the shell in its original build.
flags=[f.replace('\\"','"') for f in flags]
extra=[] if MODE=='normal' else ['-fsanitize='+('address' if MODE=='asan' else 'undefined'),'-fno-sanitize-recover=all','-fno-omit-frame-pointer']
compile_cmd=['/usr/bin/gcc','-std=c99',*flags,*extra,'-I'+str(SRC),'-I'+str(OUT),
             str(OUT/'local_slices.c'),str(SRC/'fpr-emulated.c'),str(SRC/'falcon-fft.c'),'-lm','-o',str(OUT/'local_slices')]
records=[]
for name,cmd in [('compile',compile_cmd),('run',[str(OUT/'local_slices')])]:
    t=time.monotonic()
    p=subprocess.run(cmd,capture_output=True)
    stdout=OUT/('C_SLICES.ndjson' if name=='run' else 'c_compile.stdout')
    stderr=OUT/(name+'.stderr')
    stdout.write_bytes(p.stdout);stderr.write_bytes(p.stderr)
    records.append({'argv':cmd,'exit_code':p.returncode,'elapsed_seconds':time.monotonic()-t,
                    'stdout':stdout.name,'stdout_sha256':sha(stdout),'stderr':stderr.name,'stderr_sha256':sha(stderr)})
    if p.returncode or p.stderr:
        (OUT/'C_COMMANDS.json').write_text(json.dumps(records,indent=2)+'\n')
        print(p.stdout.decode(errors='replace')[:8000]); print(p.stderr.decode(errors='replace')[:8000])
        raise SystemExit(p.returncode or 1)
binding={'source_file_sha256':sha(SRC/'falcon-sign.c'),
         'terminal_lines':[1633,1650],'terminal_sha256':hashlib.sha256(terminal.encode()).hexdigest(),
         'suffix_lines':[1902,1912],'suffix_sha256':hashlib.sha256(suffix.encode()).hexdigest(),
         'harness_sha256':sha(OUT/'local_slices.c'),'source_modified':False,
         'compiled_primitives':{'fpr-emulated.c':sha(SRC/'fpr-emulated.c'),'falcon-fft.c':sha(SRC/'falcon-fft.c')},
         'binding_kind':'byte-exact slices + finite execution diagnostics; not kernel source refinement'}
(OUT/'C_SOURCE_BINDING.json').write_text(json.dumps(binding,indent=2,sort_keys=True)+'\n')
(OUT/'C_COMMANDS.json').write_text(json.dumps(records,indent=2)+'\n')
print('C_PUBLIC_SLICES_'+MODE.upper()+'_PASS')
