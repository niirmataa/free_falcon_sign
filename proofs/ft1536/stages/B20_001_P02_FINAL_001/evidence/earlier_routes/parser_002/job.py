#!/usr/bin/env python3
"""One bounded, network-off W-only job with immutable source snapshots."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time

W = Path(__file__).resolve().parents[1]
REPO = W.parents[4]
LEAN = "/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean"
LIB = REPO / "proofs/ft1536/work/B20_001/P01/bootstrap/mathlib4"
PACKAGES = REPO / "proofs/ft1536/work/B20_001/P01/run/.lake/packages"


def digest(path):
    with path.open("rb") as handle:
        return hashlib.file_digest(handle, "sha256").hexdigest()


def stamp():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def main():
    name, mode, *args = sys.argv[1:]
    assert name.replace("_", "").isalnum()
    dest = W / "run" / name
    dest.mkdir()
    shutil.copy2(__file__, dest / "job.py")
    source = W / "src"
    shutil.copytree(source, dest / "source")
    files = {str(p.relative_to(dest / "source")): digest(p) for p in sorted((dest / "source").rglob("*")) if p.is_file()}
    for p in (dest / "source").rglob("*"):
        if p.is_file():
            p.chmod(0o444)
    for part in ["build", "home", "tmp", "cache", "sage", "config", "data"]:
        (dest / part).mkdir()
    env = {k: v for k, v in os.environ.items() if k in ["PATH", "LANG", "LC_ALL", "TERM"]}
    env.update({"HOME": str(dest / "home"), "TMPDIR": str(dest / "tmp"), "TMP": str(dest / "tmp"), "TEMP": str(dest / "tmp"), "DOT_SAGE": str(dest / "sage"), "XDG_CACHE_HOME": str(dest / "cache"), "XDG_CONFIG_HOME": str(dest / "config"), "XDG_DATA_HOME": str(dest / "data"), "PYTHONDONTWRITEBYTECODE": "1", "OMP_NUM_THREADS": "1", "OPENBLAS_NUM_THREADS": "1", "P02_INPUTS": str(W / "inputs"), "P02_DEST": str(dest)})
    libpaths = [LIB / ".lake/build/lib/lean"] + [p / ".lake/build/lib/lean" for p in sorted(PACKAGES.iterdir()) if p.is_dir()]
    env["LEAN_PATH"] = ":".join(map(str, [dest / "build"] + libpaths))
    sandbox = ["/usr/bin/bwrap", "--die-with-parent", "--unshare-net", "--ro-bind", "/", "/", "--dev-bind", "/dev", "/dev", "--bind", str(dest), str(dest), "--ro-bind", str(dest / "source"), str(dest / "source"), "--bind", str(dest / "tmp"), "/tmp", "--chdir", str(dest / "source")]
    if mode == "lean":
        commands = []
        for rel in args:
            src = dest / "source" / rel
            out = dest / "build" / Path(rel).with_suffix(".olean")
            out.parent.mkdir(parents=True, exist_ok=True)
            commands.append([LEAN, "-j1", "-M2048", "--root=" + str(dest / "source"), "-o", str(out), str(src)])
    elif mode == "command":
        commands = [[a.replace("{source}", str(dest / "source")).replace("{dest}", str(dest)) for a in args]]
    else:
        raise ValueError(mode)
    receipt = {"name": name, "start": stamp(), "wall_limit_per_step_s": 1800, "address_space_bytes": 8 * 1024**3, "network": "bwrap --unshare-net", "writable_project_root": str(dest), "source_before": files, "environment": env, "steps": []}
    rc = 0
    for index, command in enumerate(commands):
        argv = sandbox + ["/usr/bin/prlimit", "--as=8589934592", "--"] + command
        out = dest / f"{index:03d}.stdout"
        err = dest / f"{index:03d}.stderr"
        start = stamp()
        t = time.monotonic()
        timed_out = False
        with out.open("wb") as so, err.open("wb") as se:
            try:
                p = subprocess.run(argv, env=env, stdout=so, stderr=se, timeout=1800)
                code = p.returncode
            except subprocess.TimeoutExpired:
                code = 124
                timed_out = True
        receipt["steps"].append({"argv": argv, "cwd": str(dest / "source"), "start": start, "stop": stamp(), "elapsed_s": time.monotonic() - t, "exit_code": code, "timeout": timed_out, "stdout": out.name, "stdout_sha256": digest(out), "stderr": err.name, "stderr_sha256": digest(err)})
        print(f"{name}/{index}: exit={code}", flush=True)
        print(out.read_text(errors="replace")[-12000:], end="")
        print(err.read_text(errors="replace")[-12000:], end="")
        if code:
            rc = code
            break
    receipt["stop"] = stamp()
    receipt["source_after"] = {str(p.relative_to(dest / "source")): digest(p) for p in sorted((dest / "source").rglob("*")) if p.is_file()}
    receipt["sources_unchanged"] = receipt["source_before"] == receipt["source_after"]
    receipt["products"] = {str(p.relative_to(dest)): digest(p) for p in sorted((dest / "build").rglob("*")) if p.is_file()}
    receipt["exit_code"] = rc
    (dest / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
    assert receipt["sources_unchanged"]
    return rc


if __name__ == "__main__":
    sys.exit(main())
