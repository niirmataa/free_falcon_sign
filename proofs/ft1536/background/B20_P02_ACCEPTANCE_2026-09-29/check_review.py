"""Bind received P02/V02 artifacts and recorded executions; never replay proofs."""
from datetime import datetime, timezone
import importlib.util
import json
import os
from pathlib import Path
import struct
import subprocess

W = Path(__file__).resolve().parent
REPO = W.parents[5]
ROOT = REPO / "proofs/ft1536"
A = ROOT / "work/FT1536_P02_FREEZE_CLOSURE_RUN_001/output"
V = ROOT / "work/B20_001/V02/output"
PINS = {
    "author_report": "ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5",
    "author_outputs": "af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e",
    "review_report": "30a82492d4e9b385ea2b3b3c991b984b2b8077d0e373b4ad8a9b38a6ace95e8d",
    "review_outputs": "792b5fb6c5b7dc42f1a4ffb7d02343f6d6a76f9c7f6921ce2ce1817a17836a6c",
    "source_head": "41216bb8d61004bb941a8d1b276f43346df11ce8",
}
spec = importlib.util.spec_from_file_location("archive", ROOT / "tools/archive.py")
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)


def load(path):
    return json.loads(archive.read(path))


def need(condition, message):
    if not condition:
        raise RuntimeError(message)


def main():
    author = archive.verify_bundle(A, "OUTPUTS.sha256", PINS["author_outputs"], "REPORT.md",
                                   PINS["author_report"], "RESULT.json")
    review = archive.verify_bundle(V, "REVIEW_OUTPUTS.sha256", PINS["review_outputs"], "REVIEW.md",
                                   PINS["review_report"], "REVIEW_RESULT.json")
    ar = archive.manifest(archive.read(A / "OUTPUTS.sha256"))
    vr = archive.manifest(archive.read(V / "REVIEW_OUTPUTS.sha256"))
    ai = archive.manifest(archive.read(A / "INPUTS.sha256"), absolute=True)
    vi = archive.manifest(archive.read(V / "INPUTS.sha256"), absolute=True)
    need(len(ar) == 30612 and len(vr) == 343 and len(vi) == 30633, "external member counts differ")
    need(archive.regular_files(A) == set(ar) | {"OUTPUTS.sha256"}, "author exact-set mismatch")
    need(archive.regular_files(V) == set(vr) | {"REVIEW_OUTPUTS.sha256"}, "review exact-set mismatch")
    for rel, digest in ai.items():
        need(ar.get(rel) == digest, "author input not sealed")
    for origin, digest in vi.items():
        path = Path(origin)
        need(path.is_absolute() and path.is_relative_to(ROOT), "unexpected input origin")
        archive.checked_bytes(path, digest)
    need(review["source_task"] == author["task_id"] == "B20_001_P02_WORD_FPEMU_REFINEMENT", "wrong author ID")
    need(review["review_id"] == "B20_001_V02_WORD_FPEMU_REFINEMENT", "wrong review ID")
    need(review["source_report_sha256"] == PINS["author_report"] and
         review["source_outputs_sha256"] == PINS["author_outputs"], "wrong subject pins")
    need(review["source_head"] == author["new_package_head"] == PINS["source_head"], "wrong source HEAD")
    need(author["status"] == review["source_status"] == "PARTIAL_PROOF" and
         review["verdict"] == "PASS_SCOPED_REVIEW", "unexpected verdict/scope")
    need(review["jobs_complete"] is True and review["owner_accepted"] is False, "job/acceptance flag differs")
    need(review["reviewer_model"] != review["author_proof_model"], "same model as mathematical author")
    need(review["same_model_as_packager"] and review["separate_session_and_context_from_packager"],
         "disclosed independence limitation differs")
    need(review["reviewer_session"] != "ses_f13139bc5ffeFI41laN8mgF1PA", "same packaging session")

    receipt = load(V / "evidence/replay/receipt.json")
    checks = load(V / "REPLAY_CHECKS.json")
    need(receipt["exit_code"] == 0 and len(receipt["steps"]) == 43, "replay outcome differs")
    need(receipt["source_before"] == receipt["source_after"], "replay sources changed")
    for rel, digest in receipt["source_before"].items():
        need(ar.get("formal/" + rel) == digest, f"replay-source mismatch: {rel}")
    child_count = 0
    for step in receipt["steps"]:
        need(step["exit_code"] == 0 and step["clean"] is True, "replay step failed/unclean")
        for kind in ("stdout", "stderr"):
            need(vr.get("evidence/replay/" + step[kind]) == step[kind + "_sha256"], "replay log mismatch")
        if "child_receipt_snapshot" in step:
            cp = V / "evidence/replay" / step["child_receipt_snapshot"]
            rows = load(cp)
            need(len(rows) == step["child_commands_snapshotted"], "child count mismatch")
            for row in rows:
                for kind in ("stdout", "stderr"):
                    rel = str((cp.parent / (row["name"] + "." + kind)).relative_to(V))
                    need(vr.get(rel) == row[kind + "_sha256"], "child log mismatch")
                child_count += 1
    need(child_count == 45, "expected 45 recorded child commands")
    plan = {r["path"]: r for r in load(A / "SEMANTIC_FILES.json")["matches"]}
    matches = checks["audit"]["semantic_matches"]
    need(len(matches) == 16 and {r["path"] for r in matches} == set(plan), "semantic exact-set differs")
    for row in matches:
        baseline = plan[row["path"]]
        step = receipt["steps"][row["actual_producer_step"]]
        # The sealed reviewer packager flattens selected build products into
        # evidence/replay/semantic/, while raw step logs stay under logs/.
        rel = ("semantic/" + Path(row["path"]).name) if row["path"].startswith("build/") else step["stdout"]
        need(vr.get("evidence/replay/" + rel) == row["sha256"] == baseline["sha256"] == ar.get(baseline["baseline"]),
             "semantic byte binding mismatch")

    own = load(V / "evidence/own_final/receipt.json")
    own_index = load(V / "EXECUTION_RECEIPTS.json")
    need(own["result"] == "PASS" and len(own["steps"]) == 10, "own controls outcome differs")
    need(own["source_before"] == own["source_after"] == own_index["source_before"] == own_index["source_after"],
         "own source maps differ")
    for rel, digest in own["source_before"].items():
        need(vr.get("sources/" + rel) == digest, "own final source mismatch")
    for step in own["steps"]:
        need(step["exit_code"] == step["expected_exit"] and not step["timed_out"], "own unexpected exit")
        for kind in ("stdout", "stderr"):
            need(vr.get("evidence/own_final/" + step[kind]) == step[kind + "_sha256"], "own raw log mismatch")
    for rel, digest in own["products"].items():
        if Path(rel).suffix == ".olean":
            continue  # Rebuilt binary explicitly outside the frozen text bundle.
        key = "evidence/own_final/" + rel
        need(vr.get(key) == digest, "own product mismatch")
    sage = load(V / "SAGE_RUNS.json")
    for row in sage["runs"]:
        if "preserved" in row:
            candidates = {path: digest for path, digest in vr.items() if path.startswith(row["preserved"] + "/")}
            for field in ("source_sha256", "stdout_sha256", "stderr_sha256"):
                need(row[field] in candidates.values(), f"failed Sage binding missing: {row['id']}/{field}")
        else:
            need(row["source_sha256"] == own["source_before"]["check_words.sage"], "final Sage source differs")

    paths = {"proofs/ft1536/batches/B20_001/STATUS.json", "docs/onboarding/COORDINATOR_LOG.md"}
    for ident, rows, inputs, mf in (("B20_001_P02_FINAL_001", ar, ai, "OUTPUTS.sha256"),
                                  ("B20_001_V02_FINAL_001", vr, vi, "REVIEW_OUTPUTS.sha256")):
        paths.add(f"proofs/ft1536/catalog/{ident}.json")
        paths.add(f"proofs/ft1536/stages/{ident}/{mf}")
        paths.update(f"proofs/ft1536/stages/{ident}/{rel}" for rel in rows)
        paths.update(f"proofs/ft1536/objects/{digest}" for digest in inputs.values())
    path_bytes = sum(len(p.encode()) + 1 for p in paths)
    env_bytes = sum(len(k.encode()) + len(v.encode()) + 2 for k, v in os.environ.items())
    pointers = struct.calcsize("P") * (len(paths) + len(os.environ) + 16)
    process_matches = []
    watched = (str(A.parent), str(V.parent))
    for p in Path("/proc").iterdir():
        if not p.name.isdigit() or int(p.name) in (os.getpid(), os.getppid()):
            continue
        try:
            cwd = str((p / "cwd").resolve())
            raw = (p / "cmdline").read_bytes()
            if cwd.startswith(watched) or any(root.encode() in raw for root in watched):
                process_matches.append({"pid": int(p.name), "comm": (p / "comm").read_text().strip(), "cwd": cwd})
        except (OSError, RuntimeError):
            pass
    record = {"utc": datetime.now(timezone.utc).isoformat(), "status": "PIN_RECEIPT_BINDING_PASS",
              "pins": PINS, "author_outputs": len(ar), "author_inputs": len(ai),
              "review_outputs": len(vr), "review_inputs": len(vi),
              "review_output_bytes": sum((V / rel).stat().st_size for rel in vr),
              "replay_steps": 43, "replay_semantic_matches": 16, "replay_child_commands": child_count,
              "replay_source_bindings": len(receipt["source_before"]),
              "own_controls_steps_with_expected_exits": 10, "own_controls_cases_reported": 1437,
              "own_source_bindings": own["source_before"], "sage_run_bindings": len(sage["runs"]),
              "reviewer_model": review["reviewer_model"], "reviewer_session": review["reviewer_session"],
              "independence_from_math_author": True, "same_model_as_packager": True,
              "fresh_separate_context_from_packager": True,
              "accepted_scope_candidate": review["verdict_scope"], "process_matches": process_matches,
              "checkpoint_arg_preflight": {"paths": len(paths), "path_bytes": path_bytes,
                  "environment_bytes": env_bytes, "pointer_bytes": pointers,
                  "default_arg_max": os.sysconf("SC_ARG_MAX"),
                  "planned_archive_stack_bytes": 33554432, "observed_arg_max_with_planned_stack": 6291456},
              "coordinator_math_review_repeated": False, "coordinator_replay_run": False}
    (W / "INTAKE.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
    (W / "STATE.before.md").write_bytes((REPO / "docs/onboarding/STATE.md").read_bytes())
    (W / "STATE.head.md").write_bytes(subprocess.check_output(["git", "show", "HEAD:docs/onboarding/STATE.md"], cwd=REPO))
    print(json.dumps({key: value for key, value in record.items() if key not in ("accepted_scope_candidate", "pins")}, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        (W / "STOP_AND_REPORT.json").write_text(json.dumps({"error": repr(error),
            "frozen_sources_unchanged": True, "further_actions_stopped": True}, indent=2) + "\n")
        raise
