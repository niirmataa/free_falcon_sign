import json,subprocess,sys
from pathlib import Path
commands=[['/usr/bin/gcc','--version'],['/usr/bin/gcc','-dumpmachine'],
 ['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','--version'],
 ['/home/footfalcon/.local/bin/sage','-c','import sys; from sage.env import SAGE_VERSION; print(SAGE_VERSION); print(sys.version)'],
 [sys.executable,'--version']]
records=[];text=[]
for argv in commands:
    p=subprocess.run(argv,capture_output=True,timeout=60)
    records.append(dict(argv=argv,exit_code=p.returncode,stdout=p.stdout.decode(),stderr=p.stderr.decode()))
    text+=['$ '+' '.join(argv),p.stdout.decode(),p.stderr.decode()];assert p.returncode==0
assert '14.2.0' in records[0]['stdout'] and 'x86_64' in records[1]['stdout']
assert '4.34.0' in records[2]['stdout'] and records[3]['stdout'].startswith('10.9\n')
Path('TOOLCHAIN.txt').write_text('\n'.join(text))
Path('artifacts/toolchain_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
print('\n'.join(text))
