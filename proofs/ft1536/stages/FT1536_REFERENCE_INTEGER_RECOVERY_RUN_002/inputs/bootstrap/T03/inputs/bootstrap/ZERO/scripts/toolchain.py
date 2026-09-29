import json,subprocess,sys
from pathlib import Path
cmds=[['/usr/bin/gcc','--version'],['/usr/bin/gcc','-dumpmachine'],['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','--version'],
 ['/home/footfalcon/.local/bin/sage','-c','import sys; from sage.env import SAGE_VERSION; print(SAGE_VERSION); print(sys.version)'],[sys.executable,'--version']]
rows=[];text=[]
for cmd in cmds:
 p=subprocess.run(cmd,capture_output=True,timeout=60);assert p.returncode==0
 rows.append(dict(argv=cmd,exit_code=p.returncode,stdout=p.stdout.decode(),stderr=p.stderr.decode()));text+=['$ '+' '.join(cmd),p.stdout.decode(),p.stderr.decode()]
assert '14.2.0' in rows[0]['stdout'] and '4.34.0' in rows[2]['stdout'] and rows[3]['stdout'].startswith('10.9\n')
Path('TOOLCHAIN.txt').write_text('\n'.join(text));Path('artifacts/toolchain_receipts.json').write_text(json.dumps(rows,indent=2)+'\n');print('\n'.join(text))
