"""Record the outer-tool interruption honestly; no invented child exit code."""
import datetime
import hashlib
import json
from pathlib import Path

W=Path.cwd()
record=dict(record_type="interrupted_command_observation",
            observed_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
            cwd=str(W),argv=["/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean","formal/Witness.lean"],
            termination="outer shell tool timeout after 240000 ms",
            exit_code=None,stdout=None,stderr=None,
            capture_note="run.py was interrupted before its receipt; child streams were not retained; do not infer they were empty",
            process_check="ps -C lean,python3,bwrap: no remaining matching processes after timeout",
            source_sha256=hashlib.sha256((W/"formal/Witness.lean").read_bytes()).hexdigest(),
            mathematical_result="NO_VERDICT_FROM_THIS_ATTEMPT")
with (W/"artifacts/lean_array_timeout.json").open("x") as f:json.dump(record,f,indent=2);f.write("\n")
with (W/"COMMANDS.log").open("a") as f:f.write(json.dumps(record,sort_keys=True)+"\n")
print(json.dumps(record,indent=2))
