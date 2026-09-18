import subprocess,sys,json
from pathlib import Path
line=next(l for l in Path('reference/Makefile').read_text().splitlines() if l.startswith('CFLAGS ='))
import shlex
flags=shlex.split(line.split('=',1)[1])
sources=['scripts/harness.c','reference/falcon-enc.c','reference/shake.c']
mode=sys.argv[1] if len(sys.argv)>1 else 'normal'
extra=['-shared','-fPIC'] if mode=='shared' else ['-DLV_MAIN']
if mode=='sanitize': extra+=['-fsanitize=undefined,address','-fno-sanitize-recover=all','-g']
out='bin/lv.so' if mode=='shared' else 'bin/lv-'+mode
argv=['/usr/bin/gcc',*flags,*extra,'-Ireference',*sources,'-o',out,'-lm']
print(json.dumps({'argv':argv}),flush=True)
subprocess.run(argv,check=True)
