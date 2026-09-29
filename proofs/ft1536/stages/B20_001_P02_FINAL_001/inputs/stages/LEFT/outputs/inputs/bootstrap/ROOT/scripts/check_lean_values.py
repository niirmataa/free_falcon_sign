import json,subprocess,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();cmd=['/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean','-j1','-M2048','--run','formal/RootModel.lean','checks/model_jobs.txt','checks/model_values.txt']
t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=120)
(W/'logs/model_values.stdout').write_bytes(p.stdout);(W/'logs/model_values.stderr').write_bytes(p.stderr)
receipt=dict(argv=cmd,cwd=str(W),exit_code=p.returncode,wall_limit=120,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs/model_values.stdout'),stderr_sha256=sha(W/'logs/model_values.stderr'))
(W/'artifacts/model_values_command.json').write_text(json.dumps(receipt,indent=2)+'\n')
assert p.returncode==0 and not p.stdout and not p.stderr,(p.stdout.decode(),p.stderr.decode())
assert (W/'checks/model_values.txt').read_bytes()==(W/'checks/model_expected.txt').read_bytes()
out=dict(status='PASS_KERNEL_MODEL_VALUES',pairs=len((W/'checks/model_jobs.txt').read_text().splitlines()),
 operations=['mulC','divC'],output_sha256=sha(W/'checks/model_values.txt'),native_and_literal_raw_bits_equal=True,
 scope='Value binding controls, not a universal compiler refinement or error theorem.')
(W/'artifacts/model_values.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
