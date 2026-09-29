"""Coordinator checks of received review bytes/recorded evidence, without replay."""
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess

W = Path(__file__).resolve().parent
REPO = W.parents[3]
ROOT = REPO / "proofs/ft1536"
AUTHOR = ROOT / "work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002"
REVIEW_W = ROOT / "work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001"
REVIEW = REVIEW_W / "output"
PINS = {
    "author_report": "b2e8c9af003edee089b49156541e631e3ab8bb01c93f9cad521edf7b66a59dfc",
    "author_outputs": "12df61056ddada2f79c1b94b3b17e8f326db2b3a2cbe53d1694754d79d7958cc",
    "review_report": "acad9276fa7e8ed6924b8a1ada1bbf84052be330d3a0e1641a2850f2e6b5d84e",
    "review_outputs": "a4118200de729562ad1e6396c0bb252a204d9a1ee0f7d7ce085db1fb11689956",
}
spec = importlib.util.spec_from_file_location("archive", ROOT / "tools/archive.py")
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)


def sha(path):
    return hashlib.sha256(archive.read(path)).hexdigest()


def load(path):
    return json.loads(archive.read(path))


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def main():
    author_result = archive.verify_bundle(AUTHOR, "OUTPUTS.sha256", PINS["author_outputs"],
                                          "REPORT.md", PINS["author_report"], "RESULT.json")
    result = archive.verify_bundle(REVIEW, "REVIEW_OUTPUTS.sha256", PINS["review_outputs"],
                                   "REVIEW.md", PINS["review_report"], "REVIEW_RESULT.json")
    author = archive.manifest(archive.read(AUTHOR / "OUTPUTS.sha256"))
    review = archive.manifest(archive.read(REVIEW / "REVIEW_OUTPUTS.sha256"))
    require(archive.regular_files(REVIEW) == set(review) | {"REVIEW_OUTPUTS.sha256"},
            "review exact-set mismatch")
    require(result["subject_task_id"] == AUTHOR.name and result["review_id"] == REVIEW_W.name,
            "wrong subject/review ID")
    require(result["subject_report_sha256"] == PINS["author_report"] and
            result["subject_outputs_sha256"] == PINS["author_outputs"], "wrong subject pins")
    require(author_result["status"] == result["subject_status"] == "BLOCKED_UPSTREAM_EXPORTS",
            "subject status mismatch")
    require(result["verdict"] == "PASS_SCOPED_REVIEW" and result["jobs_completed"] is True,
            "wrong review outcome/job status")
    require(result["source_gap"] is None and result["full_recovery"] is False and
            result["required_domain_counterexample"] is False and result["owner_accepted"] is False,
            "scope flags mismatch")
    require(result["reviewer"]["model"] != author_result["executor"], "reviewer model same as author")

    inputs = archive.manifest(archive.read(REVIEW / "INPUTS.sha256"))
    require(sha(REVIEW / "INPUTS.sha256") == result["review_input_manifest_sha256"] ==
            sha(REVIEW_W / "inputs/MANIFEST.sha256"), "review input manifest mismatch")
    for rel, digest in inputs.items():
        archive.checked_bytes(REVIEW_W / "inputs" / rel, digest)
    require(archive.regular_files(REVIEW_W / "inputs") == set(inputs) | {"MANIFEST.sha256", "ORIGINS.json"},
            "review input exact-set mismatch")
    author_inputs = archive.manifest(archive.read(AUTHOR / "INPUTS.sha256"))
    for rel, digest in author_inputs.items():
        require(author.get(rel) == digest, f"author input not sealed: {rel}")

    run_bindings = []
    for name, expected_exit, count in (("fresh_001", 1, 1), ("fresh_002", 0, 7),
                                       ("ubsan_001", 0, 3), ("asan_001", 0, 3)):
        root = REVIEW / "evidence" / name
        receipt = load(root / "receipt.json")
        require(receipt["exit_code"] == expected_exit and len(receipt["steps"]) == count,
                f"recorded outcome differs: {name}")
        require(receipt["source_before"] == receipt["source_after"], f"source mutation: {name}")
        for rel, digest in receipt["source_before"].items():
            require(author.get(rel) == digest, f"replay did not bind final author source: {rel}")
        for step in receipt["steps"]:
            for key in ("stdout", "stderr"):
                p = root / step[key]
                require(review.get(str(p.relative_to(REVIEW))) == step[key + "_sha256"],
                        f"raw log binding mismatch: {p}")
            if expected_exit == 0:
                require(step["exit_code"] == 0 and step["clean_log"] is True, f"unclean step: {name}")
        products = []
        for rel, digest in receipt["products"].items():
            p = root / "build" / rel
            sealed = str(p.relative_to(REVIEW))
            if sealed in review:
                require(review[sealed] == digest, f"product binding mismatch: {sealed}")
                products.append(sealed)
        c_commands = root / "build/C_COMMANDS.json"
        command_logs = 0
        if c_commands.exists():
            for command in load(c_commands):
                for key in ("stdout", "stderr"):
                    rel = str((root / "build" / command[key]).relative_to(REVIEW))
                    require(review.get(rel) == command[key + "_sha256"], f"C command log mismatch: {rel}")
                    command_logs += 1
        run_bindings.append({"name": name, "receipt_sha256": sha(root / "receipt.json"),
                             "exit_code": expected_exit, "steps": count,
                             "recorded_step_seconds": sum(s["elapsed_seconds"] for s in receipt["steps"]),
                             "raw_step_logs": 2 * count, "C_command_log_bindings": command_logs,
                             "source_bindings": len(receipt["source_before"]),
                             "sealed_product_bindings": len(products)})

    fresh_root = REVIEW / "evidence/fresh_002"
    fresh = load(fresh_root / "REPLAY_RESULT.json")
    plan = load(AUTHOR / "SEMANTIC_FILES.json")
    require(fresh["status"] == "FRESH_REPLAY_PASS" and fresh["exit_code"] == 0, "fresh replay not PASS")
    require(fresh["receipt_sha256"] == sha(fresh_root / "receipt.json"), "producer receipt pin mismatch")
    require(fresh["source_before"] == fresh["source_after"], "fresh source maps differ")
    require(fresh["input_manifest_before"] == fresh["input_manifest_after"] == sha(AUTHOR / "INPUTS.sha256"),
            "fresh input pins differ")
    require(fresh["plan_sha256"] == sha(AUTHOR / "SEMANTIC_FILES.json"), "semantic plan mismatch")
    require(len(fresh["matches"]) == 10 and {r["path"] for r in fresh["matches"]} == set(plan["files"]),
            "semantic exact-set mismatch")
    for row in fresh["matches"]:
        base = plan.get("baseline_overrides", {}).get(row["path"], plan["baseline"])
        require(row["baseline"] == base and row["producer_exit_code"] == 0, "wrong semantic producer")
        require(review.get("evidence/fresh_002/" + row["path"]) == row["sha256"] ==
                author.get(base + "/" + row["path"]), "semantic byte binding mismatch")

    own_controls = []
    for name in ("input_audit", "claim_audit", "reviewer_arithmetic", "reviewer_lean", "collect_evidence"):
        require((REVIEW / (name + ".exit")).read_text().strip() == "0", f"own check exit: {name}")
        require((REVIEW / (name + ".stderr")).read_bytes() == b"", f"own check stderr: {name}")
        own_controls.append({"name": name, "recorded_exit": 0,
                             "stdout_sha256": sha(REVIEW / (name + ".stdout")),
                             "stderr_sha256": sha(REVIEW / (name + ".stderr"))})
    own_sources = {p: review[p] for p in ("reviewer_arithmetic.sage", "Reviewer.lean", "REVIEW_SAGE.json")}

    processes = []
    roots = (str(AUTHOR), str(REVIEW_W))
    for p in Path("/proc").iterdir():
        if not p.name.isdigit() or int(p.name) in (os.getpid(), os.getppid()):
            continue
        try:
            cwd = str((p / "cwd").resolve())
            args = (p / "cmdline").read_bytes()
            if cwd.startswith(roots) or any(root.encode() in args for root in roots):
                processes.append({"pid": int(p.name), "comm": (p / "comm").read_text().strip(), "cwd": cwd})
        except (OSError, RuntimeError):
            pass
    record = {"schema": "T03_RUN002_ACCEPTED_REVIEW_BINDING_V1",
              "observed_utc": datetime.now(timezone.utc).isoformat(),
              "status": "PIN_RECEIPT_BINDING_PASS", "pins": PINS,
              "author_outputs": len(author), "author_inputs": len(author_inputs),
              "review_outputs": len(review), "review_inputs": len(inputs),
              "review_output_bytes": sum((REVIEW / p).stat().st_size for p in review),
              "reviewer": result["reviewer"], "verdict": result["verdict"],
              "accepted_scope": result["accepted_scope"], "run_bindings": run_bindings,
              "semantic_bindings": 10, "own_control_sidecars": own_controls,
              "own_sources_and_result": own_sources,
              "known_evidence_limit": "First three reviewer Sage stderr overwritten; final source/log/exit/result sealed. No fabricated early raw logs or execution-source receipts.",
              "review_inputs_origin": str(REVIEW_W / "inputs"),
              "review_import_layout": "INPUTS paths are relative to reviewer inputs, not output; create byte-identical import-source with those origins, preserve original manifest.",
              "process_matches": processes, "mathematical_review_repeated": False,
              "new_replay_performed": False, "owner_accepted": False}
    (W / "REVIEW_BINDING.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
    (W / "STATE.before.md").write_bytes((REPO / "docs/onboarding/STATE.md").read_bytes())
    (W / "STATE.head.md").write_bytes(subprocess.check_output(["git", "show", "HEAD:docs/onboarding/STATE.md"], cwd=REPO))
    print(json.dumps({k: record[k] for k in ("status", "author_outputs", "author_inputs", "review_outputs",
                                           "review_inputs", "review_output_bytes", "run_bindings", "process_matches")}, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        (W / "STOP_AND_REPORT.json").write_text(json.dumps({
            "observed_utc": datetime.now(timezone.utc).isoformat(), "error": repr(error),
            "author_and_review_unchanged": True, "further_actions_stopped": True
        }, indent=2) + "\n")
        raise
