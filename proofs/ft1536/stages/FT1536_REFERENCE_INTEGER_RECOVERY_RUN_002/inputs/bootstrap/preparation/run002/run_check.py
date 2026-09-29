"""Organize one new Sage budget check; no old producer or proof replay."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
from datetime import datetime, timezone

W = Path(__file__).resolve().parent
REPO = W.parents[3]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def utc():
    return datetime.now(timezone.utc).isoformat()


def main():
    stage = REPO / "proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001"
    external = {
        "REPORT.md": "e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c",
        "OUTPUTS.sha256": "0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de",
    }
    for name, expected in external.items():
        if sha(stage / name) != expected:
            raise SystemExit(f"STOP_AND_REPORT: external pin mismatch: {name}")
    manifest = {}
    for line in (stage / "OUTPUTS.sha256").read_text().splitlines():
        digest, rel = line.split("  ", 1)
        if rel in manifest or Path(rel).is_absolute() or ".." in Path(rel).parts:
            raise SystemExit("STOP_AND_REPORT: malformed manifest")
        path = stage / rel
        if path.is_symlink() or not path.is_file() or sha(path) != digest:
            raise SystemExit(f"STOP_AND_REPORT: member mismatch: {rel}")
        manifest[rel] = digest

    inputs = W / "inputs"
    inputs.mkdir(exist_ok=True)
    selected = ["REPORT.md", "OUTPUTS.sha256", "SOURCE_ERROR.md", "SOURCE_ERROR.json",
                "checks/gap_composition.json", "checks/constants_extract.json",
                "checks/sage/gap_composition.sage", "EXACT_SKELETON.md"]
    members = []
    for name in selected:
        dest = inputs / "T03" / name
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists():
            if sha(dest) != sha(stage / name):
                raise SystemExit(f"STOP_AND_REPORT: existing input mismatch: {name}")
        else:
            shutil.copyfile(stage / name, dest)
            dest.chmod(0o444)
        members.append({"path": str(dest.relative_to(W)), "sha256": sha(dest),
                        "origin": str((stage / name).relative_to(REPO))})
    input_manifest = "".join(f"{m['sha256']}  {m['path']}\n" for m in members)
    if (W / "INPUTS.sha256").exists():
        if (W / "INPUTS.sha256").read_text() != input_manifest:
            raise SystemExit("STOP_AND_REPORT: changed input manifest")
    else:
        (W / "INPUTS.sha256").write_text(input_manifest)
        (W / "INPUT_BINDING.json").write_text(json.dumps({
            "checked_utc": utc(), "external_pins": external,
            "verified_output_members": len(manifest), "selected_inputs": members,
            "scope": "pin-byte binding and task preparation, no mathematical review"
        }, indent=2) + "\n")

    run_name = sys.argv[1]
    if not run_name.startswith("run") or not run_name[3:].isdigit():
        raise SystemExit("expected runNNN")
    run = W / run_name
    run.mkdir(exist_ok=False)
    for rel in ("home", "tmp", "cache", "sage", "config", "data"):
        (run / rel).mkdir()
    shutil.copyfile(W / "check_budget.sage", run / "check_budget.sage")
    shutil.copyfile(Path(__file__), run / "run_check.py")
    source_before = sha(run / "check_budget.sage")
    env = {
        "PATH": "/home/footfalcon/.local/bin:/home/footfalcon/miniforge3/bin:/usr/bin:/bin",
        "HOME": str(run / "home"), "TMPDIR": str(run / "tmp"),
        "TMP": str(run / "tmp"), "TEMP": str(run / "tmp"),
        "DOT_SAGE": str(run / "sage"), "XDG_CACHE_HOME": str(run / "cache"),
        "XDG_CONFIG_HOME": str(run / "config"), "XDG_DATA_HOME": str(run / "data"),
        "MAMBA_ROOT_PREFIX": "/home/footfalcon/miniforge3",
        "CONDA_ENVS_PATH": "/home/footfalcon/miniforge3/envs",
        "PYTHONDONTWRITEBYTECODE": "1", "OMP_NUM_THREADS": "1",
        "OPENBLAS_NUM_THREADS": "1", "LANG": "C.UTF-8",
    }
    argv = ["/usr/bin/bwrap", "--die-with-parent", "--unshare-net",
            "--ro-bind", "/", "/", "--bind", str(W), str(W),
            "--ro-bind", str(inputs), str(inputs), "--proc", "/proc",
            "--dev", "/dev", "--chdir", str(run), "/usr/bin/prlimit",
            "--as=8589934592", "--cpu=120", "--",
            "/home/footfalcon/.local/bin/sage", "check_budget.sage",
            str(inputs), str(run / "BUDGET_CHECK.json")]
    start = utc()
    with (run / "stdout.log").open("wb") as out, (run / "stderr.log").open("wb") as err:
        completed = subprocess.run(argv, cwd=run, env=env, stdout=out, stderr=err,
                                   timeout=180, check=False)
    receipt = {"argv": argv, "cwd": str(run), "env": env, "start_utc": start,
               "end_utc": utc(), "exit_code": completed.returncode,
               "source_sha256_before": source_before,
               "source_sha256_after": sha(run / "check_budget.sage"),
               "runner_sha256": sha(run / "run_check.py"),
               "launcher_sha256": sha(Path("/home/footfalcon/.local/bin/sage")),
               "input_manifest_sha256": sha(W / "INPUTS.sha256"),
               "stdout_sha256": sha(run / "stdout.log"),
               "stderr_sha256": sha(run / "stderr.log")}
    if (run / "BUDGET_CHECK.json").exists():
        receipt["output_sha256"] = sha(run / "BUDGET_CHECK.json")
    (run / "EXECUTION_RECEIPT.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print((run / "stdout.log").read_text())
    if completed.returncode:
        print((run / "stderr.log").read_text(), file=sys.stderr)
        raise SystemExit(completed.returncode)
    assert source_before == receipt["source_sha256_after"]
    assert all(sha(W / m["path"]) == m["sha256"] for m in members)
    print(f"Pin binding: {len(manifest)} members; receipt: {run / 'EXECUTION_RECEIPT.json'}")


if __name__ == "__main__":
    main()
