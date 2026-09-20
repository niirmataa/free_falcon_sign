import json,subprocess,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();cmd=['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','-j1','-M2048','--run','formal/SqrtMain.lean','checks/data/sqrt_lean.input','checks/data/sqrt_lean.actual']
t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=120)
(W/'logs/lean_values.stdout').write_bytes(p.stdout);(W/'logs/lean_values.stderr').write_bytes(p.stderr)
(W/'artifacts/lean_values_command.json').write_text(json.dumps(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,elapsed=time.monotonic()-t,limit=120,stdout_sha256=sha(W/'logs/lean_values.stdout'),stderr_sha256=sha(W/'logs/lean_values.stderr')),indent=2)+'\n')
assert p.returncode==0 and not p.stdout and not p.stderr,(p.stdout.decode(),p.stderr.decode())
assert (W/'checks/data/sqrt_lean.actual').read_bytes()==(W/'checks/data/sqrt_lean.expected').read_bytes()
out=dict(status='PASS_KERNEL_MODEL_SQRT54_VALUES',cases=4096,q_and_final_remainders_match=True,output_sha256=sha(W/'checks/data/sqrt_lean.actual'))
(W/'artifacts/lean_values.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
