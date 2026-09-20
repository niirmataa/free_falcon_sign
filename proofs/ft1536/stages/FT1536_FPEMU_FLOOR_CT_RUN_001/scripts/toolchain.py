import json,subprocess,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();jobs=[['/usr/bin/gcc','--version'],['/usr/bin/gcc','-dumpmachine'],['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','--version'],['/usr/bin/objdump','--version'],['/usr/bin/python3','--version']]
texts=[];rows=[]
for i,cmd in enumerate(jobs):
 t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=30)
 for k,v in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/f'toolchain_{i}.{k}').write_bytes(v)
 rows.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,wall_limit=30,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/f'toolchain_{i}.stdout'),stderr_sha256=sha(W/'logs'/f'toolchain_{i}.stderr')))
 assert p.returncode==0;texts.append('$ '+' '.join(cmd)+'\n'+p.stdout.decode()+p.stderr.decode())
text='\n\n'.join(texts)+'\n';assert '14.2.0-19' in text and '4.34.0' in text
(W/'TOOLCHAIN.txt').write_text(text);(W/'artifacts/toolchain_commands.json').write_text(json.dumps(rows,indent=2)+'\n');print(text)
