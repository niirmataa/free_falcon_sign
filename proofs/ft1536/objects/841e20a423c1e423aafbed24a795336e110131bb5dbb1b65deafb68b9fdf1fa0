"""Bind the received P02 v2 bytes and receipts without running its producers."""
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess

W = Path(__file__).resolve().parent
REPO = W.parents[5]
ROOT = REPO / "proofs/ft1536"
O = ROOT / "work/FT1536_P02_FREEZE_CLOSURE_RUN_001/output"
REPORT = "ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5"
OUTPUTS = "af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e"
HEAD = "41216bb8d61004bb941a8d1b276f43346df11ce8"
spec = importlib.util.spec_from_file_location("archive", ROOT / "tools/archive.py")
a = importlib.util.module_from_spec(spec)
spec.loader.exec_module(a)


def load(path):
    return json.loads(a.read(path))


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def main():
    result = a.verify_bundle(O, "OUTPUTS.sha256", OUTPUTS, "REPORT.md", REPORT, "RESULT.json")
    rows = a.manifest(a.read(O / "OUTPUTS.sha256"))
    require(len(rows) == 30612, "external output count differs")
    require(a.regular_files(O) == set(rows) | {"OUTPUTS.sha256"}, "output exact-set mismatch")
    require(result["task_id"] == "B20_001_P02_WORD_FPEMU_REFINEMENT" and result["pair"] == "V02", "wrong pair")
    require(result["status"] == "PARTIAL_PROOF" and result["complete_for_review"] is True, "wrong status")
    require(result["new_package_head"] == HEAD and result["owner_accepted"] is False, "HEAD/flags differ")
    static = a.manifest(a.checked_bytes(O / "INPUTS.sha256",
        "b0a57afa260c403a11901ef29676104729306c02ecd856b07170ec261ab76045"))
    for rel, digest in static.items():
        require(rows.get(rel) == digest, f"input is not sealed: {rel}")
    static_dirs = ("inputs", "formal", "predecessor", "evidence", "context", "library_provenance", "replay")
    actual_static = {rel for rel in rows if rel.split("/", 1)[0] in static_dirs}
    actual_static.add("SEMANTIC_FILES.json")
    require(actual_static == set(static), "static exact-set mismatch")
    previous = a.manifest(a.checked_bytes(O / "predecessor/OUTPUTS.sha256",
        "4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01"))
    for rel, digest in previous.items():
        require(rows.get("predecessor/" + rel) == digest, f"changed predecessor: {rel}")
        if rel.startswith("formal/"):
            require(rows.get(rel) == digest, f"changed old formal source: {rel}")

    fresh = load(O / "REPLAY_RESULT.json")
    recipe = load(O / "SEMANTIC_FILES.json")
    receipt = load(O / fresh["receipt"])
    fresh_dir = (O / fresh["receipt"]).parent
    require(fresh["status"] == "FRESH_REPLAY_PASS" and len(receipt["steps"]) == fresh["steps"] == 43,
            "fresh count/status differs")
    require(receipt["exit_code"] == 0 and receipt["sources_unchanged"] is True, "fresh failed")
    require(receipt["source_before"] == receipt["source_after"] == fresh["source_before"] == fresh["source_after"],
            "source maps differ")
    for rel, digest in receipt["source_before"].items():
        require(rows.get("formal/" + rel) == digest, f"current/fresh source mismatch: {rel}")
    child_count = 0
    for step in receipt["steps"]:
        require(step["exit_code"] == 0 and step["clean"] is True, "unclean fresh step")
        for key in ("stdout", "stderr"):
            rel = str((fresh_dir / step[key]).relative_to(O))
            require(rows.get(rel) == step[key + "_sha256"], f"fresh log mismatch: {rel}")
        if "child_receipt_snapshot" in step:
            path = fresh_dir / step["child_receipt_snapshot"]
            children = load(path)
            require(len(children) == step["child_commands_snapshotted"], "child command count differs")
            for command in children:
                for key in ("stdout", "stderr"):
                    rel = str((path.parent / (command["name"] + "." + key)).relative_to(O))
                    require(rows.get(rel) == command[key + "_sha256"], f"child log mismatch: {rel}")
                child_count += 1
    matches = fresh["matched_semantics"]
    require(len(matches) == len(recipe["matches"]) == 16, "semantic count differs")
    declared = {r["path"]: r for r in recipe["matches"]}
    require(set(declared) == {r["path"] for r in matches}, "semantic path set differs")
    for match in matches:
        expected = declared[match["path"]]
        require(match["baseline"] == expected["baseline"] and match["sha256"] == expected["sha256"],
                "semantic plan/baseline changed")
        step = receipt["steps"][match["producer_step"]]
        require(step["argv"] == match["producer_argv"] and step["exit_code"] == match["producer_exit"] == 0,
                "semantic producer mismatch")
        product = fresh_dir / (match["path"] if match["path"].startswith("build/") else step["stdout"])
        require(rows.get(str(product.relative_to(O))) == match["sha256"] == rows.get(match["baseline"]),
                "semantic byte binding mismatch")

    modules = load(O / "formal/BUILD_PLAN.json")["modules"]
    require(len(modules) == 34 and all("formal/" + m in rows for m in modules), "incomplete module closure")
    for rel, digest in load(O / "FREEZE_CLOSURE.json")["F2"]["sha256"].items():
        require(rows.get("formal/" + rel) == digest, "audit source binding mismatch")
    full_print = (fresh_dir / "logs/042.stdout").read_text()
    require("⋯" not in full_print and "\n...\n" not in full_print, "final printed terms truncated")

    history = load(O / "EXECUTION_RECEIPTS.json")["history"]["runs"]
    historic_steps = 0
    for run in history:
        d = O / "evidence/prior_run" / run["id"]
        rec = load(d / "receipt.json")
        require(rec["exit_code"] == 0 and len(rec["steps"]) == run["steps"], "historical outcome differs")
        require(rec["source_before"] == rec["source_after"], "historical source maps differ")
        for rel, digest in rec["source_before"].items():
            require(rows.get(str((d / "source" / rel).relative_to(O))) == digest, "historical source binding differs")
        for step in rec["steps"]:
            for key in ("stdout", "stderr"):
                require(rows.get(str((d / step[key]).relative_to(O))) == step[key + "_sha256"], "historical raw log differs")
        historic_steps += len(rec["steps"])
    overwritten = load(O / "OVERWRITTEN_LOGS.json")
    require(overwritten["count"] == len(overwritten["rows"]) == 6, "overwrite count differs")
    for item in overwritten["rows"]:
        require(rows.get(item["overwritten_path"]) == item["overwritten_hash"], "overwritten bytes differ")
        require(rows.get(item["replacement_path"]) == rows.get(item["byte_identical_origin"]) == item["expected_hash"],
                "equivalent log bytes mismatch")

    process_matches = []
    roots = (str(O.parent), str(ROOT / "work/B20_001/V02"))
    for p in Path("/proc").iterdir():
        if not p.name.isdigit() or int(p.name) in (os.getpid(), os.getppid()):
            continue
        try:
            cwd = str((p / "cwd").resolve())
            args = (p / "cmdline").read_bytes()
            if cwd.startswith(roots) or any(root.encode() in args for root in roots):
                process_matches.append({"pid": int(p.name), "comm": (p / "comm").read_text().strip(), "cwd": cwd})
        except (OSError, RuntimeError):
            pass
    record = {"utc": datetime.now(timezone.utc).isoformat(), "status": "PIN_RECEIPT_BINDING_PASS",
              "task_id": result["task_id"], "author_status": result["status"], "head": HEAD,
              "report_sha256": REPORT, "outputs_sha256": OUTPUTS,
              "output_members": len(rows), "output_bytes": sum((O / p).stat().st_size for p in rows),
              "static_inputs": len(static), "predecessor_outputs": len(previous),
              "formal_plan_modules": len(modules), "fresh_source_bindings": len(receipt["source_before"]),
              "fresh_steps": len(receipt["steps"]), "fresh_semantics": len(matches),
              "fresh_child_commands": child_count,
              "historic_runs": len(history), "historic_steps": historic_steps,
              "historic_raw_step_logs": 2 * historic_steps, "declared_overwrites_bound": 6,
              "packager_model_per_handoff": "openai/gpt-6-sol",
              "packager_session": "ses_f13139bc5ffeFI41laN8mgF1PA",
              "packager_context": "continued after T03-B, not independent V02; owner confirmed",
              "process_matches": process_matches, "new_math_review": False, "new_replay": False,
              "limitations": ["six old child streams have equivalent bytes but unrecovered original-path provenance",
                              "old final HEAD unrecorded", "historical AuditTerms print truncated; supplemental final print sealed"]}
    (W / "INTAKE.json").write_text(json.dumps(record, indent=2) + "\n")
    (W / "STATE.before.md").write_bytes((REPO / "docs/onboarding/STATE.md").read_bytes())
    (W / "STATE.head.md").write_bytes(subprocess.check_output(["git", "show", "HEAD:docs/onboarding/STATE.md"], cwd=REPO))
    print(json.dumps(record, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        (W / "STOP_AND_REPORT.json").write_text(json.dumps({"error": repr(error),
            "frozen_sources_unchanged": True, "further_actions_stopped": True}, indent=2) + "\n")
        raise
