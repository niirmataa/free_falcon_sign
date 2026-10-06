"""Run the paper's Sage calculator with all generated files under build/."""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

PAPER = Path(__file__).resolve().parents[1]
ROOT = PAPER.parents[2]
SOURCE = PAPER / "tools/check_numbers.sage"


def main():
    sage = shutil.which("sage")
    if sage is None:
        raise SystemExit("sage is required (standard .sage preparser)")
    number = 1
    while (PAPER / f"build/numbers/run_{number:03d}").exists():
        number += 1
    runtime = PAPER / f"build/numbers/run_{number:03d}"
    runtime.mkdir(parents=True)
    env = os.environ.copy()
    for name, subdir in {
        "HOME": "home", "TMPDIR": "tmp", "XDG_CACHE_HOME": "cache",
        "DOT_SAGE": "dot_sage", "PYTHONPYCACHEPREFIX": "pycache",
    }.items():
        path = runtime / subdir
        path.mkdir()
        env[name] = str(path)
    env["FT1536_REPO_ROOT"] = str(ROOT)
    script = runtime / "check_numbers.sage"
    shutil.copyfile(SOURCE, script)
    result_path = runtime / "numbers.json"
    command = [sage, "check_numbers.sage", str(result_path)]
    started = datetime.now(timezone.utc).isoformat()
    with (runtime / "stdout.log").open("wb") as out, (runtime / "stderr.log").open("wb") as err:
        result = subprocess.run(command, cwd=runtime, env=env, stdout=out, stderr=err)
    files = [SOURCE, script, runtime / "stdout.log", runtime / "stderr.log"]
    if result_path.exists():
        files.append(result_path)
    receipt = {
        "started_utc": started, "finished_utc": datetime.now(timezone.utc).isoformat(),
        "command": command, "cwd": str(runtime), "exit_code": result.returncode,
        "scope": "Paper display arithmetic, not a proof replay or S06 certification",
        "files": {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
    }
    (runtime / "RECEIPT.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if result.returncode:
        print((runtime / "stderr.log").read_text())
        raise SystemExit(result.returncode)
    shutil.copyfile(result_path, PAPER / "build/numbers.json")
    (PAPER / "build/NUMBERS_RECEIPT.txt").write_text(str(runtime.relative_to(PAPER) / "RECEIPT.json") + "\n")
    print(f"Sage display arithmetic PASS: {runtime.relative_to(PAPER)}/RECEIPT.json")


if __name__ == "__main__":
    main()
