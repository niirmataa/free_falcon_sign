#!/usr/bin/env python3
"""Append-only command receipts; only W is writable in the child sandbox."""
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

W = Path(__file__).absolute().parents[1]
argv = sys.argv[1:]
if not argv:
    raise SystemExit("usage: run.py PROGRAM ARGS...")
start = datetime.datetime.now(datetime.timezone.utc).isoformat()
tag = "resume_" + start.replace(":", "").replace(".", "")
env = dict(os.environ)
env.update(TMPDIR=str(W / "tmp"), TMP=str(W / "tmp"), TEMP=str(W / "tmp"),
           XDG_CACHE_HOME=str(W / "cache"), DOT_SAGE=str(W / "cache/sage"),
           PYTHONPYCACHEPREFIX=str(W / "cache/pycache"),
           PYTHONDONTWRITEBYTECODE="1", MPLCONFIGDIR=str(W / "cache/mpl"),
           IPYTHONDIR=str(W / "cache/ipython"),
           JUPYTER_CONFIG_DIR=str(W / "cache/jupyter"),
           HOME=str(W / "cache/home"), GIT_OPTIONAL_LOCKS="0")
sandbox = ["/usr/bin/bwrap", "--die-with-parent", "--unshare-net",
           "--ro-bind", "/", "/", "--bind", str(W), str(W),
           "--proc", "/proc", "--dev", "/dev", "--chdir", str(W), "--"]
with (W / "resume_001/executor.lock").open("a") as lock:
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    before = hashlib.sha256((W / "COMMANDS.log").read_bytes()).hexdigest()
    tick = time.monotonic()
    p = subprocess.run(sandbox + argv, cwd=W, env=env, capture_output=True)
    paths = {}
    hashes = {}
    for stream, value in [("stdout", p.stdout), ("stderr", p.stderr)]:
        rel = "logs/" + tag + "." + stream
        with (W / rel).open("xb") as f:
            f.write(value)
        paths[stream] = rel
        hashes[stream] = hashlib.sha256(value).hexdigest()
    record = dict(start_utc=start, cwd=str(W), argv=argv,
                  sandbox_argv=sandbox, exit_code=p.returncode,
                  elapsed_seconds=time.monotonic() - tick,
                  previous_log_sha256=before, **paths,
                  stream_sha256=hashes,
                  cache_environment={k: env[k] for k in [
                      "TMPDIR", "XDG_CACHE_HOME", "DOT_SAGE", "HOME",
                      "PYTHONPYCACHEPREFIX", "PYTHONDONTWRITEBYTECODE",
                      "MPLCONFIGDIR", "IPYTHONDIR", "GIT_OPTIONAL_LOCKS"]})
    with (W / "COMMANDS.log").open("a") as f:
        f.write(json.dumps(record, sort_keys=True) + "\n")
sys.stdout.buffer.write(p.stdout)
sys.stderr.buffer.write(p.stderr)
sys.exit(p.returncode)
