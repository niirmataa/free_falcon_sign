"""Fresh process replay of the frozen-source verifier, with explicit c."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

W=Path.cwd(); kind=sys.argv[1]
assert kind in ("normal","sanitize")
build=json.loads((W/("artifacts/build-base-"+kind+".json")).read_text())
binary=W/build["binary"]
assert hashlib.sha256(binary.read_bytes()).hexdigest()==build["binary_sha256"]
w=json.loads((W/"artifacts/witness.json").read_text())
assert bytes.fromhex(w["payload_hex"])==(W/"artifacts/witness.bin").read_bytes()
assert w["c"]==list(map(int,(W/"artifacts/witness_c.txt").read_text().split()))
argv=[str(binary),"inputs/key/canonical_public_key.bin","artifacts/witness_c.txt","artifacts/witness.bin"]
p=subprocess.run(argv,capture_output=True,text=True)
receipt=dict(argv=argv,cwd=str(W),exit_code=p.returncode,stdout=p.stdout,stderr=p.stderr,
             stdout_sha256=hashlib.sha256(p.stdout.encode()).hexdigest(),
             stderr_sha256=hashlib.sha256(p.stderr.encode()).hexdigest(),
             binary_sha256=build["binary_sha256"],
             witness_sha256=hashlib.sha256((W/"artifacts/witness.json").read_bytes()).hexdigest())
with (W/("artifacts/c-replay-"+kind+".json")).open("x") as f:
    json.dump(receipt,f,indent=2);f.write("\n")
print(json.dumps(receipt,indent=2),flush=True)
assert p.returncode==0, "C replay execution failed; not a mathematical verdict"
r=json.loads(p.stdout)
assert r["loader"]==r["verify"]==r["raw"]==r["point_calls"]==1
assert r["machine_norm"]==400000000 and r["decoded_bytes"]==1930
assert r["payload_bytes"]==1931 and r["s0"]==-20000 and r["preNTT0"]==63969
assert r["cast65535"]==-1 and r["cast32768"]==-32768
assert not p.stderr
print("UNCHANGED_C_REPLAY",kind,"PASS")
