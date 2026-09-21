import errno,json,os,subprocess,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();jobs=[['/usr/bin/gcc','--version'],['/usr/bin/gcc','-dumpmachine'],['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','--version'],['/home/footfalcon/.local/bin/sage','--version'],['/usr/bin/python3','--version']];rows=[];texts=[]
for i,cmd in enumerate(jobs):
 t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=45)
 for s,data in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/f'toolchain_{i}.{s}').write_bytes(data)
 rows.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,limit=45,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/f'toolchain_{i}.stdout'),stderr_sha256=sha(W/'logs'/f'toolchain_{i}.stderr')))
 assert p.returncode==0;texts.append('$ '+' '.join(cmd)+'\n'+p.stdout.decode()+p.stderr.decode())
mounts=[s.split() for s in Path('/proc/self/mountinfo').read_text().splitlines()]
for p in [W/'source/falcon-sign.c',W/'inputs/bootstrap/MANIFEST.sha256']:
 cover=max((f for f in mounts if str(p)==f[4] or str(p).startswith(f[4].rstrip('/')+'/')),key=lambda f:len(f[4]));assert 'ro' in cover[5].split(',')
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);raise AssertionError('source not readonly')
 except OSError as e:assert e.errno in [errno.EROFS,errno.EACCES]
text='\n\n'.join(texts)+'\n';assert '14.2.0-19' in text and '4.34.0' in text and '10.9' in text
(W/'TOOLCHAIN.txt').write_text(text);(W/'artifacts/toolchain_commands.json').write_text(json.dumps(rows,indent=2)+'\n');print(text)
