import hashlib,json,subprocess
from pathlib import Path
W=Path.cwd();jobs=[];native=[]
for line in (W/'checks/logs/normal/run.stdout').read_text().splitlines():
 a=line.split()
 if a[0]!='inside':continue
 _,idx,x,s,z,y,os,oy,r,res,d=a;jobs.append(f'{int(x,16)} {z}\n')
 native.append([int(x,16),int(z),int(s)]+[int(v,16) for v in [os,oy,r,res,d]])
(W/'checks/model_jobs.txt').write_text(''.join(jobs))
cmd=['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','-j1','-M2048','--run','formal/ModelMain.lean','checks/model_jobs.txt','checks/model_values.txt']
p=subprocess.run(cmd,capture_output=True,timeout=120)
(W/'logs/model_runtime.stdout').write_bytes(p.stdout);(W/'logs/model_runtime.stderr').write_bytes(p.stderr)
assert p.returncode==0 and b'warning:' not in p.stdout+p.stderr,(p.stdout.decode(),p.stderr.decode())
actual=[list(map(int,s.split())) for s in (W/'checks/model_values.txt').read_text().splitlines()]
assert actual==native
out=dict(status='PASS',cases=len(native),source_normalized_Lean_matches_literal_C_raw_words=True,
 argv=cmd,exit_code=p.returncode,model_values_sha256=hashlib.sha256((W/'checks/model_values.txt').read_bytes()).hexdigest(),
 scope='Finite binding control, distinct from universal analytical source-subtraction proof.')
(W/'artifacts/lean_value_checks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
