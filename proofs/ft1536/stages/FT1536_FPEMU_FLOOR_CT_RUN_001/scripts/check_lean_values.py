import json,subprocess,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();cmd=['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','-j1','-M2048','--run','formal/FloorMain.lean','checks/data/lean_inputs.txt','checks/data/lean_values.txt']
t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=120)
(W/'logs/lean_values.stdout').write_bytes(p.stdout);(W/'logs/lean_values.stderr').write_bytes(p.stderr)
(W/'artifacts/lean_values_command.json').write_text(json.dumps(dict(argv=cmd,cwd=str(W),limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs/lean_values.stdout'),stderr_sha256=sha(W/'logs/lean_values.stderr')),indent=2)+'\n')
assert p.returncode==0 and not p.stdout and not p.stderr,(p.stdout.decode(),p.stderr.decode())
assert (W/'checks/data/lean_values.txt').read_bytes()==(W/'checks/data/lean_expected.txt').read_bytes()
out=dict(status='PASS_ALL_EXPONENT_MODEL_VALUES',cases=12288,output_sha256=sha(W/'checks/data/lean_values.txt'),universal_proof_separate=True)
(W/'artifacts/lean_values.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
