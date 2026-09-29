import json,subprocess,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();ev=W/'checks/HalfEval.lean';ev.write_text('import HalfMain\n#eval halfMain ["checks/half_jobs.txt", "checks/half_values.txt"]\n')
cmd=['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','-j1','-M2048','checks/HalfEval.lean']
t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=120)
(W/'logs/half_values.stdout').write_bytes(p.stdout);(W/'logs/half_values.stderr').write_bytes(p.stderr)
r=dict(argv=cmd,cwd=str(W),exit_code=p.returncode,wall_limit=120,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs/half_values.stdout'),stderr_sha256=sha(W/'logs/half_values.stderr'))
(W/'artifacts/model_values_command.json').write_text(json.dumps(r,indent=2)+'\n');assert p.returncode==0 and not p.stdout and not p.stderr,(p.stdout.decode(),p.stderr.decode())
assert (W/'checks/half_values.txt').read_bytes()==(W/'checks/half_expected.txt').read_bytes()
out=dict(status='PASS_KERNEL_HALF_MODEL_VALUES',words=len((W/'checks/half_jobs.txt').read_text().splitlines()),output_sha256=sha(W/'checks/half_values.txt'),
 scope='Raw boundary controls; universal half bit/value theorems are checked independently by the kernel audit.')
(W/'artifacts/model_values.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
