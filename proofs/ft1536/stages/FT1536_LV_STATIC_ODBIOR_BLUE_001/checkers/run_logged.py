#!/usr/bin/env python3
"""Run one argv without a shell and append a local audit receipt."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

W = Path(__file__).resolve().parents[1]
argv = sys.argv[1:]
if not argv:
    raise SystemExit("missing argv")

env = dict(os.environ)
env.update({
    "TMPDIR": str(W / "work" / "tmp"),
    "TMP": str(W / "work" / "tmp"),
    "TEMP": str(W / "work" / "tmp"),
    "XDG_CACHE_HOME": str(W / "work" / "cache"),
    "DOT_SAGE": str(W / "work" / "dot_sage"),
    "PYTHONPYCACHEPREFIX": str(W / "work" / "cache" / "pycache"),
    "GIT_OPTIONAL_LOCKS": "0",
})
started = datetime.datetime.now(datetime.timezone.utc).isoformat()
tag = started.replace(":", "").replace(".", "")
t0 = time.monotonic()
p = subprocess.run(argv, cwd=W, env=env, capture_output=True)
elapsed = time.monotonic() - t0
out_rel = f"logs/{tag}.stdout"
err_rel = f"logs/{tag}.stderr"
(W / out_rel).write_bytes(p.stdout)
(W / err_rel).write_bytes(p.stderr)
record = {
    "started_utc": started,
    "cwd": str(W),
    "argv": argv,
    "exit_code": p.returncode,
    "elapsed_seconds": elapsed,
    "stdout": out_rel,
    "stdout_sha256": hashlib.sha256(p.stdout).hexdigest(),
    "stderr": err_rel,
    "stderr_sha256": hashlib.sha256(p.stderr).hexdigest(),
    "environment": {k: env[k] for k in (
        "TMPDIR", "XDG_CACHE_HOME", "DOT_SAGE", "PYTHONPYCACHEPREFIX",
        "GIT_OPTIONAL_LOCKS")},
}
for key in ("ASAN_OPTIONS", "UBSAN_OPTIONS"):
    if key in env:
        record["environment"][key] = env[key]
with (W / "COMMANDS.log").open("a", encoding="utf-8") as f:
    f.write(json.dumps(record, sort_keys=True) + "\n")
sys.stdout.buffer.write(p.stdout)
sys.stderr.buffer.write(p.stderr)
raise SystemExit(p.returncode)
