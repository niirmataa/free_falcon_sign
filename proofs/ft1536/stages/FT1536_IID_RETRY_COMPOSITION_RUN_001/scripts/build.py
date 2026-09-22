import json,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','sanitized'];flags=shlex.split(next(s.split('=',1)[1].strip() for s in (W/'source/Makefile').read_text().splitlines() if s.startswith('CFLAGS =')));assert '-O' in flags;rows=[]
for name in ['retry','reset']:
 cmd=['gcc','-std=c99']+flags+['-Isource','checks/'+name+'.c','source/fpr-emulated.c','-lm','-o','bin/'+name+'-'+mode]
 if mode=='sanitized':cmd+=['-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-g','-no-pie']
 t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=100);tag='build_'+mode+'_'+name
 for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/(tag+'.'+s)).write_bytes(b)
 rows.append(dict(argv=cmd,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/(tag+'.stdout')),stderr_sha256=sha(W/'logs'/(tag+'.stderr')),source_changed=False));(W/'artifacts'/('build_'+mode+'.json')).write_text(json.dumps(rows,indent=2)+'\n')
 sys.stdout.buffer.write(p.stdout);sys.stderr.buffer.write(p.stderr);assert p.returncode==0 and not p.stderr;print('PASS_BUILD',mode,name)
