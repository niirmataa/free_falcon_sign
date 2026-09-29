"""Coordinator pin/receipt binding only. Never execute the author's producers."""
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess

W = Path(__file__).resolve().parent
REPO = W.parents[3]
SUBJECT = REPO / "proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002"
REPORT_SHA = "b2e8c9af003edee089b49156541e631e3ab8bb01c93f9cad521edf7b66a59dfc"
OUTPUTS_SHA = "12df61056ddada2f79c1b94b3b17e8f326db2b3a2cbe53d1694754d79d7958cc"

spec = importlib.util.spec_from_file_location("archive", REPO / "proofs/ft1536/tools/archive.py")
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)


def sha(path):
    with path.open("rb") as f:
        return hashlib.file_digest(f, "sha256").hexdigest()


def load(path):
    return json.loads(path.read_text())


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def main():
    result = archive.verify_bundle(SUBJECT, "OUTPUTS.sha256", OUTPUTS_SHA,
                                  "REPORT.md", REPORT_SHA, "RESULT.json")
    outputs = archive.manifest((SUBJECT / "OUTPUTS.sha256").read_bytes())
    require(len(outputs) == 1939, "owner-declared output count differs")
    require(result["task_id"] == SUBJECT.name, "wrong task ID")
    require(result["status"] == "BLOCKED_UPSTREAM_EXPORTS", "wrong claimed status")
    require(result["owner_accepted"] is False and result["own_jobs_completed"] is True,
            "handoff flags differ")
    require(result["full_recovery_proved"] is False and result["new_uniform_source_gap_bound"] is None,
            "scope differs from external handoff")

    inputs = archive.manifest((SUBJECT / "INPUTS.sha256").read_bytes())
    for rel, expected in inputs.items():
        require(outputs.get(rel) == expected, f"input outside frozen outputs: {rel}")
        archive.checked_bytes(SUBJECT / rel, expected)
    actual_inputs = {"inputs/" + p for p in archive.regular_files(SUBJECT / "inputs")}
    require(actual_inputs == set(inputs), "input exact-set mismatch")

    receipt_index = load(SUBJECT / "EXECUTION_RECEIPTS.json")
    run_bindings = []
    for summary in receipt_index["runs"]:
        rel = summary["path"]
        require(outputs.get(rel) == summary["sha256"], f"unsealed receipt: {rel}")
        receipt = load(SUBJECT / rel)
        root = (SUBJECT / rel).parent
        require(receipt["exit_code"] == summary["exit_code"], f"exit mismatch: {rel}")
        require(len(receipt["steps"]) == summary["steps"], f"step count: {rel}")
        require(receipt["source_before"] == receipt["source_after"], f"changed run sources: {rel}")
        for name, expected in receipt["source_before"].items():
            p = root / "source" / name
            require(outputs.get(str(p.relative_to(SUBJECT))) == expected,
                    f"source snapshot not sealed: {p}")
        for step in receipt["steps"]:
            for kind in ("stdout", "stderr"):
                p = root / step[kind]
                require(outputs.get(str(p.relative_to(SUBJECT))) == step[kind + "_sha256"],
                        f"log binding: {p}")
        sealed_products = 0
        for name, expected in receipt["products"].items():
            rel_product = str((root / "build" / name).relative_to(SUBJECT))
            if rel_product in outputs:
                require(outputs[rel_product] == expected, f"product binding: {rel_product}")
                sealed_products += 1
        run_bindings.append({"receipt": rel, "sha256": summary["sha256"],
                             "exit_code": receipt["exit_code"], "steps": len(receipt["steps"]),
                             "source_snapshots": len(receipt["source_before"]),
                             "raw_log_bindings": 2 * len(receipt["steps"]),
                             "sealed_product_bindings": sealed_products})

    sages = load(SUBJECT / "SAGE_RUNS.json")
    for step in sages["runs"]:
        receipt = load(SUBJECT / step["run"] / "receipt.json")
        original = receipt["steps"][step["step"]]
        require(step["argv"] == original["argv"] and step["exit_code"] == original["exit_code"],
                "Sage argv/exit binding mismatch")
        for kind in ("stdout", "stderr"):
            require(outputs.get(step[kind]) == step[kind + "_sha256"] == original[kind + "_sha256"],
                    "Sage log binding mismatch")
        require(any(arg.endswith(".sage") for arg in step["argv"]), "not a native .sage command")

    plan = load(SUBJECT / "SEMANTIC_FILES.json")
    fresh = load(SUBJECT / "artifacts/fresh_replay.json")
    destination = SUBJECT / plan["fresh_destination"]
    require(sha(destination / "REPLAY_RESULT.json") == sha(SUBJECT / "artifacts/fresh_replay.json"),
            "fresh receipt copy differs")
    require(fresh["receipt_sha256"] == sha(destination / "receipt.json"), "fresh producer receipt differs")
    require(fresh["input_manifest_before"] == fresh["input_manifest_after"] == sha(SUBJECT / "INPUTS.sha256"),
            "fresh inputs differ")
    require(fresh["plan_sha256"] == sha(SUBJECT / "SEMANTIC_FILES.json"), "semantic plan differs")
    require(fresh["exit_code"] == 0 and fresh["status"] == "FRESH_REPLAY_PASS", "fresh result not PASS")
    require(len(fresh["matches"]) == len(plan["files"]) == 10 and
            {row["path"] for row in fresh["matches"]} == set(plan["files"]), "semantic exact-set differs")
    for row in fresh["matches"]:
        baseline = plan.get("baseline_overrides", {}).get(row["path"], plan["baseline"])
        require(row["baseline"] == baseline, "baseline override differs")
        for p in (destination / row["path"], SUBJECT / baseline / row["path"]):
            require(outputs.get(str(p.relative_to(SUBJECT))) == row["sha256"], f"semantic binding: {p}")
    require(fresh["source_before"] == fresh["source_after"], "fresh source maps differ")
    for part, sources in fresh["source_before"].items():
        for rel, expected in sources.items():
            require(outputs.get(part + "/" + rel) == expected, f"current/fresh source differs: {part}/{rel}")

    exports = load(SUBJECT / "FORMAL_EXPORTS.json")
    require(len(exports["exports"]) == exports["export_count"] == 15, "export count differs")
    require(exports["source_bound_exports"] == [], "unexpected source-bound claim")
    for row in exports["exports"]:
        require(outputs.get(row["module"]) == row["module_sha256"], "formal module binding differs")
        require(row["source_instantiated"] is False, "unexpected source instantiation claim")

    processes = []
    for p in Path("/proc").iterdir():
        if not p.name.isdigit() or int(p.name) in (os.getpid(), os.getppid()):
            continue
        try:
            comm = (p / "comm").read_text().strip()
            cwd = (p / "cwd").resolve()
            args = (p / "cmdline").read_bytes()
            if str(cwd).startswith(str(SUBJECT)) or str(SUBJECT).encode() in args:
                processes.append({"pid": int(p.name), "comm": comm, "cwd": str(cwd)})
        except (OSError, RuntimeError):
            pass

    record = {
        "schema": "T03_RUN002_COORDINATOR_INTAKE_V1", "utc": datetime.now(timezone.utc).isoformat(),
        "status": "PIN_RECEIPT_BINDING_PASS", "subject": str(SUBJECT),
        "report_sha256": REPORT_SHA, "outputs_sha256": OUTPUTS_SHA,
        "output_members": len(outputs), "output_bytes": sum((SUBJECT / p).stat().st_size for p in outputs),
        "input_members": len(inputs), "input_exact_set": True,
        "run_bindings": run_bindings, "sage_command_bindings": len(sages["runs"]),
        "semantic_bindings": len(fresh["matches"]), "formal_export_bindings": len(exports["exports"]),
        "author_status": result["status"], "author_model": result["executor"],
        "author_session": result["session_id"], "reported_jobs_completed": result["own_jobs_completed"],
        "observed_process_matches": processes,
        "mathematical_review_performed": False, "own_replay_performed": False,
        "stages_imported": False, "owner_accepted": False,
        "scope": "Bytes and recorded producer bindings only; no proof or new replay accepted here."
    }
    (W / "INTAKE.json").write_text(json.dumps(record, indent=2) + "\n")
    (W / "STATE.before.md").write_bytes((REPO / "docs/onboarding/STATE.md").read_bytes())
    (W / "STATE.head.md").write_bytes(subprocess.check_output(["git", "show", "HEAD:docs/onboarding/STATE.md"], cwd=REPO))
    print(json.dumps({key: value for key, value in record.items() if key != "run_bindings"}, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        (W / "STOP_AND_REPORT.json").write_text(json.dumps({
            "utc": datetime.now(timezone.utc).isoformat(), "error": repr(error),
            "subject_unchanged": True, "further_actions_stopped": True
        }, indent=2) + "\n")
        raise
